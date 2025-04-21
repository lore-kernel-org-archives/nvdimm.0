Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172FB137C37
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199243; cv=none; b=mBuTPrs6r8PzNaStk6cojtmffHAWJdABlegyrXs14EQgOMQQuJgtJ3FVeSdSz1Zyas5xmyaMr9Vh/l2KYPfou3N7IRy66jTrEIP32FtBMBXw1Wp+lw1ZyxWltXqKpA2gZhBlF/QshLC2lSvqacfflzHjkFrk2zL41anZwDwX+nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199243; c=relaxed/simple;
	bh=gsIhmfFsaL+5EF4z3f0VUnIpcZS1jFVcEdA2B4rIq38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gtt4MVs4XLeihE42OYw3kSb5k/HEU+klzj0Qg21ld26WC2PO5j8aS+wnZilpiQyxltNYPi5FGpwtF/5cyeJoMJXeyqhA4lNCoABfktCEflmI+chI1gy1CUicpkF2yOsqnO/iqskd1LPQat4j+Ci40yXo9oF3DsMvF0EOUTcobbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzY6LW7h; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzY6LW7h"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-72bceb93f2fso2477809a34.0
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199241; x=1745804041; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37keBjnXcy0vWAMphYKQfFgDhN7R9v7a8FhgLd8vRyw=;
        b=YzY6LW7h7grv8Gvfk5sqGdWpLd41z3pyIlUbryEDVHzRSZkV2UQfzVUGa3w0D/sw8e
         B7heucSHpyfRvP4Puogj0xktYEBMqIaeG2KpV/d5t5d5uHRJoNgySoL8PqPLojVvvuZ/
         D55VksJTtbNrXEXtSNYTxWuB8u/5Xk1U9+ucEFfgr4rqi4jCiD6ofWMqLTJ/eWHQITrM
         oU/lgghZbiSLPHhmmceUOmmh2X/+rmoCYFqcGynUHORNw2vxDIfLNWLZ9STZ011jPHRc
         DsfuAagK8FjOgJU6gya1pHTLmHy2RkDp6sRnlK2hrO0JCF4t6fKQ9/IcI0a+4HKIC5Mp
         pNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199241; x=1745804041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=37keBjnXcy0vWAMphYKQfFgDhN7R9v7a8FhgLd8vRyw=;
        b=GbWnGYnEpT2zNGnkBbuiPluqhF/ZATae9w12mWDVKEE7kz2Z3I5vamVar4Z/8lmQSQ
         vcb+kl7fgfQPJKygu/8SrXXofp6NzlzrN52WihxShOjWuJQFZGhHvxcFUCrLib6RL0oz
         YgAFciG2cal4IxYYXkIunbGnp3Rnx+7HqXSa8lZVMv76fAe5ETc3DoBfRIxUSM7NwfpC
         3CdLmWgH9reedOHEVbZyEeGdmHzNc7kwNdIqGqy/e4LQjDGnEuBTswmejelm8mZ94A/N
         oS/9OPMe4lP+/BewAKM+4gdXz9s+fqaqiWLVVFRiZfvp/HRoKJGGYpeqXlcn5AlLS8/m
         KzEw==
X-Forwarded-Encrypted: i=1; AJvYcCV5Awgefx3IQvAa15JK1nfO1o1TxDSJTKBepTxfvpSqWGtbnSeCBCZYYWvS+UDCxYd881zFKMM=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywbp4AOlW5fUg4vriLkqdGW4AP5JP17wzT6N0vo/+optY+SMPaL
	nLLSGGqr62FoxHsFGWUzg91FZpDIEjhAufEfz+hW3c12iioa5LFs
X-Gm-Gg: ASbGncsZWhNZW9m05vJT5IKSomwHrNKMzgdqO559oGb3KHX89xspqPwQLqhNDqBGvXf
	vFjtqlZ/DELo//T1OUETt4RB8B0zCt9GmEaaf0UWgKVbjeQTkkiE7jF5RK3u1/5AIJWlBEOP9Uz
	cbnqHGERPcIHHnSn+TG3/8BniPsrK3Q7CtF06J3bxPN0XsPSMNtMkESr/4Q3aCC4ec4+PHtmclf
	2WQ3yKd54Kow2RSo04EvmOMSuvV0tFQLRwrHTGioyxQEyEodQZoM6FX+zfJJtD8T9VPzmIVVwWw
	dCcOXiMXdaq8ihnU+hVZR2Q8i1DlAIpffsf2HE20TsB0QMjVk2o6ve6bvQglCDXs3IRwPA==
X-Google-Smtp-Source: AGHT+IGp8RZLlzeUTFl1h5mg3H6My52ABBiCe3Ryq979SMBCBftURNPp06AGz5RNSl+DLM/21GFUdA==
X-Received: by 2002:a05:6830:630b:b0:72a:1222:9e8a with SMTP id 46e09a7af769-7300606460dmr5662821a34.14.1745199241117;
        Sun, 20 Apr 2025 18:34:01 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.33.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:00 -0700 (PDT)
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
Subject: [RFC PATCH 02/19] dev_dax_iomap: Add fs_dax_get() func to prepare dax for fs-dax usage
Date: Sun, 20 Apr 2025 20:33:29 -0500
Message-Id: <20250421013346.32530-3-john@groves.net>
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

This function should be called by fs-dax file systems after opening the
devdax device. This adds holder_operations, which effects exclusivity
between callers of fs_dax_get().

This function serves the same role as fs_dax_get_by_bdev(), which dax
file systems call after opening the pmem block device.

This also adds the CONFIG_DEV_DAX_IOMAP Kconfig parameter

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/Kconfig |  6 ++++++
 drivers/dax/super.c | 30 ++++++++++++++++++++++++++++++
 include/linux/dax.h |  5 +++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index d656e4c0eb84..ad19fa966b8b 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -78,4 +78,10 @@ config DEV_DAX_KMEM
 
 	  Say N if unsure.
 
+config DEV_DAX_IOMAP
+       depends on DEV_DAX && DAX
+       def_bool y
+       help
+         Support iomap mapping of devdax devices (for FS-DAX file
+         systems that reside on character /dev/dax devices)
 endif
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e16d1d40d773..48bab9b5f341 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -122,6 +122,36 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
 EXPORT_SYMBOL_GPL(fs_put_dax);
 #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
+#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
+/**
+ * fs_dax_get()
+ *
+ * fs-dax file systems call this function to prepare to use a devdax device for
+ * fsdax. This is like fs_dax_get_by_bdev(), but the caller already has struct
+ * dev_dax (and there  * is no bdev). The holder makes this exclusive.
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
+	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))
+		return -ENODEV;
+
+	if (cmpxchg(&dax_dev->holder_data, NULL, holder))
+		return -EBUSY;
+
+	dax_dev->holder_ops = hops;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fs_dax_get);
+#endif /* DEV_DAX_IOMAP */
+
 enum dax_device_flags {
 	/* !alive + rcu grace period == no new operations / mappings */
 	DAXDEV_ALIVE,
diff --git a/include/linux/dax.h b/include/linux/dax.h
index df41a0017b31..86bf5922f1b0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -51,6 +51,11 @@ struct dax_holder_operations {
 
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
+
+#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
+int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
+struct dax_device *inode_dax(struct inode *inode);
+#endif
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
-- 
2.49.0

