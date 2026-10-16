Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDE4D7D36
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163851; cv=none; b=PkXUgaAbsSUXTPxzVs7IigD3HfdJge8CgkpxvHqtPBdXwqqYfNCFRfe5CyDi1hvkhn7E35e9ANSkTVw25WyAJ811YStaSm8IgJ/2/U9LgEch4KeyIFu1DMTOKxL5T433e9qqFYlXQW3/U/jdQwszk5Q8Q25wtFXS0OnaDxDPN44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163851; c=relaxed/simple;
	bh=YUkw+dai85UeClnTY/cNJI38d36WxPxX1F8i1DhNk+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=fsyqd09FVDovljIfriScgJEwMUEl+JlvRnIQcyAV0bCyMJSVD47bJFh75oOCSoPDGR0QpgZZi+UXl4MKhpTfE2M6KWEpPmNECg2Im/4tC6JYfOs3kK8REPT0gYJSfDTXctIMA1Cj6iDx5L9Lzfdzk6qgIgfInr8G6svvhNqU5kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YgJIOWgu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YgJIOWgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792163847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+TROMxDl8UrJYxG0M+aHIDtSYaFMtjE8ArsPy1R4PO0=;
	b=YgJIOWguC/0Tg9Arzi/aW7+90nVakWbSAOL1iHHiDTIe9MvaXBgXm/Fli731jf/rM7/bGz
	TG3hhQfWmhiCLSqwRfv4IAziXy0DQxC/3yreI5pNCuDnxOKU0zkvzVkraO+/aer1ISRgbT
	6WwWGilcPl2U27QjXnlNxUZHtHD8V64=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-AjVm4m2GMme9_XJkI0-SJQ-1; Fri, 16 Oct 2026 15:17:24 +0000
X-MC-Unique: AjVm4m2GMme9_XJkI0-SJQ-1
X-Mimecast-MFC-AGG-ID: AjVm4m2GMme9_XJkI0-SJQ_1792163843
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a0761224e1so810845e9.0
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 08:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163843; x=1792768643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+TROMxDl8UrJYxG0M+aHIDtSYaFMtjE8ArsPy1R4PO0=;
        b=FID1UcVbZ5elgKjaKzz3qevGzKWW5qUQbZUsTAnanARdeMJsuSG/NtAWK7WfxLZHYk
         ZzSHAYVsxnvG2vuMAMBZH6UcofyG50ZtSEOYUUBnkaRs2tMSR5TfQvMaLZ5X6l2DNUd1
         DspJH746kDaI7aIv+ATS07MneozukZecx6xOSzTXNKHjZ+m+/68OLaEOjNlLd6jAQlYz
         nixSCXcM88B20nkjpT9k+1UWW3hf30E78hPcdnutZ+yYGj/BeNEhFhva2qcobryTra6h
         PE+5suQUAx9F0O8JISPJQLNoglkK3PxrGuC4jLkgS2ITE16xiCZUtyuYpUvm1QzgdEHF
         gaMA==
X-Forwarded-Encrypted: i=1; AKwUvByy/CahG32htqihByZFGKrZ44DAX2qqPFsqKE9QsNWEc+IsJx12S/vSf71K+YYy7/e3ocpXSCg=@lists.linux.dev
X-Gm-Message-State: AFq9FYLxQ2SJVAaxjczkLmYUnPBRz+4rMPwNxP5JijduKg82Lqcii2dv
	fIX2eDIwqfswhcj/jIFycpyKRaTMgGXiyZa9vdbw4nn8vMeJ6pcLHfuU985xGS7GCDd03xI1k5E
	Qw/G0O5pP1pIFgosC9NdQA9QEC8UKpR8eD4hdvi3IVBJ4SH8akQYYynQQJw==
X-Gm-Gg: AYBFou2alWzPrL5Z7Vtx6g5u3ns9iudooyGFgtTEfk3oaUEVF8LhBi8BMhjz8+owo1V
	/pAPBK25C/5UEimN1njlw+H/2WIwg9finfCMmA1VATzSX0dP0LSct8ixPL62VYx5JT2Dlk0Xpmd
	RA6xHmF3VyBHgq+8TTepcgg4qfUWLAj72cNEbgkc6TOVeHENYkNhLuqze58XFPaB9ZHA17mNUJ+
	7gqYcygtBwU9iaw0dtWeQwqFp8tlP2stzZygdzWcfB+4N9C6FmQj5f6xe5ovYkb2jzEPDyJ7UD8
	siTNh/aTun9d6m3YLh+xlOrZ83BCtjSdfv6vgAu5SiGSW80ARoOW6GThT5RKyNedVt6y/o4S61c
	1VY2ka6dA75P6chFBhKHXsw==
X-Received: by 2002:a05:600c:1393:b0:4a1:d248:25b5 with SMTP id 5b1f17b1804b1-4a1d760e327mr2401095e9.24.1792163842794;
        Fri, 16 Oct 2026 08:17:22 -0700 (PDT)
X-Received: by 2002:a05:600c:1393:b0:4a1:d248:25b5 with SMTP id 5b1f17b1804b1-4a1d760e327mr2399225e9.24.1792163841216;
        Fri, 16 Oct 2026 08:17:21 -0700 (PDT)
Received: from maszat.com (85-67-2-18.pool.digikabel.hu. [85.67.2.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8de7230sm64621665e9.14.2026.10.16.08.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:17:20 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: fuse-devel@lists.linux.dev
Cc: John Groves <John@Groves.net>,
	John Groves <john@groves.net>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v5 01/10] dax: add fsdev_dax_from_file()
Date: Fri, 16 Oct 2026 17:16:28 +0200
Message-ID: <20261016151638.2962413-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261016151638.2962413-1-mszeredi@redhat.com>
References: <20261016151638.2962413-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yqRpK4JMzQ4zbKamTNwMke1pmsUfRcahvUWBK10-Mmw_1792163843
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: John Groves <John@Groves.net>

If the file is a fsdev_dax open, take the dax_dev from the device inode's
i_cdev.  Return with a reference grabbed on the private dax inode.

Make dax_dev_get() static again (internal to super.c for alloc_dax), export
fsdev_dax_from_file() instead.

This fix is in response to a Sashiko review, and some subsequent analysis.

About the 'fixes' tag: this removes the export of dax_dev_get(), which was
flawed, and replaces it with fsdev_dax_from_file(). It feels like the fixes
tag makes sense for correcting an ABI error.

Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")
Originally-by: John Groves <john@groves.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 drivers/dax/fsdev.c | 23 +++++++++++++++++++++++
 drivers/dax/super.c |  3 +--
 include/linux/dax.h |  3 ++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 598604bf5ac5..910665c1f492 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -234,6 +234,29 @@ static const struct file_operations fsdev_fops = {
 	.release = fsdev_release,
 };
 
+/**
+ * fsdev_dax_from_file - get dax_device from an open file
+ * @file: open device file
+ *
+ * Returns a dax_device pointer if @file refers to a fsdev_dax device.
+ * Otherwise return NULL.
+ *
+ * Caller must put_dax() the returned device when done.
+ */
+struct dax_device *fsdev_dax_from_file(struct file *file)
+{
+	struct dax_device *dax_dev;
+
+	if (file->f_op != &fsdev_fops)
+		return NULL;
+
+	dax_dev = inode_dax(file_inode(file));
+	ihold(dax_inode(dax_dev));
+
+	return dax_dev;
+}
+EXPORT_SYMBOL_GPL(fsdev_dax_from_file);
+
 /*
  * Acquire the dev_pagemap for probe: the static (pre-populated) one if
  * present, or a devm-allocated one for the dynamic case. Note that
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 45f84b0eb909..25836f389bde 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -565,7 +565,7 @@ static int dax_set(struct inode *inode, void *data)
 	return 0;
 }
 
-struct dax_device *dax_dev_get(dev_t devt)
+static struct dax_device *dax_dev_get(dev_t devt)
 {
 	struct dax_device *dax_dev;
 	struct inode *inode;
@@ -588,7 +588,6 @@ struct dax_device *dax_dev_get(dev_t devt)
 
 	return dax_dev;
 }
-EXPORT_SYMBOL_GPL(dax_dev_get);
 
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index fe6c3ded1b50..2c9fc81f031b 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -54,7 +54,6 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
-struct dax_device *dax_dev_get(dev_t devt);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 bool dax_synchronous(struct dax_device *dax_dev);
@@ -323,3 +322,5 @@ typedef int (*walk_hmem_fn)(struct device *dev, int target_nid,
 			    const struct resource *res);
 int walk_hmem_resources(struct device *dev, walk_hmem_fn fn);
 #endif
+
+struct dax_device *fsdev_dax_from_file(struct file *file);
-- 
2.54.0

