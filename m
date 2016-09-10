Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 522791A1E02
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 18:44:41 -0700 (PDT)
Subject: [ndctl PATCH 2/3] test,
 device-dax: fix 'skip' reporting when test device not found
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Sep 2016 18:41:37 -0700
Message-ID: <147347169770.15190.17079545331805636573.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147347168712.15190.17312702584906386275.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147347168712.15190.17312702584906386275.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

If we are unable to find a test device, then the test should report
skipped.  However if any ndctl_test_attempt() succeeds prior to this
discovery ndctl_test_result() will return success (0) instead of skip
(77).  Re-arrange the 4.7 kernel version check to be after the device
availability check.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/device-dax.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/test/device-dax.c b/test/device-dax.c
index 04d53da544cd..c1409ac8b8b8 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -76,9 +76,6 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		return 1;
 	}
 
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
-		return 77;
-
 	ndctl_set_log_priority(ctx, loglevel);
 
 	ndns = ndctl_get_test_dev(ctx);
@@ -88,6 +85,9 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		return 77;
 	}
 
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
+		return 77;
+
 	rc = setup_device_dax(ndns);
 	if (rc < 0) {
 		fprintf(stderr, "%s: failed device-dax setup\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
