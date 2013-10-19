require 'spec_helper'

describe WikisController do
  describe "GET wiki#new" do
    it "should have a new route" do
      get :new
      expect(assigns(:wiki)).to be_a(Wiki)
    end
  end

  describe "GET wiki#new" do
    let (:new_wiki) { FactoryGirl.build(:change) }

    ## TO DO... PINGPONG CHANGE FORMS
    it "should return a new wiki page with edits" do
      get :new, wiki: { url: url, replace_text: new_answer.question_id }
      expect(assigns(:answer)).to be_a(Answer)
      expect(assigns(:answer).body).to eq new_answer.body
      expect(assigns(:answer).question_id).to eq new_answer.question_id
    end

    it "should create an answer associated with a question" do
      post :create, answer: { body: new_answer.body, question_id: new_answer.question_id }
      expect(assigns(:answer).question).to be_a(Question)
    end
  end

end