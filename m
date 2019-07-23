Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 413F72128D681
 for <linux-nvdimm@lists.01.org>; Tue, 23 Jul 2019 16:43:09 -0700 (PDT)
From: Jane Chu <jane.chu@oracle.com>
Subject: [PATCH] mm/memory-failure: Poison read receives SIGKILL instead of
 SIGBUS if mmaped more than once
Date: Tue, 23 Jul 2019 17:38:30 -0600
Message-Id: <1563925110-19359-1-git-send-email-jane.chu@oracle.com>
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
To: n-horiguchi@ah.jp.nec.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Mmap /dev/dax more than once, then read the poison location using address
from one of the mappings. The other mappings due to not having the page
mapped in will cause SIGKILLs delivered to the process. SIGKILL succeeds
over SIGBUS, so user process looses the opportunity to handle the UE.

Although one may add MAP_POPULATE to mmap(2) to work around the issue,
MAP_POPULATE makes mapping 128GB of pmem several magnitudes slower, so
isn't always an option.

Details -

ndctl inject-error --block=10 --count=1 namespace6.0

./read_poison -x dax6.0 -o 5120 -m 2
mmaped address 0x7f5bb6600000
mmaped address 0x7f3cf3600000
doing local read at address 0x7f3cf3601400
Killed

Console messages in instrumented kernel -

mce: Uncorrected hardware memory error in user-access at edbe201400
Memory failure: tk->addr = 7f5bb6601000
Memory failure: address edbe201: call dev_pagemap_mapping_shift
dev_pagemap_mapping_shift: page edbe201: no PUD
Memory failure: tk->size_shift == 0
Memory failure: Unable to find user space address edbe201 in read_poison
Memory failure: tk->addr = 7f3cf3601000
Memory failure: address edbe201: call dev_pagemap_mapping_shift
Memory failure: tk->size_shift = 21
Memory failure: 0xedbe201: forcibly killing read_poison:22434 because of failure to unmap corrupted page
  => to deliver SIGKILL
Memory failure: 0xedbe201: Killing read_poison:22434 due to hardware memory corruption
  => to deliver SIGBUS

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 mm/memory-failure.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d9cc660..7038abd 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -315,7 +315,6 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 
 	if (*tkc) {
 		tk = *tkc;
-		*tkc = NULL;
 	} else {
 		tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
 		if (!tk) {
@@ -331,16 +330,21 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 		tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
 
 	/*
-	 * In theory we don't have to kill when the page was
-	 * munmaped. But it could be also a mremap. Since that's
-	 * likely very rare kill anyways just out of paranoia, but use
-	 * a SIGKILL because the error is not contained anymore.
+	 * Indeed a page could be mmapped N times within a process. And it's possible
+	 * that not all of those N VMAs contain valid mapping for the page. In which
+	 * case we don't want to send SIGKILL to the process on behalf of the VMAs
+	 * that don't have the valid mapping, because doing so will eclipse the SIGBUS
+	 * delivered on behalf of the active VMA.
 	 */
 	if (tk->addr == -EFAULT || tk->size_shift == 0) {
 		pr_info("Memory failure: Unable to find user space address %lx in %s\n",
 			page_to_pfn(p), tsk->comm);
-		tk->addr_valid = 0;
+		if (tk != *tkc)
+			kfree(tk);
+		return;
 	}
+	if (tk == *tkc)
+		*tkc = NULL;
 	get_task_struct(tsk);
 	tk->tsk = tsk;
 	list_add_tail(&tk->nd, to_kill);
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
