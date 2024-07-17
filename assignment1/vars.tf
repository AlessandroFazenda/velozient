variable "frontendvm" {
  type = map(object({
    computername = string
    computersize = string
    ospublisher  = string
    osoffer      = string
    ossku        = string
    osversion    = string
    osdisksize   = number
  }))
}

variable "backendvm" {
  type = map(object({
    computername = string
    computersize = string
    ospublisher  = string
    osoffer      = string
    ossku        = string
    osversion    = string
    osdisksize   = number
  }))
}
