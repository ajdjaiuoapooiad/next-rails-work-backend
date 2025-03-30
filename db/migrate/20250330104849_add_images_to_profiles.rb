# db/migrate/YYYYMMDDHHMMSS_add_images_to_profiles.rb
class AddImagesToProfiles < ActiveRecord::Migration[7.2]
  def change
    # 必要に応じて、画像のパスを保存するカラムを追加
    add_column :profiles, :user_icon, :string
    add_column :profiles, :bg_image, :string
  end
end