require 'pathname'

module Clog
  class Directory < Entry
    def type
      :directory
    end

    def title
      @title ||= name + "/"
    end

    def header
      main.header if main
    end

    def files
      @files ||= @path.children
        .reject { |x| x.basename.to_s[0] == ?. }
        .sort.map { |x| child(x) }.compact
    end

    def [](name)
      files.detect { |x| name === x.name }
    end

    MAIN = /^(README|main)\./

    def main
      return @main if defined? @main
      @main = parent && (self[MAIN] || parent.main)
    end

    def find(path)
      @finder ||= Hash.new do |h, k|
        h[k] = k.split("/").inject(self) do |dir, part|
          dir && dir[part]
        end
      end

      @finder[path]
    end

    def each_file(&blk)
      files.each do |entry|
        entry.each_file(&blk)
      end
    end
  end
end

