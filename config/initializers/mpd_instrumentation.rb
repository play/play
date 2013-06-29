module MpdInstrumentation
  class LogSubscriber < ActiveSupport::LogSubscriber
    def search(event)
      return unless logger.debug?

      name     = '%s (%.1fms)' % ["MPD Search", event.duration]
      options  = event.payload[:options]
      keys     = options.select{|i| options.index(i).even? }
      values   = options.select{|i| options.index(i).odd? }

      combined = keys.zip(values)
      combined = combined.map {|array| array.join(': ') }.join(', ')

      self.class.runtime += event.duration
      debug "  #{color(name, YELLOW, true)}  [ #{combined} ]"
    end

    def find(event)
      return unless logger.debug?

      name     = '%s (%.1fms)' % ["MPD Find", event.duration]
      options  = event.payload[:options]
      keys     = options.select{|i| options.index(i).even? }
      values   = options.select{|i| options.index(i).odd? }

      combined = keys.zip(values)
      combined = combined.map {|array| array.join(': ') }.join(', ')

      self.class.runtime += event.duration
      debug "  #{color(name, YELLOW, true)}  [ #{combined} ]"
    end

    def playlist(event)
      return unless logger.debug?
      return if $PROGRAM_NAME =~ /queue/

      name     = '%s (%.1fms)' % ["MPD Playlist", event.duration]
      options  = event.payload[:options]

      self.class.runtime += event.duration
      debug "  #{color(name, YELLOW, true)}"
    end

    def list(event)
      return unless logger.debug?

      name     = '%s (%.1fms)' % ["MPD List", event.duration]
      options  = event.payload[:options]
      keys     = options.select{|i| options.index(i).even? }
      values   = options.select{|i| options.index(i).odd? }

      combined = keys.zip(values)
      combined = combined.map {|array| array.join(': ') }.join(', ')

      self.class.runtime += event.duration
      debug "  #{color(name, YELLOW, true)}  [ #{combined} ]"
    end

    def now_playing(event)
      return unless logger.debug?
      return if $PROGRAM_NAME =~ /queue/

      name = '%s (%.1fms)' % ["MPD Now Playing", event.duration]

      self.class.runtime += event.duration
      debug "  #{color(name, YELLOW, true)}"
    end

    def self.runtime=(value)
      Thread.current["mpd_runtime"] = value
    end

    def self.runtime
      Thread.current["mpd_runtime"] ||= 0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end
  end

  module ControllerRuntime
    extend ActiveSupport::Concern

    protected

    def append_info_to_payload(payload)
      super
      payload[:mpd_runtime] = MpdInstrumentation::LogSubscriber.runtime
    end

    module ClassMethods
      def log_process_action(payload)
        messages, mpd_runtime = super, payload[:mpd_runtime]
        messages << ("Mpd: %.1fms" % mpd_runtime.to_f) if mpd_runtime
        messages
      end
    end
  end
end

MpdInstrumentation::LogSubscriber.attach_to :mpd

ActiveSupport.on_load(:action_controller) do
  include MpdInstrumentation::ControllerRuntime
end
