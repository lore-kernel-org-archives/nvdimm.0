Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAAF149003
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710190; cv=none; b=N8saKR6Tj184tm+NKJFpNGuzquz0AF0UwhfQB/BJUJtPjS5Bvqzu1UQ9ipCp5uymEEQCLTtem5mLmCbsDwiyerpVmTuFQzh8tEj+yjP7nYVtmwhnB2ejqpNp5rQWz/MD0uvvFfEUDcwqTyeBnMqwUQZHCX7/GBnPWi6PIngg+jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710190; c=relaxed/simple;
	bh=Ezvg1m83Vs64xk30SW6VrHXVsjwp8rUkX/UFmrsqfhg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F077Zh1ZoH3pnRIe4Q1jYSO6XS9t4nObGr4rm0VCTayd5ldIuFDvytbYL7ci0Xpm3DzAcXrhFwNrENsKUSxweN0poYqFASjoMAJRZB8WyOvSne4Z6uU2AbkL/ZsS0tHg0CRGFoGmPHUJiDoTkTNdVCWD+rWLE0PwAMgujNOkgIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c9qQZpVE; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9qQZpVE"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2185739b64cso612649fac.0
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710188; x=1709314988; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bZOoCwgmIQtQYNMOXLY20KATST0iJmwj9uPACUep5Q=;
        b=c9qQZpVEDWRfimVOZ2T4Jv7Ss6wheioXijEXpgmg+jeM0m37Rn+zS5lOpI0rtR5G/F
         fR87CiN9OthD8fN6slZ85OOCr70EewVzgnwO9T+zUFq/32O8Yr5+2OR0eaEn36x66+Dg
         U4HbquBrMGxTbN4ZDrdvwORuHtrYPqE+ySJt5MO1bupG3cpIZOCW/wiJ8ZIb6Rsgk4UI
         j1fdyDzmMl+sknt1XjNmXlofl6G/gXHkG44shy1T83GFLQJf9I/ip3qqCO0qksheyjNU
         O7CSu9Cjs+NHATMvcgdfLf1uGFGHPiQGiB38WjI79GMmLm8wyYUwiJx7bmOH2UfODvAp
         yeTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710188; x=1709314988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5bZOoCwgmIQtQYNMOXLY20KATST0iJmwj9uPACUep5Q=;
        b=rJCh/x5RCKNawZuTrbj7uRbQtpPTHu+Mg9rRAo/YVIvvByetAvZtgAGuiPvJVFOZS3
         bE0lvTC6Et/GPYUR7w9qAmvxAuG5W25rY8SdPwPE8zJbuw6NEBIiXBFN/bOeV8is0RsF
         ZxAWfjxTLnyohfLT7XyJL2bK3lIoihbK0wK5oJkf4z1N4LS4m6hGsscoVkJw8b0U5bFW
         b+CsUkc4/xdwh0/SZf3NTcZ6QXytOc+vFRmP6d0qbRcl/7fhSMvNLVd06AtQ2PUSR/In
         2DhsORKMdR7DCMDlw3uI64SpmPVMP+6LbTM+rZ+uBCTqCLzcIDJRsZv9wA5mx5GQhjiD
         jiQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNsVsMp/WObDBhfG1cVHsHooPt83IGtQM9Y1MJWn+uxwQ2BHRtnsKQQG35wWGwEwgimq+vf20Pf9qfbwZBjexY0J3+1yq0
X-Gm-Message-State: AOJu0YzS/GBw3JpNrQjMAnFeha/Gq1Q+OgsX0pl6Kx0qNrU386rcOqFo
	OlbCpvXTaTYX0g5ySC2pxJGBtcYqdyDDqRJxotFbTWTdunK/pZOgqBLiYgaJovQ=
X-Google-Smtp-Source: AGHT+IHUEsDV7yeQRAIvTjc09WAn3P29Hi3DwkwU1/8Dctv6Vii+QtA1pfrR/mdognmcuCPTsC2TYg==
X-Received: by 2002:a05:6870:95a8:b0:21e:87ce:87c4 with SMTP id k40-20020a05687095a800b0021e87ce87c4mr572812oao.13.1708710188345;
        Fri, 23 Feb 2024 09:43:08 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.43.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:43:08 -0800 (PST)
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
Subject: [RFC PATCH 18/20] famfs: Support character dax via the dev_dax_iomap patch
Date: Fri, 23 Feb 2024 11:42:02 -0600
Message-Id: <fa06095b6a05a26a0a016768b2e2b70663163eeb.1708709155.git.john@groves.net>
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

This commit introduces the ability to open a character /dev/dax device
instead of a block /dev/pmem device. This rests on the dev_dax_iomap
patches earlier in this series.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_inode.c | 97 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 10 deletions(-)

diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
index 0d659820e8ff..7d65ac497147 100644
--- a/fs/famfs/famfs_inode.c
+++ b/fs/famfs/famfs_inode.c
@@ -215,6 +215,93 @@ static const struct super_operations famfs_ops = {
 	.show_options	= famfs_show_options,
 };
 
+/*****************************************************************************/
+
+#if defined(CONFIG_DEV_DAX_IOMAP)
+
+/*
+ * famfs dax_operations  (for char dax)
+ */
+static int
+famfs_dax_notify_failure(struct dax_device *dax_dev, u64 offset,
+			u64 len, int mf_flags)
+{
+	pr_err("%s: offset %lld len %llu flags %x\n", __func__,
+	       offset, len, mf_flags);
+	return -EOPNOTSUPP;
+}
+
+static const struct dax_holder_operations famfs_dax_holder_ops = {
+	.notify_failure		= famfs_dax_notify_failure,
+};
+
+/*****************************************************************************/
+
+/**
+ * famfs_open_char_device()
+ *
+ * Open a /dev/dax device. This only works in kernels with the dev_dax_iomap patch
+ */
+static int
+famfs_open_char_device(
+	struct super_block *sb,
+	struct fs_context  *fc)
+{
+	struct famfs_fs_info *fsi = sb->s_fs_info;
+	struct dax_device    *dax_devp;
+	struct inode         *daxdev_inode;
+
+	int rc = 0;
+
+	pr_notice("%s: Opening character dax device %s\n", __func__, fc->source);
+
+	fsi->dax_filp = filp_open(fc->source, O_RDWR, 0);
+	if (IS_ERR(fsi->dax_filp)) {
+		pr_err("%s: failed to open dax device %s\n",
+		       __func__, fc->source);
+		fsi->dax_filp = NULL;
+		return PTR_ERR(fsi->dax_filp);
+	}
+
+	daxdev_inode = file_inode(fsi->dax_filp);
+	dax_devp     = inode_dax(daxdev_inode);
+	if (IS_ERR(dax_devp)) {
+		pr_err("%s: unable to get daxdev from inode for %s\n",
+		       __func__, fc->source);
+		rc = -ENODEV;
+		goto char_err;
+	}
+
+	rc = fs_dax_get(dax_devp, fsi, &famfs_dax_holder_ops);
+	if (rc) {
+		pr_info("%s: err attaching famfs_dax_holder_ops\n", __func__);
+		goto char_err;
+	}
+
+	fsi->bdev_handle = NULL;
+	fsi->dax_devp = dax_devp;
+
+	return 0;
+
+char_err:
+	filp_close(fsi->dax_filp, NULL);
+	return rc;
+}
+
+#else /* CONFIG_DEV_DAX_IOMAP */
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
+
+#endif /* CONFIG_DEV_DAX_IOMAP */
+
 /***************************************************************************************
  * dax_holder_operations for block dax
  */
@@ -236,16 +323,6 @@ const struct dax_holder_operations famfs_blk_dax_holder_ops = {
 	.notify_failure		= famfs_blk_dax_notify_failure,
 };
 
-static int
-famfs_open_char_device(
-	struct super_block *sb,
-	struct fs_context  *fc)
-{
-	pr_err("%s: Root device is %s, but your kernel does not support famfs on /dev/dax\n",
-	       __func__, fc->source);
-	return -ENODEV;
-}
-
 /**
  * famfs_open_device()
  *
-- 
2.43.0

