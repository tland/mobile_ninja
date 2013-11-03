require 'spec_helper'

IPHONE = "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_3 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25"
NEXUS_7 = "Mozilla/5.0 (Linux; Android 4.3; Nexus 7 Build/JSS15R) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.92 Safari/537.36"
IPAD = "Mozilla/5.0 (iPad; CPU OS 7_0_2 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A501 Safari/9537.53"
MAC_CHROME = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36"
MAC_FIREFOX = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:25.0) Gecko/20100101 Firefox/25.0"


describe MobileNinja do
  it "should have version defined" do
    MobileNinja::VERSION.should_not be_nil
  end
end

describe MobileNinja::ControllerAdditions::ClassMethods do
  let(:controller_class) { Class.new }
  let(:controller) { controller_class.new }

  describe "#enable_mobile_ninja" do
    it "should set up controller" do
      controller_class.send(:include, MobileNinja)
      controller_class.should_receive(:include).with(MobileNinja::ControllerAdditions::InstanceMethods)
      controller_class.should_receive(:before_filter).with(:check_for_mobile)
      controller_class.should_receive(:helper_method).with(:mobile_device?)

      controller_class.enable_mobile_ninja
    end
  end
end

  describe MobileNinja::ControllerAdditions::InstanceMethods do
    let(:controller_class) { Class.new }
    let(:controller) { controller_class.new }

    let(:params) { Hash.new }
    let(:session) { Hash.new }
    let(:request) { Object.new }

    before :each do
      controller_class.send(:include, MobileNinja::ControllerAdditions::InstanceMethods)
      #controller_class.enable_mobile_ninja
      controller.stub(:params) { params }
      controller.stub(:session) { session }
      controller.stub(:request) { request }
      Rails.stub!(:root) { Pathname.new("/") }
    end

    describe ".check_for_mobile" do
      it "should change view template path for mobile devices" do
        request.stub!(:user_agent).and_return(IPHONE)
        controller.should_receive(:prepend_view_path).with(Rails.root.join('app', 'views_mobile'))
        controller.check_for_mobile
      end

      it "should change view template path for pc or tablet devices" do
        request.stub!(:user_agent).and_return(MAC_CHROME)
        controller.should_not_receive(:prepend_view_path).with(Rails.root.join('app', 'views_mobile'))
        controller.check_for_mobile
      end

      it "should change view template path when the mobile param is set" do
        request.stub!(:user_agent).and_return(MAC_CHROME)
        params[:mobile] = "true"
        controller.should_receive(:prepend_view_path).with(Rails.root.join('app', 'views_mobile'))
        controller.check_for_mobile
      end
    end

    describe ".mobile_device?" do
      it "should return true for mobile devices" do
        request.stub!(:user_agent).and_return(IPHONE)
        controller.mobile_device?.should be_true
      end

      it "should return false for pc or tablet devices" do
        request.stub!(:user_agent).and_return(MAC_CHROME)
        controller.mobile_device?.should be_false
      end

      it "should return true when the mobile param is set" do
        request.stub!(:user_agent).and_return(MAC_CHROME)
        session[:mobile_override] = "true"
        controller.mobile_device?.should be_true
      end
    end
  end
