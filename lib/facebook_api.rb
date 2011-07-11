class FacebookAPI
  def get_login_link
    MiniFB.oauth_url(FB_APP_ID, redirect_url, :scope=>FB_PERMS)
  end

  def get_access_token code
    access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, redirect_url, FB_SECRET, code)
    access_token_hash['access_token']
  end

  def get_my_info access_token
    MiniFB.get(access_token, "me", :type=>nil)
  end

  def get_my_friends_info access_token
    friends_data = MiniFB.get(access_token, "me", :type=>"friends")
    friend_ids = friends_data.data.collect {|friend_data| friend_data.id}
    friends_info = MiniFB.fql(access_token, "SELECT uid, name, pic_square, profile_url, pic, sex, current_location, birthday, birthday_date, relationship_status FROM user where uid IN (#{friend_ids.join(',')})")

    friends_info.each do |f|
      f.gender = Gender.find_by_gender_or_get_none f.sex
      if f.current_location.nil?
        f.location = nil
      else
        f.location = f.current_location.name
      end

      if f.birthday_date
        begin
          f.birthday = DateTime.strptime f.birthday_date, "%m/%d/%Y"
        rescue ArgumentError
          f.birthday = nil
        end
      else
        f.birthday = nil
      end

      if f.relationship_status.blank?
        f.relationship_status = 'Unknown'
      end
    end
  end

  def get_family_info access_token, user
    MiniFB.fql access_token, "SELECT uid FROM family where profile_id = #{user.fbid}"
  end

  private
  def redirect_url
    "http://#{HOST_NAME}/login"
  end

end
