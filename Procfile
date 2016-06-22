web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker:      QUEUES=default,paperclip,mailers bundle exec rake jobs:work
css_compile: QUEUE=css_compile bundle exec rake jobs:work
