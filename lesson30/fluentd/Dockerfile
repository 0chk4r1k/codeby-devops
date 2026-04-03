FROM fluent/fluentd:v1.19-1

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN gem install elasticsearch -v 7.6 \
    && gem install fluent-plugin-elasticsearch \
    && gem install fluent-plugin-grok-parser \
    && gem sources --clear-all \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

USER fluent
