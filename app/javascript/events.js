$("button.event").click(function(e) {
  e.preventDefault();
  var buttonValue = this.value;
  $.ajax({
    type: "POST",
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    url: "/event/create",
    data: { 
      event_name: buttonValue,
    },
    success: function(result) {
      alert(result.responseText);
    },
    error: function(result) {
      alert(result.responseText);
    }
  });
});