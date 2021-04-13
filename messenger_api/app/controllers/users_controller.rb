class UsersController < ApplicationController

  def create
    user = User.new(
      username: create_params['username'],
    )

    if user.save
      render nothing: true, status: :no_content
    else
      render_jsonapi_errors(user)
    end
  end

  private

    def create_params
      params.require(:user)
            .permit(
              :username
            )
    end
end
