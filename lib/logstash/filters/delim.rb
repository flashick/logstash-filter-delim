# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"


class LogStash::Filters::Delim < LogStash::Filters::Base

  config_name "delim"

  # Source field for processing
  config :source, :validate => :string, :default => "message"

  # Target field for saved results. If it isn't set results would be save into root
  config :target, :validate => :string

  # delimiter for split
  config :delimiter, :validate => :string

  # fields list
  config :fields, :validate => :array


  public
  def register
    # Add instance variables
  end # def register

  public
  def filter(event)

    if @source
      str = event.get(@source)
      if @delimiter
        split_str = str.split(@delimiter, @fields.length)

        if @target && @fields
          result = {}
          split_str.each_with_index do |f, i|
            result[@fields[i]] = f
          end
          event.set(@target, result)
        else
          split_str.each_with_index do |f, i|
            event.set(@fields[i], f)
          end
        end
      end
    end


    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Delim
