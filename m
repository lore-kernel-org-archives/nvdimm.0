Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5304694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791930; x=1697327930;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pn7FRJyA8KXjI8N8cdiRLRmRlb+h9sH/LZ3PlPzj0fI=;
  b=D25XocbSvCZDmVeiF2l4IMQ9qrkTevAUf9gg9zHc6Wns+/i+gP2sLmVO
   0G3763f2Rcyms/IDnlSsS5gU5yKw6ljYzaC5kLw22mMYWRKsc1hosgctK
   BqPKkBRmC1eNLh/PdRkJ+WLMxyDB4HxwHxXzvCawISyKDxW2PQrCRLRoC
   x/x0WF4YmoGF2GHCqD0UGdj3pzrp5XIQTIIqxOPQdhjd/CNTtzN9K5hY5
   nDZcnu2u82e0U6/av4bSyVXJKtog2SaQ6EQYkqsvU+KdVWXM2OqPrwmRI
   YOSnvsUcU273KAEIDHnoj+og+VpVgtE6MzeXdcXk8HpNU9kyy6LEFRGN3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="304236762"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="304236762"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:49 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="802798957"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="802798957"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:49 -0700
Subject: [PATCH v3 19/25] devdax: Sparse fixes for vm_fault_t in tracepoints
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: kernel test robot <lkp@intel.com>, david@fromorbit.com, hch@lst.de,
 nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:49 -0700
Message-ID: <166579192919.2236710.12464252412504907962.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that the dax-mapping-entry code has moved to a common location take
the opportunity to fixup some long standing sparse warnings. In this
case the tracepoints have long specified the wrong type for the traced
return code. Pass the correct type, but handle casting it back to
'unsigned int' inside the trace helpers as the helpers are not prepared
to handle restricted types.

Fixes:
drivers/dax/mapping.c:1031:55: sparse: warning: incorrect type in argument 3 (different base types)
drivers/dax/mapping.c:1031:55: sparse:    expected int result
drivers/dax/mapping.c:1031:55: sparse:    got restricted vm_fault_t
drivers/dax/mapping.c:1046:58: sparse: warning: incorrect type in argument 3 (different base types)
drivers/dax/mapping.c:1046:58: sparse:    expected int result
drivers/dax/mapping.c:1046:58: sparse:    got restricted vm_fault_t [assigned] [usertype] ret

Reported-by: Reported-by: kernel test robot <lkp@intel.com>
Link: http://lore.kernel.org/r/202210091141.cHaQEuCs-lkp@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm_types.h      |   26 +++++++++++++-------------
 include/trace/events/fs_dax.h |   16 ++++++++--------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 500e536796ca..910d880e67eb 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -891,19 +891,19 @@ enum vm_fault_reason {
 			VM_FAULT_HWPOISON_LARGE | VM_FAULT_FALLBACK)
 
 #define VM_FAULT_RESULT_TRACE \
-	{ VM_FAULT_OOM,                 "OOM" },	\
-	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
-	{ VM_FAULT_MAJOR,               "MAJOR" },	\
-	{ VM_FAULT_WRITE,               "WRITE" },	\
-	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
-	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
-	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
-	{ VM_FAULT_NOPAGE,              "NOPAGE" },	\
-	{ VM_FAULT_LOCKED,              "LOCKED" },	\
-	{ VM_FAULT_RETRY,               "RETRY" },	\
-	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
-	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
-	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" }
+	{ (__force unsigned int) VM_FAULT_OOM,                 "OOM" },	\
+	{ (__force unsigned int) VM_FAULT_SIGBUS,              "SIGBUS" },	\
+	{ (__force unsigned int) VM_FAULT_MAJOR,               "MAJOR" },	\
+	{ (__force unsigned int) VM_FAULT_WRITE,               "WRITE" },	\
+	{ (__force unsigned int) VM_FAULT_HWPOISON,            "HWPOISON" },	\
+	{ (__force unsigned int) VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
+	{ (__force unsigned int) VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
+	{ (__force unsigned int) VM_FAULT_NOPAGE,              "NOPAGE" },	\
+	{ (__force unsigned int) VM_FAULT_LOCKED,              "LOCKED" },	\
+	{ (__force unsigned int) VM_FAULT_RETRY,               "RETRY" },	\
+	{ (__force unsigned int) VM_FAULT_FALLBACK,            "FALLBACK" },	\
+	{ (__force unsigned int) VM_FAULT_DONE_COW,            "DONE_COW" },	\
+	{ (__force unsigned int) VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 97b09fcf7e52..adc50cf7b969 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -9,7 +9,7 @@
 
 DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		pgoff_t max_pgoff, int result),
+		pgoff_t max_pgoff, vm_fault_t result),
 	TP_ARGS(inode, vmf, max_pgoff, result),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
@@ -21,7 +21,7 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__field(pgoff_t, max_pgoff)
 		__field(dev_t, dev)
 		__field(unsigned int, flags)
-		__field(int, result)
+		__field(unsigned int, result)
 	),
 	TP_fast_assign(
 		__entry->dev = inode->i_sb->s_dev;
@@ -33,7 +33,7 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__entry->flags = vmf->flags;
 		__entry->pgoff = vmf->pgoff;
 		__entry->max_pgoff = max_pgoff;
-		__entry->result = result;
+		__entry->result = (__force unsigned int) result;
 	),
 	TP_printk("dev %d:%d ino %#lx %s %s address %#lx vm_start "
 			"%#lx vm_end %#lx pgoff %#lx max_pgoff %#lx %s",
@@ -54,7 +54,7 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 #define DEFINE_PMD_FAULT_EVENT(name) \
 DEFINE_EVENT(dax_pmd_fault_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		pgoff_t max_pgoff, int result), \
+		pgoff_t max_pgoff, vm_fault_t result), \
 	TP_ARGS(inode, vmf, max_pgoff, result))
 
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault);
@@ -151,7 +151,7 @@ DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
 
 DECLARE_EVENT_CLASS(dax_pte_fault_class,
-	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, vm_fault_t result),
 	TP_ARGS(inode, vmf, result),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
@@ -160,7 +160,7 @@ DECLARE_EVENT_CLASS(dax_pte_fault_class,
 		__field(pgoff_t, pgoff)
 		__field(dev_t, dev)
 		__field(unsigned int, flags)
-		__field(int, result)
+		__field(unsigned int, result)
 	),
 	TP_fast_assign(
 		__entry->dev = inode->i_sb->s_dev;
@@ -169,7 +169,7 @@ DECLARE_EVENT_CLASS(dax_pte_fault_class,
 		__entry->address = vmf->address;
 		__entry->flags = vmf->flags;
 		__entry->pgoff = vmf->pgoff;
-		__entry->result = result;
+		__entry->result = (__force unsigned int) result;
 	),
 	TP_printk("dev %d:%d ino %#lx %s %s address %#lx pgoff %#lx %s",
 		MAJOR(__entry->dev),
@@ -185,7 +185,7 @@ DECLARE_EVENT_CLASS(dax_pte_fault_class,
 
 #define DEFINE_PTE_FAULT_EVENT(name) \
 DEFINE_EVENT(dax_pte_fault_class, name, \
-	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result), \
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, vm_fault_t result), \
 	TP_ARGS(inode, vmf, result))
 
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault);

