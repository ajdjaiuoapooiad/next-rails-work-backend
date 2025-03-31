# db/migrate/YYYYMMDDHHMMSS_remove_image_columns_from_profiles.rb
class RemoveImageColumnsFromProfiles < ActiveRecord::Migration[7.2]
  def change
    remove_column :profiles, :user_icon, :string
    remove_column :profiles, :bg_image, :string
  end
end