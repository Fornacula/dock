FROM ruby:2.7.1

# Nodejs must be installed separately for rails to work out of the box
RUN apt-get update -qq && apt-get install -y nodejs

RUN gem install rails

# Copy the application directory in your localhost as the
# default work-dir in docker container.
COPY . /dock

# Set the default working directory.
WORKDIR /dock

# Install rails libraries (install everything that is noted down
# in Gemfile).
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

# The EXPOSE instruction informs Docker that the container listens
# on the specified network ports at runtime. You can specify
# whether the port listens on TCP or UDP, and the default is TCP
# if the protocol is not specified.
# Look more at https://docs.docker.com/engine/reference/builder/#expose
EXPOSE 3000

# Start the main process: bind the rails server to 0.0.0.0 address
# in the container
CMD ["rails", "server", "-b", "0.0.0.0"]