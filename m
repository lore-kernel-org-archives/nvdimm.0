Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31A4E226516D8
 for <linux-nvdimm@lists.01.org>; Sat,  7 Apr 2018 09:48:52 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, test: fix pmem-errors.sh vs new ARS rework
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 07 Apr 2018 09:38:56 -0700
Message-ID: <152311913670.5287.392327526734931887.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Due to locking constraints the nfit_test implementation is not able to
internally trigger ARS, so just run and wait for ARS manually in this
test. For example, here is what happens if nfit_test call
acpi_nfit_ars_rescan() from within the ioctl path.

 WARNING: possible circular locking dependency detected
 4.16.0-rc4+ #1686 Tainted: G           OE
 ------------------------------------------------------
 kworker/u80:0/6 is trying to acquire lock:
  (&nvdimm_bus->reconfig_mutex){+.+.}, at: [<0000000048851014>] nvdimm_badblocks_populate+0x41/0x150 [libnvdimm]

 but task is already holding lock:
  (&acpi_desc->init_mutex){+.+.}, at: [<00000000016af3e5>] acpi_nfit_scrub+0x3b/0x2d0 [nfit]

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&acpi_desc->init_mutex){+.+.}:
        acpi_nfit_ars_rescan+0x28/0x160 [nfit]
        nfit_test_ctl+0x976/0x1040 [nfit_test]
        __nd_ioctl+0x5d8/0x650 [libnvdimm]
        nd_ioctl+0xa4/0xb0 [libnvdimm]
        do_vfs_ioctl+0xa5/0x6d0
        SyS_ioctl+0x74/0x80
        do_syscall_64+0x79/0x230
        entry_SYSCALL_64_after_hwframe+0x42/0xb7

 -> #0 (&nvdimm_bus->reconfig_mutex){+.+.}:
        __mutex_lock+0x7f/0xa00
        nvdimm_badblocks_populate+0x41/0x150 [libnvdimm]
        nd_region_notify+0x95/0xb0 [libnvdimm]
        nd_device_notify+0x40/0x50 [libnvdimm]
        ars_complete.isra.19+0x5d/0xb0 [nfit]
        ars_complete_all+0x42/0x60 [nfit]
        acpi_nfit_scrub+0x84/0x2d0 [nfit]
        process_one_work+0x212/0x660
        worker_thread+0x3a/0x390
        kthread+0x11e/0x140
        ret_from_fork+0x3a/0x50

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/pmem-errors.sh |    1 +
 1 file changed, 1 insertion(+)

diff --git a/test/pmem-errors.sh b/test/pmem-errors.sh
index 7c0487d1ac49..e0ab9e866b92 100755
--- a/test/pmem-errors.sh
+++ b/test/pmem-errors.sh
@@ -59,6 +59,7 @@ err_sector="$(((size/512) / 2))"
 err_count=8
 if ! read sector len < /sys/block/$blockdev/badblocks; then
 	$NDCTL inject-error --block="$err_sector" --count=$err_count $dev
+	$NDCTL start-scrub; $NDCTL wait-scrub
 fi
 read sector len < /sys/block/$blockdev/badblocks
 [ $((sector * 2)) -ne $((size /512)) ] && echo "fail: $LINENO" && false

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
