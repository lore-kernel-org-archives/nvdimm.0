Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E170133995
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710151; cv=none; b=Fz+WIa6tojjQGbK5HUqMpQ/2WPnOwWl8twFjHfW0jLDIyC8Z/0U3XZj3kg8B6PTPYsuTvcoOLRoJFukfKZiM2e+DHTsNgZdNnUnlsQfPam9quNJMkxXEWRNfXxx2qc/SfquHViB6uRKJmeM8osJcTeMnYMzTZkcUMlIhRZnsKkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710151; c=relaxed/simple;
	bh=P4ycxMH1eLEp2A0+12tkQr5yDXMbhNTfR+V2FQ6zQjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PxAHFRN+cnNiH/juv6JWeZuuKuPUW/SoeJu2Km2cKnkdqmN5h9rJ9YboA+ne6hRHaczYka8snGUPtQ4P8GEkM4WlgFdFE432kweYP5fu2UPz+5AjDswv3k25DoUcvOZ0BGIcL8KsrnQe8PTYMoE7Gguk4NQcufo8x7GuNt/4Lvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jpO6CQyk; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpO6CQyk"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3bbb4806f67so386329b6e.3
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710149; x=1709314949; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJnJfeFGNikf7Cy1KZrMQXeMgUfPXb1BZJ051HZbDR4=;
        b=jpO6CQykLg49v0ovCPfr4sjMzC3og8/f+PIclRxpsfhv3F27KG1RwJakZ4Vl09biJj
         asdJ36FC18koZ7+sklvnFldAmCgCGJ+4G1jF2hcuyUuhRVF1FJH9zayEa5Rjkwwfowx0
         DM8U7LK9aDjswH9ogSud3PNFWhB2gSOB8cLBGWWvB/7eaExFIq9v66LiMIyc4upmDTeN
         BjdZ9FwgBDtvi3qj6loff5PUvN28QPxRg3z/bo5uAlsStw1C8vR+4HlPV04VnW+ETi0H
         kxuCdakqu9APBLENO5kSKWUA7KXQ4lmx1baeydnN5OU44GCi6sYR7rB8tvAwNW0wxQQC
         uRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710149; x=1709314949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJnJfeFGNikf7Cy1KZrMQXeMgUfPXb1BZJ051HZbDR4=;
        b=W9uTZ0ELq0lmH0yaZS5hJUe7/DnQrQx15iRmNjCNyCmW6RfShe0a+pRpjllWLQ/0hv
         DreEZUthQohcu1y7k6Xv32MT2AJcTIIGmR9y5SvabXG1xGqwkzhCnysnU0O/RJv8ugt/
         DkFUw+aBftoa6OeUvIny76XSSz+M+YmKFKa+AK16/TTMTNZsh6vpWO2UWjeDnWVo0PAP
         SSNFLxfDOed0sf6qG2s7xavkkJLT7bYlqKafEtHodq+qPLKvKnbhtXbRdoStv6lbiezr
         Fx1rkljDbv/kAeHnLxpwd6jq9kOZ9IqeIbOMRxP51ZfVNPpVUZjJcJPC56WZtE9QCJnu
         VAxA==
X-Forwarded-Encrypted: i=1; AJvYcCUSe6gIkQJy0QvmRZV3DYP6m+IUGXUDOnjPviuWPEYd9o1fmSSfSmDu1DzQzMCe9rbv9fhPV3eNIK3/SSba5PXThOIxohRW
X-Gm-Message-State: AOJu0YzXkwdwwGbszzMBy5nhsc20dwCd2B/qJ8dXFmyLVGrVX6NMPebE
	AnNNh/uiri5vEd3wp87/GFnROYVaz2eYz17xGakFQFblpqcv3uyD
X-Google-Smtp-Source: AGHT+IEIopUj6ImsBlvAoK0O/1OKc+IpoiZFvcZvRep/2o4LSk5XrwSkmZ5t0MNRVaK6kXRmK59Fsw==
X-Received: by 2002:a05:6870:64a6:b0:21e:8c19:f716 with SMTP id cz38-20020a05687064a600b0021e8c19f716mr516277oab.49.1708710149191;
        Fri, 23 Feb 2024 09:42:29 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:28 -0800 (PST)
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
Subject: [RFC PATCH 04/20] dev_dax_iomap: Save the kva from memremap
Date: Fri, 23 Feb 2024 11:41:48 -0600
Message-Id: <66620f69fa3f3664d955649eba7da63fdf8d65ad.1708709155.git.john@groves.net>
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

Save the kva from memremap because we need it for iomap rw support

Prior to famfs, there were no iomap users of /dev/dax - so the virtual
address from memremap was not needed.

Also: in some cases dev_dax_probe() is called with the first
dev_dax->range offset past pgmap[0].range. In those cases we need to
add the difference to virt_addr in order to have the physaddr's in
dev_dax->ranges match dev_dax->virt_addr.

Dragons...

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h |  1 +
 drivers/dax/device.c      | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 446617b73aea..894eb1c66b4a 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -63,6 +63,7 @@ struct dax_mapping {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	u64 virt_addr;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 40ba660013cf..6cd79d00fe1b 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -372,6 +372,7 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct device *dev = &dev_dax->dev;
 	struct dev_pagemap *pgmap;
+	u64 data_offset = 0;
 	struct inode *inode;
 	struct cdev *cdev;
 	void *addr;
@@ -426,6 +427,20 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
+	/* Detect whether the data is at a non-zero offset into the memory */
+	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
+		u64 phys = (u64)dev_dax->ranges[0].range.start;
+		u64 pgmap_phys = (u64)dev_dax->pgmap[0].range.start;
+		u64 vmemmap_shift = (u64)dev_dax->pgmap[0].vmemmap_shift;
+
+		if (!WARN_ON(pgmap_phys > phys))
+			data_offset = phys - pgmap_phys;
+
+		pr_notice("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx shift=%llx\n",
+		       __func__, phys, pgmap_phys, data_offset, vmemmap_shift);
+	}
+	dev_dax->virt_addr = (u64)addr + data_offset;
+
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
 	cdev_init(cdev, &dax_fops);
-- 
2.43.0

