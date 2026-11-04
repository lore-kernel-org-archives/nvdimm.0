Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833393;
	b=pOBquOuYGutFRIHCA9G0f6Y21dUg13rqz41Y78v2KpR7OnnCbhjZTIY9DX0jvJw1eVi4
	 yfNipGgxa/0WKinSBDKsNouy00eMdtkzkqiKL8OAz5Ge3o9Dbi4IoEqQQjywHlcDgWAdw
	 swMdgeE3v43B9iDNQxMIqE3G8sxiQtfQ/SmK/XAW2NRv/MYMyxyIo3NO28VImAnRil5pK
	 4fqGU2Bd78HxOzQX5iFttZFqNJgUCa+tqQNXno6sYKMChK1ouwmVpPC6u4HvsKItjbVnf
	 G7iIqjE0tpYSBiGmsZ8HWfulyg3VsJlZsmr3Meb8idAcaj3iW8bnxYnGKNwU8atYthA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uBOj0MpEU21dHCbR2d//S8bvH9LfZBaUlAFlXvsTngM=;
	b=QNG/fNHn0IXbwvFtQNvbUco0xkjKrHylfj81QTXEDjWdMgtIJtmZ96HwijBl07dPt8za
	 4Hjt0JL59zIRLrezwNyuTnEaXHIHeFlaUPDZ5kJ9i4DghHdUP58EgAARIBtUxy1eSpm3Z
	 N1ieP8/tQo//0iTqfxRa/1tqZTeJCt2CqTSAAQODsZ7d6Tcnx12MaksS1dczydEpijXk1
	 gnLI7dqH367ruy0g5pKp1by5/rwTu8oovqgZGpPKeoakH/8pmU3NOu0OQBsCKm+UrPrLU
	 nWkeEVBlmoGoVEJ8MNUouWEWbCg5eoo55EHZehfVEYHI5qthxjsXF5RfpCtijzlb6jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x7BBpCEt;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0939606D803
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0939606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x7BBpCEt
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e987a2ba0cso7091275ad.3
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833392; x=1794438192; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uBOj0MpEU21dHCbR2d//S8bvH9LfZBaUlAFlXvsTngM=;
        b=x7BBpCEtoiRaagsofE7jVkeJuTnaEkkMkVg5mLHudy59MTlnYoWf6Grz9vpklWbzle
         H+Hytzfp3OUKvlTWIfXCpUkoqLU9rt7qXJ3OCgPBJu+5CQvcgvIT866B544MmkqaMoXK
         nnRU0VL3DbpabQHBS1rXQK4QqnTyADGw7dIXZwOrsfuFPvHVpzO6e9NSf2VR2xkpUitH
         nnxdlc/BookRE6DAt1jg8gK/xzfMc9R0JaJ3r1GIgTKFc18pOHuyvLXiHH0Gq9nv7E/r
         weJ1SU9q44gp9yPu1L3owWva6Fas0ML6VZUA6Qa7dRW4tinD9usccDrB6cBzQH/hngyi
         gDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833392; x=1794438192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uBOj0MpEU21dHCbR2d//S8bvH9LfZBaUlAFlXvsTngM=;
        b=pLRWd93dXkiZr41fwg7D4adMzvJ0Xe9wz7YEyC/ArTrN7wNuCN6l6jM0ZbGtmr5kWt
         HkmO9m/0g98aR4Hup+F1gufDXo0m7vUUTKTCzrgKkbaQTFWNCxXWoUoo1G8lYay6RHm/
         v1sX93uomHEapPVtkUnU872qb7+9GlR7yXu2aphQ29H76QwcKCpLbYA7BiVzAjwfiqNO
         1cfIdNfm2XnZ7JVLfNTzsrjXR/3FknyGK9epe610NNdT+qwdqpD7bC9lHOwfv5xmSy9x
         nvcGH4KQ3eH1Qbq0+L8gtKdPVIxw82CV3DO4HXL6xQhfJNX1ID3lW7sKVnOUW2A19qe1
         yuow==
X-Gm-Message-State: APuU4Z+0NlTymJ4kI7fLQCdCRGBao3R0QsA59Mjlp7kpeWZjkrIxz61j
	addpWhAovrPDYT6Ykio7kOKLa118sAoWMUKSnuNbaJroI9frHX8a0H6E
X-Gm-Gg: AYBFou1UUMOh6LxSG/SWyBh0uLQBmdjbLB7IHPzHkK8KPJGDlgdgXhHP2vXBZbNlPXj
	FW1jZYMgIO5EvRyO7G6dEqfeqj09019DHRUrqNdulx2pCjawp9JD9B7CvmLM7swdRMg2Gf35P4p
	BYtUqURUOfgaGr7X+jFGFh6nw3KcKVK8+wX/oUkud5TqDJPgPlGv7yxXoQvalChEDGw+jhjundP
	yN+t1V+ghYi7Okw/crAtX4Eul2gzRPZiYFIH38qOgWC/GqquXIC3QALfpYZ8Z5U37BoOvovzwxM
	9/arE89FZQXkGbUF0EwTGDNvGkJT3NKn/jrusXonRNIxxZ0cR+R31BhUqsXMNo1ldqOuXqaeNTT
	YE2CbZ6mcHxRIffCCfRhM8dMIeEnFvbhT304X5JRC28v4QavPYB4N5M3DVKoDF6fGeatMV4/QUI
	+MHmTn9gUOU9vB43Ga+jCgEI+0lDjqXwxvSDXcV6LA3bmSmrFm7YWrhznO2XZ7HixTh8TzzZF+P
	FsH5aE5kgLVJF72n3cCazNSmI50P1qPVgaW1Z24ytzNEdXgYEJvRFRt9DaiAhU97Mlzzzwkg1yR
	gjCAzF1sBm6fHy3OPnoNN0hwl73DMQ==
X-Received: by 2002:a17:903:3c4e:b0:2e6:136e:f264 with SMTP id d9443c01a7336-2eb364e56d1mr174540005ad.50.1793833391576;
        Wed, 04 Nov 2026 15:03:11 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:03:11 -0800 (PST)
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
Subject: [PATCH v1 12/14] cxl/region: Read existing extents on region creation
Date: Thu,  5 Nov 2026 08:02:36 +0900
Message-ID: <20261104230445.66625-13-anisa.su@samsung.com>
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

Dynamic capacity device extents may be left in an accepted state on a
device due to an unexpected host crash.  In this case it is expected
that the creation of a new region on top of a DC partition can read
those extents and surface them for continued use.

Once all endpoint decoders are part of a region and the region is being
created, a read of the device's extent list can reveal these
previously accepted extents.

CXL r4.0 Section 8.2.10.9.9.2 specifies the mailbox call Get Dynamic
Capacity Extent List for this purpose.  The call returns all the extents
for all dynamic capacity partitions, so only the extents inside the
region's decoder DPA range are accepted.  The rest belong to other
regions, or to partitions Linux does not map, so are not tracked on the
current region.  If the fabric manager is adding extents to any DCD
partition, the extent list for the recovered region may change; the
generation number changing between queries is detected and the read is
retried.

The dax_region device probes asynchronously, so the extent list is
read from the cxl_dax_region probe, not at region creation.  Onlining
a recovered group attaches its devres teardown to the dax_region
device, and devres present before a probe starts makes the driver
core refuse to bind ("Resources present before probing").

The same asynchrony means the region can detach its decoder before or
while the probe runs, and the scan needs that decoder throughout: its
DPA range filters the extent list, and every recovered extent is
resolved through it back to the region.  So cxl_dax_region_alloc()
records the decoder in cxlr_dax->cxled with a reference, which keeps
it valid until the dax_region is released.  A detach mid-scan then
just makes the remaining extents resolve to no region, and the group
is released back to the device.

New add events for a region are refused until that region's pre-existing
extents have been read, so a tag already in use is never registered twice.
Unbinding the dax driver returns every extent to the device.

Recovered extents are already accepted on the device, so no Add
response follows the scan.  cxl_add_extent() and cxl_add_pending()
take an 'existing' flag for this, and a recovered group that fails
validation or online is released back to the device with Release DC
instead of being left out of a response.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/core.h       |   6 +-
 drivers/cxl/core/extent.c     |  18 ++-
 drivers/cxl/core/mbox.c       | 218 +++++++++++++++++++++++++++++++++-
 drivers/cxl/core/region_dax.c |  47 ++++++++
 drivers/cxl/cxl.h             |  18 +++
 drivers/cxl/cxlmem.h          |  21 ++++
 drivers/dax/cxl.c             |  27 ++++-
 7 files changed, 341 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index f0edd0100c72..e69167818cb5 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -37,6 +37,7 @@ static inline bool cxled_dcd_enabled(struct cxl_endpoint_decoder *cxled)
 
 const char *cxl_dc_mode_name(bool shareable, bool read_only);
 int cxl_dc_mode_parse(const char *buf, bool *shareable, bool *read_only);
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled);
 
 #ifdef CONFIG_CXL_REGION
 
@@ -78,7 +79,7 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 void kill_regions(struct cxl_root_decoder *cxlrd);
 
 int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
-		   u16 seq_num);
+		   u16 seq_num, bool existing);
 int cxl_resolve_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 		       struct cxl_region **cxlrp,
 		       struct cxl_dc_tag_group **groupp);
@@ -101,7 +102,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 }
 
 static inline int cxl_add_extent(struct cxl_memdev_state *mds,
-				 struct cxl_extent *extent, u16 seq_num)
+				 struct cxl_extent *extent, u16 seq_num,
+				 bool existing)
 {
 	return -ENXIO;
 }
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 1873a3dfe8e0..2abc00f7f55d 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -230,7 +230,7 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 			       struct cxl_extent *extent,
 			       struct cxl_endpoint_decoder **out_cxled,
 			       struct cxl_dax_region **out_cxlr_dax,
-			       struct range *out_ext_range)
+			       struct range *out_ext_range, bool existing)
 {
 	u64 start_dpa = le64_to_cpu(extent->start_dpa);
 	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
@@ -271,6 +271,17 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 	if (!cxlr || !cxlr->cxlr_dax)
 		return -ENXIO;
 
+	/*
+	 * New adds wait for a bound dax driver that has read the device's
+	 * pre-existing extents, so a tag already in use is never added twice.
+	 */
+	if (!existing && !smp_load_acquire(&cxlr->cxlr_dax->extents_scanned)) {
+		dev_warn_ratelimited(dev,
+				     "DC extent DPA %pra: dax driver not ready, refusing\n",
+				     &ext_range);
+		return -EBUSY;
+	}
+
 	ed_range = (struct range) {
 		.start = cxled->dpa_res->start,
 		.end = cxled->dpa_res->end,
@@ -406,7 +417,7 @@ static int cxlr_add_extent(struct cxl_memdev_state *mds,
  * Returns 0 for a successfully added extent and <0 on error.
  */
 int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
-		   u16 seq_num)
+		   u16 seq_num, bool existing)
 {
 	struct cxl_endpoint_decoder *cxled;
 	struct cxl_dax_region *cxlr_dax;
@@ -418,7 +429,8 @@ int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 	lockdep_assert_held(&cxl_rwsem.region);
 	lockdep_assert_held(&cxl_rwsem.dpa);
 
-	rc = cxl_validate_extent(mds, extent, &cxled, &cxlr_dax, &ext_range);
+	rc = cxl_validate_extent(mds, extent, &cxled, &cxlr_dax, &ext_range,
+				 existing);
 	if (rc)
 		return rc;
 
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index c3236fe9e7c5..a18b41ff5d23 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1452,6 +1452,19 @@ static void extract_tag_group(struct list_head *pending,
 	}
 }
 
+/*
+ * Recovered extents are already the host's: a group the host will not keep
+ * goes back to the device rather than leaking there.
+ */
+static void cxl_release_recovered(struct cxl_memdev_state *mds,
+				  const uuid_t *tag, struct list_head *group)
+{
+	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, group,
+				 list_count_nodes(group)))
+		dev_dbg(mds->cxlds.dev,
+			"Tag %pUb: failed to release recovered extents\n", tag);
+}
+
 /*
  * Validate shared_extn_seq across a tag group from a sharable partition,
  * already sorted ascending.  Per CXL r4.0 Table 8-230 the device stamps
@@ -1573,7 +1586,8 @@ static int cxl_check_group_partition(struct cxl_memdev_state *mds,
  * the caller to drop.
  */
 static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
-			     struct list_head *group, bool shareable)
+			     struct list_head *group, bool shareable,
+			     bool existing)
 {
 	struct device *dev = mds->cxlds.dev;
 	struct cxl_extent_list_node *pos;
@@ -1594,7 +1608,7 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 		else
 			seq_num++;
 
-		rc = cxl_add_extent(mds, pos->extent, seq_num);
+		rc = cxl_add_extent(mds, pos->extent, seq_num, existing);
 		if (rc < 0) {
 			dev_dbg(dev,
 				"Tag %pUb: dropping group, failed to add extent DPA:%#llx LEN:%#llx\n",
@@ -1612,7 +1626,7 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 	if (rc) {
 		dev_warn(dev, "Tag %pUb: failed to online tag group (%d)\n",
 			 tag, rc);
-		return rc;
+		goto err_release;
 	}
 
 	return group_cnt;
@@ -1627,6 +1641,10 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 	mds->dc_chain.group = NULL;
 	if (tag_group)
 		discard_tag_group(tag_group);
+err_release:
+	/* A fresh group is simply left out of the Add response */
+	if (existing)
+		cxl_release_recovered(mds, tag, group);
 	return rc;
 }
 
@@ -1686,11 +1704,14 @@ static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t *tag,
  * list.
  */
 static int cxl_add_pending(struct cxl_memdev_state *mds,
-			   struct list_head *pending)
+			   struct list_head *pending, bool existing)
 {
 	LIST_HEAD(accepted);
 	int total_accepted = 0;
 
+	/* Realizing a group builds through mds->dc_chain.group */
+	lockdep_assert_held(&mds->dc_chain.lock);
+
 	/*
 	 * Held across validation, add and online so that cxlr_dax_unpublish()
 	 * excludes a whole flush; cxl_dpa_to_region() also walks every dpa_res.
@@ -1727,11 +1748,13 @@ static int cxl_add_pending(struct cxl_memdev_state *mds,
 		shareable = cxl_group_is_shareable(mds, &group);
 
 		if (cxl_validate_group(mds, &tag, &group, shareable)) {
+			if (existing)
+				cxl_release_recovered(mds, &tag, &group);
 			drop_extent_group(&group);
 			continue;
 		}
 
-		cnt = cxl_realize_group(mds, &tag, &group, shareable);
+		cnt = cxl_realize_group(mds, &tag, &group, shareable, existing);
 		if (cnt < 0) {
 			drop_extent_group(&group);
 			continue;
@@ -1743,6 +1766,14 @@ static int cxl_add_pending(struct cxl_memdev_state *mds,
 
 	list_splice(&accepted, pending);
 
+	/*
+	 * Recovered (already-accepted) extents must not be re-reported in an
+	 * Add-DC-Response: the device rejects a DPA range already added by a
+	 * previous response (CXL r4.0 8.2.10.9.9.3, Invalid Physical Address).
+	 */
+	if (existing)
+		return 0;
+
 	return cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
 				    pending, total_accepted);
 }
@@ -1895,7 +1926,8 @@ static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
 	cancel_delayed_work(&chain->timeout_work);
 
 	if (event->event_type == DCD_ADD_CAPACITY)
-		rc = cxl_add_pending(mds, &chain->pending_extents);
+		/* Fresh add events: extents are not yet accepted (not existing). */
+		rc = cxl_add_pending(mds, &chain->pending_extents, false);
 	else
 		rc = cxl_rm_pending(mds);
 	clear_pending_extents(mds);
@@ -2439,6 +2471,180 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
 
+/*
+ * Stage the device's extents inside @dpa_range on @existing.  Returns
+ * -EAGAIN if the list changes while it is being read.
+ */
+static int cxl_read_extent_list(struct cxl_memdev_state *mds,
+				const struct range *dpa_range,
+				struct list_head *existing)
+{
+	u32 current_index, total_read, total_expected, initial_gen_num;
+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_mbox_cmd mbox_cmd;
+	u32 max_extent_count;
+	bool first = true;
+	int rc;
+
+	struct cxl_mbox_get_extent_out *extents __free(kvfree) =
+				kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
+	if (!extents)
+		return -ENOMEM;
+
+	total_read = 0;
+	current_index = 0;
+	total_expected = 0;
+	max_extent_count = (cxl_mbox->payload_size - sizeof(*extents)) /
+			    sizeof(struct cxl_extent);
+	do {
+		u32 nr_returned, current_total, current_gen_num;
+		struct cxl_mbox_get_extent_in get_extent;
+
+		get_extent = (struct cxl_mbox_get_extent_in) {
+			.extent_cnt = cpu_to_le32(max_extent_count),
+			.start_extent_index = cpu_to_le32(current_index),
+		};
+
+		mbox_cmd = (struct cxl_mbox_cmd) {
+			.opcode = CXL_MBOX_OP_GET_DC_EXTENT_LIST,
+			.payload_in = &get_extent,
+			.size_in = sizeof(get_extent),
+			.size_out = cxl_mbox->payload_size,
+			.payload_out = extents,
+			.min_out = sizeof(*extents),
+		};
+
+		rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+		if (rc < 0)
+			return rc;
+
+		/* Save initial data */
+		if (first) {
+			total_expected = le32_to_cpu(extents->total_extent_count);
+			initial_gen_num = le32_to_cpu(extents->generation_num);
+			first = false;
+		}
+
+		nr_returned = le32_to_cpu(extents->returned_extent_count);
+		if (nr_returned > max_extent_count ||
+		    struct_size(extents, extent, nr_returned) > mbox_cmd.size_out) {
+			dev_err(dev, "Extent list returned %u extents, asked for %u in %zu bytes\n",
+				nr_returned, max_extent_count, mbox_cmd.size_out);
+			return -EIO;
+		}
+		total_read += nr_returned;
+		current_total = le32_to_cpu(extents->total_extent_count);
+		current_gen_num = le32_to_cpu(extents->generation_num);
+
+		dev_dbg(dev, "Got extent list %d-%d of %d generation Num:%d\n",
+			current_index, total_read ? total_read - 1 : 0,
+			current_total, current_gen_num);
+
+		if (current_gen_num != initial_gen_num || total_expected != current_total) {
+			dev_warn(dev, "Extent list change detected; gen %u != %u : cnt %u != %u\n",
+				 current_gen_num, initial_gen_num,
+				 total_expected, current_total);
+			return -EAGAIN;
+		}
+
+		/* No progress with more expected: a buggy device would loop forever. */
+		if (!nr_returned && total_expected > total_read) {
+			dev_warn(dev, "Device returned 0 of %u remaining extents\n",
+				 total_expected - total_read);
+			return -EIO;
+		}
+
+		for (int i = 0; i < nr_returned ; i++) {
+			struct cxl_extent *extent = &extents->extent[i];
+			struct range ext_range;
+
+			ext_range.start = le64_to_cpu(extent->start_dpa);
+			ext_range.end = ext_range.start +
+					le64_to_cpu(extent->length) - 1;
+			dev_dbg(dev, "Processing extent %d/%d %pra (%pUb) seq %u\n",
+				current_index + i, total_expected, &ext_range,
+				extent->uuid,
+				le16_to_cpu(extent->shared_extn_seq));
+			/* Another region's, or an unmapped partition's: not ours */
+			if (!range_contains(dpa_range, &ext_range))
+				continue;
+			rc = stage_pending_extent(existing, extent);
+			if (rc)
+				return rc;
+		}
+
+		current_index += nr_returned;
+	} while (total_expected > total_read);
+
+	return 0;
+}
+
+static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+	struct range dpa_range;
+	LIST_HEAD(existing);
+	int rc;
+
+	/*
+	 * The list covers every DC partition and region of the device; only
+	 * the extents inside this decoder's DPA range are this region's.
+	 */
+	scoped_guard(rwsem_read, &cxl_rwsem.dpa) {
+		if (!cxled->dpa_res)
+			return -ENXIO;
+		dpa_range = (struct range) {
+			.start = cxled->dpa_res->start,
+			.end = cxled->dpa_res->end,
+		};
+	}
+
+	/*
+	 * Realizing a group goes through mds->dc_chain.group, shared with the
+	 * event path, so hold its lock.  Stage into a private list so an event
+	 * chain the device left open is not consumed as existing extents.
+	 */
+	guard(mutex)(&mds->dc_chain.lock);
+
+	rc = cxl_read_extent_list(mds, &dpa_range, &existing);
+
+	/*
+	 * Already accepted on the device: no Add response is sent for existing
+	 * extents, and one that fails validation or online is released back to
+	 * the device rather than dropped.
+	 */
+	if (!rc && !list_empty(&existing))
+		rc = cxl_add_pending(mds, &existing, true);
+	drop_extent_group(&existing);
+
+	return rc;
+}
+
+#define CXL_READ_EXTENT_LIST_RETRY 10
+
+/**
+ * cxl_process_extent_list() - Read existing extents
+ * @cxled: Endpoint decoder which is part of a region
+ *
+ * Issue the Get Dynamic Capacity Extent List command to the device
+ * and add existing extents if found.
+ *
+ * A retry of 10 is somewhat arbitrary, however, extent changes should be
+ * relatively rare while bringing up a region.  So 10 should be plenty.
+ */
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	int retry = CXL_READ_EXTENT_LIST_RETRY;
+	int rc;
+
+	do {
+		rc = __cxl_process_extent_list(cxled);
+	} while (rc == -EAGAIN && --retry);
+
+	return rc;
+}
+
 int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
index 790176a8aadd..816386301b80 100644
--- a/drivers/cxl/core/region_dax.c
+++ b/drivers/cxl/core/region_dax.c
@@ -13,6 +13,8 @@ static void cxl_dax_region_release(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
 
+	if (cxlr_dax->cxled)
+		put_device(&cxlr_dax->cxled->cxld.dev);
 	xa_destroy(&cxlr_dax->dc_extents);
 	ida_destroy(&cxlr_dax->tag_group_ida);
 	kfree(cxlr_dax);
@@ -79,6 +81,15 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 	cxlr_dax->hpa_range.start = p->res->start;
 	cxlr_dax->hpa_range.end = p->res->end;
 
+	/*
+	 * DC regions are not interleaved; the probe-time scan uses this decoder
+	 * and may outlive its attachment to the region, so hold a reference.
+	 */
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM)
+		cxlr_dax->cxled = p->targets[0];
+	if (cxlr_dax->cxled)
+		get_device(&cxlr_dax->cxled->cxld.dev);
+
 	dev = &cxlr_dax->dev;
 	cxlr_dax->cxlr = cxlr;
 	cxlr->cxlr_dax = cxlr_dax;
@@ -153,6 +164,42 @@ DEFINE_FREE(unpublish_cxl_dax_region, struct cxl_dax_region *,
 		put_device(&_T->dev);
 	})
 
+/*
+ * Runs from cxl_dax_region_probe().  The region's parameters may not be
+ * read here: a concurrent detach clears p->targets[] under cxl_rwsem.region
+ * before it waits for this probe.  Use the decoder recorded at allocation
+ * instead; cxlr_dax holds a reference on it.
+ */
+int cxl_region_add_existing_extents(struct cxl_dax_region *cxlr_dax)
+{
+	struct cxl_endpoint_decoder *cxled = cxlr_dax->cxled;
+	int rc;
+
+	rc = cxl_process_extent_list(cxled);
+	if (rc) {
+		dev_err(&cxled->cxld.dev, "Existing extent processing failed %d\n",
+			rc);
+		return rc;
+	}
+
+	/* Pairs with the acquire in cxl_validate_extent(); adds may proceed */
+	smp_store_release(&cxlr_dax->extents_scanned, true);
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_region_add_existing_extents, "CXL");
+
+/*
+ * Driver unbind returns the held extents to the device (devres), so refuse
+ * new adds until the next probe has read the device's list again.
+ */
+void cxl_region_reset_extent_scan(struct cxl_dax_region *cxlr_dax)
+{
+	/* Adds test the gate under cxl_rwsem.region; none is mid-flight after this */
+	guard(rwsem_write)(&cxl_rwsem.region);
+	cxlr_dax->extents_scanned = false;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_region_reset_extent_scan, "CXL");
+
 int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 {
 	struct device *dev;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 79f5773f8f81..cf109f119bc4 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -619,6 +619,10 @@ struct cxl_dax_region {
 	struct ida tag_group_ida;
 	/* parent of the extentX.Y devices of untagged allocations */
 	struct device untagged;
+	/* The region's single endpoint decoder, for the probe-time extent scan */
+	struct cxl_endpoint_decoder *cxled;
+	/* Set once the probe has read the device's pre-existing extents. */
+	bool extents_scanned;
 };
 
 /**
@@ -1006,6 +1010,8 @@ bool is_cxl_pmem_region(struct device *dev);
 struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
+int cxl_region_add_existing_extents(struct cxl_dax_region *cxlr_dax);
+void cxl_region_reset_extent_scan(struct cxl_dax_region *cxlr_dax);
 bool cxl_region_contains_resource(const struct resource *res);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
@@ -1024,6 +1030,18 @@ static inline struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
 {
 	return NULL;
 }
+
+static inline int
+cxl_region_add_existing_extents(struct cxl_dax_region *cxlr_dax)
+{
+	return 0;
+}
+
+static inline void
+cxl_region_reset_extent_scan(struct cxl_dax_region *cxlr_dax)
+{
+}
+
 static inline bool cxl_region_contains_resource(const struct resource *res)
 {
 	return false;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 73f01efc0172..3acd4e0e1725 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -592,6 +592,27 @@ struct cxl_mbox_dc_response {
 	} __packed extent_list[] __counted_by_le(extent_list_size);
 } __packed;
 
+/*
+ * Get Dynamic Capacity Extent List; Input Payload
+ * CXL r4.0 section 8.2.10.9.9.2; Table 8-348
+ */
+struct cxl_mbox_get_extent_in {
+	__le32 extent_cnt;
+	__le32 start_extent_index;
+} __packed;
+
+/*
+ * Get Dynamic Capacity Extent List; Output Payload
+ * CXL r4.0 section 8.2.10.9.9.2; Table 8-349
+ */
+struct cxl_mbox_get_extent_out {
+	__le32 returned_extent_count;
+	__le32 total_extent_count;
+	__le32 generation_num;
+	u8 rsvd[4];
+	struct cxl_extent extent[];
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 43eb18c8a035..7cc512e4b3c6 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -6,6 +6,12 @@
 #include "../cxl/cxl.h"
 #include "bus.h"
 
+static void cxl_dax_region_remove(struct device *dev)
+{
+	/* Refuse new adds; devres returns the held extents */
+	cxl_region_reset_extent_scan(to_cxl_dax_region(dev));
+}
+
 static int cxl_dax_region_probe(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
@@ -15,6 +21,7 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct dev_dax_data data;
 	resource_size_t dev_size;
 	unsigned long flags;
+	int rc;
 
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
@@ -29,11 +36,17 @@ static int cxl_dax_region_probe(struct device *dev)
 	if (!dax_region)
 		return -ENOMEM;
 
-	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM)
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM) {
+		/* Recover extents the device still holds for this region */
+		rc = cxl_region_add_existing_extents(cxlr_dax);
+		if (rc)
+			goto err_remove;
+
 		/* Add empty seed dax device */
 		dev_size = 0;
-	else
+	} else {
 		dev_size = range_len(&cxlr_dax->hpa_range);
+	}
 
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
@@ -42,12 +55,20 @@ static int cxl_dax_region_probe(struct device *dev)
 		.memmap_on_memory = true,
 	};
 
-	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
+	rc = PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
+	if (rc)
+		goto err_remove;
+	return 0;
+
+err_remove:
+	cxl_dax_region_remove(dev);
+	return rc;
 }
 
 static struct cxl_driver cxl_dax_region_driver = {
 	.name = "cxl_dax_region",
 	.probe = cxl_dax_region_probe,
+	.remove = cxl_dax_region_remove,
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
-- 
2.43.0

