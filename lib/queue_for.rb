module ActionView::Helpers::CaptureHelper
  class QueueForError < StandardError; end
  def queue_for(kv, &block)
    raise "needs :name" if not kv.key? :name

    # open or create queue
    queue = instance_variable_get("@content_for_#{kv[:name]}") || ContentQueue.new 
    raise QueueForError, "queue.class is '#{queue.class.to_s}' not 'ContentQueue' (content_for and queue_for are probably being mixed)" unless queue.class == ContentQueue


    # capture or require content
    if block_given?
      new_content_for = capture(&block)
    else
      raise "need :content if no block is given" if not kv.key? :content
      new_content_for = kv[:content].to_s
    end

    # add to queue
    index = kv[:index] || queue.next_key
    queue[index] = new_content_for 

    # return to an instance variable the :yield can see
    instance_variable_set("@content_for_#{kv[:name]}", queue)
  end
end
