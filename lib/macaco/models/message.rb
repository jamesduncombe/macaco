module Macaco
  class Message

    def initialize(*args, &block)
      @body_html = nil
      @body_text = nil
      @text      = nil
      @to        = []
      @from      = nil
      @subject   = nil

      if args.first.is_a? Hash
        hash_attributes(args.first)
      end

      if block_given?
        instance_eval(&block)
      end

      self
    end

    def hash_attributes(args)
      to      args[:to]
      from    args[:from]
      subject args[:subject]
      body_html args[:body_html]
      body_text args[:body_text]
    end
    
    def to(val = nil)
      return @to unless val
      @to << { email: val }
    end

    def from(val = nil)
      return @from unless val
      @from ||= val
    end

    def subject(val = nil)
      return @subject unless val
      @subject ||= val
    end

    def body_html(val = nil)
      return @body_html unless val
      @body_html ||= val
    end
    alias_method :html, :body_html

    def body_text(val = nil)
      return @body_text unless val
      @body_text ||= val
    end
    alias_method :text, :body_text

    # reflections

    def to_mandrill_hash
      {
        message: {
          from_email:  @from,
          to:          @to,
          subject:     @subject,
          html:        @body_html,
          text:        @body_text
        }
      }
    end

    def to_json
      to_mandrill_hash.to_json
    end
  end
end
