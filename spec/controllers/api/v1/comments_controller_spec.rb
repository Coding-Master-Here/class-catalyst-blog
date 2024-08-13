require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:auth_token) { user.auth_token }
  let(:post1) { create(:post, user: user) }

  before do
    request.headers['Authorization'] = "Token #{auth_token}"
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new comment for the post' do
        expect {
          post :create, params: { post_id: post1.id, comment: { content: 'Great post!' } }, format: :json
        }.to change(Comment, :count).by(1)
        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['content']).to eq('Great post!')
        expect(parsed_response['post_id']).to eq(post1.id)
        expect(parsed_response['user_id']).to eq(user.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new comment' do
        expect {
          post :create, params: { post_id: post1.id, comment: { content: '' } }, format: :json
        }.not_to change(Comment, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to include("Content can't be blank")
      end
    end

    context 'when user is not authenticated' do
      before do
        request.headers['Authorization'] = nil
      end

      it 'returns an unauthorized status' do
        post :create, params: { post_id: post1.id, comment: { content: 'Great post!' } }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when post does not exist' do
      it 'returns a not found status' do
        post :create, params: { post_id: 9999, comment: { content: 'Great post!' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
