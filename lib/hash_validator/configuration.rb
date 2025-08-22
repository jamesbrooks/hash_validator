module HashValidator
  class Configuration
    def add_validator(*args)
      HashValidator.add_validator(*args)
    end
    
    def remove_validator(name)
      HashValidator.remove_validator(name)
    end
  end
  
  def self.configure
    config = Configuration.new
    yield(config) if block_given?
  end
end