module DXRuby
  class Image
    @@instances = {}

    def self.register(name, path)
      @@instances[name] = Image.load(path)
    end

    def self.[](name)
      @@instances[name]
    end
  end

  module Window
    def self.load_resources
      yield
    end
  end
end
