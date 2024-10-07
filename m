Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28EC1DE8BA
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343036; cv=none; b=kxu/ySFZTwq9jHYl/s1zS5d8dAFV5IP3WheD31GRZrMSecaOiNaf3eN7SSmCFvbwlNT8hr0SLZlBUTtQIszF5Gn4zqWq6e3ZxbsQlUlcXMu/gd0lY39CcgxCMbsWUdAJ28ugtgUX+n8VZAKdp1tP7e6Ln5KvNI6gGR5tMz2Y7sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343036; c=relaxed/simple;
	bh=qM1m2pUoXc1sppU1JLZj43ZFqNMSdAopy9UnAspqefc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OKM3Poc36GJ4C5QPwsO8CGVLOAb5iZSJ8APiXSyTUtxmvChFhD8geSdnTRxhaK5fuHZz8r9fjPpP//FrSmo4ibqEv7Vc2My8SUez76F8/otCbnT3NYIx0esULjrgPpiMkNnXxdDQapmqBocRFhmnaU9Ehg4o4cMm3gVEi9ctoZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2KUi5Q1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2KUi5Q1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343034; x=1759879034;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=qM1m2pUoXc1sppU1JLZj43ZFqNMSdAopy9UnAspqefc=;
  b=a2KUi5Q1JcyLXOFKYZT/8d5r8vETeNSr2TMb50KvgBEF9XxsotpxUh4n
   aRUI9Hh/IIo6AegHLMkSb0KxjmIIEOEm8DmUnOGXbSKAl9gIXTfM5cU7O
   4ANErNwZSz2VxB3GDmkH8Sb10BZFfokA/VBVoVEHy2bgUkY32Kv+N66Re
   WE7cBYS2X1Z6E831aS+GVlYg6rbxiiGWdKcoSDn4dbuGaAqY6I1mCgMxT
   Weukpzsp9010c9v/J3iCSb65gg768jNQXLCoATZFnNYR6siiDUG90Su4K
   5E7thjdwhbD8hY7UlP9Y+wppKuyu3MtxRqqI2frO4xQXdGw4cQoY+Uiaf
   Q==;
X-CSE-ConnectionGUID: lfsY/k4FSHqmayo+zuQy+Q==
X-CSE-MsgGUID: m1cLwkhZQd29vJFuwJAyiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45036935"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="45036935"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:56 -0700
X-CSE-ConnectionGUID: Dt9TywtCSseXAQLBDOVlYw==
X-CSE-MsgGUID: DScO9GQAQNqI8BhRan2C2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75309125"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:53 -0700
From: ira.weiny@intel.com
Date: Mon, 07 Oct 2024 18:16:20 -0500
Subject: [PATCH v4 14/28] cxl/port: Add endpoint decoder DC mode support to
 sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-14-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=6365;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=Wwal7/W3GJZGdURNsctdKcS4fKs7rhYXMIZP02QRH3o=;
 b=zdEvJtKSunr0PYy8vb9F9YYsIOWBWEPxjtGNZRbAxN3Rf+sbfGW1Yv5dkQ54KwwT/BTgO7Jnr
 E5y0bPWJHm4B1ovwrsmGjlnFd32E1R9YcDePGRW4w0j81Ifygsdcoxt
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Endpoint decoder mode is used to represent the partition the decoder
points to such as ram or pmem.

Expand the mode to allow a decoder to point to a specific DC partition
(Region).

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: prevent creation of region on shareable DC partitions]
[Fan: change mode range logic]
[Fan: use !resource_size()]
[djiang: use the static mode name string array in mode_store()]
[Jonathan: remove rc check from mode to region index]
[Jonathan: clarify decoder mode 'mixed']
[djbw: drop cleanup patch and just follow the convention in cxl_dpa_set_mode()]
[fan: make dcd resource size check similar to other partitions]
[djbw, jonathan, fan: remove mode range check from dc_mode_to_region_index]
[iweiny: push sysfs versions to 6.12]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 21 ++++++++++----------
 drivers/cxl/core/hdm.c                  | 17 ++++++++++++++++
 drivers/cxl/core/port.c                 | 10 +++++-----
 drivers/cxl/cxl.h                       | 35 ++++++++++++++++++---------------
 4 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index b865eefdb74c..661dab99183f 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -361,23 +361,24 @@ Description:
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/mode
-Date:		May, 2022
-KernelVersion:	v6.0
+Date:		May, 2022, October 2024
+KernelVersion:	v6.0, v6.12 (dcY)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
 		translates from a host physical address range, to a device local
 		address range. Device-local address ranges are further split
-		into a 'ram' (volatile memory) range and 'pmem' (persistent
-		memory) range. The 'mode' attribute emits one of 'ram', 'pmem',
-		'mixed', or 'none'. The 'mixed' indication is for error cases
-		when a decoder straddles the volatile/persistent partition
-		boundary, and 'none' indicates the decoder is not actively
-		decoding, or no DPA allocation policy has been set.
+		into a 'ram' (volatile memory) range, 'pmem' (persistent
+		memory) range, or Dynamic Capacity (DC) range. The 'mode'
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
index 8c7f941eaba1..b368babb55d9 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -551,6 +551,7 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 	switch (mode) {
 	case CXL_DECODER_RAM:
 	case CXL_DECODER_PMEM:
+	case CXL_DECODER_DC0 ... CXL_DECODER_DC7:
 		break;
 	default:
 		dev_dbg(dev, "unsupported mode: %d\n", mode);
@@ -578,6 +579,22 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 		goto out;
 	}
 
+	if (mode >= CXL_DECODER_DC0 && mode <= CXL_DECODER_DC7) {
+		struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+
+		rc = dc_mode_to_region_index(mode);
+		if (!resource_size(&cxlds->dc_res[rc])) {
+			dev_dbg(dev, "no available dynamic capacity\n");
+			rc = -ENXIO;
+			goto out;
+		}
+		if (mds->dc_region[rc].shareable) {
+			dev_err(dev, "DC region %d is shareable\n", rc);
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
 	cxled->mode = mode;
 	rc = 0;
 out:
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 85b912c11f04..23b4f266a83a 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -205,11 +205,11 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
 	enum cxl_decoder_mode mode;
 	ssize_t rc;
 
-	if (sysfs_streq(buf, "pmem"))
-		mode = CXL_DECODER_PMEM;
-	else if (sysfs_streq(buf, "ram"))
-		mode = CXL_DECODER_RAM;
-	else
+	for (mode = CXL_DECODER_RAM; mode < CXL_DECODER_MIXED; mode++)
+		if (sysfs_streq(buf, cxl_decoder_mode_names[mode]))
+			break;
+
+	if (mode >= CXL_DECODER_MIXED)
 		return -EINVAL;
 
 	rc = cxl_dpa_set_mode(cxled, mode);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 8b7099c38a40..cbaacbe0f36d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -365,6 +365,9 @@ struct cxl_decoder {
 /*
  * CXL_DECODER_DEAD prevents endpoints from being reattached to regions
  * while cxld_unregister() is running
+ *
+ * NOTE: CXL_DECODER_RAM must be second and CXL_DECODER_MIXED must be last.
+ *	 See mode_store()
  */
 enum cxl_decoder_mode {
 	CXL_DECODER_NONE,
@@ -382,25 +385,25 @@ enum cxl_decoder_mode {
 	CXL_DECODER_DEAD,
 };
 
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
+};
+
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
2.46.0

