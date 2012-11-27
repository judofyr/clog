require 'pygments'

class Clog::App
  class MainController < Zoidberg::Controller
    attr_accessor :entry

    before_filter [:show, :raw] do
      @entry = app.directory
      @entry = @entry.find(stash[:path]) if stash[:path]
      not_found! unless @entry
    end

    def index
    end

    def show
      if entry.directory? && tx.req.url.path[-1] != ?/
        redirect_to "#{tx.req.url.path}/"
        return
      end

      if main = entry.main
        case entry
        when main
          redirect_to "/#{main.parent.relative_path}/"
          return
        when main.parent
          @entry = main
        end
      end
    end

    def raw
      render :text => entry.read,
             :format => entry.ext,
             :type => "text/plain"
    end

    def highlight
      render :text => Pygments.css('.highlight'), :format => :css
    end
  end
end

