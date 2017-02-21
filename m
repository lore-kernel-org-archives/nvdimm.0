Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9852E82225
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 11:51:36 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/6] dax: add tracepoints to dax_pfn_mkwrite()
Date: Tue, 21 Feb 2017 12:51:12 -0700
Message-Id: <20170221195116.13278-3-ross.zwisler@linux.intel.com>
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

Add tracepoints to dax_pfn_mkwrite(), following the same logging
conventions as the rest of DAX.

Here is an example PTE fault followed by a pfn_mkwrite:

small_aligned-1094  [002] ....   374.084998: dax_pte_fault: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10400000 pgoff
0x200

small_aligned-1094  [002] ....   374.085145: dax_pte_fault_done: dev 259:0
ino 0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10400000 pgoff
0x200 MAJOR|NOPAGE

small_aligned-1094  [002] ....   374.085165: dax_pfn_mkwrite: dev 259:0 ino
0x1003 shared WRITE|MKWRITE|ALLOW_RETRY|KILLABLE|USER address 0x10400000
pgoff 0x200 NOPAGE

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      | 3 +++
 include/trace/events/fs_dax.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index bf70d4d..b52732fb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -931,6 +931,7 @@ int dax_pfn_mkwrite(struct vm_fault *vmf)
 {
 	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
 	void *entry, **slot;
 	pgoff_t index = vmf->pgoff;
 
@@ -940,6 +941,7 @@ int dax_pfn_mkwrite(struct vm_fault *vmf)
 		if (entry)
 			put_unlocked_mapping_entry(mapping, index, entry);
 		spin_unlock_irq(&mapping->tree_lock);
+		trace_dax_pfn_mkwrite_no_entry(inode, vmf, VM_FAULT_NOPAGE);
 		return VM_FAULT_NOPAGE;
 	}
 	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
@@ -952,6 +954,7 @@ int dax_pfn_mkwrite(struct vm_fault *vmf)
 	 */
 	finish_mkwrite_fault(vmf);
 	put_locked_mapping_entry(mapping, index, entry);
+	trace_dax_pfn_mkwrite(inode, vmf, VM_FAULT_NOPAGE);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index cbcd7d6..b5a5209 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -190,6 +190,8 @@ DEFINE_EVENT(dax_pte_fault_class, name, \
 
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault);
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault_done);
+DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite_no_entry);
+DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite);
 
 #endif /* _TRACE_FS_DAX_H */
 
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
