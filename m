Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4735219FFEC9
 for <linux-nvdimm@lists.01.org>; Tue, 23 May 2017 14:26:11 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/3] dax: add fallback reason to dax_pmd_load_hole()
Date: Tue, 23 May 2017 15:26:00 -0600
Message-Id: <20170523212600.26477-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20170523212600.26477-1-ross.zwisler@linux.intel.com>
References: <20170523212600.26477-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Currently the tracepoints in dax_pmd_load_hole() provide the user with
enough information to diagnose some but not all of the reasons for falling
back to PTEs.  Enhance the tracepoints in this function to explicitly tell
the user why the fallback happened.  This adds information for previously
undiagnosable failures such as PMD collisions, and it also makes all the
fallback reasons much more obvious.

Here is an example of this new tracepoint output where the page fault found
that another PMD had been inserted into our page tables:

read_big-1138  [004] ....   202.093800: dax_pmd_fault: dev 259:0 ino 0xc
shared ALLOW_RETRY|KILLABLE|USER address 0x10400000 vm_start 0x10200000
vm_end 0x10600000 pgoff 0x200 max_pgoff 0x1400

read_big-1138  [004] ....   202.094002: dax_pmd_load_hole_fallback: dev
259:0 ino 0xc shared address 0x10400000 zero_page ffffea0007758000
radix_entry 0x1e pmd collision

read_big-1138  [004] ....   202.094004: dax_pmd_fault_done: dev 259:0 ino
0xc shared ALLOW_RETRY|KILLABLE|USER address 0x10400000 vm_start 0x10200000
vm_end 0x10600000 pgoff 0x200 max_pgoff 0x1400 FALLBACK

The "pmd collision" text at the end of the second line is the new bit,
telling us why dax_pmd_load_hole() failed.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      | 15 +++++++++++----
 include/trace/events/fs_dax.h | 16 ++++++++++------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 531d235..45e22cd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1320,6 +1320,7 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	struct inode *inode = mapping->host;
+	char *fallback_reason = "";
 	struct page *zero_page;
 	void *ret = NULL;
 	spinlock_t *ptl;
@@ -1327,17 +1328,22 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 
 	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
 
-	if (unlikely(!zero_page))
+	if (unlikely(!zero_page)) {
+		fallback_reason = "no zero page";
 		goto fallback;
+	}
 
 	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, 0,
 			RADIX_DAX_PMD | RADIX_DAX_HZP);
-	if (IS_ERR(ret))
+	if (IS_ERR(ret)) {
+		fallback_reason = "insert mapping";
 		goto fallback;
+	}
 	*entryp = ret;
 
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
+		fallback_reason = "pmd collision";
 		spin_unlock(ptl);
 		goto fallback;
 	}
@@ -1346,11 +1352,12 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 	pmd_entry = pmd_mkhuge(pmd_entry);
 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
 	spin_unlock(ptl);
-	trace_dax_pmd_load_hole(inode, vmf, zero_page, ret);
+	trace_dax_pmd_load_hole(inode, vmf, zero_page, ret, "");
 	return VM_FAULT_NOPAGE;
 
 fallback:
-	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, ret);
+	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, ret,
+			fallback_reason);
 	return VM_FAULT_FALLBACK;
 }
 
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 2263029..e8d7494 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -65,14 +65,15 @@ DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_done);
 DECLARE_EVENT_CLASS(dax_pmd_load_hole_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
 		struct page *zero_page,
-		void *radix_entry),
-	TP_ARGS(inode, vmf, zero_page, radix_entry),
+		void *radix_entry, char *fallback_reason),
+	TP_ARGS(inode, vmf, zero_page, radix_entry, fallback_reason),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
 		__field(unsigned long, vm_flags)
 		__field(unsigned long, address)
 		__field(struct page *, zero_page)
 		__field(void *, radix_entry)
+		__field(char *, fallback_reason)
 		__field(dev_t, dev)
 	),
 	TP_fast_assign(
@@ -82,24 +83,27 @@ DECLARE_EVENT_CLASS(dax_pmd_load_hole_class,
 		__entry->address = vmf->address;
 		__entry->zero_page = zero_page;
 		__entry->radix_entry = radix_entry;
+		__entry->fallback_reason = fallback_reason;
 	),
 	TP_printk("dev %d:%d ino %#lx %s address %#lx zero_page %p "
-			"radix_entry %#lx",
+			"radix_entry %#lx %s",
 		MAJOR(__entry->dev),
 		MINOR(__entry->dev),
 		__entry->ino,
 		__entry->vm_flags & VM_SHARED ? "shared" : "private",
 		__entry->address,
 		__entry->zero_page,
-		(unsigned long)__entry->radix_entry
+		(unsigned long)__entry->radix_entry,
+		__entry->fallback_reason
 	)
 )
 
 #define DEFINE_PMD_LOAD_HOLE_EVENT(name) \
 DEFINE_EVENT(dax_pmd_load_hole_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		struct page *zero_page, void *radix_entry), \
-	TP_ARGS(inode, vmf, zero_page, radix_entry))
+		struct page *zero_page, void *radix_entry, \
+		char *fallback_reason), \
+	TP_ARGS(inode, vmf, zero_page, radix_entry, fallback_reason))
 
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
