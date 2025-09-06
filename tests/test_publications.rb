require 'minitest/autorun'
require 'liquid'
require 'csv'

class PublicationsTemplateTest < Minitest::Test
  def setup
    fixture_path = File.expand_path('fixtures/citations.csv', __dir__)
    @citations = CSV.read(fixture_path, headers: true).map(&:to_h)
    template_path = File.expand_path('../_includes/publications', __dir__)
    @template = Liquid::Template.parse(File.read(template_path))
  end

  def test_venue_search_exclude
    context = {
      'site' => { 'data' => { 'citations' => @citations } },
      'include' => { 'venue_search' => 'design', 'venue_search_exclude' => 'conference' }
    }
    result = @template.render(context).downcase
    assert_includes result, 'design studies'
    refute_includes result, 'design conference'
  end
end
