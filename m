Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 127801A1EC4
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 05:56:19 -0700 (PDT)
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.7 19/31] x86/boot: Fix kdump,
 cleanup aborted E820_PRAM max_pfn manipulation
Date: Fri, 14 Oct 2016 14:55:03 +0200
Message-Id: <20161014122716.036754844@linuxfoundation.org>
In-Reply-To: <20161014122715.235592611@linuxfoundation.org>
References: <20161014122715.235592611@linuxfoundation.org>
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
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

4.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 917db484dc6a69969d317b3e57add4208a8d9d42 upstream.

In commit:

  ec776ef6bbe1 ("x86/mm: Add support for the non-standard protected e820 type")

Christoph references the original patch I wrote implementing pmem support.
The intent of the 'max_pfn' changes in that commit were to enable persistent
memory ranges to be covered by the struct page memmap by default.

However, that approach was abandoned when Christoph ported the patches [1], and
that functionality has since been replaced by devm_memremap_pages().

In the meantime, this max_pfn manipulation is confusing kdump [2] that
assumes that everything covered by the max_pfn is "System RAM".  This
results in kdump hanging or crashing.

 [1]: https://lists.01.org/pipermail/linux-nvdimm/2015-March/000348.html
 [2]: https://bugzilla.redhat.com/show_bug.cgi?id=1351098

So fix it.

Reported-by: Zhang Yi <yizhan@redhat.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Zhang Yi <yizhan@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-nvdimm@lists.01.org
Fixes: ec776ef6bbe1 ("x86/mm: Add support for the non-standard protected e820 type")
Link: http://lkml.kernel.org/r/147448744538.34910.11287693517367139607.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/e820.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -348,7 +348,7 @@ int __init sanitize_e820_map(struct e820
 		 * continue building up new bios map based on this
 		 * information
 		 */
-		if (current_type != last_type || current_type == E820_PRAM) {
+		if (current_type != last_type) {
 			if (last_type != 0)	 {
 				new_bios[new_bios_entry].size =
 					change_point[chgidx]->addr - last_addr;
@@ -754,7 +754,7 @@ u64 __init early_reserve_e820(u64 size,
 /*
  * Find the highest page frame number we have available
  */
-static unsigned long __init e820_end_pfn(unsigned long limit_pfn)
+static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 {
 	int i;
 	unsigned long last_pfn = 0;
@@ -765,11 +765,7 @@ static unsigned long __init e820_end_pfn
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
@@ -794,12 +790,12 @@ static unsigned long __init e820_end_pfn
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
