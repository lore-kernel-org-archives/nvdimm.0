Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7DE42119EF3A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Dec 2018 16:45:40 -0800 (PST)
Subject: [driver-core PATCH v9 9/9] driver core: Rewrite
 test_async_driver_probe to cover serialization and NUMA affinity
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 12 Dec 2018 16:45:40 -0800
Message-ID: <154466194015.9126.17353800566619470679.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154466182249.9126.3905559325944768059.stgit@ahduyck-desk1.jf.intel.com>
References: <154466182249.9126.3905559325944768059.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, bvanassche@acm.org, linux-pm@vger.kernel.org, alexander.h.duyck@linux.intel.com, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, mcgrof@kernel.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The current async_probe test code is only testing one device allocated
prior to driver load and only loading one device afterwards. Instead of
doing things this way it makes much more sense to load one device per CPU
in order to actually stress the async infrastructure. By doing this we
should see delays significantly increase in the event of devices being
serialized.

In addition I have updated the test to verify that we are trying to place
the work on the correct NUMA node when we are running in async mode. By
doing this we can verify the best possible outcome for device and driver
load times.

I have added a timeout value that is used to disable the sleep and instead
cause the probe routine to report an error indicating it timed out. By
doing this we limit the maximum runtime for the test to 20 seconds or less.

The last major change in this set is that I have gone through and tuned it
for handling the massive number of possible events that will be scheduled.
Instead of reporting the sleep for each individual device it is moved to
only being displayed if we enable debugging.

With this patch applied below are what a failing test and a passing test
should look like. I elided a few hundred lines in the failing test that
were duplicated since the system I was testing on had a massive number of
CPU cores:

-- Failing --
[  243.524697] test_async_driver_probe: registering first set of asynchronous devices...
[  243.535625] test_async_driver_probe: registering asynchronous driver...
[  243.543038] test_async_driver_probe: registration took 0 msecs
[  243.549559] test_async_driver_probe: registering second set of asynchronous devices...
[  243.568350] platform test_async_driver.447: registration took 9 msecs
[  243.575544] test_async_driver_probe: registering first synchronous device...
[  243.583454] test_async_driver_probe: registering synchronous driver...
[  248.825920] test_async_driver_probe: registration took 5235 msecs
[  248.825922] test_async_driver_probe: registering second synchronous device...
[  248.825928] test_async_driver test_async_driver.443: NUMA node mismatch 3 != 1
[  248.825932] test_async_driver test_async_driver.445: NUMA node mismatch 3 != 1
[  248.825935] test_async_driver test_async_driver.446: NUMA node mismatch 3 != 1
[  248.825939] test_async_driver test_async_driver.440: NUMA node mismatch 3 != 1
[  248.825943] test_async_driver test_async_driver.441: NUMA node mismatch 3 != 1
...
[  248.827150] test_async_driver test_async_driver.229: NUMA node mismatch 0 != 1
[  248.827158] test_async_driver test_async_driver.228: NUMA node mismatch 0 != 1
[  248.827220] test_async_driver test_async_driver.281: NUMA node mismatch 2 != 1
[  248.827229] test_async_driver test_async_driver.282: NUMA node mismatch 2 != 1
[  248.827240] test_async_driver test_async_driver.280: NUMA node mismatch 2 != 1
[  253.945834] test_async_driver test_async_driver.1: NUMA node mismatch 0 != 1
[  253.945878] test_sync_driver test_sync_driver.1: registration took 5119 msecs
[  253.961693] test_async_driver_probe: async events still pending, forcing timeout and synchronize
[  259.065839] test_async_driver test_async_driver.2: NUMA node mismatch 0 != 1
[  259.073786] test_async_driver test_async_driver.3: async probe took too long
[  259.081669] test_async_driver test_async_driver.3: NUMA node mismatch 0 != 1
[  259.089569] test_async_driver test_async_driver.4: async probe took too long
[  259.097451] test_async_driver test_async_driver.4: NUMA node mismatch 0 != 1
[  259.105338] test_async_driver test_async_driver.5: async probe took too long
[  259.113204] test_async_driver test_async_driver.5: NUMA node mismatch 0 != 1
[  259.121089] test_async_driver test_async_driver.6: async probe took too long
[  259.128961] test_async_driver test_async_driver.6: NUMA node mismatch 0 != 1
[  259.136850] test_async_driver test_async_driver.7: async probe took too long
...
[  262.124062] test_async_driver test_async_driver.221: async probe took too long
[  262.132130] test_async_driver test_async_driver.221: NUMA node mismatch 3 != 1
[  262.140206] test_async_driver test_async_driver.222: async probe took too long
[  262.148277] test_async_driver test_async_driver.222: NUMA node mismatch 3 != 1
[  262.156351] test_async_driver test_async_driver.223: async probe took too long
[  262.164419] test_async_driver test_async_driver.223: NUMA node mismatch 3 != 1
[  262.172630] test_async_driver_probe: Test failed with 222 errors and 336 warnings

-- Passing --
[  105.419247] test_async_driver_probe: registering first set of asynchronous devices...
[  105.432040] test_async_driver_probe: registering asynchronous driver...
[  105.439718] test_async_driver_probe: registration took 0 msecs
[  105.446239] test_async_driver_probe: registering second set of asynchronous devices...
[  105.477986] platform test_async_driver.447: registration took 22 msecs
[  105.485276] test_async_driver_probe: registering first synchronous device...
[  105.493169] test_async_driver_probe: registering synchronous driver...
[  110.597981] test_async_driver_probe: registration took 5097 msecs
[  110.604806] test_async_driver_probe: registering second synchronous device...
[  115.707490] test_sync_driver test_sync_driver.1: registration took 5094 msecs
[  115.715478] test_async_driver_probe: completed successfully

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/test/test_async_driver_probe.c |  261 +++++++++++++++++++++------
 1 file changed, 201 insertions(+), 60 deletions(-)

diff --git a/drivers/base/test/test_async_driver_probe.c b/drivers/base/test/test_async_driver_probe.c
index e7f145d662f0..f4b1d8e54daf 100644
--- a/drivers/base/test/test_async_driver_probe.c
+++ b/drivers/base/test/test_async_driver_probe.c
@@ -11,16 +11,47 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/time.h>
+#include <linux/numa.h>
+#include <linux/nodemask.h>
+#include <linux/topology.h>
 
 #define TEST_PROBE_DELAY	(5 * 1000)	/* 5 sec */
 #define TEST_PROBE_THRESHOLD	(TEST_PROBE_DELAY / 2)
 
+static atomic_t warnings, errors, timeout, async_completed;
+
 static int test_probe(struct platform_device *pdev)
 {
-	dev_info(&pdev->dev, "sleeping for %d msecs in probe\n",
-		 TEST_PROBE_DELAY);
-	msleep(TEST_PROBE_DELAY);
-	dev_info(&pdev->dev, "done sleeping\n");
+	struct device *dev = &pdev->dev;
+
+	/*
+	 * Determine if we have hit the "timeout" limit for the test if we
+	 * have then report it as an error, otherwise we wil sleep for the
+	 * required amount of time and then report completion.
+	 */
+	if (atomic_read(&timeout)) {
+		dev_err(dev, "async probe took too long\n");
+		atomic_inc(&errors);
+	} else {
+		dev_dbg(&pdev->dev, "sleeping for %d msecs in probe\n",
+			 TEST_PROBE_DELAY);
+		msleep(TEST_PROBE_DELAY);
+		dev_dbg(&pdev->dev, "done sleeping\n");
+	}
+
+	/*
+	 * Report NUMA mismatch if device node is set and we are not
+	 * performing an async init on that node.
+	 */
+	if (dev->driver->probe_type == PROBE_PREFER_ASYNCHRONOUS) {
+		if (dev_to_node(dev) != numa_node_id()) {
+			dev_warn(dev, "NUMA node mismatch %d != %d\n",
+				 dev_to_node(dev), numa_node_id());
+			atomic_inc(&warnings);
+		}
+
+		atomic_inc(&async_completed);
+	}
 
 	return 0;
 }
@@ -41,31 +72,64 @@ static struct platform_driver sync_driver = {
 	.probe = test_probe,
 };
 
-static struct platform_device *async_dev_1, *async_dev_2;
-static struct platform_device *sync_dev_1;
+static struct platform_device *async_dev[NR_CPUS * 2];
+static struct platform_device *sync_dev[2];
+
+static struct platform_device *
+test_platform_device_register_node(char *name, int id, int nid)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	pdev = platform_device_alloc(name, id);
+	if (!pdev)
+		return NULL;
+
+	if (nid != NUMA_NO_NODE)
+		set_dev_node(&pdev->dev, nid);
+
+	ret = platform_device_add(pdev);
+	if (ret) {
+		platform_device_put(pdev);
+		return ERR_PTR(ret);
+	}
+
+	return pdev;
+
+}
 
 static int __init test_async_probe_init(void)
 {
-	ktime_t calltime, delta;
+	struct platform_device **pdev = NULL;
+	int async_id = 0, sync_id = 0;
 	unsigned long long duration;
-	int error;
+	ktime_t calltime, delta;
+	int err, nid, cpu;
+
+	pr_info("registering first set of asynchronous devices...\n");
 
-	pr_info("registering first asynchronous device...\n");
+	for_each_online_cpu(cpu) {
+		nid = cpu_to_node(cpu);
+		pdev = &async_dev[async_id];
+		*pdev =	test_platform_device_register_node("test_async_driver",
+							   async_id,
+							   nid);
+		if (IS_ERR(*pdev)) {
+			err = PTR_ERR(*pdev);
+			*pdev = NULL;
+			pr_err("failed to create async_dev: %d\n", err);
+			goto err_unregister_async_devs;
+		}
 
-	async_dev_1 = platform_device_register_simple("test_async_driver", 1,
-						      NULL, 0);
-	if (IS_ERR(async_dev_1)) {
-		error = PTR_ERR(async_dev_1);
-		pr_err("failed to create async_dev_1: %d\n", error);
-		return error;
+		async_id++;
 	}
 
 	pr_info("registering asynchronous driver...\n");
 	calltime = ktime_get();
-	error = platform_driver_register(&async_driver);
-	if (error) {
-		pr_err("Failed to register async_driver: %d\n", error);
-		goto err_unregister_async_dev_1;
+	err = platform_driver_register(&async_driver);
+	if (err) {
+		pr_err("Failed to register async_driver: %d\n", err);
+		goto err_unregister_async_devs;
 	}
 
 	delta = ktime_sub(ktime_get(), calltime);
@@ -73,86 +137,163 @@ static int __init test_async_probe_init(void)
 	pr_info("registration took %lld msecs\n", duration);
 	if (duration > TEST_PROBE_THRESHOLD) {
 		pr_err("test failed: probe took too long\n");
-		error = -ETIMEDOUT;
+		err = -ETIMEDOUT;
 		goto err_unregister_async_driver;
 	}
 
-	pr_info("registering second asynchronous device...\n");
+	pr_info("registering second set of asynchronous devices...\n");
 	calltime = ktime_get();
-	async_dev_2 = platform_device_register_simple("test_async_driver", 2,
-						      NULL, 0);
-	if (IS_ERR(async_dev_2)) {
-		error = PTR_ERR(async_dev_2);
-		pr_err("failed to create async_dev_2: %d\n", error);
-		goto err_unregister_async_driver;
+	for_each_online_cpu(cpu) {
+		nid = cpu_to_node(cpu);
+		pdev = &sync_dev[sync_id];
+
+		*pdev = test_platform_device_register_node("test_async_driver",
+							   async_id,
+							   nid);
+		if (IS_ERR(*pdev)) {
+			err = PTR_ERR(*pdev);
+			*pdev = NULL;
+			pr_err("failed to create async_dev: %d\n", err);
+			goto err_unregister_async_driver;
+		}
+
+		async_id++;
 	}
 
 	delta = ktime_sub(ktime_get(), calltime);
 	duration = (unsigned long long) ktime_to_ms(delta);
-	pr_info("registration took %lld msecs\n", duration);
+	dev_info(&(*pdev)->dev,
+		 "registration took %lld msecs\n", duration);
 	if (duration > TEST_PROBE_THRESHOLD) {
-		pr_err("test failed: probe took too long\n");
-		error = -ETIMEDOUT;
-		goto err_unregister_async_dev_2;
+		dev_err(&(*pdev)->dev,
+			"test failed: probe took too long\n");
+		err = -ETIMEDOUT;
+		goto err_unregister_async_driver;
 	}
 
-	pr_info("registering synchronous driver...\n");
 
-	error = platform_driver_register(&sync_driver);
-	if (error) {
-		pr_err("Failed to register async_driver: %d\n", error);
-		goto err_unregister_async_dev_2;
+	pr_info("registering first synchronous device...\n");
+	nid = cpu_to_node(cpu);
+	pdev = &sync_dev[sync_id];
+
+	*pdev = test_platform_device_register_node("test_sync_driver",
+						   sync_id,
+						   NUMA_NO_NODE);
+	if (IS_ERR(*pdev)) {
+		err = PTR_ERR(*pdev);
+		*pdev = NULL;
+		pr_err("failed to create sync_dev: %d\n", err);
+		goto err_unregister_async_driver;
 	}
 
-	pr_info("registering synchronous device...\n");
+	sync_id++;
+
+	pr_info("registering synchronous driver...\n");
 	calltime = ktime_get();
-	sync_dev_1 = platform_device_register_simple("test_sync_driver", 1,
-						     NULL, 0);
-	if (IS_ERR(sync_dev_1)) {
-		error = PTR_ERR(sync_dev_1);
-		pr_err("failed to create sync_dev_1: %d\n", error);
-		goto err_unregister_sync_driver;
+	err = platform_driver_register(&sync_driver);
+	if (err) {
+		pr_err("Failed to register async_driver: %d\n", err);
+		goto err_unregister_sync_devs;
 	}
 
 	delta = ktime_sub(ktime_get(), calltime);
 	duration = (unsigned long long) ktime_to_ms(delta);
 	pr_info("registration took %lld msecs\n", duration);
 	if (duration < TEST_PROBE_THRESHOLD) {
-		pr_err("test failed: probe was too quick\n");
-		error = -ETIMEDOUT;
-		goto err_unregister_sync_dev_1;
+		dev_err(&(*pdev)->dev,
+			"test failed: probe was too quick\n");
+		err = -ETIMEDOUT;
+		goto err_unregister_sync_driver;
 	}
 
-	pr_info("completed successfully");
+	pr_info("registering second synchronous device...\n");
+	pdev = &sync_dev[sync_id];
+	calltime = ktime_get();
 
-	return 0;
+	*pdev = test_platform_device_register_node("test_sync_driver",
+						   sync_id,
+						   NUMA_NO_NODE);
+	if (IS_ERR(*pdev)) {
+		err = PTR_ERR(*pdev);
+		*pdev = NULL;
+		pr_err("failed to create sync_dev: %d\n", err);
+		goto err_unregister_sync_driver;
+	}
 
-err_unregister_sync_dev_1:
-	platform_device_unregister(sync_dev_1);
+	sync_id++;
 
-err_unregister_sync_driver:
-	platform_driver_unregister(&sync_driver);
+	delta = ktime_sub(ktime_get(), calltime);
+	duration = (unsigned long long) ktime_to_ms(delta);
+	dev_info(&(*pdev)->dev,
+		 "registration took %lld msecs\n", duration);
+	if (duration < TEST_PROBE_THRESHOLD) {
+		dev_err(&(*pdev)->dev,
+			"test failed: probe was too quick\n");
+		err = -ETIMEDOUT;
+		goto err_unregister_sync_driver;
+	}
 
-err_unregister_async_dev_2:
-	platform_device_unregister(async_dev_2);
+	/*
+	 * The async events should have completed while we were taking care
+	 * of the synchronous events. We will now terminate any outstanding
+	 * asynchronous probe calls remaining by forcing timeout and remove
+	 * the driver before we return which should force the flush of the
+	 * pending asynchronous probe calls.
+	 *
+	 * Otherwise if they completed without errors or warnings then
+	 * report successful completion.
+	 */
+	if (atomic_read(&async_completed) != async_id) {
+		pr_err("async events still pending, forcing timeout\n");
+		atomic_inc(&timeout);
+		err = -ETIMEDOUT;
+	} else if (!atomic_read(&errors) && !atomic_read(&warnings)) {
+		pr_info("completed successfully\n");
+		return 0;
+	}
 
+err_unregister_sync_driver:
+	platform_driver_unregister(&sync_driver);
+err_unregister_sync_devs:
+	while (sync_id--)
+		platform_device_unregister(sync_dev[sync_id]);
 err_unregister_async_driver:
 	platform_driver_unregister(&async_driver);
+err_unregister_async_devs:
+	while (async_id--)
+		platform_device_unregister(async_dev[async_id]);
+
+	/*
+	 * If err is already set then count that as an additional error for
+	 * the test. Otherwise we will report an invalid argument error and
+	 * not count that as we should have reached here as a result of
+	 * errors or warnings being reported by the probe routine.
+	 */
+	if (err)
+		atomic_inc(&errors);
+	else
+		err = -EINVAL;
 
-err_unregister_async_dev_1:
-	platform_device_unregister(async_dev_1);
+	pr_err("Test failed with %d errors and %d warnings\n",
+	       atomic_read(&errors), atomic_read(&warnings));
 
-	return error;
+	return err;
 }
 module_init(test_async_probe_init);
 
 static void __exit test_async_probe_exit(void)
 {
+	int id = 2;
+
 	platform_driver_unregister(&async_driver);
 	platform_driver_unregister(&sync_driver);
-	platform_device_unregister(async_dev_1);
-	platform_device_unregister(async_dev_2);
-	platform_device_unregister(sync_dev_1);
+
+	while (id--)
+		platform_device_unregister(sync_dev[id]);
+
+	id = NR_CPUS * 2;
+	while (id--)
+		platform_device_unregister(async_dev[id]);
 }
 module_exit(test_async_probe_exit);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
