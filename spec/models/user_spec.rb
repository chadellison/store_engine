require 'spec_helper'

describe User do
  # let(:user) do 
  #   User.new(:name => "Example User",
  #                   :email => "foo@bar.com",
  #                   :display_name => "example_user",
  #                   :password => "foobar", 
  #                   :password_confirmation => "foobar")
  # end

  let(:user) { FactoryGirl.create(:user)}

  [:name, :email, :display_name, :password_digest, :password, 
    :password_confirmation, :remember_token, :authenticate ].each do |attr|
    it "responds to #{attr}" do
      user.should respond_to(attr)
    end
  end

  context "given valid parameters" do
    it "should be valid" do
      user.should be_valid
    end

    it "should be valid when missing display_name" do
      user.display_name = nil
      user.should be_valid
    end
  end

  context "given invalid parameters" do
    it "should be invalid without name" do
      user.name = nil
      user.should_not be_valid
    end

    it "should be invalid without email" do
      user.email = nil
      user.should_not be_valid
    end

    it "should be invalid if password not present" do
      user.password = user.password_confirmation = " "
      user.should_not be_valid
    end

    it "should be invalid when passwords don't match" do
      user.password_confirmation = "meow"
      user.should_not be_valid
    end

    it "should be invalud when password_confirmation is nil" do
      user.password_confirmation = nil
      user.should_not be_valid
    end
  end

  context "authenticate method" do
    describe "return value of authenticate method" do
      before { user.save }
      let(:found_user) { User.find_by_email(user.email) }

      describe "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }

        it { should_not == user_for_invalid_password }
        specify { user_for_invalid_password.should be_false }
      end

      describe "with valid password" do
        it "should authenticate if password matches" do
          found_user.authenticate(user.password).should == found_user
        end
      end

    end

  end

  context "valid token" do
    before { user.save }

    it "should not be blank for a user" do
      user.remember_token.should_not be_blank
    end
  end

  context "#orders" do
    let(:order) { FactoryGirl.create(:order) }
    let(:orders) { [order, FactoryGirl.create(:order)] }
    before(:each) do
      orders.each do |o|
        user.add_order(o)
      end
    end

    context "after an order has been generated" do
      it "should return a collection of orders that correspond to the user" do
        orders.each do |order|
          user.orders.should include(order)
        end
      end
      
    end
  end

end
