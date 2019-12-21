require 'test/unit'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'bin'))
require 'md2spec'

class TestSpecTree < Test::Unit::TestCase
  def test_describe
    st = SpecTree.new
    st.add("- d: hoge")

    assert_equal "describe 'hoge' do\nend", st.to_spec
  end

  def test_2level_describe
    st = SpecTree.new
    st.add("- d: hoge")
    st.add("    - d: fuga")

    expect = [
      "describe 'hoge' do",
      "  describe 'fuga' do",
      "  end",
      "end"
    ].join("\n")
    assert_equal expect, st.to_spec
  end

  def test_describe_context
    st = SpecTree.new
    st.add("- d: hoge")
    st.add("    - c: fuga")

    expect = [
      "describe 'hoge' do",
      "  context 'fuga' do",
      "  end",
      "end"
    ].join("\n")
    assert_equal expect, st.to_spec
  end

  def test_describe_context_it
    st = SpecTree.new
    st.add("- d: hoge")
    st.add("    - c: fuga")
    st.add("        - i: this is it")

    expect = [
      "describe 'hoge' do",
      "  context 'fuga' do",
      "    xit 'this is it' do",
      "    end",
      "  end",
      "end"
    ].join("\n")
    assert_equal expect, st.to_spec
  end

  def test_describe_context_it_comment
    st = SpecTree.new
    st.add("- d: hoge")
    st.add("    - c: fuga")
    st.add("        - i: this is it")
    st.add("            - this is comment1")
    st.add("            - this is comment2")

    expect = [
      "describe 'hoge' do",
      "  context 'fuga' do",
      "    xit 'this is it' do",
      "      # this is comment1",
      "      # this is comment2",
      "    end",
      "  end",
      "end"
    ].join("\n")
    assert_equal expect, st.to_spec
  end

  def test_multiple_its
    st = SpecTree.new
    st.add("- d: hoge")
    st.add("    - c: fuga")
    st.add("        - i: this is it")
    st.add("            - this is comment1")
    st.add("            - this is comment2")
    st.add("        - i: this is it2")
    st.add("            - this is comment3")
    st.add("            - this is comment4")

    expect = [
      "describe 'hoge' do",
      "  context 'fuga' do",
      "    xit 'this is it' do",
      "      # this is comment1",
      "      # this is comment2",
      "    end",
      "    xit 'this is it2' do",
      "      # this is comment3",
      "      # this is comment4",
      "    end",
      "  end",
      "end"
    ].join("\n")
    assert_equal expect, st.to_spec
  end

  def test_multiple_contexts
    st = SpecTree.new
    st.add("- d: hoge")
    st.add("    - c: fuga")
    st.add("        - i: this is it")
    st.add("            - this is comment1")
    st.add("            - this is comment2")
    st.add("    - c: fuga2")
    st.add("        - i: this is it2")
    st.add("            - this is comment1")

    expect = [
      "describe 'hoge' do",
      "  context 'fuga' do",
      "    xit 'this is it' do",
      "      # this is comment1",
      "      # this is comment2",
      "    end",
      "  end",
      "  context 'fuga2' do",
      "    xit 'this is it2' do",
      "      # this is comment1",
      "    end",
      "  end",
      "end"
    ].join("\n")
    assert_equal expect, st.to_spec
  end

  def test_feature_scenario
    st = SpecTree.new
    st.add("- f: hoge")
    st.add("    - c: fuga")
    st.add("        - s: this is scenario")
    st.add("            - this is comment1")
    st.add("            - this is comment2")
    st.add("    - c: fuga2")
    st.add("        - s: this is scenario2")
    st.add("            - this is comment1")

    expect = [
      "feature 'hoge', type: :feature do",
      "  context 'fuga' do",
      "    xscenario 'this is scenario' do",
      "      # this is comment1",
      "      # this is comment2",
      "    end",
      "  end",
      "  context 'fuga2' do",
      "    xscenario 'this is scenario2' do",
      "      # this is comment1",
      "    end",
      "  end",
      "end"
    ].join("\n")
    assert_equal expect, st.to_spec
  end
end
