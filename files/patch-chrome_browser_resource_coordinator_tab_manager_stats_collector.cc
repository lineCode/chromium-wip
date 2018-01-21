--- chrome/browser/resource_coordinator/tab_manager_stats_collector.cc.orig	2018-01-21 04:52:11.831777000 +0100
+++ chrome/browser/resource_coordinator/tab_manager_stats_collector.cc	2018-01-21 04:54:53.165317000 +0100
@@ -273,12 +273,14 @@
     return;
   }
 
+#if !defined(OS_BSD)
   // Always create a new instance in case there is a SessionType change because
   // this is shared between SessionRestore and BackgroundTabOpening.
   swap_metrics_driver_ = content::SwapMetricsDriver::Create(
       base::WrapUnique<content::SwapMetricsDriver::Delegate>(
           new SwapMetricsDelegate(this, type)),
       base::TimeDelta::FromSeconds(0));
+#endif
   // The driver could still be null on a platform with no swap driver support.
   if (swap_metrics_driver_)
     swap_metrics_driver_->InitializeMetrics();
