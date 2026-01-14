Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6793624A8
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426506; cv=none; b=WX7iEhrsbY1pQvaYS7g6SktRPOd6lhrQzLcJ/HSnoWDSGBDAB6fS8X7EuuKpSuT2JQfW7eQ9Vxj7+ty9BxDyoU0Ow8YqJ/WvUE0/RvkkyUDJsFjLYAfw727ZYz5AGOqYkblUFCpNZgart4ovw3Iw9CHPK7sXoDkTFtkbvcXnDSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426506; c=relaxed/simple;
	bh=VJhZh7W86znk6T4YU4zDAnr6xplKZCmyhBUSPOyJHg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dct/VkFabZgpXy7p9E4DaYjbY+gyvZ2S3iEXgw2t5z+lfwdJG9ICQyr+OhVj/Vf+0n6LQbVXZJJNyJhmcSCt0gg+sw/Su6IWxFSjElhias150ZHgYqzFkGm5gComgzASthoQLykRomtqa0Jq2GxAuzNlFFeloHAXTw39yGUCArQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AF1LGbNn; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AF1LGbNn"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7c78d30649aso187535a34.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426497; x=1769031297; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZsKBgwQfRTYfl5tr8Q6BwcIVeayQIJR9+JPKX7ldDM=;
        b=AF1LGbNnYee0WkACDTJbMQsOGSZL1wfeAn5VBG/2Siorqv2jtSOJTmy+HBJ7zsLCV4
         8CwvTUYQYG5pQci3edl5anSsp4gLxQ1OuR/PJDK41Rf/wib11iAL7oYxJ9rzvSRnopMP
         egd+iP+hxjRC2NS84FFZzFqC4QOrBTlXjsdn1wD0MYFn1OKqwJL29oNRkQaAjbUbYHy0
         PQ+UgaBLrUw7DrX+2CT5VABr5LklRN52oQz7XcDL1R4/2/ewDt8QzmDumKeGQbcJykpA
         IXwdzy9SWGSS/sqhbckbXDVxpGcNP8t53yIrnKw7NPBMPerXDbn2J1c2a32qJRgmOs07
         eqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426497; x=1769031297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZsKBgwQfRTYfl5tr8Q6BwcIVeayQIJR9+JPKX7ldDM=;
        b=aSaIJK9hdwlrygLjOOKcuZyptbjq/NVH7GGz5CO/VwUH1znU/6VI8iTPRTYF/oJ7+X
         /WQitaA/FIl4mIokLDppn7I6/OOI02Qf3NRa3/Xn6KjlEKGSHaOfWQTxJ+coyO5Z/DdT
         x4qreT3hw2QayocbvAUEFnEY3ZA0tUc5CgIxMlP8Y6T0QCWdbL1+hgq9wUOSp87NiA1y
         C3UHpEcS/AzYB/tZqzM0aBlBVp9BaE4ckdQ0+FyXHZJ28v1Gsn94jXWnRqo8vcRoUwYa
         zIhSKOn2u4LyeAq1Ayh/iUOatjpn/XMzmGH1Kns3rkI+x7sBNgYEp+8kURw5XRYkfaT2
         ayoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjksOaJHRznMrSU9X2vpumQur/YuL9BvMDvLF+gEO2lhXsVysN/oO7Xsjq0cD4ukCVKaB6624=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfWOdWtNNdhGJ5DCxqUNczy39MzdMZHVyfVyQHU3//VEwN3qj0
	ep7dZWK7O8SnCWSN0QHB1lfg4HuEkI/9VaALmXwYFZSpdV5puSx7HIDN
X-Gm-Gg: AY/fxX7s+MmIygnZv+O7R7JvwbI8NPk++Pb4OO3Az8IDzzJDOTkPNIdijy611kVyM6k
	lrgWx5uJL16njCMA0gKCouwHQvbxfhcE6mOam84z6hqbu3G7i/Y3lsN3yifmPbmoYyOrRPuKaGx
	1JCYYc6gcB4NyBI35nOnUDcizjuDi/xCFoHtv/c3A68PPISn42Tuuk/f6YlZyZX0P84Bi6OZKD+
	PsWmChs0XJS8agfjCsh/DjBfpq9p+qE34b06tk+CxNuuvwchil3qa9f05QDmtIT86YyQrAETDAJ
	Z5kX7ORISXzkBoHswIa9CAxtFqekNCoWyd7klVCTyBbuDPrb7z79zc8GtDX1DpN1RfXxKQvizSD
	t1ghc+KRKFrvM2M4Uc42h6iBA4Sy+bx5vOCRqRm8WxNqwx/FLxCSq9ATVfgQ+lsFpVnDG5VJN15
	Fr/PdszyFno0L49TYcrxXLWstyM90dgVHRS2QFJVPC9U4iO9m/1ht7fy8=
X-Received: by 2002:a05:6830:4124:b0:7cf:d18e:706e with SMTP id 46e09a7af769-7cfd18e7074mr1365370a34.5.1768426497284;
        Wed, 14 Jan 2026 13:34:57 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfd447151csm542661a34.14.2026.01.14.13.34.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:34:56 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V4 05/19] dax: Add dax_operations for use by fs-dax on fsdev dax
Date: Wed, 14 Jan 2026 15:31:52 -0600
Message-ID: <20260114213209.29453-6-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114213209.29453-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114213209.29453-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

fsdev: Add dax_operations for use by famfs

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
 drivers/dax/fsdev.c       | 80 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index f3cf0a664f1b..164dd5b9d933 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -86,6 +86,7 @@ struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
 	void *virt_addr;
+	u64 cached_size;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 72f78f606e06..f58c88de7a4d 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -28,6 +28,81 @@
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
+	WARN_ON(!dev_dax->virt_addr);
+
+	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
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
@@ -163,6 +238,11 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
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
2.52.0

