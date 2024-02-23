Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C324113A870
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710146; cv=none; b=FD7JW9WYGP9FbCHG/WejfyoHqGvg+kNz2c67mgoEaBNgWS6DXhE+l+opEXjxNwHt9RGJ/o0lwmiRORuN//SJdLPxfaQcvcCUJHDqp1GHNsysRR6BK35Wnik8wmFV6OskH8/HVKLgljj1G/WxuIo8EXmGdPWkaTZEvmycMShip4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710146; c=relaxed/simple;
	bh=CkgahHLrXAzsDc1GyliBXNYmxljQ1YjaPW98OF38fIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rBYzj/NpSEssK5hD8C9Fu3ZcyWBILtc1cJQsOp2S5qXtNN3pIo00srv6k0OnqTLJUOdWye0kpPFtx7b90b9B9LvTQIwEy9BGzOhPf9WsLZRe5J48cZFmYbyurUxb9vbH0xGstEaS3apckQSVWknQ5SzIKYuvSGScMpSTYDgqwew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxWv4BtY; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxWv4BtY"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e2e5824687so401405a34.0
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710144; x=1709314944; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGMjiwg1uZ6Jr5mNemJ2ScloiGdJ6cdnQKQjOvidMjQ=;
        b=gxWv4BtYleBqylRA41x4SvuyZ3vtcu/RAYjnc2m6LTg9QYp64cFlIeq0BRxMZ2CbiJ
         dTmKtquE75F72yqZ+fJxcJwuXSGgLrwbQVJeW4myNqPIXszgkrCRjyakvG6LyrrehBBf
         sKjVcShuP5TYffooFWFyCHf1QZJkd2zEZ04L7zB6GCkRwtGHtAcyz3YWv6PMmumJ20xT
         O9xs1/QG5Zo3yF0y5+CdYcv63sbQEFv4Y8tkIidHLZkXOMqI1oV6b4gJUiqhy4wtkEKx
         Rfb4lxL1UeUOY9JGfi4NfrsUW/jGwpdlVRfqeJqLJJ85AU0tHYUYr6TNyyJJsCwQs0B2
         HXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710144; x=1709314944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nGMjiwg1uZ6Jr5mNemJ2ScloiGdJ6cdnQKQjOvidMjQ=;
        b=v9IhMPDr+aAK8MPAkQMPe1Ga95HTJiSdezmME4/FFJJcN4Q1bS7ZG7lM6Yn1ie1QmC
         lpBC9sK4aKSnUD41FIozJuNuHcl0q8La8eMS/HrGlPgK6iP9DLKAIkURMf26CMmyWKF/
         jceBTe98nKh9NHfdLhYsazTAceNrHc16nr8avt0OglpKNdoiooFiuO7vUyoIczeM57/7
         lPQpUlBO0Kgl6JK9PLrx5uILqvqGNZRQQdXdclOMvOXMGH6FPOOtlPIK3hl/YPcXBv0F
         YlgvOkr6CouBOwJq4CG1WIZNw2YnXkJW66MbFwqSix/5jhxpaLm9/Hg01NUEytZ1Ujnc
         qiYw==
X-Forwarded-Encrypted: i=1; AJvYcCW4G4rhi4pfvpuykOSDl7ueEMQmaE2T/1lv3gKH0gROOvcpMF+fuNYS+XtFMdP/PgtRtZQwzNVTM/tuLeVhhRDzpjvVFwVD
X-Gm-Message-State: AOJu0YyCqglVQi6ufmiYXPm+9GDHl14oQ8BJf4FsRNqESBBl7Ldq+jnj
	9uTHIrm0hJEz5nBOcjtjcBPPX9le17gD3MxjXAWaIxJW72TzsbDRcO1IM2ai/II=
X-Google-Smtp-Source: AGHT+IGTh/vsL/iyfr1+O5xIszFoRGO1T0cqNt3QFKtOmtVkFPM3Pqvq3kpeRl0uX4riIRv1bk+bvQ==
X-Received: by 2002:a05:6871:489:b0:21f:662:e01 with SMTP id f9-20020a056871048900b0021f06620e01mr481442oaj.56.1708710143576;
        Fri, 23 Feb 2024 09:42:23 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:23 -0800 (PST)
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
Subject: [RFC PATCH 02/20] dev_dax_iomap: Add fs_dax_get() func to prepare dax for fs-dax usage
Date: Fri, 23 Feb 2024 11:41:46 -0600
Message-Id: <69ed4a3064bd9b48fd0593941038dd111fcfb8f3.1708709155.git.john@groves.net>
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

This function should be called by fs-dax file systems after opening the
devdax device. This adds holder_operations.

This function serves the same role as fs_dax_get_by_bdev(), which dax
file systems call after opening the pmem block device.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |  5 +++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index f4b635526345..fc96362de237 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -121,6 +121,44 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
 EXPORT_SYMBOL_GPL(fs_put_dax);
 #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
+#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
+
+/**
+ * fs_dax_get()
+ *
+ * fs-dax file systems call this function to prepare to use a devdax device for fsdax.
+ * This is like fs_dax_get_by_bdev(), but the caller already has struct dev_dax (and there
+ * is no bdev). The holder makes this exclusive.
+ *
+ * @dax_dev: dev to be prepared for fs-dax usage
+ * @holder: filesystem or mapped device inside the dax_device
+ * @hops: operations for the inner holder
+ *
+ * Returns: 0 on success, -1 on failure
+ */
+int fs_dax_get(
+	struct dax_device *dax_dev,
+	void *holder,
+	const struct dax_holder_operations *hops)
+{
+	/* dax_dev->ops should have been populated by devm_create_dev_dax() */
+	if (WARN_ON(!dax_dev->ops))
+		return -1;
+
+	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))
+		return -1;
+
+	if (cmpxchg(&dax_dev->holder_data, NULL, holder)) {
+		pr_warn("%s: holder_data already set\n", __func__);
+		return -1;
+	}
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
index b463502b16e1..e973289bfde3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -57,7 +57,12 @@ struct dax_holder_operations {
 
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
+
+#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
+int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
+#endif
 void *dax_holder(struct dax_device *dax_dev);
+struct dax_device *inode_dax(struct inode *inode);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
-- 
2.43.0

