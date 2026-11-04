Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833378;
	b=v973YUfPHeMZOuxXwsD9tDCdPP14HQdjmrAJYkgZjsk+lZ7mGxmIocgIMyqqqehD0fqM
	 beyuxGC2YO/P6wY5CgvL0ezOOhDqZsypqjWtBJAS3Me3lGSzsqgryQfKyDJxAdz+e7aGz
	 bqMuor7riFG9j1JnEGzFUq1Y2TXKDDu+uhRrfkgRRqARFT1E3R1uV7nkmXk6vU4S1JIC5
	 3XeVZQvqQDSIKw6g4tKYTcKP8xxKlztJpwey2QDsAfuhj1Bqqtt3ZvVhwO58c7rdz1qQl
	 e2MKSsqfi3wLWL15DvDOgINH9yvwXoYr2Rc8tOT+VjhYu7ykKodtxVJYHXrlZceJg+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=YiodbiOBXjWvWWEj6Yx21Jb/b8nlmUGIGF+99ROj+mk=;
	b=0LLBpFx0dtZCWU6fMNbkn+yxjasr9J3EfuPfS9udi/6OajjIry1V6jT108b0RN5FsCRk
	 3XJGeVKKLq+D5EShvOB6hSAhdkb4m/E04OutH0jPlax0zVQlsXHPcifZCaf1ttUIgVWnk
	 qDWN+oHJ9CfhhZWobrewX6RPx4apgsfrTA0o115KMlVkMFcHNwq3ra9uKdgEVpa9QP5Lm
	 JOlfQwtvRH5Zknszrik7LSkyTH0s0uuWDe2fLZFjMxInqav+dZr+dlx5kaxYI3CCMdSCG
	 2NCrpyzIkQhf4HoGlitwJyBz0XhnL6KuMMjAJeny3h5lDd4UOzXJbOLGioPzve9mQpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GO91nYyM;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5316082BF5
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A5316082BF5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GO91nYyM
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e812e2b31bso7087775ad.3
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833378; x=1794438178; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YiodbiOBXjWvWWEj6Yx21Jb/b8nlmUGIGF+99ROj+mk=;
        b=GO91nYyMyUg3wRFY8OY3/EkwOMjjhujvh2pVg1eunOxspwRNnUTEwvoLTH9mgan2xI
         ZK70WXfILyDnM7m0JX/oYZtjGMLX10HbD/VUygwHSArMOynLrqDk4v86NTUXZov4Qz2w
         IuaX1hpU9IIokzazoA2/rD2zKJ+CMr4U5DPwy/bFNdHzg55xke48jKRCkqhWIBca1pVx
         FLPO2Qwm6mZ6SdWBn0e+1N2UILX158XqWSYKcZBu3HY9WIKlzpqYg6YjVAVR2N4X12+G
         7J0hcyc8d2B2HiI3lQEcGT/4h7zWhAQFH3NOZHZWTz3NVObh6fYE6dU/0wPC0hhxfA+p
         +L4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833378; x=1794438178;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YiodbiOBXjWvWWEj6Yx21Jb/b8nlmUGIGF+99ROj+mk=;
        b=smMCDCaxxsW1Tf2q6XcTeKsfbE0PE4LctHc8pHWvntp5sMJO7l4p43n9/xwjoJQBe2
         vbU+vQrpl57tlH7fQmaYcDW2ronazgpkZ1/LscihrsMt5VJABZXsRwLpm9AAmk/efdUJ
         VRSMbynaJR3FW5lOwhOdRYFFRzpVDU6o1YiDrFCugDLTiWIszzKJWfAC8VxM/s5PoQ6l
         PUU5wQXmXRLp6FixBhQR2WHVEnC3iOfqkUhdj40Xe4JNYwFhjFp8uVBoeWL87kIyK3pg
         amqbLKZ1m4c1DriQIOccmcGYhHyt4tN7VQkpJIf6+qfySoLXlcrX5pw/CNRXIs9TVlDq
         3R1w==
X-Gm-Message-State: APuU4Z/Y7hlbOByFiloDWa6GTYC9IPmrLwnO0hmjECru328JEjSb4fbT
	wR/N+7ApgTeJlxXyH5Q/uFy6YeTs4uBe/8uG4y1Q9dZmY1bvTxX5oeLt
X-Gm-Gg: AYBFou0ZIeFZ9R2pCX22HQZ7yVywnw//7fy8rU5LRnwFELGatOsTVpI/a5kUbQ2zTdQ
	PIJk6YwpGhWjS8lDebc0u3ziFzEirdZHIQXN+g0EQpaO4SrVbFNEgW2xjSV5OL+PbRba/KggV3Z
	/ozjnE7CZhO/gq6wbLl/HCPawrSGOydHcCqWMK1lmE+25bO2dhAfuQhdqUOj5vs+OqoFzw7IyEn
	8Jmsq7uW0EsgsNlGiR7+fpRnQIqjRWk9FQmPkde2ChT+LcL3pf3QpDzcrhdJGjdosbBiCTJV7cX
	ZtkykOFaIMtCgrxwJvo9fdKSXPhgW36oqu+K7ZnR5uum+9j/b8xV2qSOm1D2dlMUgNTq4fyA+Ao
	VDV3/RwedLaY90as0VxpJozGNJIYG/mw6qof1QWByX0oxGIHjFcaNCrcimCw6h8aGqRMYe5Tud2
	WE5aHL9MGijqUjx/05LgeiTUoYz071SCurnZc6Ssa0eHST13j8NAQbuZV0Jb1yLOgg4cLRNTRsl
	alQIs7WR9CV733DTJwyUqTnoZkDjr2UPi3azEc4dKfF4OGPNOfbY8X9yxJ+oAPZhQqQ0j7pv0ks
	MbI6gdAqxFlZdPex7HtxDeZSHcjuEg==
X-Received: by 2002:a17:902:e5c1:b0:2e8:1929:c8e4 with SMTP id d9443c01a7336-2eb36527d99mr158916125ad.60.1793833377799;
        Wed, 04 Nov 2026 15:02:57 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:57 -0800 (PST)
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
Subject: [PATCH v1 08/14] cxl/extent: Validate DC extent partition
Date: Thu,  5 Nov 2026 08:02:32 +0900
Message-ID: <20261104230445.66625-9-anisa.su@samsung.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Extend cxl_validate_extent() — the per-extent check of the add pipeline
to check partition membership.

Resolves an extent's DPA to its containing DC partition.  Sharability is
a property of the partition (part->shareable), taken from its CDAT DSMAS
entry.

An extent from a sharable partition must carry a non-null tag, since hosts
sharing the allocation key on that tag.  A null tag there is a device
firmware bug; reject the extent.

A non-sharable extent must carry 0 in shared_extn_seq (CXL r4.0 Table
8-230); a non-zero value is rejected the same way.  The dense 0..n-1
check for sharable groups follows in the next commit, once the whole
tag group is collected.

Based on patches by John Groves.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: John Groves <John@Groves.net>
Signed-off-by: John Groves <John@Groves.net>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/core.h   | 12 +++++++
 drivers/cxl/core/extent.c | 70 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 759f2c47d765..528eec2a1cc3 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -83,6 +83,10 @@ int online_tag_group(struct cxl_dc_tag_group *group);
 bool rm_tag_group(struct cxl_dc_tag_group *group);
 void discard_tag_group(struct cxl_dc_tag_group *group);
 int cxl_dax_untagged_add(struct cxl_dax_region *cxlr_dax);
+const struct cxl_dpa_partition *
+cxl_extent_dc_partition(struct cxl_memdev_state *mds,
+			struct cxl_extent *extent,
+			struct range *ext_range);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
@@ -144,6 +148,14 @@ static inline void kill_regions(struct cxl_root_decoder *cxlrd) { };
 #define SET_CXL_REGION_ATTR(x)
 #define CXL_PMEM_REGION_TYPE(x) NULL
 #define CXL_DAX_REGION_TYPE(x) NULL
+
+static inline const struct cxl_dpa_partition *
+cxl_extent_dc_partition(struct cxl_memdev_state *mds,
+			struct cxl_extent *extent,
+			struct range *ext_range)
+{
+	return NULL;
+}
 #endif
 
 struct cxl_send_command;
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 8afb18e7ae5a..334a97ab583d 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -115,6 +115,51 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
 	return no_free_ptr(group);
 }
 
+/*
+ * Find the DC (Dynamic Capacity) partition that fully contains @ext_range,
+ * or NULL if the extent falls outside every DC partition on this memdev.
+ * The returned pointer is owned by mds->cxlds.part[] and lives for the
+ * lifetime of the memdev.
+ */
+const struct cxl_dpa_partition *
+cxl_extent_dc_partition(struct cxl_memdev_state *mds,
+			struct cxl_extent *extent,
+			struct range *ext_range)
+{
+	struct cxl_dev_state *cxlds = &mds->cxlds;
+	struct device *dev = mds->cxlds.dev;
+
+	/*
+	 * A device-side error could cause end < start, which range_contains()
+	 * would treat as contained in any partition.
+	 */
+	if (ext_range->end < ext_range->start) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA %pra (%pU) has invalid length (firmware bug)\n",
+				    ext_range, extent->uuid);
+		return NULL;
+	}
+
+	for (int i = 0; i < cxlds->nr_partitions; i++) {
+		struct cxl_dpa_partition *part = &cxlds->part[i];
+		struct range partition_range = {
+			.start = part->res.start,
+			.end = part->res.end,
+		};
+
+		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM)
+			continue;
+
+		if (range_contains(&partition_range, ext_range))
+			return part;
+	}
+
+	dev_err_ratelimited(dev,
+			    "DC extent DPA %pra (%pU) is not in a valid DC partition\n",
+			    ext_range, extent->uuid);
+	return NULL;
+}
+
 /*
  * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
  * to its region/endpoint decoder and ext_range, and verify the range
@@ -133,6 +178,8 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 {
 	u64 start_dpa = le64_to_cpu(extent->start_dpa);
 	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct device *dev = mds->cxlds.dev;
+	const struct cxl_dpa_partition *part;
 	struct cxl_endpoint_decoder *cxled;
 	struct cxl_region *cxlr;
 	struct range ext_range = (struct range) {
@@ -140,6 +187,29 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 		.end = start_dpa + le64_to_cpu(extent->length) - 1,
 	};
 	struct range ed_range;
+	uuid_t uuid;
+
+	import_uuid(&uuid, extent->uuid);
+
+	part = cxl_extent_dc_partition(mds, extent, &ext_range);
+	if (!part)
+		return -ENXIO;
+	dev_dbg(dev, "DC extent DPA %pra (DCR:%pR)(%pU)\n", &ext_range,
+		&part->res, &uuid);
+
+	if (part->shareable) {
+		if (uuid_is_null(&uuid)) {
+			dev_err_ratelimited(dev,
+					    "DC extent DPA %pra: sharable-partition extent has null tag (firmware bug)\n",
+					    &ext_range);
+			return -ENXIO;
+		}
+	} else if (le16_to_cpu(extent->shared_extn_seq)) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=%u (firmware bug)\n",
+				    &ext_range, &uuid, le16_to_cpu(extent->shared_extn_seq));
+		return -ENXIO;
+	}
 
 	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
 	if (!cxlr || !cxlr->cxlr_dax)
-- 
2.43.0

