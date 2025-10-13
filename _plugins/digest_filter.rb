require 'digest'

module Jekyll
  module DigestFilter
    def digest(input, algorithm = 'MD5')
      case algorithm.upcase
      when 'MD5'
        Digest::MD5.hexdigest(input)
      when 'SHA1'
        Digest::SHA1.hexdigest(input)
      when 'SHA256'
        Digest::SHA256.hexdigest(input)
      else
        raise "Unknown digest algorithm: #{algorithm}"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::DigestFilter)

# --- Give the "Random Stuff" page a daily hashed permalink
Jekyll::Hooks.register :pages, :pre_render do |page, payload|
  # match either by title (case-insensitive) or filename containing 'random'
  if page.data['title']&.downcase == 'random stuff' || page.path.include?('random')
    today = Time.now.utc.strftime('%Y-%m-%d')
    hash  = Digest::MD5.hexdigest(today)[0,8]
    page.data['permalink'] = "/random-#{hash}/"
    Jekyll.logger.info "✨ Random Stuff permalink set to:", page.data['permalink']
  end
end
