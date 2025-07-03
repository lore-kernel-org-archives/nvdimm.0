Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749802F3642
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568648; cv=none; b=VOP320XueRqQhMg2xkCzan1jmAqslI2NOqvpWJE9ukLXcEYBVN0tUWwQSMCWqJ5hFIBR9Rj9wTIcrtP/6asR2/l17TH3i92dtcaXpFSIvU+DDYpq7zb53Ylu2Gd8fy351xzvpjZ52JsHbTSyeQfW9G3Ct9b4JPPzz/zYbh4OcQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568648; c=relaxed/simple;
	bh=SM8Xj4dnyYwoGjDXor6hvaRx7QAO8yyyxbfokVYE+S8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qha20TER0Jd9W50ULEVLB2UNy3aIWhc8TJU3mrTvvoS63/rTuu2SQ0QB98y13RyHajXJRB+IJVF5QXFEF4qwDOSkuuVW0q1mfR5bphRfTHVAFh3OqdbYUkeLMCmQilnb4FA7rOZMVDTeOXfZZyKVMlfcBVtj9frLFA9f2gHnAhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ACRwtuPR; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACRwtuPR"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7382a999970so144715a34.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568645; x=1752173445; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJswZ+V2KGwmP5G+n4PEaC6MizB6DbX3hqjndqhvdZU=;
        b=ACRwtuPRPTUNlFB14jgGQtQ0FayWk/lyuu73WsmSkxrNY+riSYQScDhj9pf2YMwhzi
         Z+SCKZm3vqJ0wyIIZgyv5RsVoES8B7+UAIayyJgj5zrItIukPcJAxBUgDzVcpAg1ezJA
         VyMzlRlFFj6SmIdXOllBaovtS7cQsJ4++eNgOKwcCKVBtjetwJcIhtAbptPIfo0D5Fix
         byp5DkyKMF7qDNP2YFcnzgFpmA+ZK8E6J9ITDKUK1f74au5Wih8fYuLus3Mn5cZTXbsX
         sSD5Z2fyGzWZWR3F1FPJ1xDxrNNSEFYQQQB0KzAoaoTkGAa3kUKMfzHLe8a6aaG8rG/q
         asRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568645; x=1752173445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJswZ+V2KGwmP5G+n4PEaC6MizB6DbX3hqjndqhvdZU=;
        b=ABRuIxhyFVj8aTDhtQJATG9b/VSOaFgpj1ATMEWx0lKP7c/Bt5OLn7WvDQxCDW30Zj
         cN1k7q0pCRQlr03ghPWHsQvncm+oJLqX8+BbqEvV2hctsWj3RfzZXdN4HWIhzQkhmeBA
         fdeCHQINPTQfS8ryWTDTPEYou8t7OJGNmOPPAKUQuJkLHIF2U2b8nfd4eCZgthXVDwpu
         eDh7xOTh7PbkzJJ685lsMaj/bfVZ/oNucaURr/ymgLfmfED+24SD9AUWjbifPBxysBEV
         a+KlJPMuJwpKNrV/7fz7GJ1Iicnchb76x2JQBbr1p9moF0JgCD295WyN6XOmC/P1Yrkj
         IwdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUy5odMmsx2elMXaKLDYnOZ6x3dSGvW4Z6b+kj2nXhvDi1ZemXrGUahUIbdlr29/v3/l3gI/8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeaJAOW7JWCAlDabvr14fZq64LRJtKWZ/TQ5zR2RzNGPcr/GsI
	pOpcc72QsxIEVXHZsynEFEorfnilJWlN8yf8oVX1hEn8Fvk0XiGsAd7H
X-Gm-Gg: ASbGncuNd3GMIYYHh2k3fFcbEAqcWMa8pu6WBHq8F1apaKOwmzXszIwNtXUVW/5KRHL
	D/QMQIf8WJ2Yj7TxPZSBEr3x8ltziaZDQltGETltvb/3SyE0zWdGDsyzvVupOdXQN2k81xVK+ds
	ywMJErh6DZcFMNf2c9Qup2luwcWGMN+bwSkERUdEw8s9vw+nr5hTd500GjgpYt/JR2WXKO5neEx
	MrZfidhH+4tKlhhVlFhqKbIFaDp5XcjlS5MADTTcnLSSSDkmY/hFfdcq778krtTB9JyIk33Qv3x
	4HoLhonOKEqEhwuyPFarJmxxPm/NpaB+TiiywcPHC3zuVpyW6b1kIWogoHopcuNN21QuyCSBdqy
	QbgICjrRbJ7t9HXd+uWhRKEwO
X-Google-Smtp-Source: AGHT+IGf6EnisMiDGZyZbVSv29Y7ewVQGRvUqtA17icw2gxtyfeO9BNRhEvAJBrTRu+vFRFvecQ+Zw==
X-Received: by 2002:a05:6830:2c07:b0:727:24ab:3e4 with SMTP id 46e09a7af769-73c8c248e02mr2426451a34.9.1751568645493;
        Thu, 03 Jul 2025 11:50:45 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.50.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:50:45 -0700 (PDT)
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
Subject: [RFC V2 03/18] dev_dax_iomap: Save the kva from memremap
Date: Thu,  3 Jul 2025 13:50:17 -0500
Message-Id: <20250703185032.46568-4-john@groves.net>
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

Save the kva from memremap because we need it for iomap rw support.

Prior to famfs, there were no iomap users of /dev/dax - so the virtual
address from memremap was not needed.

Also: in some cases dev_dax_probe() is called with the first
dev_dax->range offset past the start of pgmap[0].range. In those cases
we need to add the difference to virt_addr in order to have the physaddr's
in dev_dax->ranges match dev_dax->virt_addr.

This happens with devdax devices that started as pmem and got converted
to devdax. I'm not sure whether the offset is due to label storage, or
page tables, but this works in all known cases.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h |  1 +
 drivers/dax/device.c      | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..2a6b07813f9f 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -81,6 +81,7 @@ struct dev_dax_range {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	void *virt_addr;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 29f61771fef0..583150478dcc 100644
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
+		u64 phys = dev_dax->ranges[0].range.start;
+		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
+		u64 vmemmap_shift = dev_dax->pgmap[0].vmemmap_shift;
+
+		if (!WARN_ON(pgmap_phys > phys))
+			data_offset = phys - pgmap_phys;
+
+		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx shift=%llx\n",
+		       __func__, phys, pgmap_phys, data_offset, vmemmap_shift);
+	}
+	dev_dax->virt_addr = addr + data_offset;
+
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
 	cdev_init(cdev, &dax_fops);
-- 
2.49.0

