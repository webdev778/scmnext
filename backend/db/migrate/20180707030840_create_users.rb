class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, comment: "ユーザー" do |t|
      ## Required
      t.string :provider, :null => false, :default => "email",
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :email,              null: false, default: "", comment: "E-Mail"
      t.string :encrypted_password, null: false, default: "", comment: "パスワード(暗号化済)"

      ## Recoverable
      t.string   :reset_password_token, comment: "パスワードリセット時トークン"
      t.datetime :reset_password_sent_at, comment: "パスワードリセット要求日時"

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false, comment: "サインイン回数"
      t.datetime :current_sign_in_at, comment: "現在サインイン日時"
      t.datetime :last_sign_in_at, comment: "最終サインイン日時"
      t.string   :current_sign_in_ip, comment: "現在サインインIPアドレス"
      t.string   :last_sign_in_ip, comment: "最終サインインIPアドレス"

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Tokens
      t.text :tokens

      t.references "accesable", polymorphic: true, index: true
      t.stamp_fileds
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, [:uid, :provider],     unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true

  end
end
