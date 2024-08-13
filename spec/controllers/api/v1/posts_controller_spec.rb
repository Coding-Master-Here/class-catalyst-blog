require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:auth_token) { user.auth_token }
  let!(:post1) { create(:post, user: user, title: 'First Post', content: 'Content of the first post') }
  let!(:post2) { create(:post, user: user, title: 'Second Post', content: 'Content of the second post') }

  before do
    request.headers['Authorization'] = "Token #{auth_token}"
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new post' do
        expect {
          post :create, params: { post: { title: 'New Post', content: 'New post content' } }, format: :json
        }.to change(Post, :count).by(1)
        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['title']).to eq('New Post')
        expect(parsed_response['content']).to eq('New post content')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new post' do
        expect {
          post :create, params: { post: { title: '' } }, format: :json
        }.not_to change(Post, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to include("Title can't be blank")
        expect(parsed_response["message"]).to include("Content can't be blank")
      end
    end
  end

  describe 'GET #index' do
    it 'returns a list of posts for the current user' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(2)
      expect(parsed_response.map { |p| p['title'] }).to include('First Post', 'Second Post')
    end
  end

  describe 'GET #show' do
    context 'when the post exists' do
      it 'returns the post with comments' do
        get :show, params: { id: post1.id }, format: :json
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.dig('post', 'title')).to eq('First Post')
        expect(parsed_response.dig('post', 'content')).to eq('Content of the first post')
        expect(parsed_response.dig('post', 'comments')).to be_an(Array) # Ensure comments are included
      end
    end

    context 'when the post does not exist' do
      it 'returns a 404 not found error' do
        get :show, params: { id: 9999 }, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
