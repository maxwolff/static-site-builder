# Static site generator


Write a blog post in `/markdown`. Symbols transpiled into html are `#` for title, `##` for subheading, `*` for bullets. 

Generate static html with
* `elixir generate`

Push to gcloud bucket w: 
* `gsutil -m rsync -r ./static  gs://home-page-271200/static`

Visit at
`https://storage.cloud.google.com/home-page-271200/static/index.html`

TODO: 

* add inter-line html substitutions
* add styles
* improve html tags: attributes, p, div, instead of br
