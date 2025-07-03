Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F80291166
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568653; cv=none; b=lWdklXmG8Xir9Zc2oT7PNkX+rtMIaBf34vbXoWSP6nZEJGDB9k8AQN4nOXEpIfYz7E6pRxKemg+wvzLWLpZLscYBfx0O0zSabpELoeXu8sxbcd68dbDu2r1sWqMwmHxUEg1vVy6wvHEYTZBYRggpb556FJzAIsCg6deYZeB88Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568653; c=relaxed/simple;
	bh=Pw428QKL7vU/Q+rAmnYuMV/vyS2i6xzQE57G20v2vFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nfaq8es53bYLRQERFyOa6I6GOXdzN6uQ2bBMMptwjvADvoenxNOHjJ7RnY3DojmmhJyRE3UzvxfHvAYmlX0dUszAMSf20BqcOlpvn/33lTbbR6gDgSxqZSUqktO4obXmyG1LGHdDfoYQsVZdsDTFkYgFHbLriJhYS2ZDw/jG/R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJjSHfQI; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJjSHfQI"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-72c47631b4cso193851a34.1
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568651; x=1752173451; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgKTg4/Nk6wm5J+WL43f3KfjMbT1HMf3Vkuk3EBDHmU=;
        b=hJjSHfQIzxB1rFOwFMln/u6bFwVOnyqb9SuQCYJnZXBdyE77qUIb06XvfVa7DGrF3+
         JJYuWCT4kdy4dCxw8wQ5/pSUu/gKTu7lDxVuHL7IPPfD+ORZw9wdcKpWKI72ER7faQPM
         7J0Sx9w4keDCkWVbwTnuOAKhvvYClsVd8PuXSgp7YXxppaAYhJ6dKxwrAlBdfldpZ03d
         Y1Nl+ofyT3gthJfvYvC5Bx2Ucb7e/7UQRx87LnqTgmA0P5Fv/0eIJuYKykr2TRqY+4Vc
         hYV3EFuDqE3xdwsYS3yLyDRSMC576XyIvtcedgQ6bRKSpxQ0a2xGcRDAELA7CiKlr7QM
         QnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568651; x=1752173451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wgKTg4/Nk6wm5J+WL43f3KfjMbT1HMf3Vkuk3EBDHmU=;
        b=OsO4Zun/3wElVtjkD3u9RKpAFqqI+3GGHrt46wfXg8S7o68I9I1NMMQ6Em2SeBs5D+
         jocgf+gD7S9Qi5IU7XEGnVqKkP0dfbHrnj2Qkec8HIqDJ5MY7wLJAxtOlBw4GOmLly/+
         z/arLbTjr0SxaUPFoqzPan0FTwzzSQZ3cRWa1Pu1selZZ5QSGoI5nLs5AdQDw0itPWK7
         WwY2YMdJRztlnQugYAjeWiF1PVAFcJQwCG3ESHnzZYdaktnqYZ3Vt4+SvV/smaFjpVNQ
         1gscNadWJZXwvKvnjDLTzSn4br+vDtwvlsa/d+0MFi8S/CmBDklT90Hg0cuLjdZ3AQbq
         4TFg==
X-Forwarded-Encrypted: i=1; AJvYcCVKPTcHqsTx178xXWhu6kn7rhi6jsChcbdm5BoBJ+LIx0/IAa53x+FCqeAC2SiQ1zVMbgNpz/Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLyZueYfCdcyoU//d5GhL7Z+VknPlzcIKql+FEimzIWZ/w0N0J
	qVv1oTuS48SauyMoXtAym/h7yjaHOSAXAXRAHgfwLXKTrr6+vrl8bT8L
X-Gm-Gg: ASbGnct+vclvYfq1bcDeLFiclwBbvV2Lz9kL5ycbRdBT9pqBZIhyUHMS87Ve/VqlYtc
	bzncIC9EaMX1q059IYJiIXrVOXs/w8BJmfA5KmLGpTKNxBBJKGTI0aO0870LS0Nb2b07aTHOVxn
	Ym640wgfdICzTCRPw5uOrBKUgFoZ5PfhLlUy/gefXZ8xcj5buXKBwfOeE+l92KTOTQbJhbo7Vs3
	ZTIf0ZPlTtgztPlPLfV2IMXe2zx4QtSuyFaZbat85wGR7ayLgS4txDCpPn+andfXqpJBHAKMBe+
	XbekwDmliUflIdlTqsvfU/KewuX35Psf1x9+iCYg+PP6n9n4rrciZpvhIIYEjOQy34vBm1DUPes
	D5Uu4jJIjz+UyqQ7+ZdDQwLt4
X-Google-Smtp-Source: AGHT+IGNEYE8azkCu6i4tdt/Jh/JzWWu2d955CfMIRLR2kAADDQEL7D+pI5ll8ogxoQ3Xa3+A+d+Cg==
X-Received: by 2002:a05:6830:3c8d:b0:739:fcb4:db17 with SMTP id 46e09a7af769-73b4cb2f25amr6347478a34.15.1751568650976;
        Thu, 03 Jul 2025 11:50:50 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.50.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:50:49 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [RFC V2 04/18] dev_dax_iomap: Add dax_operations for use by fs-dax on devdax
Date: Thu,  3 Jul 2025 13:50:18 -0500
Message-Id: <20250703185032.46568-5-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Notes about this commit:

* These methods are based on pmem_dax_ops from drivers/nvdimm/pmem.c

* dev_dax_direct_access() is returns the hpa, pfn and kva. The kva was
  newly stored as dev_dax->virt_addr by dev_dax_probe().

* The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
  for read/write (dax_iomap_rw())

* dev_dax_recovery_write() and dev_dax_zero_page_range() have not been
  tested yet. I'm looking for suggestions as to how to test those.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/bus.c | 120 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 9d9a4ae7bbc0..61a8d1b3c07a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -7,6 +7,10 @@
 #include <linux/slab.h>
 #include <linux/dax.h>
 #include <linux/io.h>
+#include <linux/backing-dev.h>
+#include <linux/pfn_t.h>
+#include <linux/range.h>
+#include <linux/uio.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -1441,6 +1445,105 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 }
 EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
 
+#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
+
+static void write_dax(void *pmem_addr, struct page *page,
+		unsigned int off, unsigned int len)
+{
+	unsigned int chunk;
+	void *mem;
+
+	while (len) {
+		mem = kmap_local_page(page);
+		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
+		memcpy_flushcache(pmem_addr, mem + off, chunk);
+		kunmap_local(mem);
+		len -= chunk;
+		off = 0;
+		page++;
+		pmem_addr += chunk;
+	}
+}
+
+static long __dev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+			long nr_pages, enum dax_access_mode mode, void **kaddr,
+			pfn_t *pfn)
+{
+	struct dev_dax *dev_dax = dax_get_private(dax_dev);
+	size_t size = nr_pages << PAGE_SHIFT;
+	size_t offset = pgoff << PAGE_SHIFT;
+	void *virt_addr = dev_dax->virt_addr + offset;
+	u64 flags = PFN_DEV|PFN_MAP;
+	phys_addr_t phys;
+	pfn_t local_pfn;
+	size_t dax_size;
+
+	WARN_ON(!dev_dax->virt_addr);
+
+	if (down_read_interruptible(&dax_dev_rwsem))
+		return 0; /* no valid data since we were killed */
+	dax_size = dev_dax_size(dev_dax);
+	up_read(&dax_dev_rwsem);
+
+	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
+
+	if (kaddr)
+		*kaddr = virt_addr;
+
+	local_pfn = phys_to_pfn_t(phys, flags); /* are flags correct? */
+	if (pfn)
+		*pfn = local_pfn;
+
+	/* This the valid size at the specified address */
+	return PHYS_PFN(min_t(size_t, size, dax_size - offset));
+}
+
+static int dev_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
+				    size_t nr_pages)
+{
+	long resid = nr_pages << PAGE_SHIFT;
+	long offset = pgoff << PAGE_SHIFT;
+
+	/* Break into one write per dax region */
+	while (resid > 0) {
+		void *kaddr;
+		pgoff_t poff = offset >> PAGE_SHIFT;
+		long len = __dev_dax_direct_access(dax_dev, poff,
+						   nr_pages, DAX_ACCESS, &kaddr, NULL);
+		len = min_t(long, len, PAGE_SIZE);
+		write_dax(kaddr, ZERO_PAGE(0), offset, len);
+
+		offset += len;
+		resid  -= len;
+	}
+	return 0;
+}
+
+static long dev_dax_direct_access(struct dax_device *dax_dev,
+		pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,
+		void **kaddr, pfn_t *pfn)
+{
+	return __dev_dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
+}
+
+static size_t dev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	size_t off;
+
+	off = offset_in_page(addr);
+
+	return _copy_from_iter_flushcache(addr, bytes, i);
+}
+
+static const struct dax_operations dev_dax_ops = {
+	.direct_access = dev_dax_direct_access,
+	.zero_page_range = dev_dax_zero_page_range,
+	.recovery_write = dev_dax_recovery_write,
+};
+
+#endif /* IS_ENABLED(CONFIG_DEV_DAX_IOMAP) */
+
 static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dax_region *dax_region = data->dax_region;
@@ -1496,11 +1599,18 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 		}
 	}
 
-	/*
-	 * No dax_operations since there is no access to this device outside of
-	 * mmap of the resulting character device.
-	 */
-	dax_dev = alloc_dax(dev_dax, NULL);
+	if (IS_ENABLED(CONFIG_DEV_DAX_IOMAP))
+		/* holder_ops currently populated separately in a slightly
+		 * hacky way
+		 */
+		dax_dev = alloc_dax(dev_dax, &dev_dax_ops);
+	else
+		/*
+		 * No dax_operations since there is no access to this device
+		 * outside of mmap of the resulting character device.
+		 */
+		dax_dev = alloc_dax(dev_dax, NULL);
+
 	if (IS_ERR(dax_dev)) {
 		rc = PTR_ERR(dax_dev);
 		goto err_alloc_dax;
-- 
2.49.0

