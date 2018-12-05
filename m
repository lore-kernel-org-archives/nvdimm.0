Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [driver-core PATCH v8 8/9] PM core: Use new async_schedule_dev
 command
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 05 Dec 2018 09:25:55 -0800
Message-ID: <154403075493.11544.7355162444252477309.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
References: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: mcgrof@kernel.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com, bvanassche@acm.org, alexander.h.duyck@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Use the device specific version of the async_schedule commands to defer
various tasks related to power management. By doing this we should see a
slight improvement in performance as any device that is sensitive to
latency/locality in the setup will now be initializing on the node closest
to the device.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/power/main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index a690fd400260..ebb8b61b52e9 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -726,7 +726,7 @@ void dpm_noirq_resume_devices(pm_message_t state)
 		reinit_completion(&dev->power.completion);
 		if (is_async(dev)) {
 			get_device(dev);
-			async_schedule(async_resume_noirq, dev);
+			async_schedule_dev(async_resume_noirq, dev);
 		}
 	}
 
@@ -883,7 +883,7 @@ void dpm_resume_early(pm_message_t state)
 		reinit_completion(&dev->power.completion);
 		if (is_async(dev)) {
 			get_device(dev);
-			async_schedule(async_resume_early, dev);
+			async_schedule_dev(async_resume_early, dev);
 		}
 	}
 
@@ -1047,7 +1047,7 @@ void dpm_resume(pm_message_t state)
 		reinit_completion(&dev->power.completion);
 		if (is_async(dev)) {
 			get_device(dev);
-			async_schedule(async_resume, dev);
+			async_schedule_dev(async_resume, dev);
 		}
 	}
 
@@ -1366,7 +1366,7 @@ static int device_suspend_noirq(struct device *dev)
 
 	if (is_async(dev)) {
 		get_device(dev);
-		async_schedule(async_suspend_noirq, dev);
+		async_schedule_dev(async_suspend_noirq, dev);
 		return 0;
 	}
 	return __device_suspend_noirq(dev, pm_transition, false);
@@ -1569,7 +1569,7 @@ static int device_suspend_late(struct device *dev)
 
 	if (is_async(dev)) {
 		get_device(dev);
-		async_schedule(async_suspend_late, dev);
+		async_schedule_dev(async_suspend_late, dev);
 		return 0;
 	}
 
@@ -1833,7 +1833,7 @@ static int device_suspend(struct device *dev)
 
 	if (is_async(dev)) {
 		get_device(dev);
-		async_schedule(async_suspend, dev);
+		async_schedule_dev(async_suspend, dev);
 		return 0;
 	}
 
