require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end

      describe "micropost counts" do
        it "should not increment micropost counts" do
          page.should have_content('0 microposts')
          click_button "Post"
          page.should_not have_content('1 micropost')
        end
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end

      describe "micropost counts" do
        it "should increment micropost counts" do
          page.should have_content('0 microposts')
          click_button "Post"
          page.should have_content('1 micropost')
          fill_in 'micropost_content', with: "Lorem ipsum"
          click_button "Post"
          page.should have_content('2 microposts')
        end
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as incorrect user" do
      let(:another_user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: another_user)
        visit user_path(another_user) 
      end
      it "should not have delete link" do
        page.should_not have_link('delete')
      end
    end
  end
end