$(document).ready(function() {
    console.log("iframe loaded");
    $.ajax({
	url: "/comments.json",
	type: "GET",
	dataType: "json",
	data: {
	    domain: Commentary.domain,
	    document_path: Commentary.documentPath
	}
    }).done(function(comments) {
	$('body').append("<ul>");
	comments.forEach(function(comment) {
	    $("ul").append("<li>".concat(comment.content).concat("</li>"));
	});
    });
});
