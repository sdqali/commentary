Commentary = {
    initialize: function(commentaryUrl, selector) {
	$(document).ready(function() {
	    $.ajax({
		url: commentaryUrl.concat("/comments.json"),
		type: "GET",
		dataType: "json",
		data: {domain: window.location.host, document_path: window.location.pathname}
	    }).done(function(comments) {
		console.log(comments);
		$(selector).append("<ul>");
		comments.forEach(function(comment) {
		    $(selector.concat(" ul")).append("<li>".concat(comment.content).concat("</li>"));
		});
	    });
	});
    }
};

(function() {
    console.log("Commentary.js loaded")
})();
