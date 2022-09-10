# s3-static-website


Prerequisites:
Terraform and git installed
AWS CLI installed
AWS credential and profile configured on machine
S3 bucket to configure terraform backend
Issue a domain and validate it with AWS ACM

The terraform will set up the following components:
 S3 bucket for www.devopsmode.click which will host the static website
 S3 bucket for devopsmode.click which redirects to www.devopsmode.click
 Cloudfront distribution for www S3 bucket.
 Cloudfront distribution for non www S3 bucket.
 Route 53 records for:
o Non www
o www

Commands executed:
 terraform init 
 terraform plan 
 terraform apply 


Post Changes:
Once the terraform scripts have been applied successfully, need to configure
AWS nameservers with third party domain registrar.
