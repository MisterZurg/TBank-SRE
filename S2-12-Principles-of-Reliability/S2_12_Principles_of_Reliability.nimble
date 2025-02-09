# Package

packageName = "myproject"

version       = "0.1.0"
author        = "MisterZurg"
description   = "T-Bank Reliability Practices homework"
license       = "MIT"
srcDir        = "src"
# Executables nimble build
bin           = @["GetData", "GetDataWithCircuitBreaker"]


# Dependencies

requires "nim >= 2.2.0"
