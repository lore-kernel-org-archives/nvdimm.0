Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id ED92C1A1DF5
 for <linux-nvdimm@lists.01.org>; Wed, 10 Aug 2016 16:15:01 -0700 (PDT)
Subject: [PATCH] tools/testing/nvdimm: fix SIGTERM vs hotplug crash
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 Aug 2016 16:12:37 -0700
Message-ID: <147087075735.18629.14311638005696918639.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The unit tests crash when hotplug races the previous probe. This race
requires that the loading of the nfit_test module be terminated with
SIGTERM, and the module to be unloaded while the ars scan is still
running.

In contrast to the normal nfit driver, the unit test calls
acpi_nfit_init() twice to simulate hotplug, whereas the nominal case
goes through the acpi_nfit_notify() event handler.  The
acpi_nfit_notify() path is careful to flush the previous region
registration before servicing the hotplug event. The unit test was
missing this guarantee.

 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<ffffffff810cdce7>] pwq_activate_delayed_work+0x47/0x170
 [..]
 Call Trace:
  [<ffffffff810ce186>] pwq_dec_nr_in_flight+0x66/0xa0
  [<ffffffff810ce490>] process_one_work+0x2d0/0x680
  [<ffffffff810ce331>] ? process_one_work+0x171/0x680
  [<ffffffff810ce88e>] worker_thread+0x4e/0x480
  [<ffffffff810ce840>] ? process_one_work+0x680/0x680
  [<ffffffff810ce840>] ? process_one_work+0x680/0x680
  [<ffffffff810d5343>] kthread+0xf3/0x110
  [<ffffffff8199846f>] ret_from_fork+0x1f/0x40
  [<ffffffff810d5250>] ? kthread_create_on_node+0x230/0x230

Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 5404efa578a3..dd48f421844c 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/workqueue.h>
 #include <linux/libnvdimm.h>
 #include <linux/vmalloc.h>
 #include <linux/device.h>
@@ -1474,6 +1475,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 	if (nfit_test->setup != nfit_test0_setup)
 		return 0;
 
+	flush_work(&acpi_desc->work);
 	nfit_test->setup_hotplug = 1;
 	nfit_test->setup(nfit_test);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
