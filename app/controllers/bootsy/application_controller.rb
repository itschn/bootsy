module Bootsy
  class ApplicationController < Bootsy.base_controller
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    
    def mimetype_icon_css_class(mimetype)
      return unless mimetype
    
      case mimetype.split('/').first
        when 'image' then 'fa fa-file-image-o'
        when 'pdf' then 'fa fa-file-pdf-o'
        when 'zip', 'rar' then 'fa fa-file-archive-o'
        when 'application' then mimetype_icon_css_class(mimetype.split('/').last)
        when 'video' then 'fa fa-file-video-o'
      end
    end
  end
end
