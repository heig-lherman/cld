# Lab 02: App scaling on IaaS

_Duration of this lab: 6 periods_

#### Pedagogical objectives

* Deploy a web application in a scalable way using a two-tier architecture that deploys presentation layer and business logic layer into one tier and the data source layer into another tier

* Use a cloud-managed database

* Use virtual machine images to clone a web application onto
  additional virtual machine instances

* Use a load balancer that is provided as cloud service

* Performance-test a load-balanced web application

---

#### Tasks

![Schema](./img/CLD_AWS_INFA.PNG)

In this lab you will perform a number of tasks and document your
progress in a lab report. Each task specifies one or more deliverables
to be produced. Collect all the deliverables in your lab report. Give
the lab report a structure that mimics the structure of this document.

You should have from the previous lab a customized AMI based on Bitnami Drupal AMI.

You will improve the Drupal site to make it scalable. Your site will
be able to absorb traffic increases from new users by adding virtual
machines that process requests in parallel. Following a two-tier
architecture the business logic and presentation layer will be
separated from the database layer so that the former can be replicated
in multiple virtual machines. The database moves into Amazon's
Relational Database Service (RDS) which provides automatic backup,
data replication and failover.

Note 1: Not all deliverables get you the same number of
points. Deliverables that only verify that you performed some
instructions get fewer points, deliverables that ask questions that
test your understanding and require thinking get more points.

Note 2 : In the labs, you'll find a wide range of variables to use 
for implementation. Credentials are also supplied. If you don't follow
 them, it will be difficult for the teacher to validate your work (access problem).

---

### TODO

* [Task 001 - Create a database using the Relational Database Service (RDS)](./001_RDS.md)
* [Task 002 - Configure the Drupal master instance to use the RDS database](./002_Db_Migration.md)
* [Task 003 - Create a custom virtual machine image and deploy a second Drupal instance](./003_Custom_AMI.md)
* Task 004 - Create a load balancer
* Task 005 - Test the distributed application
* Task 006 - Release Cloud Resources
