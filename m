Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26D672034C087
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 19:41:53 -0700 (PDT)
Subject: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 19:39:07 -0700
Message-ID: <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

If a dax buffer from a device that does not map pages is passed to
read(2) or write(2) as a target for direct-I/O it triggers SIGBUS. If
gdb attempts to examine the contents of a dax buffer from a device that
does not map pages it triggers SIGBUS. If fork(2) is called on a process
with a dax mapping from a device that does not map pages it triggers
SIGBUS. 'struct page' is required otherwise several kernel code paths
break in surprising ways. Disable filesystem-dax on devices that do not
map pages.

In addition to needing pfn_to_page() to be valid we also require devmap
pages. We need this to detect dax pages in the get_user_pages_fast()
path and so that we can stop managing the VM_MIXEDMAP flag. This impacts
the dax drivers that do not use dev_memremap_pages(): brd, dcssblk, and
axonram.

Note that when the initial dax support was being merged a few years back
there was concern that struct page was unsuitable for use with next
generation persistent memory devices. The theoretical concern was that
struct page access, being such a hotly used data structure in the
kernel, would lead to media wear out. While that was a reasonable
conservative starting position it has not held true in practice. We have
long since committed to using devm_memremap_pages() to support higher
order kernel functionality that needs get_user_pages() and
pfn_to_page().

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c |    1 +
 drivers/dax/super.c           |    7 +++++++
 drivers/s390/block/dcssblk.c  |    1 +
 3 files changed, 9 insertions(+)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index c60e84e4558d..9da64d95e6f1 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -172,6 +172,7 @@ static size_t axon_ram_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 
 static const struct dax_operations axon_ram_dax_ops = {
 	.direct_access = axon_ram_dax_direct_access,
+
 	.copy_from_iter = axon_ram_copy_from_iter,
 };
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index b0cc8117eebe..26c324a5aef4 100644
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
 
+	if (!pfn_t_devmap(pfn)) {
+		pr_debug("VFS (%s): error: dax support not enabled\n",
+				sb->s_id);
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__bdev_dax_supported);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 7abb240847c0..e7e5db07e339 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -52,6 +52,7 @@ static size_t dcssblk_dax_copy_from_iter(struct dax_device *dax_dev,
 
 static const struct dax_operations dcssblk_dax_ops = {
 	.direct_access = dcssblk_dax_direct_access,
+
 	.copy_from_iter = dcssblk_dax_copy_from_iter,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
