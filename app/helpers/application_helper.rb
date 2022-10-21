module ApplicationHelper

  def admin_signed_in?
    if user_signed_in? and current_user.admin?
      true
    else
      false
    end
  end

  def smart_link_to(*args, &block)
    if block_given?
      options = args[0] || {}
      html_options = args[1]
      caption = capture(&block)
    else
      caption = args[0]
      options = args[1] || {}
      html_options = args[2]
    end
    html_options ||= {}
    li_options = html_options.delete(:wrapper_options) || {}
    url = String === options ? options : url_for(options)
    pattern = html_options.delete(:pattern) || Regexp.new("^#{url}")
    path = request.path
    if path =~ pattern
      li_options[:class].present? ? li_options[:class] += " active" : li_options[:class] = "active"
    end
    content_tag :li, li_options do
      link_to caption, options, html_options
    end
  end

  def check_nil val, ext = nil, slice = false
    chk_val = slice ? val[1..-1] : val
    chk_val.present? ? "#{val} #{ext}" : '–'
  end

  def find_discharge_status river, place = "list", mobile = false
    if river.discharge.to_i > 0
      val = river.discharge.to_i
      river = check_for_user_river river
      if river.conditions.present?
        t = if val >= river.conditions["high"].to_i
          "High"
        elsif val > river.conditions["low"].to_i
          "Good"
        else
          "Low"
        end
        get_condition_tag place, suggest_tag(river, t), t.downcase, mobile
      else
        get_condition_tag place, suggest_tag(river, "Edit"), nil, mobile
      end
    else
      get_condition_tag place, '–', nil, mobile
    end
  end

  def check_for_user_river river
    # Checking if conditions is present in UsersRiver and if present we return UsersRiver instead of River
    return river unless user_signed_in?
    @users_rivers_ids = @users_rivers_ids || current_user.rivers.pluck(:id)
    if @users_rivers_ids.include?(river.id)
      @users_rivers = @users_rivers || current_user.users_rivers
      r = current_user.users_rivers.find_by_river_id(river.id)
      river = r if r.conditions.present?
    end
    river
  end

  def get_condition_tag place, text, extra_class = nil, mobile = false
    if place == "list"
      col = mobile ? "col3" : "col5"
      content_tag(:td, text, class: "#{col} #{extra_class}")
    else
      if mobile
        content_tag(:span, text, class: "#{extra_class}")
      else
        content_tag(:li, text, class: "suggest-condition #{extra_class}")
      end
    end
  end

  def suggest_tag river, text
    # If user is not logged in redirect to login page
    # If user is logged in add data-url to UsersRiver edit path with river id in it
    river_id = get_river_id river
    class_name = text == 'Edit' ? "btn small condition-modal" : "condition-modal"
    link = user_signed_in? ? "#" : new_user_session_path(redirect_to: request.path)
    data_url = user_signed_in? ? edit_users_river_path(river_id) : nil
    content_tag(:a, text, href: link, class: class_name, data: {url: data_url})
  end

  def get_river_id river
    # We need River ID here nor UsersRiver ID
    if river.class.name == "River"
      river.id
    else
      river.river.id
    end
  end

end
