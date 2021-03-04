# frozen_string_literal: true

require 'colorize'

module Vera
  class Icons
    def self.check
      ' ✓ '.green
    end

    def self.arrow
      ' ⮕ '.green
    end

    def self.cross
      ' ✖ '.red
    end
  end
end
