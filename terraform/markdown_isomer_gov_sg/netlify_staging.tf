# Notes:
# Netlify staging site for markdown.isomer.gov.sg
# Netlify deploy key name convention: isomer_staging_deploy_key_[url_in_underscore]
# Netlify site name convention: isomer_staging_netlify_site_[url_in_underscore]

resource "netlify_deploy_key" "isomer_staging_deploy_key_markdown_isomer_gov_sg" {}

resource "netlify_site" "isomer_staging_netlify_site_markdown_isomer_gov_sg" {
  name = "markdown-isomer-gov-sg-staging"

  repo {
    command       = "bundle exec jekyll build"
    deploy_key_id = "${netlify_deploy_key.isomer_staging_deploy_key_markdown_isomer_gov_sg.id}"
    dir           = "_site/"
    provider      = "github"
    repo_path     = "isomerpages/markdown-helper"
    repo_branch   = "staging"
  }
}