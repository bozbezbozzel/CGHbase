Same CGHbase except with hg38 centromere and chromosome length added.

```
devtools::install_github("bozbezbozzel/CGHbase")
library(CGHbase)
library(CGHcall)
 
#sanity check that R is using the hg38 version
getAnywhere(.getCentromere)
```
