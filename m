Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B87A182225
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 11:51:37 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/6] dax: add tracepoint to dax_writeback_one()
Date: Tue, 21 Feb 2017 12:51:15 -0700
Message-Id: <20170221195116.13278-6-ross.zwisler@linux.intel.com>
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

Add a tracepoint to dax_writeback_one(), following the same logging
conventions as the rest of DAX.

Here is an example range writeback which ends up flushing one PMD and one
PTE:

test-1265  [003] ....   496.615250: dax_writeback_range: dev 259:0 ino 0x1003
pgoff 0x0-0x7ffffffffffff

test-1265  [003] ....   496.616263: dax_writeback_one: dev 259:0 ino 0x1003
pgoff 0x0 pglen 0x200

test-1265  [003] ....   496.616270: dax_writeback_one: dev 259:0 ino 0x1003
pgoff 0x305 pglen 0x1

test-1265  [003] ....   496.616272: dax_writeback_range_done: dev 259:0 ino
0x1003 pgoff 0x0-0x7ffffffffffff

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      |  1 +
 include/trace/events/fs_dax.h | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 7ca1989..d340389 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -843,6 +843,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
 	spin_unlock_irq(&mapping->tree_lock);
+	trace_dax_writeback_one(mapping->host, index, dax.size >> PAGE_SHIFT);
  unmap:
 	dax_unmap_atomic(bdev, &dax);
 	put_locked_mapping_entry(mapping, index, entry);
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 9afe8c8..292a471 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -226,6 +226,30 @@ DEFINE_EVENT(dax_writeback_range_class, name, \
 DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range);
 DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range_done);
 
+TRACE_EVENT(dax_writeback_one,
+	TP_PROTO(struct inode *inode, pgoff_t pgoff, pgoff_t pglen),
+	TP_ARGS(inode, pgoff, pglen),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(pgoff_t, pgoff)
+		__field(pgoff_t, pglen)
+		__field(dev_t, dev)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->pgoff = pgoff;
+		__entry->pglen = pglen;
+	),
+	TP_printk("dev %d:%d ino %#lx pgoff %#lx pglen %#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->pgoff,
+		__entry->pglen
+	)
+)
+
 #endif /* _TRACE_FS_DAX_H */
 
 /* This part must be outside protection */
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
