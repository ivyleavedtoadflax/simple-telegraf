PWD = $(shell pwd)

all: telegraf.conf telegraf

telegraf.conf: telegraf.template.conf .envrc Makefile
	echo "Creating telegraf.conf file"; \
	sed -e "s/\$${DATABASE}/$(DATABASE)/" \
	-e "s%\$${INFLUXDB_HOST}%$(INFLUXDB_HOST)%" \
	-e "s/\$${INFLUXDB_PORT}/$(INFLUXDB_PORT)/" \
	telegraf.template.conf > telegraf.conf

telegraf:
	sudo docker run \
	-d --restart unless-stopped \
	-v $(PWD)/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
	--name telegraf \
	-it telegraf:latest

clean:
	-sudo docker stop telegraf && \
	sudo docker rm telegraf;

help:
	@cat Makefile

.PHONY: clean help
