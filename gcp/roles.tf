resource "google_project_iam_binding" "computeadmin" {
  project = local.gcp_project
  role    = "roles/compute.admin"

  members = [
      local.user_entry,
    ]
}

resource "google_project_iam_binding" "bucketadmin" {
  project = local.gcp_project
  role    = "roles/storage.admin"

  members = [
      local.user_entry,
    ]
}
resource "google_storage_bucket_iam_binding" "bucketViewer" {
  bucket = google_storage_bucket.ice-cream-bucket.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}