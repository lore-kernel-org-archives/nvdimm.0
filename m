Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A443BBD5
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 05:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711690444; cv=none; b=cq9HMMMXavwYu626Fp6hqT9RPXgBS3ZH1hIcIKn1UxNVEY2t+C+cc5X9Bv8FT1Kh4juKXUo+5IM1s3InlcBYNrTkw+VkxD9tf/upI9nvFcn4GNqAifpEiKn/5uWaA0pujMjAhYKmQJcdLQ+/JI1sKRsvPhRQXwWbL2r9Uw6RZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711690444; c=relaxed/simple;
	bh=vXOLrurzWw91h7eYCw90ZLDHh+I4uNd31lHySo7hGYw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NrXIycdkDsuQURTMg8ps/iYxgdVxmHX5aS23jSRPKtHpMSSnYxbvXf5XFx8Ib53xTqBLUWSZWJMXfVKnniN3Bv7mOayhC9E4LCJrt4l5/lrufdoA37OAfCAgaBqCK/ommntLOCgY3Jbjxb50EzAHyTHZhUFYB0sPyAJh9Psq/zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Z0lWIe87; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Z0lWIe87"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-432bd633207so3531731cf.3
        for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 22:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711690442; x=1712295242; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM2K0D/X61aNkdsdtPeKZ1y9TeOUsh6nA3RvZQfcaBY=;
        b=Z0lWIe87ny2KBjiZ37dtpxNtmaHpQ3Q86fjMc2yylU4tVSFLJfj6Iq3W8tjMaJczvS
         al7RyitMEe8QUSdRImgeQvsJpZ799buet0ibb8367oNESY1jS63NEKRoVVcXOaNowlXR
         xqZhJruposuLyv3D+teYPE+DxJFpVNNXaQg+LWdPof0B+7hd/DWRAsgxfJB3x946dXIm
         tT2rlyyEtCjefBNmdbUu1QGitaz1RHqnFdZqrJ+yUV3ZDVQB0nWf0PvbrV+1/2W746ts
         Hngixa7a6DyKdN8nle2EcL7A8AktpQKW/z3pKFixJezkVC8YF/VSWWkoEwPSbbZXz25R
         kXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711690442; x=1712295242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nM2K0D/X61aNkdsdtPeKZ1y9TeOUsh6nA3RvZQfcaBY=;
        b=hal5FTBCef/G9E9YKHBbZW5tmV2FDI4UPyZq/T92A1jyIB9g0IdonY8Dn8hH5STZKl
         UG/4RbhJgQYf+GzWQi46Xg/zhNoFq1osb/Pek1cKSVaE5yVx2A3q7HR37KdGDzS4lYDt
         V/Oa9BqLRVAkUm2QBr1r5MaXsvYJOMAtNNFOVw0tQYSJQEcxY5pKygD6snJZ/vLSmpT9
         n/EycnOpBUWQa441JqYY7wdFWKKz6Nz+EIbhg61iB3pcw5i7mQ50pfQImTOzk7CUEbUy
         8nH7DU0WLojWCK2gWgCZxYP+gLinqesT+ywcCMFhrcFdLC9BSKGj2bZlQa6P4vwaUfeK
         PXxw==
X-Forwarded-Encrypted: i=1; AJvYcCVH0+c81HMQ83wISLQFnyo/bYNK+QMjZnhSP+ex8l0UWN+ZmdtvnZjR9hiQqLPezxolXmITulekOChULdpiol3gsQ2y8lhH
X-Gm-Message-State: AOJu0YwXMNSsCZEyRJlT1bgAeuPI+bJ4k2r6WuuyJvwBE93Fow204VdD
	+2Oi215NLiVJPxM3ciZH4FL9N6JIRCH2NgVkm9OiS2HPyguVmBujyUPY1enIwGo=
X-Google-Smtp-Source: AGHT+IFNoqNydjaxWSpQbLOw9NSrhWxbMGVfkX5oUHJM8lI3o7LuokzE9FNy1hUFSqYBfeSHSyDMdw==
X-Received: by 2002:a05:622a:10:b0:431:756b:c48f with SMTP id x16-20020a05622a001000b00431756bc48fmr1092286qtw.27.1711690441708;
        Thu, 28 Mar 2024 22:34:01 -0700 (PDT)
Received: from n231-228-171.byted.org ([147.160.184.85])
        by smtp.gmail.com with ESMTPSA id jd25-20020a05622a719900b00430bf59ebccsm1293700qtb.11.2024.03.28.22.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 22:34:01 -0700 (PDT)
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
To: "Huang, Ying" <ying.huang@intel.com>,
	"Gregory Price" <gourry.memverge@gmail.com>,
	aneesh.kumar@linux.ibm.com,
	mhocko@suse.com,
	tj@kernel.org,
	john@jagalactic.com,
	"Eishan Mirakhur" <emirakhur@micron.com>,
	"Vinicius Tavares Petrucci" <vtavarespetr@micron.com>,
	"Ravis OpenSrc" <Ravis.OpenSrc@micron.com>,
	"Alistair Popple" <apopple@nvidia.com>,
	"Srinivasulu Thanneeru" <sthanneeru@micron.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Ho-Ren (Jack) Chuang" <horenc@vt.edu>,
	"Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>,
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>,
	qemu-devel@nongnu.org
Subject: [PATCH v9 1/2] memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
Date: Fri, 29 Mar 2024 05:33:52 +0000
Message-Id: <20240329053353.309557-2-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240329053353.309557-1-horenchuang@bytedance.com>
References: <20240329053353.309557-1-horenchuang@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since different memory devices require finding, allocating, and putting
memory types, these common steps are abstracted in this patch,
enhancing the scalability and conciseness of the code.

Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
---
 drivers/dax/kmem.c           | 20 ++------------------
 include/linux/memory-tiers.h | 13 +++++++++++++
 mm/memory-tiers.c            | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 42ee360cf4e3..01399e5b53b2 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -55,21 +55,10 @@ static LIST_HEAD(kmem_memory_types);
 
 static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
 {
-	bool found = false;
 	struct memory_dev_type *mtype;
 
 	mutex_lock(&kmem_memory_type_lock);
-	list_for_each_entry(mtype, &kmem_memory_types, list) {
-		if (mtype->adistance == adist) {
-			found = true;
-			break;
-		}
-	}
-	if (!found) {
-		mtype = alloc_memory_type(adist);
-		if (!IS_ERR(mtype))
-			list_add(&mtype->list, &kmem_memory_types);
-	}
+	mtype = mt_find_alloc_memory_type(adist, &kmem_memory_types);
 	mutex_unlock(&kmem_memory_type_lock);
 
 	return mtype;
@@ -77,13 +66,8 @@ static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
 
 static void kmem_put_memory_types(void)
 {
-	struct memory_dev_type *mtype, *mtn;
-
 	mutex_lock(&kmem_memory_type_lock);
-	list_for_each_entry_safe(mtype, mtn, &kmem_memory_types, list) {
-		list_del(&mtype->list);
-		put_memory_type(mtype);
-	}
+	mt_put_memory_types(&kmem_memory_types);
 	mutex_unlock(&kmem_memory_type_lock);
 }
 
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 69e781900082..a44c03c2ba3a 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -48,6 +48,9 @@ int mt_calc_adistance(int node, int *adist);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+							struct list_head *memory_types);
+void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -136,5 +139,15 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 {
 	return -EIO;
 }
+
+struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+{
+	return NULL;
+}
+
+void mt_put_memory_types(struct list_head *memory_types)
+{
+
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 0537664620e5..974af10cfdd8 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -623,6 +623,38 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
+struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+{
+	bool found = false;
+	struct memory_dev_type *mtype;
+
+	list_for_each_entry(mtype, memory_types, list) {
+		if (mtype->adistance == adist) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		mtype = alloc_memory_type(adist);
+		if (!IS_ERR(mtype))
+			list_add(&mtype->list, memory_types);
+	}
+
+	return mtype;
+}
+EXPORT_SYMBOL_GPL(mt_find_alloc_memory_type);
+
+void mt_put_memory_types(struct list_head *memory_types)
+{
+	struct memory_dev_type *mtype, *mtn;
+
+	list_for_each_entry_safe(mtype, mtn, memory_types, list) {
+		list_del(&mtype->list);
+		put_memory_type(mtype);
+	}
+}
+EXPORT_SYMBOL_GPL(mt_put_memory_types);
+
 static void dump_hmem_attrs(struct access_coordinate *coord, const char *prefix)
 {
 	pr_info(
-- 
Ho-Ren (Jack) Chuang

