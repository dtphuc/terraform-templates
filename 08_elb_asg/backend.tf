# /*
# # Use "terraform init" to initialize the configuration.
# */

terraform {
    backend "s3" {
        bucket         = "tmp-tf-state-s3" # Your bucket name
        key            = "08_elb_asg.tfstate"
        region         = "ap-southeast-2" # Your region
        encrypt        = "true"
        dynamodb_table = "terraform_statelock" # Your DynamoDB table with LockID
    }
}