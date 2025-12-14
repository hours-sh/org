# dns
resource "google_dns_managed_zone" "this" {
  name     = "sh-hours"
  dns_name = "hours.sh."

  force_destroy = true

  dnssec_config {
    state = "on"
  }
}
resource "google_dns_managed_zone" "scw" {
  name     = "sh-hours-scw"
  dns_name = "scw.${google_dns_managed_zone.this.dns_name}"

  force_destroy = true

  dnssec_config {
    state = "on"
  }
}
resource "google_dns_record_set" "scw" {
  managed_zone = google_dns_managed_zone.this.name

  name = google_dns_managed_zone.scw.dns_name
  type = "NS"
  ttl  = 300

  rrdatas = google_dns_managed_zone.scw.name_servers
}
resource "google_dns_record_set" "mx" {
  for_each = toset([
    google_dns_managed_zone.this.dns_name,
    "*.${google_dns_managed_zone.this.dns_name}",
  ])

  managed_zone = google_dns_managed_zone.this.name

  name = each.key
  type = "MX"
  ttl  = 300

  rrdatas = [
    "10 mx.soverin.net.",
  ]
}
resource "google_dns_record_set" "txt" {
  managed_zone = google_dns_managed_zone.this.name

  name = google_dns_managed_zone.this.dns_name
  type = "TXT"
  ttl  = 300

  rrdatas = [
    "\"google-site-verification=WYABDEJ24RDhciw_SJATvfMwWaRuRWmy6HTs5XwjZWA\"",

    "\"Soverin=FahUxNiLlV0vcBOw\"",
    "\"v=spf1 include:soverin.net ~all\"",
  ]
}
resource "google_dns_record_set" "txt_sub" {
  managed_zone = google_dns_managed_zone.this.name

  name = "*.${google_dns_managed_zone.this.dns_name}"
  type = "TXT"
  ttl  = 300

  rrdatas = [
    "\"v=spf1 include:soverin.net ~all\"",
  ]
}
resource "google_dns_record_set" "dmarc" {
  managed_zone = google_dns_managed_zone.this.name

  name = "_dmarc.${google_dns_managed_zone.this.dns_name}"
  type = "CNAME"
  ttl  = 300

  rrdatas = [
    "reject._dmarc.soverin.net.",
  ]
}
resource "google_dns_record_set" "soverin" {
  for_each = toset([
    "soverin1._domainkey",
    "soverin2._domainkey",
    "soverin3._domainkey",
  ])

  managed_zone = google_dns_managed_zone.this.name

  name = "${each.key}.${google_dns_managed_zone.this.dns_name}"
  type = "CNAME"
  ttl  = 300

  rrdatas = [
    "${each.key}.soverin.net.",
  ]
}
resource "google_dns_record_set" "github" {
  managed_zone = google_dns_managed_zone.this.name

  name = "_gh-hours-sh-o.${google_dns_managed_zone.this.dns_name}"
  type = "TXT"
  ttl  = 300

  rrdatas = [
    "eec3e9600f",
  ]
}
resource "scaleway_tem_domain" "this" {
  name       = google_dns_managed_zone.scw.dns_name
  region     = "fr-par"
  autoconfig = false
  accept_tos = true
}
resource "scaleway_tem_domain_validation" "this" {
  domain_id = scaleway_tem_domain.this.id
  region    = "fr-par"
}
resource "google_dns_record_set" "scaleway_txt" {
  managed_zone = google_dns_managed_zone.scw.name

  name = google_dns_managed_zone.scw.dns_name
  type = "TXT"
  ttl  = 300

  rrdatas = [
    "\"v=spf1 ${scaleway_tem_domain.this.spf_config} ~all\"",
  ]
}
resource "google_dns_record_set" "scaleway_dkim" {
  managed_zone = google_dns_managed_zone.scw.name

  name = "${scaleway_tem_domain.this.project_id}._domainkey.${google_dns_managed_zone.scw.dns_name}"
  type = "TXT"
  ttl  = 300

  rrdatas = [
    # splits string into 255 character chunks and enquotes them
    join(" ", [for chunk in chunklist(split("", scaleway_tem_domain.this.dkim_config), 255) : "\"${join("", chunk)}\""]),
  ]
}
resource "google_dns_record_set" "scaleway_dmarc" {
  managed_zone = google_dns_managed_zone.scw.name

  name = scaleway_tem_domain.this.dmarc_name
  type = "TXT"
  ttl  = 300

  rrdatas = [
    "\"${scaleway_tem_domain.this.dmarc_config}\"",
  ]
}
resource "google_dns_record_set" "scaleway_mx" {
  managed_zone = google_dns_managed_zone.scw.name

  name = google_dns_managed_zone.scw.dns_name
  type = "MX"
  ttl  = 300

  rrdatas = [
    "10 mx.soverin.net.",
  ]
}

# repos
resource "github_repository" "this" {
  name        = "org"
  description = "manages repos and other github related stuff"

  allow_auto_merge       = true
  allow_merge_commit     = true
  allow_squash_merge     = false
  allow_rebase_merge     = false
  auto_init              = false
  delete_branch_on_merge = false
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  visibility             = "public"

  topics = [
    "terraform",
    "github",
  ]
}
