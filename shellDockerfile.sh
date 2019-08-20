apt --fix-broken install && apt-get -qq update && apt-get install -qq -y --no-install-recommends \
    ca-certificates \
    curl \
    gawk \
    libexpat1 \
    libpq5 \
    mysql-client \
    nginx \
    python \
    python-setuptools \
    python-pip \
    python-crypto \
    python-flask \
    python-pil \
    python-mysqldb \
    unixodbc \
    uwsgi \
    uwsgi-plugin-python \
&& pip install -q natsort

wget http://repo.mysql.com/apt/debian/pool/mysql-5.6/m/mysql-community/libmysqlclient18_5.6.45-1debian9_amd64.deb && dpkg -i libmysqlclient18_5.6.45-1debian9_amd64.deb && rm libmysqlclient18_5.6.45-1debian9_amd64.deb
echo exit 0 > /usr/sbin/policy-rc.d

curl -s \
    http://sphinxsearch.com/files/sphinxsearch_2.2.11-release-1~jessie_amd64.deb \
    -o /tmp/sphinxsearch.deb \
&& dpkg -i /tmp/sphinxsearch.deb \
&& rm /tmp/sphinxsearch.deb \
&& easy_install -q flask-cache \
&& pip install -q supervisor \
&& mkdir -p /var/log/sphinxsearch \
&& mkdir -p /var/log/supervisord

#VOLUME ["/data/"]
mkdir /etc/supervisor
mkdir /etc/supervisor/conf.d

cp conf/sphinx/*.conf /etc/sphinxsearch/
cp conf/nginx/nginx.conf /etc/nginx/sites-available/default
cp supervisor/*.conf /etc/supervisor/conf.d/
cp supervisord.conf /etc/supervisor/supervisord.conf
cp -r web /usr/local/src/websearch
cp sphinx-reindex.sh /
mkdir /tests
cp -r  tests/* /tests/

export SPHINX_PORT=9312 \
    SEARCH_MAX_COUNT=100 \
    SEARCH_DEFAULT_COUNT=20

echo "FINSIH"
#EXPOSE 80
#to run 
#/usr/local/bin/supervisord -c /etc/supervisor/supervisord.conf
