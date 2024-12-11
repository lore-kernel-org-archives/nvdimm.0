Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5E2397AA
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 03:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733888557; cv=none; b=ZEFmoSkLhM6arR1mpAekAehmfzj52aTXT6TEkqIhzcJ0EfRSo4/6JYBGm3aXK/TtzasySnchUbOxcZBlwaFtNthHksHhQeQA6I+uh4E3g7luJI8SjRhQPfNmXpxomTCxpj4G96zwoEkQdv+WHeyHBLG80fYyiF8qP4PNO0UB6Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733888557; c=relaxed/simple;
	bh=0InHjwlCmM52nK7iVagZkLVDEdsGa3Kmv0EZ0WuLwZo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YKbyVJcsi63508XO18SGdc+Mq9i3oi9CAdy3yV6Q+O502+msyidYvT50144X1L7P/HXTqlT9/YAeoydeFYOZVWeIyJ65Px2wtLgg8Yy1mpsazJkDpN/fDHW1xH/2ZQMQSe3evGm+9HXWKiIm7A6mxVHyaUGhQ4fR7wVH9AwEP7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yq3cIxaa; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yq3cIxaa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733888556; x=1765424556;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=0InHjwlCmM52nK7iVagZkLVDEdsGa3Kmv0EZ0WuLwZo=;
  b=Yq3cIxaa+4RGGcnLqU3F8Sb30bMUebpnVajiHRf82/0qB6tvlAAsJy4Z
   Hjtnza5oS38ll4UrWcO/XGjcJ0L1xTwvB0HZmDNtX5/h6a5jOyf7Y0OEl
   fp/8uptp/qhxTBGc7tLb8DlxgeskxspbRY4tOKR+Izf+435fIdY4dsqz1
   9QlEIF87yFxAuUrO2+pIzEoMX4sgE/QDRjrE4z1M32wGzayvJjblGXmt+
   cz1LPowX40uwkta09wl0DEA0+EOfsEWsZSu43RwYSm9rFyWA171lQq5dF
   PcxZfn+OP8B66Hy73ckudTSo7ri4X5ZIvZzOOHvz/GTO1KVUbPfkxp7LT
   Q==;
X-CSE-ConnectionGUID: 3OZbu/Q2SLi6YVqHSbFtSw==
X-CSE-MsgGUID: O3ZHrOSARLyqLmJcbDRyUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34395689"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="34395689"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:36 -0800
X-CSE-ConnectionGUID: lA0YsX+LSje85VqNlXYIkQ==
X-CSE-MsgGUID: 5iqF3VUdQvmdzITssSDAdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95696803"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO localhost) ([10.125.109.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:34 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 10 Dec 2024 21:42:21 -0600
Subject: [PATCH v8 06/21] cxl/cdat: Gather DSMAS data for DCD regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-dcd-type2-upstream-v8-6-812852504400@intel.com>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
In-Reply-To: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733888537; l=4549;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=0InHjwlCmM52nK7iVagZkLVDEdsGa3Kmv0EZ0WuLwZo=;
 b=wSzxzFTbKFC72QCVul+/Ndm8zW8qjBZSvXHy4wGx+bo42QK5b3E0wWTgCV1wbR3MMlqw2aWTu
 s3HLzzqz7UdAk5PpWVKR/ShZHTw7kyDgxRDae243LcTrkHnxCqgo5S0
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Additional DCD region (partition) information is contained in the DSMAS
CDAT tables, including performance, read only, and shareable attributes.

Match DCD partitions with DSMAS tables and store the meta data.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: convert range prints to %pra]
---
 drivers/cxl/core/cdat.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c |  2 ++
 drivers/cxl/cxlmem.h    |  3 +++
 3 files changed, 41 insertions(+)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 401a19359aee77167fb6fe9e3d8fd5e9a077ab88..14cdfb82f5ea6d4764b10098a1f009c1614b6f29 100644
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
@@ -255,6 +259,36 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
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
+					dev_warn(dev, "DC Region/DSMAS mis-matched handle/range; region %pra (%u); dsmas %pra (%u)\n"
+						      "   setting DC region attributes regardless\n",
+						&dent->dpa_range, dent->handle, &dc_range, dc_handle);
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
@@ -278,6 +312,8 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
 		else if (resource_size(&cxlds->pmem_res) &&
 			 range_contains(&pmem_range, &dent->dpa_range))
 			update_perf_entry(dev, dent, &mds->pmem_perf);
+		else if (cxl_dcd_supported(mds))
+			update_dcd_perf(cxlds, dent);
 		else
 			dev_dbg(dev, "no partition for dsmas dpa: %pra\n",
 				&dent->dpa_range);
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index a4cf9fbb1edfa275e8566bfacea03a49d68f9319..56c4389e0031e15bc66056b8a73f4159864f6c4e 100644
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
2.47.1

