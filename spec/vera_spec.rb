# frozen_string_literal: true

require 'ostruct'
require 'spec_helper'

RSpec.describe Vera::Lister do
  it 'lists files of a specific extension' do
    expect(Dir).to receive(:entries) {
      ['some.jpg', 'other.avi', 'video.mov']
    }
    expect(Vera::Lister.all_files('some/example/path',
                                  'jpg')).to eq [{ filename: 'some.jpg', path: 'some/example/path/some.jpg' }]
  end
end

RSpec.describe Vera::Timestamp do
  it 'runs exiftool with the list of files' do
    expect(Vera::Lister).to receive(:all_files)
      .exactly(4).times
      .with(anything, anything) {
                              [
                                { filename: 'some.jpg', path: 'example/some.jpg' },
                                { filename: 'other.jpg', path: 'example/other.jpg' }
                              ]
                            }
    files = '"example/some.jpg" "example/other.jpg"'
    expect(Vera::Exiftool).to receive(:change_timestamp)
      .exactly(4).times
      .with(anything, files)
    options = OpenStruct.new({ path: 'example' })
    Vera::Timestamp.execute(options)
  end
end
