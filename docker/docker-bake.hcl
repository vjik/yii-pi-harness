variable "DEBIAN_VERSION" {
  default = "13"
}

variable "HTTP_PROXY" {
  default = ""
}

variable "HTTPS_PROXY" {
  default = ""
}

variable "CURL_CONNECT_TIMEOUT" {
  default = "7"
}

group "default" {
  targets = ["pi", "claude-code"]
}

target "common" {
  args = {
    HTTP_PROXY  = HTTP_PROXY
    HTTPS_PROXY = HTTPS_PROXY
    CURL_CONNECT_TIMEOUT = CURL_CONNECT_TIMEOUT
  }
}

target "php-builder" {
  inherits   = ["common"]
  dockerfile = "docker/php-builder/Dockerfile"
  context    = "."
  args = {
    DEBIAN_VERSION = DEBIAN_VERSION
  }
}

target "php-8-1" {
  inherits   = ["common"]
  dockerfile = "docker/php-8.1/Dockerfile"
  context    = "."
  contexts = {
    php-builder = "target:php-builder"
  }
}

target "php-8-2" {
  inherits   = ["common"]
  dockerfile = "docker/php-8.2/Dockerfile"
  context    = "."
  contexts = {
    php-builder = "target:php-builder"
  }
}

target "php-8-3" {
  inherits   = ["common"]
  dockerfile = "docker/php-8.3/Dockerfile"
  context    = "."
  contexts = {
    php-builder = "target:php-builder"
  }
}

target "php-8-4" {
  inherits   = ["common"]
  dockerfile = "docker/php-8.4/Dockerfile"
  context    = "."
  contexts = {
    php-builder = "target:php-builder"
  }
}

target "php-8-5" {
  inherits   = ["common"]
  dockerfile = "docker/php-8.5/Dockerfile"
  context    = "."
  contexts = {
    php-builder = "target:php-builder"
  }
}

target "base" {
  inherits   = ["common"]
  dockerfile = "docker/Dockerfile"
  target     = "base"
  context    = "."
  contexts = {
    php-8-1 = "target:php-8-1"
    php-8-2 = "target:php-8-2"
    php-8-3 = "target:php-8-3"
    php-8-4 = "target:php-8-4"
    php-8-5 = "target:php-8-5"
  }
  args = {
    DEBIAN_VERSION = DEBIAN_VERSION
  }
}

target "pi" {
  inherits = ["base"]
  target = "pi"
  tags = ["ghcr.io/yiisoft-contrib/pi-harness:latest"]
}

target "claude-code" {
  inherits = ["base"]
  target = "claude-code"
  tags = ["ghcr.io/yiisoft-contrib/claude-code-harness:latest"]
}
