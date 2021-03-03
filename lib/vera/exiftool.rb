# frozen_string_literal: true

module Vera
  class Exiftool
    def self.change_timestamp(date_property, files_string)
      `exiftool "-FileCreateDate<#{date_property}" "-FileModifyDate<#{date_property}" #{files_string} 2>/dev/null`
    end

    def self.installed?
      system('which exiftool >/dev/null')
    end

    def self.change_filename_with_date(date_property, files_string)
      system("exiftool '-FileName<$#{date_property}-$filename' -d \"%Y-%m-%d\" #{files_string} 2>/dev/null")
    end
  end
end
