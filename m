Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19A6208205
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234145; cv=none; b=MU9WRTlkriajuQQ9GKX0tPfl5CsSPklQ6rsch6oYOV18+f/1YBHaLasjyXU6r4eOtL6PvZHdEpyVlSVbbOlx8WJ+7cBBggaIuYRR6D2hW+9SAmNYJH+tuuyuQlijfjb2/onaVIVqP7ttsHb+ZTUw/2ypPniNhrFx37slC7/WdYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234145; c=relaxed/simple;
	bh=11ABv0olJv++qD+OMirCXXfxpyfLgCaH9fiUxEz41+U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R8Nx15KE6X47hGqtKw8sYpoG2AfJsbA8CcTdK07FRqiYsgFlRs1cztCdH17+EUMW1ewBldxbSCG3G5GjlaCfep7wW7ZRDsb8fr17gYG0qodvA3uuzk7sEnm3HMoZKFRNru/D6UwDRwgmDGxtGTWgCsZuHsHQX/ORDSUNIbrms1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LaHCXLv9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LaHCXLv9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234143; x=1761770143;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=11ABv0olJv++qD+OMirCXXfxpyfLgCaH9fiUxEz41+U=;
  b=LaHCXLv9nqsCJNpnI/donIEoDeUSuicDrXhL6HZ5wBrqi913PVUD0Idi
   HZGb2Qmj/QmYqrRE1/bR/obhi8AWLoVhH/KEg/isWAQeMbErF+vUFEyns
   PB1OmLw7q9z8OtPBrImAWx0m+7Lw/Z9l+ySK7gN539NjCqrwk7PNUqedH
   Q1Qx1BL7zhP9lbU+dZgQBxG7+CBKnFd9FoYipTbaQ4Swru+Rc+dqndmIx
   C6XaNVhViugGrS7seNHmbKBUKe4++CKDJgFZ11OLELdQ3lyvWYwJ5ZWqq
   qKDfsYYudg9bvrCG9KwTXJBIWxR65wYLwl6vGYO4piaOvaQvBtxXNTa6V
   w==;
X-CSE-ConnectionGUID: qFq4bja1T+OAMk35lA8d3g==
X-CSE-MsgGUID: cQVXrncbQD25B+tMsfWjCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="40485461"
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="40485461"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:42 -0700
X-CSE-ConnectionGUID: 6olIhOU0QF2tEQ1xxBCLbw==
X-CSE-MsgGUID: /W9odoTZQ5OPyh50JLGKNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="82185302"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:40 -0700
From: ira.weiny@intel.com
Date: Tue, 29 Oct 2024 15:34:46 -0500
Subject: [PATCH v5 11/27] cxl/hdm: Add dynamic capacity size support to
 endpoint decoders
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-11-8739cb67c374@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=13472;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=sX5unRG6Run0l7668PAdJko+Y4PgmkgJFy3umj4irpQ=;
 b=jm2WkBab1Ra+tDvdBx6FX1/FmtBCSBGZWEHIpT0/sphjc6MpWU53LIDN0dDNR90g5V6HcOOMf
 EApTQTKQdYxBHg/B5WXwIhi3agrvexj90SpP3JBpx0Qns43Xp61sHfk
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

To support Dynamic Capacity Devices (DCD) endpoint decoders will need to
map DC partitions (regions).  In addition to assigning the size of the
DC partition, the decoder must assign any skip value from the previous
decoder.  This must be done within a contiguous DPA space.

Two complications arise with Dynamic Capacity regions which did not
exist with Ram and PMEM partitions.  First, gaps in the DPA space can
exist between and around the DC partitions.  Second, the Linux resource
tree does not allow a resource to be marked across existing nodes within
a tree.

For clarity, below is an example of an 60GB device with 10GB of RAM,
10GB of PMEM and 10GB for each of 2 DC partitions.  The desired CXL
mapping is 5GB of RAM, 5GB of PMEM, and 5GB of DC1.

     DPA RANGE
     (dpa_res)
0GB        10GB       20GB       30GB       40GB       50GB       60GB
|----------|----------|----------|----------|----------|----------|

RAM         PMEM                  DC0                   DC1
 (ram_res)  (pmem_res)            (dc_res[0])           (dc_res[1])
|----------|----------|   <gap>  |----------|   <gap>  |----------|

 RAM        PMEM                                        DC1
|XXXXX|----|XXXXX|----|----------|----------|----------|XXXXX-----|
0GB   5GB  10GB  15GB 20GB       30GB       40GB       50GB       60GB

The previous skip resource between RAM and PMEM was always a child of
the RAM resource and fit nicely [see (S) below].  Because of this
simplicity this skip resource reference was not stored in any CXL state.
On release the skip range could be calculated based on the endpoint
decoders stored values.

Now when DC1 is being mapped 4 skip resources must be created as
children.  One for the PMEM resource (A), two of the parent DPA resource
(B,D), and one more child of the DC0 resource (C).

0GB        10GB       20GB       30GB       40GB       50GB       60GB
|----------|----------|----------|----------|----------|----------|
                           |                     |
|----------|----------|    |     |----------|    |     |----------|
        |          |       |          |          |
       (S)        (A)     (B)        (C)        (D)
	v          v       v          v          v
|XXXXX|----|XXXXX|----|----------|----------|----------|XXXXX-----|
       skip       skip  skip        skip      skip

Expand the calculation of DPA free space and enhance the logic to
support this more complex skipping.  To track the potential of multiple
skip resources an xarray is attached to the endpoint decoder.  The
existing algorithm between RAM and PMEM is consolidated within the new
one to streamline the code even though the result is the storage of a
single skip resource in the xarray.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[Jonathan: skip extra local resource variable]
---
 drivers/cxl/core/hdm.c  | 194 ++++++++++++++++++++++++++++++++++++++++++++----
 drivers/cxl/core/port.c |   2 +
 drivers/cxl/cxl.h       |   2 +
 3 files changed, 182 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 463ba2669cea55194e2be2c26d02af75dde8d145..998aed17d7e47fc18a05fb2e8cca25de0e92a6d4 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -223,6 +223,23 @@ void cxl_dpa_debug(struct seq_file *file, struct cxl_dev_state *cxlds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dpa_debug, CXL);
 
+static void cxl_skip_release(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_dev_state *cxlds = cxled_to_memdev(cxled)->cxlds;
+	struct cxl_port *port = cxled_to_port(cxled);
+	struct device *dev = &port->dev;
+	struct resource *res;
+	unsigned long index;
+
+	xa_for_each(&cxled->skip_xa, index, res) {
+		dev_dbg(dev, "decoder%d.%d: releasing skipped space; %pr\n",
+			port->id, cxled->cxld.id, res);
+		__release_region(&cxlds->dpa_res, res->start,
+				 resource_size(res));
+		xa_erase(&cxled->skip_xa, index);
+	}
+}
+
 /*
  * Must be called in a context that synchronizes against this decoder's
  * port ->remove() callback (like an endpoint decoder sysfs attribute)
@@ -233,15 +250,11 @@ static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
 	struct cxl_port *port = cxled_to_port(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct resource *res = cxled->dpa_res;
-	resource_size_t skip_start;
 
 	lockdep_assert_held_write(&cxl_dpa_rwsem);
 
-	/* save @skip_start, before @res is released */
-	skip_start = res->start - cxled->skip;
 	__release_region(&cxlds->dpa_res, res->start, resource_size(res));
-	if (cxled->skip)
-		__release_region(&cxlds->dpa_res, skip_start, cxled->skip);
+	cxl_skip_release(cxled);
 	cxled->skip = 0;
 	cxled->dpa_res = NULL;
 	put_device(&cxled->cxld.dev);
@@ -268,6 +281,105 @@ static void devm_cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
 	__cxl_dpa_release(cxled);
 }
 
+static int dc_mode_to_region_index(enum cxl_decoder_mode mode)
+{
+	return mode - CXL_DECODER_DC0;
+}
+
+static int cxl_request_skip(struct cxl_endpoint_decoder *cxled,
+			    resource_size_t skip_base, resource_size_t skip_len)
+{
+	struct cxl_dev_state *cxlds = cxled_to_memdev(cxled)->cxlds;
+	const char *name = dev_name(&cxled->cxld.dev);
+	struct cxl_port *port = cxled_to_port(cxled);
+	struct resource *dpa_res = &cxlds->dpa_res;
+	struct device *dev = &port->dev;
+	struct resource *res;
+	int rc;
+
+	res = __request_region(dpa_res, skip_base, skip_len, name, 0);
+	if (!res)
+		return -EBUSY;
+
+	rc = xa_insert(&cxled->skip_xa, skip_base, res, GFP_KERNEL);
+	if (rc) {
+		__release_region(dpa_res, skip_base, skip_len);
+		return rc;
+	}
+
+	dev_dbg(dev, "decoder%d.%d: skipped space; %pr\n",
+		port->id, cxled->cxld.id, res);
+	return 0;
+}
+
+static int cxl_reserve_dpa_skip(struct cxl_endpoint_decoder *cxled,
+				resource_size_t base, resource_size_t skipped)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_port *port = cxled_to_port(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	resource_size_t skip_base = base - skipped;
+	struct device *dev = &port->dev;
+	resource_size_t skip_len = 0;
+	int rc, index;
+
+	if (resource_size(&cxlds->ram_res) && skip_base <= cxlds->ram_res.end) {
+		skip_len = cxlds->ram_res.end - skip_base + 1;
+		rc = cxl_request_skip(cxled, skip_base, skip_len);
+		if (rc)
+			return rc;
+		skip_base += skip_len;
+	}
+
+	if (skip_base == base) {
+		dev_dbg(dev, "skip done ram!\n");
+		return 0;
+	}
+
+	if (resource_size(&cxlds->pmem_res) &&
+	    skip_base <= cxlds->pmem_res.end) {
+		skip_len = cxlds->pmem_res.end - skip_base + 1;
+		rc = cxl_request_skip(cxled, skip_base, skip_len);
+		if (rc)
+			return rc;
+		skip_base += skip_len;
+	}
+
+	index = dc_mode_to_region_index(cxled->mode);
+	for (int i = 0; i <= index; i++) {
+		struct resource *dcr = &cxlds->dc_res[i];
+
+		if (skip_base < dcr->start) {
+			skip_len = dcr->start - skip_base;
+			rc = cxl_request_skip(cxled, skip_base, skip_len);
+			if (rc)
+				return rc;
+			skip_base += skip_len;
+		}
+
+		if (skip_base == base) {
+			dev_dbg(dev, "skip done DC region %d!\n", i);
+			break;
+		}
+
+		if (resource_size(dcr) && skip_base <= dcr->end) {
+			if (skip_base > base) {
+				dev_err(dev, "Skip error DC region %d; skip_base %pa; base %pa\n",
+					i, &skip_base, &base);
+				return -ENXIO;
+			}
+
+			skip_len = dcr->end - skip_base + 1;
+			rc = cxl_request_skip(cxled, skip_base, skip_len);
+			if (rc)
+				return rc;
+			skip_base += skip_len;
+		}
+	}
+
+	return 0;
+}
+
 static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 			     resource_size_t base, resource_size_t len,
 			     resource_size_t skipped)
@@ -305,13 +417,12 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 	}
 
 	if (skipped) {
-		res = __request_region(&cxlds->dpa_res, base - skipped, skipped,
-				       dev_name(&cxled->cxld.dev), 0);
-		if (!res) {
-			dev_dbg(dev,
-				"decoder%d.%d: failed to reserve skipped space\n",
-				port->id, cxled->cxld.id);
-			return -EBUSY;
+		int rc = cxl_reserve_dpa_skip(cxled, base, skipped);
+
+		if (rc) {
+			dev_dbg(dev, "decoder%d.%d: failed to reserve skipped space; %pa - %pa\n",
+				port->id, cxled->cxld.id, &base, &skipped);
+			return rc;
 		}
 	}
 	res = __request_region(&cxlds->dpa_res, base, len,
@@ -319,14 +430,20 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 	if (!res) {
 		dev_dbg(dev, "decoder%d.%d: failed to reserve allocation\n",
 			port->id, cxled->cxld.id);
-		if (skipped)
-			__release_region(&cxlds->dpa_res, base - skipped,
-					 skipped);
+		cxl_skip_release(cxled);
 		return -EBUSY;
 	}
 	cxled->dpa_res = res;
 	cxled->skip = skipped;
 
+	for (int mode = CXL_DECODER_DC0; mode <= CXL_DECODER_DC7; mode++) {
+		int index = dc_mode_to_region_index(mode);
+
+		if (resource_contains(&cxlds->dc_res[index], res)) {
+			cxled->mode = mode;
+			goto success;
+		}
+	}
 	if (resource_contains(&cxlds->pmem_res, res))
 		cxled->mode = CXL_DECODER_PMEM;
 	else if (resource_contains(&cxlds->ram_res, res))
@@ -337,6 +454,9 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 		cxled->mode = CXL_DECODER_MIXED;
 	}
 
+success:
+	dev_dbg(dev, "decoder%d.%d: %pr mode: %d\n", port->id, cxled->cxld.id,
+		cxled->dpa_res, cxled->mode);
 	port->hdm_end++;
 	get_device(&cxled->cxld.dev);
 	return 0;
@@ -457,8 +577,8 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 
 int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, unsigned long long size)
 {
-	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	resource_size_t free_ram_start, free_pmem_start;
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	struct cxl_port *port = cxled_to_port(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct device *dev = &cxled->cxld.dev;
@@ -515,12 +635,54 @@ int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, unsigned long long size)
 		else
 			skip_end = start - 1;
 		skip = skip_end - skip_start + 1;
+	} else if (cxl_decoder_mode_is_dc(cxled->mode)) {
+		int dc_index = dc_mode_to_region_index(cxled->mode);
+
+		for (p = cxlds->dc_res[dc_index].child, last = NULL; p; p = p->sibling)
+			last = p;
+
+		if (last) {
+			/*
+			 * Some capacity in this DC partition is already allocated,
+			 * that allocation already handled the skip.
+			 */
+			start = last->end + 1;
+			skip = 0;
+		} else {
+			/* Calculate skip */
+			resource_size_t skip_start, skip_end;
+
+			start = cxlds->dc_res[dc_index].start;
+
+			if ((resource_size(&cxlds->pmem_res) == 0) || !cxlds->pmem_res.child)
+				skip_start = free_ram_start;
+			else
+				skip_start = free_pmem_start;
+			/*
+			 * If any dc region is already mapped, then that allocation
+			 * already handled the RAM and PMEM skip.  Check for DC region
+			 * skip.
+			 */
+			for (int i = dc_index - 1; i >= 0 ; i--) {
+				if (cxlds->dc_res[i].child) {
+					skip_start = cxlds->dc_res[i].child->end + 1;
+					break;
+				}
+			}
+
+			skip_end = start - 1;
+			skip = skip_end - skip_start + 1;
+		}
+		avail = cxlds->dc_res[dc_index].end - start + 1;
 	} else {
 		dev_dbg(dev, "mode not set\n");
 		rc = -EINVAL;
 		goto out;
 	}
 
+	dev_dbg(dev, "DPA Allocation start: %pa len: %#llx Skip: %pa\n",
+		&start, size, &skip);
+
 	if (size > avail) {
 		dev_dbg(dev, "%pa exceeds available %s capacity: %pa\n", &size,
 			cxl_decoder_mode_name(cxled->mode), &avail);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index e666ec6a9085a577c92f5e73cefff894922fcb38..85b912c11f04d2c743936eaac1f356975cb3cc71 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -419,6 +419,7 @@ static void cxl_endpoint_decoder_release(struct device *dev)
 	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
 
 	__cxl_decoder_release(&cxled->cxld);
+	xa_destroy(&cxled->skip_xa);
 	kfree(cxled);
 }
 
@@ -1899,6 +1900,7 @@ struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
 		return ERR_PTR(-ENOMEM);
 
 	cxled->pos = -1;
+	xa_init(&cxled->skip_xa);
 	cxld = &cxled->cxld;
 	rc = cxl_decoder_init(port, cxld);
 	if (rc)	 {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f931ebdd36d05a8aa758627746f0fa425a5f14fd..8b7099c38a40d842e4f11137c3e9107031fbdf6a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -446,6 +446,7 @@ enum cxl_decoder_state {
  * @cxld: base cxl_decoder_object
  * @dpa_res: actively claimed DPA span of this decoder
  * @skip: offset into @dpa_res where @cxld.hpa_range maps
+ * @skip_xa: array of skipped resources from the previous decoder end
  * @mode: which memory type / access-mode-partition this decoder targets
  * @state: autodiscovery state
  * @pos: interleave position in @cxld.region
@@ -454,6 +455,7 @@ struct cxl_endpoint_decoder {
 	struct cxl_decoder cxld;
 	struct resource *dpa_res;
 	resource_size_t skip;
+	struct xarray skip_xa;
 	enum cxl_decoder_mode mode;
 	enum cxl_decoder_state state;
 	int pos;

-- 
2.47.0

