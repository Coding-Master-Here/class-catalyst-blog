module Api
  module V1
    class PostsController < BaseController
      actions :index, :create, :show

      private

      def permitted_params
        params.require(:post).permit(:title, :content).merge(user_id: @current_user.id)
      end
    end
  end
end
