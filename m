Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 814C4803B4
 for <linux-nvdimm@lists.01.org>; Fri, 10 Mar 2017 12:24:38 -0800 (PST)
Subject: [PATCH v3 2/2] dax: fix device-dax pud fault handling so that it
 would fallback
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 10 Mar 2017 13:24:27 -0700
Message-ID: <148917746786.14458.9717735467489485885.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148917746248.14458.15705199130846001839.stgit@djiang5-desk3.ch.intel.com>
References: <148917746248.14458.15705199130846001839.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Jeff Moyer reports that:
"
With a device dax alignment of 4KB or 2MB, I get sigbus when running the
attached fio job file for the current kernel (4.11.0-rc1+).  If I
specify an alignment of 1GB, it works.

I turned on debug output, and saw that it was failing in the huge fault
code.

[ 4614.138357] dax dax1.0: dax_open
[ 4614.154838] dax dax1.0: dax_mmap
[ 4614.171898] dax dax1.0: dax_dev_huge_fault: fio: write (0x7f08f0a00000 - 0x7f0ce0800000)
[ 4614.211720] dax dax1.0: __dax_dev_pud_fault: phys_to_pgoff(0xffffffffcf600) failed
[ 4614.568911] dax dax1.0: dax_release

fio config for reproduce:
[global]
ioengine=dev-dax
direct=0
filename=/dev/dax0.0
bs=2m

[write]
rw=write

[read]
stonewall
rw=read
"

It looks like the code does not fallback at all when handling faults. Adding
additional boundary checks and code that determines when to fallback. This
patch is part 2 that fixes the pud handler.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/dax.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 828f168..80c6db279 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -518,6 +518,8 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	pfn_t pfn;
+	unsigned int fault_size = PUD_SIZE;
+
 
 	if (check_vma(dax_dev, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
@@ -534,6 +536,16 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 	}
 
+	if (fault_size < dax_region->align)
+		return VM_FAULT_SIGBUS;
+	else if (fault_size > dax_region->align)
+		return VM_FAULT_FALLBACK;
+
+	/* if we are outside of the VMA */
+	if (pud_addr < vmf->vma->vm_start ||
+			(pud_addr + PUD_SIZE) > vmf->vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
 	pgoff = linear_page_index(vmf->vma, pud_addr);
 	phys = pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
 	if (phys == -1) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
