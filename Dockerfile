FROM ruby:2.4.2-jessie

ADD . /var/www

WORKDIR /var/www
RUN bundle install

EXPOSE 4567

CMD ['ruby ./app.rb']