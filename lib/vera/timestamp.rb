# frozen_string_literal: true

module Vera
  class Timestamp
    def self.execute(options)
      path = options.path
      path = Dir.pwd if options.path.nil?
      path = File.expand_path(path)
      fix_timestamp_in path
    end

    def self.fix_timestamp_in(path)
      rename_files_with_date path, 'ARW', 'DateTimeOriginal'
      rename_files_with_date path, 'JPG', 'DateTimeOriginal'
      rename_files_with_date path, 'HEIC', 'DateTimeOriginal'
      rename_files_with_date path, 'MOV', 'CreationDate'
    end

    def self.rename_files_with_date(path, ext, date_property)
      files = Lister.all_files(path, ext)
      if files.empty?
        puts 'Nothing to do here'
        return
      end
      puts "✅ Correcting timestamp for #{files.length} #{ext} files..."
      files_string = files.map { |f| "\"#{f[:path]}\"" }.join(' ')
      Exiftool.change_timestamp date_property, files_string
    end
  end
end
