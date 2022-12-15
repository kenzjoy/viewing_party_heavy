require 'rails_helper'

RSpec.describe 'welcome landing page', type: :feature do
  before(:each) do
    @kenz = User.create!(name: 'Kenz', email: 'kenz_mail@gmail.com', password: 'test', password_confirmation: 'test')
    @astrid = User.create!(name: 'Astrid', email: 'astrid_mail@gmail.com', password: 'testing', password_confirmation: 'testing')
    @reba = User.create!(name: 'Reba', email: 'reba_mail@gmail.com', password: 'testing123', password_confirmation: 'testing123')
    visit root_path
  end

  describe 'as a user' do
    describe 'when I visit root_path' do
      it '- shows the title of the application' do
        expect(page).to have_content('Viewing Party')
      end

      it '- has a button to create a new user' do
        expect(page).to have_button('Create a New User')
        
        click_button 'Create a New User'

        expect(current_path).to eq(new_user_path)
      end

      it '- has a link to go back to the landing page (this link will be present at the top of all pages)' do
        expect(page).to have_link('Home', href: root_path)
      end

      it '- has a link to log in that directs me to login_path' do
        expect(page).to have_link('Log In', href: login_path)
      end

      it 'does not show the section of the page that lists existing users after I log in' do
        alice = User.create(name: 'Alice', email: 'alice@example.com', password: 'hamburger1', password_confirmation: 'hamburger1')
        kenny = User.create(name: 'Kenny', email: 'kenny@example.com', password: 'hamburger2', password_confirmation: 'hamburger2')
        samantha = User.create(name: 'Samantha', email: 'samantha@example.com', password: 'hamburger3', password_confirmation: 'hamburger3')

        # allow_any_instance_of(ApplicationController)
        #   .to receive(:current_user)
        #   .and_return(user)

        visit root_path
        
        within "#user-list" do
          expect(page).to_not have_content(alice.email)
          expect(page).to_not have_content(kenny.email)
          expect(page).to_not have_content(samantha.email)
        end

        click_on 'Log In'

        expect(current_path).to eq(login_path)

        fill_in :email, with: 'alice@example.com'
        fill_in :password, with: 'hamburger1'

        click_on 'Submit'

        expect(current_path).to eq(user_path(alice))

        click_on 'Home'

        expect(current_path).to eq(root_path)

        expect(page).to have_css("#user-list")

        within "#user-list" do
          expect(page).to have_content(alice.email)
          expect(page).to have_content(kenny.email)
          expect(page).to have_content(samantha.email)
        end

        click_on 'Log Out'

        expect(current_path).to eq(root_path)

        within "#user-list" do
          expect(page).to_not have_content(alice.email)
          expect(page).to_not have_content(kenny.email)
          expect(page).to_not have_content(samantha.email)
        end
      end
    end
  end
end