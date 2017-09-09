--- base/process/process_metrics_posix.cc.orig	2017-09-05 21:05:11.000000000 +0200
+++ base/process/process_metrics_posix.cc	2017-09-07 06:31:36.689570000 +0200
@@ -14,11 +14,13 @@
 #include "base/logging.h"
 #include "build/build_config.h"
 
+#if !defined(OS_FREEBSD)
 #if defined(OS_MACOSX)
 #include <malloc/malloc.h>
 #else
 #include <malloc.h>
 #endif
+#endif
 
 namespace base {
 
@@ -103,8 +105,9 @@
 #endif
 #elif defined(OS_FUCHSIA)
   // TODO(fuchsia): Not currently exposed. https://crbug.com/735087.
-  return 0;
+  NOTIMPLEMENTED();
 #endif
+  return 0;
 }
 
 }  // namespace base
