# frozen_string_literal: true

require 'digest'
require 'date'

module Vera
  class Media
    attr_reader :path, :size

    def initialize(path)
      @path = path
      size = File.size(@path)
    end

    def filename
      File.basename(@path)
    end

    def partial_hash
      chunk_size = 1024 * 5
      chunk = File.read(@path, chunk_size)
      Digest::SHA1.hexdigest(chunk)
    end

    def real_hash
      chunk = File.read(@path)
      Digest::SHA1.hexdigest(chunk)
    end

    def creation_date
      datetime = Exiftool.creation_date(@path)
      puts datetime
      Date.parse(datetime)
    end

    def creation_month
    end

    def creation_year
    end

    def camera
      Exiftool.camera(@path)
    end
  end
end
