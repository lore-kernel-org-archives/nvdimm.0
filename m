Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA3E34A5
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:44 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433081"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433081"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:39 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702721"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:39 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 16/18] dax: Stray access protection for dax_direct_access()
Date: Tue,  3 Aug 2021 21:32:29 -0700
Message-Id: <20210804043231.2655537-17-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20210804043231.2655537-1-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

dax_direct_access() provides a way to obtain the direct map address of
PMEM memory.  Coordinate PKS protection with dax_direct_access() of
protected devmap pages.

Introduce 3 new calls dax_{protected,mk_readwrite,mk_noaccess}()
These 3 calls do not have to be implemented by the dax provider if no
protection is implemented.

Single threads of execution can use dax_mk_{readwrite,noaccess}() to
relax the protection of the dax device and allow direct use of the kaddr
returned from dax_direct_access().  dax_mk_{readwrite,noaccess}() must
be used within the dax_read_[un]lock() protected region.  And they only
need to be used to guard actual access to the memory pointed to.  Other
uses of dax_direct_access() do not need to use these guards.

For users who require a permanent address to the dax device such as the
DM write cache.  dax_protected() indicates that the dax device has
additional protections.  In this case the user choses to create it's own
mapping of the memory.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes for V7
	Rework cover letter.
	Do not include a FS_DAX_LIMITED restriction for dcss.  It  will
		simply not implement the protection and there is no need
		to special case this.
		Clean up commit message because I did not originally
		understand the nuance of the s390 device.
	Introduce dax_{protected,mk_readwrite,mk_noaccess}()
	From Dan Williams
		Remove old clean up cruft from previous versions
		Remove map_protected
	Remove 'global' parameters all calls
---
 drivers/dax/super.c        | 54 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-writecache.c |  8 +++++-
 fs/dax.c                   |  8 ++++++
 fs/fuse/virtio_fs.c        |  2 ++
 include/linux/dax.h        |  8 ++++++
 5 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 44736cbd446e..dc05c89102d0 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -296,6 +296,8 @@ EXPORT_SYMBOL_GPL(dax_attribute_group);
  * @pgoff: offset in pages from the start of the device to translate
  * @nr_pages: number of consecutive pages caller can handle relative to @pfn
  * @kaddr: output parameter that returns a virtual address mapping of pfn
+ *         Direct access through this pointer must be guarded by calls to
+ *         dax_mk_{readwrite,noaccess}()
  * @pfn: output parameter that returns an absolute pfn translation of @pgoff
  *
  * Return: negative errno if an error occurs, otherwise the number of
@@ -389,6 +391,58 @@ void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
 #endif
 EXPORT_SYMBOL_GPL(dax_flush);
 
+bool dax_map_protected(struct dax_device *dax_dev)
+{
+	if (!dax_alive(dax_dev))
+		return false;
+
+	if (dax_dev->ops->map_protected)
+		return dax_dev->ops->map_protected(dax_dev);
+	return false;
+}
+EXPORT_SYMBOL_GPL(dax_map_protected);
+
+/**
+ * dax_mk_readwrite() - make protected dax devices read/write
+ * @dax_dev: the dax device representing the memory to access
+ *
+ * Any access of the kaddr memory returned from dax_direct_access() must be
+ * guarded by dax_mk_readwrite() and dax_mk_noaccess().  This ensures that any
+ * dax devices which have additional protections are allowed to relax those
+ * protections for the thread using this memory.
+ *
+ * NOTE these calls must be contained within a single thread of execution and
+ * both must be guarded by dax_read_lock()  Which is also a requirement for
+ * dax_direct_access() anyway.
+ */
+void dax_mk_readwrite(struct dax_device *dax_dev)
+{
+	if (!dax_alive(dax_dev))
+		return;
+
+	if (dax_dev->ops->mk_readwrite)
+		dax_dev->ops->mk_readwrite(dax_dev);
+}
+EXPORT_SYMBOL_GPL(dax_mk_readwrite);
+
+/**
+ * dax_mk_noaccess() - restore protection to dax devices if needed
+ * @dax_dev: the dax device representing the memory to access
+ *
+ * See dax_direct_access() and dax_mk_readwrite()
+ *
+ * NOTE Must be called prior to dax_read_unlock()
+ */
+void dax_mk_noaccess(struct dax_device *dax_dev)
+{
+	if (!dax_alive(dax_dev))
+		return;
+
+	if (dax_dev->ops->mk_noaccess)
+		dax_dev->ops->mk_noaccess(dax_dev);
+}
+EXPORT_SYMBOL_GPL(dax_mk_noaccess);
+
 void dax_write_cache(struct dax_device *dax_dev, bool wc)
 {
 	if (wc)
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index e21e29e81bbf..27671300ad50 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -284,7 +284,13 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 		r = -EOPNOTSUPP;
 		goto err2;
 	}
-	if (da != p) {
+
+	/*
+	 * Force the write cache to map the pages directly if the dax device
+	 * mapping is protected or if the number of pages returned was not what
+	 * was requested.
+	 */
+	if (dax_map_protected(wc->ssd_dev->dax_dev) || da != p) {
 		long i;
 		wc->memory_map = NULL;
 		pages = kvmalloc_array(p, sizeof(struct page *), GFP_KERNEL);
diff --git a/fs/dax.c b/fs/dax.c
index 99b4e78d888f..9dfb93b39754 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -728,7 +728,9 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
 		return rc;
 	}
 	vto = kmap_atomic(to);
+	dax_mk_readwrite(dax_dev);
 	copy_user_page(vto, (void __force *)kaddr, vaddr, to);
+	dax_mk_noaccess(dax_dev);
 	kunmap_atomic(vto);
 	dax_read_unlock(id);
 	return 0;
@@ -1096,8 +1098,10 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
 	}
 
 	if (!page_aligned) {
+		dax_mk_readwrite(iomap->dax_dev);
 		memset(kaddr + offset, 0, size);
 		dax_flush(iomap->dax_dev, kaddr + offset, size);
+		dax_mk_noaccess(iomap->dax_dev);
 	}
 	dax_read_unlock(id);
 	return size;
@@ -1169,6 +1173,8 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		if (map_len > end - pos)
 			map_len = end - pos;
 
+		dax_mk_readwrite(dax_dev);
+
 		/*
 		 * The userspace address for the memory copy has already been
 		 * validated via access_ok() in either vfs_read() or
@@ -1181,6 +1187,8 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
 					map_len, iter);
 
+		dax_mk_noaccess(dax_dev);
+
 		pos += xfer;
 		length -= xfer;
 		done += xfer;
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 8f52cdaa8445..3dfb053b1c4d 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -776,8 +776,10 @@ static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
 	rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
 	if (rc < 0)
 		return rc;
+	dax_mk_readwrite(dax_dev);
 	memset(kaddr, 0, nr_pages << PAGE_SHIFT);
 	dax_flush(dax_dev, kaddr, nr_pages << PAGE_SHIFT);
+	dax_mk_noaccess(dax_dev);
 	return 0;
 }
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index b52f084aa643..8ad4839705ca 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -36,6 +36,10 @@ struct dax_operations {
 			struct iov_iter *);
 	/* zero_page_range: required operation. Zero page range   */
 	int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
+
+	bool (*map_protected)(struct dax_device *dax_dev);
+	void (*mk_readwrite)(struct dax_device *dax_dev);
+	void (*mk_noaccess)(struct dax_device *dax_dev);
 };
 
 extern struct attribute_group dax_attribute_group;
@@ -228,6 +232,10 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 			size_t nr_pages);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
 
+bool dax_map_protected(struct dax_device *dax_dev);
+void dax_mk_readwrite(struct dax_device *dax_dev);
+void dax_mk_noaccess(struct dax_device *dax_dev);
+
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
 vm_fault_t dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
-- 
2.28.0.rc0.12.gb6a658bd00c9

