module Vera
  class Lister
    def self.all_files(path, ext)
      Dir.entries(path)
         .map { |file| { path: "#{path}/#{file}", filename: file } }
         .select { |file| ext == File.extname(file[:filename]).gsub('.', '') }
    end
  end
end
