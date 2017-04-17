Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73E6F20D7A3D2
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:16:43 -0700 (PDT)
Subject: [resend PATCH v2 24/33] filesystem-dax: convert to dax_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:10:59 -0700
Message-ID: <149245625960.10206.13531754204477404679.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Filesystem-DAX flushes caches whenever it writes to the address returned
through dax_direct_access() and when writing back dirty radix entries.
That flushing is only required in the pmem case, so the dax_flush()
helper skips cache management work when the underlying driver does not
specify a flush method.

We still do all the dirty tracking since the radix entry will already be
there for locking purposes. However, the work to clean the entry will be
a nop for some dax drivers.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 11b9909c91df..edbf988de86c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -798,7 +798,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	}
 
 	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
-	wb_cache_pmem(kaddr, size);
+	dax_flush(dax_dev, pgoff, kaddr, size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
 	 * cannot be new dirty data in the pfn after the flush has completed as

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
