# Ducklink #

Ducklink is a super-simple way of centrally managing the format of URLs which should be used for links to other sites. Quack.

## Why ##

* Maybe you have an affiliate deal with a site which requires redirecting through a third-party platform
* Maybe you need to add parameters to URLs for campaign management
* Er..
* Hmm.

## How ##

Given a URL, Ducklink will extract the host and try to match against one of its configured formats.

If nothing matches, the URL is returned untouched. If a match is found, then the URL returned will be based on the format together with any run-time parameters you passed in.

### Add parameters ###

```ruby
	Ducklink::Decorator.configure do
		host 'www.example.com' do
			template '{{url}}?extra=params&added=here'
		end
	end

	Ducklink.decorate 'http://www.example.com/some/path'
	=> "http://www.example.com/some/path?extra=params&added=here"
```

### Redirects ###

```ruby
	Ducklink::Decorator.configure do
		host 'www.example.com' do
			template 'http://affiliate.example.com?clickref=42&url={{url}}'
		end
	end
	
	Ducklink.decorate 'http://www.example.com/some/path'
	=> "http://affiliate.example.com?clickref=42&url=http://www.example.com/some/path"
```
	
If you need to, you can URLEncode the target URL explicitly:

```ruby
	Ducklink::Decorator.configure do
		host 'www.example.com' do
			template 'http://affiliate.example.com?clickref=42&url={{url}}'
			set :url, CGI::escape(self[:url])
		end
	end
	
	Ducklink.decorate 'http://www.example.com/some/path'
	=> "http://affiliate.example.com?clickref=42&url=http%3A%2F%2Fwww.example.com%2Fsome%2Fpath"
```
	
### Run-time parameters ###

```ruby
	Ducklink::Decorator.configure do
		host 'www.example.com' do |context|
			template 'http://affiliate.example.com?clickref={{reference}}&url={{url}}'
			set :reference, context[:reference]
		end
	end
	
	Ducklink.decorate 'http://www.example.com/some/path', :reference => 100
	=> "http://affiliate.example.com?clickref=100&url=http://www.example.com/some/path"
```	

### Specify template in groups ###

```ruby
	Ducklink::Decorator.configure do
		group do
			template 'http://affiliate.example.com?clickref={{reference}}&url={{url}}#campaign={{campaign}}'
			host 'buy.example.com', 'shop.example.com' do |context|
				set :campaign, 'campaign1'
				set :reference, context[:reference]
			end
			host 'another.com' do |context|
				set :campaign, 'campaign2'
				set :reference, context[:reference]
			end
		end
	end
	
	Ducklink.decorate 'http://shop.example.com/goodies', :reference => 100
	=> "http://affiliate.example.com?clickref=100&url=http://shop.example.com/goodies#campaign=campaign1"
```

## TODO ##

1. Tests!
2. URL validity checks
3. Merge parameters if url already has them
4. Intelligently URL encode parameters
5. Support introspection of keys expected in context so calling code knows what to provide

## Licence ##

Ducklink is released under the MIT Licence.

Copyright © 2011 Henry Garner
