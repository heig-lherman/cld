# Custom AMI and Deploy the second Drupal instance

In this task you will update your AMI with the Drupal settings and deploy it in the second availability zone.

## Task 01 - Create AMI

### [Create AMI](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-image.html)

Note : stop the instance before

|Key|Value for GUI Only|
|:--|:--|
|Name|AMI_DRUPAL_DEVOPSTEAM[XX]_LABO02_RDS|
|Description|Same as name value|

```bash
[INPUT]

aws ec2 create-image --name "AMI_DRUPAL_DEVOPSTEAM17_LABO02_RDS" --description "AMI_DRUPAL_DEVOPSTEAM17_LABO02_RDS" \
--tag-specifications 'ResourceType=image,Tags=[{Key=Name,Value=AMI_DRUPAL_DEVOPSTEAM17_LABO02_RDS}]' \
--instance-id $(aws ec2 describe-instances --filters "Name=tag:Name, Values=EC2_PRIVATE_DRUPAL_DEVOPSTEAM17_A" | jq -r '.Reservations[0].Instances[0].InstanceId')

[OUTPUT]

{
    "ImageId": "ami-06d859beeb085f62f"
}
```

## Task 02 - Deploy Instances

* Restart Drupal Instance in Az1

* Deploy Drupal Instance based on AMI in Az2

|Key|Value for GUI Only|
|:--|:--|
|Name|EC2_PRIVATE_DRUPAL_DEVOPSTEAM[XX]_B|
|Description|Same as name value|

```bash
[INPUT]
aws ec2 run-instances --count 1 --instance-type t3.micro \
--key-name CLD_KEY_DRUPAL_DEVOPSTEAM17 \
--security-group-ids $(aws ec2 describe-security-groups --filters "Name=group-name, Values=SG-PRIVATE-DRUPAL-DEVOPSTEAM17" | jq -r '.SecurityGroups[].GroupId') \
--subnet-id $(aws ec2 describe-subnets --filters "Name=tag:Name, Values=SUB-PRIVATE-DEVOPSTEAM17b" | jq -r ".Subnets[].SubnetId") \
--private-ip-address 10.0.17.140 \
--block-device-mappings 'DeviceName=/dev/sdh,Ebs={VolumeSize=10,VolumeType=gp2}' \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=EC2_PRIVATE_DRUPAL_DEVOPSTEAM17_B}]' \
--image-id $(aws ec2 describe-images --filters "Name=tag:Name,Values=AMI_DRUPAL_DEVOPSTEAM17_LABO02_RDS" | jq -r ".Images[0].ImageId")

[OUTPUT]
{
    "Groups": [],
    "Instances": [
        {
            "AmiLaunchIndex": 0,
            "ImageId": "ami-06d859beeb085f62f",
            "InstanceId": "i-04edb130915589454",
            "InstanceType": "t3.micro",
            "KeyName": "CLD_KEY_DRUPAL_DEVOPSTEAM17",
            "LaunchTime": "2024-03-20T20:23:02+00:00",
            "Monitoring": {
                "State": "disabled"
            },
            "Placement": {
                "AvailabilityZone": "eu-west-3b",
                "GroupName": "",
                "Tenancy": "default"
            },
            "PrivateDnsName": "ip-10-0-17-140.eu-west-3.compute.internal",
            "PrivateIpAddress": "10.0.17.140",
            "ProductCodes": [],
            "PublicDnsName": "",
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "StateTransitionReason": "",
            "SubnetId": "subnet-04498bd788c84b3b8",
            "VpcId": "vpc-03d46c285a2af77ba",
            "Architecture": "x86_64",
            "BlockDeviceMappings": [],
            "ClientToken": "64bef485-7b90-4345-87d4-3d43418a9f70",
            "EbsOptimized": false,
            "EnaSupport": true,
            "Hypervisor": "xen",
            "NetworkInterfaces": [
                {
                    "Attachment": {
                        "AttachTime": "2024-03-20T20:23:02+00:00",
                        "AttachmentId": "eni-attach-0ace084f551dc92a0",
                        "DeleteOnTermination": true,
                        "DeviceIndex": 0,
                        "Status": "attaching",
                        "NetworkCardIndex": 0
                    },
                    "Description": "",
                    "Groups": [
                        {
                            "GroupName": "SG-PRIVATE-DRUPAL-DEVOPSTEAM17",
                            "GroupId": "sg-011bce67a038aeb52"
                        }
                    ],
                    "Ipv6Addresses": [],
                    "MacAddress": "0a:26:0f:9d:58:d3",
                    "NetworkInterfaceId": "eni-069e711dcdc155b3b",
                    "OwnerId": "709024702237",
                    "PrivateIpAddress": "10.0.17.140",
                    "PrivateIpAddresses": [
                        {
                            "Primary": true,
                            "PrivateIpAddress": "10.0.17.140"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Status": "in-use",
                    "SubnetId": "subnet-04498bd788c84b3b8",
                    "VpcId": "vpc-03d46c285a2af77ba",
                    "InterfaceType": "interface"
                }
            ],
            "RootDeviceName": "/dev/xvda",
            "RootDeviceType": "ebs",
            "SecurityGroups": [
                {
                    "GroupName": "SG-PRIVATE-DRUPAL-DEVOPSTEAM17",
                    "GroupId": "sg-011bce67a038aeb52"
                }
            ],
            "SourceDestCheck": true,
            "StateReason": {
                "Code": "pending",
                "Message": "pending"
            },
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "EC2_PRIVATE_DRUPAL_DEVOPSTEAM17_B"
                }
            ],
            "VirtualizationType": "hvm",
            "CpuOptions": {
                "CoreCount": 1,
                "ThreadsPerCore": 2
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "open"
            },
            "MetadataOptions": {
                "State": "pending",
                "HttpTokens": "optional",
                "HttpPutResponseHopLimit": 1,
                "HttpEndpoint": "enabled",
                "HttpProtocolIpv6": "disabled",
                "InstanceMetadataTags": "disabled"
            },
            "EnclaveOptions": {
                "Enabled": false
            },
            "PrivateDnsNameOptions": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            },
            "MaintenanceOptions": {
                "AutoRecovery": "default"
            },
            "CurrentInstanceBootMode": "legacy-bios"
        }
    ],
    "OwnerId": "709024702237",
    "ReservationId": "r-058ed332522886593"
}

```

## Task 03 - Test the connectivity

### Update your ssh connection string to test

* add tunnels for ssh and http pointing on the B Instance

```bash
ssh devopsteam17@15.188.43.46 -i ../secrets/CLD_KEY_DMZ_DEVOPSTEAM17.pem -L 2224:10.0.17.140:22
ssh bitnami@localhost -p 2224 -i ../secrets/CLD_KEY_DRUPAL_DEVOPSTEAM17.pem
```

## Check SQL Accesses

```sql
[INPUT]
bitnami@ip-10-0-17-10:~$  mysql -h dbi-devopsteam17.cshki92s4w5p.eu-west-3.rds.amazonaws.com -u bn_drupal -p'[PASSWORD]' bitnami_drupal -e "SHOW DATABASES;"

[OUTPUT]
+--------------------+
| Database           |
+--------------------+
| bitnami_drupal     |
| information_schema |
+--------------------+
```

```sql
[INPUT]
bitnami@ip-10-0-17-140:~$  mysql -h dbi-devopsteam17.cshki92s4w5p.eu-west-3.rds.amazonaws.com -u bn_drupal -p'[PASSWORD]' bitnami_drupal -e "SHOW DATABASES;"

[OUTPUT]
+--------------------+
| Database           |
+--------------------+
| bitnami_drupal     |
| information_schema |
+--------------------+
```

### Check HTTP Accesses

```bash
//connection string updated
ssh devopsteam17@15.188.43.46 -i ../secrets/CLD_KEY_DMZ_DEVOPSTEAM17.pem -L 17801:10.0.17.10:8080
ssh devopsteam17@15.188.43.46 -i ../secrets/CLD_KEY_DMZ_DEVOPSTEAM17.pem -L 17802:10.0.17.140:8080
```

### Read and write test through the web app

* Login in both webapps (same login)

* Change the users' email address on a webapp... refresh the user's profile page on the second and validated that they are communicating with the same db (rds).

* Observations ?

```
The email address is updated on both webapps.
```

### Change the profil picture

* Observations ?

```
The picture is not updated on the second webapp as the picture is stored in the file system of the first webapp.
```