module Play
  class SandboxedAppscript
    def self.app(name)
      f = FindApp.by_name('iTunes')
      mod = SDEFParser.makeModule(f)
      ::Appscript.app(name, mod)
    end
  end
end
