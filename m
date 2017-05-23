Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3338219FFEC9
 for <linux-nvdimm@lists.01.org>; Tue, 23 May 2017 14:26:10 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/3] dax: add fallback reason to dax_pmd_insert_mapping()
Date: Tue, 23 May 2017 15:25:59 -0600
Message-Id: <20170523212600.26477-3-ross.zwisler@linux.intel.com>
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

Currently the tracepoints in dax_pmd_insert_mapping() provide the user with
enough information to diagnose some but not all of the reasons for falling
back to PTEs.  Enhance the tracepoints in this function to explicitly tell
the user why the fallback happened.  This adds information for previously
undiagnosable failures such as dax_direct_access() failures, and it also
makes all the fallback reasons much more obvious.

Here is an example of this new tracepoint output where the page fault is
happening on a device that is in "raw" mode, and thus doesn't have the
required struct pages to be able to handle PMD faults:

big-1011  [000] ....    36.164708: dax_pmd_fault: dev 259:0 ino 0xc shared
WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start 0x10200000
vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400

big-1011  [000] ....    36.165521: dax_pmd_insert_mapping_fallback: dev
259:0 ino 0xc shared write address 0x10505000 length 0x200000 pfn
0x2000000000249200 DEV radix_entry 0x0 pfn_t not devmap

big-1011  [000] ....    36.165524: dax_pmd_fault_done: dev 259:0 ino 0xc
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
0x10200000 vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400 FALLBACK

The "pfn_t not devmap" text at the end of the second line is the new bit,
telling us that our PFN didn't have both the PFN_DEV and PFN_MAP flags set.
This patch also stops masking off the pfn_t flags from the tracepoint
output, since they are useful when diagnosing some fallbacks.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      | 28 ++++++++++++++++++++--------
 include/trace/events/fs_dax.h | 19 ++++++++++++-------
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 35b9f86..531d235 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1262,43 +1262,55 @@ static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 	struct block_device *bdev = iomap->bdev;
 	struct inode *inode = mapping->host;
 	const size_t size = PMD_SIZE;
+	char *fallback_reason = "";
 	void *ret = NULL, *kaddr;
 	long length = 0;
 	pgoff_t pgoff;
 	pfn_t pfn;
 	int id;
 
-	if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
+	if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0) {
+		fallback_reason = "bad pgoff";
 		goto fallback;
+	}
 
 	id = dax_read_lock();
 	length = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
-	if (length < 0)
+	if (length < 0) {
+		fallback_reason = "direct access";
 		goto unlock_fallback;
+	}
 	length = PFN_PHYS(length);
 
-	if (length < size)
+	if (length < size) {
+		fallback_reason = "bad length";
 		goto unlock_fallback;
-	if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)
+	} else if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR) {
+		fallback_reason = "pfn unaligned";
 		goto unlock_fallback;
-	if (!pfn_t_devmap(pfn))
+	} else if (!pfn_t_devmap(pfn)) {
+		fallback_reason = "pfn_t not devmap";
 		goto unlock_fallback;
+	}
 	dax_read_unlock(id);
 
 	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, sector,
 			RADIX_DAX_PMD);
-	if (IS_ERR(ret))
+	if (IS_ERR(ret)) {
+		fallback_reason = "insert mapping";
 		goto fallback;
+	}
 	*entryp = ret;
 
-	trace_dax_pmd_insert_mapping(inode, vmf, length, pfn, ret);
+	trace_dax_pmd_insert_mapping(inode, vmf, length, pfn, ret, "");
 	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
 			pfn, vmf->flags & FAULT_FLAG_WRITE);
 
 unlock_fallback:
 	dax_read_unlock(id);
 fallback:
-	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);
+	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret,
+			fallback_reason);
 	return VM_FAULT_FALLBACK;
 }
 
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index fd12f8c..2263029 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -106,8 +106,9 @@ DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
 
 DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		long length, pfn_t pfn, void *radix_entry),
-	TP_ARGS(inode, vmf, length, pfn, radix_entry),
+		long length, pfn_t pfn, void *radix_entry,
+		char *fallback_reason),
+	TP_ARGS(inode, vmf, length, pfn, radix_entry, fallback_reason),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
 		__field(unsigned long, vm_flags)
@@ -115,6 +116,7 @@ DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
 		__field(long, length)
 		__field(u64, pfn_val)
 		__field(void *, radix_entry)
+		__field(char *, fallback_reason)
 		__field(dev_t, dev)
 		__field(int, write)
 	),
@@ -127,9 +129,10 @@ DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
 		__entry->length = length;
 		__entry->pfn_val = pfn.val;
 		__entry->radix_entry = radix_entry;
+		__entry->fallback_reason = fallback_reason;
 	),
 	TP_printk("dev %d:%d ino %#lx %s %s address %#lx length %#lx "
-			"pfn %#llx %s radix_entry %#lx",
+			"pfn %#llx %s radix_entry %#lx %s",
 		MAJOR(__entry->dev),
 		MINOR(__entry->dev),
 		__entry->ino,
@@ -137,18 +140,20 @@ DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
 		__entry->write ? "write" : "read",
 		__entry->address,
 		__entry->length,
-		__entry->pfn_val & ~PFN_FLAGS_MASK,
+		__entry->pfn_val,
 		__print_flags_u64(__entry->pfn_val & PFN_FLAGS_MASK, "|",
 			PFN_FLAGS_TRACE),
-		(unsigned long)__entry->radix_entry
+		(unsigned long)__entry->radix_entry,
+		__entry->fallback_reason
 	)
 )
 
 #define DEFINE_PMD_INSERT_MAPPING_EVENT(name) \
 DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		long length, pfn_t pfn, void *radix_entry), \
-	TP_ARGS(inode, vmf, length, pfn, radix_entry))
+		long length, pfn_t pfn, void *radix_entry, \
+		char *fallback_reason), \
+	TP_ARGS(inode, vmf, length, pfn, radix_entry, fallback_reason))
 
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping_fallback);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
