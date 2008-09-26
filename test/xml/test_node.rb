require File.expand_path(File.join(File.dirname(__FILE__), '..', "helper"))

module Nokogiri
  module XML
    class TestNode < Nokogiri::TestCase
      def test_find_by_css
        html = Nokogiri::HTML.parse(File.read(HTML_FILE), HTML_FILE)
        found = html.find_by_css('div > a')
        assert_equal 3, found.length
      end

      def test_next_sibling
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert node = xml.root
        assert sibling = node.child.next_sibling
        assert_equal('employee', sibling.name)
      end

      def test_previous_sibling
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert node = xml.root
        assert sibling = node.child.next_sibling
        assert_equal('employee', sibling.name)
        assert_equal(sibling.previous_sibling, node.child)
      end

      def test_name=
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert node = xml.root
        node.name = 'awesome'
        assert_equal('awesome', node.name)
      end

      def test_child
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert node = xml.root
        assert child = node.child
        assert_equal('text', child.name)
      end

      def test_key?
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert node = xml.search('//address').first
        assert(!node.key?('asdfasdf'))
      end

      def test_set_property
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert node = xml.search('//address').first
        node['foo'] = 'bar'
        assert_equal('bar', node['foo'])
      end

      def test_attributes
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert node = xml.search('//address').first
        assert_nil(node['asdfasdfasdf'])
        assert_equal('Yes', node['domestic'])

        assert node = xml.search('//address')[2]
        attr = node.attributes
        assert_equal 2, attr.size
        assert_equal 'Yes', attr['domestic']
        assert_equal 'No', attr['street']
      end

      def test_path
        xml = Nokogiri::XML.parse(File.read(XML_FILE), XML_FILE)
        assert set = xml.search('//employee')
        assert node = set.first
        assert_equal('/staff/employee[1]', node.path)
      end

      def test_new_node
        node = Nokogiri::XML::Node.new('form')
        assert_equal('form', node.name)
        assert_nil(node.document)
      end

      def test_content
        node = Nokogiri::XML::Node.new('form')
        assert_equal('', node.content)

        node.content = 'hello world!'
        assert_equal('hello world!', node.content)
      end

      def test_replace
        xml = Nokogiri::XML.parse(File.read(XML_FILE))
        set = xml.search('//employee')
        assert 5, set.length
        assert 0, xml.search('//form').length

        first = set[0]
        second = set[1]

        node = Nokogiri::XML::Node.new('form')
        first.replace(node)

        assert set = xml.search('//employee')
        assert_equal 4, set.length
        assert 1, xml.search('//form').length

        assert_equal set[0].to_xml, second.to_xml
      end

    end
  end
end
