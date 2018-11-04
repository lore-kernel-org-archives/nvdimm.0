Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 487C22115C33C
 for <linux-nvdimm@lists.01.org>; Sat,  3 Nov 2018 18:17:47 -0700 (PDT)
Subject: [PATCH] Revert "acpi,
 nfit: Further restrict userspace ARS start requests"
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 03 Nov 2018 18:05:58 -0700
Message-ID: <154129355792.421728.127261092571335116.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The following lockdep splat results from acquiring the init_mutex in
acpi_nfit_clear_to_send():

 WARNING: possible circular locking dependency detected
 lt-daxdev-error/7216 is trying to acquire lock:
 00000000f694db15 (&acpi_desc->init_mutex){+.+.}, at: acpi_nfit_clear_to_send+0x27/0x80 [nfit]

 but task is already holding lock:
 00000000182298f2 (&nvdimm_bus->reconfig_mutex){+.+.}, at: __nd_ioctl+0x457/0x610 [libnvdimm]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&nvdimm_bus->reconfig_mutex){+.+.}:
        nvdimm_badblocks_populate+0x41/0x150 [libnvdimm]
        nd_region_notify+0x95/0xb0 [libnvdimm]
        nd_device_notify+0x40/0x50 [libnvdimm]
        ars_complete+0x7f/0xd0 [nfit]
        acpi_nfit_scrub+0xbb/0x410 [nfit]
        process_one_work+0x22b/0x5c0
        worker_thread+0x3c/0x390
        kthread+0x11e/0x140
        ret_from_fork+0x3a/0x50

 -> #0 (&acpi_desc->init_mutex){+.+.}:
        __mutex_lock+0x83/0x980
        acpi_nfit_clear_to_send+0x27/0x80 [nfit]
        __nd_ioctl+0x474/0x610 [libnvdimm]
        nd_ioctl+0xa4/0xb0 [libnvdimm]
        do_vfs_ioctl+0xa5/0x6e0
        ksys_ioctl+0x70/0x80
        __x64_sys_ioctl+0x16/0x20
        do_syscall_64+0x60/0x210
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

New infrastructure is needed to be able to perform this check without
acquiring the lock.

Fixes: 594861215c83 ("acpi, nfit: Further restrict userspace ARS start")
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5970b8f5f768..14d9f5bea015 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3341,8 +3341,6 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
-	struct nfit_spa *nfit_spa;
-	int rc = 0;
 
 	if (nvdimm)
 		return 0;
@@ -3355,17 +3353,10 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	 * just needs guarantees that any ARS it initiates are not
 	 * interrupted by any intervening start requests from userspace.
 	 */
-	mutex_lock(&acpi_desc->init_mutex);
-	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
-		if (acpi_desc->scrub_spa
-				|| test_bit(ARS_REQ_SHORT, &nfit_spa->ars_state)
-				|| test_bit(ARS_REQ_LONG, &nfit_spa->ars_state)) {
-			rc = -EBUSY;
-			break;
-		}
-	mutex_unlock(&acpi_desc->init_mutex);
+	if (work_busy(&acpi_desc->dwork.work))
+		return -EBUSY;
 
-	return rc;
+	return 0;
 }
 
 int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
