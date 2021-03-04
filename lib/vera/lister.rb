# frozen_string_literal: true

module Vera
  class Lister
    def self.all_files(path, ext)
      Dir.entries(path)
         .map { |file| { path: "#{path}/#{file}", filename: file } }
         .select { |file| ext == File.extname(file[:filename]).gsub('.', '') }
    end

    def self.all_media_files_recursive(path)
      `find #{path.gsub(' ', '\ ')} -type f | grep -E "#{MediaType.all.join('|')}"`.split("\n")
    end
  end
end
