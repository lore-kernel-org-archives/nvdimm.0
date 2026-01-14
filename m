Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B34D3815E1
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 08:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380776; cv=none; b=aJH7onMNWcwUA9S1NQwNW/BTxbldzA4cLynrZuPcBai6D6Fsszqbyy02cEVZjBs50iV8r1b75LV314zsMNivbYjmB4wp54g5haPkXJGjGTXLMa61lTbs5BrRsPPRgff3U7iWT8MmR2hivSXV7WvpZGRuOZkcgCPGtHE//XoLWOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380776; c=relaxed/simple;
	bh=IRkGW/+6U9xZlWhzp6teA03oy5t+nqHjZEeiuztKzEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZrzlfCG7pC7h86kRqOw2LjP9cyypqTPxlGJliZrCTQamo/yzm1rNhuhsqFqv4J+ujgzgXkUNhJD08ei8y613l1Pfl1Txnub6WdraUasw3tnfzTIt6zVqEBsGqR+VwXfrdWeZ5oFr2UqNhuWlniSpDDYzWO3zwH5tdcMt2O3Y/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Mh/62EKo; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Mh/62EKo"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4f822b2df7aso114292601cf.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 00:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380764; x=1768985564; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AkgGAvtlp4w6GbvGEuWsv0IzEAPVl0Fov3QmaIKpKpw=;
        b=Mh/62EKoP5yYOREZoWsN3DlKcI0LgG8hAe1ooWRClRWGVjlRSTsdHoru9YgxuyoNLt
         ItNRLOBrWV4oFLB6mB+EAwdYDAvX8MOZ6/UyiJoxVog+r0QD6QJKUkyxOsxFhubCR9xc
         gE9C7d2eunThSMLIz5lwwRQdOr+1+m7B8/dLbNevI1aYdmKxeCASyRzAfugaw3Prwg3t
         I5mULsBVl2YZ1UlgzDS6ED24fgzpQSyGL2je3w5OiuBOdXp5TP+sno12z3WClQ5KNerH
         O8jAVEAwlLGCehnIkwwABzsAM4fekh65YcpOCNPNafpSyGEHfhMCMDMMMU/+Su/JGUl3
         HV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380764; x=1768985564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AkgGAvtlp4w6GbvGEuWsv0IzEAPVl0Fov3QmaIKpKpw=;
        b=p8o2N54dPX01lJc/yP68g8LDfmaEpIASvQCD8ce40tmwE1NXfI+ZTo0sPF8aYcNlHT
         jtPtxMapR8VLaijfpnRv8lmI8bV2yW7C+/rLuJptV7NdRJKwarhnhq8aX4cSYaVCHVID
         BYoI/YaWZG7M4vKxr8/drf9i7YrLHNED0e8oJyH8hdtUM/ZiEf34LFJ9mKHBBFQUqs0c
         xBLAmXqNJlvxbVts0TEnavuX3lgHvvPQZjAWsI/OQfTkwJyPIb4B4+zaBuk1Ei7zNwCD
         3kHCf4CRbbLMqx5S3+KBzAeb4Lz6z0FlZ7xObiYmCwrmZs8BHuSV8RXB7kXjJXgQ6Cbm
         XvDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8Z83+Cjd3jMDWdJoH1MV1k2qsHJ/B6EEvNUIM4/T+uZShQP+HkP6St5Lp+ZEqLELVGSOhkzQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxm46th1H4Ev5PSuKAQh33Tb7L51cJY7Klls3mGVsUEfdiCyaNp
	pqiWHGmslNgYPqcKX+3R3cwO5wNTA/cBmMc2CMukD+cmfQaYq9URZQRHlbAK1YG9G54=
X-Gm-Gg: AY/fxX4rqPKx4xJEXAokh0PKuBOU3v2B6x7hgdqoe7X6mAm6C/SzGsjrsU2WJFveh6P
	0LFHCUOI6/dMX/2oqSIomK+aZLPdvf3yeip6mBm41AB9wvqdW80p5ML6H3Yw4Ydnfo2W2RE5mQg
	4hBPpLuGKO/GGi26fIMVRkQepbgLKfUGhFyfhXg2381iyvQwNVqOk/Os38z2fZUvOt+FhIzbaIY
	IM8glC35x4FOmZMM6aeeaCf46MJD5RBhcNfhgChzXPbdNOvfOdBgvVAkzWW71kOhZQwjc+H82Vc
	uFsQ63pSr/fnx/3G442j5nm8P6W7/BmMbM/avNqDK4XHh4DJh0EOJauIeKON+uc7j8rONi61dT6
	+Sx+VU0OH7AoaL4Z/PBv+lHXRjOc9FIWwrcaaGVy6msPshamOB0d9uId8LLCaby2WrLUzZ75Rv4
	AUFsZukzNjYMeuvI7g61+lliINqFTVxd+FV3xUbCx8XV4La49N+AeCPgXJhLpL9w0sbZQKDE94T
	Yg=
X-Received: by 2002:ac8:7dc1:0:b0:4ee:ccd:7215 with SMTP id d75a77b69052e-501481206a5mr26400211cf.0.1768380764400;
        Wed, 14 Jan 2026 00:52:44 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:44 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH 6/8] dax/kmem: add online/offline helper functions
Date: Wed, 14 Jan 2026 03:51:58 -0500
Message-ID: <20260114085201.3222597-7-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helper functions for onlining and offlining memory ranges:

  - dax_kmem_do_online(): online memory with specified type (MMOP_ONLINE
    or MMOP_ONLINE_MOVABLE) using online_memory_range()
  - dax_kmem_do_offline(): offline memory using offline_memory()

These helpers use the memory hotplug APIs from the memory_hotplug
refactoring and will be used by the upcoming sysfs interface to allow
userspace control over memory state transitions.

No functional change as these helpers are not called yet.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 103 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 5225f2bf0b2a..30429f2d5a67 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -190,6 +190,109 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+/**
+ * dax_kmem_do_online - online memory blocks for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_ONLINE or MMOP_ONLINE_MOVABLE
+ *
+ * Onlines all ranges in the dev_dax region with the specified online type.
+ * On partial failure, previously onlined ranges are rolled back to offline.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int dax_kmem_do_online(struct dev_dax *dev_dax,
+			      struct dax_kmem_data *data, int online_type)
+{
+	int i, j, rc;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		if (!data->res[i])
+			continue;
+
+		rc = online_memory_range(range.start, range_len(&range),
+					 online_type);
+		if (rc)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	/* Rollback previously onlined ranges */
+	for (j = 0; j < i; j++) {
+		struct range range;
+
+		if (dax_kmem_range(dev_dax, j, &range))
+			continue;
+
+		if (!data->res[j])
+			continue;
+
+		/* Best effort rollback - ignore failures */
+		offline_memory(range.start, range_len(&range));
+	}
+	return rc;
+}
+
+/**
+ * dax_kmem_do_offline - offline memory blocks for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Offlines all ranges in the dev_dax region.
+ * On partial failure, previously offlined ranges are rolled back to online.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int dax_kmem_do_offline(struct dev_dax *dev_dax,
+			       struct dax_kmem_data *data)
+{
+	int i, j, rc;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		if (!data->res[i])
+			continue;
+
+		rc = offline_memory(range.start, range_len(&range));
+		if (rc)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	/*
+	 * Rollback previously offlined ranges. Use MMOP_ONLINE as a safe
+	 * default - the original online type is not tracked per-range.
+	 */
+	for (j = 0; j < i; j++) {
+		struct range range;
+
+		if (dax_kmem_range(dev_dax, j, &range))
+			continue;
+
+		if (!data->res[j])
+			continue;
+
+		/* Best effort rollback - ignore failures */
+		online_memory_range(range.start, range_len(&range), MMOP_ONLINE);
+	}
+	return rc;
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
-- 
2.52.0

