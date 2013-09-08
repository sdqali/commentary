$(document).ready(function() {
    var resize = function() {
	var height = $("html").height();
	window.parent.postMessage(['setHeight', height], '*');
    };

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
	    $(".nickname").val("");
	    $("#comment-body").val("");
	    console.log(comment);
	}).error(function(error) {
	    console.log(error);
	});
    });

    resize();
});
