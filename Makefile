# Makefile для k8s-controller

# Змінні
APP_NAME := k8s-controller
BINARY_NAME := controller
GO := go
GOFLAGS := -v
GOCMD := $(GO) $(GOFLAGS)
GOBUILD := $(GOCMD) build
GOCLEAN := $(GOCMD) clean
GOTEST := $(GOCMD) test
GOGET := $(GOCMD) get
GOCOVER := $(GOCMD) tool cover
GOLINT := golangci-lint
DOCKER := docker
DOCKER_IMAGE := $(APP_NAME)
DOCKER_TAG := latest
DOCKER_BUILD := $(DOCKER) build
DOCKER_PUSH := $(DOCKER) push

# Шляхи
SRC_DIRS := ./cmd ./pkg
MAIN_FILE := main.go
COVERAGE_FILE := coverage.out
COVERAGE_XML := coverage.xml

# Цілі
.PHONY: all build clean test coverage lint docker-build docker-push help

all: clean lint test build

# Збірка бінарного файлу
build:
	@echo "Збірка $(APP_NAME)..."
	$(GOBUILD) -o $(BINARY_NAME) $(MAIN_FILE)

# Очищення артефактів збірки
clean:
	@echo "Очищення..."
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
	rm -f $(COVERAGE_FILE)
	rm -f $(COVERAGE_XML)

# Запуск тестів
test:
	@echo "Запуск тестів..."
	$(GOTEST) -v ./...

# Генерація звіту про покриття коду тестами
coverage:
	@echo "Генерація звіту про покриття коду..."
	$(GOTEST) -coverprofile=$(COVERAGE_FILE) ./...
	$(GOCOVER) -func=$(COVERAGE_FILE)
	$(GOCOVER) -html=$(COVERAGE_FILE)

# Генерація XML-звіту про покриття коду для CI систем
coverage-xml:
	@echo "Генерація XML-звіту про покриття коду..."
	$(GOTEST) -coverprofile=$(COVERAGE_FILE) ./...
	$(GOCOVER) -func=$(COVERAGE_FILE)
	gocov convert $(COVERAGE_FILE) | gocov-xml > $(COVERAGE_XML)

# Перевірка коду лінтером
lint:
	@echo "Перевірка коду лінтером..."
	$(GOLINT) run ./...

# Збірка Docker-образу
docker-build:
	@echo "Збірка Docker-образу..."
	$(DOCKER_BUILD) -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

# Публікація Docker-образу
docker-push:
	@echo "Публікація Docker-образу..."
	$(DOCKER_PUSH) $(DOCKER_IMAGE):$(DOCKER_TAG)

# Допомога
help:
	@echo "Доступні команди:"
	@echo "  make all          - Очистити, перевірити лінтером, запустити тести та зібрати проект"
	@echo "  make build        - Зібрати бінарний файл"
	@echo "  make clean        - Очистити артефакти збірки"
	@echo "  make test         - Запустити тести"
	@echo "  make coverage     - Згенерувати звіт про покриття коду тестами"
	@echo "  make coverage-xml - Згенерувати XML-звіт про покриття коду для CI систем"
	@echo "  make lint         - Перевірити код лінтером"
	@echo "  make docker-build - Зібрати Docker-образ"
	@echo "  make docker-push  - Опублікувати Docker-образ"
	@echo "  make help         - Показати цю довідку"