Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1142DFA2F
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883842; cv=none; b=l0qO0uPrNfb6/8WLSdKRdCdwbrKbo2jHGokgE8u4KmAVfODEdUshp685EMl8/7AF0QISzmVKRYvMiFldFBrBF740u50gGWI1KAlYQkNb4UV5mL4ukqa/vUr0o8JndEQ+vvLruUrX9r3kFGrR3JNg2twevUuWAyi3zfRK6gDcCck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883842; c=relaxed/simple;
	bh=mu7F6EbKH3FQO2cw+iEfmXw0RIlWeJ7w3ZCalUplYig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjimHQlIO93VmhJLvlifcvCJ3PNZYW0wSwnpErceH3LgZ5IDEhbs/Ah2sfcK9U/CXHcZsEtzH5hgeoT0KvLQvhGG6aWn6z+Slqo52U69f+fc2zeqluKisEcHggQmzpD2jxRyU3tTjv0F9qk8xOSOq8mviCHYWvjzmzCzhR4iapI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53E7D1B72E8;
	Thu, 19 Mar 2026 01:30:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf09.hostedemail.com (Postfix) with ESMTPA id EE64E2002A;
	Thu, 19 Mar 2026 01:30:23 +0000 (UTC)
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
Subject: [PATCH V8 7/8] dax: Add fs_dax_get() func to prepare dax for fs-dax usage
Date: Wed, 18 Mar 2026 20:30:22 -0500
Message-ID: <20260319013022.4531-1-john@groves.net>
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
X-Rspamd-Queue-Id: EE64E2002A
X-Stat-Signature: gigd84f1a8scdd4pjso1om9e5abp3egz
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18W7ZaX2fgubPZ7Q2KPHmP9OrS/mINysaU=
X-HE-Tag: 1773883823-871223
X-HE-Meta: U2FsdGVkX19W1sakYRyevFB0WDJ857L+jtQD1a7ycQIGNV3ki62iK9SuRsfk/96KSoJ+U8xsPYGumJkQ+y+6LYcun+5u/nM1/AUdQqonakPdkJNYYoPr5nlew62r92JjU4mGXj9ka3hLCAzHu5N1X8HLmTIjMXknTgCuEiMDfHoMllNVjpJfg7SyPcJoEk5crffZTqyjwK63Swyuz0aPuk3wqMVnyNP2OlH83joyGT+O4jczRZ+wfDPfVZU2Cfqm93QLzcCNBTIXlyCZ7tH0t/0ombLUIWeO3QDBVt2fktG2VhmLS9q4urfDSMz7LLDCBRCx6kV6pC0=

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
 drivers/dax/super.c | 66 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/dax.h | 16 ++++++++---
 4 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 562e2b06f61a..8a8710a8234e 100644
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
index ba0b4cd18a77..d4ab60c406bf 100644
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
@@ -119,7 +124,66 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
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
+	if (!dev_dax) {
+		iput(&dax_dev->inode);
+		return -ENODEV;
+	}
+
+	device_lock(&dev_dax->dev);
+	if (!dev_dax->dev.driver) {
+		device_unlock(&dev_dax->dev);
+		iput(&dax_dev->inode);
+		return -ENODEV;
+	}
+	dax_drv = to_dax_drv(dev_dax->dev.driver);
+	if (dax_drv->type != DAXDRV_FSDEV_TYPE) {
+		device_unlock(&dev_dax->dev);
+		iput(&dax_dev->inode);
+		return -EOPNOTSUPP;
+	}
+	device_unlock(&dev_dax->dev);
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
index 8d469a23c485..f14fa2147175 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -131,7 +131,6 @@ int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
 void dax_remove_host(struct gendisk *disk);
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off,
 		void *holder, const struct dax_holder_operations *ops);
-void fs_put_dax(struct dax_device *dax_dev, void *holder);
 #else
 static inline int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
 {
@@ -146,12 +145,12 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev,
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
 struct dax_device *inode_dax(struct inode *inode);
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
@@ -166,6 +165,15 @@ dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
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
2.53.0

