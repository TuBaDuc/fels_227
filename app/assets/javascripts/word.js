var ready = function () {
  $("#new_word, .edit_word").submit(function () {
    if ($('input:checkbox:checked').length === 0) {
      alert("Please choose a correct answer")
      return false
    }
    return true
  })
  make_radio_from_checkbox()
  $("body").on("DOMNodeInserted", function () {
    make_radio_from_checkbox()
  })
}

function make_radio_from_checkbox () {
  $(".answer_field").click(function () {
    $(".answer_field").not(this).attr("checked", false)
  })
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1")
  var parent = $(link).parents(".fields")
  parent.hide()
  parent.find("input:checkbox").prev().val(false)
}

function add_fields(link, association, content) {
  answer_count = $(".answer_field:visible").size();
  answer_limit = $("#max_answer").val()
  if (answer_count >= answer_limit) {
    alert("You have too much answers!")
    return false
  }
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id))
}

$(document).ready(ready)
$(document).on("page:load", ready)
