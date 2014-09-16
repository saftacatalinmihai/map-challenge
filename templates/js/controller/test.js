
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
  		alert(data);
  	})
  })
});
