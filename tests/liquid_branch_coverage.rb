require 'json'
require 'set'
require 'liquid'

# Instruments the parsed Liquid template without changing the published include.
# A branch is each path through an if/unless (including an implicit else) or
# each nonempty/empty path through a for loop. This is not Ruby line coverage.
module LiquidBranchCoverage
  class Marker
    def initialize(id, collector)
      @id = id
      @collector = collector
    end

    def render(_context)
      @collector.hit(@id)
      ''
    end
  end

  class Collector
    attr_reader :branches, :hits

    def initialize
      @branches = {}
      @hits = Set.new
    end

    def instrument(template)
      @line_counts = Hash.new(0)
      walk(template.root)
      template
    end

    def hit(id)
      @hits.add(id)
    end

    def covered_count
      @hits.length
    end

    def total_count
      @branches.length
    end

    def percent
      return 0 if total_count.zero?

      (covered_count * 100.0 / total_count).floor
    end

    def write_reports(directory)
      raise 'No Liquid branches found' if total_count.zero?

      Dir.mkdir(directory) unless Dir.exist?(directory)
      details = {
        metric: 'Liquid conditional and loop branch coverage',
        covered: covered_count,
        total: total_count,
        percent: percent,
        branches: @branches.values.sort_by { |branch| branch[:id] }.map do |branch|
          branch.merge(covered: @hits.include?(branch[:id]))
        end
      }
      badge = {
        schemaVersion: 1,
        label: 'Liquid branches',
        message: "#{percent}%",
        color: percent >= 90 ? 'brightgreen' : percent >= 75 ? 'yellow' : 'red'
      }
      File.write(File.join(directory, 'liquid-branches.json'), JSON.pretty_generate(details) + "\n")
      File.write(File.join(directory, 'liquid-branches-badge.json'), JSON.pretty_generate(badge) + "\n")
      puts "Liquid branch coverage: #{covered_count}/#{total_count} (#{percent}%)"
      uncovered = details[:branches].reject { |branch| branch[:covered] }
      uncovered.each { |branch| puts "  uncovered: #{branch[:id]}" }
    end

    private

    def walk(body)
      body.nodelist.each do |node|
        case node
        when Liquid::Unless, Liquid::If
          instrument_conditional(node)
        when Liquid::For
          instrument_loop(node)
        when Liquid::Case
          raise 'Add coverage instrumentation for Liquid case tags before using them'
        when Liquid::Block
          nested_body = node.instance_variable_get(:@body)
          walk(nested_body) if nested_body
        end
      end
    end

    def node_id(node)
      line = node.line_number
      @line_counts[line] += 1
      "#{node.tag_name}@L#{line}##{@line_counts[line]}"
    end

    def register(body, id, line, path)
      branch = { id: id, line: line, path: path }
      if @branches.key?(id) && @branches[id] != branch
        raise "Conflicting Liquid branch: #{id}"
      end
      @branches[id] = branch
      body.nodelist.unshift(Marker.new(id, self))
      walk(body)
    end

    def instrument_conditional(node)
      id = node_id(node)
      unless node.blocks.any?(&:else?)
        fallback = Liquid::ElseCondition.new
        fallback.attach(Liquid::BlockBody.new)
        node.blocks << fallback
      end
      node.blocks.each_with_index do |block, index|
        path = block.else? ? 'else' : index.zero? ? node.tag_name : "elsif-#{index}"
        register(block.attachment, "#{id}/#{path}", node.line_number, path)
      end
    end

    def instrument_loop(node)
      id = node_id(node)
      body = node.instance_variable_get(:@for_block)
      empty = node.instance_variable_get(:@else_block)
      unless empty
        empty = Liquid::BlockBody.new
        node.instance_variable_set(:@else_block, empty)
      end
      register(body, "#{id}/nonempty", node.line_number, 'nonempty')
      register(empty, "#{id}/empty", node.line_number, 'empty')
    end
  end
end
