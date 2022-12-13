require 'rails_helper'

RSpec.describe 'User Registration Page' do
  before :each do
    visit '/register'
  end

  describe 'the user registration form' do
    it 'show the correct form with fields for name, email, and a submit button' do
      expect(page).to have_content('New User Registration')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('E-mail')
      expect(find('form')).to have_content('Password')
      expect(find('form')).to have_content('Password Confirmation')
      expect(page).to have_button('Register')
    end
  end

  describe 'registration submission' do
    context 'if filled out corectly' do
      it 'creates new user' do
        fill_in :name, with: 'Kenz'
        fill_in :email, with: 'kenz_mail@gmail.com'
        fill_in :password, with: "test"
        fill_in :password_confirmation, with: "test"
        
        expect { click_on 'Register' }.to change { User.count }.by(1)

        user = User.last
        expect(user.name).to eq('Kenz')
        expect(user.email).to eq('kenz_mail@gmail.com')
        expect(current_path).to eq(user_path(User.last.id))
      end
    end

    context 'if filled out incorrectly, it flashes appropriate error and doesnt create user' do
      it 'with empty fields' do
        expect { click_on 'Register' }.to change { User.count }.by(0)
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Password can't be blank")
        expect(current_path).to eq('/register')
      end

      it 'with non-email string in email field' do
        fill_in 'name', with: 'Cat'
        fill_in 'email', with: 'What is email'
        expect { click_on 'Register' }.to change { User.count }.by(0)
        expect(page).to have_content('Email is invalid')
        expect(current_path).to eq('/register')
      end

      it 'given a duplicate E-mail' do
        User.create!(name: 'Astrid', email: 'Astrid-mail@gmail.com', password: 'test', password_confirmation: 'test')
        fill_in 'name', with: 'Astrid_2'
        fill_in 'email', with: 'Astrid-mail@gmail.com'
        fill_in 'password', with: 'test'

        expect { click_on 'Register' }.to change { User.count }.by(0)
        expect(page).to have_content('Email has already been taken')
        expect(current_path).to eq('/register')
      end

      it 'with no password' do
        fill_in :name, with: 'Kenz'
        fill_in :email, with: 'kenz_mail@gmail.com'
        fill_in :password_confirmation, with: "test"
        
        expect { click_on 'Register' }.to change { User.count }.by(0)

        expect(page).to have_content("Password can't be blank")
        expect(current_path).to eq('/register')
      end

      it 'with no password confirmation' do
        fill_in :name, with: 'Kenz'
        fill_in :email, with: 'kenz_mail@gmail.com'
        fill_in :password, with: "test"
        
        expect { click_on 'Register' }.to change { User.count }.by(0)

        expect(page).to have_content("Password confirmation can't be blank")
        expect(current_path).to eq('/register')
      end

      it 'password and password confirmation do not match' do
        fill_in :name, with: 'Kenz'
        fill_in :email, with: 'kenz_mail@gmail.com'
        fill_in :password, with: "test"
        fill_in :password_confirmation, with: "testing"
        
        expect { click_on 'Register' }.to change { User.count }.by(0)

        expect(page).to have_content("Password confirmation doesn't match Password")
        expect(current_path).to eq('/register')
      end
    end
  end
end
