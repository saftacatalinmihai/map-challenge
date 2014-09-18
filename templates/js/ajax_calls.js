
$(document).ready(function(){
  $("button").click(function(){
    $.ajax({url:"get_places",success:function(result){
      alert(result);
    }});
  });

  $('#submitter').on('click', function(e) {
  	e.preventDefault();
  	var data = $('#form').serialize();
  	var url = $('#form').attr('action');
  	$.ajax({
  		url: url,
  		data: data,
  		type: 'POST',
  	}).done(function(data) {
  		location.reload();
  	})
  })
});

function ajax_add_place(data, callback){
  var url = 'add_place';
  
  $.ajax({
      url: url,
      data: data,
      type: 'POST',
    }).done(function(data) {
      console.log("Data sent, running callback");
      callback();
  })
}