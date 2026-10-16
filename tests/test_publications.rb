require 'minitest/autorun'
require 'liquid'
require 'csv'
require_relative 'liquid_branch_coverage'

PUBLICATIONS_COVERAGE = LiquidBranchCoverage::Collector.new

Minitest.after_run do
  PUBLICATIONS_COVERAGE.write_reports(File.expand_path('../coverage', __dir__))
end

class PublicationsTemplateTest < Minitest::Test
  def setup
    fixture_path = File.expand_path('fixtures/citations.csv', __dir__)
    @citations = CSV.read(fixture_path, headers: true).map(&:to_h)
    template_path = File.expand_path('../_includes/publications', __dir__)
    @template = Liquid::Template.parse(File.read(template_path), line_numbers: true)
    PUBLICATIONS_COVERAGE.instrument(@template)
  end

  def render(include_options = {}, citations = @citations)
    @template.render(
      'site' => { 'data' => { 'citations' => citations } },
      'include' => include_options
    )
  end

  def titles_in(result)
    result.scan(/Test (?:Conference|Journal) Paper/)
  end

  def test_exact_venue_does_not_return_other_venues
    result = render('venue' => 'Design Conference; Design Studies')
    assert_equal 2, titles_in(result).length
    result = render('venue' => 'Design Studies')
    assert_equal ['Test Journal Paper'], titles_in(result)
  end

  def test_exact_venue_and_exclusion_are_combined
    assert_empty titles_in(render('venue' => 'Design Studies', 'venue_exclude' => 'Design Studies'))
    assert_equal ['Test Journal Paper'], titles_in(render('venue' => 'Design Studies', 'venue_exclude' => 'Design Conference'))
  end

  def test_venue_search_exclude
    result = render('venue_search' => 'design', 'venue_search_exclude' => 'conference').downcase
    assert_includes result, 'design studies'
    refute_includes result, 'design conference'
  end

  def test_search_filters_can_reject_every_row
    assert_empty titles_in(render('title_search' => 'not present'))
    assert_empty titles_in(render('venue_search' => 'not present'))
  end

  def test_filters_combine_and_limit_applies_after_filtering
    result = render('author' => 'doe', 'year' => '2021', 'title_search' => 'journal', 'limit' => 1)
    assert_equal ['Test Journal Paper'], titles_in(result)
    assert_empty titles_in(render('author' => 'missing', 'year' => '2021'))
  end

  def test_escapes_csv_text_and_rejects_unsafe_doi_url
    citation = {
      'Authors' => 'Doe, Jane; ',
      'Title' => '<script>alert(1)</script>',
      'Publication' => '<b>Journal</b>',
      'Year' => '2026',
      'DOI' => 'javascript:alert(1)'
    }
    result = render({ 'link' => true }, [citation])
    assert_includes result, '&lt;script&gt;alert(1)&lt;/script&gt;'
    assert_includes result, '&lt;b&gt;Journal&lt;/b&gt;'
    assert_includes result, 'https://scholar.google.com/scholar?q='
    refute_includes result, '<script>'
    refute_includes result, 'href="javascript:'
  end

  def test_prefers_doi_and_handles_sparse_rows
    rows = [
      { 'Authors' => 'Doe, Jane', 'Title' => 'DOI paper', 'Publication' => 'Journal', 'Year' => '2026', 'DOI' => '10.1234/example' },
      { 'Authors' => 'Smith, John', 'Title' => 'DOI URL paper', 'Publication' => 'Journal', 'Year' => '2026', 'DOI' => 'https://doi.org/10.5678/example' },
      { 'Title' => 'Sparse paper', 'Year' => '2025' }
    ]
    result = render({ 'link' => true }, rows)
    assert_includes result, 'href="https://doi.org/10.1234/example"'
    assert_includes result, 'href="https://doi.org/10.5678/example"'
    assert_includes result, 'Sparse paper'
    assert_equal 3, result.scan('<li>').length
  end

  def test_google_scholar_csv_with_bom_in_authors_header
    row = { "\uFEFFAuthors" => 'Lovelace, Ada; ', 'Title' => 'BOM paper', 'Publication' => 'Journal', 'Year' => '2026' }
    result = render({ 'author' => 'Lovelace' }, [row])
    assert_includes result, 'BOM paper'
    assert_includes result, 'Lovelace'
  end

  def test_all_styles_render_and_unknown_style_uses_apa
    %w[apa mla chicago harvard vancouver unknown].each do |style|
      result = render('style' => style, 'limit' => 1)
      assert_equal 1, result.scan('<li>').length, style
      assert_includes result, 'Test Journal Paper', style
    end
  end

  def test_all_styles_handle_a_row_without_authors
    row = { 'Title' => 'Anonymous paper', 'Publication' => 'Journal', 'Year' => '2026' }
    %w[apa mla chicago harvard vancouver].each do |style|
      result = render({ 'style' => style }, [row])
      assert_includes result, 'Anonymous paper', style
      assert_equal 1, result.scan('<li>').length, style
    end
  end

  def test_empty_csv_and_limit_larger_than_matches
    assert_equal 0, render({}, []).scan('<li>').length
    assert_equal 2, render('limit' => 10).scan('<li>').length
  end

  def test_compact_output_uses_title_year_and_venue
    result = render('compact' => true, 'link' => true, 'limit' => 1)
    assert_match(/<li>\s*<a href="https:\/\/scholar\.google\.com\/scholar\?q=/, result)
    assert_match(/Test Journal Paper<\/a> \(2021\)\. <em>Design Studies<\/em>\./, result)
    refute_includes result, 'Doe, J.'
  end

  def test_compact_output_handles_missing_fields_and_escapes_text
    row = { 'Title' => '<Example>', 'Year' => '2026', 'Publication' => '<Venue>' }
    result = render({ 'compact' => true }, [row])
    assert_match(/&lt;Example&gt; \(2026\)\. <em>&lt;Venue&gt;<\/em>\./, result)
    refute_includes result, '<Example>'
    refute_includes result, '<Venue>'
    assert_includes render({}, [row]), '(2026)'
    assert_match(/Empty fields\.\s*<\/li>/m, render({ 'compact' => true }, [{ 'Title' => 'Empty fields' }]))
  end

  def test_branch_collector_preserves_output_and_counts_both_paths
    collector = LiquidBranchCoverage::Collector.new
    template = collector.instrument(Liquid::Template.parse(
      '{% if show %}{% for item in items %}{{ item }}{% endfor %}{% endif %}',
      line_numbers: true
    ))
    assert_equal 'ab', template.render('show' => true, 'items' => %w[a b])
    assert_equal '', template.render('show' => true, 'items' => [])
    assert_equal '', template.render('show' => false, 'items' => %w[a b])
    assert_equal 4, collector.total_count
    assert_equal 4, collector.covered_count
  end
end
