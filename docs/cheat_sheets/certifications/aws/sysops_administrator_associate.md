# Cheat sheet AWS SysOps Administrator Associate certification

## EC2

### Placement groups

### Network ENA

### Instance connect

### purchasing options

- on demand
- ...

### CW Metrics

Super important

- no RAM

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
