$(document).ready(function() {
    $("input.button").click(function() {
	var nickname = $(".nickname").val();
	var commentContent = $("#comment-body").val();
	if($.trim(nickname) == "" || $.trim(commentContent) == "") {
	    return false;
	}
	$.ajax({
	    url: "/comments.json",
	    type: "POST",
	    dataType: "json",
	    data: JSON.stringify({
		domain: Commentary.domain,
		document_path: Commentary.documentPath,
		nickname: nickname,
		content: commentContent
	    })
	}).done(function(comment) {
	    console.log("Created comment");
	    console.log(comment);
	}).error(function(error) {
	    console.log(error);
	});
    });
});
