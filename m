Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F14C209831CF
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 22:00:45 -0700 (PDT)
Subject: [PATCH v6 08/13] mm,
 memory_failure: Collect mapping size in collect_procs()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 21:50:11 -0700
Message-ID: <153154381163.34503.9922261445330906942.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for supporting memory_failure() for dax mappings, teach
collect_procs() to also determine the mapping size. Unlike typical
mappings the dax mapping size is determined by walking page-table
entries rather than using the compound-page accounting for THP pages.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/memory-failure.c |   81 +++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 41 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 988f977db3d2..8a81680d00dd 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -174,22 +174,51 @@ int hwpoison_filter(struct page *p)
 EXPORT_SYMBOL_GPL(hwpoison_filter);
 
 /*
+ * Kill all processes that have a poisoned page mapped and then isolate
+ * the page.
+ *
+ * General strategy:
+ * Find all processes having the page mapped and kill them.
+ * But we keep a page reference around so that the page is not
+ * actually freed yet.
+ * Then stash the page away
+ *
+ * There's no convenient way to get back to mapped processes
+ * from the VMAs. So do a brute-force search over all
+ * running processes.
+ *
+ * Remember that machine checks are not common (or rather
+ * if they are common you have other problems), so this shouldn't
+ * be a performance issue.
+ *
+ * Also there are some races possible while we get from the
+ * error detection to actually handle it.
+ */
+
+struct to_kill {
+	struct list_head nd;
+	struct task_struct *tsk;
+	unsigned long addr;
+	short size_shift;
+	char addr_valid;
+};
+
+/*
  * Send all the processes who have the page mapped a signal.
  * ``action optional'' if they are not immediately affected by the error
  * ``action required'' if error happened in current execution context
  */
-static int kill_proc(struct task_struct *t, unsigned long addr,
-			unsigned long pfn, struct page *page, int flags)
+static int kill_proc(struct to_kill *tk, unsigned long pfn, int flags)
 {
-	short addr_lsb;
+	struct task_struct *t = tk->tsk;
+	short addr_lsb = tk->size_shift;
 	int ret;
 
 	pr_err("Memory failure: %#lx: Killing %s:%d due to hardware memory corruption\n",
 		pfn, t->comm, t->pid);
-	addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
 
 	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
-		ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)addr,
+		ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)tk->addr,
 				       addr_lsb, current);
 	} else {
 		/*
@@ -198,7 +227,7 @@ static int kill_proc(struct task_struct *t, unsigned long addr,
 		 * This could cause a loop when the user sets SIGBUS
 		 * to SIG_IGN, but hopefully no one will do that?
 		 */
-		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)addr,
+		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
 				      addr_lsb, t);  /* synchronous? */
 	}
 	if (ret < 0)
@@ -235,35 +264,6 @@ void shake_page(struct page *p, int access)
 EXPORT_SYMBOL_GPL(shake_page);
 
 /*
- * Kill all processes that have a poisoned page mapped and then isolate
- * the page.
- *
- * General strategy:
- * Find all processes having the page mapped and kill them.
- * But we keep a page reference around so that the page is not
- * actually freed yet.
- * Then stash the page away
- *
- * There's no convenient way to get back to mapped processes
- * from the VMAs. So do a brute-force search over all
- * running processes.
- *
- * Remember that machine checks are not common (or rather
- * if they are common you have other problems), so this shouldn't
- * be a performance issue.
- *
- * Also there are some races possible while we get from the
- * error detection to actually handle it.
- */
-
-struct to_kill {
-	struct list_head nd;
-	struct task_struct *tsk;
-	unsigned long addr;
-	char addr_valid;
-};
-
-/*
  * Failure handling: if we can't find or can't kill a process there's
  * not much we can do.	We just print a message and ignore otherwise.
  */
@@ -292,6 +292,7 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 	}
 	tk->addr = page_address_in_vma(p, vma);
 	tk->addr_valid = 1;
+	tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
 
 	/*
 	 * In theory we don't have to kill when the page was
@@ -317,9 +318,8 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
-static void kill_procs(struct list_head *to_kill, int forcekill,
-			  bool fail, struct page *page, unsigned long pfn,
-			  int flags)
+static void kill_procs(struct list_head *to_kill, int forcekill, bool fail,
+		unsigned long pfn, int flags)
 {
 	struct to_kill *tk, *next;
 
@@ -342,8 +342,7 @@ static void kill_procs(struct list_head *to_kill, int forcekill,
 			 * check for that, but we need to tell the
 			 * process anyways.
 			 */
-			else if (kill_proc(tk->tsk, tk->addr,
-					      pfn, page, flags) < 0)
+			else if (kill_proc(tk, pfn, flags) < 0)
 				pr_err("Memory failure: %#lx: Cannot send advisory machine check signal to %s:%d\n",
 				       pfn, tk->tsk->comm, tk->tsk->pid);
 		}
@@ -1012,7 +1011,7 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * any accesses to the poisoned memory.
 	 */
 	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL);
-	kill_procs(&tokill, forcekill, !unmap_success, p, pfn, flags);
+	kill_procs(&tokill, forcekill, !unmap_success, pfn, flags);
 
 	return unmap_success;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
