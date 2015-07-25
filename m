Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 02/25] mm, x86: Remove region_is_ram() call from ioremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:38:06 -0400
Message-ID: <20150725023806.8664.68687.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, "Luis R. Rodriguez" <mcgrof@suse.com>, linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>, Roland Dreier <roland@purestorage.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

From: Toshi Kani <toshi.kani@hp.com>

__ioremap_caller() calls region_is_ram() to walk through the
iomem_resource table to check if a target range is in RAM, which
was added to improve the lookup performance over page_is_ram()
(commit 906e36c5c717 "x86: use optimized ioresource lookup in
ioremap function").  page_is_ram() was no longer used when this
change was added, though.

__ioremap_caller() then calls walk_system_ram_range(), which had
replaced page_is_ram() to improve the lookup performance (commit
c81c8a1eeede "x86, ioremap: Speed up check for RAM pages").

Since both checks walk through the same iomem_resource table for
the same purpose, there is no need to call the two functions.
Furthermore, region_is_ram() always returns with -1, which makes
walk_system_ram_range() as the only check being used at this point.

Therefore, this patch changes __ioremap_caller() to call
walk_system_ram_range() only.

Note, removing the call to region_is_ram() is also necessary to
fix bugs in region_is_ram().  walk_system_ram_range() requires
RAM ranges be page-aligned in the iomem_resource table to work
properly.  This restriction has allowed multiple ioremaps to RAM
(setup_data) which are page-unaligned.  Using fixed region_is_ram()
will cause these callers to start failing.  After all ioremap
callers to setup_data are converted, __ioremap_caller() may call
region_is_ram() instead to remove this restriction.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/ioremap.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index c13f7fdca142..12b1eaeab6b9 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -92,7 +92,6 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	pgprot_t prot;
 	int retval;
 	void __iomem *ret_addr;
-	int ram_region;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -115,26 +114,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	/* First check if whole region can be identified as RAM or not */
-	ram_region = region_is_ram(phys_addr, size);
-	if (ram_region > 0) {
-		WARN_ONCE(1, "ioremap on RAM at 0x%lx - 0x%lx\n",
-				(unsigned long int)phys_addr,
-				(unsigned long int)last_addr);
-		return NULL;
-	}
-
-	/* If could not be identified(-1), check page by page */
-	if (ram_region < 0) {
-		pfn      = phys_addr >> PAGE_SHIFT;
-		last_pfn = last_addr >> PAGE_SHIFT;
-		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
+	pfn      = phys_addr >> PAGE_SHIFT;
+	last_pfn = last_addr >> PAGE_SHIFT;
+	if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
 					  __ioremap_check_ram) == 1) {
-			WARN_ONCE(1, "ioremap on RAM at %pa - %pa\n",
+		WARN_ONCE(1, "ioremap on RAM at %pa - %pa\n",
 					&phys_addr, &last_addr);
-			return NULL;
-		}
+		return NULL;
 	}
+
 	/*
 	 * Mappings have to be page-aligned
 	 */

