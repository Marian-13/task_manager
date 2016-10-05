require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it 'should render the new template if user not logged in' do
      session[:user_id] = nil

      get :new
      expect(response).to render_template(:new)
    end

    it 'should redirect to task if user logged in' do
      user = User.create(id: 1, name: 'user', email: 'user01@email.com', password: 'secret')
      session[:user_id] = user.id

      get :new
      expect(response).to redirect_to(tasks_path)
    end
  end
end
