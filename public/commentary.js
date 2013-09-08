Commentary = {
    initialize: function(commentaryUrl, selector) {
	var addCommentCreateFrame = function(commentaryUrl, selector) {
	    var commentFrame = $("<iframe>");
	    var frameUrl = commentaryUrl.concat("/comment_frame")
		.concat("?domain=").concat(window.location.host)
		.concat("&document_path=").concat(window.location.pathname);
	    commentFrame.attr("src",  frameUrl);
	    commentFrame.attr("style", "width: 100%; border: none; height: 200px");
	    commentFrame.attr("class", "commentary-frame");
	    commentFrame.attr("scrolling", "auto");
	    $(selector).append(commentFrame);
	};

	var wireUpMessages = function() {
	    window.addEventListener('message', function (e) {
		var $iframe = $('.commentary-frame');

		var eventName = e.data[0];
		var data      = e.data[1];

		switch (eventName) {
		case 'setHeight':
		    $iframe.height(data);
		    break;
		}
	    }, false);
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
		$(selector).append("<ul>");
		comments.forEach(function(comment) {
		    $("ul").append("<li>".concat(comment.content).concat("</li>"));
		});
	    });
	};

	showComments(commentaryUrl, selector);
	addCommentCreateFrame(commentaryUrl, selector);
	wireUpMessages();
    }
};

(function() {
    console.log("Commentary.js loaded")
})();
