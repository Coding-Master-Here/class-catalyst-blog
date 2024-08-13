module Api
  module V1
    class CommentsController < BaseController
      actions :create

      private

      def permitted_params
        params.require(:comment).permit(:content).merge(user_id: @current_user.id, post_id: params[:post_id])

      end
    end
  end
end
