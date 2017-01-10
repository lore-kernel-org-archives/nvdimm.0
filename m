Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 407B081B3C
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jan 2017 13:52:45 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 5/7] dax: add tracepoints to dax_pmd_insert_mapping()
Date: Tue, 10 Jan 2017 14:52:20 -0700
Message-Id: <1484085142-2297-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1484085142-2297-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1484085142-2297-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add tracepoints to dax_pmd_insert_mapping(), following the same logging
conventions as the tracepoints in dax_iomap_pmd_fault().

Here is an example PMD fault showing the new tracepoints:

big-1504  [001] ....   326.960743: xfs_filemap_pmd_fault: dev 259:0 ino
0x1003

big-1504  [001] ....   326.960753: dax_pmd_fault: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
0x10200000 vm_end 0x10700000 pgoff 0x200 max_pgoff 0x1400

big-1504  [001] ....   326.960981: dax_pmd_insert_mapping: dev 259:0 ino
0x1003 shared write address 0x10505000 length 0x200000 pfn 0x100600 DEV|MAP
radix_entry 0xc000e

big-1504  [001] ....   326.960986: dax_pmd_fault_done: dev 259:0 ino 0x1003
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
0x10200000 vm_end 0x10700000 pgoff 0x200 max_pgoff 0x1400 NOPAGE

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/dax.c                      | 12 +++++++---
 include/linux/pfn_t.h         |  6 +++++
 include/trace/events/fs_dax.h | 51 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 199a7e7..4671530 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1254,15 +1254,16 @@ static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct block_device *bdev = iomap->bdev;
+	struct inode *inode = mapping->host;
 	struct blk_dax_ctl dax = {
 		.sector = dax_iomap_sector(iomap, pos),
 		.size = PMD_SIZE,
 	};
 	long length = dax_map_atomic(bdev, &dax);
-	void *ret;
+	void *ret = NULL;
 
 	if (length < 0) /* dax_map_atomic() failed */
-		return VM_FAULT_FALLBACK;
+		goto fallback;
 	if (length < PMD_SIZE)
 		goto unmap_fallback;
 	if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)
@@ -1275,13 +1276,18 @@ static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
 	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, dax.sector,
 			RADIX_DAX_PMD);
 	if (IS_ERR(ret))
-		return VM_FAULT_FALLBACK;
+		goto fallback;
 	*entryp = ret;
 
+	trace_dax_pmd_insert_mapping(inode, vma, address, write, length,
+			dax.pfn, ret);
 	return vmf_insert_pfn_pmd(vma, address, pmd, dax.pfn, write);
 
  unmap_fallback:
 	dax_unmap_atomic(bdev, &dax);
+fallback:
+	trace_dax_pmd_insert_mapping_fallback(inode, vma, address, write,
+			length, dax.pfn, ret);
 	return VM_FAULT_FALLBACK;
 }
 
diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
index a3d90b9..033fc7b 100644
--- a/include/linux/pfn_t.h
+++ b/include/linux/pfn_t.h
@@ -15,6 +15,12 @@
 #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
 #define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
 
+#define PFN_FLAGS_TRACE \
+	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
+	{ PFN_SG_LAST,	"SG_LAST" }, \
+	{ PFN_DEV,	"DEV" }, \
+	{ PFN_MAP,	"MAP" }
+
 static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
 {
 	pfn_t pfn_t = { .val = pfn | (flags & PFN_FLAGS_MASK), };
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 43f1263..c3b0aae 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -104,6 +104,57 @@ DEFINE_EVENT(dax_pmd_load_hole_class, name, \
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
 
+DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
+	TP_PROTO(struct inode *inode, struct vm_area_struct *vma,
+		unsigned long address, int write, long length, pfn_t pfn,
+		void *radix_entry),
+	TP_ARGS(inode, vma, address, write, length, pfn, radix_entry),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long, vm_flags)
+		__field(unsigned long, address)
+		__field(long, length)
+		__field(u64, pfn_val)
+		__field(void *, radix_entry)
+		__field(dev_t, dev)
+		__field(int, write)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->vm_flags = vma->vm_flags;
+		__entry->address = address;
+		__entry->write = write;
+		__entry->length = length;
+		__entry->pfn_val = pfn.val;
+		__entry->radix_entry = radix_entry;
+	),
+	TP_printk("dev %d:%d ino %#lx %s %s address %#lx length %#lx "
+			"pfn %#llx %s radix_entry %#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->vm_flags & VM_SHARED ? "shared" : "private",
+		__entry->write ? "write" : "read",
+		__entry->address,
+		__entry->length,
+		__entry->pfn_val & ~PFN_FLAGS_MASK,
+		__print_flags_u64(__entry->pfn_val & PFN_FLAGS_MASK, "|",
+			PFN_FLAGS_TRACE),
+		(unsigned long)__entry->radix_entry
+	)
+)
+
+#define DEFINE_PMD_INSERT_MAPPING_EVENT(name) \
+DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
+	TP_PROTO(struct inode *inode, struct vm_area_struct *vma, \
+		unsigned long address, int write, long length, pfn_t pfn, \
+		void *radix_entry), \
+	TP_ARGS(inode, vma, address, write, length, pfn, radix_entry))
+
+DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
+DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping_fallback);
+
 #endif /* _TRACE_FS_DAX_H */
 
 /* This part must be outside protection */
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
