Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/3] mm, x86: Fix warning in ioremap RAM check
Date: Fri, 19 Jun 2015 15:44:03 -0600
Message-Id: <1434750245-6304-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org
Cc: travis@sgi.com, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

__ioremap_caller() calls __ioremap_check_ram() through
walk_system_ram_range() to check if a target range is RAM.
__ioremap_check_ram() has WARN_ONCE() in a wrong place that
it warns when the given range is not RAM.  This misplaced
warning is not exposed since walk_system_ram_range() only
calls __ioremap_check_ram() for RAM ranges.

Move the WARN_ONCE() to the error path of __ioremap_caller(),
and update the message to include the address range.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/ioremap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 70e7444..56f8af7 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -60,8 +60,6 @@ static int __ioremap_check_ram(unsigned long start_pfn, unsigned long nr_pages,
 		    !PageReserved(pfn_to_page(start_pfn + i)))
 			return 1;
 
-	WARN_ONCE(1, "ioremap on RAM pfn 0x%lx\n", start_pfn);
-
 	return 0;
 }
 
@@ -128,8 +126,11 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		pfn      = phys_addr >> PAGE_SHIFT;
 		last_pfn = last_addr >> PAGE_SHIFT;
 		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
-					  __ioremap_check_ram) == 1)
+					  __ioremap_check_ram) == 1) {
+			WARN_ONCE(1, "ioremap on RAM at 0x%llx - 0x%llx\n",
+					phys_addr, last_addr);
 			return NULL;
+		}
 	}
 	/*
 	 * Mappings have to be page-aligned
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
