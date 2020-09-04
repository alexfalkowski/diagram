workspace "Connect" "As Gelato is growing its Network, we are more and more getting in contact with situations where our Gelato workflow with ready-to-print files is not the optimal solution for sending orders to partners." {
    model {
        networkSoftwareSystem = softwareSystem "Network Service" "Creates orders and receives updates." "Network"
        connectSoftwareSystem = softwareSystem "Connect Service" "Handle orders for parners." "Connect" {
            apiContainer = container "API" "Provides JSON/HTTPS API." "Go with Go-kit" {
                connectAPIComponent = component "Connect" "Handles subscribe webhooks." "conx package"
                partnerAPIComponent = component "Partner" "Handles status postback and dispatch order." "ptnr package"
            }
            workerContainer = container "Worker" "Handles AMQP." "Go with Go-kit" {
                connectWorkerComponent = component "Connect" "Handles a placed order." "conx package"
            }

            databaseContainer = container "Database" "Stores webhooks." "PostgreSQL" "Database"
            amqpContainer = container "AMQP" "Order ready messages." "RabbitMQ" "Database"
        }
        partnerSoftwareSystem = softwareSystem "Print Partner" "Produces the order and ships." "Partner"
        productSoftwareSystem = softwareSystem "Product Platform" "Product information." "Product"
        sentrySoftwareSystem = softwareSystem "Sentry" "Shared application monitoring."
        keycloakSoftwareSystem = softwareSystem "Keycloak" "Handle authentication and authorisation system."
        jaegerSoftwareSystem = softwareSystem "Jaeger" "Distributed tracing."

        networkSoftwareSystem -> connectSoftwareSystem "Sends an order." "AMQP"
        connectSoftwareSystem -> partnerSoftwareSystem "Sends an order to be produced." "HTTPS"
        connectSoftwareSystem -> productSoftwareSystem "Gets product details." "gRPC"
        partnerSoftwareSystem -> connectSoftwareSystem "Sends order status information." "HTTPS"
        connectSoftwareSystem -> sentrySoftwareSystem "Sends critical failure alerts." "HTTPS" "Asynchronous, Alert"
        connectSoftwareSystem -> jaegerSoftwareSystem "Sends distributed traces using OpenTracing." "UDP" "Asynchronous"
        connectSoftwareSystem -> keycloakSoftwareSystem "Generates JWT tokens." "HTTPS"

        partnerSoftwareSystem -> partnerAPIComponent "Order status." "HTTPS"
        partnerSoftwareSystem -> connectAPIComponent "Subscribe webhook." "HTTPS"
        connectAPIComponent -> databaseContainer "Save webhook." "TCP"
        partnerAPIComponent -> databaseContainer "Get webhook." "TCP"
        partnerAPIComponent -> networkSoftwareSystem "Dispatch order." "HTTPS"
        connectWorkerComponent -> amqpContainer "Order ready to be dispatched." "AMQP"
        connectWorkerComponent -> partnerSoftwareSystem "Submit order." "HTTPS"
        connectWorkerComponent -> productSoftwareSystem "Get product details." "gRPC"
        connectWorkerComponent -> amqpContainer "Success/Failure for submit order." "AMQP"

        deploymentEnvironment "Live" {
            deploymentNode "connect-live***" "" "Debian Buster" "Kubernetes - node" 3 {
                deploymentNode "Go" "" "golang:1.14.6" "Kubernetes - pod" {
                    liveAPIContainerInstance = containerInstance apiContainer
                }
            }

            deploymentNode "connect-live-worker***" "" "Debian Buster" "Kubernetes - node" 3 {
                deploymentNode "Go" "" "golang:1.14.6" "Kubernetes - pod" {
                    liveWorkerContainerInstance = containerInstance workerContainer
                }
            }

            deploymentNode "pg-gelato-connect-live2" "" "Red Hat 4.8.5-11" "Amazon Web Services - RDS" {
                deploymentNode "PostgreSQL" "" "PostgreSQL 11.4" "Amazon Web Services - RDS Amazon RDS instance" {
                    liveDatabaseContainerInstance = containerInstance databaseContainer
                }
            }

            deploymentNode "rabbitmq.service.consul" "" "" "Amazon Web Services - Simple Queue Service SQS" {
                deploymentNode "RabbitMQ" "" "RabbitMQ 3.8.5" "Amazon Web Services - Simple Queue Service SQS Queue" {
                    liveAMQPContainerInstance = containerInstance amqpContainer
                }
            }
        }
    }

    views {
        systemContext connectSoftwareSystem "SystemContext" {
            include *
            autoLayout
        }

        container connectSoftwareSystem "Containers" {
            include *
            autoLayout
        }

        component apiContainer "ComponentsAPI" {
            include *
            autoLayout
        }

        component workerContainer "ComponentsWorker" {
            include *
            autoLayout
        }

        deployment connectSoftwareSystem "Live" "LiveDeployment" {
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
            element "Connect" {
                background #799351
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
