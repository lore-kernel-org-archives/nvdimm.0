Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A9E12E4E
	for <nvdimm@lists.linux.dev>; Fri, 22 Mar 2024 07:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711091051; cv=none; b=n6MoWiYQ/w3/2cHnQ2JJ5L9cWvFvGQT8fnhGfArgv4uj4xh5+g6RnNCwR54vDfvvJMQMV+cXUywujkfxVi8phjW04iPxUCEXuI+DKxHN4GQslBjXuVBLoffAgLOxIUHazVzs2q1ozlRA3Ax56MR3wr5ArRu+uZhAlUwMWD3kJlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711091051; c=relaxed/simple;
	bh=vFF0xl5uC5TkFV+VvhVksXaBFVN1XObnMprIpkcV0NE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U2N64Qp0Ow0AVTgBjEEhvgV00DUj+uUPDZ0zwqtIuxwe/1NwgbcKm64klkykGo5SFsHm1HFoRMNa4jQDFwa8pxDR+cTvWn+SZHwRBahRjRIjBWj1icmA9lCrCK5cszL8T6fTfB8vjswcFft15c0iioQxZuVu+CQRRdDNu/3gNKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=CUXrrkEC; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="CUXrrkEC"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e6b01c3dc3so921076a34.2
        for <nvdimm@lists.linux.dev>; Fri, 22 Mar 2024 00:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711091048; x=1711695848; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvdqGcDUWp3D4k7+aVnVSTSeWYL78OJhC3HPSf53QMU=;
        b=CUXrrkEC3CDUkPx7UwJiFO9QpjXVvfSXsaSdwiMgQEiy+kjT8EIl0c3ng9jl/hLP5z
         Y0o+//rdEPsvzr9JvjbAy2xX8YGWy/QpFd22WrvWncGu/PTWFSeYhJCzBOgSAo1VsnS1
         Qx0FHD6+P5BnXm1CkPqLhV8F5obehkduNoWEdA4e1uQSrl+n9JANm/c8aXw0vyTOjXld
         h+gfr+B7G3eqGu+0fhy1pqIWC3NMfxJrlXylyqa7WLLewvJ5fFm+kdQHujfQXY8j5K2/
         9IAQCDJNG6Nj3PAS7Vw1genx6LuTcUh9Vnv9sn2K1JB4wpV5mz3VSzzppL8O4i1fj4mR
         V9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711091048; x=1711695848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvdqGcDUWp3D4k7+aVnVSTSeWYL78OJhC3HPSf53QMU=;
        b=gEZAGEQizU+RKYJIxkcbJC5Jvp/ixSrGtZ4sgO4jvlpiQVOGPAvqS4SZFEyzYpIc0m
         Lhyxa6eTJHzCFCxKHiJH0TGRXcKZgn2xiJ+10ai1WPNuR09bsqECSh2b/DXD9wlJqMUF
         PeoMO0JUp01I59LovJjQ8GFvwGE+2Fy1tJ2P3zxvr/R2g84lfBXF3+ViliuTrEem8f6z
         +F8i0q0wATH9PTzI9SJbyHOzML1i7ZkXZcFN0NT3DM0hZHkNFsSypw5pNHcMgCyNC2/+
         OkG/E0+13kborZydj3UoPr1Ue3Wq1CeVAmuR+UA05V7orn4NOU97XaIqIrD+pamk3zPz
         BgDA==
X-Forwarded-Encrypted: i=1; AJvYcCUUQxfczQDEpCiW+Lp8ZsORVHRDjP4eW1tSIHZ04tM/rXZEXBH6brmyNlkMV7doKeJ/e+2ezz4vMz95sZnB6mE7+e1pO/N9
X-Gm-Message-State: AOJu0Yx2n4VjbxSddX1NrlscXEr5Flk8snk+1Cd5zrG2Ry+VFj7b4Go4
	wfrxTu5cAUGxd4IBiMwNnwuiabzT/Zy/xAuwf5jBdKVrhCkBgAH6T7UihlZBO1g=
X-Google-Smtp-Source: AGHT+IExMx82G1L/gVZ6jXrs/MSYhc9K/oqB/ubjzqHOlRbMAoe/h5NMx7SZB1F0B8mlmh4A9A/ppg==
X-Received: by 2002:a9d:6e90:0:b0:6e6:a66e:842e with SMTP id a16-20020a9d6e90000000b006e6a66e842emr1756946otr.21.1711091048480;
        Fri, 22 Mar 2024 00:04:08 -0700 (PDT)
Received: from n231-228-171.byted.org ([130.44.215.108])
        by smtp.gmail.com with ESMTPSA id k1-20020ae9f101000000b00789fc794dbesm553974qkg.45.2024.03.22.00.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 00:04:08 -0700 (PDT)
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
Subject: [PATCH v4 1/2] memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
Date: Fri, 22 Mar 2024 07:03:54 +0000
Message-Id: <20240322070356.315922-2-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240322070356.315922-1-horenchuang@bytedance.com>
References: <20240322070356.315922-1-horenchuang@bytedance.com>
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

