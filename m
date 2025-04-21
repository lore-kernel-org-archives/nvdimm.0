Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF241448E3
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199246; cv=none; b=CIX+Yl0/fsVMOVRLSKJhWsTlYMrfUpzmZ04Em773dJtjP0tB+0cGCs4Tkm6P2qdLebgEj66d4cvtQVUf+OJlZNn+SW7Wgp6qNtCx7OD/oQp3cWtk8bI04HsfraXOVeYM+citDbcknJbeKMkHfzeXYKRK2nF8Ep/i1KkkB0rdFd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199246; c=relaxed/simple;
	bh=SM8Xj4dnyYwoGjDXor6hvaRx7QAO8yyyxbfokVYE+S8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l0qv1Qr9j/o9FGSs/vM5K8SFE3sYRk5Ow4BsqLv25L719/ydWxxSb5bG1gq760KZueRBTOfo/hqPGvC6x/zPVu1rwQFfjSnfnQLk3qMVh70ebx8kTryC8IbWKhNI2RIC/t9i8Jnlp4WDWlbqAJEQIBsforktP7oCbhOUjcEZg8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gEQroFsj; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEQroFsj"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-72c173211feso1009080a34.1
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199244; x=1745804044; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJswZ+V2KGwmP5G+n4PEaC6MizB6DbX3hqjndqhvdZU=;
        b=gEQroFsjjXZdlYqldvYJ0KD5Z/UFArOyowy6cCGnftCTKYbmlq9XZDPe0ymRFNwEwx
         6XXoc+Noxog8uVSjVqGNQ1hoXlmOL3Z4OAhrjeiqz0bZFBQ9NeXyfpiJerJa79w1xZqD
         CBMHFFlaNSR2Kmrhgg8pfo6+CoKGpKlETGCVKwKE8IrrnTGOVbUlOJ8FWwtMAD2kNj+p
         YtiHZy6mQg2z8xe1gfEDIWuuMJxPZBAXX+vByAMCmg0tjcr5N2t9PDe+gi2qemTezB8d
         tKkzMRwOQnKmEUhvo9c+7uRE0qEm++WdgNAcoQdJK7uqHPumfhLbWHb93xRDv620Z/9v
         FBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199244; x=1745804044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJswZ+V2KGwmP5G+n4PEaC6MizB6DbX3hqjndqhvdZU=;
        b=aWuCarFb3xiMHZC3EysAuM5ACRw7NSxWGp8wY0iOR7oAyXMJnTBShRYJgDQoxd7Xnr
         sb71K49CZbzmndt5cUGlcpvfThmR9H5LN53cYFTe5wTthZihJeXt07SnkFegiOIriyJT
         NRxOFcs/IWRZlIt7IiY08l3OB6Y9COa3AcDFcEBIzhagyYNFSgee4T9pplyAx9Byi82S
         fmkaY6glJz9Y6osRCuYbmsf8CmVQPyDmO6oQePfmRl3hYJoZs7pdUje10KRKEuUbrZQ2
         02GjUSyuoiSdSIhpNOCmGZ6GlL6G/aVJacjn/cJjMqjwHB7+CCbJcq1voTpcChU7rA0W
         eVbQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5TQS0XbClD7C1w8lJcIQYWDaQnmt6UbDyJNPIvDoh1X1XLkQxjs++lxi97CDYwFUikYWvtfg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/++m0I/xy/MhElkh/0nxdmMauNxY+GtZEEX4UofF1CxvB+hiI
	T0TiV8L2tJG6V8iOltcD2ThAGaAaWrV1em+7xO0BzAqHx5YrPKGX
X-Gm-Gg: ASbGncuY+QI9VRBcMzVqPBO7cmqvamNLea7ONjdoiN4/sUPkWHGRNJ8HtPZgCPSwl8d
	TkW20OMLSAgcRH8S0IS/EocOvKZYjEl17qC3cI3IdMLxJc7imvGgZ4tcC2jW0Q9JI199nSz8sNL
	YsrNpr5Uvu2GQQ6nuAFpOEaPpbuoIOf641KxfgQFsmPmSHWKEbkksUUhzNPouVCCOHWJpuawujT
	DIT6/PISIiAn57lExF3pEurC+gwIjSL5gDXbxkmeupmuTdobrN0DCD6OBE/2FeLvfXMXF2HqGLj
	TGsZQZHiSgAVKMFdPaqP5gRb1wczAGCWjjLBg90lQQdO/5xd+mpVi10Z5wpQNTg8UuGGPg==
X-Google-Smtp-Source: AGHT+IHRSyjVpRQa2MLAEuuQnotFbd3RCybPdxGlv+ddIkS2NgjbTnLA8P/hoj1HDXSaxjqDyXt1wQ==
X-Received: by 2002:a05:6830:71a6:b0:72b:8c4b:8ef2 with SMTP id 46e09a7af769-7300635568amr5548316a34.24.1745199243747;
        Sun, 20 Apr 2025 18:34:03 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:03 -0700 (PDT)
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
	Luis Henriques <luis@igalia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Vorel <pvorel@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
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
Subject: [RFC PATCH 03/19] dev_dax_iomap: Save the kva from memremap
Date: Sun, 20 Apr 2025 20:33:30 -0500
Message-Id: <20250421013346.32530-4-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
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

