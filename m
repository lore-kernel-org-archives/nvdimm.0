Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C996782227
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 11:51:36 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/6] dax: add tracepoints to dax_iomap_pte_fault()
Date: Tue, 21 Feb 2017 12:51:11 -0700
Message-Id: <20170221195116.13278-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20170221195116.13278-1-ross.zwisler@linux.intel.com>
References: <20170221195116.13278-1-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add tracepoints to dax_iomap_pte_fault(), following the same logging
conventions as the rest of DAX.

Here is an example fault that initially tries to be serviced by the PMD
fault handler but which falls back to PTEs because the VMA isn't large
enough to hold a PMD:

small-1086  [005] ....    71.140014: xfs_filemap_huge_fault: dev 259:0 ino
0x1003

small-1086  [005] ....    71.140027: dax_pmd_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 vm_start
0x10200000 vm_end 0x10500000 pgoff 0x220 max_pgoff 0x1400

small-1086  [005] ....    71.140028: dax_pmd_fault_done: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 vm_start
0x10200000 vm_end 0x10500000 pgoff 0x220 max_pgoff 0x1400 FALLBACK

small-1086  [005] ....    71.140035: dax_pte_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff 0x220

small-1086  [005] ....    71.140396: dax_pte_fault_done: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff
0x220 MAJOR|NOPAGE

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      | 15 +++++++++++----
 include/trace/events/fs_dax.h | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 8cf4f41..bf70d4d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1132,13 +1132,16 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	int vmf_ret = 0;
 	void *entry;
 
+	trace_dax_pte_fault(inode, vmf, vmf_ret);
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is supposed
 	 * to hold locks serializing us with truncate / punch hole so this is
 	 * a reliable test.
 	 */
-	if (pos >= i_size_read(inode))
-		return VM_FAULT_SIGBUS;
+	if (pos >= i_size_read(inode)) {
+		vmf_ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
 
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
 		flags |= IOMAP_WRITE;
@@ -1149,8 +1152,10 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	 * that we never have to deal with more than a single extent here.
 	 */
 	error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
-	if (error)
-		return dax_fault_return(error);
+	if (error) {
+		vmf_ret = dax_fault_return(error);
+		goto out;
+	}
 	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
 		vmf_ret = dax_fault_return(-EIO);	/* fs corruption? */
 		goto finish_iomap;
@@ -1234,6 +1239,8 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		 */
 		ops->iomap_end(inode, pos, PAGE_SIZE, copied, flags, &iomap);
 	}
+out:
+	trace_dax_pte_fault_done(inode, vmf, vmf_ret);
 	return vmf_ret;
 }
 
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index c566ddc..cbcd7d6 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -150,6 +150,47 @@ DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping_fallback);
 
+DECLARE_EVENT_CLASS(dax_pte_fault_class,
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
+	TP_ARGS(inode, vmf, result),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long, vm_flags)
+		__field(unsigned long, address)
+		__field(pgoff_t, pgoff)
+		__field(dev_t, dev)
+		__field(unsigned int, flags)
+		__field(int, result)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->vm_flags = vmf->vma->vm_flags;
+		__entry->address = vmf->address;
+		__entry->flags = vmf->flags;
+		__entry->pgoff = vmf->pgoff;
+		__entry->result = result;
+	),
+	TP_printk("dev %d:%d ino %#lx %s %s address %#lx pgoff %#lx %s",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->vm_flags & VM_SHARED ? "shared" : "private",
+		__print_flags(__entry->flags, "|", FAULT_FLAG_TRACE),
+		__entry->address,
+		__entry->pgoff,
+		__print_flags(__entry->result, "|", VM_FAULT_RESULT_TRACE)
+	)
+)
+
+#define DEFINE_PTE_FAULT_EVENT(name) \
+DEFINE_EVENT(dax_pte_fault_class, name, \
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result), \
+	TP_ARGS(inode, vmf, result))
+
+DEFINE_PTE_FAULT_EVENT(dax_pte_fault);
+DEFINE_PTE_FAULT_EVENT(dax_pte_fault_done);
+
 #endif /* _TRACE_FS_DAX_H */
 
 /* This part must be outside protection */
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
