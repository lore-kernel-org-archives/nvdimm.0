Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057FC36C581
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426581; cv=none; b=QkTZobNJomK5eURVuiEn6tCZHtIpAlNxXp/XA0jQcHpoIcjqI5s8YUfYWZwu80Xy8ehG9AK2uDdPClEkUqxE3q2NO0vzBZPdvU5cFHxw4HObi7ovo/lTptoEEnGikCV3j/uXsaKg+yOZQw2DOXFZ7hJVZRT/Lk2EA8w7pbLbBnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426581; c=relaxed/simple;
	bh=RJs5dBBAWuOxqEEVBB1HCtYboJ+JS3oCwl7NKWs84IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQHt8N3NgD2TiOp0AJW5A+96BnFmdRlWd79uH6R2v8TeQ0syVvEldy9jb/6gwNXRFPmhVnYlIhRbsSrQRi9Eoo+dbCelX8TgjL1I0foBBC9z5jr9j/RhrQuexzKrG/H+qKZ7i3ACdf1IKuKusMtUcWjtZA9OInV//6LyJJJFwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BZ+P3KaJ; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZ+P3KaJ"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfd53a8c31so112887a34.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426562; x=1769031362; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHr6a06dT/VqhW8Rq+1vjbEURwj0h9cjtIZdXyvuQJA=;
        b=BZ+P3KaJAtfvoxyTkQOhtYrpTMLt5CTUWdkTW/u0Nwjj9MljZEl8x9Fpxgpm6mdN9v
         eGlGWHGjjU8rh+T0yPDZSEimLgf43zBy5pJsNiohi830RDo2Gt0IreaeAnsfelvemSsK
         cvqt8OzNJ8sW/fAGvOvgmgdXwq5x38s1o5EUSsA/T8Bg1UIdqWvvpeF3PZ5nkLsfNr5I
         8NDVNuJrpZ7eTGIbf/4kmJXoNiXNYTdd6TlFNHiJjl8g6jpHjeEp7GGKLqlGvwEr4NDL
         yNMEY34MnJEII83mIPft66c3x6+wxZlESh9QAqZvJB91RyZ3yc23VMkCoifQCz8rlaMJ
         3A2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426562; x=1769031362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BHr6a06dT/VqhW8Rq+1vjbEURwj0h9cjtIZdXyvuQJA=;
        b=PXtp1urSSmHNmNtKfDWwoBJb1RuubdgK2/jF3eidrbDYgNZ7N2d3kw4A56E9Qluj/o
         4A0wdmjVIWMdbeEMXZlYAqVHhArHTdZ+3F5rN8N5yyq0vocxArZbql9kATQxDJibL39b
         5DGi1htkG6BVrUPTtdcCgNhTY2WXeBFTYGIlk1W1YQY+z/DhpLeRxFdX2rlbBGzHiEZT
         1XkmAWDEYk7NVdDzOXAW9D6NIny6kL8WqnqZBxwTxTwF1gMOAoaTvgWCKH+2Uam/GNZV
         Jlojfklb78Zsy/6F74fafR5hNdwwKOWtplhkCGaiu02f7aqhc/A51B/3Jr3Rr5nAoiMd
         Gfmw==
X-Forwarded-Encrypted: i=1; AJvYcCUNCVxmw9jf0l8qjRmJoiBnsVeGq87O+QW51LPo0RDGUzcQzhdfRBajHyhMiIstyU162SMgWWo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzE7QRGTrJ6/YvqpKixpBGf67DN4rNBe+fQQcryHSGhGjqD9Nmm
	iD0LSmo4QpImhJchFuWJLlPrMmxRVHsZSs9UmbbCBej0kJKKdCXyozgV
X-Gm-Gg: AY/fxX6VdBIPGO89Z7NZqRU/T9rbrrBZ2uVit+q11wyDZED6ZUw9cqnX8e2XxRYtVSw
	zmtrPsbuF154Dpi+5h8DiGhabIc0R5LDGpP+aKyDJdyX2D1OVpzPzk/hz1hCpHD3Nakmk0Hn9h3
	ipwVhOImPwQTxKI/U00nGIBSfKbLpQiKAyilgCLIRJdwQ/UXR4aaWxHy4fxj2c1qotaZQiBax3K
	drNns/nYnAxE/WvaMpyTz5dGsoOTA4nCjaVYVdDnw79Kt/pJ/al2xM88Qz3EFtJlFdc7LG7GyfX
	SfaLFMRcqe6C/hp0kl26PGdXeT9Y7Kxr6O+gTQCu3J/nqz4sgml8hJ29kH5sjJTLAcv4+MLJf8Y
	KS+gi0VFTnLflP0MzuEOnd/vkcbNmVoAz6u1KMnubePCdKLprb1Qnlwex6irYlHp1JCtwZDfL1c
	ReH9vkWj+x4+M9B4rwcZe6mNlff9teD0WbTQ5O/axEtNSY
X-Received: by 2002:a05:6830:3c06:b0:7c7:7f85:d19 with SMTP id 46e09a7af769-7cfd46192a9mr560960a34.8.1768426562527;
        Wed, 14 Jan 2026 13:36:02 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce4781c43asm18703055a34.7.2026.01.14.13.36.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:36:02 -0800 (PST)
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
Subject: [PATCH V4 07/19] dax: Add fs_dax_get() func to prepare dax for fs-dax usage
Date: Wed, 14 Jan 2026 15:31:54 -0600
Message-ID: <20260114213209.29453-8-john@groves.net>
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

The fs_dax_get() function should be called by fs-dax file systems after
opening a fsdev dax device. This adds holder_operations, which provides
a memory failure callback path and effects exclusivity between callers
of fs_dax_get().

fs_dax_get() is specific to fsdev_dax, so it checks the driver type
(which required touching bus.[ch]). fs_dax_get() fails if fsdev_dax is
not bound to the memory.

This function serves the same role as fs_dax_get_by_bdev(), which dax
file systems call after opening the pmem block device.

This can't be located in fsdev.c because struct dax_device is opaque
there.

This will be called by fs/fuse/famfs.c in a subsequent commit.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/bus.c   |  2 --
 drivers/dax/bus.h   |  2 ++
 drivers/dax/super.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/dax.h | 20 ++++++++++------
 4 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index e79daf825b52..01402d5103ef 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -39,8 +39,6 @@ static int dax_bus_uevent(const struct device *dev, struct kobj_uevent_env *env)
 	return add_uevent_var(env, "MODALIAS=" DAX_DEVICE_MODALIAS_FMT, 0);
 }
 
-#define to_dax_drv(__drv)	container_of_const(__drv, struct dax_device_driver, drv)
-
 static struct dax_id *__dax_match_id(const struct dax_device_driver *dax_drv,
 		const char *dev_name)
 {
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 880bdf7e72d7..dc6f112ac4a4 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -42,6 +42,8 @@ struct dax_device_driver {
 	void (*remove)(struct dev_dax *dev);
 };
 
+#define to_dax_drv(__drv) container_of_const(__drv, struct dax_device_driver, drv)
+
 int __dax_driver_register(struct dax_device_driver *dax_drv,
 		struct module *module, const char *mod_name);
 #define dax_driver_register(driver) \
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ba0b4cd18a77..00c330ef437c 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/cacheinfo.h>
 #include "dax-private.h"
+#include "bus.h"
 
 /**
  * struct dax_device - anchor object for dax services
@@ -111,6 +112,10 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off,
 }
 EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
 
+#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
+
+#if IS_ENABLED(CONFIG_FS_DAX)
+
 void fs_put_dax(struct dax_device *dax_dev, void *holder)
 {
 	if (dax_dev && holder &&
@@ -119,7 +124,58 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
 	put_dax(dax_dev);
 }
 EXPORT_SYMBOL_GPL(fs_put_dax);
-#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
+
+/**
+ * fs_dax_get() - get ownership of a devdax via holder/holder_ops
+ *
+ * fs-dax file systems call this function to prepare to use a devdax device for
+ * fsdax. This is like fs_dax_get_by_bdev(), but the caller already has struct
+ * dev_dax (and there is no bdev). The holder makes this exclusive.
+ *
+ * @dax_dev: dev to be prepared for fs-dax usage
+ * @holder: filesystem or mapped device inside the dax_device
+ * @hops: operations for the inner holder
+ *
+ * Returns: 0 on success, <0 on failure
+ */
+int fs_dax_get(struct dax_device *dax_dev, void *holder,
+	const struct dax_holder_operations *hops)
+{
+	struct dev_dax *dev_dax;
+	struct dax_device_driver *dax_drv;
+	int id;
+
+	id = dax_read_lock();
+	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode)) {
+		dax_read_unlock(id);
+		return -ENODEV;
+	}
+	dax_read_unlock(id);
+
+	/* Verify the device is bound to fsdev_dax driver */
+	dev_dax = dax_get_private(dax_dev);
+	if (!dev_dax || !dev_dax->dev.driver) {
+		iput(&dax_dev->inode);
+		return -ENODEV;
+	}
+
+	dax_drv = to_dax_drv(dev_dax->dev.driver);
+	if (dax_drv->type != DAXDRV_FSDEV_TYPE) {
+		iput(&dax_dev->inode);
+		return -EOPNOTSUPP;
+	}
+
+	if (cmpxchg(&dax_dev->holder_data, NULL, holder)) {
+		iput(&dax_dev->inode);
+		return -EBUSY;
+	}
+
+	dax_dev->holder_ops = hops;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fs_dax_get);
+#endif /* CONFIG_FS_DAX */
 
 enum dax_device_flags {
 	/* !alive + rcu grace period == no new operations / mappings */
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5aaaca135737..6897c5736543 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -52,9 +52,6 @@ struct dax_holder_operations {
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 
-#if IS_ENABLED(CONFIG_DEV_DAX_FS)
-struct dax_device *inode_dax(struct inode *inode);
-#endif
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
@@ -134,7 +131,6 @@ int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
 void dax_remove_host(struct gendisk *disk);
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off,
 		void *holder, const struct dax_holder_operations *ops);
-void fs_put_dax(struct dax_device *dax_dev, void *holder);
 #else
 static inline int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
 {
@@ -149,12 +145,13 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev,
 {
 	return NULL;
 }
-static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
-{
-}
 #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
 #if IS_ENABLED(CONFIG_FS_DAX)
+void fs_put_dax(struct dax_device *dax_dev, void *holder);
+int fs_dax_get(struct dax_device *dax_dev, void *holder,
+	       const struct dax_holder_operations *hops);
+struct dax_device *inode_dax(struct inode *inode);
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
 int dax_folio_reset_order(struct folio *folio);
@@ -168,6 +165,15 @@ dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
 void dax_unlock_mapping_entry(struct address_space *mapping,
 		unsigned long index, dax_entry_t cookie);
 #else
+static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
+{
+}
+
+static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,
+			     const struct dax_holder_operations *hops)
+{
+	return -EOPNOTSUPP;
+}
 static inline struct page *dax_layout_busy_page(struct address_space *mapping)
 {
 	return NULL;
-- 
2.52.0

