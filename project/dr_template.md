## Infrastructure
## AWS Zones
Zone1: Primary site in us-east-2: us-east-2a, us-east-2b, us-east-2c

Zone2: Secondary site in us-west-1: us-west-1a, us-west-1b
## Servers and Clusters
### Table 1.1 Summary
| Asset      | Purpose           | Size                                                                   | Qty                                                             | DR                                                                                                           |
|------------|-------------------|------------------------------------------------------------------------|-----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| Ubuntu-web (EC2) | Web Application | t3.micro | 3 | Deployed DR to us-west-1 |
| SSH Key Pair              | To connect to EC2 if needed               | .pem      | 1           | each region have different key |
| Ubuntu-web for DR (EC2) | Web Application | t3.micro | 3 | DR for web app running in us-east-2 |
| EKS Cluster | Prometheus and Grafana | t3.medium | 1 cluster with 2 nodes | Deployed DR to us-west-1|
| EKS Cluster (DR) | Prometheus and Grafana | t3.medium | 1 cluster with 2 nodes | DR for monitoring tools running in us-east-2 |
| RDS Cluster | Database for web app | t3.medium | 2 nodes (writer+reader) | replicated with DR |
| RDS Cluster (DR) | Database for web app | t3.medium | 2 nodes (writer+reader) | replicated with DC |
| Application Load Balancer    | Load balance traffic |              | 1           | deploy to DR              |
| Grafana and Prometheus | Monitoring and visual graph               |              | 1           | deploy to DR              |
| VPC                       | Virtual Private network                   |             | 2  | Multiple zones per VPC, one VPC in us-east-2 and other one in us-west-1 for DR |

### Descriptions

- 3 EC2 instances running the website, in the same region (us-east-2) but are in different AZ
- SSH keys pair to connet to EC2 instance.
- Application Load Balancer for the website, point to primary site and will failover to secondary DR site when primary is not available
- EKS cluster for monitoring stack, including 2 nodes and are deployed in different AZ
- Grafana and Prometheus for the web application deployed into the Kubernetes cluster
- RDS running on 3 nodes for the website, nodes deployed to different AZ. Database is replicated to a second zone2 (us-west-1) for DR
- RDS backups stored in S3 for recovery, perform daily backup, backup retention window is 5 days.
- VPC to separate resource and divine to small network, use VPC to launch resources

## DR Plan
### Pre-Steps:
Using Terraform to build 2 zones (us-east-2 and us-west-1)
Both zones will have same config.
If zone 1 down, we will redirect to zone 2 with update record in Load balance(Route 53)

## Steps:
You won't actually perform these steps, but write out what you would do to "fail-over" your application and database cluster to the other region. Think about all the pieces that were setup and how you would use those in the other region
Using Route53 to re-route traffic to DR zone.
With health check, when zone 1 down, route 53 will re-direct traffic from zone 1 to zone 2.
Traffic will go to ALB (EC2 group)
DB Cluster in zone 1 and zone 2 will replication.
With health checks, When DB zone 1 down, will force DB zone 2 to become primary.
