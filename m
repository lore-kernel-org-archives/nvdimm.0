Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40191146E9B
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710188; cv=none; b=uqlJlU0M2ugjgMrbQqZqYsk4fWco4zCN5/icVmKZP5Ul8fhL0gAzF9rxGValkNPpeFos/AHvMURXkGE7PafegvibH/ULyGh6t8UIk850HwaI55j0BlMsLswdHfDDgL528HVfT4G9PuMeGs2onjTbiwLfAZf6w8Mm+mb7c81UpUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710188; c=relaxed/simple;
	bh=yRp5u9MQR7i0pHHhigFRLMC5jxEA/cmL4WRIc6/6wyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hvrwlirk9sQ8nMFNADXm5ZfrNc3pXGU4OqdQgMP+Spi3dgj+sXt4DiVck3MneobCWFUUqunfG29I4Elka2zVB3Z3jXlSJ2cw3ne7BDiOpOAeTE+6VvauW9QLRlpIvRwtguKGVdu5/6+CylgH7dS8bNGGrbiJplT8qeDKIpm3d1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GGBqogeH; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGBqogeH"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-204235d0913so761418fac.1
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710186; x=1709314986; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHor3u3W+wuqia7Ht/WsFpCY9Rk+dRiHPG2C9ZesKqY=;
        b=GGBqogeHGBzJC2sQJy6v77HN81KX8bxyVGXNPs06q685+L5G60H4AdHGYN7y1rSxO0
         5LBPHPkQaCoa01pQRO6/Fs/y34c/3YqDMMFvkI/u7LSHvduzqmat0PPb8JeES4BCSEiF
         HBCjq5d10adfWeNrSWtnGNjw26UaI2Lf5MpZ4KuIjisguF8f+dkR9knEQ6Lqx3nbHYrv
         wltUzu+jK/qzaPW6iY85hykPkD+6Hg0RDdCdkvifjW55EwjW6Pyjfk7s9rkMfn6Jj7Pu
         AbG7n1GtZxFL/6PfyXxPRSPk50ITYUUreMy61Tri4/TIzmtai8WN3uXrhNmSffehV/4e
         zF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710186; x=1709314986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OHor3u3W+wuqia7Ht/WsFpCY9Rk+dRiHPG2C9ZesKqY=;
        b=MEtlrnm7ySHYCnp598aOrQA4CDA4Q2pYTpEGpTCCGlkZwxVZkh6fIaSII3s+nXVO7V
         gsnc57C00+0LNBCHXhmDjdhySFXUGxMuReamH4dzlwCZhDwvbtJBWIN1Tbp34qJsU38S
         NV7hjV8M3tYmmWdNdyuy3rJygpJwm+6kBNax9wJgQ9hUAoLov4LSmZ8UFDq3cQWaZbqt
         +BCCJg8y0eKw5ckxAVlMfQaRPuElTV1Be8m1fLU8uTYdXBobaKjNa5ordiYi6i4U+v2Q
         04uzrIbKjFL56vD6DCf8dnTTjXz1TzODKg+jgNSQvsF3WIGjbjJu3BdaXliUJyopauk2
         3E+w==
X-Forwarded-Encrypted: i=1; AJvYcCXk+AgWL0U4qIqdZzxIOsrSE944ywBdOJfaULGjOrOK1k8wfqnVg9V8iBkEmxvMghZhb7u6yLoj15W7XXEHoP7zYsVI4Qnz
X-Gm-Message-State: AOJu0YyJHucHuwWRAq40nljqLNGinuGbS+ps8q2bIEHbTmTo9zJFjja7
	wyUov+RU9/VswbEkXnBxRkoM+B5BL7QSKRH31lAdxZDfOBB4zlWoE8MO0+TVn08=
X-Google-Smtp-Source: AGHT+IHNnKVpb62Lo5a6C8MsXucHX7a5scGCwnDEKNG9/0OIPbmHNqpRkF5qcIHHDdwtWWcx7RJCLQ==
X-Received: by 2002:a05:6870:d109:b0:21e:e9bd:afa9 with SMTP id e9-20020a056870d10900b0021ee9bdafa9mr558439oac.21.1708710185753;
        Fri, 23 Feb 2024 09:43:05 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.43.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:43:05 -0800 (PST)
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
Subject: [RFC PATCH 17/20] famfs: Add module stuff
Date: Fri, 23 Feb 2024 11:42:01 -0600
Message-Id: <e633fb92d3c20ba446e60c2c161cf07074aef374.1708709155.git.john@groves.net>
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

This commit introduces the module init and exit machinery for famfs.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_inode.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
index ab46ec50b70d..0d659820e8ff 100644
--- a/fs/famfs/famfs_inode.c
+++ b/fs/famfs/famfs_inode.c
@@ -462,4 +462,48 @@ static struct file_system_type famfs_fs_type = {
 	.fs_flags	  = FS_USERNS_MOUNT,
 };
 
+/*****************************************************************************************
+ * Module stuff
+ */
+static struct kobject *famfs_kobj;
+
+static int __init init_famfs_fs(void)
+{
+	int rc;
+
+#if defined(CONFIG_DEV_DAX_IOMAP)
+	pr_notice("%s: Your kernel supports famfs on /dev/dax\n", __func__);
+#else
+	pr_notice("%s: Your kernel does not support famfs on /dev/dax\n", __func__);
+#endif
+	famfs_kobj = kobject_create_and_add(MODULE_NAME, fs_kobj);
+	if (!famfs_kobj) {
+		pr_warn("Failed to create kobject\n");
+		return -ENOMEM;
+	}
+
+	rc = sysfs_create_group(famfs_kobj, &famfs_attr_group);
+	if (rc) {
+		kobject_put(famfs_kobj);
+		pr_warn("%s: Failed to create sysfs group\n", __func__);
+		return rc;
+	}
+
+	return register_filesystem(&famfs_fs_type);
+}
+
+static void
+__exit famfs_exit(void)
+{
+	sysfs_remove_group(famfs_kobj,  &famfs_attr_group);
+	kobject_put(famfs_kobj);
+	unregister_filesystem(&famfs_fs_type);
+	pr_info("%s: unregistered\n", __func__);
+}
+
+
+fs_initcall(init_famfs_fs);
+module_exit(famfs_exit);
+
+MODULE_AUTHOR("John Groves, Micron Technology");
 MODULE_LICENSE("GPL");
-- 
2.43.0

