# Cheat sheet AWS SysOps Administrator Associate certification

## EC2

### Termination protection

- when enabled and shutdown behaviour is set to terminate, a shutdown of the instance within the instance OS will terminate the instance (even with termination protection). Within console it is not possible to shut down.

### Placement groups

Are always in same AZ

- Cluster
  - HighPerformanceComputing
  - choose for highest performance
  - instances are located close to each other
- Spread
- Partition

### Network ENA

### Instance connect

### purchasing options

- on demand
- reserved
- spot instance

### CW Metrics

Super important

- no RAM -> need CW agent installed

#### unified cloudwatch agent


### Status checks

Must know:

SYSTEM status checks monitor the AWS system on which your instance runs

- Problem with underlying host.
  - Loss of network connectivity
  - Loss of system power
  - Software issues on the physical host
  - Hardware issues on the physical host that impact network reachability
- Either wait for AWS to fix the host or move the instance to a new host = STOP and START the instance (if EBS backed)

INSTANCE status checks monitor the software and network configuration of the individual instance

- Example of issues
  - incorrect networking or startup configuration
  - Exhausted memory
  - Corrupted file system
  - Incompatible kernel
- Requires involvement to fix
- Restart EC2 instance or change the EC2 instance configuration

### Hibernate

- enabling -> EBS volume must be encrypted

### Burstable CPU

You have CPU credits, it is not possible to purchase some


### Actions

- Change instance type
  - requires stopping the instance first
- Launch instance
  - Error: `InstanceLimitExceeded`
    - reached number of running On-Demand instances that you can launch in a Region
    - request an instance limit increase (AWS EC2 service quotas)
  - Error: `InsufficientInstanceCapacity`
    - AWS currently doesn't have enough available On-Demand capacity
    - AZ wide
  - Error: switch immediatly from `pending` to `terminating` possible issues
    - you have reached EBS volume limit
    - an EBS snapshot is corrupted
    - The root EBS volume is encrypted and you do not have permissions to the KMS key for decryption
    - NOT: you have reached the instance limit per region assigned to your account
- ssh into instance
  - Error: `Connection timed out`
    - network related issue

## AMI

- AMI = AmazonMachineImage
- built for a specific region
- public: AWS provided
- own AMI: own maintained
- AWS Marketplace: AMI someone else made
- AMI process
  - create AMI
    - creates also EBS snapshots
    - you do not need to stop a running instance -> but will shut down
    - it is in part image and templates
  - use AMI
    - just launch instance and choose image in my amis part

### No reboot image

- enables to create AMI without shut down
- not selected by default
- option when AMi creation

### AWS backup plans to create AMI

- does not reboot instance while taking EBS snapshots

### AMI cross account sharing and copy

AMI is regino locked, that means that you are not able to share an AMI across regions

#### share

- possible to share AMis
- sharing does not affect the ownership of the AMI
- only possible if it has unencrypted volume and volumes that are encrypted with a customer managed key
- if encrypted must also share customer managed key

#### copy

- new account is owner
- owner of source AMI must grant read permissions
- if encrypted must have kms key shared

#### AMI in producion

- can force user to only launch pre-approved AMIs (e.q. AMI with special tag)
  - combine with AWS Config to find non compliant rescources
  - IAM permissions e.q.

```json
  "Condition": {
    "StringEquals": {
      "ec2:ResourceTag/stage": "prod"
    }
  }
```

#### Image builder

automate creation of images

- permissions:
  - `EC2InstanceProfileForImageBuilder` -> for AMIs
  - `EC2InstanceProfileForImageBuilderECRContainerBuilds` -> for container images
- Be careful: when not specifying the instance type, some higher charges will occure for building the image
- Distribution settings
  - possible to distribute to different regions

## SSM and OpsWorks

- Free service
- helps to manage EC2 and on-prem systems at scale
- easily detect problems
- patching automation for enhanced compliance
- linux and windows
- integrated with cloudwatch metrics/dashboard
- integrated with AWS config
- need to install SSM agent
  - installed per default on Amazon Linux 2 AMI and soe Ubuntu AMI
  - most issues are related to issues with the agent
  - EC2 instances must have proper IAM role to allow SSM actions
  - no need t open EC2 inbound sec group -> connection initiated by instance

### contains

- resource groups
- ops management
  - explorer
  - OpsCenter
  - CloudWatch dashboard
  - PHD
  - Incident Manager
- Shared resources
  - Documents
- Change management
  - Change manager
  - Automation
  - Change Calendar
  - Maintenance Windows
- Application Management
  - Application Manager
  - AppConfig
  - Parameter Store
- Node Management
  - Fleet manager
  - Compliance
  - Inventory
  - Hybrid Activations
  - Session Manager
  - Run Command
  - State Manager
  - Patch Manager
  - Distributer

### resource groups

- can create resource groups related to instance tags

### Documents

- define parameters and actions
- many already exists in AWS
- JSON or YAML

#### run command

- execute script or just run a command
- run comand across multiple instances (using resource groups)
- Rate ctrl/error ctrl
- integrated with IAM and cloudTrail
- notifications -> SNS
- output -> Console, CloudWatch, S3
- eventbridge can invoke

### automations

- automation runbooks
- defines actions performed on Ec2
- can be triggered
  - manually
  - AWS EventBridge
  - schedule
  - AWS config remediations

### parameter store

- version tracking
- sec with IAM
- notifications -> eventBridge
- integrates with CloudFormation
- sls, easy SDK
- optional can use KMS
- secure storage for configuration and secrets

#### Tiers

| TIER | standard | advanced |
| ---- | -------- | -------- |
| `#` of params per region| 10 000 | 100 000|
| max size of param value in kb | 4 | 8 |
| param policies | no | yes |
| cost | no additional | charges apply |
| pricing | free | $0.05 per advanced parameter per month |

- advanced parameters
  - allows assign TTL
  - can assign multi policies at a time

### SSM Inventory

- collect metadata from managed instances
- metadata includes installed software, OS drivers, configs, updates,..
- view data -> console, S3
- specify metadata collection interval
- query data for mult acc and regions
- create custom inventory
- bucket sync (put to S3 and sync with other instances)

### SSM stage manager

- automate process of keeping instances in state you defined
- use cases: bootstrap, patch,..
- State manager associations
  - defines the state for the managed instance
- use ssm documents to create association

### SSM patch manager

- autmate patch manager
- OS updates, applications,..
- EC2 and on prem
- linux, mac, windows
- patch on demand or schedulae with maintenance windows
- scan instances and generate patch compliance reports
  - report can be sent to S3

#### PAtch baseline

- define which patches should be installed
- can create custom patch baselines
- patches can be auto approved
- default only install critical pathces and patches related to security

#### patch group

- associate group of instance with patch baseline
- Instance should be defined with tag key `PATCH GROUP`
- instance can only be in one patch group
- patch group can only have one patch baseline

### SSM session manager

- allows to start secure shell on instance
- aws cli, session manager sdk or aws console
- no need for SSH, basion or ssh keys
- reports -> S3, CloudTrail (Log connections to instance and executed commands)
- IAM permissions needed
- no need to open port 22 on instance (security group)

### SSM OpsWorks

- use chef or puppet

## ElasticBeansTalk

- PaaS
- free, just pay for underlying resources
- Managed
  - instance config / OS -> handled by EBT
  - deployment strategy configurable but perfomred by EBT
- applikaiton code is responsibility of developer
- architecture models:
  - single instance -> DEV mode
  - LB + ASG -> prod or pre prod web aps
  - ASG only -> great for non-web apps in prod (workers,..), has queue
- 3 different components
  - application
  - application version
  - environment name (dev, test, prod,.. free naming)
- deploy app versions
- rollback to prev version
- full control over lifecycle
- support of many plattforms/languages
- possible to create custom platform

## CloudFormation

### intrinsic functions

- Ref
- Fn::GetAtt
- Fn::FindInMap
- Fn::ImportValue
- Fn::Join
- Fn::Sub
- Condition functions

### Advanced

- EC2 userData
  - need Fn::Base64
  - located in `/var/log/cloud-init-output.log`

```yaml
UserData:
  Fn::Base64: |
    #!/usr/bin/env bash
    # here whatever code
```

- there exists WaitCondition resources for cloudformation
- cfn-init
  - AWS::CloudFormation::Init must be in Metadata of a CF resource
  - with cfn-init script it helps make complex EC2 configurations readable
  - EC2 service will query CloudFormation service to get init data
  - Logs go to `/var/log/cfn-init.log`
  - can use cfn-signal script for wait conditions until it reports back to cloudformation

- rollback
  - stack creation fails
    - default: everything rollsback
    - option to disable the rollback
  - stack update fails
    - automatically rolls back to previous known working state
    - ability to see the logs

### nested stacks

- are parts of other stacks
- Template Type: `AWS::CloudFormation:Stack`
- When parent stack gets deleted -> nested stack also gets deleted

### Change Sets

- help to understand what changes before the execution
- Change sets won't say if the update will be successful
- in changes tab you see the changes nicely

### Drift

- does not protect against manual configuration changes
- checks if rescources have drifted

### Deletion Policy

- Retain -> CloudFormation will preserve / bakcup in case of CF deletion
- snapshop -> for dbs, volumes, datastores
- delete -> default (for RDS::Cluster snapshot is default)

### Termination Protection

- protects against accidentally deletion
- for nested stacks can only be changed on root stack

### CreationPolicy

- different for cloudformation resources
- e.q. for autoscaling can wait for 3 complete instances created (for example for desiredCapacity), e.q. can be triggered with cfn-init

### UpdatePolicy

- e.q. for autoscalinggroup useful if launchconfiguration changes
- rollingupdate or replacingupdate (replacing will create first new ASG then deletes it)
- schedulaction
- per default it will just for example update the launch configuration but won't do changes to the instances

### DependsOn

- wait until resource which is dependent has been created

### StackPolicies

- can protect resources in stack for being updated
- JSON format (looks like IAM policy)
- if stackpolicy changes during cfn update -> it will be reverted to original state after the update

### StackSets

- create/update/delete stacks accross multiple accounts and regions with single operation
- ability to set max concurrent actions on targets (`# or %`)
- ability to set error tolerance (`# or %`)

### Stack update rollback failed

- fix error manually outside of CF and then continue update rollback
- or skip the resource

## EBS Volume

- ElasticBlockSorage is a network drive can be attached to instances while they run
- allow instances to persist data even after their termination
- can be only mounted to one instance at a time
- bound to AZ
- with snapshots you can move to other AZ
- get billed for provisioned capacity
- delete on termination -> when EC2 instance is terminated, can be set when EC2 instance is created. Is on per default for root volume

### EC2 Instance Store

- high performance hardware disk
- EC2 instance store lose their storage if they are stopped (ephemeral)
- Good for buffer / cache / temp content
- Risk of data loss if hardware fails
- backups and replication job of customer

### Volume types

- gp2/gp3 SSD -> general purpose
  - gp3 baseline 3000 (increase max 16000) IOPs and trhoughput of 125MiB/s (increase max 1000 MiB/s)
  - gp2 can burst up to 3000 IOPs, Size of volume and IOPs are linked, max IOPs 16000, 3 IOPs per GB means at 5334 GB max IOPs
- io1/io2 SSD (4GB - 16 TB) -> highest performacne SSD for mission critical low latency or high throughput workload
  - great for databases workloads
  - if app needs more then 16000 IOPs
  - Max PIOPs 64000, for nitro EC2 instances and 32000 for others
  - can increase PIOPs independently from storage size
  io2 have more durability and more IOPs per GiB at the same price as io1
  - support EBS multi attach
- st1 HDD -> low cost HDD designed for frequently accessed, throughput intenxe workloads
  - Big DAta warehouse, Log processing
  - max throughput 500 MiB/s max IOPs 500
- sc1 HDD -> lowest cost HDD volume for less frequent access
  - infrequently accesses
  - cold sotrage
  - throughput of 250MiB/s max IOPs 250
- only gp2/gp3 and io1/io2 can be used as boot volumes

### Multi attach

- allows to attach one EBS to multiple EC2s in same AZ (only io1/io2)
- write and read access
- up to 16 EC2 instances at a time
- must use file system that is cluster aware

### Volume resizing

- only possible to increase
  - size
  - IOPs
- afer resizing a repartition is needed
- after increasing it is possible that the volule is a long time in `optimisation` phase. The volume is still  usable
- decrease not possible

### Snapshots

- not necessary to detach volume but recommended
- stored in S3
- snapshot archive
  - 75% cheaper
  - takes within 24 to 72 hours for restoring
- recycle bin for snapshots (other storage tier)
  - setup rules to retain deleted snapshots so you can recover after accidental deletion
  - specify retention (1 day to 1 year)
  - encrypted if volume is encrypted

#### Amazon Data Lifecylcle Manager

- automate creation, retention and deletion of snapshots and EBS backed AMIs
- schedule backups, cross-account snapshot
- use resource tags to identify the resources

#### Fast Snapshot Restore (FSR)

- helps to create a volume from a snapshot that is fully initialized at creation (no I/O latency)
- very expensive
- can be done with DataLifecycleManager

### EBS migration

- only per AZ
- create snapshot
- create volume in new AZ

### EBS encryption

- if volume is encrypted
  - @Rest inside the volume
  - in flight data is encrypted
  - all snapshots are encrypted
- volume created from snapshot are encrypted
encryption and decryption are handled transparently (nothing to do)
- small impact on performance

- if snapshot is not encrypted
  - copy snapshot there is an option to encrypt
  - create volume there is an option to encrypt the volume

## EFS

- Managed NFS (network file system) that can be mounted on many EC2
- multi AZ
- highly available, expensive (3xgp2), pay per use
- only for linux based AMI
- use sec group to control access to EFS
- NFSv4.1 protocol
- possible to enable encryption @Rest
- POSIX file system
- scales automatically, pay per use

### Performance and storage classes

- 1000s of concurrent NFS clients, 10GB+ /s throughput
- Grow to Petabyte-scale network file system
- performance mode (set at EFS creation time)
  - generaol purpose (default), latency-sensitive use cases (web server,..)
  - max I/O - higher latency, throughput, highly parallel (big data, media processing)
- Throughput mode
  - bursting (default) 1TB = 50MiB/s + burst up to 100MiB/s
  - provisioned: set throughput regardless of storage siz, ex: 1GiB/s for 1 TB storage
- storage classes
  - storage tiers (liefecycle management feature - move file after N days)
    - standard: for frequently accessed files
    - Infrequent access (EFS-IA): cost to retrieve files, lower proce to store. EFS-IA with a lifecycle policy
  - availability and durability
    - standard: Multi AZ, great for prod -> now called Regional
    - one zone: one AZ, great for dev, backup, compatible with IA (EFS One Zone-IA)
  - over 90% in cost saving
- automated backups
- now poccible to automount EFS in EC2
- automated transition into IA with treshholds (e.q. not accesses for 30 days)
- need security group
  - NFS type
  - port 2049
  - autocreated inbound rules when automount within EC2

### Access Points

- easily manage app access to NFS
- enforce POSIX user and group to use
- restrict access to a directory and optionally specify different root dir
- can restrict access from NFS clients using IAM policies
- need to be mounted into instance

### Operations

- operations can be done in place
  - lifecycle policies
  - throughput mode
  - EFS access points
- operations that require migration
  - migration to encrypted EFS
  - performance mode (e.q. Max IO)
  - AWS dataSync servcie can be used to sync

### CloudWatch Metrics

- `PercentIOLimit`
  - how close to I/O limit
  - If at 100% move to Max I/O
- `BurstCreditBalance`
  - The number of burst credits fhe file system can use to achieve higher throughput levels
- `StorageBytes`
  - storage used in bytes

## EBS vs EFS

- EBS
  - can only be attached to 1 instance
  - single AZ
  - Root EBS volume of instances get deleted when instance terminated
-EFS
  - mnt 100s of instances accross AZs
  - only for linux because POSIX

## Advanced S3 and Athena

- you can transition objects between storage classes
  - can be automated with lifecylce rules

### Lifecylce rules

- tranistion actions (storage classes)
- expiration actions (e.q. delete old versions of files, delete incomplete multipart upload)
- rules can be created for a certain prefix or tag

### S3 analytics

- help to decide when to tranisition objects to right storage class
- recommendations for stadard and standard IA
- report updated daily

### S3 event notifications

- no limit, can create as many events as needed
- all events are in event bridge
- advanced filtering options (metadata, object size,..)
event bridge capabilites (archive, replay, reliable delivery,..)

### S3Select and Glacier select

- retrieve less data using SQL (serverside filtering)
- can filter rows and columns
- less network transfer, less CPU cost client-side

### S3 batch operations

- perform bulk operations
- can use S3 inventory to get object list and use S3 select to filter your objects

### S3 Inventory

- list objects and their corresponding metadata (alternative to S3 List API)
- output: CSV, ORC, or Apache Parquet
- Can query with Athena, Redshift, Presto, Hive, Spark,..

### S3 Glacier

- low cost for archiving/backup
- by default data encrypted using AES-256
- alternative to on prem magnetic tape storage
- Vault policies (e.q. cannot delete objects younger than 300d) can only be set once -> need to approve the request
- restore links have an expiration time

### Multipart upload

- upload large objects in parts
- recommended for files > 100MB, must use for files > 5GB
- Can help parallelize uploads
- failures: restart uploading only failed parts
  - use Lifeycle Policy to automate old parts deletion of unfinished upload after X days (e.q. network outage)

### Athena

- sls query service
- SQL language (built on Presto)
- %$ per TB data scanned
- commonly used with Amazon Quicksight for reporting/dashboards
- performance improvement
  - columnar data for cost savings
  - use GLUE to convert data to Parquet or ORC
  - compress data for smaller retrievals (bzip2, gzip,..)
  - partition datasets in S3
  - use larger files (> 128 MB)

### Object encryption

- SSE-S3
  - must set header `"x-amz-server-side-encryption":"AES256"` at upload
- SSE-KMS
  - user control and possible to audit usage using CloudTrail
  - must set header `"x-amz-server-side-encryption":"aws:kms"`
  - limitations
    - download it calls Decrypt KMS API
    - upload it calls GenerateDataKey KMS API
    - possible impact by KMS limits
- SSE-C (customer provided keys)
  - AWS does NOT store the encryption key you provide
  - HTTPS must be used
  - Key and file are uploaded
- client side encryption
  - encrpyt before sending data
  - fully managed keys by client
- Encryption in transit
  - SSL/TLS
  - S3 has 2 endpoints: http and https
  - https mandatory for SSE-C
- force encryption
  - one way set bucket to use default encryption
  - another way: bucket policy
  - note: bucket policies are evaluated before "default encryption"

### S3 CORS

- Cross-Region Resource Sharing
- Origin = scheme (protocol) + host (domain) + port
  - example: `https://github.com:443`
  - same origin -> CORS is no issue
  - other origin -> need CORS header (example `Access-Control-Allow-Origin`)
- If a client makes a cross-origin request on our S3 buckets, we need to enable the CORS headers
- popular exam question

### MFA delete

- MFA required to do important operations
  - permanently delete an object version
  - suspend versioning on the bucket
- only the bucket owner can enable/disable MFA delete (root account, real AWS account root)

### S3 access logs

- for audit purposes
- logs any request made to S3 bucket
- target logging bucket must be in same region
- Do not set the logging bucket to be the monitored bucket (else it is a loop)

### Presigned URLs

- TTL 1min up to 720mins (12 hours)

### Glacier Vault lock and S3 object lock

- Glacier lock
  - adopt a WORM (WriteOnceReadMany) model
  - crate vault lock policy
  - lock the policy for future edits (can no longer be changed or deleted)
  - helpful for compliance and data retention
- S3 object lock (versioning must be enabled)
  - adopt a WORM model
  - block an object version deletion for a specified amount of time
  - Retention mode - Compliance
    - object versions cannot be overwritten or deleted by any user, inclding the root user
    - objects renention modes cannot be changed and retention periods cannot be shortened
  - Retention mode - Governance
    - Most users cannot overwrite or delete an object version or alter its lock settings
    - some users have special permissions (IAM)
  - retention period must be set
  - Legal Hold
    - protect the object indefinitely, independent from retention period
    - can be placed and removed with IAM permissions `s3:PutObjectLegalHold`

### Access Points

- each Access Point gets its own DNS and policy to limit who can access it
- One policy per access point => easier to manage than complex bucket policies
- can restrict to traffic from a specific VPC
- Access points are linked to a specific bucket

## Advanced Storage

### Snow family

- highly secure, portable devices to collect and process data at the edge and migrate data into and out of AWS
- snowball edge
  - storage or compute optimized
  - pay per data transfer job
  - data migration and edge computing
- snowcone
  - smaller then snowball edge
  - withstands harsh environments (dessert, snow,..)
  - 8 TB of usable storage
  - data migration and edge computing
- snowmobile
  - Data migration
  - 100 PB of capacity
- edge computing
  - use cases: preprocess data, machine learning at the edge
  - transcoding media streams
  - all devices can run EC2 instances and AWS lambda (IoT Greengrass)
  - long term deployment options for discount (1 and 3 years)
- AWS OpsHub
  - historically to use snow family CLI was needed
  - OpsHub is UI

### FSx

- Launch 3rd party high performance file systems on AWS
- fully managed
- for windows (file server)
  - supports SMB and NTFS
  - Microsoft AD integration, ACLs, user quotas
  - Can be mounted on Linux EC2 instances
  - supports DistributedFileSystem Namespaces (group files accross multiple FS)
  - scal up to 10s of GB/s, nillions of IOPS, 100s PB of data
  - storage options
    - SSD
    - HDD
  - can be multi AZ
- deploymeny methods
  - scratch filesystem -> data not persisted -> data lost if file server fails
  - persistent filesystem

### Storage Gateway

- hybrid cloud (onprem and cloud)
- S3 is proprietary storage technology (unlike EFS/NFS), so how to expose S3 data on-prem -> Storage Gateway
- is bridge between on prem data and cloud data
- types
  - S3 File gateway
    - no glacier suported (use lifecycle policies)
    - NFS/SMB to/from S3
    - most recently used data is cached in the file gateway
    - bucket access using IAM roles for each file gateway
    - SMB protocol has integration with AD
  - FSx File Gateway
    - FSx supports SMB out of the box
    - The File Gateway gives you the option to have a local cache (main reason)
  - volume gateway
    - block storage using iSCSI protocol backed by S3
    - backed by EBS snapshots
    - types:
      - cached volues -> low latency to most recent data
      - stored volumes -> dataset on prem, scheduled backups to S3
  - Tape gateway
    - backup data
- Hardware applicance
  - using storage gateway means you need on prem virtualization -> otherwise you can use Storage Gateway hardware applicance
  - can be bought within AWS console
  - has required CPU, memory, network, SSD cache
- POSIX compliant
- reboot storage gateway VM
  - File Gateway: simply restart the storage gateway VM
  - Volume and Tape gateway:
    - stop the storage gateway service
    - reboot the storage gateway VM
    - start storage gateway service
- two ways to get activation key:
  - either using the gateway VM cli
  - or make a web request to the gateway VM port 80
  - troubleshoot activation failure
    - make sure Gateway VM has port 80 opened
    - NTP issue
- volume gw cache mode
  - cached mode: only most recent data is stored
  - cache efficiency
    - look at the `CacheHitPercent` (should be high)
    - look at the `CachePercentUsed` (should be low)
  - create a larger cache disk
    - use cached volume to clone a new one of larger size
    - select the new disk as the cached volume

## CloudFront

- CDN
- improves read performance by caching
- DDoS protection, integration with Shield, AWS WebApplication Firewall
- can be proxy to applications in EC2,..
- CloudFront vs S3 Cross Region replication
  - CF -> global edge network
  - files are cached for a TTL
  - great fro static content that must be available everywhere
  - S3 CRR
    - files are updated in near real time
    - read only
    - must be setup for each region you want replication
    - great fro dynamic content that needs to be avialable at low latency
- ALB or EC2 as an origin
  - EC2 instance must be public
  - ALB must be public -> behind EC2 instance can be private
- Geo Restriction
  - allowlist/blocklist for countries -> 3rd party Geo-IP database
- Access Logs -> into  S3 bucket -> should be different from content bucket
  - cache statistics report
  - popular objects report
  - top rererrers report
  - usage reporrts
  - viewers report
- troubleshooting
  - CF caches HTTP 4xx and 5xx status codes returned by S3 (or origin server)
- caching (deep dive)
  - based on
    - headers
    - session cookies
    - query string parameters
  - cache lives at each CF Edge location
  - goal is to max cache hit rate and min requests to origin
  - can invalidate cache with `CacheInvalidation` api
  - origin Headers vs Cache behavior
    - origin custom headers
      - origin level setting
      - set a constant header / header value for all requests to origin
    - behavior settings
      - cache-related settings
      - contains the whitelist of headers to forward (to origin)
  - Caching TTL
    - `"Cache-Control":"max-age"` is prefered to `"Expires"` header
    - If the origin sets the header `Cache-Control` then you can set TTL to be controlled only by that header
    - In case you want to min/max boundaries, choose `"customize"` for the Object Caching settings
  - Cookies -> is a header value with many items
    - Default: do not process the cookies
      - Caching is not based on cookies
      - Cookies are not forwarded
    - Forward a whitelist of cookies
      - caching based on values in all the specified cookies
    - Forward all cookies
  - Query Strings
    - Default: do not prcess the query strings
      - caching is not based on query strings
      - parameters are not forwarded
    - Forward a whitelist of query strings
      - caching based on the param whitelist
    - based on all parameters
  - Maximize cache hits by separating static and dynamic distributions
  - increase cache ratio
    - monitor `CacheHitRate`
    - specify how long to cache (header)
    - specift none or the minimally required headers
    - specify none or the minimally required query string params
    - separate static and dynamic distributions (two origins)
- ALB sticky sessions
  - must forward / whitelist cookie that controls the session affinity to the origin to allow the session affinity to work -> set a TTL lower then the session cookie expiration

## RDS

- can only scale up RDS storage once within 6 hours
- cannot SSH into the instance
- RDS storage autoscaling -> can be enabled, need to set max storage treshold
- read replica scale for reads, multi AZ is for Disaster Recovery (DR)
- read replicas -> no network costs if to same region, cross region has network costs
- go from single AZ to multi AZ
  - just click modify
- RDS proxy -> manages connection pool, noissue with `TooManyConnections` Error, e.q. when Lambda connects anymore
  - support IAM athuentication or DB authentication
  - proxy private -> lambda in VPC
  - public proxy -> lambda public
  - need secret in secrets manager
- parameter groups
  - can configure the DB engine
  - static parameters are applied after instance reboot
  - must known parameter: PostrgreSQL/SQL server: rds.force_ssl=1 -> force SSL connections, for SSL on MySQL / MariaDB you must run `GRANT SELECT ON mydatabase.* TO 'myuser@'%'IDENTIFIED BY '...' REQUIRE SSL`
- backups vs. Snapshots
  |backups| snapshots |
  | ----- | --------- |
  | are continous and allow point in time recovery | take IO operations and can stop the database from seconds to minutes |
  | happen during maintenance windows| snapshots taken on multi AZ do not impact the master -just standby |
  | when DB instance is deleted, backups can be retained | are incremental after the firs snapshot (which is full) |
  | backups have a retention period you set between 0 and 35 days | can copy and share snapshot |
  | to disable set retention period to 0 | manual snapshots don't expire, can take final snapshot when database gets deleted |

- Events and logs
  - RDS keeps record aof events related to DB instances, snapshots,..
  - RDS event subscriptions -> also EventBridge
  - DB instance logs can be sent to CloudWatch, General, Audit, Error, Slow query
- enhanced monitoring (gather from an agent on the DB instance, like CloudWatch agent)
- perfomrance insights -> visualize the database load
  - can view SQL queries causing performance issues
- Aurora
  - not open source
  - compatible drivers to ySQL and PostgreSQL
  - AWS cloud optimized -> claims 5x performance over MySQL and RDS over 3x performance of Postgres on RDS
  - storage automatically grows in increments of 10 GB up to 128 TB
  - can have 15 replicas, replica process is faster
  - failover is instantaneous. It is HA native
  - about 20% more costs then RDS
  - HA -> 6 copies of data across 3 AZ, 3 out of 6 need for reads, self healing with peer to peer, storage stripes across 100s volumes
  - autoscaling possible for read replicas -> reader endpoint does the load balancing
  - backtrack: restore data at any point of time without using backups (up to 72h), doesn't create a new cluster (in place restore)
  - deletion -> must delete reader, then writer then cluster
  - automatic backups -> cannot be disabled (1-35d retention period), PITR
  - aurora daabase cloning -> create new DB cluster using the same volume as the original one, uses copy-on-write protocol (first single copy, then allocate storage only when changes made to the data), useful for creation of testing environments
- security
  - at rest encrpytion, using KMS -> must be defined on launch time, master not encr -> read repl not possible to be encr., if unencr -> do snapshot and restore as enc
  - TLS ready by default, use AWS TLS root cert client side
  - IAM auth: IAM roles to connect to db
  - security groups
  - no ssh available except on RDS Custom
  - audit logs can be enabled and sent to CW logs for longer retention
- priority tier (0-15) on each read replica for failover cases
- can migrate RDS snapshot to aurora
- Aurora CW `AuroraReplicaLag` `AuroraReplicaLagMaximum` `AuroraReplicaLagMinimum` (related to all DB instances in the cluster) -> eventuall consistency!! `DatabaseConnections` `InsertLatency`

## ElastiCache

- same way RDS is to get manage relational Databases ElastiCache is to get managed Redis or Memcached
- in memory databases, high performance, low latency
- helps reduce load off of databases
- using ElastiCahce involves heavy app changes

| Redis | Memcahed |
| ----- | -------- |
| multi AZ | multi node for partitioning of data (sharding) |
| read replicas | no HA (replication) |
| data durability using AOF persistence | non persistent |
| backup and restore features | no backup and restore |
| | Multi threaded architecture |

- cluster mode disabled (scale reads)
  - one shard, all nodes have all the data
  - guard against data loss if node failure
- Cluster mode enabled (scale writes)
  - data is partitioned across shards
- Redis scaling
  - cluster mode disabled
    - horizontal (add read replicas)
    - vertical
  - cluster mode enabled
    - two modes
      - online scaling -> continue serving requests (no downtime, performance degradation)
      - offline scaling -> unable to serve requsts during the scaling process (backup and restore)
    - horizontal (resharding and shard rebalancing)
      - resharding -> scale out/in by adding/removing shards
      - shard rebalancing -> equally distribute the keyspaces among the shards as possible
      - supports online and offline
    - vertical (change read/write capacity)
      - change node type
- Redis Metrics
  - `Evictions` the number of non expired items the cache evicted -> scale up to larger node types (more memory) or more nodes
  - `CPUUtilization` -> scale up to larger node type (more memory) or scale ou by adding more nodes
  - `SwapUsage`: should not exceed 50 MB -> change reserved memory
  - `CurrConnections` -> investigate applications
  - `NetworkBytesIn/Out`
  - ....
- Memcached sacling
  - can have 1 - 40 nodes (soft)
  - horizontal
    - nodes
  - vertical
    - node type
    - process
      - new cluster with new node type
      - update app to use new cluster
      - delete old cluster
    - nodes start out empty
- Memcached Auto Discovery
  - no need to connect to individual nodes
  - seamless from a client perspective
- Memcache Metrics
  - `Evictions`
  - `CPUUtilization`
  - ...

## CloudWatch

- EC2 metrics all 5 minutes -> detailed monitoring -> all 1 minute
- custom metrics -> API call `PutMetricData`
  - make sure EC2 instance time is set right
- Dashboards, are global multi account
  - automatic creation possible
  - custom
- logs
  - insight -> SQL like query
  - subsriptions -> send log data to other services or do logs aggregation
- alarms
  - composite alarms are monitoring the sttate of multiple other alarms, `AND` `OR` conditions, helpful to reuce alarm noise
  - can be created on Metric filters
  - to test -> set state of alarm with aws cli

### EventBridge

- can create multiple event busses
- can record and replay events

### Service Quotas

- can add cloudwatch alarms for service quotas reached

## CloudTrail

- enabled by default
- get history of events
- trail can be applied to all regions
- insights
  - try to detect unusual activity
- default 90 days retention
- LogFile integrity validation -> digest file contains a hash of each log file for last hour
- integratew with EventBridge
- has organizations trails

## AWS config

- helps with auditing and recording comliance of AWS resources
- Rules can be triggered
  - cron
  - config change
- does not prevent actions from happening
- remediations -> e.q. use SSM automation document
  - can set retries
- notification -> use SNS filtering
- aggregators -> collect all findings over many accounts

## Account managing

- service health dashboard -> public page for global AWS services status
- personal health dashboard -> show how AWS outages directly impact you, shows all maintenance events from AWS in your account, manually reachable with `AWS Health` API
  - use eventbridge to react to changes in accounts
  - event log (like aurora db instance upgrade)
- Organizations -> allows to manage multiple accounts over time
  - consolidated Billing across all accounts
  pricing benefits
  - share reserved instances and saving plans discounts, share can be turned of for any account
  - OrganisationalUnits
  - ServicecontrolPolicies
    - inheritance within OUs (deny goes over allow)
    - BlockList and AllowList strategies
  - use `asw:PrincipalOrgID` condition key in resource based policies to restrict access to IAM principals
  - tag policies
  - cost allocation tags
- ControlTower
  - easy way to setup multi-account AWS environment
  - runs on top of organizations
  - policies using guardrails
- AWS service Catalog
  - User taks -> product list = autorized by IAM -> launch -> provisioned producs
  - Admin tasks -> product = CloudFormation templates - portfolio = colleciton of products -> control = IAM permissions
  - TagOptions -> used to create AWS Tag, can be associated with portfolios and products
  - sharing catalogs
    - share reference of the portfolio, then import the shared portfolio into the recipient account (stays in sync with the oiringal portfolio)
    - deploy a copy of the portfolio into the recipient account (must re-deploy any updates)
- Billing alarms
- Cost explorer
- AWS budgets - billing alarms -> same options as billing explorer
- Cost allocation tags -> track AWS costs on a detailed level
  - aws generated tags -> starts with prefix `aws:`
  - user defined tags -> starts with `user:`
- AWS compute optimizer -> reduce costs and improve performance by recommending optimal AWS resources for your workloads

## AWS data sync

- move large amount of data to and from
  - on prem or other cloud provider - AWS (needs client)
  - AWS - AWS (no agent needed)
- targets (can also be src)
  - S3
  - EFS
  - FSx
- can be scheduled hourly, daily, weekly
- keep file permissions and metadata are preserved (NFS POSIX, SMB..)

## AWS backup

- centrally manage and automate backups across AWS services
- can create backup policies known as `Backup Plans`
- tag based policies
- on-demand and scheduled backups
- supports PITR for supported services
- backup vault lock
  - enforce a WORM
  - even root user cannot delete backups when enabled

## Security and compliance

- shared responsiblity model
  - AWS - security **of** the cloud
  - customer - security **in** the cloud
  - shared - patch management, config management, awareness and training
- DDOS attack
  - AWS shield standard/advanced
  - WAF
  - Cloudfront and Route53
  - Be ready to scale (autoscale)
- pen test on AWS
  - no need to get prior approval for
    - EC2, NAT, ELB
    - RDS
    - CloudFront
    - Aurora
    - API GW
    - Lambda and Lambda Edge functions
    - Amazon Lightsail resources
  - prohibited
    - DNS zone walking
    - DoS, DDos, Simulated Dos, Simulated DDos
    - port flooding
    - protocol flooding
    - request flooding
  - all other simulated events, contact `aws-security-simulated-event@amazon.com`
- Amazon inspector
  - automated security assessments
    - EC2 instances
    - containers push to Amazon ECR
    - network reachability (EC2)
    - package vulnerabilities (EC2 and ECR)
  - reporting and integration with SecurityHub
  - Send findings to EventBridge
- logging in AWS
  - logs can be analyzed using Athena
  - you should encrypt logs in S3
  - Move logs to Glacier for cost savings
- GuardDuty -> threat discovery, use ML, Anomaly detection
  - can protect against CryptoCurrency attacks
- Macie
  - fully managed data security and data privacy service, uses ML
  - helps identify and alert to sensitive data, such as personally identifiable information (PII)
- TrustedAdvisor -> analyze accounts and provide recommendations
- encryption
  - in flight (SSL)
    - protects again ManInTheMiddle attack
  - ServerSideEncryption@Rest
    - protects against stealing disks
  - ClientSideEncryption
    - Server does not know anything about encryption
- KMS -> never store secrets in plain text
  - **KMS keys** is the new name of KMS Customer Master Key
  - symmetric -> AWS services are integrated
  - assymetric
  - AWS managed key -> free
  - CustomerManagedKey 1$/month
  - CMK imported must be 256-bit symmetric 1$/month
  - pay fo each KMS API call
  - auto rotation for CMK -> 1a, previous key will be kept active so that old data is able to be decrypted again -> use alias
  - key data will be stored inside encrypted data
  - cannot change encryption key used by volumes
  - deletion of key -> waiting period
    - during deletion mark -> not able to be used anymore
  - CloudHSM -> AWS provisions encryption hardware, encr keys are managed by customer, sym and asym, good option to use ClientSideEncryption
- AWS artifact -> portal giving customer on-demand access to AWS compliance documentation and AWS agreements
  - artifact-reports -> allows to download AWS security and compliance documents from third party auditors
  - artifact agreements -> allows to accept, review and download agreements
- ACM -> manage SSL/TLS certificates, free of charge for public certs
- SecretsManager -> capability to force rotation of secrets every X days, integration with RDS, secrets are encrypted using KMS
  - CloudTrail -> captures API calls to SecretManagers API in addition it captures other related events which might have a security or compliance impact on AWS (name: **non-API service events**), e.q rotation events
  - more expensive then parameter store

## IAM security tools

- IAM credentials report (account-level) -> report list with all users and status of their creds
- IAM access advisor (user-level) -> shows the service permissions granted to a user
- IAM access analyzer -> find out which resources are shared external, define zone of Trust
- identity federation -> let users outside AWS to assume temp roles
- SecurityTokenSservice -> `AssumeRole`, `AssumeRoleWithSAML`, `AssumeRoleWithWebIdentity`, `GetSesstionToken` MFA
- Cognito user pools (CUP)
- AWS SSO

## Other services

- OpenSearch and Kibana
  - production setup -> 3 dedicated master nodes at least 2 data nodes per AZ
- X-Ray -> visual analysis of application over different AWS services
- amplify -> web and mobile applications development tool

## Scalability & HighAvailability

- 2 kinds of scalability, vertical and horizontal
- HighAvailabiliy -> ususally goes hand in hand with horizontal scaling
- ELB -> forward traffic to multiple servers
  - classic LG (old generation) CLB
  - application load balancer ALB
  - network load balancer NLB
  - gateway load balancer GWLB
    - uses GENEVE protocol on port 6081
    - layer 3 (IP)
    - combines following functions
      - transparent Network Gateway - single entry/exit for all traffic
      - Load Balancer - distribute traffic to virtual appliances
    - deploy, scale and manage a fleet of 3rd party network virtual appliances
      - example: Firewalls, Intrusion Detection,..
    - target groups
      - IP addresses
      - EC2 instances
  - sticky sessions -> cookie x-forward x-forward-proto header
    - application base cookie
    - duration based cookie
  - cross zone balancing -> evenly distribute traffic over the registered AZs (regardless of nodes)
  - ServerNameIndication (SNI) -> solves the problem of laoding multiple SSL cert onto one web server, newer protocol and requires the hostname of the target server in the initial SSL handshake
  - connection draining (deregistration delay) -> time to complete in-flight requests while the instance is deregistered or unhealthy
  - ELB health checks
  - Error Codes -> http error codes
  - access logs -> S3, only pay for S3 storage
  - request tracing -> each http request has an added custom header `X-Amzn-Trace-Id`
  - Slow start mode -> give healthy targets time to warm up before requests are sent
  - requess routing algorithm
    - least outstanding requests -> next instance to get request is instance with lowest number of pending/unfinished requests
    - round robin -> equally choose the target
    - flow hash (sickiness) -> select target related to protocol
  - ALB rules deep dive
    - processed in order (default last)
    - can have conditions
    - actions -> forward, redirect, fixed-response
    - target group weighting (blue green deployment)
- AutoScalingGroup
  - need launch template -> AMI, instance type,,..

## Networking - Route53

- 100% availability SLA (only AWS service)
- Record types
  - CNAME -> maps to other hostname
  - A -> IPv4
  - AAAA -> IPv6
  - NS name server for the hosted Zone
- Hosted Zone -> container for records
  - public
  - private
- Record TTL default is 300
- CNAME vs. ALIAS -> cname not for root domains, but alias for root domain, Alias has automated TTL, cannot set ALIAS for EC2 DNS name
- Routing policy
  - DNS does not route
  - simple -> to single resource
  - weighted -> do not need to sum up to 100%
  - latency -> redirect to resource that has the least latency close to us
  - checks
  - failover -> if health check not healthy it fails over
  - Geolocation -> based on where user is located, based on user location
  - Geoproximity -> ability to shift more traffic to resource base on the defined bias
  - MultiValue -> not substitute for having ELB, use when routing traffic to multiple resources -> client will choose
- health checks - about 15 global health checkers will check the endpoint health
  - possible to have calculated health checks -> combine wiht `OR` `AND` `NOT`
  - private hosted zone -> create cloud watch metric and associate a CloudWatch Alarm then create a health check for the alarm itself
- NS delegation
- Hybrid DNS -> resolve DNS queries between VPC (Route53 Resolver) and your networks (other DNS resolvers)
  - resolver endpoints
    - inbound endpoint -> DNS resolvers in network can forward DNS queries to Route53 Resolver
    - outbound endpoint -> route53 conditionally forward DNS queries to your DNS Resolver

## Networking - VPC

- Classles Inter-Domain Routing (CIDR)
  - private IP addresses must be of following values
    - 10.0.0.0/8 (big networks)
    - 172.16.0.0/12 <- AWS default VPC in that range
    - 192.168.0.0/16 e.g. home networks
- VirtualPrivateCloud
  - max CIDR per VPC `5`
  - max size `/16`
  - because VPC is private, only private IPv4 are allowed
  - tiers -> can have dedicated hardware
- subnet
  - AWS reserves 5 IP addresses (first 4 and last one)
- InternetGateway
  - need to be attached to VPC
  - there exist egress only type -> similar to NAT GW but IPv6
- route tables
  - need to be associated with subnet
- Bastion hosts
- NAT
  - NAT instances (outdated!!), must have EIP attached to it, must disable EC2 settings Source/ Destindation Check
  - NAT Gateways -> created in specific AZ, uses elastic IP
    - HA -> need multi AZ
    - does not need security group
- DNS resolution and Route53 private zones
  - decides if DNS resolution from Route 53 resolver is supported for VPC
  - Default is true
  - enableDNSSupport
    - amazon DNS server provider 169.254.169.253 or the reserved IP address at the base of the VPC IPv4 network range plus two (.2)
    - also needed to get DNS resolution for public addresses
    - if disabled you need own DNS server
  - enable DNSHostnames
    - if true it assigns public hostname to EC2 instance if it has public IPv4
- NACL and security groups
  - NACL stateless
  - sg statefull
  - one NACL per subnet
  - new subnets assigned default NACL
  - NACL rules
    - number 1-32766 (higher precedence with lower number
    - first rule match will drive the decision
    - The last rule is an asterisk and denies a request in case of no rule match
    - recoomendation: add rules by increment of 100
  - Default NACL is super open
- reachability analyzer (0.1$ per analyze run)
- VPC peering
  - must not have overlapping CIDRs
  - not transitive
  - must update route table
- VPC endpoints (AWS PrivateLink)
  - interface endpoint -> ENI
  - Gateway Endpoints
    - need to be target in route table
    - S3
    - Dynamodb
- VPC flow logs
  - troubleshoot SG & NACL -> look at the `ACTION` field
- site2site VPN
  - VirtualPrivateGateway (VGW)
  - Customer Gateway (needed on customer site)
    - what IP address to use?
      - public IP of customer Gateway device (internet routable)
      - If it is behind a NAT device -> use public IP of NAT
  - important: enable route propagation for the VPG in the route rable
  - if you want to ping, enable ICMP protocoll in FW
  - AWS VPN CloudHub
    - provide secure communication between multiple VPN connections
    - VPN so it goes over public internet
    - use same VGW with multiple VPN connections
- DirectConnect (DX)
  - private connection
  - hybrid environments
  - encryption, per default no encryption but private, DX + VPN provides an IPsec-encrypted private connection
  - resiliency
    - high resiliency for critical workloads -> one connection at multiple locations
    - maximum resiliency for Critical workloads -> separate connection terminating on separate devices in more than one location
  - Site2SiteVPN connection can be used as a backup connection
- exposing services in VPC to other VPC
  - options:
    - make public
    - VPC peering
    - PrivateLink
- TransitGateway
  - transitive peering connection
  - IP multicast
- VPC traffic mirroring
  - allows to capture and inspect network traffic in VPC
- IPv6 -> 3.4 x 10^38 uniquie IP addresses, IPv4 cannot be disabled for VPC
- Network firewall
  - protect entire VPC
- network costs
  - incoming to EC2 is free
  - in AZ private communication from EC2 to EC2 is free
  - from different AZ it costs money
  - inter region traffic can be expensive
  - minimzie egress costs
    - better to have APP in Cloud to have no egress
  - S3 data transfer
    - ingress is free
    - egress 0.09$ per GB
    - S3 transfer Acceleration -> additional costs on top
    - S3 to CloudFront is free
    - CloudFront to internet (cheaper then S3)
    - cross region replication -> 0.02$ per GB
  - NAT GW vs Gateway VPC endpoint -> VPC endpoints are way cheaper
