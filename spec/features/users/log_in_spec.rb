require 'rails_helper'

RSpec.describe 'welcome landing page', type: :feature do
  before(:each) do
    @kenz = create(:user, name: 'Kenz', email: 'kenz_mail@gmail.com')
    @astrid = create(:user, name: 'Astrid', email: 'astrid_mail@gmail.com', password: 'Hunter01')
    @reba = create(:user, name: 'Reba', email: 'reba_mail@gmail.com')

    visit user_login_path
  end

  describe 'as a user' do
    describe 'when I visit root_path' do
      it ', I see a link to log in that takes me to login page' do
        visit root_path

        expect(page).to have_link('Log In')

        click_link 'Log In'

        expect(current_path).to be(user_login_path)
      end
    end

    describe 'when I visit the login page' do
      it 'has empty email and password fields' do
        expect(page).to have_content('User Login')
        expect(find('form')).to have_content('E-mail:')
        expect(find('form')).to have_field(:user_email)
        expect(find('form')).to have_content('Password:')
        expect(find('form')).to have_field(:user_password)
        expect(find('form')).to have_button('Log In')
      end

      context ' - happy path - ' do
        it 'and fill out email and password fields correctly, it takes me to that user dashboard' do
          fill_in :user_email, with: @astrid.email
          fill_in :user_password, with: 'Hunter01'

          click_button 'Log In'

          exepect(current_path).to be(user_path(@astrid))
        end

        it 'and fill out correctly, but email with wrong case, it still takes me to that user dashboard' do
          fill_in :user_email, with: @astrid.email.upcase
          fill_in :user_password, with: 'Hunter01'

          click_button 'Log In'

          exepect(current_path).to be(user_path(@astrid))
        end
      end

      context ' - sad path - ' do
        it 'and fill out email but not password fields correctly, it flashes a message to try again' do
          fill_in :user_email, with: @astrid.email
          fill_in :user_password, with: 'aswdasdas'

          click_button 'Log In'

          exepect(current_path).to be(user_login_path)
          expect(page).to have_content('Incorrect Credentials. Please try again.')
        end

        it 'and fill out password but not email fields correctly, it flashes same message to try again' do
          fill_in :user_email, with: 'wrong_mail@gmail.com'
          fill_in :user_password, with: 'Hunter01'

          click_button 'Log In'

          exepect(current_path).to be(user_login_path)
          expect(page).to have_content('Incorrect Credentials. Please try again.')
        end

        it 'and dont fill out fields, it flashes same message to try again' do
          fill_in :user_email, with: ''
          fill_in :user_password, with: ''

          click_button 'Log In'

          exepect(current_path).to be(user_login_path)
          expect(page).to have_content('Incorrect Credentials. Please try again.')
        end
      end
    end
  end
end