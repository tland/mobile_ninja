require 'rails'
require 'action_controller'
require "mobile_ninja/version"

module MobileNinja

  def self.included(base)
    base.extend ControllerAdditions::ClassMethods
  end

  module ControllerAdditions
    # Class Methods
    module ClassMethods

      def enable_mobile_ninja
        include MobileNinja::ControllerAdditions::InstanceMethods

        before_filter :check_for_mobile

        helper_method :mobile_device?
      end
    end

    # Instance Methods
    module InstanceMethods

      def check_for_mobile
        # the use of mobile request parameter should be for testing purpose only
        session[:mobile_override] = params[:mobile] if params[:mobile]
        prepare_for_mobile if mobile_device?
      end

      def prepare_for_mobile
        prepend_view_path Rails.root.join('app', 'views_mobile')
      end

      def mobile_device?
        if session[:mobile_override]
          !!session[:mobile_override].match(/^(true|t|yes|y|1)$/i)
        else
          # iPad is not considered as a mobile device
          (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
        end
      end
    end
  end
end

ActionController::Base.send(:include, MobileNinja)