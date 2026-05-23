Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0DB38737B
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529457; cv=none; b=PGuZOPFl9te/eUhN9f8L4RJStAAmGLZW36hXGn+CtebJd/sjKnsEfleMOarB4/dOeACTJEPyJKRdIWH54vNSs5luaqNF4p2htV5Gz+xGlthkjwggMGCMB2vUIOx3iEi+9s+u+3EOMJ3QscnZ+ir+OQhFSqCvuS1jh6N+IEhDBrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529457; c=relaxed/simple;
	bh=slI4nvrX63CgPuf0Zdsw9jQIJ2+RZL8IaZz0qSbJ7Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPj5vZFYESJIsH7pf63wJe6BYkmlYhfV1kkOjuJjEj8v+EN93sQ87H4d8aXAgJeA8o4LAuCQ3uX1vJURd5bFtlppyiXfFUMCW+hwhGTj+GTs5KFZ3P1xqhv+3e2R4XKDmupRYrjqeEriGDQub55nQc8wLq0Aw9SiuyDGMDUdYxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fhSLtc0E; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhSLtc0E"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1329fc4bf77so2963980c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529454; x=1780134254; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdCEB4+GSe0WqjUBIw1Z2Tl7ajOiH3CDmRtVej+qJq8=;
        b=fhSLtc0ExfbECJVeI7hanz15dgQKe6q3ijGchaekF1JfpbsukIfaQuCjGMPYt63WhO
         0CPGLemyGpWgdUNQGsbzKFyZTjdaStyvgBU7kX23W7TP2vvMGZfO0ciEtfClERKCxjcM
         1S3qoNAwoefJe2Da+dv8nzkAUmLKTUZ7R8/yeuINoMV2gkHjxr1aMiWmlGWRVR1a9KwT
         Uk/J3arh9O76OPriu0Ur/J3ztwPa2NiVePJSbWNsJYyghvaGKw1f23RteoQZewaLJkuC
         Z/JUbU84E4PdgddBFmL73dC1GKOtQ4vJKy/0AFQZI2+wfa0kgwxpZJ+x8zt7PBlnEPZr
         1j8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529454; x=1780134254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QdCEB4+GSe0WqjUBIw1Z2Tl7ajOiH3CDmRtVej+qJq8=;
        b=EdFXAezVS/w8xhbUlTJkAzZlBqo5YWzT+Wz8hNLIs++QtayyeloIkV4hlDqxRkzaC5
         8nKDAKvlDxP/iEFg7OoRCmVCAl5vaU5itOB8+028S6cLVnpXuX1Eqk1bySvgyAhtuwqI
         VxbMhvOO+kSsETMuyZ7syBp7Uw6ttpcyCdiW8nrFKj/ZlfIZagcwje2zfzWEVKjK6rDK
         shKWwttP3AYiDAOrly/H9MajZr4ZXyCuxTh6VwEtuUYIE1i6RUgk4RSsEEYyLGbtKGYA
         Q70PHDcQXsINaZ/ujXpFXXc1FIKjHuJHUZZMlYWr22T99dahbMTk1ZX+6ULKUU4LqqaY
         Vwgg==
X-Gm-Message-State: AOJu0YzAaKusZDMe/BZgxHVjNCswsMqF2qJrmQQD8kBtobRX9pDTsyE9
	+/3oUh/BsCQ2WoTILfm1c1m45zH0C3dQIeQOyxErvbvo0OlAlajLPj4e
X-Gm-Gg: Acq92OHgWlzw4ZmHiGbilWZqvXAWnDQiIMIbfeJ3hQCLw7M997ItP3kV0BO8p4zWWXz
	ycwyyQMonwoPUoiDDm6ysHU1q7KknxwBB0eMn3ueDGBrgOgyLBr9D2lDIzvaSpIQXQDrws02E7S
	cV7KMpFGlXLJbd4lSkeyQD0/cWZC5YQSyFWz/hZ/JDX2hYuCMD+2PTojnVEPUMavjfF4nc7krHx
	D3BG8UMUVivDhFlboCYjnWZs2zX+ggFLCmtRkcnBFAIe36ufN3G0cQV18E9rfIDMdrPhFMROFRI
	sZYUk9KQ8wUoUB08djQe1MIeZYEoz1mzffsWRmdTqY4w1a1ijpBkEyRSNbbaT7rb0aXj17nfsxy
	MpOczhjSuQR+xzXpyVjtz7qTA2iuJSyeEqnfCdmAfnX/cnoP2nvxqJVU3NUpaNbooQBuL2pzzso
	Xq30BE7aT72aGaWfXxCRXRrsJYJNcE+iJ1uV0qlTJt306lx3vyLtRpRpNNuUjlzBsKJDB0KSJW5
	E97aYswgdagJjKlXCFVmWO1B/QC
X-Received: by 2002:a05:7022:60d:b0:130:ab68:2b6f with SMTP id a92af1059eb24-1365f812d70mr2615308c88.9.1779529454246;
        Sat, 23 May 2026 02:44:14 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:13 -0700 (PDT)
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
Subject: [PATCH v10 19/31] cxl/extent: Enforce cross-region tag uniqueness
Date: Sat, 23 May 2026 02:43:13 -0700
Message-ID: <8f4aa2f5da26221efdd85650578c953657466e0f.1779528761.git.anisa.su@samsung.com>
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

The per-region scan in cxl_tag_already_committed() only catches a tag
re-appearing on the same cxlr_dax.  The orchestrator owns tag
allocation and is responsible for global uniqueness, but a buggy FM
(or firmware redelivering a tag for a previously-closed allocation)
can still hand the same uuid to extents on two different regions or
memdevs, and the per-region check accepts the second one — leaving
two independent cxl_dc_tag_group objects with the same uuid.

Add a host-wide registry of live tag groups with non-null uuids.
alloc_tag_group() inserts on success, free_tag_group() removes; both
skip the null-uuid case since the spec defines no cross-chain identity
for untagged allocations.

An attempt to add a second group with the same uuid fails with
-EBUSY.

No exit hook is needed: cxl_core only unloads after every dependent
module has, by which point every live tag group has been freed and
the registry is empty.

Signed-off-by: Anisa Su <anisa.su@samsung.com>
---
 drivers/cxl/core/core.h   |  5 ++++
 drivers/cxl/core/extent.c | 60 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c   | 19 +++++++++++++
 drivers/cxl/cxl.h         |  3 ++
 4 files changed, 87 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 65daaaadf68e..02b36728c22d 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -69,6 +69,7 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 		   u16 seq_num);
+bool cxl_tag_already_committed(const uuid_t *tag);
 int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
 int online_tag_group(struct cxl_dc_tag_group *group);
 #else
@@ -91,6 +92,10 @@ static inline int online_tag_group(struct cxl_dc_tag_group *group)
 {
 	return 0;
 }
+static inline bool cxl_tag_already_committed(const uuid_t *tag)
+{
+	return false;
+}
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 51116c8139ed..f66fa8c600c5 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -18,8 +18,60 @@ static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 	memdev_release_extent(mds, &dc_extent->dpa_range);
 }
 
+/*
+ * Host-wide registry of live tag groups with non-null uuids.  Enforces
+ * that within this host, a tag uuid identifies exactly one allocation
+ * across all regions and memdevs — closing the gap left by the
+ * per-region scans in cxlr_add_extent() and uuid_claim_tagged().  The
+ * orchestrator (FM) owns tag-uuid allocation per spec; this is a
+ * defense against firmware bugs and orchestrator misbehavior.  Untagged
+ * (null uuid) allocations are not tracked: the spec defines no
+ * cross-chain identity for them.
+ */
+static DEFINE_MUTEX(cxl_tag_lock);
+static LIST_HEAD(cxl_tag_groups);
+
+static int cxl_tag_register(struct cxl_dc_tag_group *grp)
+{
+	struct cxl_dc_tag_group *g;
+
+	if (uuid_is_null(&grp->uuid))
+		return 0;
+
+	guard(mutex)(&cxl_tag_lock);
+	list_for_each_entry(g, &cxl_tag_groups, registry_node)
+		if (uuid_equal(&g->uuid, &grp->uuid))
+			return -EBUSY;
+	list_add_tail(&grp->registry_node, &cxl_tag_groups);
+	return 0;
+}
+
+static void cxl_tag_unregister(struct cxl_dc_tag_group *grp)
+{
+	if (uuid_is_null(&grp->uuid))
+		return;
+
+	guard(mutex)(&cxl_tag_lock);
+	list_del(&grp->registry_node);
+}
+
+bool cxl_tag_already_committed(const uuid_t *tag)
+{
+	struct cxl_dc_tag_group *g;
+
+	if (uuid_is_null(tag))
+		return false;
+
+	guard(mutex)(&cxl_tag_lock);
+	list_for_each_entry(g, &cxl_tag_groups, registry_node)
+		if (uuid_equal(&g->uuid, tag))
+			return true;
+	return false;
+}
+
 static void free_tag_group(struct cxl_dc_tag_group *group)
 {
+	cxl_tag_unregister(group);
 	xa_destroy(&group->dc_extents);
 	kfree(group);
 }
@@ -54,12 +106,20 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
 {
 	struct cxl_dc_tag_group *group __free(kfree) =
 				kzalloc(sizeof(*group), GFP_KERNEL);
+	int rc;
+
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
 	group->cxlr_dax = cxlr_dax;
 	uuid_copy(&group->uuid, uuid);
 	xa_init(&group->dc_extents);
+	INIT_LIST_HEAD(&group->registry_node);
+
+	rc = cxl_tag_register(group);
+	if (rc)
+		return ERR_PTR(rc);
+
 	return no_free_ptr(group);
 }
 
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 70e6c4c9743c..85959dee35ea 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1474,6 +1474,25 @@ static int cxl_add_pending(struct cxl_memdev_state *mds)
 		extract_tag_group(pending, &tag, &group);
 		list_sort(NULL, &group, extent_seq_compare);
 
+		/*
+		 * Cross-More-chain uniqueness.  A non-null tag seen in this
+		 * group must not already correspond to a committed tag group
+		 * anywhere on this host.  More=0 was supposed to close that
+		 * allocation, and tag uuids must be unique across all regions
+		 * and memdevs (the orchestrator owns assignment per spec).
+		 * Either constraint failing — same chain redelivered, or two
+		 * distinct allocations colliding on the same uuid — is a
+		 * firmware/orchestrator bug; reject the whole group.
+		 */
+		if (cxl_tag_already_committed(&tag)) {
+			dev_warn(dev,
+				 "Tag %pUb: dropping group, tag already committed (firmware/orchestrator bug)\n",
+				 &tag);
+			list_for_each_entry_safe(pos, tmp, &group, list)
+				delete_extent_node(pos);
+			continue;
+		}
+
 		/* Sequence-number integrity */
 		if (cxl_check_group_seq(dev, &tag, &group)) {
 			list_for_each_entry_safe(pos, tmp, &group, list)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index cbbfba92fea9..a28e7b12a4a8 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -598,12 +598,15 @@ struct cxl_dax_region {
  *		allocations.
  * @nr_extents: live count of dc_extents in the group; the group is freed
  *		when the last dc_extent device is released.
+ * @registry_node: anchor in the host-wide non-null-tag registry that
+ *		enforces tag uuid uniqueness across all regions and memdevs.
  */
 struct cxl_dc_tag_group {
 	struct cxl_dax_region *cxlr_dax;
 	uuid_t uuid;
 	struct xarray dc_extents;
 	unsigned int nr_extents;
+	struct list_head registry_node;
 };
 
 bool is_dc_extent(struct device *dev);
-- 
2.43.0

