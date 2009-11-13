class ContentQueue
  def initialize(*args,&block)
    @index = 0
    @li = []
  end

  def []=(key,value)
    @li << [key,value]
  end

  def next_key
    @index -= 1
    @index
  end

  def to_s
    @li.sort!.reverse!.map do |kv|
      key,value = kv 
      value.to_s
    end.join('')
  end
end

