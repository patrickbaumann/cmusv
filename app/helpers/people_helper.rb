module PeopleHelper

def display_location(person)
  return nil if (person.work_city.nil? && person.work_state.nil? && person.work_country.nil?)
  return "#{person.work_state} #{person.work_country}" if person.work_city.nil?
  return "#{person.work_city}, #{person.work_state} #{person.work_country}"

end

def image_path(person)
  if (person.profile_pic_file_name.nil?)
    return person.image_uri
  else
    return person.profile_pic.url
  end
end

end
