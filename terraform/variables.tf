variable "AWS_DEFAULT_REGION" {
  description = "La région AWS où l'infrastructure sera déployée (ex: eu-west-3)."
  type        = string
}

variable "AWS_ACCESS_KEY_ID" {
  description = "L'ID de la clé d'accès AWS."
  type        = string
  sensitive   = true 
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "La clé d'accès secrète AWS."
  type        = string
  sensitive   = true
}
