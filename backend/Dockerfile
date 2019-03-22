FROM ruby:2.5.1

ARG RAILS_ENV
ENV DEBIAN_FRONTEND noninteractive

# タイムゾーンをAsia/Tokyoに
RUN timedatectl set-timezone Asia/Tokyo

RUN apt-get update \
  && apt-get -y install apt-utils \
  && apt-get -y install build-essential \
  && apt-get -y install ruby ruby-dev
#  && apt-get -y install graphviz
#  && apt-get -y install libmysqlclient-dev \

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler -v=1.7.2
RUN bundle install

COPY . .
# RUN rails assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
