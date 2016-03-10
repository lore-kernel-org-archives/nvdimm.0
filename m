Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B92071A1EC6
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:18:52 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/12] mm: Remove VM_FAULT_MINOR
Date: Thu, 10 Mar 2016 20:18:46 +0100
Message-Id: <1457637535-21633-4-git-send-email-jack@suse.cz>
In-Reply-To: <1457637535-21633-1-git-send-email-jack@suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The define has a comment from Nick Pigging from 2007:

/* For backwards compat. Remove me quickly. */

I guess 9 years should not be too hurried sense of 'quickly' even for
kernel measures.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 arch/arm/mm/fault.c       | 2 +-
 arch/arm64/mm/fault.c     | 2 +-
 arch/unicore32/mm/fault.c | 2 +-
 arch/xtensa/mm/fault.c    | 2 +-
 include/linux/mm.h        | 2 --
 5 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index daafcf121ce0..ad5841856007 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -346,7 +346,7 @@ retry:
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 * Handle the "normal" case first - VM_FAULT_MAJOR
 	 */
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index abe2a9542b3a..97135b61b32a 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -295,7 +295,7 @@ retry:
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 * Handle the "normal" case first - VM_FAULT_MAJOR
 	 */
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP |
 			      VM_FAULT_BADACCESS))))
diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
index afccef5529cc..2ec3d3adcefc 100644
--- a/arch/unicore32/mm/fault.c
+++ b/arch/unicore32/mm/fault.c
@@ -276,7 +276,7 @@ retry:
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 * Handle the "normal" case first - VM_FAULT_MAJOR
 	 */
 	if (likely(!(fault &
 	       (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index c9784c1b18d8..7f4a1fdb1502 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -146,7 +146,7 @@ good_area:
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	if (flags & VM_FAULT_MAJOR)
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
-	else if (flags & VM_FAULT_MINOR)
+	else
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
 
 	return;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 516e14944339..37f319d7636e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1051,8 +1051,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
  * just gets major/minor fault counters bumped up.
  */
 
-#define VM_FAULT_MINOR	0 /* For backwards compat. Remove me quickly. */
-
 #define VM_FAULT_OOM	0x0001
 #define VM_FAULT_SIGBUS	0x0002
 #define VM_FAULT_MAJOR	0x0004
-- 
2.6.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
