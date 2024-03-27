Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F3123774
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 04:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711513015; cv=none; b=tivlHKphGOwmo1xkKxg7wHUhdqeJ9dZAihFvlUKxjuZ2NqHWy/BwaTLyrIlIeRfvnB2w/7NL6fV93ZTbkoEI4ud0dObK50TTf2Jv1icCDhBr9g47xvG2wrqXjVGrwMPfkwqkvQQRMqBxNE2B7Be2S9iKkxTQNFFdI+UdKP+3Lu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711513015; c=relaxed/simple;
	bh=vFF0xl5uC5TkFV+VvhVksXaBFVN1XObnMprIpkcV0NE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bk4q+VmrUcHf8DDjkKJphOBc+9LFoKP/3ammSWEdB4JPpCft7RpSRhJ4vi+pehjsBdoN7UnZVahohp8N5lyLT0ygbY0bSwSW/VsOrgKHh6bjGCfCag5mySo58SV9yabtZyrukuYL36HivwYt7tKSv411U5DrBs+x1w4QhFWJ+Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ewwuAvDM; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ewwuAvDM"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-42f2d02fbdeso27406891cf.1
        for <nvdimm@lists.linux.dev>; Tue, 26 Mar 2024 21:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711513011; x=1712117811; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvdqGcDUWp3D4k7+aVnVSTSeWYL78OJhC3HPSf53QMU=;
        b=ewwuAvDMIvKdBOpepyS+8nYM27pRmAEWeKR4+K5tvOSFAbACL6UO+S3+KxpLqYFsV8
         ApETNeJkutsr4764OQQX3KeyVcxCyl8Hi2RTAdDcDCe+JyjnyBzE1UJtLI4q3McmVqIT
         u85v7O5NrI0WXD1H14r0XFTHqk3EJzpUHBTFrKWYAnIcOztVZHIF7hVcXsMf0f82NQmB
         983n6YYflY9yQ+Ec8mtOVJgVDRc9DRoR7Web9Q5M9NNRbYKvV9g0YckdZsa87Ac3AMy0
         TZQx4vSDzc3WBU6TgEjdsGe08EY2vHUra8ICG+ZutSaiuGGAHfCs3349rsndnPoWSPzL
         GaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711513011; x=1712117811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvdqGcDUWp3D4k7+aVnVSTSeWYL78OJhC3HPSf53QMU=;
        b=JDP0Hu9iXwbjUA1KLA/bQMzfLOF4N0BO85NiQRCAl1u8/fEQ4yLLwZ/k7SEzpE3xQ9
         1qE8Nrs3XXnDQpPknujOTkbrfzSrSXLyD6VkK7nxMUf10hWD4FF4rMVYgML2uYaD95lC
         f+zBnNGtSEx1oMt9IIJzA4z/qAuL52PiZm7qTHsRWlsIp/sI5/qJyIJsON0KwATByYB4
         Ei9fGs5uc75xdrbWXDubSa26dWUx4TMveU1ES5vFX1vu4i1DY9bqRFL30vf5GYZ9M2LO
         /c7dD2SVDQkicbn7GbEwl82EGEjqejWM6V951QvZejmRITMjCKm2JFShnqCOeZErcEqz
         HS9w==
X-Forwarded-Encrypted: i=1; AJvYcCUQ9FpDx2Sr8s63gu/kVnwY4MHf4JDwtVgPymD55xhb7d8glpjFA58nqY/u9y0azaepN/DI0Umm3qn6XwPx3c3xuX3ZXtsx
X-Gm-Message-State: AOJu0YxcIoa7VcNZQcU82K+j3VjbcYpgR7KB0h2sT3uP+dtrJp3+XzFS
	/OfMUsQnw7WZbget3uJAlgvf2Bxc2l3BWShQJ94zgsakWvvN36Hvdq3vwK8yBAY=
X-Google-Smtp-Source: AGHT+IEbcnIkX9F1+noiNxXN//yadPNJj9nh7BFrHLgyTMaUxP9qk1B63nH9uusK6y5BVegm9808jg==
X-Received: by 2002:a05:622a:507:b0:431:30e6:6eec with SMTP id l7-20020a05622a050700b0043130e66eecmr90754qtx.24.1711513011567;
        Tue, 26 Mar 2024 21:16:51 -0700 (PDT)
Received: from n231-228-171.byted.org ([147.160.184.93])
        by smtp.gmail.com with ESMTPSA id hb11-20020a05622a2b4b00b0043123c8b6a6sm4370696qtb.4.2024.03.26.21.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 21:16:51 -0700 (PDT)
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
Subject: [PATCH v5 1/2] memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
Date: Wed, 27 Mar 2024 04:16:45 +0000
Message-Id: <20240327041646.3258110-2-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240327041646.3258110-1-horenchuang@bytedance.com>
References: <20240327041646.3258110-1-horenchuang@bytedance.com>
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

