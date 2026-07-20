Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8218A47A0C4
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576110; cv=none; b=MLoNUbdV91rOWM89WvpYUHHYtgQJdsWbsh3rJwJVdB2LhS5Sz3sn50xNuLUeNLWsdQil1ENdvUqhoDY7hHWzSprLEQFKYvo05HZ1PeNy1v/GmmVU8bVWhibaKhFaal64i+yNw1YZD0cyi9l6ZokYjR9Djjdpiw0xqi0Xru0X8a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576110; c=relaxed/simple;
	bh=w0eKiY4I5uQufyW64Owv7K7jj+Cw2kBSZ0H/fUn8aTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5Fd48yyvmETUAjB6tuNDMRuNKVGcLDWnD4oi4fzczazV3BRpxeZva6MpfvstWJ0743/7t+UIy5lJz/xZ9W5XGpj9JR2dAd5OkV2QDldFvWB+rKHucmByM+RkLjyCbaptqntpoW/7JJj5nK3zq3C9/v7YahwEvGywWdrZoVzvuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=l7htEs2D; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="l7htEs2D"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e5c9211d2so926775785a.1
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576107; x=1785180907; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AbvY/gXh+2/u61eyWpGKI13cVvWaG4WQkB8wV0sMVYg=;
        b=l7htEs2DpB3UFo9n/br8LcKGCQKGhNJaonS4N5sM5ITKINNXT/WTckkYxGCiBkYKsL
         PVAiKjFebES+B0AKO7Cj18KcN8KL5tLiFD4KsO4Fe+sUr8+oPJmnaUoNHFlPmOocymRk
         m7qSZOTtJgHRpGykMP7hBYH2ElR9k2O7ftLj5k6rTpP1S5cAFO+d/AAm46e5Gtsys2BT
         Z4PpNWu/AStTnKnnSjKX9Gr4jbBY4eCesofHnALH+d+3tI4u7ht5IkGegzM40cEp9o5E
         nO0vILKJIFMePfTLSU+CRqQs2/QKxYM2RVlmvfveMFYdSH9Dg2LOSR+n6Lm+++fXLiPe
         FjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576107; x=1785180907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AbvY/gXh+2/u61eyWpGKI13cVvWaG4WQkB8wV0sMVYg=;
        b=atCDdJwyR1iULcVEXXzZ1K1cuvyIlImDcTuRK7gJO2XyTqQeqAL/VrCr4QOWd7VMEX
         /5I7DpxtdzCFBnIdCLnRhH59vozADdC/YPP0gNKKBZ5Wf0YiHF9a37jjXEtLrR0m4d8P
         DHJYCBeI/GPHQ8gYiOiEw+kWc4vSj/gqN6mrAds4U4IbLXu8nlI7mH9e+grgT0VLjylR
         I/mNzwGbu8MSifSxH03/Vtx7zMWYGF1n0Ef+mPPoRPF9U/Kl8X6wUzg1U7pPqfbFQ3uP
         miJQ7Ep/My21fAGQMfvbIkOFhDqJuWJVQbehJ/PvCYJbBgfEV2PBapnVnRDMe4j3onk3
         RiCw==
X-Forwarded-Encrypted: i=1; AHgh+Rrt5EHoLvckrMYGb+AWWmkg1/f3HfRGrEhXrrRvMO7KsDBo5YqxNTbtgdI0zQLBClvZyDQqMr4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBTs+gMFTD+gpOWg73Zkou1b8rjwVgSSVqXTNJmD/EMU5UmJEy
	h7Y16Qg95aQ8DSCpB7daDWAhW9q5Yc7+0x+e0cGhwT24A5LZugT0h9It1EHwtVkS5+I=
X-Gm-Gg: AfdE7ckYZjDGpDIOT9xT08k22yofEaDtFxEBUr1iw9r17OTbnkL+vmsPFh2KduYBfmG
	RN0pV+mSePXK2vBlUgCGvRqYL1qiAUvK1hPCCwIcJPLkZDYRN78LJ43dwUBjr9R29nOCaN2xE3j
	igX8Gh3pUb5/ULR9zFG4Ea4ehcnM1IAtWDAhtYIhlLRUGTaW3Zz7hedMf9l3Wl8HwkazUPWL1ni
	OQBKz4ka2axgEG98xq48YbKsohqRpFTa7GtZdtLTHYhUKNmW3f9HdA16uKu5dlCPBzs8/sPrWWf
	mHkJknTBAXtUtar8hcKFprq9qb6vZwjniuGEWGMovuvfI5qNmIwtno2F7pAGBM7rD/mwoZXNuvC
	oaBfft6yGsLTJ/DI3cQM3Iy91QzX/G9xhuUa6crY2KIZVuFeQEl+nufRRD7IJBPT2Vqj+HyQr+k
	tdT4y219Fkp6UbrTHLRMwmPTH2shLrkwTme1zTawrMYSMueezTsinQ7MgiFUg32/w=
X-Received: by 2002:a05:620a:44c2:b0:92e:6b95:237a with SMTP id af79cd13be357-930b3f45487mr1592960485a.32.1784576106925;
        Mon, 20 Jul 2026 12:35:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:06 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 11/36] mm/compaction: disallow compaction on private nodes
Date: Mon, 20 Jul 2026 15:34:05 -0400
Message-ID: <20260720193431.3841992-12-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip compaction on private nodes. Compaction requires the ability to
migrate pages, which is not yet supported on private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/compaction.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9f81055a358ed..8c1351cce7bcc 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2462,6 +2462,9 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 		    !__cpuset_zone_allowed(zone, gfp_mask))
 			continue;
 
+		if (node_is_private(zone_to_nid(zone)))
+			continue;
+
 		/*
 		 * Do not consider all the reclaimable memory because we do not
 		 * want to trash just for a single high order allocation which
@@ -2853,6 +2856,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 
+		if (node_is_private(zone_to_nid(zone)))
+			continue;
+
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
@@ -2922,6 +2928,9 @@ static int compact_node(pg_data_t *pgdat, bool proactive)
 		.proactive_compaction = proactive,
 	};
 
+	if (node_is_private(pgdat->node_id))
+		return 0;
+
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
 		zone = &pgdat->node_zones[zoneid];
 		if (!populated_zone(zone))
@@ -3017,6 +3026,9 @@ static ssize_t compact_store(struct device *dev,
 {
 	int nid = dev->id;
 
+	if (node_is_private(nid))
+		return -EINVAL;
+
 	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
 		/* Flush pending updates to the LRU lists */
 		lru_add_drain_all();
-- 
2.53.0-Meta

