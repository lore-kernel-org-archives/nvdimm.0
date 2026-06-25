Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA563DB640
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386936; cv=none; b=NFA9xSvqIPnkJrvE0kFK4uo5HxXmf+iIaSRKfcAm5miNdU1J7AWYXfXHnK3+eNgBwQxyzapGq46znStfA2WIPMiZPC7pdV3rYNHXpAB98D7a4uaa1MCUFD+a2SxzArS43poAhiXZkJKfaeQugfxZHfrmVxSYphDALfb1wR7kkqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386936; c=relaxed/simple;
	bh=iRV3zJua3YjjDCukOTOZM9/VcvYWYMRYJy6sBKQlQTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7T4d97k94FJ2IUiefgiq4jydKI08pWnHY1U4vwjeq4Vzzyivq8CGir1X1ckLh18ukuvYQ/zJuDyZW6+dJpRMDAanaNI2dOQ9/iUr+T0JLl3YH0ri5WSrL7lQSDIWSBS+/dshPHnuXB6Sh7oajfMxyzbxB6wvoU3QB7Tkvw6C1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ey40ZqWf; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ey40ZqWf"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-137dd4cc208so1045464c88.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386934; x=1782991734; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yO8ck1Me4UpWQp5jQ9zT9mWfZ1zNBaFnVEK0MMob63Y=;
        b=Ey40ZqWfhXLFjX3wbVIrnR7/3O09NGergEqHkzUMOA0anzFtyTLsPps/HTA5XBefbK
         L1D8B70oLsHxqG5gRdcTLx81kqhJreOAumZ4msgR1wfpwXA5auUHGBkcL4YC9/PU+rBw
         7Wp5vzJothRputJXh+q0pKg0f5ZDNwx3SsTHWJP5aP+tF9sgaRrFuzrmzuMxE10Sp7vY
         PU1alyMRH/mmbVK4SFydKjTcGsYVY4uTLTKFIRFxxlE+UbH38DhKg57cDas5NXmAouab
         CVC5ZrTTotIpFdQ4QOjtsnSvYhpnTm4O0X1vGh3vRSyRL6+7hzgdalYo1X0WrmtH2r6k
         hN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386934; x=1782991734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yO8ck1Me4UpWQp5jQ9zT9mWfZ1zNBaFnVEK0MMob63Y=;
        b=Xmco+PuwB23ruaCkaHAlBWR6RAoLocorFhAYubFh7yP+LcezLZGPm4NrPKNIEd1QsP
         WZlyGcI/Ru8BlQd1PBatYrkJO5qiZb0oPeoxF1Shsq6fNZJx7XhJiZ/z85RQiLwyGc6+
         quZIBkdyfj1+oZfWE+YLtRtTLfSSfLpYcpJkB96aEfOsapvFgBBWcIOQ90/2V/Q21NyV
         puPiSM2BP/mgRFlAWhgonZCkwiqzIK1yG66T7Nt+pqJ0Ogvx/FiCMg9mte2704t1jx4h
         NEsisa/h0WO8rcky35SVkgEQu5DB6ZLKYSkagCgOk7Eu1lAg1qtDgJy0eEkFz5IDF60s
         XcUg==
X-Gm-Message-State: AOJu0YySV1W5vMOMM1jbHM/uunwdquK4xdw1zMuyNpUEb1wXOgTFVY3k
	SfX0Vcniod98k/CeQkL23I5T+hnEvtezE8BVvD4hq+1NcHkmH0bzIpNu
X-Gm-Gg: AfdE7cmuH3wqcDd0FFsb/PVu771yI6JgEcZwpjD+3raDkjrRQ3F7BcQR7c44totzWrB
	db+ZYdnHWtDOEx5NFpbkkJ7v5D9y9pV8XgirUhwjuY+T+aujz3nAO5AdQyhUXqjaY++xoim27aL
	QSsWWC8irRI1xsOrZGr7dwzOjFhNjPp1T/BnsTjo0dIVASIHsGt98wtR7bVHAQzhexGSTEsOfuW
	0BagsbS1LvjpwxPIBK7uBDn7BR0pbElJXJ0GB2MTEQzKXezeBBSwT16XeZSMwXXByo9J2jzOtiC
	IxIsrimsLPDD+hGyaRLptBRVff7PAFRSNWCthU1yBab0qeByldtSriHv7GORfs9TcbkrsnfXZ0g
	Me6r9q+4c45lQ9nIbor/XjDyQPiPXY/ukJcipIjiR50BoqPRM4TjeQ/e0EFAG+T7kT/GGZTMlsb
	inDBKlCi9GbzzkS6n90R6a8cwhRUhq1xDte0G81LRnWLYqFC83oEeHsTzU0F2P509FbDSR
X-Received: by 2002:a05:7022:208a:b0:138:43a4:925b with SMTP id a92af1059eb24-139c3cdc512mr6792278c88.20.1782386934254;
        Thu, 25 Jun 2026 04:28:54 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:53 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v11 18/31] cxl/extent: Handle DC Release Capacity events
Date: Thu, 25 Jun 2026 04:04:55 -0700
Message-ID: <20260625112638.550691-19-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Replace the no-op ack stub for cxl_rm_extent() with the real teardown:
resolve the released DPA range to its region and endpoint decoder,
locate the matching dc_extent in cxlr_dax->dc_extents (filtering by
cxled, range containment, and tag), and tear down the entire containing
tag group atomically through rm_tag_group().  Partial release is not
supported.

Invalidates caches once before rm_tag_group(). Then walk the
group's dc_extents and release each via its devm action installed
at online_tag_group() time.

When the released range maps to no region (host crashed before
persisting acceptance, region destruction raced device release, or the
device is confused) the host has nothing to drop, so reply via
memdev_release_extent() to keep the device's view consistent.

The same behavior is applied to the case where the region exists, but
not cxlr_dax of that region. If its dax region is not set up,
the host is not tracking the  extent, so extents can be released.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. Check rc of cxl_region_invalidate_memregion()

If flushing fails, don't release and wait for the device to
retry.

2. Check if cxlr->cxlr_dax is null before rm_tag_group()

Similar to if !cxlr, if cxlr->cxlr_dax is not set up, the host
is not tracking extents, so it's safe to reply to the device with
release.

3. core.h: move declaration for cxl_region_invalidate_memregion()
inside #ifdef CONFIG_CXL_REGION
---
 drivers/cxl/core/core.h   |   8 +++
 drivers/cxl/core/extent.c | 115 ++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c   |  19 -------
 drivers/cxl/core/region.c |   2 +-
 4 files changed, 124 insertions(+), 20 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 6ac68f46a18e..bbbb86ababad 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -28,6 +28,8 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
 
 #ifdef CONFIG_CXL_REGION
 
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
+
 struct cxl_region_context {
 	struct cxl_endpoint_decoder *cxled;
 	struct range hpa_range;
@@ -65,6 +67,7 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 		   u16 seq_num);
+int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
 int online_tag_group(struct cxl_dc_tag_group *group, bool skip_release);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -77,6 +80,11 @@ static inline int cxl_add_extent(struct cxl_memdev_state *mds,
 {
 	return 0;
 }
+static inline int cxl_rm_extent(struct cxl_memdev_state *mds,
+				struct cxl_extent *extent)
+{
+	return 0;
+}
 static inline int online_tag_group(struct cxl_dc_tag_group *group,
 				   bool skip_release)
 {
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 0ebb581ca833..a590a89f3580 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -371,6 +371,121 @@ static void dc_extent_unregister(void *ext)
 	device_unregister(&dc_extent->dev);
 }
 
+static void rm_tag_group(struct cxl_dc_tag_group *group)
+{
+	struct device *region_dev = &group->cxlr_dax->dev;
+	struct dc_extent *dc_extent;
+	unsigned long index;
+
+	/*
+	 * Pin @group across the walk: each devm_release_action runs the
+	 * dc_extent_unregister action synchronously, which drops the last
+	 * reference on the dc_extent device and fires dc_extent_release.
+	 * The release decrements group->nr_extents and, on the final
+	 * decrement, frees @group.  Without the pin the next iteration's
+	 * xa_find_after() dereferences a freed xarray.
+	 */
+	group->nr_extents++;
+	xa_for_each(&group->dc_extents, index, dc_extent)
+		devm_release_action(region_dev, dc_extent_unregister, dc_extent);
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+}
+
+int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
+{
+	u64 start_dpa = le64_to_cpu(extent->start_dpa);
+	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_dax_region *cxlr_dax;
+	struct cxl_dc_tag_group *group;
+	struct dc_extent *dc_extent;
+	struct cxl_region *cxlr;
+	struct range dpa_range;
+	unsigned long idx;
+	uuid_t tag;
+	int rc;
+
+	dpa_range = (struct range) {
+		.start = start_dpa,
+		.end = start_dpa + le64_to_cpu(extent->length) - 1,
+	};
+
+	guard(rwsem_read)(&cxl_rwsem.region);
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
+	cxlr_dax = cxlr->cxlr_dax;
+	if (!cxlr_dax) {
+		/*
+		 * The region exists but its dax region is not set up, so the
+		 * host is not tracking this extent.  Tell the device it is not
+		 * in use, as in the no-region case above.
+		 */
+		memdev_release_extent(mds, &dpa_range);
+		return -ENXIO;
+	}
+
+	import_uuid(&tag, extent->uuid);
+
+	/*
+	 * Find the dc_extent whose DPA range covers the released range and
+	 * whose tag matches.  The release targets the entire containing
+	 * tag group atomically; partial release is not supported.
+	 */
+	group = NULL;
+	xa_for_each(&cxlr_dax->dc_extents, idx, dc_extent) {
+		if (dc_extent->cxled != cxled)
+			continue;
+		if (!range_contains(&dc_extent->dpa_range, &dpa_range))
+			continue;
+		if (!uuid_equal(&dc_extent->group->uuid, &tag))
+			continue;
+		group = dc_extent->group;
+		break;
+	}
+	if (!group) {
+		dev_err(&cxlr_dax->dev,
+			"release DPA %pra (%pU) matches no dc_extent\n",
+			&dpa_range, &tag);
+		return -EINVAL;
+	}
+
+	/*
+	 * Invalidate CPU caches for the region before releasing the capacity
+	 * back to the device so it cannot reassign the range while stale
+	 * cached data lingers.  On failure do not release: leave the tag
+	 * group intact and let the device retry.
+	 */
+	rc = cxl_region_invalidate_memregion(cxlr);
+	if (rc)
+		return rc;
+
+	rm_tag_group(group);
+	return 0;
+}
+
 static void cleanup_pending_dc_extent(struct dc_extent *dc_extent)
 {
 	struct cxl_dc_tag_group *group = dc_extent->group;
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 7967b0db2c51..a072355f2f7c 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1669,25 +1669,6 @@ static int handle_add_event(struct cxl_memdev_state *mds,
 	return rc;
 }
 
-/*
- * Stub: ack the release back to the device so it knows we are not
- * using the range.  A later commit replaces this with the real
- * teardown that walks the region's tag group and tears down the
- * member dc_extent devices.
- */
-static int cxl_rm_extent(struct cxl_memdev_state *mds,
-			 struct cxl_extent *extent)
-{
-	u64 start_dpa = le64_to_cpu(extent->start_dpa);
-	struct range dpa_range = {
-		.start = start_dpa,
-		.end = start_dpa + le64_to_cpu(extent->length) - 1,
-	};
-
-	memdev_release_extent(mds, &dpa_range);
-	return 0;
-}
-
 static char *cxl_dcd_evt_type_str(u8 type)
 {
 	switch (type) {
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f6e93bc59ae7..528f0b980f58 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -222,7 +222,7 @@ static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
 	return xa_load(&port->regions, (unsigned long)cxlr);
 }
 
-static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
 {
 	if (!cpu_cache_has_invalidate_memregion()) {
 		if (IS_ENABLED(CONFIG_CXL_REGION_INVALIDATION_TEST)) {
-- 
2.43.0

