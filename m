Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA6E47DD4E
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576119; cv=none; b=SYRKeK3IIhEBRrLHEVEmGvLS4JzGoyE8kejVCfZqbisZhlBBQWXXm4TfK9FTUxWght0qjTB2/+tP+08M6ygI6IBvzpGQFmwbCWW9oAstHuqZvQfkOoh3EKz49BIBLjdvsitH6TAHLR3M1FZU/Trgycahd5xEWlvGNf0H+j1oicU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576119; c=relaxed/simple;
	bh=cwT1qxzu5mcEtwbfCjbjp1x2zlkj7iTH/wP2YBbJ88A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhtgRFYsbjipUj8m/bbqSfgJRq9wYe3+t7pYaVauIUIcVVQjkmA1BgESC1HQH5h4jkA3Yi4PoHziAjNJPIJabvxJmmdAmfTxkl5utZdn6KaUsLD4Dw0tBbOP1GLNB1U6nXU1s+U6FTJHlTQNtz2s5Ax5qKgvIj14JKT/cspkDHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=QLgTBR7h; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="QLgTBR7h"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f18d92172aso93704736d6.2
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576110; x=1785180910; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zRBuTTcFDLFkxWr76FAXg5UPkm9NjmBW+wSCIxxIlUw=;
        b=QLgTBR7haH0eLp8HAn4nmyMNJcfccVZW3NuZ3Nt96wv+QnE9MFYbLB6MverwhNVKVO
         n1hnBLP6Kxs1P4DUEoIwi0Apoa0utiZmEDfW7OfpwCxgs1WiE9YhES46rP19XA4/XKEe
         iPcEVRlDAjyk9ZbVx/mYAWVP3QNajwa3X3fD6WAIfmZGjNrlaKYBFxw8M6JBe3ezN3Ya
         lziCB1MZgypAie1Vn/Hm0N97lz1bP8uo/Cln0pUNDfDNsb30647pVF/nKDjw/p+QHFtW
         uUT4r2VSBPe1scD+n5Qs3J0BelAgB3WhmGZ1Arm6nSv88DhvlErtOOHGRaG1WUBkGYEn
         jXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576110; x=1785180910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zRBuTTcFDLFkxWr76FAXg5UPkm9NjmBW+wSCIxxIlUw=;
        b=LzfLa3OrJKmshVSutU25t1dD4amyQQhnvkzZsufaUzobfpsst9ISFK9javT4D8cQmD
         vCBp7qS4K8DqmYaL+0sIfjIyvZCIc4N2V/J4TAv+WOBghGin20yBosUOhxXL3AvcRXJW
         FtEip6l9UGqfMOYXSIGCY/SgPk8HTVmn4vtN6MAiBNohZwXgCLNYVZliXBNx1toZJJqg
         3Ym+ASSIsItWue6lzDY8e8GwDsobwn0AikrPgyE/SDBYbE7pYA1cOUGp6sXT+Viq38lr
         YdxtGG6Q9dR7iTijcM1exZ3iqe81sE/zA8I88BVDqJYR7te8uGwuFlQpYpS3pSv9YkqA
         hzsA==
X-Forwarded-Encrypted: i=1; AHgh+Rod+C7ocRN6GDG5bdFD53FK7gBoKGdZMXTKhvb31WNGxgUM+GOYtnyMDZMwFLNfyCsURsWO/iM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhN3FN4eGrROSLMfeMRWZvJR1r5n7KqYGuFtgtCX+0gLwQJKnt
	KlbK+t9WtdupRivEkW+wVm+Lt0JGPSX6Dei00dLCnQxIbo7YZqFL9/evZu2kE+aJq/E=
X-Gm-Gg: AfdE7cmVPV1HfKjhl8ZF0C3E1UtxonKbFJtUs4TdreEar6mh2wR7hz5uUQpLyGNBLCn
	NTiFvMoNg6IKlHiVNcCicoUAwujtMNPBu+n3t1z/UEL/J0WRZL/ZG0wJJPMLay/nesWM+PmiKo7
	Xku6twyiyblhsn1cpqdbYu74xuaqTGKhRIW55U0qlDODfDnRNm9wQMDnCaZYkr73TBMFgbNHd73
	gwSLEieF3ej16xRRBDwlM2RWK/KX+1H/MRLYETfttTn4bk4jfmVfFZmAii2+H+Bn9un+eay67rk
	Zng1sXf5hCJVQxKclBBK2m3rq8Yv3Em5/Z9tNGZAzm1DCeiMWVgkp12plyhsgh9/8dYPPFrGLqp
	Di4o42ex6QTMvKRnFL3jftBn+L4R2jO6ykC1PM2RC8rGkOPv6MuV614yT8iHiyPdoQRrnAzRO6a
	8A8U15Dc/CzsdqDEHvTC9ueffoDjwwVfhSltScZ94SsiXbauJ7azra8mAj3Jsw0uc=
X-Received: by 2002:a05:620a:3706:b0:92e:f212:98df with SMTP id af79cd13be357-930b3ec8d4emr1550494985a.34.1784576110290;
        Mon, 20 Jul 2026 12:35:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:09 -0700 (PDT)
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
Subject: [PATCH v5 12/36] mm/page_alloc: clear private node watermarks and system reserves
Date: Mon, 20 Jul 2026 15:34:06 -0400
Message-ID: <20260720193431.3841992-13-gourry@gourry.net>
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

Set private node watermarks to 0 (reclaim isn't supported yet, so they
are pointless), and do not include private nodes in system reserves.

The oom killer can't actually resolve general system pressure by
releasing private node capacity, so including them in system reserve
calculations dilutes DRAM watermarks and causes poor OOM kill behavior.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 78755a55b1540..2b08bea2379a9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6555,6 +6555,10 @@ static void calculate_totalreserve_pages(void)
 
 		pgdat->totalreserve_pages = 0;
 
+		/* private nodes have zero watermarks */
+		if (node_is_private(pgdat->node_id))
+			continue;
+
 		for (i = 0; i < MAX_NR_ZONES; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 			long max = 0;
@@ -6647,9 +6651,15 @@ static void __setup_per_zone_wmarks(void)
 	struct zone *zone;
 	unsigned long flags;
 
-	/* Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages */
+	/*
+	 * Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages
+	 *
+	 * Private nodes are excluded because they are not in the regular
+	 * allocation fallback path - including them dilutes DRAM watermarks.
+	 */
 	for_each_zone(zone) {
-		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE)
+		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE &&
+		    !node_is_private(zone_to_nid(zone)))
 			lowmem_pages += zone_managed_pages(zone);
 	}
 
@@ -6657,6 +6667,16 @@ static void __setup_per_zone_wmarks(void)
 		u64 tmp;
 
 		spin_lock_irqsave(&zone->lock, flags);
+		if (node_is_private(zone_to_nid(zone))) {
+			zone->_watermark[WMARK_MIN] = 0;
+			zone->_watermark[WMARK_LOW] = 0;
+			zone->_watermark[WMARK_HIGH] = 0;
+			zone->_watermark[WMARK_PROMO] = 0;
+			zone->watermark_boost = 0;
+			spin_unlock_irqrestore(&zone->lock, flags);
+			continue;
+		}
+
 		tmp = (u64)pages_min * zone_managed_pages(zone);
 		tmp = div64_ul(tmp, lowmem_pages);
 		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
-- 
2.53.0-Meta

