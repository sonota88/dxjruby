module DXJRuby
  # A base class for resources acquired through JS Promises.
  # Provides `<klass>.register` and `<klass>[name]`.
  # A subclass must impelment `<klass>._load`.
  #
  # TODO: better name? (SoundEffect is not actually 'remote')
  class RemoteResource
    # # List of registered resources (Contains path_or_url)
    # @@resources = Hash.new{|h,k| h[k] = {}}
    # # Contains promises
    # @@promises = Hash.new{|h,k| h[k] = {}}
    # # Contains instances of Image, Sound
    # @@instances = Hash.new{|h,k| h[k] = {}}
    # # `true` if the resource is loaded
    # @@loaded = Hash.new{|h,k| h[k] = {}}

    # # Subclasses of RemoteResource
    # @@klasses = {}
    # def self.add_class(subklass)

    # # Reserve instance generation
    # def self.register(name, *args, &block)

    # # Return instance of loaded resource (call on subclasses)
    # def self.[](name)

    # Called from Window.load_resources
    def self._load_resources(&block)
      # TODO
    end

    # # Load actual content (defined on subclasses)
    # # Return `[instance, promise]`
    # def self._load(*args)

    # # Return a string like "Image" or "Sound"
    # def self._klass_name

    # # Update loading status if `dxopal-loading` is defined.
    # def self._update_loading_status
  end
end
