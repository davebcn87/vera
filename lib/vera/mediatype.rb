# frozen_string_literal: true

module Vera
  class MediaType
    MEDIA_TYPES = %w[MP4 MOV JPG HEIC ARW CR2].freeze

    def self.all
      MEDIA_TYPES
    end
  end
end
