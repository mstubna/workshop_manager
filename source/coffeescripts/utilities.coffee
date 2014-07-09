class @Utilities

  # Toggles a class based on the condition argument
  add_remove_class: (jquery_obj, class_name, condition) ->
    if condition
      jquery_obj.addClass class_name
    else
      jquery_obj.removeClass class_name
    return

  # finds the object in the array which has a property matching the value
  find_object_matching: (array, property, value) ->
    return null unless array?.length > 0 and property? and value?
    for obj in array
      return obj if obj[property] is value
