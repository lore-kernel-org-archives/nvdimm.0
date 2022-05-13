Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209937A
	for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 22:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652480002; x=1684016002;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tp29QKBC0TkkWxqN6GFsZPZItezTnUJxKUUuesmJmVE=;
  b=meZ8628LzK06YqI0MbQts/Qka0mE13aygG4yxFqlfWR/v85hfS5s1Lc+
   oU9gdqD6VSQzB9SmmHTrYIho4+OcNYvzREtw4ZOtB61COs/vwxlWKY33D
   tqHsdF3LeHd6fzWS/eshTw9syfDKlymw1jhBDH3blX5cF/K3ejj4apu9l
   f33oLzs51G+xM/xrLw7qfC5BOO2c9f6vfAzhMRmuVRMUJNshXK/aFZIRl
   d0tNodrFrqAj6vSDoCa+SFd+62u6KrBLoTIZ4xGdVNWAU5JsDIU0V1Px1
   w9rv5cYQxUdTNVHF4ff5Mw4Qs47ZEbEbradUpKvr+I46+kqlq3YRe2Rjl
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="270095935"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="270095935"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:13:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="659299630"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:13:20 -0700
Subject: [PATCH v10 7/7] pmem: implement pmem_recovery_write()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>,
 nvdimm@lists.linux.dev
Date: Fri, 13 May 2022 15:13:20 -0700
Message-ID: <165247997655.53156.8381418704988035976.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20220422224508.440670-8-jane.chu@oracle.com>
References: <20220422224508.440670-8-jane.chu@oracle.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jane Chu <jane.chu@oracle.com>

The recovery write thread started out as a normal pwrite thread and
when the filesystem was told about potential media error in the
range, filesystem turns the normal pwrite to a dax_recovery_write.

The recovery write consists of clearing media poison, clearing page
HWPoison bit, reenable page-wide read-write permission, flush the
caches and finally write.  A competing pread thread will be held
off during the recovery process since data read back might not be
valid, and this is achieved by clearing the badblock records after
the recovery write is complete. Competing recovery write threads
are already serialized by writer lock held by dax_iomap_rw().

Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v9:
- Fixup compile warnings in debug messages

 drivers/nvdimm/pmem.c |   87 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 79 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0961625dfa05..6b24ecada695 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -266,21 +266,43 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		pfn_t *pfn)
 {
 	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
-
-	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
-					PFN_PHYS(nr_pages))))
-		return -EIO;
+	sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
+	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
+	struct badblocks *bb = &pmem->bb;
+	sector_t first_bad;
+	int num_bad;
 
 	if (kaddr)
 		*kaddr = pmem->virt_addr + offset;
 	if (pfn)
 		*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
+	if (bb->count &&
+	    badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
+		long actual_nr;
+
+		if (mode != DAX_RECOVERY_WRITE)
+			return -EIO;
+
+		/*
+		 * Set the recovery stride is set to kernel page size because
+		 * the underlying driver and firmware clear poison functions
+		 * don't appear to handle large chunk(such as 2MiB) reliably.
+		 */
+		actual_nr = PHYS_PFN(
+			PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
+		dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
+				sector, nr_pages, first_bad, actual_nr);
+		if (actual_nr)
+			return actual_nr;
+		return 1;
+	}
+
 	/*
-	 * If badblocks are present, limit known good range to the
-	 * requested range.
+	 * If badblocks are present but not in the range, limit known good range
+	 * to the requested range.
 	 */
-	if (unlikely(pmem->bb.count))
+	if (bb->count)
 		return nr_pages;
 	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
 }
@@ -310,10 +332,59 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 	return __pmem_direct_access(pmem, pgoff, nr_pages, mode, kaddr, pfn);
 }
 
+/*
+ * The recovery write thread started out as a normal pwrite thread and
+ * when the filesystem was told about potential media error in the
+ * range, filesystem turns the normal pwrite to a dax_recovery_write.
+ *
+ * The recovery write consists of clearing media poison, clearing page
+ * HWPoison bit, reenable page-wide read-write permission, flush the
+ * caches and finally write.  A competing pread thread will be held
+ * off during the recovery process since data read back might not be
+ * valid, and this is achieved by clearing the badblock records after
+ * the recovery write is complete. Competing recovery write threads
+ * are already serialized by writer lock held by dax_iomap_rw().
+ */
 static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return 0;
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	size_t olen, len, off;
+	phys_addr_t pmem_off;
+	struct device *dev = pmem->bb.dev;
+	long cleared;
+
+	off = offset_in_page(addr);
+	len = PFN_PHYS(PFN_UP(off + bytes));
+	if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) >> SECTOR_SHIFT, len))
+		return _copy_from_iter_flushcache(addr, bytes, i);
+
+	/*
+	 * Not page-aligned range cannot be recovered. This should not
+	 * happen unless something else went wrong.
+	 */
+	if (off || !PAGE_ALIGNED(bytes)) {
+		dev_dbg(dev, "Found poison, but addr(%p) or bytes(%#zx) not page aligned\n",
+			addr, bytes);
+		return 0;
+	}
+
+	pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
+	cleared = __pmem_clear_poison(pmem, pmem_off, len);
+	if (cleared > 0 && cleared < len) {
+		dev_dbg(dev, "poison cleared only %ld out of %zu bytes\n",
+			cleared, len);
+		return 0;
+	}
+	if (cleared < 0) {
+		dev_dbg(dev, "poison clear failed: %ld\n", cleared);
+		return 0;
+	}
+
+	olen = _copy_from_iter_flushcache(addr, bytes, i);
+	pmem_clear_bb(pmem, to_sect(pmem, pmem_off), cleared >> SECTOR_SHIFT);
+
+	return olen;
 }
 
 static const struct dax_operations pmem_dax_ops = {

