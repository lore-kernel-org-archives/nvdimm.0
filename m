Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41CD3B8D5F
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800040; cv=none; b=OKBEILSn5WJ/Y1SZ/hvJt/gggzt4K+THcDseVqb2A2COvho+Envqf+WbPLbAcQnuRhKpxGw05ENPi20jinOX5n44GeRZ8r/GYTtsz5Unk+kxqtMRT0kfF+sIkQB87Z/M9+b/ThjoFLGLTtQDOC9P8hxs1Qt31M13Op088fUzUyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800040; c=relaxed/simple;
	bh=Z9XPB5cChIo/t/9LU2WCPFfPnMA+oTk5cMf0x2oZ3bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMPFfovgymNrXwmcyTKxSU1NUU7tLGnTuKwnFGxxx/E4Lf0NLMI7JRqrJSfA58rgBkxBQVBT/ZGcHRVrA04j7xBDff/E5W4/gZEAYpVlpqMR+J32tiaj+fl7PvZKAfkjHGRSU5DqDKW0j5Re84WX10AHXgMW3vuN+jKKLr6PSXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bVB9nglF; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVB9nglF"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-450c65f3510so1426910b6e.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800036; x=1768404836; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OlFXJUauQcVO7MpBSFt3XLVu48darYU11J/SZXzaKDg=;
        b=bVB9nglFOdI6ewsKR1PRcIDH/rHSyHLL52IAqPTjqHbUx/imPMQs12CpTe1gZaK0XI
         7B/JV1MVX1g5L0+0zy0Wly8T50fA+GJvk2wKsRfVtGPbfJVVMAGymtet0UtJ0A5X8l7K
         0S0KfI9Voct2HZkIE9MmRlsjKQMcNhvFLLA/NI08fCHomQ4x8/xERCTnbLE/zqP2EhnU
         nVXGzgkivPOpB3apCcf0wSiHCBBrh36jU+LhFje/OIQoSeS099G/lUpRw8iVrXQlQ98+
         xyEL46SvXCagc1td7OHZj0VkkLm+2j+I1TqAtx//MuwCZskVXSTwhbOlEcZLwH6zz8ZQ
         Tzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800036; x=1768404836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OlFXJUauQcVO7MpBSFt3XLVu48darYU11J/SZXzaKDg=;
        b=QJyvavzgY2y7p9pMW2BRQT/HuE98x4V0V5IIo6yXGfZ7m7ojCDaE1e7fLEX8CquRJv
         dN6+GKKBXumUsNa+myTQtmBYrBvSOgpM9TJE9DMeJsu1L5mOgRT90kfEeqo7TPEwKFL4
         +J7RTZXGSaOHd1Af9IL+MhpXyu6LrTUfn+6PTkBgKFFYh2kM1YybCact4X4lyii3HQbO
         jEKbDETFtbCYQrhQJLXXWka09qHr9abh8Kp8hoiaV5Tc9AU1iLpzpaBPggpuNL1srFpw
         L6dQKPJ/EhOOmYEUA8yADg2TPvMCmr8ZSNgMKn8niwr1YS2cuJrffTLAqSsMFk2m4vRz
         qheQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8aln9sWUigSp09Afy/BsyT3KFzM2/O/t/85Wgqw/xmOPA2rR4ru/KN3WX4Zzus93gCVXHXvE=@lists.linux.dev
X-Gm-Message-State: AOJu0YywNG7U+8/HLJy96ksfnW5hMWyUoNvX+uTn7jdBbznq+q/FIAG4
	Fl6xYFpRUWgJakZKOW8VOg2a3WhJepglhKfhXgGfUoNToJ0ohA0OMgft
X-Gm-Gg: AY/fxX4PX7DUgh3vzQoPZNVG1FBbJQQ52irTbYrS3tP9KEOkRbzqZ59M59vZ0WUmY04
	DYNRbX0ThqwxSrqtwfOst5barGPZ7omzkkFFe/D+UWCP4FwsXpKOrF2zMmeLTuHNron7+IQKZO1
	rluYkTK3Hg5lH4D3FYsVBh8u37A9hY7DRJpQd3t2UuxSnzFdkb+xn31bDcokDT6w6mAYuLuFZaR
	jAv4eU54IcRQl7SDywSXFNgJGJUslRhlhbeYD9yGrfdj8sFfmaHN8D6Vznd+I0pnfpzfkZvt4vX
	dAP9o5M+vsIz6YrYOawDK4D10jkSuEn8jiFNdveIxOkTdTCBbtBarsfYaM0lsyxUZYolfRe/F4P
	t4Qtx4NtMbvbKttkJ31KzX1mxxYdk7A1wgAOByYzQLoW8yfDVDolbbFW0eVc8z9KnryWbMCP5Ym
	/w/Oz0tn22dO77Vu1Bt0KfzPoesr0KNS27RmzQ+rPrFRjl
X-Google-Smtp-Source: AGHT+IGZ+SYDHTTG5p48tl+QB5iPnahkcLty5U9a8Qi/hJOxw+cPuomkuu2gZKHVriePbcQqcWrLVA==
X-Received: by 2002:a05:6808:221e:b0:43f:7287:a5de with SMTP id 5614622812f47-45a6bdfb427mr1080778b6e.41.1767800036459;
        Wed, 07 Jan 2026 07:33:56 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.33.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:33:56 -0800 (PST)
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
Subject: [PATCH V3 05/21] dax: Add dax_set_ops() for setting dax_operations at bind time
Date: Wed,  7 Jan 2026 09:33:14 -0600
Message-ID: <20260107153332.64727-6-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

The dax_device is created (in the non-pmem case) at hmem probe time via
devm_create_dev_dax(), before we know which driver (device_dax,
fsdev_dax, or kmem) will bind - by calling alloc_dax() with NULL ops,
drivers (i.e. fsdev_dax) that need specific dax_operations must set
them later.

Add dax_set_ops() exported function so fsdev_dax can set its ops at
probe time and clear them on remove. device_dax doesn't need ops since
it uses the mmap fault path directly.

Use cmpxchg() to atomically set ops only if currently NULL, returning
-EBUSY if ops are already set. This prevents accidental double-binding.
Clearing ops (NULL) always succeeds.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 12 ++++++++++++
 drivers/dax/super.c | 38 +++++++++++++++++++++++++++++++++++++-
 include/linux/dax.h |  1 +
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 9e2f83aa2584..3f4f593896e3 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -330,12 +330,24 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	if (rc)
 		return rc;
 
+	/* Set the dax operations for fs-dax access path */
+	rc = dax_set_ops(dax_dev, &dev_dax_ops);
+	if (rc)
+		return rc;
+
 	run_dax(dax_dev);
 	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
 }
 
+static void fsdev_dax_remove(struct dev_dax *dev_dax)
+{
+	/* Clear ops on unbind so they aren't used with a different driver */
+	dax_set_ops(dev_dax->dax_dev, NULL);
+}
+
 static struct dax_device_driver fsdev_dax_driver = {
 	.probe = fsdev_dax_probe,
+	.remove = fsdev_dax_remove,
 	.type = DAXDRV_FSDEV_TYPE,
 };
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c00b9dff4a06..ba0b4cd18a77 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -157,6 +157,9 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 	if (!dax_alive(dax_dev))
 		return -ENXIO;
 
+	if (!dax_dev->ops)
+		return -EOPNOTSUPP;
+
 	if (nr_pages < 0)
 		return -EINVAL;
 
@@ -207,6 +210,10 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 
 	if (!dax_alive(dax_dev))
 		return -ENXIO;
+
+	if (!dax_dev->ops)
+		return -EOPNOTSUPP;
+
 	/*
 	 * There are no callers that want to zero more than one page as of now.
 	 * Once users are there, this check can be removed after the
@@ -223,7 +230,7 @@ EXPORT_SYMBOL_GPL(dax_zero_page_range);
 size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *iter)
 {
-	if (!dax_dev->ops->recovery_write)
+	if (!dax_dev->ops || !dax_dev->ops->recovery_write)
 		return 0;
 	return dax_dev->ops->recovery_write(dax_dev, pgoff, addr, bytes, iter);
 }
@@ -307,6 +314,35 @@ void set_dax_nomc(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(set_dax_nomc);
 
+/**
+ * dax_set_ops - set the dax_operations for a dax_device
+ * @dax_dev: the dax_device to configure
+ * @ops: the operations to set (may be NULL to clear)
+ *
+ * This allows drivers to set the dax_operations after the dax_device
+ * has been allocated. This is needed when the device is created before
+ * the driver that needs specific ops is bound (e.g., fsdev_dax binding
+ * to a dev_dax created by hmem).
+ *
+ * When setting non-NULL ops, fails if ops are already set (returns -EBUSY).
+ * When clearing ops (NULL), always succeeds.
+ *
+ * Return: 0 on success, -EBUSY if ops already set
+ */
+int dax_set_ops(struct dax_device *dax_dev, const struct dax_operations *ops)
+{
+	if (ops) {
+		/* Setting ops: fail if already set */
+		if (cmpxchg(&dax_dev->ops, NULL, ops) != NULL)
+			return -EBUSY;
+	} else {
+		/* Clearing ops: always allowed */
+		dax_dev->ops = NULL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_set_ops);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 74e098010016..3fcd8562b72b 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -246,6 +246,7 @@ static inline void dax_break_layout_final(struct inode *inode)
 
 bool dax_alive(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
+int dax_set_ops(struct dax_device *dax_dev, const struct dax_operations *ops);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		enum dax_access_mode mode, void **kaddr, unsigned long *pfn);
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
-- 
2.49.0

