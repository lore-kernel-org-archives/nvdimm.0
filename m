Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C125D21FD88
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013143; cv=none; b=qQzgXs4B+msXuXJyF6ld31hMYDSIOxij5yq2d94GJrF03F6uhEiP8RPxt3Xeh1UpOFMV80U/BncTUIQHZYgmHvVy0mHicOLG93Aj5L2K7OGD2TMYupzNWfnCcUO70Ip2Krit5QY7suvXQynAnV8hRfTAZB34b0cjpGPUzrt3fgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013143; c=relaxed/simple;
	bh=Ik5VP6IO2+Sl0l25uKW5XK4yMsZRV1pydB1PU8xjNlw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uo6GDKu9+CwAjMzvngPVlsSc733zmjPEYjmVkFXrf4291DxfRV3jtTGFUL35FthMoPQk3Ysw40VLobOfcHRDfypuWmLMh9hCX9hxsebXbavESEcLWidB2ce0X5ourbnrPJdb6hroRAK84/CMxiiWY7VXyQTXK8oG38cK2F4ErTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6IdT50R; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6IdT50R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013142; x=1762549142;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=Ik5VP6IO2+Sl0l25uKW5XK4yMsZRV1pydB1PU8xjNlw=;
  b=W6IdT50Ra9pREod3GmWgi7avVByNJ99wNhUG+iBY2rwCJWtlJm/pEblx
   UPTJ7ulzJT1LcWdfSBV3TarC5L5aFooVJNCyC1ItRU77zyB/34bKwduyu
   AXU302tZyVrnIvKKFbT/FMcs36BBPrHYC2LGJoc9iLW15DYPIVWWweDt+
   7zTSU034WaNhvi1J0w43kopJ5lh6uXkKWnD2hs3CX38QYwl4/Ktt9Bep+
   PYjyLwyUxqDbySkHyHxzLh75OE+Xty8t5XY22iTwIzgv2PaZtLhHm9Is4
   mGSPfO5AtK8DJo0kyJtp0OeTwjU9IpCvZkC8wZYvlNntKm0ZVWzJjNkG+
   A==;
X-CSE-ConnectionGUID: DmTi/VlgRbqvqVM0b3Y8iA==
X-CSE-MsgGUID: ag2YF3zxS2qGGP9S55Ripw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41441031"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41441031"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:01 -0800
X-CSE-ConnectionGUID: lz4+fpn1ScionhH4NHQWNw==
X-CSE-MsgGUID: 2CJK7N7CRbGSZC1UNxGxAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122746019"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:00 -0800
From: ira.weiny@intel.com
Date: Thu, 07 Nov 2024 14:58:32 -0600
Subject: [PATCH v7 14/27] cxl/port: Add endpoint decoder DC mode support to
 sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-14-56a84e66bc36@intel.com>
References: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
In-Reply-To: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=6278;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=94u2ZU2KhMC3r6DSXpzSgMHBRS/GwJgXxPJvIMLN8II=;
 b=2aZqFInzys18Fq7saOEVE0AWy8pltLOhHq0t5Hahs2aV2DX/WJ48z62XRZeutKqiKv4vKH3Yp
 B2T7uZXfd5/B2j7ejSx+GdM2EiuI5hrY4OXqnPiLTAbzGAd6K152gGo
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
[Carpenter/smatch: fix cxl_decoder_mode_names array]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 25 ++++++++++++------------
 drivers/cxl/core/hdm.c                  | 16 ++++++++++++++++
 drivers/cxl/core/port.c                 | 16 +++++++++++-----
 drivers/cxl/cxl.h                       | 34 +++++++++++++++++----------------
 4 files changed, 58 insertions(+), 33 deletions(-)

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
index 8b7099c38a40d842e4f11137c3e9107031fbdf6a..46cc5ba502b2c46c68fd81c48b06f76f33282878 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -380,27 +380,29 @@ enum cxl_decoder_mode {
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
+	[CXL_DECODER_DEAD] = "dead",
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

