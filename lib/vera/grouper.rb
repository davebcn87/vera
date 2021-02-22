module Vera
  class Grouper
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
      type = options.by
      group_by_date path, type
    end

    def self.group_by_date path, type
      grouped_files = MediaType
      .all
      .map { |mt| all_files(path, mt) }
      .compact
      .flatten
      .group_by { |a|
        media = Media.new(a[:path])
        value_type_for type, media
      }

      grouped_files
      .each do |date, items|
        new_path = "#{path}/#{date}"
        Dir.mkdir(new_path) unless File.exists?(new_path)
        items.each { |f| FileUtils.mv(f[:path], new_path) }
      end
    end

    def self.value_type_for type, media
      case type
      when "date"
        media.creation_date
      when "camera"
        media.camera
      else
        raise "You cannot group by #{type}. Only 'camera' and 'date' are available types."
      end
    end

    def self.all_files path, ext
      Vera::Lister.all_files path, ext
    end
  end
end
