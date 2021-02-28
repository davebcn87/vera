# frozen_string_literal: true

module Vera
  class Exiftool
    def self.change_timestamp(date_property, files_string)
      `exiftool "-FileCreateDate<#{date_property}" "-FileModifyDate<#{date_property}" #{files_string} 2>/dev/null`
    end

    def self.is_installed?
      system("which exiftool >/dev/null")
    end
  end
end
