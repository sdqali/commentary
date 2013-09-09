$(document).ready(function() {
    var resize = function() {
	var height = $("html").height();
	window.parent.postMessage(['setHeight', height], '*');
    };

   var renderError = function(error) {
       var errorText = error.responseJSON.error;
       var errorDiv = $("<div>");
       errorDiv.text(errorText);
       errorDiv.css("font-weight", "bold");
       $('.comments .display').append(errorDiv);
   }

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
	}).error(function(error) {
	    renderError(error);
	    resize();
	});
	resize();
    };

    $("input.button").click(function() {
	var loader = $("img.loader");
	loader.css("display", "inline");
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
	    loader.css("display", "none");
	}).error(function(error) {
	    renderError(error);
	    loader.css("display", "none");
	    resize();
	});
    });
    showComments();
});
