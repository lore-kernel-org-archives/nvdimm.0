Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F21481256
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576127; cv=none; b=me1ypdlR2GwLa8cQzormor5dAQ1hTNhCEQW8+dlubOGcjjtra11/E0JISfy6bM5i2EFl41dYG4MnI+/aTO9Jd5UehMmQOT2VGELn7Cnb7ca8MXzN+5TKgsNGvZTSn10ykaI9kMfgKgabvGESwBsD8Saxv0MnEE7WqTMTppkFim0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576127; c=relaxed/simple;
	bh=AclVB29m5XEXwT6jfLm+y0Vje/ATQlFgKmkw+sbjY3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SO4Zl/qJrYGbqbibQZ3SKJEM21YIjX8/vKqQe9EJxMoqE5e5AA/fpFAq90aLZsfnHr4PK87hxN3trxAPUtlrR2aemsRMCXjtoPwu4KYNM5ovaLad38KTkB/FyWRHb8vYA00eUPZonimDhLq7sfeDXi/0PvaJ8XoBGgA7mTfjd7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=fi+I8HhI; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="fi+I8HhI"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92edb12cdf2so447574285a.3
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576123; x=1785180923; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v2LDhxlVOpgNtSXDCdv8imM0ubGsvF9EJ4oiPoX2j2c=;
        b=fi+I8HhIet7HPyizZcEDOVfm416HncKv+PdpftSW2rSr8U0JFj08ZOnsJqAMu6eB/q
         AYlhRQgBGK3YoYrJt067shMITN+nWz4IMUo0KEM0Z7E/5G9AcndkW1OSkT8yMLgynbDc
         aNHQ/YKKfTZLhHaBhU7kBEI892czirtk9A4yEPn+FbUBsy2KIhCrQm5xhO8ETrYITnfV
         sw7ZtRJ1+KQ+6Lim4tR5EXIUB5UEudpnt4mki2bBqhyrYCKnv2R4YeyQY0b3imroxpd7
         DMLUWEqwM0pJniLchGELpP4obXAPVUlshJmOaMkaGenBwMD5NdN4gkMg3K4q39Xs5zF5
         KxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576123; x=1785180923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v2LDhxlVOpgNtSXDCdv8imM0ubGsvF9EJ4oiPoX2j2c=;
        b=f4kfd3kD6qFKrT25fXABpwhGXgUN7C5JYXksJNBMtscznSBimCfcoEA382uFP3NT6Y
         So9hLkci5SMjmbBDMAaIx+8+c8aeI42R2IgdOUL2QQvauBvTO1NVWYAKzubivCLntLpj
         FXj+A2X2h6oXqhv3pjB2QaKdcYb9D0iKkIH8iBC8OBJY98jbGlX9tM4XpoMSKOYsxrSe
         0jBrA3pDFixTvxN2EMgVHrB/yXcsVCQgbM5kKtnoXywHy72B4cfxFYfZlgmfJxRR8Rsz
         9ifRvWHrIIJhVvtMeXswwkQ7MYMldfsTO6Z/3/odsginoYDEyudz5HZrelB/kDs3jQCN
         KkNg==
X-Forwarded-Encrypted: i=1; AHgh+RpxdrwrOz5bN8wCbbIFEKuVuI8uzPGAOcEfkkoAPvbCpVCHhYafUv4Z0lD0ZizyHkMPG/JX/Mo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yye1m7sWnk7VUudPl00Et1BVCBJV9gIEUa7+wXz91iOteWNTgfv
	S73HOZ4tIfxxZz2PSIXyNkQYaneHNWnZpCWwCRTWDalKcJ3PJlNBC06ssjQpFFHfXro=
X-Gm-Gg: AfdE7cnuJXX6Z36ThLZdpHRmDoKwiVN43iqjOVnA4Robh0CsLoKnND1xOhi1zkUEaGJ
	YoXXyZmRuu/0bk7P0qMHHud+khuhJuLnnhCjZ5LtgjSr6PkqFUjyY7JQVds7hVwQhyHL8Txx+Mw
	PHk0WNrqABPV9bZcatxi0iBssRfS76XPaf9LNQHFFKfBbluf2TQiNZbeead2xVvks04kdM3n8SC
	9xuY4JEbivozflMDCa98pGzUICaQCW7mT08yyj3g/SNHTTg2SvMvhN2M4HDdhbpyrmSCPstO4/r
	9QYcbWBoxw1n1g5BngiwIzQQUVyytPBAW4I1yWBbemkqmguPc1xiToaTTeItpOxYVc5iagXQye5
	3dmPAcClkwcckf+MGryJClS9dbOdSxvry8z0gtKGUtmsP3axlQFujeqpyVZilmvN2etfQlbufUD
	eszrwpuIfO93ds2G1itKhHXKDAhpE1X0qQmbuoDmsG4lW9XWhDGs6o5OPH4ikvM9NXLZKdkr9V3
	w==
X-Received: by 2002:a05:620a:288a:b0:92e:f3ca:2ec8 with SMTP id af79cd13be357-930b3e4b8a0mr1508481385a.19.1784576122786;
        Mon, 20 Jul 2026 12:35:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:22 -0700 (PDT)
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
Subject: [PATCH v5 17/36] mm/vmscan: disallow reclaim of private node memory
Date: Mon, 20 Jul 2026 15:34:11 -0400
Message-ID: <20260720193431.3841992-18-gourry@gourry.net>
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

Private nodes do not support reclaim by default, so prevent all
reclaimers from operating on private nodes.

shrink_node() is the common chokepoint for most reclaimers (direct,
kswapd, proactive, mglru, etc), so it's the best place to filter.

DAMON's proactive pageout bypasses shrink_node() entirely, so we
disable DAMON in a separate commit as its own discrete service.

Other reclaim entry points are already covered - e.g. MGLRU's debugfs
interface rejects nids that are not N_MEMORY (N_MEMORY_PRIVATE is
mutually exclusive), and madvise pageout/cold skips private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e26c6931f5fde..86b2334c23b98 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6141,6 +6141,13 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
+	/*
+	 * Private nodes do not support reclaim by default, filtering here
+	 * captures all normal reclaim paths that may attempt eviction.
+	 */
+	if (node_is_private(pgdat->node_id))
+		return;
+
 	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
 		memset(&sc->nr, 0, sizeof(sc->nr));
 		lru_gen_shrink_node(pgdat, sc);
-- 
2.53.0-Meta

