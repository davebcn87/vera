# frozen_string_literal: true
require 'colorize'

module Vera
  class Safe
    def self.execute(options)
      unless Exiftool.installed?
        puts "
          You need to install exiftool to use vera. You can run the following command to do it:
          bash <(curl -Ls https://git.io/JtbuH)
        "
        return
      end
      path = options.path
      path = Dir.pwd if options.path.nil?
      path = File.expand_path(path)
      backup_path = File.expand_path(options.backup)

      unless File.directory?(path)
        puts "#{path} is not a valid directory.".red
        return
      end

      unless File.directory?(backup_path)
        puts "#{backup_path} is not a valid directory.".red
        return
      end

      safe_to_delete_path? path, backup_path
    end

    def self.safe_to_delete_path?(path, backup_path)
      backup_media_files = Lister.all_media_files_recursive(backup_path)
                                 .map { |f| Media.new(f) }

      media_files = Lister.all_media_files_recursive(path)
                                 .map { |f| Media.new(f) }

      print_folders(path, backup_path)
      print_number_of_files(media_files, backup_media_files)

      select_candidates = candidates_by_file_size(media_files, backup_media_files)
      found_files       = candidates_by_partial_hash(select_candidates)

      print_list_of_files(found_files, backup_path)
    end

    def self.candidates_by_file_size(media_files, backup_media_files)
      media_files.map do |media|
        {
          media: media,
          candidates: backup_media_files.select { |c| c.size == media.size }
        }
      end
    end

    def self.candidates_by_partial_hash(media_files)
      media_files.map do |hash|
        media = hash[:media]
        file_found = hash[:candidates].find do |m|
          media.partial_hash == m.partial_hash
        end

        {
          media: media,
          file_found: file_found,
          found: !file_found.nil?
        }
      end
    end

    def self.print_folders(path, backup_path)
      message = "Trying to find #{path} files in #{backup_path}"

      print_separator message.length
      puts message.yellow
      print_separator message.length
    end

    def self.print_number_of_files(media_files, backup_files)
      backup_message = "In a total of #{backup_files.length} media files in your backup folder..."

      print_separator backup_message.length
      puts "Searching #{media_files.length} media files...".yellow
      puts backup_message.yellow
      print_separator backup_message.length
    end

    def self.print_separator length
      length.times { print "-" }
      print "\n"
    end

    def self.print_list_of_files(files, backup_dir)
      found_message = "#{Icons.check} #{files.select { |f| f[:found] }.length } file(s) found"
      not_found_message = "#{Icons.cross} #{files.reject { |f| f[:found] }.length } file(s) not found"

      files.sort_by { |x| [(x[:found] ? 0 : 1), x[:path]] }
           .each do |f|
        found    = f[:found]
        found_in = f[:file_found].path.gsub(backup_dir, '')
        filename = f[:media].filename.ljust(15, ' ')

        puts "#{Icons.check} #{filename} #{Icons.arrow} #{found_in}" if found
        puts "#{Icons.cross} #{filename} not found." unless found
      end

      print_separator not_found_message.length
      puts found_message
      puts not_found_message
      print_separator not_found_message.length
    end

    def self.filter_real_hash(hash)
      {
        media: hash[:media],
        candidates: hash[:candidates].find do |m|
          media.real_hash == m.real_hash
        end
      }
    end
  end
end
