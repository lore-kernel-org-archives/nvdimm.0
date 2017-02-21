Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82E1F82227
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 11:51:37 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 4/6] dax: add tracepoints to dax_writeback_mapping_range()
Date: Tue, 21 Feb 2017 12:51:14 -0700
Message-Id: <20170221195116.13278-5-ross.zwisler@linux.intel.com>
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

Add tracepoints to dax_writeback_mapping_range(), following the same
logging conventions as the rest of DAX.

Here is an example writeback call:

msync-1085  [006] ....   200.902565: dax_writeback_range: dev 259:0 ino
0x1003 pgoff 0x200-0x2ff

msync-1085  [006] ....   200.902579: dax_writeback_range_done: dev 259:0
ino 0x1003 pgoff 0x200-0x2ff

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c                      |  8 ++++++--
 include/trace/events/fs_dax.h | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index bcfa11a..7ca1989 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -878,6 +878,8 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 	start_index = wbc->range_start >> PAGE_SHIFT;
 	end_index = wbc->range_end >> PAGE_SHIFT;
 
+	trace_dax_writeback_range(inode, start_index, end_index);
+
 	tag_pages_for_writeback(mapping, start_index, end_index);
 
 	pagevec_init(&pvec, 0);
@@ -898,10 +900,12 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 			ret = dax_writeback_one(bdev, mapping, indices[i],
 					pvec.pages[i]);
 			if (ret < 0)
-				return ret;
+				goto out;
 		}
 	}
-	return 0;
+out:
+	trace_dax_writeback_range_done(inode, start_index, end_index);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 2f15dfe..9afe8c8 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -194,6 +194,38 @@ DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite_no_entry);
 DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite);
 DEFINE_PTE_FAULT_EVENT(dax_load_hole);
 
+DECLARE_EVENT_CLASS(dax_writeback_range_class,
+	TP_PROTO(struct inode *inode, pgoff_t start_index, pgoff_t end_index),
+	TP_ARGS(inode, start_index, end_index),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(pgoff_t, start_index)
+		__field(pgoff_t, end_index)
+		__field(dev_t, dev)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->start_index = start_index;
+		__entry->end_index = end_index;
+	),
+	TP_printk("dev %d:%d ino %#lx pgoff %#lx-%#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->start_index,
+		__entry->end_index
+	)
+)
+
+#define DEFINE_WRITEBACK_RANGE_EVENT(name) \
+DEFINE_EVENT(dax_writeback_range_class, name, \
+	TP_PROTO(struct inode *inode, pgoff_t start_index, pgoff_t end_index),\
+	TP_ARGS(inode, start_index, end_index))
+
+DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range);
+DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range_done);
+
 #endif /* _TRACE_FS_DAX_H */
 
 /* This part must be outside protection */
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
