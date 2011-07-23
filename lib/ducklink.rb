require "ducklink/version"
require 'uri'
require 'cgi'

module Ducklink
  def self.decorate(url, context = {})
    Decorator.decorate(url, context)
  end
  
  class Decorator
    class << self
      @@hosts = {}
      
      def configure(&block)
        Params.new.instance_exec &block
      end
      
      def hosts
        @@hosts
      end
      
      def host(domain, params, &block)
        @@hosts[domain] = [params, block]
      end
      
      def decorate(url, context = {})
        params, block = hosts[URI.parse(url).host] rescue nil
        return url unless params
        
        params.set :url, url
        params.instance_exec context, &block
        
        params.template.scan(/\{\{([a-z_]+?)\}\}/i).inject(params.template) do |result, matches|
          params[matches.first] ? result.gsub("{{#{matches.first}}}", params[matches.first]) : result
        end
      end
    end
  end
  
  class Params
    attr_reader :settings
    
    def initialize(settings = {})
      @settings = settings
    end
    
    def set(key, value)
      settings[key.to_s] = value.to_s
    end
    
    def [](key)
      settings[key.to_s]
    end
    
    def template(template = nil)
      template ? set(:template, template) : self[:template]
    end
    
    def group(&block)
      Params.new(settings.clone).instance_exec &block
    end
    
    def host(*domains, &block)
      domains.each do |domain|
        Ducklink::Decorator.host domain, Params.new(settings.clone), &block
      end
    end
  end
end
