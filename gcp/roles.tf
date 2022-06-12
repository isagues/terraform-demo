resource "google_project_iam_binding" "owner" {
  project = local.gcp_project
  role    = "roles/owner"

  members = [
      "user:tbrandy@itba.edu.ar",
    ]
}

resource "google_project_iam_binding" "iamadmin" {
  project = local.gcp_project
  role    = "roles/iam.roleAdmin"

  members = [
      "user:tbrandy@itba.edu.ar",
    ]
}

resource "google_project_iam_binding" "computeadmin" {
  project = local.gcp_project
  role    = "roles/compute.admin"

  members = [
      "user:tbrandy@itba.edu.ar",
    ]
}

resource "google_project_iam_binding" "bucketadmin" {
  project = local.gcp_project
  role    = "roles/storage.admin"

  members = [
      "user:tbrandy@itba.edu.ar",
    ]
}
# # resource "google_storage_bucket_iam_binding" "bucketadmin" {
# #   bucket = google_storage_bucket.ice-cream-bucket.name
# #   role = "roles/storage.admin"
# #   members = [
# #     "user:tbrandy@itba.edu.ar",
# #   ]
# # }

resource "google_storage_bucket_iam_binding" "bucketViewer" {
  bucket = google_storage_bucket.ice-cream-bucket.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}