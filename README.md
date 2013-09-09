# Commentary

Add comments to your blog.

## Setup
* Edit `config/production.yml` to add your site. Specify a name and the domain where the site will be hosted. Example configuration will be like this:

```
name: Blog
domain: blog.sdqali.in
```

* Run `RACK_ENV=production setup.rb`
* Start the server with `RACK_ENV=production app.rb`
* Add the following to your HTML pages or templates. `selector` is the CSS selector for the DOM element where comments will be rendered.

```html
<script type="text/javascript" src="<server>/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="<server>//commentary.js"></script>
<script type="text/javascript">
   $(document).ready(function() {
      Commentary.initialize("<server>", "<selector>");
   });
</script>

```