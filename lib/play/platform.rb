module Play
  class Platform
    def self.darwin?
      !!(RUBY_PLATFORM =~ /darwin/)
    end

    def self.linux?
      !!(RUBY_PLATFORM =~ /linux/)
    end

    def self.windows?
      warn("Windows is not currently supported!")
      !!(RUBY_PLATFORM =~ /mswin|mingw/)
    end
  end
end
