Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1EC304BA3
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 22:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762555815; cv=none; b=sj0tBLV8hn3R1dA1ui0iPN2kmUKhHoMpbcL+t817u6jMbAy263/GNdQQDpMo84xTo0qJjRsyjKAPVEzssBXrWzq4nb8cpA4PHcpkuI2q2HnabQZT+yEeCgFftB/netGdmNf1geK19MuflLRScYu4grPUIOPTUXODMMf36HI3vKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762555815; c=relaxed/simple;
	bh=t1PWd9W4F3MKCeCrtb+bV5TXG4Q3iLBygfAXlk1bL90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvDKCyl+A0hJgCNrDlmw7Mszh1/kXH7OaIdods54NIaSBeEhtLUjbPNy6J7x6d1pROE2SwjhByx64yTVbU7ollAcjnkGaXqh6DfYZGJW5sKYgbnMLoKAKpNW3X5sBla35h0cyGuRvcBHPEguKN8rCMmhDrhf1cCWFZ2U/byP9cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RmTxXzZu; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RmTxXzZu"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-87fc4d29301so16137196d6.2
        for <nvdimm@lists.linux.dev>; Fri, 07 Nov 2025 14:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555812; x=1763160612; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R64FiI16+WP3yeCxBiatrBL599beZnZfURxXJrYPjuA=;
        b=RmTxXzZu0s6Eoq5+diafz+1x68W9FSabmFxIw3D//iidMOklSLxq+BRY5BZdjm2k7G
         QKXdSnTtjUVyYVVZB0EDzJ+PySSPGGZ0I4TqUz4k86antbCgfkFJwwCSQ7WEEtI5I2xt
         NP39x77CPDUtu81MqmIp5OwoJ50ieqS+kFxeRpLM8WC9gtPY3NR9xl7XLa4QaN8Q8w3f
         m5iXEl2rgZVmOr8xZpTU058bg6NSij478Qr3PChApxgdkoy0Gce1QIjGlCeg8qfBdBrw
         gjrvll4P1SVGYAuh2AhXdEOAGk3Em3r9YitPSnnZX7DdBXVnUfb6M3CHh364V8WITfJh
         wUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555812; x=1763160612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R64FiI16+WP3yeCxBiatrBL599beZnZfURxXJrYPjuA=;
        b=SiQw0U0TIbfPgKTJX6p3G1OlLqjg4aiEIacVCVBKDKQHaBb3bdsCkN6XjCW+tm60dc
         17P0hlY7aKLiTRDoypQM8mm/QjFRRheHiUu5pyHY1oZzFtldRWkBIYCmr3qmKvd88FXr
         FoFXmDyMtACqRUiwdV6FPlVpEA3a8pTFdSljqbIT3WjbCt1Vd+Nh0DYABCIvt6PAPNHd
         qR8BowNUZna2QCqHFsDp6WoDP5DEcmTYLhHb24N5qWaOxXzLBpb4esw9zWTNn4LYA35r
         4S1AMTc4nw3yX7X1RlLZlNcyZm56fyd2bjRkbaT8jyOFJnRC4iAU9B5SlLAZ5ca5ak0d
         Rmug==
X-Forwarded-Encrypted: i=1; AJvYcCUCTg3jaQmI1vPRNr4+pF5kYS3RWkm1Flx+vMDIW0P4lkdrdGP6v3SJTbNyiopEfs63cC5GHCw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5YC919S47p8GwobYtPPpvSjQvC7+5nndGUxj8LDUl9dRk9QAK
	SJhKNUGwpFdS0S0cgVC/Us32Cjf+sjjoQvLXRdYoa/o8raj6A15kw67ilufILOtAk98=
X-Gm-Gg: ASbGnctWQfMzhz67tzZI2AcP/UHe2T6HN9k7gsKJu8gRR2eFdty7FvoMVDAdLhNstO5
	F9HjtSrR4jaYbz4gwwzorokV3H4cnH0Rkanr5BYg0I0OSjIn6SMYb4xFu5FBka3m7ym7ogcN3ne
	1iyimxLEcJHRSU/qWAO0BgthIBT4Rli9TkCJe3BvxHJJDwWOG8W4t57kfUEb6eV0o8SpYQAPhQK
	Jvwe6nguRYqE6Zc/ZXyzrwaASSE3mteg6Phc2UKgkX1u+yloEAQYa3n71OYL7X77+oOMvBU5m/O
	okPdgmBf4Tf01NdXU4K0YeT/KLqYz823j22dA/se6x1SlyDIdm+7/4Wfq3MccQLe/q9mQDseQMp
	nji+rZj+E5udWXGEBgZtk9rhDLPOPEe6Vek+z0jkqWTnBF5cPq9snrQJpGJZegQL4xthori8QNr
	tByYxcatuAh2n6ixq9/5YSW9UY9jd/F2zSgRMUv9r6IveN9Clj7VEgnTIFjRrOIyUAIweiLGxba
	s2cAzN7txNkZQ==
X-Google-Smtp-Source: AGHT+IG4CM60aE94hoVAm6WlLLrQN78GzB6+sZgYXWXWNkYKc0tId9Jl3T1QS1663TlSzExe8IcNow==
X-Received: by 2002:a05:6214:20eb:b0:882:36d3:2c60 with SMTP id 6a1803df08f44-88238616f43mr9660116d6.19.1762555812276;
        Fri, 07 Nov 2025 14:50:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:11 -0800 (PST)
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
Subject: [RFC PATCH 3/9] mm: default slub, oom_kill, compaction, and page_alloc to sysram
Date: Fri,  7 Nov 2025 17:49:48 -0500
Message-ID: <20251107224956.477056-4-gourry@gourry.net>
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

Constrain core users of nodemasks to the default_sysram_nodemask,
which is guaranteed to either be NULL or contain the set of nodes
with sysram memory blocks.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/oom_kill.c   |  5 ++++-
 mm/page_alloc.c | 12 ++++++++----
 mm/slub.c       |  4 +++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c145b0feecc1..e0b6137835b2 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -34,6 +34,7 @@
 #include <linux/export.h>
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
+#include <linux/memory-tiers.h>
 #include <linux/mempolicy.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
@@ -1118,6 +1119,8 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
+	if (!oc->nodemask)
+		oc->nodemask = default_sysram_nodes;
 
 	if (oom_killer_disabled)
 		return false;
@@ -1154,7 +1157,7 @@ bool out_of_memory(struct oom_control *oc)
 	 */
 	oc->constraint = constrained_alloc(oc);
 	if (oc->constraint != CONSTRAINT_MEMORY_POLICY)
-		oc->nodemask = NULL;
+		oc->nodemask = default_sysram_nodes;
 	check_panic_on_oom(oc);
 
 	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fd5401fb5e00..18213eacf974 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -34,6 +34,7 @@
 #include <linux/cpuset.h>
 #include <linux/pagevec.h>
 #include <linux/memory_hotplug.h>
+#include <linux/memory-tiers.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
@@ -4610,7 +4611,7 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	 */
 	if (cpusets_enabled() && ac->nodemask &&
 			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
-		ac->nodemask = NULL;
+		ac->nodemask = default_sysram_nodes;
 		return true;
 	}
 
@@ -4794,7 +4795,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * user oriented.
 	 */
 	if (!(alloc_flags & ALLOC_CPUSET) || reserve_flags) {
-		ac->nodemask = NULL;
+		ac->nodemask = default_sysram_nodes;
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
 	}
@@ -4946,7 +4947,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
 			*alloc_flags |= ALLOC_CPUSET;
-	}
+	} else if (!ac->nodemask) /* sysram_nodes may be NULL during __init */
+		ac->nodemask = default_sysram_nodes;
 
 	might_alloc(gfp_mask);
 
@@ -5190,8 +5192,10 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	/*
 	 * Restore the original nodemask if it was potentially replaced with
 	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
+	 *
+	 * If not set, default to sysram nodes.
 	 */
-	ac.nodemask = nodemask;
+	ac.nodemask = nodemask ? nodemask : default_sysram_nodes;
 
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
 
diff --git a/mm/slub.c b/mm/slub.c
index d4367f25b20d..b8358a961c4c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -28,6 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
+#include <linux/memory-tiers.h>
 #include <linux/ctype.h>
 #include <linux/stackdepot.h>
 #include <linux/debugobjects.h>
@@ -3570,7 +3571,8 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
 		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
-		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
+		for_each_zone_zonelist_nodemask(zone, z, zonelist, highest_zoneidx,
+						default_sysram_nodes) {
 			struct kmem_cache_node *n;
 
 			n = get_node(s, zone_to_nid(zone));
-- 
2.51.1

