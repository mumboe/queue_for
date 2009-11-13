require 'test_helper'

class QueueForTest < ActiveSupport::TestCase
  include ActionView::Helpers::CaptureHelper

  test "you can add content to a queue" do
    queue_for :name => :test_queue, :content => "test_content"

    assert instance_variable_get("@content_for_test_queue") 
    assert instance_variable_get("@content_for_test_queue").class == ContentQueue 
  end
  test "content to a queue obeys ordering rules" do
    queue_for :name => :test_queue, :content => "test_content_1"
    queue_for :name => :test_queue, :content => "test_content_2"
    queue_for :name => :test_queue, :content => "test_content_3", :index => 10

    assert_equal "test_content_3test_content_1test_content_2", 
      instance_variable_get("@content_for_test_queue").to_s 
  end
  test "that queue_for barfs on an existing content_for variable" do
    content_for :test_queue, "content_for"
    assert_raise(ActionView::Helpers::CaptureHelper::QueueForError) {
      queue_for :name => :test_queue, :content =>"queue_for"
    }
  end
end
