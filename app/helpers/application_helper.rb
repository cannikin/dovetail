# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current_path?(class_name='active',values={})
    params.has_at_least? values
  end

end
