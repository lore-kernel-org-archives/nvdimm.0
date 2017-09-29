Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A160021F30415
 for <linux-nvdimm@lists.01.org>; Thu, 28 Sep 2017 18:24:22 -0700 (PDT)
Subject: [PATCH v2 2/4] dax: disable filesystem dax on devices that do not
 map pages
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Sep 2017 18:21:12 -0700
Message-ID: <150664807247.36094.11168730579639072446.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

If a dax buffer from a device that does not map pages is passed to
read(2) or write(2) as a target for direct-I/O it triggers SIGBUS. If
gdb attempts to examine the contents of a dax buffer from a device that
does not map pages it triggers SIGBUS. If fork(2) is called on a process
with a dax mapping from a device that does not map pages it triggers
SIGBUS. 'struct page' is required otherwise several kernel code paths
break in surprising ways. Disable filesystem-dax on devices that do not
map pages.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index b0cc8117eebe..491d4859c644 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -15,6 +15,7 @@
 #include <linux/mount.h>
 #include <linux/magic.h>
 #include <linux/genhd.h>
+#include <linux/pfn_t.h>
 #include <linux/cdev.h>
 #include <linux/hash.h>
 #include <linux/slab.h>
@@ -123,6 +124,12 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 		return len < 0 ? len : -EIO;
 	}
 
+	if (!pfn_t_has_page(pfn)) {
+		pr_debug("VFS (%s): error: dax support not enabled\n",
+				sb->s_id);
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__bdev_dax_supported);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
