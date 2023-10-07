# AWS Database Encryption SDK

Demo for the AWS DBE SDK with DynamoDB.

Apply the infrastructure to create the DDB and KMS resources:

```sh
terraform init
terraform apply -auto-approve
```

Create the file `dev.properties`:

```properties
kms.key.arn=arn:aws:kms:us-east-2:000000000000:key/00000000-0000-0000-0000-000000000000
ddb.table.name=Table001
```

Install Maven dependencies:

```sh
mvn clean install
```

Execute the application:

```sh
mvn exec:java
```
