Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8232F2730
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568645; cv=none; b=iCNsISa8dRhXj83/V90/GswsXj40LZ7vJttStEjgNHYD3joq77sDh3Py1P2JRLNyGjqEGO2h8lrX71+hM2t/fTTdqIzw2E0d5Gn6K9FD6xXVe8unFX8liWnr8B5zyM22beentkn5oNbfwonnPJWjcaL2YmbUDCNBgm5ujfQxvuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568645; c=relaxed/simple;
	bh=gsIhmfFsaL+5EF4z3f0VUnIpcZS1jFVcEdA2B4rIq38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cOuH7qb0jGdi+0nakU0bUss/0M1a/4oTHU/L17yS9DZmAzyNNoHPNoTzVrVEgKRf4d3BoXjfQYaKBNSTLHWZXL6lcXULIWTAkDvtAopMFeKwJYZ8dGJyflW6z/W5m2dclrhZWAinKISl+q8WSfr1ig52RcvHBT8Va1KsEhZzyJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ca4Ogmvn; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ca4Ogmvn"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2e9071e3706so195597fac.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568643; x=1752173443; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37keBjnXcy0vWAMphYKQfFgDhN7R9v7a8FhgLd8vRyw=;
        b=ca4OgmvnYmgzGvvUiSMglE7rQiobI9FWRZoMvckwHFtWUCCJOTh7DbIVlDS9Miv3XF
         nrnCNtjSSKfnFBlJaQeVDnRIdSkPGYecOpA3hP6xyExpW2qouqf3zhJ0l5roCw3UhGLC
         H8OJ30OeZnzWH2+9ohKZoD5+2qNECzKFnOWYgAjSCb07ePV/vYcbC85LHQvXvRzWYbIZ
         XSvVlGDkE2WV7x8s7DI6lqiTm61oEqFC4SlYw6k+R0VeZRlx9+ZQtJDdIwbDwlb+dthe
         bvXum1/YDGyosBvMBVN8pPQ9O9MQgcRiYvp22JLNiUuj/iRgoVslVbYbfhut8LikzhSH
         HJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568643; x=1752173443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=37keBjnXcy0vWAMphYKQfFgDhN7R9v7a8FhgLd8vRyw=;
        b=EX3nuAXIZM7aDlK8hlzG5rEIjdNUC+hCEoDzncdptXvGzkWetcsvrplzrZRk7lmKh9
         dUN/cZJ73KEUQqkdiGTEWqZzhyKDOqcT/FAt9crZc0X+0hjFPaPDi6tIz/qhlskLmnIj
         tP2xXVqQmaTMnGuCfhsih4ND5dqvYduZezvKg2W1t2aNYc9BBaylzl0gCthjde96uHYU
         OQP1yMtirOZ56S3eqvJYfIVs+nA1A0GVt/bScHDTTRY2SEGMnSUutv94F6YLh+8MYu3z
         xo8yCo+hTNSuaW8yrmKCu3xjDiGp6laVguaNcKgHLtHoXjCZ5NkArIxMX0/TCPGXKEaR
         Tv7g==
X-Forwarded-Encrypted: i=1; AJvYcCVDNp0c4RwN8fSB6D/tguxK8E12UwkxCbO6dzOP937Oj9KgAIu8MuGatVnneTdNmfARS0cQ2mY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9rnrOKDMyYHtylR9Ga/ExUa23xn9BprsdXQaS2e5zCx2wbig5
	m7B9WaC6Y+QGtmHA/oukXvhcswYibRuh/h8BWs8h9vzsbErFldT8Qxz7
X-Gm-Gg: ASbGncs/qAd7ok0lvP+pxzecuzHNJ1Bd+rUQyUyee+qXwE4CXBsZsZj0OTPwJ1fhnWL
	A+vgcjP9rTZs6pG9XSFeUN9YzEnJeIqFFwxYkj/aLv+JAMw86tigP3P41U49VhNM04d/6WGItV6
	m3OWEBAFEjZyNu9SW0pdFafAq9AmcFEWYzZvN9sSqq9a5IU9n+YPHBS52KnicmWBsAaT1UJ5zFU
	Sq3j5Mj213uVHAh3JauBOBArwdorInXmMzF22VNkHb89uWPMawqwpWpU7dV7rh1U2ET8D9tHnoh
	mh55WHOc73I8NQ42FPlK2+H21slfd/z9MB+FQLowZ/4CQtrndFyvm955AiBh7S9r5ky21hEQvZz
	zXyY0PddE3s/ErUDGNMaIxuf0
X-Google-Smtp-Source: AGHT+IGGO26vNj25TCeR8caAFdVMd/7bQ1PotJARXetJW6yAE8gTTCz/lmho2fjx9+U6Hq3mnqrM6w==
X-Received: by 2002:a05:6871:8416:b0:2f7:64ff:aae2 with SMTP id 586e51a60fabf-2f764ffaf42mr2834618fac.36.1751568642961;
        Thu, 03 Jul 2025 11:50:42 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.50.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:50:42 -0700 (PDT)
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
Subject: [RFC V2 02/18] dev_dax_iomap: Add fs_dax_get() func to prepare dax for fs-dax usage
Date: Thu,  3 Jul 2025 13:50:16 -0500
Message-Id: <20250703185032.46568-3-john@groves.net>
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

