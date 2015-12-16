Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.4-rc6
Date: Wed, 16 Dec 2015 21:20:43 +0000
Message-ID: <1450300844.5150.9.camel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <AC23221086BC4A49BA051FCDF6BFD13E@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Zwisler, Ross" <ross.zwisler@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

1/ 2 bug fixes for misuse of PAGE+AF8-MASK in scatterlist and dma-debug.
+AKA-These are tagged for -stable. +AKA-The scatterlist impact is potentially
corrupted dma addresses on HIGHMEM enabled platforms.

2/ A minor locking fix for the NFIT hot-add implementation that is new
in 4.4-rc. +AKA-This would only trigger in the case a hot-add raced driver
removal.

These have received a build success notification from the kbuild robot.

---

The following changes since commit 527e9316f8ec44bd53d90fb9f611fa7ffff52bb9:

+AKA- Linux 4.4-rc4 (2015-12-06 15:43:12 -0800)

are available in the git repository at:

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 0354aec19ce3d355c6213b0434064efc25c9b22c:

+AKA- dma-debug: Fix dma+AF8-debug+AF8-entry offset calculation (2015-12-16 11:24:26 -0800)

----------------------------------------------------------------
Alexey Khoroshilov (1):
+AKAAoACgAKAAoACg-nfit: acpi+AF8-nfit+AF8-notify(): Do not leave device locked

Dan Williams (1):
+AKAAoACgAKAAoACg-Revert +ACI-scatterlist: use sg+AF8-phys()+ACI-

Daniel Mentz (1):
+AKAAoACgAKAAoACg-dma-debug: Fix dma+AF8-debug+AF8-entry offset calculation

+AKA-arch/arm/mm/dma-mapping.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 2 +--
+AKA-arch/microblaze/kernel/dma.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 3 +-+--
+AKA-drivers/acpi/nfit.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 2 +--
+AKA-drivers/iommu/intel-iommu.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHw- 4 +-+---
+AKA-drivers/iommu/iommu.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHw- 2 +--
+AKA-drivers/staging/android/ion/ion+AF8-chunk+AF8-heap.c +AHw- 4 +-+---
+AKA-lib/dma-debug.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHw- 4 +-+---
+AKA-7 files changed, 11 insertions(+-), 10 deletions(-)

commit 0354aec19ce3d355c6213b0434064efc25c9b22c
Author: Daniel Mentz +ADw-danielmentz+AEA-google.com+AD4-
Date:+AKAAoACg-Tue Dec 15 17:38:48 2015 -0800

+AKAAoACgAKA-dma-debug: Fix dma+AF8-debug+AF8-entry offset calculation
+AKAAoACgAKA-
+AKAAoACgAKA-dma-debug uses struct dma+AF8-debug+AF8-entry to keep track of dma coherent
+AKAAoACgAKA-memory allocation requests. The virtual address is converted into a pfn
+AKAAoACgAKA-and an offset. Previously, the offset was calculated using an incorrect
+AKAAoACgAKA-bit mask.+AKAAoA-As a result, we saw incorrect error messages from dma-debug
+AKAAoACgAKA-like the following:
+AKAAoACgAKA-
+AKAAoACgAKAAIg-DMA-API: exceeded 7 overlapping mappings of cacheline 0x03e00000+ACI-
+AKAAoACgAKA-
+AKAAoACgAKA-Cacheline 0x03e00000 does not exist on our platform.
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Fixes: 0abdd7a81b7e (+ACI-dma-debug: introduce debug+AF8-dma+AF8-assert+AF8-idle()+ACI-)
+AKAAoACgAKA-Signed-off-by: Daniel Mentz +ADw-danielmentz+AEA-google.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 3e6110fd5480f5f86ff31381f4dea14218284bff
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Tue Dec 15 12:54:06 2015 -0800

+AKAAoACgAKA-Revert +ACI-scatterlist: use sg+AF8-phys()+ACI-
+AKAAoACgAKA-
+AKAAoACgAKA-commit db0fa0cb0157 +ACI-scatterlist: use sg+AF8-phys()+ACI- did replacements of
+AKAAoACgAKA-the form:
+AKAAoACgAKA-
+AKAAoACgAKAAoACgAKAAoA-phys+AF8-addr+AF8-t phys +AD0- page+AF8-to+AF8-phys(sg+AF8-page(s))+ADs-
+AKAAoACgAKAAoACgAKAAoA-phys+AF8-addr+AF8-t phys +AD0- sg+AF8-phys(s) +ACY- PAGE+AF8-MASK+ADs-
+AKAAoACgAKA-
+AKAAoACgAKA-However, this breaks platforms where sizeof(phys+AF8-addr+AF8-t) +AD4-
+AKAAoACgAKA-sizeof(unsigned long).+AKAAoA-Revert for 4.3 and 4.4 to make room for a
+AKAAoACgAKA-combined helper in 4.5.
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Cc: Jens Axboe +ADw-axboe+AEA-fb.com+AD4-
+AKAAoACgAKA-Cc: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4-
+AKAAoACgAKA-Cc: Russell King +ADw-linux+AEA-arm.linux.org.uk+AD4-
+AKAAoACgAKA-Cc: David Woodhouse +ADw-dwmw2+AEA-infradead.org+AD4-
+AKAAoACgAKA-Cc: Andrew Morton +ADw-akpm+AEA-linux-foundation.org+AD4-
+AKAAoACgAKA-Fixes: db0fa0cb0157 (+ACI-scatterlist: use sg+AF8-phys()+ACI-)
+AKAAoACgAKA-Suggested-by: Joerg Roedel +ADw-joro+AEA-8bytes.org+AD4-
+AKAAoACgAKA-Reported-by: Vitaly Lavrov +ADw-vel21ripn+AEA-gmail.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit d91e892825ae6f0ed4f8b07ae5d348eff86ab2ea
Author: Alexey Khoroshilov +ADw-khoroshilov+AEA-ispras.ru+AD4-
Date:+AKAAoACg-Fri Dec 11 23:24:10 2015 +-0300

+AKAAoACgAKA-nfit: acpi+AF8-nfit+AF8-notify(): Do not leave device locked
+AKAAoACgAKA-
+AKAAoACgAKA-Even if dev-+AD4-driver is null because we are being removed,
+AKAAoACgAKA-it is safer to not leave device locked.
+AKAAoACgAKA-
+AKAAoACgAKA-Found by Linux Driver Verification project (linuxtesting.org).
+AKAAoACgAKA-
+AKAAoACgAKA-Signed-off-by: Alexey Khoroshilov +ADw-khoroshilov+AEA-ispras.ru+AD4-
+AKAAoACgAKA-Reviewed-by: Ross Zwisler +ADw-ross.zwisler+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Reviewed-by: Vishal Verma +ADw-vishal.l.verma+AEA-intel.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e62400e5fb99..534a60ae282e 100644
--- a/arch/arm/mm/dma-mapping.c
+-+-+- b/arch/arm/mm/dma-mapping.c
+AEAAQA- -1521,7 +-1521,7 +AEAAQA- static int +AF8AXw-map+AF8-sg+AF8-chunk(struct device +ACo-dev, struct scatterlist +ACo-sg,
+AKA-		return -ENOMEM+ADs-
+AKA-
+AKA-	for (count +AD0- 0, s +AD0- sg+ADs- count +ADw- (size +AD4APg- PAGE+AF8-SHIFT)+ADs- s +AD0- sg+AF8-next(s)) +AHs-
-		phys+AF8-addr+AF8-t phys +AD0- sg+AF8-phys(s) +ACY- PAGE+AF8-MASK+ADs-
+-		phys+AF8-addr+AF8-t phys +AD0- page+AF8-to+AF8-phys(sg+AF8-page(s))+ADs-
+AKA-		unsigned int len +AD0- PAGE+AF8-ALIGN(s-+AD4-offset +- s-+AD4-length)+ADs-
+AKA-
+AKA-		if (+ACE-is+AF8-coherent +ACYAJg-
diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index c89da6312954..bf4dec229437 100644
--- a/arch/microblaze/kernel/dma.c
+-+-+- b/arch/microblaze/kernel/dma.c
+AEAAQA- -61,7 +-61,8 +AEAAQA- static int dma+AF8-direct+AF8-map+AF8-sg(struct device +ACo-dev, struct scatterlist +ACo-sgl,
+AKA-	/+ACo- FIXME this part of code is untested +ACo-/
+AKA-	for+AF8-each+AF8-sg(sgl, sg, nents, i) +AHs-
+AKA-		sg-+AD4-dma+AF8-address +AD0- sg+AF8-phys(sg)+ADs-
-		+AF8AXw-dma+AF8-sync(sg+AF8-phys(sg), sg-+AD4-length, direction)+ADs-
+-		+AF8AXw-dma+AF8-sync(page+AF8-to+AF8-phys(sg+AF8-page(sg)) +- sg-+AD4-offset,
+-							sg-+AD4-length, direction)+ADs-
+AKA-	+AH0-
+AKA-
+AKA-	return nents+ADs-
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index e7ed39bab97d..aa45d4802707 100644
--- a/drivers/acpi/nfit.c
+-+-+- b/drivers/acpi/nfit.c
+AEAAQA- -1810,7 +-1810,7 +AEAAQA- static void acpi+AF8-nfit+AF8-notify(struct acpi+AF8-device +ACo-adev, u32 event)
+AKA-	if (+ACE-dev-+AD4-driver) +AHs-
+AKA-		/+ACo- dev-+AD4-driver may be null if we're being removed +ACo-/
+AKA-		dev+AF8-dbg(dev, +ACIAJQ-s: no driver found for dev+AFw-n+ACI-, +AF8AXw-func+AF8AXw-)+ADs-
-		return+ADs-
+-		goto out+AF8-unlock+ADs-
+AKA-	+AH0-
+AKA-
+AKA-	if (+ACE-acpi+AF8-desc) +AHs-
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f1042daef9ad..ac7387686ddc 100644
--- a/drivers/iommu/intel-iommu.c
+-+-+- b/drivers/iommu/intel-iommu.c
+AEAAQA- -2159,7 +-2159,7 +AEAAQA- static int +AF8AXw-domain+AF8-mapping(struct dmar+AF8-domain +ACo-domain, unsigned long iov+AF8-pfn,
+AKA-			sg+AF8-res +AD0- aligned+AF8-nrpages(sg-+AD4-offset, sg-+AD4-length)+ADs-
+AKA-			sg-+AD4-dma+AF8-address +AD0- ((dma+AF8-addr+AF8-t)iov+AF8-pfn +ADwAPA- VTD+AF8-PAGE+AF8-SHIFT) +- sg-+AD4-offset+ADs-
+AKA-			sg-+AD4-dma+AF8-length +AD0- sg-+AD4-length+ADs-
-			pteval +AD0- (sg+AF8-phys(sg) +ACY- PAGE+AF8-MASK) +AHw- prot+ADs-
+-			pteval +AD0- page+AF8-to+AF8-phys(sg+AF8-page(sg)) +AHw- prot+ADs-
+AKA-			phys+AF8-pfn +AD0- pteval +AD4APg- VTD+AF8-PAGE+AF8-SHIFT+ADs-
+AKA-		+AH0-
+AKA-
+AEAAQA- -3704,7 +-3704,7 +AEAAQA- static int intel+AF8-nontranslate+AF8-map+AF8-sg(struct device +ACo-hddev,
+AKA-
+AKA-	for+AF8-each+AF8-sg(sglist, sg, nelems, i) +AHs-
+AKA-		BUG+AF8-ON(+ACE-sg+AF8-page(sg))+ADs-
-		sg-+AD4-dma+AF8-address +AD0- sg+AF8-phys(sg)+ADs-
+-		sg-+AD4-dma+AF8-address +AD0- page+AF8-to+AF8-phys(sg+AF8-page(sg)) +- sg-+AD4-offset+ADs-
+AKA-		sg-+AD4-dma+AF8-length +AD0- sg-+AD4-length+ADs-
+AKA-	+AH0-
+AKA-	return nelems+ADs-
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index abae363c7b9b..0e3b0092ec92 100644
--- a/drivers/iommu/iommu.c
+-+-+- b/drivers/iommu/iommu.c
+AEAAQA- -1430,7 +-1430,7 +AEAAQA- size+AF8-t default+AF8-iommu+AF8-map+AF8-sg(struct iommu+AF8-domain +ACo-domain, unsigned long iova,
+AKA-	min+AF8-pagesz +AD0- 1 +ADwAPA- +AF8AXw-ffs(domain-+AD4-ops-+AD4-pgsize+AF8-bitmap)+ADs-
+AKA-
+AKA-	for+AF8-each+AF8-sg(sg, s, nents, i) +AHs-
-		phys+AF8-addr+AF8-t phys +AD0- sg+AF8-phys(s)+ADs-
+-		phys+AF8-addr+AF8-t phys +AD0- page+AF8-to+AF8-phys(sg+AF8-page(s)) +- s-+AD4-offset+ADs-
+AKA-
+AKA-		/+ACo-
+AKA-		+AKAAKg- We are mapping on IOMMU page boundaries, so offset within
diff --git a/drivers/staging/android/ion/ion+AF8-chunk+AF8-heap.c b/drivers/staging/android/ion/ion+AF8-chunk+AF8-heap.c
index 195c41d7bd53..0813163f962f 100644
--- a/drivers/staging/android/ion/ion+AF8-chunk+AF8-heap.c
+-+-+- b/drivers/staging/android/ion/ion+AF8-chunk+AF8-heap.c
+AEAAQA- -81,7 +-81,7 +AEAAQA- static int ion+AF8-chunk+AF8-heap+AF8-allocate(struct ion+AF8-heap +ACo-heap,
+AKA-err:
+AKA-	sg +AD0- table-+AD4-sgl+ADs-
+AKA-	for (i -+AD0- 1+ADs- i +AD4APQ- 0+ADs- i--) +AHs-
-		gen+AF8-pool+AF8-free(chunk+AF8-heap-+AD4-pool, sg+AF8-phys(sg) +ACY- PAGE+AF8-MASK,
+-		gen+AF8-pool+AF8-free(chunk+AF8-heap-+AD4-pool, page+AF8-to+AF8-phys(sg+AF8-page(sg)),
+AKA-			+AKAAoACgAKAAoACg-sg-+AD4-length)+ADs-
+AKA-		sg +AD0- sg+AF8-next(sg)+ADs-
+AKA-	+AH0-
+AEAAQA- -109,7 +-109,7 +AEAAQA- static void ion+AF8-chunk+AF8-heap+AF8-free(struct ion+AF8-buffer +ACo-buffer)
+AKA-							DMA+AF8-BIDIRECTIONAL)+ADs-
+AKA-
+AKA-	for+AF8-each+AF8-sg(table-+AD4-sgl, sg, table-+AD4-nents, i) +AHs-
-		gen+AF8-pool+AF8-free(chunk+AF8-heap-+AD4-pool, sg+AF8-phys(sg) +ACY- PAGE+AF8-MASK,
+-		gen+AF8-pool+AF8-free(chunk+AF8-heap-+AD4-pool, page+AF8-to+AF8-phys(sg+AF8-page(sg)),
+AKA-			+AKAAoACgAKAAoACg-sg-+AD4-length)+ADs-
+AKA-	+AH0-
+AKA-	chunk+AF8-heap-+AD4-allocated -+AD0- allocated+AF8-size+ADs-
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 8855f019ebe8..d34bd24c2c84 100644
--- a/lib/dma-debug.c
+-+-+- b/lib/dma-debug.c
+AEAAQA- -1464,7 +-1464,7 +AEAAQA- void debug+AF8-dma+AF8-alloc+AF8-coherent(struct device +ACo-dev, size+AF8-t size,
+AKA-	entry-+AD4-type+AKAAoACgAKAAoACgAD0- dma+AF8-debug+AF8-coherent+ADs-
+AKA-	entry-+AD4-dev+AKAAoACgAKAAoACgAKAAPQ- dev+ADs-
+AKA-	entry-+AD4-pfn	+AKAAPQ- page+AF8-to+AF8-pfn(virt+AF8-to+AF8-page(virt))+ADs-
-	entry-+AD4-offset	+AKAAPQ- (size+AF8-t) virt +ACY- PAGE+AF8-MASK+ADs-
+-	entry-+AD4-offset	+AKAAPQ- (size+AF8-t) virt +ACY- +AH4-PAGE+AF8-MASK+ADs-
+AKA-	entry-+AD4-size+AKAAoACgAKAAoACgAD0- size+ADs-
+AKA-	entry-+AD4-dev+AF8-addr+AKAAoAA9- dma+AF8-addr+ADs-
+AKA-	entry-+AD4-direction +AD0- DMA+AF8-BIDIRECTIONAL+ADs-
+AEAAQA- -1480,7 +-1480,7 +AEAAQA- void debug+AF8-dma+AF8-free+AF8-coherent(struct device +ACo-dev, size+AF8-t size,
+AKA-		.type+AKAAoACgAKAAoACgAKAAoACgAKAAoAA9- dma+AF8-debug+AF8-coherent,
+AKA-		.dev+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAD0- dev,
+AKA-		.pfn		+AD0- page+AF8-to+AF8-pfn(virt+AF8-to+AF8-page(virt)),
-		.offset		+AD0- (size+AF8-t) virt +ACY- PAGE+AF8-MASK,
+-		.offset		+AD0- (size+AF8-t) virt +ACY- +AH4-PAGE+AF8-MASK,
+AKA-		.dev+AF8-addr+AKAAoACgAKAAoACgAKAAPQ- addr,
+AKA-		.size+AKAAoACgAKAAoACgAKAAoACgAKAAoAA9- size,
+AKA-		.direction+AKAAoACgAKAAoACgAD0- DMA+AF8-BIDIRECTIONAL,