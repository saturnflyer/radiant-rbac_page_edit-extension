namespace :radiant do
  namespace :extensions do
    namespace :rbac_page_edit do
      
      desc "Runs the migration of the Rbac Page Edit extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          RbacPageEditExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          RbacPageEditExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Rbac Page Edit to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[RbacPageEditExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(RbacPageEditExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
