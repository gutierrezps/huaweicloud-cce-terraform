resource "huaweicloud_obs_bucket" "main" {
  count  = var.create_obs ? 1 : 0
  bucket = var.obs_bucket_name
  acl    = "private"
}

resource "huaweicloud_identity_user" "obs_access" {
  count       = var.create_obs ? 1 : 0
  name        = var.obs_bucket_name
  access_type = "programmatic"
  pwd_reset   = false
}

resource "huaweicloud_identity_access_key" "obs_access" {
  count       = var.create_obs ? 1 : 0
  user_id     = one(huaweicloud_identity_user.obs_access).id
  secret_file = "output/obs-credentials.csv"
}

data "huaweicloud_account" "current" {}

resource "huaweicloud_obs_bucket_policy" "main" {
  count  = var.create_obs ? 1 : 0
  bucket = one(huaweicloud_obs_bucket.main).bucket

  policy = jsonencode({
    Statement = [
      {
        Sid       = "allow-read-write",
        Effect    = "Allow",
        NotAction = ["DeleteBucket", "PutBucketPolicy", "PutBucketAcl"],
        Resource  = ["${var.obs_bucket_name}", "${var.obs_bucket_name}/*"],
        Principal = {
          "ID" = "domain/${data.huaweicloud_account.current.id}:user/${one(huaweicloud_identity_user.obs_access).id}"
        }
      }
    ]
  })
}