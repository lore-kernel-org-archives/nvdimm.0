Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3106A34FF4A
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 19:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975798; cv=none; b=kJXBVYihmosE6XURWQICZwxjrbz6Sd4VB/D3pX94mepTUnDARytfp4Hg9f6WPTVTOZXgRxVKkCzDaDdQ1mVJgPv6yIYYpTiOBdWphnyjondy5YgiDwsV6vdmKgTSs1RsFLxHFLM0+XPeFsAlYR/ljjDvPVTz6xzkt6Yw50Oe+WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975798; c=relaxed/simple;
	bh=LBAE8kZkJPq29k1iLwOntoOZutywPK8fvxCPXpNAG00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7bwL85DlMUT3Ef66HY3c2ShY7N6cw1N+jrb0tWsbrY54QKCinsuZ2crCJd+xPCLSMfbBlN0CfhR4ry3NNkUXX9fagDjQD1lzYfcgb6ddPETj555mueeQlP+33AkLpSr/fbtSSsvMCrHtVuTMeH6uEhe1w2489G0+ULcukPjmpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=S8z8EhZk; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="S8z8EhZk"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4edaeb11634so10116371cf.0
        for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 11:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975794; x=1763580594; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCG0uhUeeA1he7Dw5Q3elz2n5ZNHYlg7H15kRGg6IlY=;
        b=S8z8EhZkt7CIJN2z8f1GxKunAysRoZY+u6AiiFFwPu7TKlp82xBsnisbepFIU7JCQA
         b5upYUisZdDMde761xDrLdMXoV4HyNMOy5K5sI3T7LgbE4BDJ6jHgzcrb9EwarG9NqTC
         7dNE1x0ZaxpNozndN+ayXUkPDt1knTMQfWgjEFiuPBJSmSXVYKGozC0nB5oQ8p49hAH7
         5sZXZhyEQY6CCtpTKt8urGQdcDq2nl0koIsfKtbpQTGl0IweJsQIYArMmn2/52Nq5bPV
         RfZU5uMtSGN9+MpXMR0wS9NwzlO2JeMB5Ix30+9vua/GCt735Dv6h+XLe5LCJBS0K9DH
         9b+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975794; x=1763580594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sCG0uhUeeA1he7Dw5Q3elz2n5ZNHYlg7H15kRGg6IlY=;
        b=HevEJnE/neV53bgep78dQaKVpG0t4fn4QfaOjHHStr8UFFD52n7N9jTC6uQBltemUM
         HAOjQVfASEQOk4LcQGPFHPecEHxbSeuv/CTDHbqY0cSf46jiLG1ATtwO+7raiicdhzn6
         umdjtNW0MyEW3BoP1imPgynN2SrVNgYqGi6UxCHicaC+Wgej5v82rG0rtMPv7TlrZo6L
         w2lnRwgHsMLZRTta/xPxorm8sI9tz5QWZj/Qk7DL7qCAanP6dEdVEIOuPhM/n+Mw5uPt
         hTViM/Vdl+WgUSG7h7CKbgCDhO5GkJvr1mThxbjL3tlKr58UzwmdJdsNgKeCiN/Cq6Cg
         6HLA==
X-Forwarded-Encrypted: i=1; AJvYcCX+jxK05noeGwvVzvkm6OFWUSLAfwPTfKtln7a1TfXQpBMWcsCQ2QsRxYxwrEE/BD5PLoJJmLY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIkDCufh1JNrYev7yAw6UtWealONYaZO+y+J3xoziQkXtcRsVP
	pmK0/EIUbBLxbup3RT9Ut9ZsIMoBY5C+EHWRCg2zY9mfLkUVdyGBGHhKmUt0iPeHSBu75BlZ7fH
	wUKev
X-Gm-Gg: ASbGncsAzn/xOO8gx6qVovYzz5mXiFdwluNtoABsWJIK7KUEBKRHa+5LgyNwM21kAud
	Mhg5pPQhYlCrSwJ52VKMo78PzCm4EVwZiIvGDcSgOHWYsqBxg8L8ZeMbTm5FCYTa5tmBC1b8i2K
	R1mSVPgRxjN2QOrOxeGW8YenzMPeSkJPWKnVTEvz0nFw/0yogSFp3y7PqLtKywhSdxpdoLMPaa2
	wgPOUrEqrvh09tafQMph4zE4fKEXKRWjv1qEbs2knsq/HFOoB+XFq6CYYgkeitFQnpOQlCuv4+0
	pU7pazmJ+XuwRUBRJrgiMY3QCR7rPk2NeHne9P035fxtxRaszF2gQPK4kGiDasrJAohbn6l7oFK
	tUPwwQHw1EpX7h//gWZZE6jJ3u25ajGOEFoMYN/icWLALcB1P2RBBwPwkaDhJQ4ABkxLhYYyY+T
	9+vWTGsX1uY+LsqpbX575cfTd7IT9K6r7NrDhVoJQOkTLkMBNYiNPhRbvTPySUETL4PMfwGbDBl
	ME=
X-Google-Smtp-Source: AGHT+IHnM9b4iMhaMM3Umfgp794GytPagXJHdOPIuSBhJp6PMVhTsTQsQQE9eWpDhS66Z0o2IvV+zA==
X-Received: by 2002:a05:622a:2d6:b0:4db:db96:15d3 with SMTP id d75a77b69052e-4eddbd61fe9mr49171401cf.31.1762975793923;
        Wed, 12 Nov 2025 11:29:53 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:53 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH v2 02/11] mm: change callers of __cpuset_zone_allowed to cpuset_zone_allowed
Date: Wed, 12 Nov 2025 14:29:18 -0500
Message-ID: <20251112192936.2574429-3-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All current callers of __cpuset_zone_allowed() presently check if
cpusets_enabled() is true first - which is the first check of the
cpuset_zone_allowed() function.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/compaction.c |  7 +++----
 mm/page_alloc.c | 19 ++++++++-----------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..d2176935d3dd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2829,10 +2829,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 					ac->highest_zoneidx, ac->nodemask) {
 		enum compact_result status;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fd5401fb5e00..bcaf1125d109 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3750,10 +3750,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		struct page *page;
 		unsigned long mark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a node that is within its dirty
@@ -4553,10 +4552,9 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		unsigned long min_wmark = min_wmark_pages(zone);
 		bool wmark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
@@ -5052,10 +5050,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
-		    !__cpuset_zone_allowed(zone, gfp)) {
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp))
 			continue;
-		}
 
 		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
 		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
-- 
2.51.1

