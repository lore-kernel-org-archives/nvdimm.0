Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 01/25] mm, x86: Fix warning in ioremap RAM check
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:38:00 -0400
Message-ID: <20150725023800.8664.47177.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, "Luis R. Rodriguez" <mcgrof@suse.com>, linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, kbuild test robot <fengguang.wu@intel.com>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

From: Toshi Kani <toshi.kani@hp.com>

__ioremap_caller() calls __ioremap_check_ram() through
walk_system_ram_range() to check if a target range is in RAM.
__ioremap_check_ram() has WARN_ONCE() in a wrong place where it warns
when the given range is not RAM.  This misplaced warning is not exposed
since walk_system_ram_range() only calls __ioremap_check_ram() for RAM
ranges.

Move the WARN_ONCE() to __ioremap_caller(), and update the message to
include the address range.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
[djbw: fix format specifier warnings]
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/ioremap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index cc5ccc415cc0..c13f7fdca142 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -63,8 +63,6 @@ static int __ioremap_check_ram(unsigned long start_pfn, unsigned long nr_pages,
 		    !PageReserved(pfn_to_page(start_pfn + i)))
 			return 1;
 
-	WARN_ONCE(1, "ioremap on RAM pfn 0x%lx\n", start_pfn);
-
 	return 0;
 }
 
@@ -131,8 +129,11 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		pfn      = phys_addr >> PAGE_SHIFT;
 		last_pfn = last_addr >> PAGE_SHIFT;
 		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
-					  __ioremap_check_ram) == 1)
+					  __ioremap_check_ram) == 1) {
+			WARN_ONCE(1, "ioremap on RAM at %pa - %pa\n",
+					&phys_addr, &last_addr);
 			return NULL;
+		}
 	}
 	/*
 	 * Mappings have to be page-aligned

