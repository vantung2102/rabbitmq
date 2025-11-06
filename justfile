default:
  @just --list --justfile {{justfile()}}

alias s := server
alias c := console

server:
  bundle exec rails s

console:
  bundle exec rails c

routes:
  bundle exec rails routes

migrate:
  bundle exec rails db:migrate

bundle-project:
  BUNDLE_GEMFILE=Gemfile bundle

bundle-local:
  BUNDLE_GEMFILE=Gemfile.local bundle

bundle-local-list:
  BUNDLE_GEMFILE=Gemfile.local bundle list

bundle:
  @just bundle-project
  @just bundle-local


