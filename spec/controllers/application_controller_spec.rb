require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  context 'current_user' do
    it 'should return current user if user logged in' do
      user = User.create(id: 1, name: 'user', email: 'user01@email.com', password: 'secret')
      session[:user_id] = user.id
      expect(controller.current_user).to be_instance_of User
    end

    it 'should return nil if no user logged in' do
      session[:user_id] = nil
      expect(controller.current_user).to be_nil
    end
  end
end
