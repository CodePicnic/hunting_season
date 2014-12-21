require 'spec_helper'

describe ProductHunt do

  before(:each) do
    @api = ProductHunt::API.new(ENV['TOKEN'] || 'my-token')
  end

  describe 'API' do

    it 'requires an API token (eg. env TOKEN=mytoken bundle exec rake)' do
      ENV["TOKEN"].should_not be_empty
    end

    describe 'Posts' do

      before(:each) do
        @post = @api.posts(3372)
      end

      it 'implements posts#show and yields the name of the post' do
        @post['name'].should == 'namevine'
      end

      describe 'Votes' do

        it 'implements votes#index and yields the first voter' do
          vote = @post.votes.first

          vote.should be_a(ProductHunt::API::Vote)
          vote['user']['username'].should == '1korda'
        end

        it 'implements votes#index with pagination' do
          votes = @post.votes(per_page: 1)
          votes.size.should be(1)

          votes = @post.votes(per_page: 1, older: votes.first['id'])
          votes.size.should be(1)
          votes.first['user']['username'].should == 'mikejarema'
        end

      end

      describe 'Comments' do

        it 'implements comments#index and yields the first voter' do
          comment = @post.comments(order: 'asc').first

          comment.should be_a(ProductHunt::API::Comment)
          comment['user']['username'].should == 'andreasklinger'
        end

        it 'implements comments#index with pagination' do
          pending("https://github.com/producthunt/producthunt-api/issues/35")
          comments = @post.comments(per_page: 1, order: 'asc')
          comments.size.should be(1)

          comments = @post.comments(per_page: 1, older: comments.first['id'], order: 'asc')
          comments.size.should be(1)
          comments.first['user']['username'].should == 'dshan'
        end

      end

    end

    describe 'Users' do

      it 'implements users#show and yields the details of a specific user' do
        user = @api.users('rrhoover')

        user['name'].should == 'Ryan Hoover'
        user['id'].should == 2
      end

    end

  end

end
