Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x232.google.com (mail-ot0-x232.google.com
 [IPv6:2607:f8b0:4003:c0f::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36206802BF
 for <linux-nvdimm@lists.01.org>; Sat, 18 Mar 2017 09:32:39 -0700 (PDT)
Received: by mail-ot0-x232.google.com with SMTP id o24so111911835otb.1
 for <linux-nvdimm@lists.01.org>; Sat, 18 Mar 2017 09:32:39 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 18 Mar 2017 09:32:37 -0700
Message-ID: <CAPcyv4howFv-RzVBhOr4Rcj08s2SCFRGY4gxwLoi19xfQbsSSw@mail.gmail.com>
Subject: [GIT PULL] device-dax fixes for 4.11-rc3
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive 2 fixes and a cleanup for device-dax.

The device-dax driver was not being careful to handle falling back to
smaller fault-granularity sizes. The driver already fails fault
attempts that are smaller than the device's alignment, but it also
needs to handle the cases where a larger page mapping could be
established. For simplicity of the immediate fix the implementation
just signals VM_FAULT_FALLBACK until fault-size == device-alignment.
One fix is for -stable to address pmd-to-pte fallback from the
original implementation, another fix is for the new (introduced in
4.11-rc1) pud-to-pmd regression, and a typo fix comes along for the
ride. These have received a build success notification from the kbuild
robot.

The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:

  Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 52084f89b38cdd896b59627c629915ef1a7bf615:

  device-dax: fix debug output typo (2017-03-10 19:56:56 -0800)

----------------------------------------------------------------
Dave Jiang (3):
      device-dax: fix pmd/pte fault fallback handling
      device-dax: fix pud fault fallback handling
      device-dax: fix debug output typo

 drivers/dax/dax.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

---

commit 0134ed4fb9e78672ee9f7b18007114404c81e63f
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri Mar 10 13:24:22 2017 -0700

    device-dax: fix pmd/pte fault fallback handling

    Jeff Moyer reports:

        With a device dax alignment of 4KB or 2MB, I get sigbus when running
        the attached fio job file for the current kernel (4.11.0-rc1+).  If
        I specify an alignment of 1GB, it works.

        I turned on debug output, and saw that it was failing in the huge
        fault code.

         dax dax1.0: dax_open
         dax dax1.0: dax_mmap
         dax dax1.0: dax_dev_huge_fault: fio: write (0x7f08f0a00000 -
         dax dax1.0: __dax_dev_pud_fault: phys_to_pgoff(0xffffffffcf60
         dax dax1.0: dax_release

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

    The driver fails to fallback when taking a fault that is larger than
    the device alignment, or handling a larger fault when a smaller
    mapping is already established. While we could support larger
    mappings for a device with a smaller alignment, that change is
    too large for the immediate fix. The simplest change is to force
    fallback until the fault size matches the alignment.

    Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
    Cc: <stable@vger.kernel.org>
    Reported-by: Jeff Moyer <jmoyer@redhat.com>
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 70b085b06c4560a69e95607f77bb4c2b2e41943c
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri Mar 10 13:24:27 2017 -0700

    device-dax: fix pud fault fallback handling

    Jeff Moyer reports:

        With a device dax alignment of 4KB or 2MB, I get sigbus when running
        the attached fio job file for the current kernel (4.11.0-rc1+).  If
        I specify an alignment of 1GB, it works.

        I turned on debug output, and saw that it was failing in the huge
        fault code.

         dax dax1.0: dax_open
         dax dax1.0: dax_mmap
         dax dax1.0: dax_dev_huge_fault: fio: write (0x7f08f0a00000 -
         dax dax1.0: __dax_dev_pud_fault: phys_to_pgoff(0xffffffffcf60)
         dax dax1.0: dax_release

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

    The driver fails to fallback when taking a fault that is larger than
    the device alignment, or handling a larger fault when a smaller
    mapping is already established. While we could support larger
    mappings for a device with a smaller alignment, that change is
    too large for the immediate fix. The simplest change is to force
    fallback until the fault size matches the alignment.

    Reported-by: Jeff Moyer <jmoyer@redhat.com>
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 52084f89b38cdd896b59627c629915ef1a7bf615
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Thu Mar 9 16:56:01 2017 -0700

    device-dax: fix debug output typo

    The debug output for return the return data of pgoff_to_phys() in the
    fault handlers has 'phys' and 'pgoff' incorrectly swapped.

    Reported-by: Jeff Moyer <jmoyer@redhat.com>
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 8d9829ff2a78..80c6db279ae1 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -427,6 +427,7 @@ static int __dax_dev_pte_fault(struct dax_dev
*dax_dev, struct vm_fault *vmf)
        int rc = VM_FAULT_SIGBUS;
        phys_addr_t phys;
        pfn_t pfn;
+       unsigned int fault_size = PAGE_SIZE;

        if (check_vma(dax_dev, vmf->vma, __func__))
                return VM_FAULT_SIGBUS;
@@ -437,9 +438,12 @@ static int __dax_dev_pte_fault(struct dax_dev
*dax_dev, struct vm_fault *vmf)
                return VM_FAULT_SIGBUS;
        }

+       if (fault_size != dax_region->align)
+               return VM_FAULT_SIGBUS;
+
        phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
        if (phys == -1) {
-               dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+               dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
                                vmf->pgoff);
                return VM_FAULT_SIGBUS;
        }
@@ -464,6 +468,7 @@ static int __dax_dev_pmd_fault(struct dax_dev
*dax_dev, struct vm_fault *vmf)
        phys_addr_t phys;
        pgoff_t pgoff;
        pfn_t pfn;
+       unsigned int fault_size = PMD_SIZE;

        if (check_vma(dax_dev, vmf->vma, __func__))
                return VM_FAULT_SIGBUS;
@@ -480,10 +485,20 @@ static int __dax_dev_pmd_fault(struct dax_dev
*dax_dev, struct vm_fault *vmf)
                return VM_FAULT_SIGBUS;
        }

+       if (fault_size < dax_region->align)
+               return VM_FAULT_SIGBUS;
+       else if (fault_size > dax_region->align)
+               return VM_FAULT_FALLBACK;
+
+       /* if we are outside of the VMA */
+       if (pmd_addr < vmf->vma->vm_start ||
+                       (pmd_addr + PMD_SIZE) > vmf->vma->vm_end)
+               return VM_FAULT_SIGBUS;
+
        pgoff = linear_page_index(vmf->vma, pmd_addr);
        phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
:        if (phys == -1) {
-               dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+               dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
                                pgoff);
                return VM_FAULT_SIGBUS;
        }
@@ -503,6 +518,8 @@ static int __dax_dev_pud_fault(struct dax_dev
*dax_dev, struct vm_fault *vmf)
        phys_addr_t phys;
        pgoff_t pgoff;
        pfn_t pfn;
+       unsigned int fault_size = PUD_SIZE;
+

        if (check_vma(dax_dev, vmf->vma, __func__))
                return VM_FAULT_SIGBUS;
@@ -519,10 +536,20 @@ static int __dax_dev_pud_fault(struct dax_dev
*dax_dev, struct vm_fault *vmf)
                return VM_FAULT_SIGBUS;
        }

+       if (fault_size < dax_region->align)
+               return VM_FAULT_SIGBUS;
+       else if (fault_size > dax_region->align)
+               return VM_FAULT_FALLBACK;
+
+       /* if we are outside of the VMA */
+       if (pud_addr < vmf->vma->vm_start ||
+                       (pud_addr + PUD_SIZE) > vmf->vma->vm_end)
+               return VM_FAULT_SIGBUS;
+
        pgoff = linear_page_index(vmf->vma, pud_addr);
        phys = pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
        if (phys == -1) {
-               dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+               dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
                                pgoff);
                return VM_FAULT_SIGBUS;
        }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
