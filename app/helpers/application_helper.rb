module ApplicationHelper

  def team_logo(team)
    content_tag(:div, class: "team-logo") do
      image_tag("team_logos/#{team.abbr}.png") +
      content_tag(:span, team.full_name, class: "is-sr-only")
    end
  end

end
