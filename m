Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833360;
	b=LNrXH+1DIvyg0YntJlROmaAA3eekYRvkiseFIkWNiK6qFtpvFYUUU+u5KYGl75jp7J61
	 8pdx1Y82e/nSO50cmb+kxZ1PpV4mARa+uW7FFYzG1tDtUMJgOweQ4YPqSDdLkj7cq8BA7
	 lrVEYNbVeVcGlzPg01YPHhEqXWbDjYOGsvp9K7UvK4SV1496QXGtUuLPsQiyu2aJg7vHA
	 e3tRNf4O5R4dRVc4CA/7ffR7RH5nnfFlcq2EzxzyYb2YqjRxkcQbY5I2zkNgGCrxqCe+T
	 RX1HE64Fxx+BPIRR88uPw92l6J6Mxggz2pH3mMGFCprzUnFsxtmRPd1ElwTXOCzTFhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833360;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eeQXc76txxkNChGpsqrLz/1ptGh49tNOgaE3bfTy8GI=;
	b=31h7dRn8t8PVxP058eN8bGShiCLBV+DHy3qWPosGObs20Lije2Lz2QQJnVxbhy/8PRWc
	 z8c12yx97jO9CQBoj4V/hC4AyGclbnkh+amwpjgAyWYMQKtuPbxqBtAcB/WIAQZDvzHQD
	 qiQs3aXKVVMgnbB/nEeJPehjEFA/PoeJgHnyU+3GuYXynlHkt8U63Qqf/q9YC4X9yK/Fn
	 5iQ7s3fe5831IN72wZ7RHLzd34KK10ckbV23vHchkhMklTrJAyAz4hjJaO0xpHFu+Fz8f
	 t/bXoPFzB8C7rhruOvo3QTlHq9sFI7q3EEZhJV7wGpNxBgT4pw30d3EI59yHYnX1Bew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=krlnQMyQ;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBD0606D804
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EBD0606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=krlnQMyQ
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e812e2b31bso7086685ad.3
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833360; x=1794438160; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eeQXc76txxkNChGpsqrLz/1ptGh49tNOgaE3bfTy8GI=;
        b=krlnQMyQt9qgONcVB94j8UzG2pyMDSHGYnMnadPWovuPggN/JYP+C6gaxVcIY6wufx
         CRcPygbab6HRJH1432TNU9HNKsLhhyhedLqHqHwiJfIdeZvdnDa/kcM25EfUMcsLi3mx
         IW5YQKL45FhAmUg1s6OKPydzqyLg3n9gLBc1HMUiVPT083uM2YRurQMg5z1Z4MxqpOqn
         I/qaHLERD+ZLP44omfiQjO/NbAILlkM1Ilb2xx7yMmHYPAya6AWplusjxIvFualY0c7E
         1s5Yhb/5kqEsjvdCQL0/QEGc86Yeb5t4Pw5Lnx5swV0D3RgoJq6ogGaRl844kI7oslrn
         ncVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833360; x=1794438160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eeQXc76txxkNChGpsqrLz/1ptGh49tNOgaE3bfTy8GI=;
        b=uYS3IwXo3LheE5ciC6z9W3CwqsjjS/Kz8O1CeoIyBCvDVepVB7FkDVJFubHv3TXaEv
         A0rKqImC/FsszwU3Brwk0FicG6gQODXPXURs602JuHec/sbOLqaww10QvIqjTRV3l9yL
         WjP/3RkJi6C6xnqShFKY4KRbztV3q0P/s9nwU7bNtHNtnvr96ST88QICYKXtiFegIWs6
         fgeg2KS1mutWqyFCLJRhVQFhwxue0oucQlUaZC1mQ8IGbaFWVq3F+Wf6Da2e6tLDXEDA
         tMrAgOOg+9caqJq2zVcnlAO1ZHwwy4FGQHEAeWqEdELcX4eJebTpNZsnN+N/+i//yZ5S
         VJAw==
X-Gm-Message-State: APuU4Z/Eoj9rZA/isgq9fTdxkpGD8vfDM+pWDhIjY71M1V+KOTSxrXRK
	U4+bodHs+otj/FfY35uHD2l0SQmG+awX86p1U9VmAhGb8v/SwBVkUSmW
X-Gm-Gg: AYBFou3dwPipZcSzh2wNG+n0o/ExI4AWZ4AAbi6U0idLV0X1JNybd7mqJpZjhcLKKbx
	v3aMg4P4Qy85+CkH9MAV1XWrbXqfRt4m38AYI3nbgw1OYskuON1GxXsHnjKgbBqHyumfmFx29Py
	uyWny4M+KLAA343MDVM8vCc0Q7wr9Zo+bBbvBbq0LdQInUZu7eFt/SNg7gHbQqc4xsYQP6Ta7UQ
	W+L8UbK47Ny05JRKpU4s2VeUvuIQIYOSCIQPWBG1/AI2mS0FqdfMeDERy2JqYOafdxBmaaAc9Sn
	ScXCuhu7QpEfFRuQky0byuYMPyC3GvxmMp30LE2SvKIlVZOODk7tktpG16pbNNFt+/uQr7Dixp1
	lhU/TwkDq/asiSSPcwSVFL39JzkrV+lrWOF67o2FpzGA+25DhRs2s9xS2RkGFT24gpeOOqiYYil
	38p9xeKU0x5Jps99ZTGJ5Xn64ma7g/bm5s6ZXVINxJedfxANFkhtM6hLMaEzsh6JDg/s39JgG0i
	ZLXs2JEXz0HIAtm1Z3aVRDOyRki5HXvX36N9gOzgKsxoMMwq5b2kYT/fbPX1P3AH8HuZV4x0OTB
	U9GnQRVy54Jffs3jsRCgFiURMrvymA==
X-Received: by 2002:a17:903:244c:b0:2e5:c563:c0dc with SMTP id d9443c01a7336-2eb364e9f36mr173385085ad.42.1793833359629;
        Wed, 04 Nov 2026 15:02:39 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:38 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v1 03/14] cxl/region: Add dynamic DAX region support
Date: Thu,  5 Nov 2026 08:02:27 +0900
Message-ID: <20261104230445.66625-4-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104230445.66625-1-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

CXL DAX regions must allow memory to be added or removed dynamically
to support DCD. In addition to the quantity of memory available, the
location of the memory within a DC partition is dynamic, based on the
extents offered by a device.  CXL DAX regions must accommodate the
dynamic movement of this memory in the management of DAX regions and
devices.

Introduce the concept of a dynamic DAX region. A dynamic region
carries the shareable and read-only properties of the partitions it
decodes, fixed when the region is created: every endpoint decoder
attached to it must point at a partition with exactly those
properties, and the region's 'mode' reports the matching selector.

A dynamic region has no capacity when it is created, so the DAX device
that cxl_dax_region_probe() creates for every region gets size 0
instead of the region size: a seed that claims no capacity the device
has not offered yet.  Its dax_region is created with IORESOURCE_DAX_DCD
rather than IORESOURCE_DAX_KMEM, so the DAX devices on it bind to
device_dax and not to kmem.

Indicate 0 byte available capacity until such time that capacity is
added.

While DCD is disabled, auto region creation and the region 'target'
write refuse endpoint decoders on a DC partition with -ENXIO, as the
decoder 'mode' write already does. The sysfs entries for manual region
creation follow in a separate patch.

Additionally, dynamic regions complicate the range mapping of dax
devices. There is no known use case for range mapping on dynamic
regions. Avoid the complication by preventing range mapping of dax
devices on dynamic regions.

Interleaving is deferred for now.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |  5 ++-
 drivers/cxl/core/region.c               | 60 ++++++++++++++++++++++---
 drivers/cxl/core/region_dax.c           |  6 +++
 drivers/cxl/cxl.h                       |  4 ++
 drivers/dax/bus.c                       | 10 +++++
 drivers/dax/bus.h                       |  1 +
 drivers/dax/cxl.c                       | 17 ++++++-
 7 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index bcbc44fea6db..69e4f1fa21b7 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -543,7 +543,10 @@ Description:
 		(RO) The mode of a region is established at region creation time
 		and dictates the mode of the endpoint decoder that comprise the
 		region. For more details on the possible modes see
-		/sys/bus/cxl/devices/decoderX.Y/mode
+		/sys/bus/cxl/devices/decoderX.Y/mode. A dynamic capacity
+		region reports the selector it was created with: 'dynamic_ram',
+		'dynamic_ram_shared', 'dynamic_ram_ro' or
+		'dynamic_ram_shared_ro'.
 
 
 What:		/sys/bus/cxl/devices/regionZ/resource
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f4a9839c73d2..fc9139ce358f 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -495,6 +495,11 @@ static int set_interleave_ways(struct cxl_region *cxlr, int val)
 	int save, rc;
 	u8 iw;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM && val != 1) {
+		dev_dbg(&cxlr->dev, "Interleaving and DCD not supported\n");
+		return -EINVAL;
+	}
+
 	rc = ways_to_eiw(val, &iw);
 	if (rc)
 		return rc;
@@ -644,6 +649,8 @@ static ssize_t mode_show(struct device *dev, struct device_attribute *attr,
 		desc = "ram";
 	else if (cxlr->mode == CXL_PARTMODE_PMEM)
 		desc = "pmem";
+	else if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM)
+		desc = cxl_dc_mode_name(cxlr->shareable, cxlr->read_only);
 	else
 		desc = "";
 
@@ -2080,6 +2087,20 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 		return -EINVAL;
 	}
 
+	/* A DC region's flavor is fixed; every member partition must match */
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM) {
+		struct cxl_dpa_partition *part = &cxlds->part[cxled->part];
+
+		if (part->shareable != cxlr->shareable ||
+		    part->read_only != cxlr->read_only) {
+			dev_dbg(&cxlr->dev, "%s: partition is %s, region is %s\n",
+				dev_name(&cxled->cxld.dev),
+				cxl_dc_mode_name(part->shareable, part->read_only),
+				cxl_dc_mode_name(cxlr->shareable, cxlr->read_only));
+			return -EINVAL;
+		}
+	}
+
 	/* all full of members, or interleave config not established? */
 	if (p->state > CXL_CONFIG_INTERLEAVE_ACTIVE) {
 		dev_dbg(&cxlr->dev, "region already active\n");
@@ -2411,6 +2432,7 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 	if (sysfs_streq(buf, "\n"))
 		rc = detach_target(cxlr, pos);
 	else {
+		struct cxl_endpoint_decoder *cxled;
 		struct device *dev;
 
 		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
@@ -2422,8 +2444,14 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 			goto out;
 		}
 
-		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
-				   TASK_INTERRUPTIBLE);
+		cxled = to_cxl_endpoint_decoder(dev);
+		if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM &&
+		    !cxled_dcd_enabled(cxled)) {
+			dev_dbg(dev, "DCD not enabled\n");
+			rc = -ENXIO;
+			goto out;
+		}
+		rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
 out:
 		put_device(dev);
 	}
@@ -2737,6 +2765,8 @@ void kill_regions(struct cxl_root_decoder *cxlrd)
  * @cxlrd: root decoder
  * @id: memregion id to create, or memregion_free() on failure
  * @mode: mode for the endpoint decoders of this region
+ * @shareable: dynamic region: its partitions must be shareable
+ * @read_only: dynamic region: its partitions must be read-only
  * @type: select whether this is an expander or accelerator (type-2 or type-3)
  *
  * This is the second step of region initialization. Regions exist within an
@@ -2748,7 +2778,8 @@ void kill_regions(struct cxl_root_decoder *cxlrd)
 static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 					      int id,
 					      enum cxl_partition_mode mode,
-					      enum cxl_decoder_type type)
+					      enum cxl_decoder_type type,
+					      bool shareable, bool read_only)
 {
 	struct cxl_port *port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
 	struct cxl_region *cxlr;
@@ -2760,6 +2791,8 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 		return cxlr;
 	cxlr->mode = mode;
 	cxlr->type = type;
+	cxlr->shareable = shareable;
+	cxlr->read_only = read_only;
 
 	dev = &cxlr->dev;
 	rc = dev_set_name(dev, "region%d", id);
@@ -2803,7 +2836,8 @@ static ssize_t create_ram_region_show(struct device *dev,
 
 static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 					  enum cxl_partition_mode mode, int id,
-					  enum cxl_decoder_type target_type)
+					  enum cxl_decoder_type target_type,
+					  bool shareable, bool read_only)
 {
 	int rc;
 
@@ -2813,6 +2847,7 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 	switch (mode) {
 	case CXL_PARTMODE_RAM:
 	case CXL_PARTMODE_PMEM:
+	case CXL_PARTMODE_DYNAMIC_RAM:
 		break;
 	default:
 		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
@@ -2828,7 +2863,8 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 		return ERR_PTR(-EBUSY);
 	}
 
-	return devm_cxl_add_region(cxlrd, id, mode, target_type);
+	return devm_cxl_add_region(cxlrd, id, mode, target_type, shareable,
+				   read_only);
 }
 
 static ssize_t create_region_store(struct device *dev, const char *buf,
@@ -2846,7 +2882,8 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if ((rc = ACQUIRE_ERR(mutex_intr, &regions_lock)))
 		return rc;
 
-	cxlr = __create_region(cxlrd, mode, id, CXL_DECODER_HOSTONLYMEM);
+	cxlr = __create_region(cxlrd, mode, id, CXL_DECODER_HOSTONLYMEM,
+			       false, false);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -3808,10 +3845,18 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 	if (part < 0)
 		return ERR_PTR(-EBUSY);
 
+	if (cxlds->part[part].mode == CXL_PARTMODE_DYNAMIC_RAM &&
+	    !cxled_dcd_enabled(cxled)) {
+		dev_dbg(&cxled->cxld.dev, "DCD not enabled\n");
+		return ERR_PTR(-ENXIO);
+	}
+
 	do {
 		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
 				       atomic_read(&cxlrd->region_id),
-				       cxled->cxld.target_type);
+				       cxled->cxld.target_type,
+				       cxlds->part[part].shareable,
+				       cxlds->part[part].read_only);
 	} while (IS_ERR(cxlr) && PTR_ERR(cxlr) == -EBUSY);
 
 	if (IS_ERR(cxlr)) {
@@ -4262,6 +4307,7 @@ static int cxl_region_probe(struct device *dev)
 
 		return devm_cxl_add_pmem_region(cxlr);
 	case CXL_PARTMODE_RAM:
+	case CXL_PARTMODE_DYNAMIC_RAM:
 		rc = devm_cxl_region_edac_register(cxlr);
 		if (rc)
 			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
index de04f78f6ad8..47c9c52a3902 100644
--- a/drivers/cxl/core/region_dax.c
+++ b/drivers/cxl/core/region_dax.c
@@ -84,6 +84,12 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	struct device *dev;
 	int rc;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM &&
+	    cxlr->params.interleave_ways != 1) {
+		dev_dbg(&cxlr->dev, "Interleaving DC not supported\n");
+		return -EINVAL;
+	}
+
 	struct cxl_dax_region *cxlr_dax __free(put_cxl_dax_region) =
 		cxl_dax_region_alloc(cxlr);
 	if (IS_ERR(cxlr_dax))
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index baa6df2d362a..d098f7f50bef 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -490,6 +490,8 @@ struct cxl_region_params {
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
  * @flags: Region state flags
+ * @shareable: (for DC regions) backing partitions must be shareable
+ * @read_only: (for DC regions) backing partitions must be read-only
  * @params: active + config params for the region
  * @coord: QoS access coordinates for the region
  * @node_notifier: notifier for setting the access coordinates to node
@@ -506,6 +508,8 @@ struct cxl_region {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
 	unsigned long flags;
+	bool shareable;
+	bool read_only;
 	struct cxl_region_params params;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index e40c25401cf0..d8cc1c012f46 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -177,6 +177,11 @@ static bool is_static(struct dax_region *dax_region)
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
 }
 
+static bool is_dcd(struct dax_region *dax_region)
+{
+	return (dax_region->res.flags & IORESOURCE_DAX_DCD) != 0;
+}
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
@@ -300,6 +305,9 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 
 	lockdep_assert_held(&dax_region_rwsem);
 
+	if (is_dcd(dax_region))
+		return 0;
+
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
 	return size;
@@ -1389,6 +1397,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 		return 0;
 	if (a == &dev_attr_mapping.attr && is_static(dax_region))
 		return 0;
+	if (a == &dev_attr_mapping.attr && is_dcd(dax_region))
+		return 0;
 	if ((a == &dev_attr_align.attr ||
 	     a == &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index bfc31923f3ff..c877daa8df51 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -15,6 +15,7 @@ struct dax_region;
 /* dax bus specific ioresource flags */
 #define IORESOURCE_DAX_STATIC BIT(0)
 #define IORESOURCE_DAX_KMEM BIT(1)
+#define IORESOURCE_DAX_DCD BIT(2)
 
 #define DAX_KMEM_UNPLUGGED	(-1) /* Do not create memory blocks */
 
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 3ab39b77843d..43eb18c8a035 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -13,19 +13,32 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct cxl_region *cxlr = cxlr_dax->cxlr;
 	struct dax_region *dax_region;
 	struct dev_dax_data data;
+	resource_size_t dev_size;
+	unsigned long flags;
 
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM)
+		flags = IORESOURCE_DAX_DCD;
+	else
+		flags = IORESOURCE_DAX_KMEM;
+
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, IORESOURCE_DAX_KMEM);
+				      PMD_SIZE, flags);
 	if (!dax_region)
 		return -ENOMEM;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM)
+		/* Add empty seed dax device */
+		dev_size = 0;
+	else
+		dev_size = range_len(&cxlr_dax->hpa_range);
+
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
 		.id = -1,
-		.size = range_len(&cxlr_dax->hpa_range),
+		.size = dev_size,
 		.memmap_on_memory = true,
 	};
 
-- 
2.43.0

