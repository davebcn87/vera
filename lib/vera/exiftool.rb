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

    def self.creation_date path
      day_format = "%Y-%m-%d"
      date = get_info_for_field(path, "creationDate", day_format) ||
      get_info_for_field(path, "dateTimeOriginal", day_format) ||
      get_info_for_field(path, "mediaCreateDate", day_format)
      unless date.length > 0
        puts path
      end
      date
    end

    def self.get_info_for_field path, field, date_format = nil
      unless date_format
        value = %x{ exiftool -s -s -s -#{field} "#{path}" }
      else
        value = %x{ exiftool -s -s -s -d "#{date_format}" -#{field} "#{path}" }
      end
      return nil unless value.length > 0
      value.strip
    end

    def self.camera path
      get_info_for_field path, "model"
    end
  end
end
