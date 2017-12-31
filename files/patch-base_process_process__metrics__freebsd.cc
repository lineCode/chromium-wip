--- base/process/process_metrics_freebsd.cc.orig	2017-12-15 02:04:05.000000000 +0100
+++ base/process/process_metrics_freebsd.cc	2017-12-25 04:01:32.104385000 +0100
@@ -12,6 +12,10 @@
 #include "base/macros.h"
 #include "base/memory/ptr_util.h"
 
+#include <unistd.h> /* getpagesize() */
+#include <fcntl.h>  /* O_RDONLY */
+#include <kvm.h>
+
 namespace base {
 
 ProcessMetrics::ProcessMetrics(ProcessHandle process)
@@ -118,6 +122,25 @@
   pagesize = getpagesize();
 
   return mem_total - (mem_free*pagesize) - (mem_inactive*pagesize);
+}
+
+int GetNumberOfThreads(ProcessHandle process) {
+  // Taken from FreeBSD top (usr.bin/top/machine.c)
+
+  kvm_t* kd = kvm_open(NULL, "/dev/null", NULL, O_RDONLY, "kvm_open");
+  if (kd == NULL)
+    return 0;
+
+  struct kinfo_proc* pbase;
+  int nproc;
+  pbase = kvm_getprocs(kd, KERN_PROC_PID, process, &nproc);
+  if (pbase == NULL)
+    return 0;
+
+  if (kvm_close(kd) == -1)
+    return 0;
+
+  return nproc;
 }
 
 }  // namespace base
