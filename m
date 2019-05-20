Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26BD7212735A4
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 12:24:25 -0700 (PDT)
Subject: [PATCH v2] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 May 2019 12:10:38 -0700
Message-ID: <155837931725.876528.6291628638777172042.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jeff Smits <jeff.smits@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Jeff discovered that performance improves from ~375K iops to ~519K iops
on a simple psync-write fio workload when moving the location of 'struct
page' from the default PMEM location to DRAM. This result is surprising
because the expectation is that 'struct page' for dax is only needed for
third party references to dax mappings. For example, a dax-mapped buffer
passed to another system call for direct-I/O requires 'struct page' for
sending the request down the driver stack and pinning the page. There is
no usage of 'struct page' for first party access to a file via
read(2)/write(2) and friends.

However, this "no page needed" expectation is violated by
CONFIG_HARDENED_USERCOPY and the check_copy_size() performed in
copy_from_iter_full_nocache() and copy_to_iter_mcsafe(). The
check_heap_object() helper routine assumes the buffer is backed by a
slab allocator (DRAM) page and applies some checks.  Those checks are
invalid, dax pages do not originate from the slab, and redundant,
dax_iomap_actor() has already validated that the I/O is within bounds.
Specifically that routine validates that the logical file offset is
within bounds of the file, then it does a sector-to-pfn translation
which validates that the physical mapping is within bounds of the block
device.

Bypass additional hardened usercopy overhead and call the 'no check'
versions of the copy_{to,from}_iter operations directly.

Fixes: 0aed55af8834 ("x86, uaccess: introduce copy_from_iter_flushcache...")
Cc: <stable@vger.kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Reported-and-tested-by: Jeff Smits <jeff.smits@intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v1 [1]:
* Update the changelog to clarify which checks in dax_iomap_actor()
  obviate the need for "hardened" checks. (Jan)
* Update the code comment in drivers/nvdimm/pmem.c to reflect the same.
* Collect some Acks from Kees and Jan.

[1]: https://lore.kernel.org/lkml/155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com/

 drivers/nvdimm/pmem.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 845c5b430cdd..c894f45e5077 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -281,16 +281,21 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
 }
 
+/*
+ * Use the 'no check' versions of copy_from_iter_flushcache() and
+ * copy_to_iter_mcsafe() to bypass HARDENED_USERCOPY overhead. Bounds
+ * checking is handled by dax_iomap_actor()
+ */
 static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return copy_from_iter_flushcache(addr, bytes, i);
+	return _copy_from_iter_flushcache(addr, bytes, i);
 }
 
 static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return copy_to_iter_mcsafe(addr, bytes, i);
+	return _copy_to_iter_mcsafe(addr, bytes, i);
 }
 
 static const struct dax_operations pmem_dax_ops = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
