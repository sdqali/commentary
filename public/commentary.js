Commentary = {
    initialize: function(commentaryUrl, selector) {
	var addCommentCreateFrame = function(commentaryUrl, selector) {
	    var commentFrame = $("<iframe>");
	    var frameUrl = commentaryUrl.concat("/comment_frame")
		.concat("?domain=").concat(window.location.host)
		.concat("&document_path=").concat(window.location.pathname);
	    commentFrame.attr("src", frameUrl);
	    commentFrame.attr("style", "width: 100%; border: none");
	    commentFrame.attr("class", "commentary-frame");
	    commentFrame.attr("scrolling", "auto");
	    $(selector).append(commentFrame);
	};

	var showComments = function(commentaryUrl, selector) {
	    $.ajax({
		url: commentaryUrl.concat("/comments.json"),
		type: "GET",
		dataType: "json",
		data: {
		    domain: window.location.host,
		    document_path: window.location.pathname
		}
	    }).done(function(comments) {
		$('body').append("<ul>");
		comments.forEach(function(comment) {
		    $("ul").append("<li>".concat(comment.content).concat("</li>"));
		});
	    });
	};

	$(document).ready(function() {
	    showComments(commentaryUrl, selector);
	    addCommentCreateFrame(commentaryUrl, selector);
	});
    }
};

(function() {
    console.log("Commentary.js loaded")
})();
