# frozen_string_literal: true

module Vera
  class Renamer
    def self.execute(options)
      unless Exiftool.installed?
        puts ''"
          You need to install exiftool to use vera. You can run the following command to do it:
          bash <(curl -Ls https://git.io/JtbuH)
        "''
        return
      end
      path = options.path
      path = Dir.pwd if options.path.nil?
      path = File.expand_path(path)
      rename path
    end

    def self.rename(path)
      rename_files_with_date path, 'ARW',  'DateTimeOriginal'
      rename_files_with_date path, 'JPG',  'DateTimeOriginal'
      rename_files_with_date path, 'HEIC', 'DateTimeOriginal'
      rename_files_with_date path, 'MOV',  'CreationDate'
      rename_files_with_date path, 'MP4',  'MediaCreateDate'
    end

    def self.rename_files_with_date(path, ext, date_property)
      puts "#{Icons.check} Adding creation date to #{ext} files in the filename"
      files = Lister.all_files(path, ext)
      files = Renamer.exclude_already_renamed_files(files)
      if files.empty?
        puts "No files to rename for #{ext} file type."
        return
      end
      files_string = files.map { |f| "\"#{f[:path]}\"" }.join(' ')
      puts "#{Icons.cross} Something went wrong" unless Exiftool.change_filename_with_date(date_property, files_string)
    end

    def self.exclude_already_renamed_files(files)
      files.select { |f| f[:filename].match(/\d+-\d+-\d+-/).nil? }
    end
  end
end
