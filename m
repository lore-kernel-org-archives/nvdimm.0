Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0C9C82228
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 11:51:37 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 6/6] dax: add tracepoint to dax_insert_mapping()
Date: Tue, 21 Feb 2017 12:51:16 -0700
Message-Id: <20170221195116.13278-7-ross.zwisler@linux.intel.com>
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

Add a tracepoint to dax_insert_mapping(), following the same logging
conventions as the rest of DAX.  This tracepoint, along with the one in
dax_load_hole(), lets us know how a DAX PTE fault was serviced.

Here is an example DAX fault that inserts a PTE mapping:

small-1126  [007] ....   145.451604: dax_pte_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff 0x220

small-1126  [007] ....   145.452317: dax_insert_mapping: dev 259:0 ino
0x1003 shared write address 0x10420000 radix_entry 0x100006

small-1126  [007] ....   145.452399: dax_pte_fault_done: dev 259:0 ino
0x1003 shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 pgoff
0x220 MAJOR|NOPAGE

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      |  1 +
 include/trace/events/fs_dax.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index d340389..ed53ce9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -931,6 +931,7 @@ static int dax_insert_mapping(struct address_space *mapping,
 		return PTR_ERR(ret);
 	*entryp = ret;
 
+	trace_dax_insert_mapping(mapping->host, vmf, ret);
 	return vm_insert_mixed(vma, vaddr, dax.pfn);
 }
 
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 292a471..08bb3ed 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -194,6 +194,36 @@ DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite_no_entry);
 DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite);
 DEFINE_PTE_FAULT_EVENT(dax_load_hole);
 
+TRACE_EVENT(dax_insert_mapping,
+	TP_PROTO(struct inode *inode, struct vm_fault *vmf, void *radix_entry),
+	TP_ARGS(inode, vmf, radix_entry),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long, vm_flags)
+		__field(unsigned long, address)
+		__field(void *, radix_entry)
+		__field(dev_t, dev)
+		__field(int, write)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->vm_flags = vmf->vma->vm_flags;
+		__entry->address = vmf->address;
+		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
+		__entry->radix_entry = radix_entry;
+	),
+	TP_printk("dev %d:%d ino %#lx %s %s address %#lx radix_entry %#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->vm_flags & VM_SHARED ? "shared" : "private",
+		__entry->write ? "write" : "read",
+		__entry->address,
+		(unsigned long)__entry->radix_entry
+	)
+)
+
 DECLARE_EVENT_CLASS(dax_writeback_range_class,
 	TP_PROTO(struct inode *inode, pgoff_t start_index, pgoff_t end_index),
 	TP_ARGS(inode, start_index, end_index),
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
