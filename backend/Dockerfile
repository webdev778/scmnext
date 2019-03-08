FROM ruby:2.6

RUN apt-get update \
  && apt-get -y install libmysqlclient-dev \
  && apt-get -y install build-essential \
  && apt-get -y install ruby ruby-dev \
  && apt-get -y install graphviz

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install

COPY . .
# RUN rails assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
