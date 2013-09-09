$(document).ready(function() {
    var resize = function() {
	var height = $("html").height();
	window.parent.postMessage(['setHeight', height], '*');
    };

    var showComments = function() {
	$.ajax({
	    url: "/comments.json",
	    type: "GET",
	    dataType: "json",
	    data: {
		domain: Commentary.domain,
		document_path: Commentary.documentPath
	    }
	}).done(function(comments) {
	    $('.comments .display .single-comment').remove();
	    $('.comments .display').append("<div>");
	    comments.forEach(function(comment) {
		var commentDiv = $("<div>");
		commentDiv.attr("class", "single-comment");

		var nickname = $("<div>");
		nickname.attr("class", "nickname");
		nickname.text(comment.nickname);
		commentDiv.append(nickname);

		var timeStamp = $("<div>");
		timeStamp.attr("class", "timestamp");
		timeStamp.text(comment.timestamp);
		commentDiv.append(timeStamp);

		var commentBody = $("<div>");
		commentBody.attr("class", "comment-body");
		commentBody.text(comment.content);
		commentDiv.append(commentBody);

		$('.comments .display').append(commentDiv);
	    });
	    resize();
	});
	resize();
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
	    showComments();
	}).error(function(error) {
	    console.log(error);
	    showComments();
	});
    });
    showComments();
});
