resource "huaweicloud_obs_bucket" "main" {
  bucket = var.obs_bucket_name
  acl    = "private"
}

resource "huaweicloud_identity_user" "obs_access" {
  name        = var.obs_bucket_name
  access_type = "programmatic"
}

resource "huaweicloud_identity_access_key" "obs_access" {
  user_id = huaweicloud_identity_user.obs_access.id
  secret_file = "output/obs-credentials.csv"
}

data "huaweicloud_account" "current" {}

resource "huaweicloud_obs_bucket_policy" "main" {
  bucket = huaweicloud_obs_bucket.main.bucket

  policy = jsonencode({
    Statement = [
      {
        Sid       = "allow-read-write",
        Effect    = "Allow",
        NotAction = ["DeleteBucket", "PutBucketPolicy", "PutBucketAcl"],
        Resource  = ["${var.obs_bucket_name}", "${var.obs_bucket_name}/*"],
        Principal = {
          "ID" = "domain/${data.huaweicloud_account.current.id}:user/${huaweicloud_identity_user.obs_access.id}"
        }
      }
    ]
  })
}