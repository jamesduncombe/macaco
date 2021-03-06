module Macaco
  class Sender

    def initialize(*args, &block)
      @body_html = nil
      @body_text = nil
      @text      = nil
      @to        = []
      @from      = nil
      @subject   = nil
      @attachment = []

      if args.first.is_a? Hash
        hash_attributes(args.first)
      end

      if block_given?
        instance_eval(&block)
      end

      self
    end

    def hash_attributes(args)
      to        args[:to]
      from      args[:from]
      subject   args[:subject]
      body_html args[:body_html]
      body_text args[:body_text]
      attachment args[:attachment]
    end

    def send
      Macaco::Api.post({
        api_root: api_root,
        request:  request
      })
    end

    def to(*val)
      return @to if val.flatten.compact.empty?
      @to += val.flat_map { |t| t }
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

    def attachment(*val)
    end

    def headers
      {
        "Content-Type" => "application/x-www-form-urlencoded"
      }
    end

    def convert_data_params(_)
    end

    # helpers - could be split out?

    def fetch_email(val)
      val.fetch(:email) { raise KeyError, 'Please pass an email address (using key: :email)' }
    end

    def file_handler(f)
      return f if f.respond_to? :read
      File.open(File.expand_path(f), 'r')
    rescue Errno::ENOENT
      raise ArgumentError, "Macaco: Can't open file: #{f}"
    end

    def to_curl
      Macaco::Curlable.new(
        headers: headers,
        api_root: api_root,
        api_path: api_path,
        data: data,
        content_type: content_type
      ).to_curl
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      {}
    end

    def data
      to_hash
    end

    def api_path; end
    def api_root; end
    def content_type; end

    def api_key
      return Macaco.config.api_key unless Macaco.config.api_key.nil?
      raise ArgumentError, 'Please set config.api_key for Macaco'
    end
  end
end
