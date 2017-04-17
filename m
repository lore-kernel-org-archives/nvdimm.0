Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F37FC20D7A3D3
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:17:27 -0700 (PDT)
Subject: [resend PATCH v2 32/33] filesystem-dax: gate calls to dax_flush()
 on QUEUE_FLAG_WC
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:11:43 -0700
Message-ID: <149245630377.10206.16395058260450137463.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Some platforms arrange for cpu caches to be flushed on power-fail. On
those platforms there is no requirement that the kernel track and flush
potentially dirty cache lines. Given that we still insert entries into
the radix for locking purposes this patch only disables the cache flush
loop, not the dirty tracking.

Userspace can override the default cache setting via the block device
queue "write_cache" attribute in sysfs.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f37ed21e4093..5b7ee1bc74d0 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -797,7 +797,8 @@ static int dax_writeback_one(struct block_device *bdev,
 	}
 
 	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
-	dax_flush(dax_dev, pgoff, kaddr, size);
+	if (test_bit(QUEUE_FLAG_WC, &bdev->bd_queue->queue_flags))
+		dax_flush(dax_dev, pgoff, kaddr, size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
 	 * cannot be new dirty data in the pfn after the flush has completed as
@@ -982,7 +983,8 @@ int __dax_zero_page_range(struct block_device *bdev,
 			return rc;
 		}
 		memset(kaddr + offset, 0, size);
-		dax_flush(dax_dev, pgoff, kaddr + offset, size);
+		if (test_bit(QUEUE_FLAG_WC, &bdev->bd_queue->queue_flags))
+			dax_flush(dax_dev, pgoff, kaddr + offset, size);
 		dax_read_unlock(id);
 	}
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
