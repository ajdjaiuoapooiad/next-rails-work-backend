# db/migrate/YYYYMMDDHHMMSS_add_image_urls_to_profiles.rb
class AddImageUrlsToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :user_icon_url, :string
    add_column :profiles, :bg_image_url, :string
  end
end