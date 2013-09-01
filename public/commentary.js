Commentary = {
    initialize: function(commentaryUrl, selector) {
	$(document).ready(function() {
	    var commentFrame = $("<iframe>");
	    var frameUrl = commentaryUrl.concat("/comment_frame")
		.concat("?domain=").concat(window.location.host)
		.concat("&document_path=").concat(window.location.pathname);
	    commentFrame.attr("src", frameUrl);
	    $(selector).append(commentFrame);
	});
    }
};

(function() {
    console.log("Commentary.js loaded")
})();
