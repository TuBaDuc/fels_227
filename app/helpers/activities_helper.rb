module ActivitiesHelper
  def link_to_activity activity_info
    activities = activity_info.split "|"
    content, url = activities[0].split ","
    activities_link = "<a href=\"#{url}\">#{content}</a>"
    if activities.size > 1
      next_activity = link_to_activity activities[1..-1].join("|")
      activities_link = "#{activities_link} #{I18n.t :of_text} #{next_activity}"
    end
    activities_link
  end
end
