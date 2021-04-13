class ApplicationController < ActionController::API
  def render_jsonapi_errors(object)
    render json: { errors: object.errors }, status: :unprocessable_entity
  end
end
