Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AB013635E
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199249; cv=none; b=bYRuGULjwgSxKCPJm1xurZIRm0351Z+PWwEl2F6eHok1Ww+4pLpcZiZ8egBQQejulZJhsxv70OKZ11Bdpx/zODSihWjcIK5fcxsRi7qZU97B7lecdHpKxuIR4Q0H6q0jGplPK+tvYPJa6LAY6sXv0DteTPad6Cnwp69y6d6SL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199249; c=relaxed/simple;
	bh=Pw428QKL7vU/Q+rAmnYuMV/vyS2i6xzQE57G20v2vFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rfWOGq6PsLkQD0R+nA5dDOeSPZ0kYULVQd6e9Bcr/61jI3ahBksKEKH7UB3KpKJfimw1vUlmw+U8jjCtNhmSGSWv+6m1b4sIe5RbQNU6cTzsWl6KUcvwScQAX4qkUIt+AME84erJwcJASFYLO2kgnsHYfAztp9wSi9ZcSDrPVqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gI4m3nvH; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gI4m3nvH"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7272f9b4132so3007641a34.0
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199247; x=1745804047; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgKTg4/Nk6wm5J+WL43f3KfjMbT1HMf3Vkuk3EBDHmU=;
        b=gI4m3nvH+4vTQ4cqBXLM1cosYeqhydaAbL6g/X3OaeGB03aXmZWxFGkipXyuvzseZj
         raZGIMtkdA8qzYZFnSC2vVWAZ6SEbeawK9+WL1DmFcvJW5+xFZnTCN3ZmOeDbla6/iV3
         iEp0h8vI24SJ48JxFvOatQgSR8KuFWRv+sBiUYQaoMpTVcShNnpYZ92IUH7EHkiv185H
         qqVGD7TR6vWOqcleEZ4/oyw9qIKM3F+ILMyqZH64mxSG9/8BzkxXwXBd4JQeoqjRADEa
         6o8Yj2FaCJIKTgNXCmWmTh0SLqfCzhOpcl9jYXpKwlAvisYvvT+ckimxx19IshNTTflu
         Xz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199247; x=1745804047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wgKTg4/Nk6wm5J+WL43f3KfjMbT1HMf3Vkuk3EBDHmU=;
        b=lDYxPfRqcIgXlqFd9lJ7l8QF2+z7X7WVMQDx2IxxF32FFoVZ2R9puUomixGvz+n17e
         0bG2EB3H6OWKsF4alTDgiCrnrxm1zcGH4JZkiZt8lGtWunAx1M7hGxlQ8qgQe2dRu3Xc
         xpNv/8t1VTdspv0D+ZCcjIG2xraK84pEBtVzxE1iEAj3d5mfvcXslN7GgHqArKtGdlFQ
         2HqdJ9KyQ6/VIB8M58cDWO5P/bzjicE8uDzx1TxPfWgY6f+cXgdwzB1pezmJhxMbdo2V
         doBCnakBOLMb0SHbstoU512LrVTrXASLD3P2HzE1RqPfDNyCdoqKBa6otPWsbW2pk+5J
         TW9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxYMqNRhVWb+i9KsWk3SJ3w16/KASnQoK8QaY9azZD1QxenYS/dn0w7Rh4kFSQAPLLTdXP+Wk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywqdh8Od6cx0uMKZN9vEX8kAm3dmwUH7GEyKYESTm50LZpfg/2l
	0/bI3bmygXzLSAYuLNxSTALqTnZjwy/IpprpxgXq3UEyycJnhPzEuaQSVc7Gpqk=
X-Gm-Gg: ASbGncs7GbQ/zsIPO+GjcTbi5F/3LGbXqa1hwSFi7wqgBtmvkOAr2Wh58kczLMNLg0c
	xv8NYbZjMLJlKvIYzA1b7pypXv0iq/UNxpqzn7AOV9CRtt+Ikdrx7KZfIgrfT838IBFEEcRBmQ+
	EpCUw1Sn1Rce4XfuRlfwuNLqIgpaGDGKsT3hLYGCQYmWYLuhgJxF65HbkWPuU93uLZqmbUqD8BM
	zU8a0AF0sWVZq5lbdywUfGpw3Zvq1G529L6f/yfreEXsz/yWhf6EX9lkQDGuqzzZaWJpcRHqelW
	2aGXveyCD/2e+dk5ox0vaqYZlaW8FUoDar6T0cuRAmW1rdiF9Jg+UCYfzLv1cZxo++LMCg==
X-Google-Smtp-Source: AGHT+IEsMa4dpZJjBid8/pLKvlf+SmLNSge/Fka+TntF/FXSs3PgaAfQ5jAVyn8KSUpKFBCYf59yRg==
X-Received: by 2002:a05:6830:a92:b0:72b:8974:e3db with SMTP id 46e09a7af769-7300634d735mr6694059a34.25.1745199247110;
        Sun, 20 Apr 2025 18:34:07 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:06 -0700 (PDT)
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
	Luis Henriques <luis@igalia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Vorel <pvorel@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
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
Subject: [RFC PATCH 04/19] dev_dax_iomap: Add dax_operations for use by fs-dax on devdax
Date: Sun, 20 Apr 2025 20:33:31 -0500
Message-Id: <20250421013346.32530-5-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
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

