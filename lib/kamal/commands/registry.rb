class Kamal::Commands::Registry < Kamal::Commands::Base
  delegate :registry, to: :config

  def login
    pipe \
      echo(sensitive(lookup("password"))),
      docker(:login, registry["server"], "-u", sensitive(lookup("username")), "--password-stdin")
  end

  def logout
    docker :logout, registry["server"]
  end

  private
    def lookup(key)
      if registry[key].is_a?(Array)
        ENV.fetch(registry[key].first).dup
      else
        registry[key]
      end
    end
end
