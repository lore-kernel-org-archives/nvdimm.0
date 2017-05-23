Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE15921A09139
 for <linux-nvdimm@lists.01.org>; Tue, 23 May 2017 14:26:09 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/3] dax: add fallback reason to dax_iomap_pmd_fault()
Date: Tue, 23 May 2017 15:25:58 -0600
Message-Id: <20170523212600.26477-2-ross.zwisler@linux.intel.com>
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

Currently the tracepoints in dax_iomap_pmd_fault() provide the user with
enough information to diagnose some but not all of the reasons for falling
back to PTEs.  Enhance the tracepoints in this function to explicitly tell
the user why the fallback happened.  This adds information for previously
undiagnosable failures such as radix tree collisions, and it also makes all
the fallback reasons much more obvious.

Here is an example of this new tracepoint output, where the page fault is
happening in a VMA that is less than 2 MiB in size:

small-1018  [004] ....    77.657433: dax_pmd_fault: dev 259:0 ino 0xc
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 vm_start
0x10200000 vm_end 0x10500000 pgoff 0x220 max_pgoff 0x1400

small-1018  [004] ....    77.657436: dax_pmd_fault_done: dev 259:0 ino 0xc
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 vm_start
0x10200000 vm_end 0x10500000 pgoff 0x220 max_pgoff 0x1400 FALLBACK beyond
vma

The "beyond vma" text at the end is the new bit, telling us that our PMD
fault would have faulted in addresses beyond the current bounds of the VMA.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      | 33 ++++++++++++++++++++++++---------
 include/trace/events/fs_dax.h | 15 +++++++++------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c22eaf1..35b9f86 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1353,6 +1353,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	struct inode *inode = mapping->host;
 	int result = VM_FAULT_FALLBACK;
 	struct iomap iomap = { 0 };
+	char *fallback_reason = "";
 	pgoff_t max_pgoff, pgoff;
 	void *entry;
 	loff_t pos;
@@ -1366,17 +1367,22 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	pgoff = linear_page_index(vma, pmd_addr);
 	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
-	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0);
+	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0, "");
 
 	/* Fall back to PTEs if we're going to COW */
-	if (write && !(vma->vm_flags & VM_SHARED))
+	if (write && !(vma->vm_flags & VM_SHARED)) {
+		fallback_reason = "copy on write";
 		goto fallback;
+	}
 
 	/* If the PMD would extend outside the VMA */
-	if (pmd_addr < vma->vm_start)
+	if (pmd_addr < vma->vm_start) {
+		fallback_reason = "before vma";
 		goto fallback;
-	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
+	} else if ((pmd_addr + PMD_SIZE) > vma->vm_end) {
+		fallback_reason = "beyond vma";
 		goto fallback;
+	}
 
 	if (pgoff > max_pgoff) {
 		result = VM_FAULT_SIGBUS;
@@ -1384,8 +1390,10 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	}
 
 	/* If the PMD would extend beyond the file size */
-	if ((pgoff | PG_PMD_COLOUR) > max_pgoff)
+	if ((pgoff | PG_PMD_COLOUR) > max_pgoff) {
+		fallback_reason = "beyond file";
 		goto fallback;
+	}
 
 	/*
 	 * grab_mapping_entry() will make sure we get a 2M empty entry, a DAX
@@ -1394,8 +1402,10 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	 * back to 4k entries.
 	 */
 	entry = grab_mapping_entry(mapping, pgoff, RADIX_DAX_PMD);
-	if (IS_ERR(entry))
+	if (IS_ERR(entry)) {
+		fallback_reason = "entry lock";
 		goto fallback;
+	}
 
 	/*
 	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
@@ -1404,11 +1414,15 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	 */
 	pos = (loff_t)pgoff << PAGE_SHIFT;
 	error = ops->iomap_begin(inode, pos, PMD_SIZE, iomap_flags, &iomap);
-	if (error)
+	if (error) {
+		fallback_reason = "iomap begin";
 		goto unlock_entry;
+	}
 
-	if (iomap.offset + iomap.length < pos + PMD_SIZE)
+	if (iomap.offset + iomap.length < pos + PMD_SIZE) {
+		fallback_reason = "beyond iomap";
 		goto finish_iomap;
+	}
 
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
@@ -1448,7 +1462,8 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 		count_vm_event(THP_FAULT_FALLBACK);
 	}
 out:
-	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, result);
+	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, result,
+			fallback_reason);
 	return result;
 }
 #else
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 08bb3ed..fd12f8c 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -8,8 +8,8 @@
 
 DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		pgoff_t max_pgoff, int result),
-	TP_ARGS(inode, vmf, max_pgoff, result),
+		pgoff_t max_pgoff, int result, char *fallback_reason),
+	TP_ARGS(inode, vmf, max_pgoff, result, fallback_reason),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
 		__field(unsigned long, vm_start)
@@ -18,6 +18,7 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__field(unsigned long, address)
 		__field(pgoff_t, pgoff)
 		__field(pgoff_t, max_pgoff)
+		__field(char *, fallback_reason)
 		__field(dev_t, dev)
 		__field(unsigned int, flags)
 		__field(int, result)
@@ -33,9 +34,10 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__entry->pgoff = vmf->pgoff;
 		__entry->max_pgoff = max_pgoff;
 		__entry->result = result;
+		__entry->fallback_reason = fallback_reason;
 	),
 	TP_printk("dev %d:%d ino %#lx %s %s address %#lx vm_start "
-			"%#lx vm_end %#lx pgoff %#lx max_pgoff %#lx %s",
+			"%#lx vm_end %#lx pgoff %#lx max_pgoff %#lx %s %s",
 		MAJOR(__entry->dev),
 		MINOR(__entry->dev),
 		__entry->ino,
@@ -46,15 +48,16 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__entry->vm_end,
 		__entry->pgoff,
 		__entry->max_pgoff,
-		__print_flags(__entry->result, "|", VM_FAULT_RESULT_TRACE)
+		__print_flags(__entry->result, "|", VM_FAULT_RESULT_TRACE),
+		__entry->fallback_reason
 	)
 )
 
 #define DEFINE_PMD_FAULT_EVENT(name) \
 DEFINE_EVENT(dax_pmd_fault_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		pgoff_t max_pgoff, int result), \
-	TP_ARGS(inode, vmf, max_pgoff, result))
+		pgoff_t max_pgoff, int result, char *fallback_reason), \
+	TP_ARGS(inode, vmf, max_pgoff, result, fallback_reason))
 
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault);
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_done);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
