module Clog
  class Entry
    attr_accessor :path, :parent

    def initialize(path, parent = nil)
      @path = Pathname.new(path).realpath
      @parent = parent
    end

    def name
      @name ||= parent ? @path.basename.to_s : ""
    end

    def ext
      @ext ||= name[/\.([^.]+)$/, 1]
    end

    def relative_path(entry = top)
      p = path.relative_path_from(entry.path).to_s
      p << "/" if directory?
      p
    end

    def title
      name
    end

    def [](name)
    end

    def relative_name(entry)
    end

    def file?;      type == :file      end
    def directory?; type == :directory end

    def main?
      main == self
    end

    def top
      if parent
        parent.top
      else
        self
      end
    end

    def parents
      if parent
        parent.parents + [parent]
      else
        []
      end
    end

    def child(path)
      case
      when path.file?
        Clog::File.new(path, self)
      when path.directory?
        Clog::Directory.new(path, self)
      end
    end
  end
end

require 'clog/directory'
require 'clog/file'

