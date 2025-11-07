Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B87314A94
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762555810; cv=none; b=b+hhfEgwbz+QSkI22pjuPBGhQdvBUS6LXfuwETwtw12QRCamj3OTkpMsWCa/VkeKkj7UNKSqtyi2PHSaz9EJ1RqZaq41BnCnQhVPVPAjMq7BBM0qKEdg2IvAjUn/i8TRcEQMM5EMb2CMkUod4GzmPVmMHIQ0v3zidpLaMDeJqUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762555810; c=relaxed/simple;
	bh=UCpXheq+ISF5ooL3BArG9j5Ni7nrQ94FnST2TGVI9qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KE7f1E3v/WPLkfop/h46nA8Q8nEbgcuUEHNKUwFBzpNXI67FjwbV7k+xw2pz5DEcBzVuX/Kxw7+ZVu3N+TswVvOEqU7mUk8lAxO/mtxozMETHAjUiMIiwLrMEe2j/54211Ij98H7EvY7vGx8uxPSWRy38aojxnGbqkg39jpAG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=EsBW8m34; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="EsBW8m34"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b1f2fbaed7so118509485a.2
        for <nvdimm@lists.linux.dev>; Fri, 07 Nov 2025 14:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555806; x=1763160606; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCHR6ylRLZZ9pqd+jMer6/IGdndwoE5PhK5YE6dS19U=;
        b=EsBW8m34EiJkA4VD4nNSboitjjOvQreCQOfh5K+OWGXOgUzkbNNcXOHv6IEILZi88c
         0KGY7AWyRSMLSzLdQdNRQlimJG1/EZnEzkosqncJzNLMPWADZyQSbI7b+tDzCcJf+1zV
         yzR0exf9H9UjJZsg1QjEZc4tzgz3dggOZ8AYYFzSbiVMB3YCOBLYWJlAV+tHFfVE7x95
         9acmvzG2BBJD/EppBULDyAVnRykbMd/7xNIBXJbkH5BdSqk8rH4THCf4tC+5f8dmCRyd
         Ss0DEi/yDPDsJUdswdyueHJ3CEaswtfl/tbSkCvDCWpzlp3Vgfj/W8MIqmfEIOHlNxNP
         cRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555806; x=1763160606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jCHR6ylRLZZ9pqd+jMer6/IGdndwoE5PhK5YE6dS19U=;
        b=A8grMCrXmSP2Nwu8w26vr6pDq/LGp0ggUowRCqDoh36cxt8Cee+68ZEtLKZsFa1Il3
         CXExRkIlTjJVcxvwKo3jSs6SryJD7jwE8tpXQQIHBvFfi0VkGRtuBRR6/BTg1QIAOLf2
         Z/NRPpM8k0bkeAJLmfwxJhvpV1e6EJtdmo7fuwMDF5u6j8GdKCpeiDfdtc0NNypnoXzd
         4b3592uWCB1aaJ3ZDxzG1TvWHun5JCtgURnPcya5letfUA9IpNx7nTKSwB2jc4zOYygF
         W1qojGCNHjz1MssgK3B3TnzoTJLTgp3u3OnjTWcRz7+SVanxarLhuM+9FTkLFRKurak6
         cPUw==
X-Forwarded-Encrypted: i=1; AJvYcCV8J9+lYv5GvjZFBXDzUF5aCfOyZ/v6vvkiawmC/4SUuEyihQ4R5D8tT/iNjBZR5kGWlr0a3mU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzbg1mAV/Dd3HcsoHy23AZ5Ow18h9hDKf0XZ2oQlwjAYlxQefoc
	shMoI4+xtcdLY4EChWGI2yhtWgmRz+QyCefrLcm/S1Q2l+36KdNWmt3Y7ElDhtqE5ss=
X-Gm-Gg: ASbGncvSt23lxot1H9+If/FKayhu9f7SA1Pm7szL5RnoV1OzUr7I6MF9GAFVKJwzrw1
	jVHMR9UU7LbHgSi7stoAzl3FbH74isInaxhfY5Rp5nm3y7CHI2Z2lZi8Le1qroIT4E8LouOhqss
	4ukErLP0ymBPj/caRGx6qdUALOEz7DpBLgCh9tKqTxxAf3jkscGkZ+muBZ5DHAtpEjVsaV8cAA3
	xOqmCPD15qygkut2DkMHMWFYmO19ObNcg69jqpIkVR2KzAWLryzjk4sFpDGf4ZL8FqmotmlHEzv
	6JwCIYxMGMRtKtXBe3rxLYQp1nKRA86X9qq3qmLJIyKYltSyh0TL5XB2Bhfybe/IrCkT5a/Ox9O
	EbQZm8IfoA6zyl3RWmIp8szx+nMk52k8YfAytbdaaSOlz1cnNweA1adAnesjC8CxZkiGYlZ5jgA
	V9i9axkMPKVcGC7gh/QmDpr97yxcxpSsR7ADV9tvGTLs1/F3nSFbtOqi7cH8zbxq0OdcB2wHPeu
	c947ILpYoN/xw==
X-Google-Smtp-Source: AGHT+IFFPECdAOsGcbR+MEazzzIO7MJP4xCB0/B2/FxsL9mdOEjwM8IeKSGUWcVdouQFvc3wSAz+tg==
X-Received: by 2002:a05:622a:120f:b0:4ed:6e79:acf7 with SMTP id d75a77b69052e-4eda4fa468emr10231361cf.41.1762555806006;
        Fri, 07 Nov 2025 14:50:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:05 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH 1/9] gfp: Add GFP_PROTECTED for protected-node allocations
Date: Fri,  7 Nov 2025 17:49:46 -0500
Message-ID: <20251107224956.477056-2-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_PROTECTED changes the nodemask checks when ALLOC_CPUSET
is set in the page allocator to check the full set of nodes
in cpuset->mems_allowed rather than just sysram nodes in
task->mems_default.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp_types.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f905..2c0c250ade3a 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -58,6 +58,7 @@ enum {
 #ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
 #endif
+	___GFP_PROTECTED_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -103,6 +104,7 @@ enum {
 #else
 #define ___GFP_NO_OBJ_EXT       0
 #endif
+#define ___GFP_PROTECTED	BIT(___GFP_PROTECTED_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -115,6 +117,7 @@ enum {
 #define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
 #define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
 #define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* ZONE_MOVABLE allowed */
+#define __GFP_PROTECTED	((__force gfp_t)___GFP_PROTECTED) /* Protected nodes allowed */
 #define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
 
 /**
-- 
2.51.1

