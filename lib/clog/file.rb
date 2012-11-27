require 'redcarpet'
require 'pygments'
require 'pathname'

module Clog
  class File < Entry
    def each_file
      yield self
    end

    def read
      path.read
    end

    def type
      :file
    end

    def main
      parent.main
    end

    def header
      @header ||=
      case file_type
      when :code
        read[%r{\A(//|#)\s*(.+)$}, 2]
      when :markdown
        read[%r{\A#?\s*(.+)$}, 1]
      end
    end

    def file_type
      case ext
      when "rb", "pl", "js", "html"
        :code
      when "jpg", "jpeg", "png", "gif"
        :image
      when "md", "mkd", "markdown"
        :markdown
      end
    end

    def render
      @render ||=
      case file_type
      when :markdown
        Markdown.render(process(read))
      when :code
        self.class.render_code(read, ext)
      end
    end

    def self.render_code(code, languague)
      '<div class="highlight">%s</div>' %
        Pygments.highlight(code, :lexer => languague)
    end

    def process(code)
      code.gsub(/{include (.*)}/) do
        parent.find($1).read
      end
    end

    class Renderer < Redcarpet::Render::HTML
      def block_code(code, language)
        File.render_code(code, language)
      end
    end

    options = {
      :fenced_code_blocks => true
    }

    Markdown = Redcarpet::Markdown.new(Renderer.new, options)
  end
end

