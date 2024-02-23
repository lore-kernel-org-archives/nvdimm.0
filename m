Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A6014262E
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710168; cv=none; b=V/AQoerDkAHkJyTLrFT5xiyvaL8iOX5Q0vzdlxxzTia5MANu6vaI+eIffky31r+1ynBzihPcNE7kGXGL2S6C67Snki6CWMN/2L8KLysu1UesXkKB5AM8MxohazWLW0K5iinWONtmn6ntIcyKb4YmHiahBXaiC+59anTfbUVyYmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710168; c=relaxed/simple;
	bh=srzo99OmjkDCUvG5svVH4unqtaTIPC9o374VcuR+GuM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JCGXhCZ0ITc6w/em2mPbXdfReXFxMscbEoELeSs5VrSQCApZMzjHBHiRyX1BOICV9Z8UNmoMtkPjqquALifJyv7FbyVbKwjYU+g49me5nathcrJ/2kLp7PUxGwPJgWAKPO2smXfSSIQVfQR81YC24LWTKy5+0H0kyWullltJmJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOE4xswE; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOE4xswE"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6e4899fa7f1so93872a34.0
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710166; x=1709314966; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A873SqENQ+wCYjpP9mWHe+BP4BuwHGe8YCt4HStt9WQ=;
        b=fOE4xswEDuXjPJLzUBIf4EExXW05fDTrdnBwX7aZA1iKo+tpo7sjoPrSxInrxf35En
         h9uUrBrzPCal4J+IciTw2V7qLJLa2hyOQCMJur70u31xefdIaZxwxbwqURA7L/TRRf6Y
         5at7wXvdmmxO44XVtktXwkRwiTbSqha8o0VESo3SNQhIzGjuggwZksRe7/hObzMVpdiJ
         c+5f1OVUGHMD254YTsFMgeLhX23IWRMrHqYbG6uhOWSIVw5yIX0y8OoT97ARxsHYIsnU
         FHAJeQHpqzShDebqpWDTaiolx9BoeXStj/TNaxJELKHxZ5x4C7+4qC3Xz9pZkPRRKjrE
         GpAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710166; x=1709314966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A873SqENQ+wCYjpP9mWHe+BP4BuwHGe8YCt4HStt9WQ=;
        b=jkSf33ChHNABcQsuEZVkkhO8PQhnHEcsj3FYBqwZ7auJGdIhquY9pLcfq6m52TXeOD
         DNe1EN8SxMMEP0vkyLLyy4yHrIEhH+o7enYBDdZHP0RhyQcMDPfs+fDmovcr+GXdfSS6
         QM3nP6hgmkBsncOVkc4fMDx8kgWC2FQv5KMOKB5Zws/OtQVfLDn9sTdnDy9vqPgm8cv5
         cQXRoHTVarTwh3ZwmYMVJrHRWtubiibX+mjy3yYxuS8hXJWXb94Eax1E6pakqkBrlbkv
         oZoEN0J4+PA6wSbYilWjq2jIqX7nO9XQ4DKcVN3THbs2qJP8bIKNLhdZTcDM/7QpnlFl
         ZXUA==
X-Forwarded-Encrypted: i=1; AJvYcCUOeGVWrwfaBCKmXcFI4xZ67VIPkWcylEPnEbxCPJ+EQCh6NFCrm5eiXW/oFJALbfcDzAEVJVpzhZM8+ORpWZb7SO1LeHAO
X-Gm-Message-State: AOJu0YwrKjlUnD/mcDgr/jpf8V76ke8uIBeF52tMI77r0Yh7NeTRy1xF
	xeNCAAWyn/9ZYyhijz/eNK+/pRp1Lnl8ORe/2bKJ+ulNIdJLUlGr
X-Google-Smtp-Source: AGHT+IF2fmWGYszloE2KJFCTjjXL/IoXoZ6AQti5BlXVdEWVOweP5vY0ChXNH89MGd6oVU3o3oDieQ==
X-Received: by 2002:a05:6870:514f:b0:21e:5647:c3e2 with SMTP id z15-20020a056870514f00b0021e5647c3e2mr604937oak.26.1708710166110;
        Fri, 23 Feb 2024 09:42:46 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:45 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John@Groves.net,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	John Groves <john@groves.net>
Subject: [RFC PATCH 10/20] famfs: famfs_open_device() & dax_holder_operations
Date: Fri, 23 Feb 2024 11:41:54 -0600
Message-Id: <74359fdc83688fb1aac1cb2c336fbd725590a131.1708709155.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <cover.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Famfs works on both /dev/pmem and /dev/dax devices. This commit introduces
the function that opens a block (pmem) device and the struct
dax_holder_operations that are needed for that ABI.

In this commit, support for opening character /dev/dax is stubbed. A
later commit introduces this capability.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_inode.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
index 3329aff000d1..82c861998093 100644
--- a/fs/famfs/famfs_inode.c
+++ b/fs/famfs/famfs_inode.c
@@ -68,5 +68,88 @@ static const struct super_operations famfs_ops = {
 	.show_options	= famfs_show_options,
 };
 
+/***************************************************************************************
+ * dax_holder_operations for block dax
+ */
+
+static int
+famfs_blk_dax_notify_failure(
+	struct dax_device	*dax_devp,
+	u64			offset,
+	u64			len,
+	int			mf_flags)
+{
+
+	pr_err("%s: dax_devp %llx offset %llx len %lld mf_flags %x\n",
+	       __func__, (u64)dax_devp, (u64)offset, (u64)len, mf_flags);
+	return -EOPNOTSUPP;
+}
+
+const struct dax_holder_operations famfs_blk_dax_holder_ops = {
+	.notify_failure		= famfs_blk_dax_notify_failure,
+};
+
+static int
+famfs_open_char_device(
+	struct super_block *sb,
+	struct fs_context  *fc)
+{
+	pr_err("%s: Root device is %s, but your kernel does not support famfs on /dev/dax\n",
+	       __func__, fc->source);
+	return -ENODEV;
+}
+
+/**
+ * famfs_open_device()
+ *
+ * Open the memory device. If it looks like /dev/dax, call famfs_open_char_device().
+ * Otherwise try to open it as a block/pmem device.
+ */
+static int
+famfs_open_device(
+	struct super_block *sb,
+	struct fs_context  *fc)
+{
+	struct famfs_fs_info *fsi = sb->s_fs_info;
+	struct dax_device    *dax_devp;
+	u64 start_off = 0;
+	struct bdev_handle   *handlep;
+
+	if (fsi->dax_devp) {
+		pr_err("%s: already mounted\n", __func__);
+		return -EALREADY;
+	}
+
+	if (strstr(fc->source, "/dev/dax")) /* There is probably a better way to check this */
+		return famfs_open_char_device(sb, fc);
+
+	if (!strstr(fc->source, "/dev/pmem")) { /* There is probably a better way to check this */
+		pr_err("%s: primary backing dev (%s) is not pmem\n",
+		       __func__, fc->source);
+		return -EINVAL;
+	}
+
+	handlep = bdev_open_by_path(fc->source, FAMFS_BLKDEV_MODE, fsi, &fs_holder_ops);
+	if (IS_ERR(handlep->bdev)) {
+		pr_err("%s: failed blkdev_get_by_path(%s)\n", __func__, fc->source);
+		return PTR_ERR(handlep->bdev);
+	}
+
+	dax_devp = fs_dax_get_by_bdev(handlep->bdev, &start_off,
+				      fsi  /* holder */,
+				      &famfs_blk_dax_holder_ops);
+	if (IS_ERR(dax_devp)) {
+		pr_err("%s: unable to get daxdev from handlep->bdev\n", __func__);
+		bdev_release(handlep);
+		return -ENODEV;
+	}
+	fsi->bdev_handle = handlep;
+	fsi->dax_devp    = dax_devp;
+
+	pr_notice("%s: root device is block dax (%s)\n", __func__, fc->source);
+	return 0;
+}
+
+
 
 MODULE_LICENSE("GPL");
-- 
2.43.0

