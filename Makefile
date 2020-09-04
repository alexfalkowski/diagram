-include .env

clean-setup:
	rm -rf bin

setup-bin: clean-setup
	mkdir -p bin

setup-cli: setup-bin ## Install the structurizr tool
	curl -o structurizr-cli.zip -L https://github.com/structurizr/cli/releases/download/v1.3.1/structurizr-cli-1.3.1.zip
	unzip -o structurizr-cli.zip -d bin
	rm -f structurizr-cli.zip

setup-plantuml: setup-bin ## Install the mermaid tool
	curl -o bin/plantuml.jar -L https://netix.dl.sourceforge.net/project/plantuml/plantuml.jar

setup: setup-cli setup-plantuml ## Install all the tools

clean: ## Clean all files
	rm -rf structurizr/**/*.png
	rm -rf structurizr/**/*.puml

generate-plantuml: ## Generate plantuml diagram
	bin/structurizr.sh export -workspace structurizr/$(type)/main.dsl -format plantuml

generate-image: ## Generate diagram image
	java -Djava.awt.headless=true -jar bin/plantuml.jar -progress -o . structurizr/$(type)/*.puml

generate: clean generate-plantuml generate-image ## Generate diagram

publish: ## Publish workspace to structurizr
	bin/structurizr.sh push -id ${STRUCTURIZR_WORKSPACE_ID} -key ${STRUCTURIZR_KEY} -secret ${STRUCTURIZR_SECRET} -workspace connect.dsl
