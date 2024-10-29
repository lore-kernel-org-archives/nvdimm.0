Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5F720C027
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234153; cv=none; b=bszhS5cvPI8qrlKSoCkCVemdgGlhkFMT40LdotA52CtsidFPFi8xZdqgQxtk++VL5q3G/oEaPsHylwGqaVBnRNBhI9MjB5TxyO7gfUShUNG9vBCg37pNbW7vTVBR+HqWJUcvvYxxPI/pQPIPjuTo3hPGAIfwMTIW0opN2G14g5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234153; c=relaxed/simple;
	bh=46g4ZTNho8GbO0JpBsREVXeW/uwwpZ1EJb9rS5EEwsg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q4SSOmjSZrlgCuEL62k4o014LSceAo7LyeE5NESK7MfALFoJT02MKu2CZSHY7qoHJcmApDjxRmru+liCqs3cprCWI6fbf/CO3hyHKT+/yACdiD5riui0ri10t3OdtEaJyFwMcPRd7RCzAx5b624cL6f+84Pwz6DhMEg50rj059g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XwgcIMUk; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XwgcIMUk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234151; x=1761770151;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=46g4ZTNho8GbO0JpBsREVXeW/uwwpZ1EJb9rS5EEwsg=;
  b=XwgcIMUknbTKHG7ca+egxejomobf2FiUXX96h/y5NCyvXnk4R3OpLi6I
   Xp8hmi7jEgnNzWKzblz/OV9bus6zd5cWGTomLI/G3o+1fbJyGaLYwiSUA
   Uk9d0woMB0RvlGEF7teEaMao/3ghw0RWqTalbwpBxW9v+mcis8/uZYF1J
   lOBu32t//4/NvYGpxW9iBEA2EHb5tzDBZFsMs+AE0X+npHDfY7aQPh9rb
   Mr/WLQWuX3hjd+WH+pe+YH2c2YcnDogGHrrBCETo5iFhYYdvqCA+pY+Ry
   3AvHCsJSHGTCHo9IYs9SUqpAn7AV4swwFAKXZyDHjQw8IeXdTuMKlLqhG
   g==;
X-CSE-ConnectionGUID: ua3SWkgTQAm/BeDHbQ663A==
X-CSE-MsgGUID: 6LBKkOzFTCmTxnvR1UGlIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52457576"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52457576"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:51 -0700
X-CSE-ConnectionGUID: kO2aDaLwSPaT0QrdHspSPA==
X-CSE-MsgGUID: yP4L2XhZRlyYQxxw05ANLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="119561229"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:49 -0700
From: ira.weiny@intel.com
Date: Tue, 29 Oct 2024 15:34:49 -0500
Subject: [PATCH v5 14/27] cxl/port: Add endpoint decoder DC mode support to
 sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-14-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=6348;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=2wr9/O/HF4I86fzqG9Geyg6KBxvyobTU1ujZTnZ2vD0=;
 b=9K8cm3jJPZgfpZPS7o49JDcPpbvVVicMtpAOlXHEK21dGWKZx0Z2cMH4el5PjU3/ERK0xcqMl
 iuJpMfdKTg6BtSXRtzDEUu7DrLl4EyGv3H/Y4x0IZZnQXavubrnRrdI
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Endpoint decoder mode is used to represent the partition the decoder
points to such as ram or pmem.

Expand the mode to allow a decoder to point to a specific DC partition
(Region).

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: push sysfs versions to 6.13]
[Jonathan: adjust to the use of guard()]
[Jonathan: clean up documentation]
[Jonathan: adjust decoder mode enum]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 25 +++++++++++++------------
 drivers/cxl/core/hdm.c                  | 16 ++++++++++++++++
 drivers/cxl/core/port.c                 | 16 +++++++++++-----
 drivers/cxl/cxl.h                       | 33 +++++++++++++++++----------------
 4 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index ff3ae83477f0876c0ee2d3955d27a11fa9d16d83..8d990d702f63363879150cf523c0be6229f315e0 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -361,23 +361,24 @@ Description:
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/mode
-Date:		May, 2022
-KernelVersion:	v6.0
+Date:		May, 2022, October 2024
+KernelVersion:	v6.0, v6.13 (dcY)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
-		translates from a host physical address range, to a device local
-		address range. Device-local address ranges are further split
-		into a 'ram' (volatile memory) range and 'pmem' (persistent
-		memory) range. The 'mode' attribute emits one of 'ram', 'pmem',
-		'mixed', or 'none'. The 'mixed' indication is for error cases
-		when a decoder straddles the volatile/persistent partition
-		boundary, and 'none' indicates the decoder is not actively
-		decoding, or no DPA allocation policy has been set.
+		translates from a host physical address range, to a device
+		local address range. Device-local address ranges are further
+		split into a 'ram' (volatile memory) range, 'pmem' (persistent
+		memory) range, and Dynamic Capacity (DC) ranges. The 'mode'
+		attribute emits one of 'ram', 'pmem', 'dcY', 'mixed', or
+		'none'. The 'mixed' indication is for error cases when a
+		decoder straddles partition boundaries, and 'none' indicates
+		the decoder is not actively decoding, or no DPA allocation
+		policy has been set.
 
 		'mode' can be written, when the decoder is in the 'disabled'
-		state, with either 'ram' or 'pmem' to set the boundaries for the
-		next allocation.
+		state, with 'ram', 'pmem', or 'dcY' to set the boundaries for
+		the next allocation.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 998aed17d7e47fc18a05fb2e8cca25de0e92a6d4..40799a0ca1d7af89b9af53cc098381e83b8c7e82 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -548,6 +548,7 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 	switch (mode) {
 	case CXL_DECODER_RAM:
 	case CXL_DECODER_PMEM:
+	case CXL_DECODER_DC0 ... CXL_DECODER_DC7:
 		break;
 	default:
 		dev_dbg(dev, "unsupported mode: %d\n", mode);
@@ -571,6 +572,21 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 		return -ENXIO;
 	}
 
+	if (mode >= CXL_DECODER_DC0 && mode <= CXL_DECODER_DC7) {
+		struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+		int index;
+
+		index = dc_mode_to_region_index(mode);
+		if (!resource_size(&cxlds->dc_res[index])) {
+			dev_dbg(dev, "no available dynamic capacity\n");
+			return -ENXIO;
+		}
+		if (mds->dc_region[index].shareable) {
+			dev_err(dev, "DC region %d is shareable\n", index);
+			return -EINVAL;
+		}
+	}
+
 	cxled->mode = mode;
 	return 0;
 }
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 85b912c11f04d2c743936eaac1f356975cb3cc71..2f42c8717a65586c769f0fd2016e8addc2552f9d 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -205,11 +205,17 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
 	enum cxl_decoder_mode mode;
 	ssize_t rc;
 
-	if (sysfs_streq(buf, "pmem"))
-		mode = CXL_DECODER_PMEM;
-	else if (sysfs_streq(buf, "ram"))
-		mode = CXL_DECODER_RAM;
-	else
+	for (mode = 0; mode < CXL_DECODER_MODE_MAX; mode++)
+		if (sysfs_streq(buf, cxl_decoder_mode_names[mode]))
+			break;
+
+	if (mode == CXL_DECODER_NONE ||
+	    mode == CXL_DECODER_DEAD ||
+	    mode == CXL_DECODER_MODE_MAX)
+		return -EINVAL;
+
+	/* Not yet supported */
+	if (mode >= CXL_DECODER_MIXED)
 		return -EINVAL;
 
 	rc = cxl_dpa_set_mode(cxled, mode);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 8b7099c38a40d842e4f11137c3e9107031fbdf6a..486ceaafa85c3ac1efd438b6d6b9ccd0860dde45 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -380,27 +380,28 @@ enum cxl_decoder_mode {
 	CXL_DECODER_DC7,
 	CXL_DECODER_MIXED,
 	CXL_DECODER_DEAD,
+	CXL_DECODER_MODE_MAX,
+};
+
+static const char * const cxl_decoder_mode_names[] = {
+	[CXL_DECODER_NONE] = "none",
+	[CXL_DECODER_RAM] = "ram",
+	[CXL_DECODER_PMEM] = "pmem",
+	[CXL_DECODER_DC0] = "dc0",
+	[CXL_DECODER_DC1] = "dc1",
+	[CXL_DECODER_DC2] = "dc2",
+	[CXL_DECODER_DC3] = "dc3",
+	[CXL_DECODER_DC4] = "dc4",
+	[CXL_DECODER_DC5] = "dc5",
+	[CXL_DECODER_DC6] = "dc6",
+	[CXL_DECODER_DC7] = "dc7",
+	[CXL_DECODER_MIXED] = "mixed",
 };
 
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 {
-	static const char * const names[] = {
-		[CXL_DECODER_NONE] = "none",
-		[CXL_DECODER_RAM] = "ram",
-		[CXL_DECODER_PMEM] = "pmem",
-		[CXL_DECODER_DC0] = "dc0",
-		[CXL_DECODER_DC1] = "dc1",
-		[CXL_DECODER_DC2] = "dc2",
-		[CXL_DECODER_DC3] = "dc3",
-		[CXL_DECODER_DC4] = "dc4",
-		[CXL_DECODER_DC5] = "dc5",
-		[CXL_DECODER_DC6] = "dc6",
-		[CXL_DECODER_DC7] = "dc7",
-		[CXL_DECODER_MIXED] = "mixed",
-	};
-
 	if (mode >= CXL_DECODER_NONE && mode <= CXL_DECODER_MIXED)
-		return names[mode];
+		return cxl_decoder_mode_names[mode];
 	return "mixed";
 }
 

-- 
2.47.0

