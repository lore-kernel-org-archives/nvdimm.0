Return-Path: <owner-linux-mm@kvack.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: fix regression in dax_writeback_mapping_range()
Date: Tue, 14 Mar 2017 15:53:58 -0600
Message-Id: <20170314215358.31451-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20170314025642.nwpf7zxbc6655gum@XZHOUW.usersys.redhat.com>
References: <20170314025642.nwpf7zxbc6655gum@XZHOUW.usersys.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-next@vger.kernel.org, Xiong Zhou <xzhou@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

commit 354ae7432ee8 ("dax: add tracepoints to dax_writeback_mapping_range()")
in the -next tree, which appears in next-20170310, inadvertently changed
dax_writeback_mapping_range() so that it could end up returning a positive
value: the number of bytes flushed, as returned by dax_writeback_one().
This was incorrect. This function either needs to return a negative error
value, or zero on success.

This change was causing xfstest failures, as reported by Xiong:

https://lkml.org/lkml/2017/3/13/1220

With this fix applied to next-20170310, all the test failures reported by
Xiong (generic/075 generic/112 generic/127 generic/231 generic/263) are
resolved.

Reported-by: Xiong Zhou <xzhou@redhat.com>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1861ef0..60688c7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -907,7 +907,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 	}
 out:
 	trace_dax_writeback_range_done(inode, start_index, end_index);
-	return ret;
+	return (ret < 0 ? ret : 0);
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
