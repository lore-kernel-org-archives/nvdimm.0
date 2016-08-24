Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1DCD1A1E3B
 for <linux-nvdimm@lists.01.org>; Wed, 24 Aug 2016 09:18:30 -0700 (PDT)
Subject: [PATCH] dax: fix device-dax region base
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Aug 2016 09:16:07 -0700
Message-ID: <147205536732.1606.8994275381938837346.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Abhilash Kumar Mulumudi <m.abhilash-kumar@hpe.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The data offset for a dax region needs to account for a reservation in
the resource range.  Otherwise, device-dax is allowing mappings directly
into the memmap or device-info-block area with crash signatures like the
following:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
 IP: [<ffffffff811ac851>] get_zone_device_page+0x11/0x30
 Call Trace:
   follow_devmap_pmd+0x298/0x2c0
   follow_page_mask+0x275/0x530
   __get_user_pages+0xe3/0x750
   __gfn_to_pfn_memslot+0x1b2/0x450 [kvm]
   ? hrtimer_try_to_cancel+0x2c/0x120
   ? kvm_read_l1_tsc+0x55/0x60 [kvm]
   try_async_pf+0x66/0x230 [kvm]
   ? kvm_host_page_size+0x90/0xa0 [kvm]
   tdp_page_fault+0x130/0x280 [kvm]
   kvm_mmu_page_fault+0x5f/0xf0 [kvm]
   handle_ept_violation+0x94/0x180 [kvm_intel]
   vmx_handle_exit+0x1d3/0x1440 [kvm_intel]
   ? atomic_switch_perf_msrs+0x6f/0xa0 [kvm_intel]
   ? vmx_vcpu_run+0x2d1/0x490 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0x81d/0x16a0 [kvm]
   ? wake_up_q+0x44/0x80
   kvm_vcpu_ioctl+0x33c/0x620 [kvm]
   ? __vfs_write+0x37/0x160
   do_vfs_ioctl+0xa2/0x5d0
   SyS_ioctl+0x79/0x90
   entry_SYSCALL_64_fastpath+0x1a/0xa4

Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: ab68f2622136 ("/dev/dax, pmem: direct access to persistent memory")
Reported-by: Abhilash Kumar Mulumudi <m.abhilash-kumar@hpe.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Tested-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/pmem.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index dfb168568af1..1f01e98c83c7 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -116,6 +116,9 @@ static int dax_pmem_probe(struct device *dev)
 	if (rc)
 		return rc;
 
+	/* adjust the dax_region resource to the start of data */
+	res.start += le64_to_cpu(pfn_sb->dataoff);
+
 	nd_region = to_nd_region(dev->parent);
 	dax_region = alloc_dax_region(dev, nd_region->id, &res,
 			le32_to_cpu(pfn_sb->align), addr, PFN_DEV|PFN_MAP);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
