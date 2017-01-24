Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F73D81EFA
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 16:06:39 -0800 (PST)
Subject: [PATCH] dax: pgoff in fs DAX trace needs to be corrected
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 23 Jan 2017 17:06:39 -0700
Message-ID: <148521639917.25631.6919429328589810158.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

With only vmf being passed in, the pgoff in vmf that is passed in is for
the PTE and not the PMD. Fix up so the pgoff is corrected.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 include/trace/events/fs_dax.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index c566ddc..e26affa 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -30,7 +30,8 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__entry->vm_flags = vmf->vma->vm_flags;
 		__entry->address = vmf->address;
 		__entry->flags = vmf->flags;
-		__entry->pgoff = vmf->pgoff;
+		__entry->pgoff = linear_page_index(vmf->vma,
+			vmf->address & PMD_MASK);
 		__entry->max_pgoff = max_pgoff;
 		__entry->result = result;
 	),

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
