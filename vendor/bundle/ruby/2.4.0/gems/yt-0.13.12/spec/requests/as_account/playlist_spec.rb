# encoding: UTF-8

require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :device_app do
  subject(:playlist) { Yt::Playlist.new id: id, auth: $account }

  context 'given an existing playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }

    it 'returns valid metadata' do
      expect(playlist.title).to be_a String
      expect(playlist.description).to be_a String
      expect(playlist.thumbnail_url).to be_a String
      expect(playlist.published_at).to be_a Time
      expect(playlist.tags).to be_an Array
      expect(playlist.channel_id).to be_a String
      expect(playlist.channel_title).to be_a String
      expect(playlist.privacy_status).to be_in Yt::Status::PRIVACY_STATUSES
    end

    it { expect(playlist.playlist_items.first).to be_a Yt::PlaylistItem }
  end

  context 'given an unknown playlist' do
    let(:id) { 'not-a-playlist-id' }

    it { expect{playlist.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
  end

  context 'given someone else’s playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }
    let(:video_id) { 'MESycYJytkU' }

    it { expect{playlist.delete}.to fail.with 'forbidden' }
    it { expect{playlist.update}.to fail.with 'forbidden' }
    it { expect{playlist.add_video! video_id}.to raise_error Yt::Errors::RequestError }
    it { expect{playlist.delete_playlist_items}.to raise_error Yt::Errors::RequestError }
  end

  context 'given one of my own playlists that I want to delete' do
    before(:all) { @my_playlist = $account.create_playlist title: "Yt Test Delete Playlist #{rand}" }
    let(:id) { @my_playlist.id }

    it { expect(playlist.delete).to be true }
  end

  context 'given one of my own playlists that I want to update' do
    before(:all) { @my_playlist = $account.create_playlist title: "Yt Test Update Playlist #{rand}" }
    after(:all) { @my_playlist.delete }
    let(:id) { @my_playlist.id }
    let!(:old_title) { @my_playlist.title }
    let!(:old_privacy_status) { @my_playlist.privacy_status }
    let(:update) { @my_playlist.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Playlist #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(@my_playlist.title).not_to eq old_title
        expect(@my_playlist.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { @my_playlist.description }
      let(:attrs) { {description: "Yt Example Description  #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(@my_playlist.description).not_to eq old_description
        expect(@my_playlist.title).to eq old_title
        expect(@my_playlist.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { @my_playlist.tags }
      let(:attrs) { {tags: ["Yt Test Tag #{rand}"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(@my_playlist.tags).not_to eq old_tags
        expect(@my_playlist.title).to eq old_title
        expect(@my_playlist.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update title, description and/or tags using angle brackets' do
      let(:attrs) { {title: "Yt Test < >", description: '< >', tags: ['<tag>']} }

      specify 'updates them replacing angle brackets with similar unicode characters accepted by YouTube' do
        expect(update).to be true
        expect(playlist.title).to eq 'Yt Test ‹ ›'
        expect(playlist.description).to eq '‹ ›'
        expect(playlist.tags).to eq ['‹tag›']
      end
    end

    context 'given I update the privacy status' do
      let!(:new_privacy_status) { old_privacy_status == 'private' ? 'unlisted' : 'private' }

      context 'passing the parameter in underscore syntax' do
        let(:attrs) { {privacy_status: new_privacy_status} }

        specify 'only updates the privacy status' do
          expect(update).to be true
          expect(@my_playlist.privacy_status).not_to eq old_privacy_status
          expect(@my_playlist.title).to eq old_title
        end
      end

      context 'passing the parameter in camel-case syntax' do
        let(:attrs) { {privacyStatus: new_privacy_status} }

        specify 'only updates the privacy status' do
          expect(update).to be true
          expect(@my_playlist.privacy_status).not_to eq old_privacy_status
          expect(@my_playlist.title).to eq old_title
        end
      end
    end

    context 'given an existing video' do
      let(:video_id) { 'MESycYJytkU' }

      describe 'can be added' do
        it { expect(playlist.add_video video_id).to be_a Yt::PlaylistItem }
        it { expect{playlist.add_video video_id}.to change{playlist.playlist_items.count}.by(1) }
        it { expect(playlist.add_video! video_id).to be_a Yt::PlaylistItem }
        it { expect{playlist.add_video! video_id}.to change{playlist.playlist_items.count}.by(1) }
        it { expect(playlist.add_video(video_id, position: 0).position).to be 0 }
      end

      describe 'can be removed' do
        before { playlist.add_video video_id }

        it { expect(playlist.delete_playlist_items.uniq).to eq [true] }
        it { expect{playlist.delete_playlist_items}.to change{playlist.playlist_items.count} }
      end
    end

    context 'given an unknown video' do
      let(:video_id) { 'not-a-video' }

      describe 'cannot be added' do
        it { expect(playlist.add_video video_id).to be_nil }
        it { expect{playlist.add_video video_id}.not_to change{playlist.playlist_items.count} }
        it { expect{playlist.add_video! video_id}.to fail.with 'videoNotFound' }
      end
    end

    context 'given a video of a terminated account' do
      let(:video_id) { 'kDCpdKeTe5g' }

      describe 'cannot be added' do
        it { expect(playlist.add_video video_id).to be_nil }
        it { expect{playlist.add_video video_id}.not_to change{playlist.playlist_items.count} }
        it { expect{playlist.add_video! video_id}.to fail.with 'forbidden' }
      end
    end

    context 'given one existing and one unknown video' do
      let(:video_ids) { ['MESycYJytkU', 'not-a-video'] }

      describe 'only one can be added' do
        it { expect(playlist.add_videos(video_ids).length).to eq 2 }
        it { expect{playlist.add_videos video_ids}.to change{playlist.playlist_items.count}.by(1) }
        it { expect{playlist.add_videos! video_ids}.to fail.with 'videoNotFound' }
      end
    end
  end
end