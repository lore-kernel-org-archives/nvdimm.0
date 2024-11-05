Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC3D1F6697
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831942; cv=none; b=HRFfKKkDQkYj3KdYxiRhk8inHvWeDUsUqGeKtibi7THyL39oZdM9dJxK8q9oJgl+qONNGwrfDQscfWsV0PGKQVkWdrr47xSA3PlM2wGJ47In87vsarohhoMMvVj4na7BCWX1EGXOdmpy159yXTssMCZeupv5NRi4kwsu/Dv+css=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831942; c=relaxed/simple;
	bh=3lXAlinzuI4EXO7/sRHZo/LB0N4FnPkvPS8xpovssbE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MFILYpj1eCSKQRzjQ1614YXXFaE84zT9iwQth33NRNAQH1HHyFK/CvsiwrM5edI6C2NyHcBwo/6VNvbOwtpWFKpQq4/WWIOegz9FTeLAtk7cAagrFDgR1JzHVA3kjvuaz7x9fP7AG952v2rT4oHv/ef5npLvuKc65bOMAZ18bt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lji/qEIC; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lji/qEIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831941; x=1762367941;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=3lXAlinzuI4EXO7/sRHZo/LB0N4FnPkvPS8xpovssbE=;
  b=Lji/qEICIxJK5ffGFddFP/SijFlVg2FGiZ8/UehRwo9R2ZPsjilDcuTI
   oS3+h09YM+wygG0PFoktSYyrcD028R69To7PZSw1svt6RZTvFDiTuRCwm
   N+q97mhpUL6t4DnsD7qQK9lOWBg9PriGtDRKz55mGSVivTo9oiSAnqvTY
   c2Hn8Bu0z42hK/uvzPWaDyvYRpRInZQK1GqsuSANaQ99beL6jIm8YahLh
   QlhpQG4cIOYHuc3FOJc1txZh5J3SRQ+rzpHsSTTXVBBbICfRJs7szGufh
   9coyoTfWBy1h4CytC+eC4uu3tkCwxDkVXb5s6OzuEm4E9ZzBTLgapiU0b
   A==;
X-CSE-ConnectionGUID: PCMA659iR3+HDFY/Zi8v7w==
X-CSE-MsgGUID: 6Wc57+VjTU2H+t0qN2PBuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41153263"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41153263"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:01 -0800
X-CSE-ConnectionGUID: EgBjDoiiT6uFVYrz6jjqCg==
X-CSE-MsgGUID: fXKdiQgATxGe7ERR09so0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84235690"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:58 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 05 Nov 2024 12:38:34 -0600
Subject: [PATCH v6 12/27] cxl/cdat: Gather DSMAS data for DCD regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-12-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=4568;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=3lXAlinzuI4EXO7/sRHZo/LB0N4FnPkvPS8xpovssbE=;
 b=J1XfflZz2mjKYLLP2n1CXtEAHeOWoPDpE3GDqt+cRkZd20MctXM1engF+xA/jx8Z4Ij5IkSjI
 DnGFv4Q5A4jBcskcBSYBpcT1mP7T40zswCXpnaGNBiiMLZAo8rQ2C9I
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Additional DCD region (partition) information is contained in the DSMAS
CDAT tables, including performance, read only, and shareable attributes.

Match DCD partitions with DSMAS tables and store the meta data.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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

