Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CD636B056
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426541; cv=none; b=T/yHYT1NBg7Hm5HH1mK86+3UTBvtHZjxn2tI84lQL45uQEFgpfsMQuhdxb0Npf84T+WJkyFMnG3keVMucMjBFKiyyAD259lC+LQbxzfhiLljRTmFGSEm/caxrz4aUWWoj6RHPdlLCr4t7gLsl6awdlMFJ8LTc9JMVD7sgJuMPjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426541; c=relaxed/simple;
	bh=Ifuf2L6wRVVt+3qNeBjdLicdVJ8UNwMl/Wbxz9ngJzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDVVOFc1joFlwrd0J9vTlv7UWPmspst7phwF7anTFJPGbboz20sqkRCy5Mg35q+vpq8qjgaol7A8KhnhXbgdkpOB+Yb3YRWNP3lN1Nxg29yX9qCaYNG9YFMVmD/o2np7cLVNsvg2ZeIT2fnC45zppFPKv54+p6wLSlMVA6EVAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QDsAHdmB; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDsAHdmB"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-40413188553so161796fac.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426530; x=1769031330; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPBFShXog0UoyhMxz+wxzMnblXj48CNmW7x9zXtvk2c=;
        b=QDsAHdmBtBRNcm7RdgMDzDy8mmbGPJ7poiA32rL+Fk9qFlD7iKIdiuQlBdd40bwt2P
         rC/QM4doVWTt4emHH6cVKpuDFuN8J/DHwnu5r8BPq1yDOtN/10CJhFKrD59CykNlrKSO
         4zg8qGClbVTqY3pb5wadb9XjvRx5CAuqdqtqWSQHK7TTuO9MbDWnz62lprLshvwoICz3
         TE4plst4r69At89j8C+Q+4LceHN+Wf6fXPgKlPHvFJ5iyXssEIz67ua7/4i4V4zrQoAb
         cI9rMsFs0gYoslKLNgq+QyrbHsk8U5zcPtiqeZ+6voqpGYtGn6PHtAOt3mSRNl/jBR55
         If+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426530; x=1769031330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TPBFShXog0UoyhMxz+wxzMnblXj48CNmW7x9zXtvk2c=;
        b=ShOiEdMVYYDp1EN51vRUn1W0Hy/nNWsEUyRRPMyLGJ+SrSiLS9EHdNMEOElv8y1u5A
         Y3MveKQ4ij7Mu1qra9Y9I1du7bp1oIhOPvwQuvgByBdc692PxDwoBu+rkRyjhfFtM2be
         ghzS528ybzf1GHa3rxvbyiiD5NuUXEnBq5YVtZnGQ96mVBC54kV9z7aXZmVBB80o5Lxt
         AgNKAPWAJXD44yIrWNDG2bmFq13I7QwqUxlHAUCgw+Q70vPM7+7XcM9D7wu0CVSRd2ME
         LU00oVtaXQMpHt1tyEzzd6wV0HE4zJt/XFmsA3KiKUFK8qfAxPnluIZ6E19dWUWpSSuC
         EM7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCzpwX+bq3/fsWRMqb1T0geE3swKgUrYpWW/mL37wq0p8+1P9N7uLwZ9SP2wk23GV1tP5x3bk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuwPDzcNJ3G/Er5YELfZKpexTOfFuZ7DUxhL5Hsc1PPXPg7DQz
	Rf8cdrA+jpo0+7CTyMKqFHxlPjRuELlUhMVug6g6FonRLHVY7lF+xi67
X-Gm-Gg: AY/fxX6mmQRc8oPcBBD14x0jnLLZkwP2ZhHBkyfKRTtSJq/ovxWXGX+022MCdB8W1Px
	agk5qPNR+33pp/pDbHdeyXR5zIK+7zVZZpcHRkEFbBgNvvZokRSZdRQxRaCxJsuWWKK2US3fgFe
	CIWqPtr5k+/os8jopsuGC4P7knFah70tEkG/fpY/4t+Du77w+7dluxVe6ubDJ4uxqeRfVLBvLmG
	0yz6t9W8qYm5bNg2HHB+o4ACQbsX9sIzywk+d0x6gFzZ4xoQYXmRdkiJyfVt60XshSExwkAAKHW
	iKRLDZfyHaBB6M2gK6Qw/rg18IXmRHHzhOQPHWlXDJmd/6UL7vmX4v3VERStfPoxgZPOad/KmbD
	zb1/5n93cXgX97i+TtQuxHJv1M7j1TXWihmDBB3GTpDU/tvdS+8GryvbGvb3oOCSVv1vJYviv6Z
	rQAsJHa/WblmgZ2MCwdERtZdAak2VS/mpCMfR/WWUUGcTl
X-Received: by 2002:a05:6871:8b0b:b0:404:1da3:8005 with SMTP id 586e51a60fabf-4041da384acmr1095432fac.54.1768426530025;
        Wed, 14 Jan 2026 13:35:30 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa50721a6sm17707178fac.10.2026.01.14.13.35.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:35:29 -0800 (PST)
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
Subject: [PATCH V4 06/19] dax: Add dax_set_ops() for setting dax_operations at bind time
Date: Wed, 14 Jan 2026 15:31:53 -0600
Message-ID: <20260114213209.29453-7-john@groves.net>
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

Add a new dax_set_ops() function that allows drivers to set the
dax_operations after the dax_device has been allocated. This is needed
for fsdev_dax where the operations need to be set during probe and
cleared during unbind.

The fsdev driver uses devm_add_action_or_reset() for cleanup consistency,
avoiding the complexity of mixing devm-managed resources with manual
cleanup in a remove() callback. This ensures cleanup happens automatically
in the correct reverse order when the device is unbound.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 16 ++++++++++++++++
 drivers/dax/super.c | 38 +++++++++++++++++++++++++++++++++++++-
 include/linux/dax.h |  1 +
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index f58c88de7a4d..d658942b7143 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -114,6 +114,13 @@ static void fsdev_kill(void *dev_dax)
 	kill_dev_dax(dev_dax);
 }
 
+static void fsdev_clear_ops(void *data)
+{
+	struct dev_dax *dev_dax = data;
+
+	dax_set_ops(dev_dax->dax_dev, NULL);
+}
+
 /*
  * Page map operations for FS-DAX mode
  * Similar to fsdax_pagemap_ops in drivers/nvdimm/pmem.c
@@ -296,6 +303,15 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	if (rc)
 		return rc;
 
+	/* Set the dax operations for fs-dax access path */
+	rc = dax_set_ops(dax_dev, &dev_dax_ops);
+	if (rc)
+		return rc;
+
+	rc = devm_add_action_or_reset(dev, fsdev_clear_ops, dev_dax);
+	if (rc)
+		return rc;
+
 	run_dax(dax_dev);
 	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
 }
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
index fe1315135fdd..5aaaca135737 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -247,6 +247,7 @@ static inline void dax_break_layout_final(struct inode *inode)
 
 bool dax_alive(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
+int dax_set_ops(struct dax_device *dax_dev, const struct dax_operations *ops);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		enum dax_access_mode mode, void **kaddr, unsigned long *pfn);
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
-- 
2.52.0

