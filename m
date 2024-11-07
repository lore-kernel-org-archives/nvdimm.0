Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94280224B43
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013158; cv=none; b=FQYTS3CrFpsTHkMz0H+yoNETJTT20qra+AshVKS5F+jVL09ZQ1esx+x1Q6evxX+Km+jgE1hDXdHMfzT5/Hazg7Afy/vPSVdZ4ss5pg5uvZlL4BEojDDCkIl+kM1rnCEDdtty9eAZ7G4S+Gz7msFM3oK0IUcZLD3UZSHqMuPffys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013158; c=relaxed/simple;
	bh=RA7/V8d3+/ZG+TEho2L2jAdCPkNmfQB02sBeilyCcIg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GkPl0fICUrP9Y/E9f9WJWzo1HKMxorLVuUQrbfsTJlnJjWgPBqOttHtL7gP35nAAPss4le39K2WkNSuQf2hhrKBip7m5XCFlPubTFuRZhDl/FZFu822x67rXuXrEe4raEtrIT0kxMdtxWujUr/DHu1EvnehamuNCsv22aStUNeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HMxtSTVf; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HMxtSTVf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013155; x=1762549155;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=RA7/V8d3+/ZG+TEho2L2jAdCPkNmfQB02sBeilyCcIg=;
  b=HMxtSTVfAvhQGb8KxoXvMgv7403A/vfM30AlEvsbM42lVmOSckKkckvE
   0FHUO0pLAynXDSXXN05Cdd8Eb5FkVVRM9IcJFT7JpYKD8PAXHCi0Zsy9v
   YhzNsx0XcHkML1wIArF2zLGrZrerfa8hmBEGABu7A/1gw7J/BG9iT5AZS
   6tNzTeKBlbxXKtwsKnWRXlSM7xVU2X2tP3IWb26fn+ffdOIk7l7aKwOAf
   rf9ty9WLjWAOPifvpBjRGF9SrsgmgpXb8w9jNi916l1BtvgzhwbuCCd6T
   BfaK1S9ChQ0e8MaNCsm/NabFgTFdJf42A52Rmm3dGK3QkbXnbnM0O3e3q
   w==;
X-CSE-ConnectionGUID: rOeOqeMAS7yNeIsz18IhiQ==
X-CSE-MsgGUID: 9dESniA0TsWSpdeDZ7pfUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41441082"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41441082"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:15 -0800
X-CSE-ConnectionGUID: mFPyhTdPQXmy6t7BVxuRBw==
X-CSE-MsgGUID: syCcAiElTu2BtbUEZR4XqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122746050"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:14 -0800
From: ira.weiny@intel.com
Date: Thu, 07 Nov 2024 14:58:38 -0600
Subject: [PATCH v7 20/27] cxl/extent: Process DCD events and realize region
 extents
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-20-56a84e66bc36@intel.com>
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
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Li Ming <ming4.li@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=36317;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=c4CLS8Mp66GKk4V7YeHPJYH7JdimQ+hnahguk6DBLcg=;
 b=wwT+Q+BVecmRBOnFwuvCRhEqBv1h2PaF7Z1T3CTgZQtfI6E0qi4AbKeoXCBvUae7u6qC+hm2Q
 MVO+iDejBTYCoBPbPPXUF47qLtA2Gwe+Nyc5Grg/iy9tGrNlQOMpf2h
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

A dynamic capacity device (DCD) sends events to signal the host for
changes in the availability of Dynamic Capacity (DC) memory.  These
events contain extents describing a DPA range and meta data for memory
to be added or removed.  Events may be sent from the device at any time.

Three types of events can be signaled, Add, Release, and Force Release.

On add, the host may accept or reject the memory being offered.  If no
region exists, or the extent is invalid, the extent should be rejected.
Add extent events may be grouped by a 'more' bit which indicates those
extents should be processed as a group.

On remove, the host can delay the response until the host is safely not
using the memory.  If no region exists the release can be sent
immediately.  The host may also release extents (or partial extents) at
any time.  Thus the 'more' bit grouping of release events is of less
value and can be ignored in favor of sending multiple release capacity
responses for groups of release events.

Force removal is intended as a mechanism between the FM and the device
and intended only when the host is unresponsive, out of sync, or
otherwise broken.  Purposely ignore force removal events.

Regions are made up of one or more devices which may be surfacing memory
to the host.  Once all devices in a region have surfaced an extent the
region can expose a corresponding extent for the user to consume.
Without interleaving a device extent forms a 1:1 relationship with the
region extent.  Immediately surface a region extent upon getting a
device extent.

Per the specification the device is allowed to offer or remove extents
at any time.  However, anticipated use cases can expect extents to be
offered, accepted, and removed in well defined chunks.

Simplify extent tracking with the following restrictions.

	1) Flag for removal any extent which overlaps a requested
	   release range.
	2) Refuse the offer of extents which overlap already accepted
	   memory ranges.
	3) Accept again a range which has already been accepted by the
	   host.  Eating duplicates serves three purposes.  First, this
	   simplifies the code if the device should get out of sync with
	   the host.  And it should be safe to acknowledge the extent
	   again.  Second, this simplifies the code to process existing
	   extents if the extent list should change while the extent
	   list is being read.  Third, duplicates for a given region
	   which are seen during a race between the hardware surfacing
	   an extent and the cxl dax driver scanning for existing
	   extents will be ignored.

	   NOTE: Processing existing extents is done in a later patch.

Management of the region extent devices must be synchronized with
potential uses of the memory within the DAX layer.  Create region extent
devices as children of the cxl_dax_region device such that the DAX
region driver can co-drive them and synchronize with the DAX layer.
Synchronization and management is handled in a subsequent patch.

Tag support within the DAX layer is not yet supported.  To maintain
compatibility legacy DAX/region processing only tags with a value of 0
are allowed.  This defines existing DAX devices as having a 0 tag which
makes the most logical sense as a default.

Process DCD events and create region devices.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes:
[Ming: Fix setting the more flag]
---
 drivers/cxl/core/Makefile |   2 +-
 drivers/cxl/core/core.h   |  13 ++
 drivers/cxl/core/extent.c | 371 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c   | 295 +++++++++++++++++++++++++++++++++++-
 drivers/cxl/core/region.c |   3 +
 drivers/cxl/cxl.h         |  53 ++++++-
 drivers/cxl/cxlmem.h      |  27 ++++
 include/cxl/event.h       |  32 ++++
 tools/testing/cxl/Kbuild  |   3 +-
 9 files changed, 795 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 9259bcc6773c804ccace2478c9f6f09267b48c9d..3b812515e72536aee5cd305e1ffabfd5a8bd296c 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -15,4 +15,4 @@ cxl_core-y += hdm.o
 cxl_core-y += pmu.o
 cxl_core-y += cdat.o
 cxl_core-$(CONFIG_TRACING) += trace.o
-cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_REGION) += region.o extent.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 94ee06cfbdca07b50130299dfe0dd6546e7b9dac..0eccdd0b9261467fe762aa665776c87c5cb9ce24 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -44,12 +44,24 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 
+int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
+int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
 {
 	return ULLONG_MAX;
 }
+static inline int cxl_add_extent(struct cxl_memdev_state *mds,
+				   struct cxl_extent *extent)
+{
+	return 0;
+}
+static inline int cxl_rm_extent(struct cxl_memdev_state *mds,
+				struct cxl_extent *extent)
+{
+	return 0;
+}
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
@@ -123,5 +135,6 @@ int cxl_update_hmat_access_coordinates(int nid, struct cxl_region *cxlr,
 bool cxl_need_node_perf_attrs_update(int nid);
 int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
 					struct access_coordinate *c);
+void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range);
 
 #endif /* __CXL_CORE_H__ */
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
new file mode 100644
index 0000000000000000000000000000000000000000..bb12abe4792bcadd2442de3c21bf5ce4d48edf06
--- /dev/null
+++ b/drivers/cxl/core/extent.c
@@ -0,0 +1,371 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2024 Intel Corporation. All rights reserved. */
+
+#include <linux/device.h>
+#include <cxl.h>
+
+#include "core.h"
+
+static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
+				 struct cxled_extent *ed_extent)
+{
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+	struct device *dev = &cxled->cxld.dev;
+
+	dev_dbg(dev, "Remove extent [range 0x%016llx-0x%016llx] (%pU)\n",
+		ed_extent->dpa_range.start, ed_extent->dpa_range.end,
+		ed_extent->tag);
+	memdev_release_extent(mds, &ed_extent->dpa_range);
+	kfree(ed_extent);
+}
+
+static void free_region_extent(struct region_extent *region_extent)
+{
+	struct cxled_extent *ed_extent;
+	unsigned long index;
+
+	/*
+	 * Remove from each endpoint decoder the extent which backs this region
+	 * extent
+	 */
+	xa_for_each(&region_extent->decoder_extents, index, ed_extent)
+		cxled_release_extent(ed_extent->cxled, ed_extent);
+	xa_destroy(&region_extent->decoder_extents);
+	ida_free(&region_extent->cxlr_dax->extent_ida, region_extent->dev.id);
+	kfree(region_extent);
+}
+
+static void region_extent_release(struct device *dev)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	free_region_extent(region_extent);
+}
+
+static const struct device_type region_extent_type = {
+	.name = "extent",
+	.release = region_extent_release,
+};
+
+bool is_region_extent(struct device *dev)
+{
+	return dev->type == &region_extent_type;
+}
+EXPORT_SYMBOL_NS_GPL(is_region_extent, CXL);
+
+static void region_extent_unregister(void *ext)
+{
+	struct region_extent *region_extent = ext;
+
+	dev_dbg(&region_extent->dev, "DAX region rm extent HPA [range 0x%016llx-0x%016llx]\n",
+		region_extent->hpa_range.start, region_extent->hpa_range.end);
+	device_unregister(&region_extent->dev);
+}
+
+static void region_rm_extent(struct region_extent *region_extent)
+{
+	struct device *region_dev = region_extent->dev.parent;
+
+	devm_release_action(region_dev, region_extent_unregister, region_extent);
+}
+
+static struct region_extent *
+alloc_region_extent(struct cxl_dax_region *cxlr_dax, struct range *hpa_range, u8 *tag)
+{
+	int id;
+
+	struct region_extent *region_extent __free(kfree) =
+				kzalloc(sizeof(*region_extent), GFP_KERNEL);
+	if (!region_extent)
+		return ERR_PTR(-ENOMEM);
+
+	id = ida_alloc(&cxlr_dax->extent_ida, GFP_KERNEL);
+	if (id < 0)
+		return ERR_PTR(-ENOMEM);
+
+	region_extent->hpa_range = *hpa_range;
+	region_extent->cxlr_dax = cxlr_dax;
+	import_uuid(&region_extent->tag, tag);
+	region_extent->dev.id = id;
+	xa_init(&region_extent->decoder_extents);
+	return no_free_ptr(region_extent);
+}
+
+static int online_region_extent(struct region_extent *region_extent)
+{
+	struct cxl_dax_region *cxlr_dax = region_extent->cxlr_dax;
+	struct device *dev = &region_extent->dev;
+	int rc;
+
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr_dax->dev;
+	dev->type = &region_extent_type;
+	rc = dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id, dev->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(dev, "region extent HPA [range 0x%016llx-0x%016llx]\n",
+		region_extent->hpa_range.start, region_extent->hpa_range.end);
+	return devm_add_action_or_reset(&cxlr_dax->dev, region_extent_unregister,
+					region_extent);
+
+err:
+	dev_err(&cxlr_dax->dev, "Failed to initialize region extent HPA [range 0x%016llx-0x%016llx]\n",
+		region_extent->hpa_range.start, region_extent->hpa_range.end);
+
+	put_device(dev);
+	return rc;
+}
+
+struct match_data {
+	struct cxl_endpoint_decoder *cxled;
+	struct range *new_range;
+};
+
+static int match_contains(struct device *dev, void *data)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	struct match_data *md = data;
+	struct cxled_extent *entry;
+	unsigned long index;
+
+	if (!region_extent)
+		return 0;
+
+	xa_for_each(&region_extent->decoder_extents, index, entry) {
+		if (md->cxled == entry->cxled &&
+		    range_contains(&entry->dpa_range, md->new_range))
+			return 1;
+	}
+	return 0;
+}
+
+static bool extents_contain(struct cxl_dax_region *cxlr_dax,
+			    struct cxl_endpoint_decoder *cxled,
+			    struct range *new_range)
+{
+	struct match_data md = {
+		.cxled = cxled,
+		.new_range = new_range,
+	};
+
+	struct device *extent_device __free(put_device)
+			= device_find_child(&cxlr_dax->dev, &md, match_contains);
+	if (!extent_device)
+		return false;
+
+	return true;
+}
+
+static int match_overlaps(struct device *dev, void *data)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	struct match_data *md = data;
+	struct cxled_extent *entry;
+	unsigned long index;
+
+	if (!region_extent)
+		return 0;
+
+	xa_for_each(&region_extent->decoder_extents, index, entry) {
+		if (md->cxled == entry->cxled &&
+		    range_overlaps(&entry->dpa_range, md->new_range))
+			return 1;
+	}
+
+	return 0;
+}
+
+static bool extents_overlap(struct cxl_dax_region *cxlr_dax,
+			    struct cxl_endpoint_decoder *cxled,
+			    struct range *new_range)
+{
+	struct match_data md = {
+		.cxled = cxled,
+		.new_range = new_range,
+	};
+
+	struct device *extent_device __free(put_device)
+			= device_find_child(&cxlr_dax->dev, &md, match_overlaps);
+	if (!extent_device)
+		return false;
+
+	return true;
+}
+
+static void calc_hpa_range(struct cxl_endpoint_decoder *cxled,
+			   struct cxl_dax_region *cxlr_dax,
+			   struct range *dpa_range,
+			   struct range *hpa_range)
+{
+	resource_size_t dpa_offset, hpa;
+
+	dpa_offset = dpa_range->start - cxled->dpa_res->start;
+	hpa = cxled->cxld.hpa_range.start + dpa_offset;
+
+	hpa_range->start = hpa - cxlr_dax->hpa_range.start;
+	hpa_range->end = hpa_range->start + range_len(dpa_range) - 1;
+}
+
+static int cxlr_rm_extent(struct device *dev, void *data)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	struct range *region_hpa_range = data;
+
+	if (!region_extent)
+		return 0;
+
+	/*
+	 * Any extent which 'touches' the released range is removed.
+	 */
+	if (range_overlaps(region_hpa_range, &region_extent->hpa_range)) {
+		dev_dbg(dev, "Remove region extent HPA [range 0x%016llx-0x%016llx]\n",
+			region_extent->hpa_range.start, region_extent->hpa_range.end);
+		region_rm_extent(region_extent);
+	}
+	return 0;
+}
+
+int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
+{
+	u64 start_dpa = le64_to_cpu(extent->start_dpa);
+	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct cxl_endpoint_decoder *cxled;
+	struct range hpa_range, dpa_range;
+	struct cxl_region *cxlr;
+
+	dpa_range = (struct range) {
+		.start = start_dpa,
+		.end = start_dpa + le64_to_cpu(extent->length) - 1,
+	};
+
+	guard(rwsem_read)(&cxl_region_rwsem);
+	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
+	if (!cxlr) {
+		/*
+		 * No region can happen here for a few reasons:
+		 *
+		 * 1) Extents were accepted and the host crashed/rebooted
+		 *    leaving them in an accepted state.  On reboot the host
+		 *    has not yet created a region to own them.
+		 *
+		 * 2) Region destruction won the race with the device releasing
+		 *    all the extents.  Here the release will be a duplicate of
+		 *    the one sent via region destruction.
+		 *
+		 * 3) The device is confused and releasing extents for which no
+		 *    region ever existed.
+		 *
+		 * In all these cases make sure the device knows we are not
+		 * using this extent.
+		 */
+		memdev_release_extent(mds, &dpa_range);
+		return -ENXIO;
+	}
+
+	calc_hpa_range(cxled, cxlr->cxlr_dax, &dpa_range, &hpa_range);
+
+	/* Remove region extents which overlap */
+	return device_for_each_child(&cxlr->cxlr_dax->dev, &hpa_range,
+				     cxlr_rm_extent);
+}
+
+static int cxlr_add_extent(struct cxl_dax_region *cxlr_dax,
+			   struct cxl_endpoint_decoder *cxled,
+			   struct cxled_extent *ed_extent)
+{
+	struct region_extent *region_extent;
+	struct range hpa_range;
+	int rc;
+
+	calc_hpa_range(cxled, cxlr_dax, &ed_extent->dpa_range, &hpa_range);
+
+	region_extent = alloc_region_extent(cxlr_dax, &hpa_range, ed_extent->tag);
+	if (IS_ERR(region_extent))
+		return PTR_ERR(region_extent);
+
+	rc = xa_insert(&region_extent->decoder_extents, (unsigned long)ed_extent,
+		       ed_extent, GFP_KERNEL);
+	if (rc) {
+		free_region_extent(region_extent);
+		return rc;
+	}
+
+	/* device model handles freeing region_extent */
+	return online_region_extent(region_extent);
+}
+
+/* Callers are expected to ensure cxled has been attached to a region */
+int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
+{
+	u64 start_dpa = le64_to_cpu(extent->start_dpa);
+	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct cxl_endpoint_decoder *cxled;
+	struct range ed_range, ext_range;
+	struct cxl_dax_region *cxlr_dax;
+	struct cxled_extent *ed_extent;
+	struct cxl_region *cxlr;
+	struct device *dev;
+
+	ext_range = (struct range) {
+		.start = start_dpa,
+		.end = start_dpa + le64_to_cpu(extent->length) - 1,
+	};
+
+	guard(rwsem_read)(&cxl_region_rwsem);
+	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
+	if (!cxlr)
+		return -ENXIO;
+
+	cxlr_dax = cxled->cxld.region->cxlr_dax;
+	dev = &cxled->cxld.dev;
+	ed_range = (struct range) {
+		.start = cxled->dpa_res->start,
+		.end = cxled->dpa_res->end,
+	};
+
+	dev_dbg(&cxled->cxld.dev, "Checking ED (%pr) for extent [range 0x%016llx-0x%016llx]\n",
+		cxled->dpa_res, ext_range.start, ext_range.end);
+
+	if (!range_contains(&ed_range, &ext_range)) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA [range 0x%016llx-0x%016llx] (%pU) is not fully in ED [range 0x%016llx-0x%016llx]\n",
+				    ext_range.start, ext_range.end, extent->tag,
+				    ed_range.start, ed_range.end);
+		return -ENXIO;
+	}
+
+	/*
+	 * Allowing duplicates or extents which are already in an accepted
+	 * range simplifies extent processing, especially when dealing with the
+	 * cxl dax driver scanning for existing extents.
+	 */
+	if (extents_contain(cxlr_dax, cxled, &ext_range)) {
+		dev_warn_ratelimited(dev,
+			"Extent [range 0x%016llx-0x%016llx] exists; accept again\n",
+			ext_range.start, ext_range.end);
+		return 0;
+	}
+
+	if (extents_overlap(cxlr_dax, cxled, &ext_range))
+		return -ENXIO;
+
+	ed_extent = kzalloc(sizeof(*ed_extent), GFP_KERNEL);
+	if (!ed_extent)
+		return -ENOMEM;
+
+	ed_extent->cxled = cxled;
+	ed_extent->dpa_range = ext_range;
+	memcpy(ed_extent->tag, extent->tag, CXL_EXTENT_TAG_LEN);
+
+	dev_dbg(dev, "Add extent [range 0x%016llx-0x%016llx] (%pU)\n",
+		ed_extent->dpa_range.start, ed_extent->dpa_range.end,
+		ed_extent->tag);
+
+	return cxlr_add_extent(cxlr_dax, cxled, ed_extent);
+}
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index a06137d95c6822192fb279068abf964f98f0a335..61d406d19bf777a3921dbb3cc1213d341d8dea4c 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -889,6 +889,59 @@ int cxl_enumerate_cmds(struct cxl_memdev_state *mds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_enumerate_cmds, CXL);
 
+static u8 zero_tag[CXL_EXTENT_TAG_LEN] = { 0 };
+
+static int cxl_validate_extent(struct cxl_memdev_state *mds,
+			       struct cxl_extent *extent)
+{
+	u64 start = le64_to_cpu(extent->start_dpa);
+	u64 length = le64_to_cpu(extent->length);
+	struct device *dev = mds->cxlds.dev;
+
+	struct range ext_range = (struct range){
+		.start = start,
+		.end = start + length - 1,
+	};
+
+	if (le16_to_cpu(extent->shared_extn_seq) != 0) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA [range 0x%016llx-0x%016llx] (%pU) can not be shared\n",
+				    ext_range.start, ext_range.end,
+				    extent->tag);
+		return -ENXIO;
+	}
+
+	if (memcmp(extent->tag, zero_tag, CXL_EXTENT_TAG_LEN)) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA [range 0x%016llx-0x%016llx] (%pU); tags not supported\n",
+				    ext_range.start, ext_range.end,
+				    extent->tag);
+		return -ENXIO;
+	}
+
+	/* Extents must not cross DC region boundary's */
+	for (int i = 0; i < mds->nr_dc_region; i++) {
+		struct cxl_dc_region_info *dcr = &mds->dc_region[i];
+		struct range region_range = (struct range) {
+			.start = dcr->base,
+			.end = dcr->base + dcr->decode_len - 1,
+		};
+
+		if (range_contains(&region_range, &ext_range)) {
+			dev_dbg(dev, "DC extent DPA [range 0x%016llx-0x%016llx] (DCR:%d:%#llx)(%pU)\n",
+				ext_range.start, ext_range.end, i, start - dcr->base,
+				extent->tag);
+			return 0;
+		}
+	}
+
+	dev_err_ratelimited(dev,
+			    "DC extent DPA [range 0x%016llx-0x%016llx] (%pU) is not in any DC region\n",
+			    ext_range.start, ext_range.end,
+			    extent->tag);
+	return -ENXIO;
+}
+
 void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 			    enum cxl_event_log_type type,
 			    enum cxl_event_type event_type,
@@ -1017,6 +1070,224 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
 	return rc;
 }
 
+static int send_one_response(struct cxl_mailbox *cxl_mbox,
+			     struct cxl_mbox_dc_response *response,
+			     int opcode, u32 extent_list_size, u8 flags)
+{
+	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
+		.opcode = opcode,
+		.size_in = struct_size(response, extent_list, extent_list_size),
+		.payload_in = response,
+	};
+
+	response->extent_list_size = cpu_to_le32(extent_list_size);
+	response->flags = flags;
+	return cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+}
+
+static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
+				struct xarray *extent_array, int cnt)
+{
+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	struct cxl_mbox_dc_response *p;
+	struct cxl_extent *extent;
+	unsigned long index;
+	u32 pl_index;
+
+	size_t pl_size = struct_size(p, extent_list, cnt);
+	u32 max_extents = cnt;
+
+	/* May have to use more bit on response. */
+	if (pl_size > cxl_mbox->payload_size) {
+		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
+			      sizeof(struct updated_extent_list);
+		pl_size = struct_size(p, extent_list, max_extents);
+	}
+
+	struct cxl_mbox_dc_response *response __free(kfree) =
+						kzalloc(pl_size, GFP_KERNEL);
+	if (!response)
+		return -ENOMEM;
+
+	if (cnt == 0)
+		return send_one_response(cxl_mbox, response, opcode, 0, 0);
+
+	pl_index = 0;
+	xa_for_each(extent_array, index, extent) {
+		response->extent_list[pl_index].dpa_start = extent->start_dpa;
+		response->extent_list[pl_index].length = extent->length;
+		pl_index++;
+
+		if (pl_index == max_extents) {
+			u8 flags = 0;
+			int rc;
+
+			if (pl_index < cnt)
+				flags |= CXL_DCD_EVENT_MORE;
+			rc = send_one_response(cxl_mbox, response, opcode,
+					       pl_index, flags);
+			if (rc)
+				return rc;
+			cnt -= pl_index;
+			pl_index = 0;
+		}
+	}
+
+	if (!pl_index) /* nothing more to do */
+		return 0;
+	return send_one_response(cxl_mbox, response, opcode, pl_index, 0);
+}
+
+void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct xarray extent_list;
+
+	struct cxl_extent extent = {
+		.start_dpa = cpu_to_le64(range->start),
+		.length = cpu_to_le64(range_len(range)),
+	};
+
+	dev_dbg(dev, "Release response dpa [range 0x%016llx-0x%016llx]\n",
+		range->start, range->end);
+
+	xa_init(&extent_list);
+	if (xa_insert(&extent_list, 0, &extent, GFP_KERNEL)) {
+		dev_dbg(dev, "Failed to release [range 0x%016llx-0x%016llx]\n",
+			range->start, range->end);
+		goto destroy;
+	}
+
+	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))
+		dev_dbg(dev, "Failed to release [range 0x%016llx-0x%016llx]\n",
+			range->start, range->end);
+
+destroy:
+	xa_destroy(&extent_list);
+}
+
+static int validate_add_extent(struct cxl_memdev_state *mds,
+			       struct cxl_extent *extent)
+{
+	int rc;
+
+	rc = cxl_validate_extent(mds, extent);
+	if (rc)
+		return rc;
+
+	return cxl_add_extent(mds, extent);
+}
+
+static int cxl_add_pending(struct cxl_memdev_state *mds)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent *extent;
+	unsigned long cnt = 0;
+	unsigned long index;
+	int rc;
+
+	xa_for_each(&mds->pending_extents, index, extent) {
+		if (validate_add_extent(mds, extent)) {
+			/*
+			 * Any extents which are to be rejected are omitted from
+			 * the response.  An empty response means all are
+			 * rejected.
+			 */
+			dev_dbg(dev, "unconsumed DC extent DPA:%#llx LEN:%#llx\n",
+				le64_to_cpu(extent->start_dpa),
+				le64_to_cpu(extent->length));
+			xa_erase(&mds->pending_extents, index);
+			kfree(extent);
+			continue;
+		}
+		cnt++;
+	}
+	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+				  &mds->pending_extents, cnt);
+	xa_for_each(&mds->pending_extents, index, extent) {
+		xa_erase(&mds->pending_extents, index);
+		kfree(extent);
+	}
+	return rc;
+}
+
+static int handle_add_event(struct cxl_memdev_state *mds,
+			    struct cxl_event_dcd *event)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent *extent;
+
+	extent = kmemdup(&event->extent, sizeof(*extent), GFP_KERNEL);
+	if (!extent)
+		return -ENOMEM;
+
+	if (xa_insert(&mds->pending_extents, (unsigned long)extent, extent,
+		      GFP_KERNEL)) {
+		kfree(extent);
+		return -ENOMEM;
+	}
+
+	if (event->flags & CXL_DCD_EVENT_MORE) {
+		dev_dbg(dev, "more bit set; delay the surfacing of extent\n");
+		return 0;
+	}
+
+	/* extents are removed and free'ed in cxl_add_pending() */
+	return cxl_add_pending(mds);
+}
+
+static char *cxl_dcd_evt_type_str(u8 type)
+{
+	switch (type) {
+	case DCD_ADD_CAPACITY:
+		return "add";
+	case DCD_RELEASE_CAPACITY:
+		return "release";
+	case DCD_FORCED_CAPACITY_RELEASE:
+		return "force release";
+	default:
+		break;
+	}
+
+	return "<unknown>";
+}
+
+static void cxl_handle_dcd_event_records(struct cxl_memdev_state *mds,
+					struct cxl_event_record_raw *raw_rec)
+{
+	struct cxl_event_dcd *event = &raw_rec->event.dcd;
+	struct cxl_extent *extent = &event->extent;
+	struct device *dev = mds->cxlds.dev;
+	uuid_t *id = &raw_rec->id;
+	int rc;
+
+	if (!uuid_equal(id, &CXL_EVENT_DC_EVENT_UUID))
+		return;
+
+	dev_dbg(dev, "DCD event %s : DPA:%#llx LEN:%#llx\n",
+		cxl_dcd_evt_type_str(event->event_type),
+		le64_to_cpu(extent->start_dpa), le64_to_cpu(extent->length));
+
+	switch (event->event_type) {
+	case DCD_ADD_CAPACITY:
+		rc = handle_add_event(mds, event);
+		break;
+	case DCD_RELEASE_CAPACITY:
+		rc = cxl_rm_extent(mds, &event->extent);
+		break;
+	case DCD_FORCED_CAPACITY_RELEASE:
+		dev_err_ratelimited(dev, "Forced release event ignored.\n");
+		rc = 0;
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc)
+		dev_err_ratelimited(dev, "dcd event failed: %d\n", rc);
+}
+
 static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 				    enum cxl_event_log_type type)
 {
@@ -1053,9 +1324,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 		if (!nr_rec)
 			break;
 
-		for (i = 0; i < nr_rec; i++)
+		for (i = 0; i < nr_rec; i++) {
 			__cxl_event_trace_record(cxlmd, type,
 						 &payload->records[i]);
+			if (type == CXL_EVENT_TYPE_DCD)
+				cxl_handle_dcd_event_records(mds,
+							&payload->records[i]);
+		}
 
 		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
 			trace_cxl_overflow(cxlmd, type, payload);
@@ -1087,6 +1362,8 @@ void cxl_mem_get_event_records(struct cxl_memdev_state *mds, u32 status)
 {
 	dev_dbg(mds->cxlds.dev, "Reading event logs: %x\n", status);
 
+	if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
+		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
 	if (status & CXLDEV_EVENT_STATUS_FATAL)
 		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FATAL);
 	if (status & CXLDEV_EVENT_STATUS_FAIL)
@@ -1632,9 +1909,21 @@ int cxl_mailbox_init(struct cxl_mailbox *cxl_mbox, struct device *host)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_mailbox_init, CXL);
 
+static void clear_pending_extents(void *_mds)
+{
+	struct cxl_memdev_state *mds = _mds;
+	struct cxl_extent *extent;
+	unsigned long index;
+
+	xa_for_each(&mds->pending_extents, index, extent)
+		kfree(extent);
+	xa_destroy(&mds->pending_extents);
+}
+
 struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
 {
 	struct cxl_memdev_state *mds;
+	int rc;
 
 	mds = devm_kzalloc(dev, sizeof(*mds), GFP_KERNEL);
 	if (!mds) {
@@ -1651,6 +1940,10 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
 	mds->pmem_perf.qos_class = CXL_QOS_CLASS_INVALID;
 	for (int i = 0; i < CXL_MAX_DC_REGION; i++)
 		mds->dc_perf[i].qos_class = CXL_QOS_CLASS_INVALID;
+	xa_init(&mds->pending_extents);
+	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
+	if (rc)
+		return ERR_PTR(rc);
 
 	return mds;
 }
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index a0c181cc33e4988e5c841d5b009d3d4aed5606c1..6ae51fc2bdae22fc25cc73773916714171512e92 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3036,6 +3036,7 @@ static void cxl_dax_region_release(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
 
+	ida_destroy(&cxlr_dax->extent_ida);
 	kfree(cxlr_dax);
 }
 
@@ -3089,6 +3090,8 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 
 	dev = &cxlr_dax->dev;
 	cxlr_dax->cxlr = cxlr;
+	cxlr->cxlr_dax = cxlr_dax;
+	ida_init(&cxlr_dax->extent_ida);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 46cc5ba502b2c46c68fd81c48b06f76f33282878..8a4c24ee7d216752a3351e29b9e5782a1a262f19 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -11,6 +11,8 @@
 #include <linux/log2.h>
 #include <linux/node.h>
 #include <linux/io.h>
+#include <linux/xarray.h>
+#include <cxl/event.h>
 
 extern const struct nvdimm_security_ops *cxl_security_ops;
 
@@ -169,11 +171,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
 #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
 #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
 #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
+#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
 
 #define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
 				 CXLDEV_EVENT_STATUS_WARN |	\
 				 CXLDEV_EVENT_STATUS_FAIL |	\
-				 CXLDEV_EVENT_STATUS_FATAL)
+				 CXLDEV_EVENT_STATUS_FATAL |	\
+				 CXLDEV_EVENT_STATUS_DCD)
 
 /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
 #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
@@ -443,6 +447,18 @@ enum cxl_decoder_state {
 	CXL_DECODER_STATE_AUTO,
 };
 
+/**
+ * struct cxled_extent - Extent within an endpoint decoder
+ * @cxled: Reference to the endpoint decoder
+ * @dpa_range: DPA range this extent covers within the decoder
+ * @tag: Tag from device for this extent
+ */
+struct cxled_extent {
+	struct cxl_endpoint_decoder *cxled;
+	struct range dpa_range;
+	u8 tag[CXL_EXTENT_TAG_LEN];
+};
+
 /**
  * struct cxl_endpoint_decoder - Endpoint  / SPA to DPA decoder
  * @cxld: base cxl_decoder_object
@@ -568,6 +584,7 @@ struct cxl_region_params {
  * @type: Endpoint decoder target type
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
+ * @cxlr_dax: (for DC regions) cached copy of CXL DAX bridge
  * @flags: Region state flags
  * @params: active + config params for the region
  * @coord: QoS access coordinates for the region
@@ -581,6 +598,7 @@ struct cxl_region {
 	enum cxl_decoder_type type;
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
+	struct cxl_dax_region *cxlr_dax;
 	unsigned long flags;
 	struct cxl_region_params params;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
@@ -621,12 +639,45 @@ struct cxl_pmem_region {
 	struct cxl_pmem_region_mapping mapping[];
 };
 
+/* See CXL 3.1 8.2.9.2.1.6 */
+enum dc_event {
+	DCD_ADD_CAPACITY,
+	DCD_RELEASE_CAPACITY,
+	DCD_FORCED_CAPACITY_RELEASE,
+	DCD_REGION_CONFIGURATION_UPDATED,
+};
+
 struct cxl_dax_region {
 	struct device dev;
 	struct cxl_region *cxlr;
 	struct range hpa_range;
+	struct ida extent_ida;
 };
 
+/**
+ * struct region_extent - CXL DAX region extent
+ * @dev: device representing this extent
+ * @cxlr_dax: back reference to parent region device
+ * @hpa_range: HPA range of this extent
+ * @tag: tag of the extent
+ * @decoder_extents: Endpoint decoder extents which make up this region extent
+ */
+struct region_extent {
+	struct device dev;
+	struct cxl_dax_region *cxlr_dax;
+	struct range hpa_range;
+	uuid_t tag;
+	struct xarray decoder_extents;
+};
+
+bool is_region_extent(struct device *dev);
+static inline struct region_extent *to_region_extent(struct device *dev)
+{
+	if (!is_region_extent(dev))
+		return NULL;
+	return container_of(dev, struct region_extent, dev);
+}
+
 /**
  * struct cxl_port - logical collection of upstream port devices and
  *		     downstream port devices to construct a CXL memory
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 863899b295b719b57638ee060e494e5cf2d639fd..73dee28bbd803a8f78686e833f8ef3492ca94e66 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -7,6 +7,7 @@
 #include <linux/cdev.h>
 #include <linux/uuid.h>
 #include <linux/node.h>
+#include <linux/xarray.h>
 #include <cxl/event.h>
 #include <cxl/mailbox.h>
 #include "cxl.h"
@@ -506,6 +507,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @pmem_perf: performance data entry matched to PMEM partition
  * @nr_dc_region: number of DC regions implemented in the memory device
  * @dc_region: array containing info about the DC regions
+ * @pending_extents: array of extents pending during more bit processing
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -538,6 +540,7 @@ struct cxl_memdev_state {
 	u8 nr_dc_region;
 	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
 	struct cxl_dpa_perf dc_perf[CXL_MAX_DC_REGION];
+	struct xarray pending_extents;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -609,6 +612,21 @@ enum cxl_opcode {
 	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
 		  0x40, 0x3d, 0x86)
 
+/*
+ * Add Dynamic Capacity Response
+ * CXL rev 3.1 section 8.2.9.9.9.3; Table 8-168 & Table 8-169
+ */
+struct cxl_mbox_dc_response {
+	__le32 extent_list_size;
+	u8 flags;
+	u8 reserved[3];
+	struct updated_extent_list {
+		__le64 dpa_start;
+		__le64 length;
+		u8 reserved[8];
+	} __packed extent_list[];
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];
@@ -671,6 +689,14 @@ struct cxl_mbox_identify {
 	UUID_INIT(0xfe927475, 0xdd59, 0x4339, 0xa5, 0x86, 0x79, 0xba, 0xb1, \
 		  0x13, 0xb7, 0x74)
 
+/*
+ * Dynamic Capacity Event Record
+ * CXL rev 3.1 section 8.2.9.2.1; Table 8-43
+ */
+#define CXL_EVENT_DC_EVENT_UUID                                             \
+	UUID_INIT(0xca95afa7, 0xf183, 0x4018, 0x8c, 0x2f, 0x95, 0x26, 0x8e, \
+		  0x10, 0x1a, 0x2a)
+
 /*
  * Get Event Records output payload
  * CXL rev 3.0 section 8.2.9.2.2; Table 8-50
@@ -696,6 +722,7 @@ enum cxl_event_log_type {
 	CXL_EVENT_TYPE_WARN,
 	CXL_EVENT_TYPE_FAIL,
 	CXL_EVENT_TYPE_FATAL,
+	CXL_EVENT_TYPE_DCD,
 	CXL_EVENT_TYPE_MAX
 };
 
diff --git a/include/cxl/event.h b/include/cxl/event.h
index 0bea1afbd747c4937b15703b581c569e7fa45ae4..eeda8059d81abef2fbf28cd3f3a6e516c9710229 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -96,11 +96,43 @@ struct cxl_event_mem_module {
 	u8 reserved[0x3d];
 } __packed;
 
+/*
+ * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-51
+ */
+#define CXL_EXTENT_TAG_LEN 0x10
+struct cxl_extent {
+	__le64 start_dpa;
+	__le64 length;
+	u8 tag[CXL_EXTENT_TAG_LEN];
+	__le16 shared_extn_seq;
+	u8 reserved[0x6];
+} __packed;
+
+/*
+ * Dynamic Capacity Event Record
+ * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-50
+ */
+#define CXL_DCD_EVENT_MORE			BIT(0)
+struct cxl_event_dcd {
+	struct cxl_event_record_hdr hdr;
+	u8 event_type;
+	u8 validity_flags;
+	__le16 host_id;
+	u8 region_index;
+	u8 flags;
+	u8 reserved1[0x2];
+	struct cxl_extent extent;
+	u8 reserved2[0x18];
+	__le32 num_avail_extents;
+	__le32 num_avail_tags;
+} __packed;
+
 union cxl_event {
 	struct cxl_event_generic generic;
 	struct cxl_event_gen_media gen_media;
 	struct cxl_event_dram dram;
 	struct cxl_event_mem_module mem_module;
+	struct cxl_event_dcd dcd;
 	/* dram & gen_media event header */
 	struct cxl_event_media_hdr media_hdr;
 } __packed;
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index b1256fee3567fc7743812ee14bc46e09b7c8ba9b..bfa19587fd763ed552c2b9aa1a6e8981b6aa1c40 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -62,7 +62,8 @@ cxl_core-y += $(CXL_CORE_SRC)/hdm.o
 cxl_core-y += $(CXL_CORE_SRC)/pmu.o
 cxl_core-y += $(CXL_CORE_SRC)/cdat.o
 cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
-cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
+cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o \
+				 $(CXL_CORE_SRC)/extent.o
 cxl_core-y += config_check.o
 cxl_core-y += cxl_core_test.o
 cxl_core-y += cxl_core_exports.o

-- 
2.47.0

