Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F36D71A1F03
 for <linux-nvdimm@lists.01.org>; Wed, 21 Sep 2016 12:53:48 -0700 (PDT)
Subject: [PATCH] x86: fix kdump, cleanup aborted E820_PRAM max_pfn manipulation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Sep 2016 12:50:45 -0700
Message-ID: <147448744538.34910.11287693517367139607.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

In commit ec776ef6bbe1 "x86/mm: Add support for the non-standard
protected e820 type" Christoph references the original patch I wrote
implementing pmem support.  The intent of the 'max_pfn' changes in that
commit were to enable persistent memory ranges to be covered by the
struct page memmap by default.  However, that approach was abandoned
when Christoph ported the patches [1], and that functionality has since
been replaced by devm_memremap_pages().

In the meantime, this max_pfn manipulation is confusing kdump [2] that
assumes that everything covered by the max_pfn is "System RAM".  This
results in kdump hanging or crashing.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-March/000348.html
[2]: https://bugzilla.redhat.com/show_bug.cgi?id=1351098

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Reported-by: Zhang Yi <yizhan@redhat.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Zhang Yi <yizhan@redhat.com>
Fixes: ec776ef6bbe1 ("x86/mm: Add support for the non-standard protected e820 type")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/kernel/e820.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 621b501f8935..8a90f1517837 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -348,7 +348,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 		 * continue building up new bios map based on this
 		 * information
 		 */
-		if (current_type != last_type || current_type == E820_PRAM) {
+		if (current_type != last_type) {
 			if (last_type != 0)	 {
 				new_bios[new_bios_entry].size =
 					change_point[chgidx]->addr - last_addr;
@@ -754,7 +754,7 @@ u64 __init early_reserve_e820(u64 size, u64 align)
 /*
  * Find the highest page frame number we have available
  */
-static unsigned long __init e820_end_pfn(unsigned long limit_pfn)
+static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 {
 	int i;
 	unsigned long last_pfn = 0;
@@ -765,11 +765,7 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn)
 		unsigned long start_pfn;
 		unsigned long end_pfn;
 
-		/*
-		 * Persistent memory is accounted as ram for purposes of
-		 * establishing max_pfn and mem_map.
-		 */
-		if (ei->type != E820_RAM && ei->type != E820_PRAM)
+		if (ei->type != type)
 			continue;
 
 		start_pfn = ei->addr >> PAGE_SHIFT;
@@ -794,12 +790,12 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn)
 }
 unsigned long __init e820_end_of_ram_pfn(void)
 {
-	return e820_end_pfn(MAX_ARCH_PFN);
+	return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
 }
 
 unsigned long __init e820_end_of_low_ram_pfn(void)
 {
-	return e820_end_pfn(1UL << (32-PAGE_SHIFT));
+	return e820_end_pfn(1UL << (32 - PAGE_SHIFT), E820_RAM);
 }
 
 static void early_panic(char *msg)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
