Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC05938D3E9
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529461; cv=none; b=S06aIWbCnD9ukNGA9KJwu0W2ruqCT/lLkGxNsT4bQf1+nHC4DGaTEdQeVaM2GKqi6L8vdz99MIPxRLzB6+Uw8haKxuhsnYmCqNOqVaVF5wf97pEq8YaIFjrvRhwLy9iFRk5jS6G6+k83WE8u37JsXLrgiB8Jnr5c8tu2d9kyQcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529461; c=relaxed/simple;
	bh=LUSayAW7Ss//wrzrfaEVE3L7lgIMMJWzEY1PnB+ZGhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E0rv60or0gFX1HlcYcezYjc3CZdBRe1TDubLZ0QOjF3WcRDGze1pGllhuxFMB6/45ANd0NH8XITilIyUlUIoM5AuSxg8loMGKnJNEfOOvYpYHeJeBfzyPrK4BjUBNxYOPYTMi3nipWpdjuIeZWyQzPvJYRRXr/hAuX9NQc9hNYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f8uQFTur; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f8uQFTur"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-135e88b8e55so3425410c88.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529459; x=1780134259; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Dxps5tq57tj4Ih7YoWNcRidGTGqRdOSyJhuFvRk8Es=;
        b=f8uQFTurpBQitBdfzSrQ/Dvpk/6qUmGvMKaH3Hi8rsWeEpbr6jR/8lMdT/qBJHWk+g
         ntVfHQ3D6n4yWptrPMvTXbV9DbbCSnwYBLkemYRGt2fdZMdqwYCIKblSdc4MmtW98xsi
         xZH0CFK9lwmWHlnEV/nPU/peC7IyjWwaiTd8sY++IClS/H7EbOp9HGKDzhLmlZ5P/bh3
         OTnltztbpw11U877yWGXv6Gd/D5zg1hHEOZ8ttebIL2Oj6TFHLRZQ9A+xWFC7Kx1FPhP
         Ue8l/MNxYzrV3z93jIf4dILkwB4J2uUwluK6dGwbjjMeRkD4onG44eupiculvvyAGizA
         12dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529459; x=1780134259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Dxps5tq57tj4Ih7YoWNcRidGTGqRdOSyJhuFvRk8Es=;
        b=BAp+mAZkRDyLIHrUZsy4y+/vu6u9yie5qyhFJOc3ueOTBM3QEG9ycppRq6EOnq6KiQ
         NNoLr0OQOz47Y4BNdfXLjYsvovx5oDJ8eeFG09jFoFm+gvSXjf4p3AXmD8EcUelJukXt
         OEZDy3kv1nOMuiuz53M7pUflFw0sElYDwQtn4XgUnHOtlDM+j1S17PYIrc+JhzBoZA4f
         tT6yqcUtNaDAp9A2uk/pW8c5Oq9djMe/MRy65+MeM3OPInzQ6ftxo7Ritx2dn+S/8z3/
         C8Fy2tWqLNCW5I82xHEbMIG2Um+Ckv6rVhkKBrJC4Ne626m4+w6bVDKac3w58WyC2Se/
         PejA==
X-Gm-Message-State: AOJu0YyqxG4/5hLdpfrDYuYgLSIMTafwnledpwVR4hwbwCJxTiOWyGRR
	LuG+GENDouxugt5n2rvx6f1AU+egDVhszd5v1YjCVsmSiBUXoWcSOQgS
X-Gm-Gg: Acq92OFCKlX9SbHDlPLUuawT9NZxvx33NwY8cCsTIo+tJ+c7RFcBUb2S3o/P/D6oOJA
	WLCIoGATg1Tptqzf16rXraot+ofbOXAC49dD3KO9i8HfWr7G469Q8MSIAk/9HdJlkzYp3nBqmZI
	Vidf0cW8G+c+g7oLdeV++cS9KFSs0iSNbbaOOGS5Zi3QUlkfd/MjAzyMSm738hgFZxadn9LNDcv
	Jtk2cRSSMdyVe3kNh/f+luqYf9EGSPrO+xaOuw2CmeBsJ5UHNJcWUWO8asVOCY+6KGBvTrMdzkk
	Er/5W2P9YmdzAD1mexu6wC8WfBKuw1gS2kDVqbSUdw94nuVm10wqeQtVfRaZ9obWwPWCZWipmsy
	4tGglB2uYdod7kOAgF4urVPCs0GwnVgeK5t5cruek92F98B2PNQu3mBXdx5U+lruS1N7WjAycQx
	Olo5Kd6HJju5vYUaOUulon3fRL/EmTO8mY9qI0lHwKMP/jlrg3BZSaLHjzalqYlFn7wA6O1oC6w
	+UMtes=
X-Received: by 2002:a05:7022:206:b0:12d:b28e:75b1 with SMTP id a92af1059eb24-1365fb40523mr2838281c88.22.1779529458842;
        Sat, 23 May 2026 02:44:18 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:18 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 22/31] cxl + dax: Release dax_resources on DCD Release Capacity events
Date: Sat, 23 May 2026 02:43:16 -0700
Message-ID: <e6cea279dcb208684c08b756f6de65438529ad65.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Implement the release path that mirrors the add path: when the
device asks for capacity back, the dax layer tears down the
per-extent resources for the whole tag group atomically.

If any extent in the group is still mapped by a dev_dax, the release
is refused with -EBUSY and no state changes; the cxl side then leaves
the tag group intact and the device retries.

Also add a rollback to the add path: if any per-extent registration
fails midway through a group, undo the ones already added so a
partial group never leaks into the dax region.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: split out from the original "Surface dc_extents" commit;
 fills in the RELEASE half of the bridge, moves the cxl-side RELEASE
 notify into this commit, and adds the rollback path to ADD.]
---
 drivers/cxl/core/extent.c | 13 +++++++++
 drivers/dax/bus.c         | 59 +++++++++++++++++++++++++++++++++++++++
 drivers/dax/cxl.c         | 54 +++++++++++++++++++++++++++--------
 drivers/dax/dax-private.h |  8 ++++--
 4 files changed, 120 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 3fc4b7292664..2c8edfe53c0a 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -532,6 +532,7 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
 	struct range dpa_range;
 	unsigned long idx;
 	uuid_t tag;
+	int rc;
 
 	dpa_range = (struct range) {
 		.start = start_dpa,
@@ -588,6 +589,18 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
 		return -EINVAL;
 	}
 
+	rc = cxlr_notify_extent(cxlr, DCD_RELEASE_CAPACITY, group);
+	if (rc) {
+		/*
+		 * dax layer refused (-EBUSY) or failed (-ENOMEM, etc.).  Do
+		 * not proceed to tear down the tag group — leave its
+		 * dax_resources alive so we do not free them out from under
+		 * live dev_dax ranges.  The device will retry the release.
+		 */
+		return 0;
+	}
+
+	/* Release the entire tag group */
 	rm_tag_group(group);
 	return 0;
 }
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index a6ee59f2d8a1..6368bdfdf93a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -253,6 +253,65 @@ int dax_region_add_resource(struct dax_region *dax_region,
 }
 EXPORT_SYMBOL_GPL(dax_region_add_resource);
 
+int dax_region_rm_resource(struct dax_region *dax_region,
+			   struct device *dev)
+{
+	struct dax_resource *dax_resource;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+
+	dax_resource = dev_get_drvdata(dev);
+	if (!dax_resource)
+		return 0;
+
+	if (dax_resource->use_cnt)
+		return -EBUSY;
+
+	/*
+	 * release the resource under dax_region_rwsem to avoid races with
+	 * users trying to use the extent
+	 */
+	__dax_release_resource(dax_resource);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_region_rm_resource);
+
+/**
+ * dax_region_rm_resources - atomically remove a set of dax_resources.
+ *
+ * Walk @devs twice under dax_region_rwsem.  First pass refuses the
+ * operation if any member's use_cnt is non-zero; second pass releases
+ * each.  This gives refuse-all-or-none semantics across the set, which
+ * a tag group's atomic release relies on.  Devices with no
+ * dax_resource attached are silently skipped.
+ */
+int dax_region_rm_resources(struct dax_region *dax_region,
+			    struct device * const *devs, unsigned int n)
+{
+	unsigned int i;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+
+	for (i = 0; i < n; i++) {
+		struct dax_resource *r = dev_get_drvdata(devs[i]);
+
+		if (r && r->use_cnt)
+			return -EBUSY;
+	}
+
+	for (i = 0; i < n; i++) {
+		struct dax_resource *r = dev_get_drvdata(devs[i]);
+
+		if (!r)
+			continue;
+		__dax_release_resource(r);
+		dev_set_drvdata(devs[i], NULL);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_region_rm_resources);
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 690cf625e052..04b73315a8f2 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -44,19 +44,52 @@ static int cxl_dax_group_add(struct dax_region *dax_region,
 
 	xa_for_each(&group->dc_extents, index, dc_extent) {
 		rc = __cxl_dax_add_resource(dax_region, dc_extent);
-		if (rc)
+		if (rc) {
+			/*
+			 * Unwind every dax_resource already added for this
+			 * group; one rm per owner suffices.
+			 */
+			struct dc_extent *u;
+			unsigned long uidx;
+
+			xa_for_each(&group->dc_extents, uidx, u) {
+				if (u == dc_extent)
+					break;
+				dax_region_rm_resource(dax_region, &u->dev);
+			}
 			return rc;
+		}
 	}
 	return 0;
 }
 
-/*
- * RELEASE is still a stub here — the atomic dax_region_rm_resources API
- * and its wire-up land in the next commit.  An incoming RELEASE returns
- * success and the cxl side proceeds to rm_tag_group(), which device-
- * unregisters each dc_extent; the devm action armed by
- * dax_region_add_resource() then tears down each dax_resource.
- */
+static int cxl_dax_group_rm(struct dax_region *dax_region,
+			    struct cxl_dc_tag_group *group)
+{
+	struct dc_extent *dc_extent;
+	struct device **devs;
+	unsigned long index;
+	unsigned int n = 0;
+	int rc;
+
+	if (!group->nr_extents)
+		return 0;
+
+	devs = kmalloc_array(group->nr_extents, sizeof(*devs), GFP_KERNEL);
+	if (!devs)
+		return -ENOMEM;
+
+	xa_for_each(&group->dc_extents, index, dc_extent) {
+		if (n == group->nr_extents)
+			break;
+		devs[n++] = &dc_extent->dev;
+	}
+
+	rc = dax_region_rm_resources(dax_region, devs, n);
+	kfree(devs);
+	return rc;
+}
+
 static int cxl_dax_region_notify(struct device *dev,
 				 struct cxl_notify_data *notify_data)
 {
@@ -68,10 +101,7 @@ static int cxl_dax_region_notify(struct device *dev,
 	case DCD_ADD_CAPACITY:
 		return cxl_dax_group_add(dax_region, group);
 	case DCD_RELEASE_CAPACITY:
-		dev_dbg(&cxlr_dax->dev,
-			"DCD RELEASE notify (tag %pUb): no-op (stub)\n",
-			&group->uuid);
-		return 0;
+		return cxl_dax_group_rm(dax_region, group);
 	case DCD_FORCED_CAPACITY_RELEASE:
 	default:
 		dev_err(&cxlr_dax->dev, "Unknown DC event %d\n",
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index f2ae5918f94d..414813a6137f 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -146,13 +146,17 @@ struct dax_resource {
 };
 
 /*
- * Similar to run_dax() dax_region_add_resource() is exported but is not
- * intended to be a generic operation outside the dax subsystem.  It is only
+ * Similar to run_dax() dax_region_{add,rm}_resource() are exported but are not
+ * intended to be generic operations outside the dax subsystem.  They are only
  * generic between the dax layer and the dax drivers.
  */
 int dax_region_add_resource(struct dax_region *dax_region, struct device *dev,
 			    resource_size_t start, resource_size_t length,
 			    const uuid_t *tag, u16 seq_num);
+int dax_region_rm_resource(struct dax_region *dax_region,
+			   struct device *dev);
+int dax_region_rm_resources(struct dax_region *dax_region,
+			    struct device * const *devs, unsigned int n);
 
 static inline struct dev_dax *to_dev_dax(struct device *dev)
 {
-- 
2.43.0

