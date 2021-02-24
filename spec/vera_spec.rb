# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vera::Lister do
  it 'lists files of a specific extension' do
    expect(Dir).to receive(:entries).with(anything) { ['some.jpg', 'other.avi', 'video.mov'] }
    expect(Vera::Lister.all_files('some/example/path',
                                  'jpg')).to eq [{ filename: 'some.jpg', path: 'some/example/path/some.jpg' }]
  end
end
