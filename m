Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id BEE381A1EF8
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:39:13 -0800 (PST)
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: [PATCH 03/12] mm: Remove VM_FAULT_MINOR
Date: Thu, 10 Mar 2016 19:38:56 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE0422079B3@FMSMSX114.amr.corp.intel.com>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-4-git-send-email-jack@suse.cz>
In-Reply-To: <1457637535-21633-4-git-send-email-jack@suse.cz>
Content-Language: en-US
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
To: Jan Kara <jack@suse.cz>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Cc: NeilBrown <neilb@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

You've clearly fixed a bug in xtensa here ;-)  Wonder why nobody noticed that counter was always 0?

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
