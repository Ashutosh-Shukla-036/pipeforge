COMPOSE=docker compose

# CORE
up:                                              ## Start all services
	$(COMPOSE) up -d --build 					
down:                                            ## Stop all services
	$(COMPOSE) down           					
restart:                                         ## Restart all services
	$(COMPOSE) down && $(COMPOSE) up -d --build  
rebuild:                                         ## Force rebuild all services
	$(COMPOSE) up -d --build --force-recreate    

# LOGS
logs:
	$(COMPOSE) logs -f 
logs-worker:
	$(COMPOSE) logs -f worker
logs-redis:
	$(COMPOSE) logs -f redis
logs-postgres:
	$(COMPOSE) logs -f postgres
logs-api:
	$(COMPOSE) logs -f api

# DATABASE	
psql:
	$(COMPOSE) exec postgres psql -U pipeforge_user -d pipeforge_db
db-shell:
	$(COMPOSE) exec postgres bash

# REDIS
redis-cli:
	$(COMPOSE) exec redis redis-cli
redis-monitor:
	$(COMPOSE) exec redis redis-cli monitor

# CONTAINER SHELL
shell-worker:
	$(COMPOSE) exec worker bash
shell-api:
	$(COMPOSE) exec api bash

# CLEANUP
clean:
	$(COMPOSE) down -v

prune:
	docker system prune -force

ps:                                     ## Show running containers and their status
	$(COMPOSE) ps

help:                                   ## Show all available make commands
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
