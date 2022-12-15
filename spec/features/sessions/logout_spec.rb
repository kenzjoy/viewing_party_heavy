require 'rails_helper'

RSpec.describe 'user can log out' do
  it 'can log out' do 
    user = User.create(name: 'Alice', email: 'alice@example.com', password: 'hamburger1', password_confirmation: 'hamburger1')

    # allow_any_instance_of(ApplicationController)
    #   .to receive(:current_user)
    #   .and_return(user)

    visit root_path

    click_on 'Log In'

    expect(current_path).to eq(login_path)

    fill_in :email, with: 'alice@example.com'
    fill_in :password, with: 'hamburger1'

    click_on 'Submit'

    expect(current_path).to eq(user_path(user))
    expect(page).to_not have_content('Log In')
    expect(page).to_not have_button('Create a New User')

    click_on 'Log Out'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Log In')
    expect(page).to have_button('Create a New User')
    
    expect(page).to_not have_content('Log Out')
  end
end