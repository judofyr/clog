require 'zoidberg'
require 'tilt'

module Clog
  class App < Zoidberg
    attr_reader :directory

    def directory=(path)
      @directory = Clog::Directory.new(path)
    end

    def setup
      home.root = home.app_lib
      home.controllers = "."
      home.templates = "templates"

      r = routes

      r.get('/').to('main#show')
      r.get('/highlight.css').to('main#highlight')
      r.get('/raw/*path').to('main#raw')
      r.get('/*path').to('main#show')
    end
  end
end

