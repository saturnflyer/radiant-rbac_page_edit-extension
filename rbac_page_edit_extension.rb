# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RbacPageEditExtension < Radiant::Extension
  version "1.0"
  description "Restricts user access of pages based upon role. Based upon the RBAC Base extension."
  url "http://saturnflyer.com/"
  
  class MissingRequirement < StandardError; end
  
  def activate
    raise RbacPageEditExtension::MissingRequirement.new('RbacBaseExtension must be installed and loaded first.') unless defined?(RbacBaseExtension)
    
    Page.class_eval {
      belongs_to :role
    }
    Role.class_eval {
      has_many :pages
    }
    Admin::PageController.send :include, PageControllerRoleExtensions
    admin.page.index.add :node, "page_role_td", :before => "status_column"
    admin.page.index.add :sitemap_head, "page_role_th", :before => "status_column_header"
    admin.page.edit.add :parts_bottom, "page_role", :after => "edit_timestamp"
  end
  
  def deactivate
    # admin.tabs.remove "Rbac Page Edit"
  end
  
end