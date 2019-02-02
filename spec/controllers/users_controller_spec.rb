require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject(:user) {User.create(username: 'John', password: 'password')}
  
  describe 'GET #new' do
    it 'renders new user template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'logs in the user' do
        post :create, params: {user: user.attributes }
        expect(session[:session_token]).to eq(User.last.session_token)
      end

      it 'redirects to the user\'s show page' do
        post :create, params: {user: {username: 'Jane', password: 'password' }}
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid params' do
      it 'renders new template with errors' do 
        post :create, params: {user: { username: 'John', password: ''} }
        expect(response).to render_template(:new)
        expect(flash.now[:errors]).to be(present)
      end
    end
  end

  describe 'GET #index' do
    it 'renders index page and shows all users' do
      get :index 
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #edit' do
    it 'renders to edit template' do
      get :edit, params: {id: user.id}
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'valid params' do
      it 'updates user params from edit template' do
        user1 = user.dup
        patch :update, params: { user: {  username: 'Sarah', password: 'password'} }
        expect(user1).not_to eq(user)
      end

      it 'redirects to user show page' do
        patch :update, params: {user: user.attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end
  end

  describe 'GET #show' do
    it 'renders user show page' do
      get :show, params: {id: user.id}
      expect(response).to render_template(:show)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys user' do
      delete :destroy, params: {id: user.id}
      expect(user).to be_nil
    end

    it 'redircts to index page' do
      expect(response).to redirect_to(users_url)
    end
  end
end

