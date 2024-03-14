# ACCESSES

## Intention

During the various stages of the AWS lab, you'll need to access the infrastructure in different ways:

* As IaaS administrator:
  * Access via the AWS web console for "visual" infrastructure management
   * Access via the AWS CLI for infrastructure management in "command line" mode
* SSH access to your infrastructure to configure your SaaS application.

This document will help you get to grips with the three ways of accessing your cloud solution.

### Prerequisites

* Choose a *devopsteam* and register [here](https://hessoit.sharepoint.com/:b:/r/sites/CLD-2023-2024-NGY/Documents%20partages/General/GCP_Coupons.pdf?csf=1&web=1&e=fqzgpP)
* Retrieve the following files from the teams channel dedicated to your team (in the AWS folder)
   * CLD_<yourTeams>_accessKeys.csv //cli accesses
   * CLD_<yourTeams>_credentials.csv //web console accesses
   * CLD_KEY_DMZ_<yourTeams>.pem //private asymmetric key  to your account on dmz
   * CLD_KEY_DRUPAL_<yourTeams>.pem //private asymmetric key to your drupal instance
   * CLD_SSH_connectionstring.md //sample connection string to help you use the supplied ssh keys

### Task 01 - AWS CLI Access

* Download and install the [AWS CLI](https://aws.amazon.com/cli/)

* Setup the credentials (use the accessKeys.csv file)

```
[INPUT]
aws configure

[OUTPUT]
AWS Access Key ID [****************XXX]: <your accesss key id>
AWS Secret Access Key [****************XXX]: <your secret acces key>
Default region name [eu-west-3]: eu-west-3 //Paris
Default output format [json]:   //let this by default
```

* Find your local AWS CLI profile

```
C:\USERS\<youUserName>\.AWS
    config
    credentials
```

* Add your profile in the "credentials" file (remove default)

```
[DEVOPSXX]
aws_access_key_id = <yourAccesKeyId>
aws_secret_access_key = <yourSecretAccessKey>
```

* Test the CLI access

```
[INPUT]
aws ec2 describe-internet-gateways --profile "CLD_DEVOPSTEAM99" --region eu-west-3 --output table

[OUTPUT]
---------------------------------------------
|         DescribeInternetGateways          |
+-------------------------------------------+
||            InternetGateways             ||
|+------------------------+----------------+|
||    InternetGatewayId   |    OwnerId     ||
|+------------------------+----------------+|
||  igw-0da47f5a441df46e0 |  709024702237  ||
|+------------------------+----------------+|
|||              Attachments              |||
||+------------+--------------------------+||
|||    State   |          VpcId           |||
||+------------+--------------------------+||
|||  available |  vpc-03d46c285a2af77ba   |||
||+------------+--------------------------+||
|||                 Tags                  |||
||+---------------+-----------------------+||
|||      Key      |         Value         |||
||+---------------+-----------------------+||
|||  Name         |  CLD-IGW              |||
||+---------------+-----------------------+||
```

## Task 02 - SSH Access to your DMZ Account

* Install/use the ssh client of your choice 

* Open a ssh session (CLD_SSH_connectionstring.md and the two supplied pem keys)

* Pay attention to :
  * key format
  * the permissions assigned to your key by the file system (it must be private - 600 on linux)

```bash
[INPUT]
ssh devopsteam<youTeam>@<dmzPublicIp> -i <pathToYourKeyFile>.pem

[OUTPUT]
Linux <privateIp>-cloud-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.55-1 (2023-09-29) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Mar  6 10:17:15 2024 from 193.5.240.9
```

## Task 03 - Access to the AWS Web Console

* Install/use the web browser of your choice

* Open your CLD_<yourTeams>_accessKeys.csv file

* Identify the following information

```
  User name : CLD_DEVOPSTEAM<yourTeam>
  Password  : XXX //need to be change on first login attempt
  Console sign-in URL https://<awsAccount>.signin.aws.amazon.com/console
```

* Go to the AWS Administrator to activate your MFA

* The same QR Code can be used on different MFA mobile/clients within the same DEVOPSTEAM.

* Here is the list of [compatible clients](https://aws.amazon.com/iam/features/mfa/?audit=2019q1).

* You will need to deliver two successive codes to synchronize your AWS account and your MFA client.