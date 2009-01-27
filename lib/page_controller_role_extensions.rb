module PageControllerRoleExtensions
  def self.included(base)
    base.class_eval {
      only_allow_access_to :new, :edit,
        :if => :user_is_in_page_role,
        :denied_url => :back,
        :denied_message => "You aren't in an appropriate role for editing or adding children to that page."

      def user_is_in_page_role
        return true if current_user.admin? || current_user.developer?
  
        page = Page.find(params[:id] || params[:page_id] || params[:parent_id])
  
        until page.nil? do
          unless page.role.nil?
            return true if current_user.send("#{page.role.role_name.underscore}?")
          end
          page = page.parent
        end
  
        return false
      end

      before_filter :disallow_role_change
      def disallow_role_change
        if params[:page] && !current_user.admin?
          params[:page].delete(:role_id)
        end
      end
    }
  end
end