Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A862E3DC4CF
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386943; cv=none; b=nrmwTyMX2gVV+APsirxTfO9Z8WfqrFC3qe3CtpuDGQlPay0HMsLiFrB9McRAZphkiGkVNobAfHLRKzcy2IDOrKt+PjVrtvfY+Rp5lGt6FbTdGkIXoApn0xNUiVPPbyTga4rCyXPa0YMtzcwXSAqdnGW+2cKqeLbzuv0AnO+G4LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386943; c=relaxed/simple;
	bh=fRAajwcfFwY6cJoDZq6SVzxN9qlk0/3O07b9DCT1hYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T1950VK/BEFk6eT50rxHTc3pSDND3o8VOSJpFivJhZHYbwo7k0LwhBOInFHNz+Yei4bbWUq3USbxdL92WYZV6MY8deVNiwStVslKx2VVWc9YFM5YfC03/hs5CiMPFiXT0whgDVlFvGR8U9tgI9iklkUhApHCZFMTmCdnNvMih8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sZXygMwy; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sZXygMwy"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-30c8b23420bso514783eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386941; x=1782991741; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=COfWEcK0qdObTQX19NJ/2M66kmTpQs5hgTwaCK6umUk=;
        b=sZXygMwy+mPzpqIh+m3RPaIDTis7jyLxa9SDKaKzlyE2lZNBVcfJA8eFOzfGMwDIHi
         8WtgYNNr3PVKsp6eV+IAXBQZ/4THlfji1j082Cn912qCILgc75GmCP8p4B+WZA5pMeA1
         YXHE2zvqapovIObIuRkqCIMGGg26xuXoSMMmura8x/0ivu4D+E+haKawsQl0M2nFv3Hc
         /SEh3xLNrl9WKUg0H+aGYITDa59nP1vUU/8PFB//LGIEOn5HTejo4tFxQkekn8BKjU2W
         YAzPQNLwYHLgqtq5KXzYwHBQkb2osblLjtZcaGEx3TvngPmJvi0S5EzrJ/7HVUIyg8Sx
         uEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386941; x=1782991741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=COfWEcK0qdObTQX19NJ/2M66kmTpQs5hgTwaCK6umUk=;
        b=oSk6TxrL4cPZ9SfKd5Gf/9wItPr414uGh1knssRMafxSopePlF6IrBROrGPc81ZkMx
         apJ85DZCUqEa/YnBCP/Zic+WphOtfIlCjujCs8sByDCHcwBjjIAf4yYcViIw4E2mdyGD
         j0R9fVtC43wMc/TDqhTA42urCYSul52eK4SHOwqYv3l7PYIiqP0sdOcS35TU+xbdsWUi
         JOzOuPuFnHx88Hw+iF7hzUFcebSgHJuN24w6VsjMsNYlFYjfyFsBeCdBOsw8+VDyeraP
         TcGzcGnqOme/3pTRiP83smu6o4TUfMUoHAts+CbHAW8wQ8y4tS2XO2WRhRlhv77riz8o
         E9sg==
X-Gm-Message-State: AOJu0YwKOAQWG1Ar65+TOQN6rv4bcKUgVShgclHSRdh8508RCDYwXApC
	Pp+J86QCI3emSj1qzrpgEiCofSECXdO5ILY5C+ZspI0rZTmr3NDAsbm8
X-Gm-Gg: AfdE7cnygiqQsTibeVEU/ALB7QBsiJm5ypQ2yVq2dpBbBtD5PuemgrpisFu9IoRUBMm
	mv2ELX1GTfY/KZSq238/2RSEivgBj8YvMDYIzxTAU1XR5YnJ6K8Mi4dGikVETKqAWQi5anZyVHj
	IrJranIG3YZYq4C08o+/C1bXrUf1YQAXY4BL+FIWkW1uYcojoVPMkDZkep25ixkm9uj67yWUUfK
	lm6GFVaTDr9M8vbc0Xr2go/Dr+BwxEVWiauNtUnMQNWi6R9SsmsmOIR10oeU4joaR/MUQjkV8KG
	jrn3ZrkiNFMvNqGFzvwl40JowcRLElqm/3LY9XC8UloMWRPwpLFBusxq0andxpmJc9uvYutf9sx
	pH1wP54qa5ygMIQWvR2jegmkQxmK+/LKUw4106giX2StXd0lIL9Lbj/PoZvL1PdBqCFOZSJRoqj
	Xn/FBK3Aph3H0D/Oa4oiKcxXoGOaoYG/B49UmiR3Bu0dO/r58C2uHQxcbkPZqf/JlzSu1K
X-Received: by 2002:a05:7300:80d0:b0:304:b93a:5107 with SMTP id 5a478bee46e88-30c84f41ad0mr2971112eec.21.1782386940637;
        Thu, 25 Jun 2026 04:29:00 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:29:00 -0700 (PDT)
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
Subject: [PATCH v11 22/31] cxl + dax: Release dax_resources on DCD Release Capacity events
Date: Thu, 25 Jun 2026 04:04:59 -0700
Message-ID: <20260625112638.550691-23-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Implement the release path that mirrors the add path: when the device
asks for capacity back, the dax layer tears down the per-extent
resources for the whole tag group atomically via
dax_region_rm_resources().

If any extent in the group is still mapped by a dev_dax, the release
is refused with -EBUSY and no state changes; the cxl side then leaves
the tag group intact and the device retries.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/core/extent.c | 12 +++++++++++
 drivers/dax/bus.c         | 43 +++++++++++++++++++++++++++++++++++++++
 drivers/dax/cxl.c         | 39 +++++++++++++++++++++++++----------
 drivers/dax/dax-private.h |  8 ++++++--
 4 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 59db1878b5e2..7009ac6a51b4 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -627,6 +627,18 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
 	if (rc)
 		return rc;
 
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
index 9b5c03616b83..95683dc8fcd0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -282,6 +282,14 @@ static int __dax_region_rm_resource(struct dax_region *dax_region,
 	return 0;
 }
 
+int dax_region_rm_resource(struct dax_region *dax_region,
+			   struct device *dev)
+{
+	guard(rwsem_write)(&dax_region_rwsem);
+	return __dax_region_rm_resource(dax_region, dev);
+}
+EXPORT_SYMBOL_GPL(dax_region_rm_resource);
+
 /**
  * dax_region_add_resources - atomically add a set of dax_resources.
  *
@@ -314,6 +322,41 @@ int dax_region_add_resources(struct dax_region *dax_region,
 }
 EXPORT_SYMBOL_GPL(dax_region_add_resources);
 
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
index 5d33be342d42..d885b6e698ef 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -40,13 +40,33 @@ static int cxl_dax_group_add(struct dax_region *dax_region,
 	return rc;
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
@@ -58,10 +78,7 @@ static int cxl_dax_region_notify(struct device *dev,
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
index 8d98fc9adb4b..59ba929e14fd 100644
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
 
 /* One resource to add as part of an atomic dax_region_add_resources() set. */
 struct dax_resource_spec {
-- 
2.43.0

