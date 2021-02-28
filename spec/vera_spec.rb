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

RSpec.describe Vera::Renamer do
  it 'skips files that are already renamed' do
    files = [
      { filename: '2020-01-02-some.jpg', path: 'example/2020-01-02-some.jpg' },
      { filename: 'other.jpg', path: 'example/other.jpg' }
    ]
    filtered_files = Vera::Renamer.exclude_already_renamed_files files
    expect(filtered_files).to eq [
      { filename: 'other.jpg', path: 'example/other.jpg' }
    ]
  end

  it 'renames files adding the date' do
    expect(Vera::Lister).to receive(:all_files)
      .exactly(4).times
      .with(anything, anything) {
                              [
                                { filename: 'some.jpg', path: 'example/some.jpg' },
                                { filename: 'other.jpg', path: 'example/other.jpg' }
                              ]
                            }
    files = '"example/some.jpg" "example/other.jpg"'
    expect(Vera::Exiftool).to receive(:change_filename_with_date)
      .exactly(4).times
      .with(anything, files)
    options = OpenStruct.new({ path: 'example' })
    Vera::Renamer.execute(options)
  end
end
