require 'rails_helper'
require 'faker'

RSpec.describe 'User Registration Page' do
  before :each do
    visit '/register'
  end

  describe 'the user registration form' do
    it 'show the correct form with fields for name, email, and a submit button' do
      expect(page).to have_content('New User Registration')
      expect(find('form')).to have_content('Name:')
      expect(find('form')).to have_field(:user_name)
      expect(find('form')).to have_content('E-mail:')
      expect(find('form')).to have_field(:user_email)
      expect(find('form')).to have_content('Password:')
      expect(find('form')).to have_field(:user_password)
      expect(find('form')).to have_content('Confirm Password:')
      expect(find('form')).to have_field(:user_password_confirmation)
      expect(page).to have_button('Register')
    end
  end

  describe ' - registration submission - ' do
    context 'if filled out corectly' do
      it 'creates new user' do
        fill_in :user_name, with: 'Kenz'
        fill_in :user_email, with: 'kenz_mail@gmail.com'
        password = Faker::Alphanumeric.alphanumeric(number: 10)
        fill_in :user_password, with: password 
        fill_in :user_password_confirmation, with: password

        expect { click_on 'Register' }.to change { User.count }.by(1)

        expect(page).to have_content("Welcome, kenz_mail@gmail.com!")

        user = User.last
        expect(user.name).to eq('Kenz')
        expect(user.email).to eq('kenz_mail@gmail.com')
        expect(current_path).to eq(user_path(User.find_by(email: 'kenz_mail@gmail.com')))
      end
    end

    context 'if filled out incorrectly, it flashes appropriate error and doesnt create user' do
      it 'with empty fields' do
        expect { click_on 'Register' }.to change { User.count }.by(0)
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Email is invalid")
        expect(page).to have_content("Password can't be blank")

        expect(current_path).to eq('/register')
      end

      it 'with non-email string in email field' do
        fill_in :user_name, with: 'Cat'
        fill_in :user_email, with: 'What is email'
        password = Faker::Alphanumeric.alphanumeric(number: 10)
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password

        expect { click_on 'Register' }.to change { User.count }.by(0)
        expect(page).to have_content('')
        expect(current_path).to eq('/register')
      end

      it 'given a duplicate E-mail' do
        _astrid = create(:user, name: 'Astrid', email: 'astrid-mail@gmail.com')
        fill_in :user_name, with: 'Astrid_2'
        fill_in :user_email, with: 'Astrid-mail@gmail.com'
        password = Faker::Alphanumeric.alphanumeric(number: 10)
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password

        expect { click_on 'Register' }.to change { User.count }.by(0)
        expect(page).to have_content('Email has already been taken')
        expect(current_path).to eq('/register')
      end

      it 'given a non-matching passwords' do
        fill_in :user_name, with: 'Astrid'
        fill_in :user_email, with: 'Astrid-mail@gmail.com'
        fill_in :user_password, with: 'Hunter1'
        fill_in :user_password_confirmation, with: 'notthecorrectone'

        expect { click_on 'Register' }.to change { User.count }.by(0)
        expect(page).to have_content('Passwords must match')
        expect(current_path).to eq('/register')
      end
    end
  end
end
