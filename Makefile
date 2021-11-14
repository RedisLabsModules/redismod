
SHELL:=$(shell sh -c "command -v bash")

define HELPTEXT
make build    # Build container
  FRESH=1|0     # always fetch images from Dockerhub
  OFFICIAL=1    # create redislabs/redismod image
make edge     # Like: make build EDGE=1
make preview  # Like: make build PREVIEW=1
make latest   # Like: make build LATEST=1

make run      # Run selected container
make up       # Build and start docker-compose containers
  VERBOSE=1     # Show output from containers (no daemon mode)
make down     # Stop docker-compose containers
make clean    # Remove docker-compose containers

make publish  # Push redislabs/redismod images (requires OFFICIAL=1)

make test     # Test with redis-py

Version selectors:
EDGE=1        # redismod:edge (latest commit on master)
PREVIEW=1     # redismod:preview (latest commit latest integration branch)
LATEST=1      # redismod:latest (last released version)

endef

#----------------------------------------------------------------------------------------------

ifeq ($(OFFICIAL),1)
STEM=redislabs/redismod
else
STEM=redismod
endif

BUILD_ARGS=

FRESH ?= 1
ifeq ($(FRESH),1)
BUILD_ARGS += --no-cache --pull
endif

ifeq ($(EDGE),1)
VARIANT=edge
else ifeq ($(PREVIEW),1)
VARIANT=preview
else ifeq ($(LATEST),1)
VARIANT=latest
else
VARIANT=edge
# $(error Unknown VARIANT)
endif

define build # (1=VARIANT)
@docker build $(BUILD_ARGS) -t $(STEM):$1 -f Dockerfile.$1 --build-arg VARIANT=$1 .
endef

#----------------------------------------------------------------------------------------------

.PHONY: all build edge preview latest run publish up down clean test help

all: build

build:
	$(call build,$(VARIANT))

edge:
	$(call build,edge)

preview:
	$(call build,preview)

latest:
	$(call build,latest)

#----------------------------------------------------------------------------------------------

run:
	@docker run $(STEM):$(VARIANT)

REDIS_HOST?=localhost

test:
	@set -e ;\
	if [ ! -d venv ]; then \
		if [ ! -d redis-py ]; then \
			git clone https://github.com/redis/redis-py.git ;\
		fi ;\
		python3 -m virtualenv venv ;\
		. ./venv/bin/activate ;\
		(cd redis-py; python -m pip setup.py install;) ;\
		python -m pip install -r pytest/dev_requirements.txt ;\
	else \
		. ./venv/bin/activate ;\
	fi ;\
	(cd redis-py; pytest --redis-url redis://$(REDIS_HOST):6379 --redismod-url redis://$(REDIS_HOST):6379)

#----------------------------------------------------------------------------------------------

ifeq ($(OFFICIAL),1)
publish:
	@docker push $(STEM):$(VARIANT)
endif

#----------------------------------------------------------------------------------------------

COMPOSE_ARGS=-f docker-compose.$(VARIANT).yml

up:
ifeq ($(VERBOSE),1)
	@docker-compose $(COMPOSE_ARGS) up
else
	@docker-compose $(COMPOSE_ARGS) up -d
endif

down:
	@docker-compose $(COMPOSE_ARGS) down -v --remove-orphans

clean:
	@docker-compose $(COMPOSE_ARGS) down -v --remove-orphans --rmi all

#----------------------------------------------------------------------------------------------

ifneq ($(filter help,$(MAKECMDGOALS)),)
HELPFILE:=$(shell mktemp /tmp/make.help.XXXX)
endif

help:
	$(file >$(HELPFILE),$(HELPTEXT))
	@echo
	@cat $(HELPFILE)
	@echo
	@-rm -f $(HELPFILE)

