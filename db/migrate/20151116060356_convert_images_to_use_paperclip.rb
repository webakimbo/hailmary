class ConvertImagesToUsePaperclip < ActiveRecord::Migration
  def up
    add_attachment :users,  :avatar
    add_attachment :groups, :avatar
    add_attachment :teams,  :logo
  end

  def down
    remove_attachment :users,  :avatar
    remove_attachment :groups, :avatar
    remove_attachment :teams,  :logo
  end
end
