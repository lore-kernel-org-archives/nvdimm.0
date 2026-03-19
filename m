Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FAD283FD9
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883807; cv=none; b=jMOMIYMDbSd2VS1cuAj0UmEGamYQVGl7KyDtun2d2QCBBwGqEvLiql2krYMuMEp99RzlDrBgaoKZbcf44ZmD8GsWWxZYIu7DaMWBB/eYDQf/LmQLEc9ki8qlW1e/5evLTd7m9NvO3R0ai69q5C8GozZVEvmkO+EVcCqKoQOpaJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883807; c=relaxed/simple;
	bh=Du28CXsaM4ajzOZ3yy8fwl2y4q9y12TZj0ITFOq6wz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9u48W5vy94yxYFrZYBt7q9H3cvZNPwDu6t6HiKY9Os7UN2Sw4seXoHe/122TSXYUSHkLP9Lf4eIj82zKCuf4QfJH1rJBmb0dv+UCB3W45ekPQ6Xwe4kBBk9gAjMs25MhJ3NFPPdqUrsjz8TW4LdkWi5omVqA2Xu932nseS0BVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 249D3C1385;
	Thu, 19 Mar 2026 01:30:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf03.hostedemail.com (Postfix) with ESMTPA id 89AFA6000D;
	Thu, 19 Mar 2026 01:29:50 +0000 (UTC)
From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V8 5/8] dax: Add dax_operations for use by fs-dax on fsdev dax
Date: Wed, 18 Mar 2026 20:29:48 -0500
Message-ID: <20260319012948.4493-1-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318202737.4344.dax@groves.net>
References: <20260318202737.4344.dax@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jrhx3gfgpz8obw3b7hy8z4rdgn3a3omk
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 89AFA6000D
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1989RsKLzlgHtrTYrZxTEcn3dEJDAesSl0=
X-HE-Tag: 1773883790-425132
X-HE-Meta: U2FsdGVkX19G9L0DFHWVe4xBTXUyQaBvrVCK6oT42OxNqzJwIFIpIUWKuXWSoRYtaCA/gXQEoIEC5j+Z1Y0/kflz6bxBRv52jm+u7V+1c4Os2ibljIqimVHkChgH2JiqMWNxjonEKrJubidae2PWqMdTPz5glA8sehPYDyDGuIOx5KSxzhLcntBRh1L48O8cfTQmXSmr6+/O2C+g+2/ed2ZpgbkxwBv1ERC51ta15WvnH7q/S068HtUqp5UBBZR/6449y0lrg7VfA+hjiItwr1k6BNeJL+eWHSbIlNYl3njVjTPkzokPCXb2xgvMfbQ0Gvqo2pqSJBc=

From: John Groves <John@Groves.net>

fsdev: Add dax_operations for use by famfs.

This replicates the functionality from drivers/nvdimm/pmem.c that
conventional fs-dax file systems (e.g. xfs) use to support dax
read/write/mmap to a daxdev - without which famfs can't sit atop a
daxdev.

- These methods are based on pmem_dax_ops from drivers/nvdimm/pmem.c
- fsdev_dax_direct_access() returns the hpa, pfn and kva. The kva was
  newly stored as dev_dax->virt_addr by dev_dax_probe().
- The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
  for read/write (dax_iomap_rw())
- fsdev_dax_recovery_write() and dev_dax_zero_page_range() have not been
  tested yet. I'm looking for suggestions as to how to test those.
- dax-private.h: add dev_dax->cached_size, which fsdev needs to
  remember. The dev_dax size cannot change while a driver is bound
  (dev_dax_resize returns -EBUSY if dev->driver is set). Caching the size
  at probe time allows fsdev's direct_access path can use it without
  acquiring dax_dev_rwsem (which isn't exported anyway).

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h |  1 +
 drivers/dax/fsdev.c       | 83 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 7a3727d76a68..ee8f3af8387f 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -85,6 +85,7 @@ struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
 	void *virt_addr;
+	u64 cached_size;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index d2f6c0341c24..5a1e504c9281 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -28,6 +28,84 @@
  * - No mmap support - all access is through fs-dax/iomap
  */
 
+static void fsdev_write_dax(void *pmem_addr, struct page *page,
+		unsigned int off, unsigned int len)
+{
+	while (len) {
+		void *mem = kmap_local_page(page);
+		unsigned int chunk = min_t(unsigned int, len, PAGE_SIZE - off);
+
+		memcpy_flushcache(pmem_addr, mem + off, chunk);
+		kunmap_local(mem);
+		len -= chunk;
+		off = 0;
+		page++;
+		pmem_addr += chunk;
+	}
+}
+
+static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+			long nr_pages, enum dax_access_mode mode, void **kaddr,
+			unsigned long *pfn)
+{
+	struct dev_dax *dev_dax = dax_get_private(dax_dev);
+	size_t size = nr_pages << PAGE_SHIFT;
+	size_t offset = pgoff << PAGE_SHIFT;
+	void *virt_addr = dev_dax->virt_addr + offset;
+	phys_addr_t phys;
+	unsigned long local_pfn;
+
+	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
+	if (phys == -1) {
+		dev_dbg(&dev_dax->dev,
+			"pgoff (%#lx) out of range\n", pgoff);
+		return -EFAULT;
+	}
+
+	if (kaddr)
+		*kaddr = virt_addr;
+
+	local_pfn = PHYS_PFN(phys);
+	if (pfn)
+		*pfn = local_pfn;
+
+	/*
+	 * Use cached_size which was computed at probe time. The size cannot
+	 * change while the driver is bound (resize returns -EBUSY).
+	 */
+	return PHYS_PFN(min(size, dev_dax->cached_size - offset));
+}
+
+static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
+			pgoff_t pgoff, size_t nr_pages)
+{
+	void *kaddr;
+
+	WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);
+	__fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
+	fsdev_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);
+	return 0;
+}
+
+static long fsdev_dax_direct_access(struct dax_device *dax_dev,
+		  pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,
+		  void **kaddr, unsigned long *pfn)
+{
+	return __fsdev_dax_direct_access(dax_dev, pgoff, nr_pages, mode,
+					 kaddr, pfn);
+}
+
+static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	return _copy_from_iter_flushcache(addr, bytes, i);
+}
+
+static const struct dax_operations dev_dax_ops = {
+	.direct_access = fsdev_dax_direct_access,
+	.zero_page_range = fsdev_dax_zero_page_range,
+	.recovery_write = fsdev_dax_recovery_write,
+};
 
 static void fsdev_cdev_del(void *cdev)
 {
@@ -168,6 +246,11 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		}
 	}
 
+	/* Cache size now; it cannot change while driver is bound */
+	dev_dax->cached_size = 0;
+	for (i = 0; i < dev_dax->nr_range; i++)
+		dev_dax->cached_size += range_len(&dev_dax->ranges[i].range);
+
 	/*
 	 * FS-DAX compatible mode: Use MEMORY_DEVICE_FS_DAX type and
 	 * do NOT set vmemmap_shift. This leaves folios at order-0,
-- 
2.53.0

