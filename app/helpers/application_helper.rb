module ApplicationHelper
  include Pagy::Frontend

  def profile_avatar_select(user, size = :small)
    image = if user.profile_picture.attached?
      user.profile_picture
    else
      "/icon.png"
    end
    size = case size
    when :small
      "width: 200px; height: 200px; object-fit: cover;"
    when :medium
      "width: 300px; height: 300px; object-fit: cover;"
    when :xs
      "width: 30px; height: 30px; object-fit: cover;"

    end

    image_tag(image, class: "rounded-circle border", style: size)
  end
end
