Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56E9C203B9932
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 07:50:16 -0700 (PDT)
Subject: [PATCH 09/11] mm, memory_failure: pass page size to kill_proc()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 May 2018 07:40:19 -0700
Message-ID: <152700001949.24093.5303974728568066054.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, tony.luck@intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Given that ZONE_DEVICE / dev_pagemap pages are never assembled into
compound pages, the size determination logic in kill_proc() needs
updating for the dev_pagemap case. In preparation for dev_pagemap
support rework memory_failure() and kill_proc() to pass / consume the page
size explicitly.

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/memory-failure.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 9d142b9b86dc..42a193ee14d3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -179,18 +179,16 @@ EXPORT_SYMBOL_GPL(hwpoison_filter);
  * ``action required'' if error happened in current execution context
  */
 static int kill_proc(struct task_struct *t, unsigned long addr,
-			unsigned long pfn, struct page *page, int flags)
+			unsigned long pfn, unsigned size_shift, int flags)
 {
-	short addr_lsb;
 	int ret;
 
 	pr_err("Memory failure: %#lx: Killing %s:%d due to hardware memory corruption\n",
 		pfn, t->comm, t->pid);
-	addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
 
 	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
 		ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)addr,
-				       addr_lsb, current);
+				       size_shift, current);
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
@@ -199,7 +197,7 @@ static int kill_proc(struct task_struct *t, unsigned long addr,
 		 * to SIG_IGN, but hopefully no one will do that?
 		 */
 		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)addr,
-				      addr_lsb, t);  /* synchronous? */
+				      size_shift, t);  /* synchronous? */
 	}
 	if (ret < 0)
 		pr_info("Memory failure: Error sending signal to %s:%d: %d\n",
@@ -318,7 +316,7 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
  * wrong earlier.
  */
 static void kill_procs(struct list_head *to_kill, int forcekill,
-			  bool fail, struct page *page, unsigned long pfn,
+			  bool fail, unsigned size_shift, unsigned long pfn,
 			  int flags)
 {
 	struct to_kill *tk, *next;
@@ -343,7 +341,7 @@ static void kill_procs(struct list_head *to_kill, int forcekill,
 			 * process anyways.
 			 */
 			else if (kill_proc(tk->tsk, tk->addr,
-					      pfn, page, flags) < 0)
+					      pfn, size_shift, flags) < 0)
 				pr_err("Memory failure: %#lx: Cannot send advisory machine check signal to %s:%d\n",
 				       pfn, tk->tsk->comm, tk->tsk->pid);
 		}
@@ -928,6 +926,7 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
+	unsigned size_shift;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
 	bool mlocked = PageMlocked(hpage);
@@ -1012,7 +1011,8 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * any accesses to the poisoned memory.
 	 */
 	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL);
-	kill_procs(&tokill, forcekill, !unmap_success, p, pfn, flags);
+	size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
+	kill_procs(&tokill, forcekill, !unmap_success, size_shift, pfn, flags);
 
 	return unmap_success;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
