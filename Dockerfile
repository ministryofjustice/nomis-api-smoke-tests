FROM ruby:2.3.0

# This is our workdir
ENV WD=/usr/src/app
WORKDIR ${WD}

RUN mkdir -p ${WD}

ADD . ${WD}

RUN gem install bundler && bundle install -j 5

