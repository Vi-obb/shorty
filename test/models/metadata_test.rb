require "test_helper"

class MetadataTest < ActiveSupport::TestCase
  test "title attribute" do
    assert_equal "Hello", Metadata.new("<title>Hello</title>").title
  end
  test "missing title attribute" do
    assert_nil Metadata.new.title
  end
  test "meta description" do
    assert_equal "Hello", Metadata.new("<meta property='og:description' content='Hello'>").description
  end
  test "missing meta description" do
    assert_nil Metadata.new.description
  end
  test "og:image" do
    assert_equal "https://example.org/og.png", Metadata.new("<meta property='og:image' content='https://example.org/og.png'>").image
  end
  test "missing og:image" do
    assert_nil Metadata.new.image
  end
end
