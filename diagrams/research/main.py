from diagrams import Diagram
from diagrams.k8s.clusterconfig import HPA
from diagrams.k8s.compute import Deployment, Pod, ReplicaSet
from diagrams.k8s.network import Ingress, Service

with Diagram("Research", show=False, filename="research"):
    net = Ingress("research.cashcowpro.com") >> Service("svc")
    pods = [Pod("api-1"), Pod("api-2"), Pod("api-3"), Pod("worker-1"), Pod("worker-2"), Pod("worker-3")]
    net >> pods << ReplicaSet("rs") << Deployment("dp") << HPA("hpa")
