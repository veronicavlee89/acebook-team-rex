require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "POST /" do
    it "page redirect and stores the post in the database" do
      User.create(name: "Bob", email: "bob@bob.com", password: "1234567")
      user = User.find_by(name: "Bob")
      allow(User).to receive(:find_by).and_return({ user: { name: 'Bob', email: 'bob@test.com' }})
      post :create, params: { post: { message: "Hello, world!", user_id: user.id, posted_to_id: user.id } }
      post = Post.find_by(message: "Hello, world!")
      expect(post).to be
      expect(response).to redirect_to(root_url)
    end
  end

  describe "GET /" do
    it "responds with 200" do
      allow(User).to receive(:find_by).and_return({ user: { name: 'Bob', email: 'bob@test.com' }})
      get :index
      expect(response).to have_http_status(200)
    end

    it "if user not signed in you get redirected to the homepage" do
      get :index
      expect(response).to redirect_to(welcome_url)
    end

  end

  describe "GET /posts/:id/edit" do
    it "responds with 200" do
      User.create(name: "Bob", email: "bob@bob.com", password: "1234567")
      user = User.find_by(name: "Bob")
      allow(User).to receive(:find_by).and_return(user)
      post :create, params: { post: { message: "Hello, world!", user_id: user.id, posted_to_id: user.id } }
      post = Post.find_by(message: "Hello, world!")

      get :edit, params: { id: post.id }
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /posts/:id" do
    it "will redirect back to index when successfully updated" do
      User.create(name: "Bob", email: "bob@bob.com", password: "1234567")
      user = User.find_by(name: "Bob")
      allow(User).to receive(:find_by).and_return(user)
      post :create, params: { post: { message: "Hello, world!", user_id: user.id, posted_to_id: user.id } }
      post = Post.find_by(message: "Hello, world!")

      patch :update, params: { id: post.id, post: { message: "potatoes are really good", user_id: user.id} }
      expect(response).to redirect_to(root_url)
    end

    it "will update the post message" do
      User.create(name: "Bob", email: "bob@bob.com", password: "1234567")
      user = User.find_by(name: "Bob")
      allow(User).to receive(:find_by).and_return(user)
      post :create, params: { post: { message: "Hello, world!", user_id: user.id, posted_to_id: user.id } }
      post = Post.find_by(message: "Hello, world!")

      patch :update, params: { id: post.id, post: { message: "potatoes are really good", user_id: user.id} }
      expect(Post.find(post.id).message).to eq("potatoes are really good")
    end
  end
  describe "DELETE #destroy" do
    it "check that we can delete a post" do
      User.create(name: "bob", email: "bob@bob.com", password: "123456")
      user = User.find_by(name: "bob")
      allow(User).to receive(:find_by).and_return(user)
      post :create, params: { post: { message: "Hello I am a test", user_id: user.id, posted_to_id: user.id } }
      post = Post.find_by(message: "Hello I am a test")
      expect { delete :destroy, params: {id: post.id } }.to change { Post.count }.by(-1)
    end

    it "redirects to index page after deleting post" do
      User.create(name: "bob", email: "bob@bob.com", password: "123456")
      user = User.find_by(name: "bob")
      allow(User).to receive(:find_by).and_return(user)
      post :create, params: { post: { message: "Hello I am a test", user_id: user.id, posted_to_id: user.id } }
      post = Post.find_by(message: "Hello I am a test")
      delete :destroy, params: {id: post.id }
      expect(response).to redirect_to(root_url)
    end
  end
end
