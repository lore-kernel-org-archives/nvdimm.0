Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A7E21C192
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013140; cv=none; b=S+boSQAzOvFRnTJTX21WEhdy2NTDZlFxPSCUC51/VwU7FfO83Uz3ogLMqkaIpwlMspEBJFbEeASXQNQIvIp/KkRCFe0wrn2EJT39etEOJ5oKgltPRR4p1JUdAYQVPxd2IxomesM+T9jDjy03LuI03nvZGZlmUfuNXA/Bf3HfsWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013140; c=relaxed/simple;
	bh=qogwsYpOk+Hm9JKEvIOsX5NUGdyAzbUw8ngMTIyJ/vA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XwhoW2HiLc2c246Rt78yxRr0bhU4d2hX4iDIj/NnQxvEqPzVdXR28v8kD4Ft6dTGmL1YFPBzfPlliAqS39DXtpesWa0dWD6u6wijJrMyuXbEDDpX31nWacSiFAFDnYmv+GxL/fcZEu6V0GgNEm/TPEKSl8vCOMUPCuGwnV/MFoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HF3B0ua0; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HF3B0ua0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013137; x=1762549137;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=qogwsYpOk+Hm9JKEvIOsX5NUGdyAzbUw8ngMTIyJ/vA=;
  b=HF3B0ua0OU991p559O5rV/5kmOQGj07pvuwyHOiMNtdZfnOoK7vaGMnS
   C+wK0EGzr5SbdJMX40IvLVN6cD81j0MzFR8eg2tQfKGGGScZ7hGKb1GLs
   +ItEPEXCzdNnDm4GECvL3LCKiqxH/RpufOexoSbQPgug14PS+QI/mvP3E
   QeN8ZsYSeeHZDRj/0Atw0VueMPHdBHVwUY6neXlOunQ5EiQBMIh+aln3N
   kOC32vgFvRuZLbP0PZL3xSag7B2dlRpqyuO9s/znYxQ4tKaep/H6qOZJ3
   8h7Vg6c+UaWg1DUD0k8a0dt8q41P8vT3rmPww8ZhZBABapHdiYG9PaK7U
   A==;
X-CSE-ConnectionGUID: KFWCO/OhSqCq4zeIdqyKBg==
X-CSE-MsgGUID: HgiF0VA8T0a+V5RZoN/Kvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41441016"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41441016"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:57 -0800
X-CSE-ConnectionGUID: k89L6qIJRVeiBJdywNX25w==
X-CSE-MsgGUID: D2J8me70SmK0mqp7aTe8+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122746009"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:56 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Thu, 07 Nov 2024 14:58:30 -0600
Subject: [PATCH v7 12/27] cxl/cdat: Gather DSMAS data for DCD regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-12-56a84e66bc36@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=4616;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=qogwsYpOk+Hm9JKEvIOsX5NUGdyAzbUw8ngMTIyJ/vA=;
 b=YpaGn9DGfTNL19Qjjn6L089eyepHnZiAydMKkzaUjcQKwJZoPOgKzQ08SnrtJuFdlNdZGjqne
 3PV8cotAU5sAoryYeuVCNjNIRRLrUg2stNkcQ0voB3Jy6w33OKGkpjr
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Additional DCD region (partition) information is contained in the DSMAS
CDAT tables, including performance, read only, and shareable attributes.

Match DCD partitions with DSMAS tables and store the meta data.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/cdat.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c |  2 ++
 drivers/cxl/cxlmem.h    |  3 +++
 3 files changed, 44 insertions(+)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index b5d30c5bf1e20725d13b4397a7ba90662bcd8766..7cd7734a3b0f0b742ee6e63973d12fb3e83ac332 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -17,6 +17,8 @@ struct dsmas_entry {
 	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
 	int entries;
 	int qos_class;
+	bool shareable;
+	bool read_only;
 };
 
 static u32 cdat_normalize(u16 entry, u64 base, u8 type)
@@ -74,6 +76,8 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
 		return -ENOMEM;
 
 	dent->handle = dsmas->dsmad_handle;
+	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
+	dent->read_only = dsmas->flags & ACPI_CDAT_DSMAS_READ_ONLY;
 	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
 	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
 			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
@@ -255,6 +259,39 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
 		dent->coord[ACCESS_COORDINATE_CPU].write_latency);
 }
 
+static void update_dcd_perf(struct cxl_dev_state *cxlds,
+			    struct dsmas_entry *dent)
+{
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+	struct device *dev = cxlds->dev;
+
+	for (int i = 0; i < mds->nr_dc_region; i++) {
+		/* CXL defines a u32 handle while CDAT defines u8, ignore upper bits */
+		u8 dc_handle = mds->dc_region[i].dsmad_handle & 0xff;
+
+		if (resource_size(&cxlds->dc_res[i])) {
+			struct range dc_range = {
+				.start = cxlds->dc_res[i].start,
+				.end = cxlds->dc_res[i].end,
+			};
+
+			if (range_contains(&dent->dpa_range, &dc_range)) {
+				if (dent->handle != dc_handle)
+					dev_warn(dev, "DC Region/DSMAS mis-matched handle/range; region [range 0x%016llx-0x%016llx] (%u); dsmas [range 0x%016llx-0x%016llx] (%u)\n"
+						      "   setting DC region attributes regardless\n",
+						dent->dpa_range.start, dent->dpa_range.end,
+						dent->handle,
+						dc_range.start, dc_range.end,
+						dc_handle);
+
+				mds->dc_region[i].shareable = dent->shareable;
+				mds->dc_region[i].read_only = dent->read_only;
+				update_perf_entry(dev, dent, &mds->dc_perf[i]);
+			}
+		}
+	}
+}
+
 static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
 				     struct xarray *dsmas_xa)
 {
@@ -278,6 +315,8 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
 		else if (resource_size(&cxlds->pmem_res) &&
 			 range_contains(&pmem_range, &dent->dpa_range))
 			update_perf_entry(dev, dent, &mds->pmem_perf);
+		else if (cxl_dcd_supported(mds))
+			update_dcd_perf(cxlds, dent);
 		else
 			dev_dbg(dev, "no partition for dsmas dpa: %#llx\n",
 				dent->dpa_range.start);
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 2c9a9af3dde3a294cde628880066b514b870029f..a4b5cb61b4e6f9b17e3e3e0cce356b0ac9f960d0 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1649,6 +1649,8 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
 	mds->cxlds.type = CXL_DEVTYPE_CLASSMEM;
 	mds->ram_perf.qos_class = CXL_QOS_CLASS_INVALID;
 	mds->pmem_perf.qos_class = CXL_QOS_CLASS_INVALID;
+	for (int i = 0; i < CXL_MAX_DC_REGION; i++)
+		mds->dc_perf[i].qos_class = CXL_QOS_CLASS_INVALID;
 
 	return mds;
 }
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 05a0718aea73b3b2a02c608bae198eac7c462523..bbdf52ac1d5cb5df82812c13ff50ca7cacfd0db6 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -466,6 +466,8 @@ struct cxl_dc_region_info {
 	u64 blk_size;
 	u32 dsmad_handle;
 	u8 flags;
+	bool shareable;
+	bool read_only;
 	u8 name[CXL_DC_REGION_STRLEN];
 };
 
@@ -533,6 +535,7 @@ struct cxl_memdev_state {
 
 	u8 nr_dc_region;
 	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
+	struct cxl_dpa_perf dc_perf[CXL_MAX_DC_REGION];
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;

-- 
2.47.0

