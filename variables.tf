variable "access_key" {

}
variable "secret_key" {

}
variable "image_id" {

}
variable "instance_type" {

}

variable ports {
    type = list(number)
    default = [22,80,443,3306,27017]

}