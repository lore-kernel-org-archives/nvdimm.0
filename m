Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/3] mm, x86: Remove region_is_ram() call from ioremap
Date: Fri, 19 Jun 2015 15:44:04 -0600
Message-Id: <1434750245-6304-3-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org
Cc: travis@sgi.com, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

__ioremap_caller() calls region_is_ram() to look up the resource
to check if a target range is RAM, which was added as an additinal
check to improve the lookup performance over page_is_ram() (commit
906e36c5c717 "x86: use optimized ioresource lookup in ioremap
function").

__ioremap_caller() then calls walk_system_ram_range(), which had
replaced page_is_ram() to improve the lookup performance (commit
c81c8a1eeede "x86, ioremap: Speed up check for RAM pages").

Since both functions walk through the resource table, there is
no need to call the two functions.  Furthermore, region_is_ram()
has bugs and always returns with -1.  This makes
walk_system_ram_range() as the only check being used.

Hence, remove the call to region_is_ram() from __ioremap_caller().

Note, removing the call to region_is_ram() is also necessary
to fix the bugs in region_is_ram().  walk_system_ram_range()
requires RAM ranges aligned by the page size in the resource
table.  e820_reserve_setup_data() updates the e820 table by
allocating a separate entry to each data region in setup_data,
which is not page-aligned.  Therefore, walk_system_ram_range()
is unable to detect the RAM ranges in setup_data.  This
restriction has allowed multiple uses of ioremap() to map
setup_data.  Using fixed region_is_ram() will cause these callers
to start failing.  After all ioremap to setup_data are converted,
__ioremap_caller() may call region_is_ram() instead.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/ioremap.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 56f8af7..928867e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -89,7 +89,6 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	pgprot_t prot;
 	int retval;
 	void __iomem *ret_addr;
-	int ram_region;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -112,26 +111,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
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
-			WARN_ONCE(1, "ioremap on RAM at 0x%llx - 0x%llx\n",
+		WARN_ONCE(1, "ioremap on RAM at 0x%llx - 0x%llx\n",
 					phys_addr, last_addr);
-			return NULL;
-		}
+		return NULL;
 	}
+
 	/*
 	 * Mappings have to be page-aligned
 	 */
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
