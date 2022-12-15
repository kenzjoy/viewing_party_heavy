require 'rails_helper'

RSpec.describe 'login form page' do
  before(:each) do
    visit login_path
  end

  describe 'as a user' do 
    describe 'when I visit login_path' do
      it '- there is a form where I can input my unique email and password' do
        expect(page).to have_content('Existing User Login')
        expect(find('form')).to have_content('E-mail')
        expect(find('form')).to have_content('Password')
        expect(page).to have_button('Submit')
      end

      it '- when I enter my unique email and correct password, I am taken to my dashboard page' do
        kenz = User.create!(name: 'Kenz', email: 'kenz_mail@gmail.com', password: 'test', password_confirmation: 'test')

        fill_in :email, with: 'kenz_mail@gmail.com'
        fill_in :password, with: 'test'
        
        click_on 'Submit'

        expect(current_path).to eq(user_path(kenz))
        expect(page).to have_content("Welcome, Kenz!")
      end

      it '- when I fail to fill in my correct credentials, I am taken back to the login page and I can see a flash message telling me I entered incorrect credentials' do
        kenz = User.create!(name: 'Kenz', email: 'kenz_mail@gmail.com', password: 'test', password_confirmation: 'test')

        fill_in :email, with: 'kenz_mail@gmail.com'
        fill_in :password, with: 'phish'
        
        click_on 'Submit'

        expect(current_path).to eq(login_path)
        expect(page).to have_content("Incorrect Credentials")
      end

      it '- email log in is case insensitive' do
        kenz = User.create!(name: 'Kenz', email: 'kenz_mail@gmail.com', password: 'test', password_confirmation: 'test')

        fill_in :email, with: 'KENZ_mail@gmail.com'
        fill_in :password, with: 'test'
        
        click_on 'Submit'

        expect(current_path).to eq(user_path(kenz))
        expect(page).to have_content("Welcome, Kenz!")
      end
    end
  end
end