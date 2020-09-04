workspace "Product Research" "Sellers are looking to find products that already sell well on Amazon." {
    model {
        portalSoftwareSystem = softwareSystem "Portal" "Amazon Software Tool." "Portal"
        scrapeySoftwareSystem = softwareSystem "Scrapey Service" "Scrapes amazon." "Scrapey" {
            scrapeyAPIContainer = container "API" "Provides JSON/HTTPS API." "Go" {
                scrapeyHealthAPIComponent = component "Health" "Handles health checks."
            }
            scrapeyWorkerContainer = container "Worker" "Handles AMQP." "Go" {
                scrapeyCatecoryWorkerComponent = component "Category" "Handles the category pages."
                scrapeyProductWorkerComponent = component "Product" "Handles the product pages."
            }
            scrapeyAMQPContainer = container "AMQP" "Events for scraped pages." "RabbitMQ" "Database"
        }
        amazonSoftwareSystem = softwareSystem "Amazon Service" "Amazon MWS API" "Amazon" {
            amazonAPIContainer = container "API" "Provides JSON/HTTPS API." "Ruby" {
                amazonHealthAPIComponent = component "Health" "Handles health checks."
            }
            amazonWorkerContainer = container "Worker" "Handles AMQP." "Ruby" {
                amazonProductWorkerComponent = component "Product" "Handles product MWS."
            }

            amazonAMQPContainer = container "AMQP" "Events for data retrieved." "RabbitMQ" "Database"
        }
        researchSoftwareSystem = softwareSystem "Research Service" "Up to date list of as many of the top selling amazon products" "Research" {
            researchAPIContainer = container "API" "Provides JSON/HTTPS API." "Go" {
                researchHealthAPIComponent = component "Health" "Handles health checks."
                researchProductAPIComponent = component "Product" "Filter best selling products."
            }
            researchWorkerContainer = container "Worker" "Handles AMQP." "Go" {
                researchProductWorkerComponent = component "Product" "Handles product MWS."
            }

            researchDatabaseContainer = container "Database" "Stores products." "PostgreSQL" "Database"
            researchAMQPContainer = container "AMQP" "Events from other services." "RabbitMQ" "Database"
        }
        mwsSoftwareSystem = softwareSystem "Amazon MWS" "Amazon MWS." "MWS"
        sentrySoftwareSystem = softwareSystem "Sentry" "Shared application monitoring." "Sentry"
        newRelicSoftwareSystem = softwareSystem "New Relic" "APM Solution." "NewRelic"
        scrapingHubSoftwareSystem = softwareSystem "Scraping Hub" "Complete Web Data Extraction." "ScrapingHub"
        logEntriesSoftwareSystem = softwareSystem "Log Entries" "Live Log Management and Analytics." "LogEntries"

        portalSoftwareSystem -> researchSoftwareSystem "Filter products." "HTTPS"
        researchSoftwareSystem -> scrapeySoftwareSystem "Find all best selling products." "AMQP"
        scrapeySoftwareSystem -> scrapeySoftwareSystem "All products from catergories." "AMQP"
        scrapeySoftwareSystem -> researchSoftwareSystem "Best selling products." "AMQP"
        scrapeySoftwareSystem -> scrapingHubSoftwareSystem "Get amazon HTML pages." "HTTPS"
        amazonSoftwareSystem -> researchSoftwareSystem "Best selling products." "AMQP"
        amazonSoftwareSystem -> mwsSoftwareSystem "Best selling products through MWS" "HTTPS"
        researchSoftwareSystem -> sentrySoftwareSystem "Sends critical failure alerts." "HTTPS" "Asynchronous, Alert"
        researchSoftwareSystem -> newRelicSoftwareSystem "Sends diagnostic information." "HTTPS" "Asynchronous, Alert"
        researchSoftwareSystem -> logEntriesSoftwareSystem "Sends logs." "TCP"
        newRelicSoftwareSystem -> researchSoftwareSystem "Health checks." "HTTPS"
        scrapeySoftwareSystem -> sentrySoftwareSystem "Sends critical failure alerts." "HTTPS" "Asynchronous, Alert"
        scrapeySoftwareSystem -> newRelicSoftwareSystem "Sends diagnostic information." "HTTPS" "Asynchronous, Alert"
        scrapeySoftwareSystem -> logEntriesSoftwareSystem "Sends logs." "TCP"
        newRelicSoftwareSystem -> scrapeySoftwareSystem "Health checks." "HTTPS"
        amazonSoftwareSystem -> sentrySoftwareSystem "Sends critical failure alerts." "HTTPS" "Asynchronous, Alert"
        amazonSoftwareSystem -> newRelicSoftwareSystem "Sends diagnostic information." "HTTPS" "Asynchronous, Alert"
        amazonSoftwareSystem -> logEntriesSoftwareSystem "Sends logs." "TCP"
        newRelicSoftwareSystem -> amazonSoftwareSystem "Health checks." "HTTPS"

        scrapeyWorkerContainer -> scrapeyAMQPContainer "Category in region." "AMQP"
        scrapeyWorkerContainer -> scrapeyAMQPContainer "Product in region." "AMQP"
        scrapeyWorkerContainer -> scrapingHubSoftwareSystem "Amazon pages" "HTTPS"
        researchAPIContainer -> researchDatabaseContainer "Get products." "TCP"
        researchWorkerContainer -> researchDatabaseContainer "Save products." "TCP"
        researchWorkerContainer -> researchAMQPContainer "Best selling products." "AMQP"
        amazonWorkerContainer -> amazonAMQPContainer "Best selling products." "AMQP"
        amazonWorkerContainer -> mwsSoftwareSystem "Product API." "HTTPS"
    }
    views {
        systemContext scrapeySoftwareSystem "ScrapeySystemContext" {
            include *
            autoLayout
        }

        container scrapeySoftwareSystem "ScrapeyContainers" {
            include *
            autoLayout
        }

        component scrapeyAPIContainer "ScrapeyComponentsAPI" {
            include *
            autoLayout
        }

        component scrapeyWorkerContainer "ScrapeyComponentsWorker" {
            include *
            autoLayout
        }

        systemContext amazonSoftwareSystem "AmazonSystemContext" {
            include *
            autoLayout
        }

        container amazonSoftwareSystem "AmazonContainers" {
            include *
            autoLayout
        }

        component amazonAPIContainer "AmazonComponentsAPI" {
            include *
            autoLayout
        }

        component amazonWorkerContainer "AmazonComponentsWorker" {
            include *
            autoLayout
        }

        systemContext researchSoftwareSystem "ResearchSystemContext" {
            include *
            autoLayout
        }

        container researchSoftwareSystem "ResearchContainers" {
            include *
            autoLayout
        }

        component researchAPIContainer "ResearchComponentsAPI" {
            include *
            autoLayout
        }

        component researchWorkerContainer "ResearchComponentsWorker" {
            include *
            autoLayout
        }

        styles {
            element "Software System" {
                background #810000
                color #ffffff
                shape RoundedBox
            }
            element "Container" {
                background #b52b65
                color #ffffff
            }
            element "Component" {
                background #d54062
                color #ffffff
                shape Component
            }
            element "Portal" {
                background #776D5A
                color #ffffff
            }
            element "Scrapey" {
                background #987D7C
                color #ffffff
            }
            element "Amazon" {
                background #A09CB0
                color #ffffff
            }
            element "Research" {
                background #A3B9C9
                color #ffffff
            }
            element "MWS" {
                background #49306B
                color #ffffff
            }
            element "Sentry" {
                background #635380
                color #ffffff
            }
            element "NewRelic" {
                background #90708C
                color #ffffff
            }
            element "ScrapingHub" {
                background #ACE4AA
                color #ffffff
            }
            element "LogEntries" {
                background #56E39F
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            relationship "Relationship" {
                dashed false
            }
            relationship "Asynchronous" {
                dashed true
            }
            relationship "Alert" {
                color #ff0000
            }
       }

       themes https://static.structurizr.com/themes/kubernetes-v0.3/theme.json https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }
}
