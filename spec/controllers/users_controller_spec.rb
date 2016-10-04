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

  describe "POST #create" do
    # it 'should redirect to the tasks if valid parameters' do
    #   params = {user: { name: 'user01',
    #                         email: 'user01@email.com',
    #                         password: '231cret',
    #                         password_confirmation:'secret' }}
    #   post :create, params
    #   response.should redirect_to tasks_path
    # end
  end
end
