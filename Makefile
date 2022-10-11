deploy:
		git push heroku
lint:
	  bundle exec rubocop && bundle exec slim-lint app/views/
install:
	  bundle && bundle exec rake assets:precompile
tests:
		bin/rails test
generate_env:
		cp .env.example .env