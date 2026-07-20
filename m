Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2893B2FCE
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576104; cv=none; b=cT+y9HQ3/Y5d4Zx/MPWn6OMG0lWkjcgqys+CxwdcCShQx4TtgVMd2c3egcVs+0YgHywa5nwcLeLFeZLXT4YxSTXTrJO4m0I8iN+H3Qb9CRgMypUTBHXd6d9+H35+hJW8xnGyRH9As73503d4ZqVCI8zFMQg1EoTeiVguwNddB9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576104; c=relaxed/simple;
	bh=xKT776XlTabqIrpZUU7blZWBtbRPmP402l67UFe57bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srTuJfS59bqX/NQcSvxsAulasDx2x8T8pyhXMN4sSZ0CYH7xcs3g+Xc+2B5OaLH1xBO5suuJSczsp6aZnqvAo/LlZ3xSkpz/sm7j6K2ifG5B9qoloPA26zceXocULdbMBuX07DBGeX5OS5w3aibeQtvfmijFhO7voXT8CTleuzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=tFL1COFl; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="tFL1COFl"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e53581361so813164185a.1
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576099; x=1785180899; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nhj7NM8i+En2OSlvQTOlJiWxfz3FRJxBEkctJdapuZ0=;
        b=tFL1COFl180Mz2HM58+nxes53BdT7sf4YFRDo8V9uf518S0z3k8hV0ZKEHvM/uOeXa
         8S+kB1irJqRz7psp+4dL902jGhPlE1x/ZG/oz53GBZQ41hxST8/xslbpjfnkmRqpcvi6
         rhuW6xHZL7GIFHGsACLag1C1x1KCTR6ey9nM28Q3NF/9nNXnmT+fhzhVd42AnHxkprg0
         osduW2JqgM6LGDcOCBXhEWlzgg1xG6wea2hEB3PufqmHZ7OFYTGpaYiDn0svXZMD0836
         hfMlDOZMdGQo+nPi3u2xVO+mEqhe1kG6wCf+lRC67JuzgpaxKmc1BQ0iuTk2GWDu12pL
         PvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576099; x=1785180899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nhj7NM8i+En2OSlvQTOlJiWxfz3FRJxBEkctJdapuZ0=;
        b=s0+4c9DbmQgeUO/1fiAL1SoQjtnWWNKYLHeEEnn+6Rcmc7Yv0TFI9X+a3Y88Kk9rQ9
         7Ee5dOk3AvajaIqvHlA7i8A1i4aGamlLBmBsTchIgjfCEuvaDl+lXaCflGlLsbu7eI7A
         qIg5XzQYBLlDahJUR2hsDKp1BecY3lrREA+8CjoRLQwCZBT/RtxD0hzKNDwsq+rvCdVe
         zfkdNCiCaw/lCCPyceyIXk6dfX6eUlHT856a30wTO7Txt6ISrZjgIb6xwcsdqpWBnekf
         ScwntkoTjp6/S32VuC+bSyoCNybsqyKwlEJvLB5PVntpiFxAaJCf9Zngd2vl0lK+aQar
         Vylg==
X-Forwarded-Encrypted: i=1; AHgh+RqMw/g2+GxFk+9zcglMNgVoYJso3sh+vwmk+psPBfPQpsAZQos2IKAi8NDYaL4Tx0JlNSmG29A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+xn8bxqllRsJT5xGpp5aabvCopg0oiFHA4rKi/paZjEhT79VG
	nfgrFWy6dRKMxH7LafrFO2z1VuYk7kqXsDli+qR5nzqMWH2ECUxXXGdFOU+2kVkA5HQ=
X-Gm-Gg: AfdE7cnuHVNT+7wAuEGo15H5gyNsDIch46y8IJ2LPaJxOi5fyNMVwA3webu/decTO+a
	/xPrhgyS78shC/Vh9UNWJ5CJA/Cj5zQhpla5jsmN98XreFo4r4/O1aIqVhlJWVp8pjEPFIiY+L7
	5CJLOu/DUZZodZpimoM/mI6PjiIUzOTZhT4aArj3bGUUHZ3N5KBr0dwsNskftwEBWldnIpZ8pPg
	in1+OZHbcP0kVpHkoM67cTTsUju7aJ4HUaZ/tAbeCiGd6YrwSrHlB4xQ0er3x1FHT65dAq/RK99
	GEiozEZE99zyLZZk5AqVuBs5RqMmXKcDbU+5Wl0vQFyl4B0R/sTMt9sSnN/DbqZ+kK42SFouPqB
	T3By6Z8YbksKrjOJxGz9aVgNN3Bp69szEYOY3udWLFmK3ljpNZGz2ZBALFbu5ES8+6rAklYNv5A
	M2giP3DxjRIgE9Y8UAJ8/ExUv8J+n98nOUtHhQGTGKKsaImUUKLut2sPO4CqeLunE=
X-Received: by 2002:a05:620a:4551:b0:92e:be48:80c with SMTP id af79cd13be357-930b41c232dmr1527846385a.57.1784576099368;
        Mon, 20 Jul 2026 12:34:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:59 -0700 (PDT)
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
Subject: [PATCH v5 08/36] mm/mempolicy: skip private node folios when queueing for migration
Date: Mon, 20 Jul 2026 15:34:02 -0400
Message-ID: <20260720193431.3841992-9-gourry@gourry.net>
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

Private nodes are already kept out of policy nodemasks (only N_MEMORY
nodes are allowed), but an mbind(MPOL_MF_MOVE) walk can still encounter a
private-node folio in the range.  Skip such folios so mempolicy-driven
migration never moves private-node memory.

We already do this for ZONE_DEVICE folios - use the same filter points
for ZONE_DEVICE (with an additional point for large pages).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5720f7f54d942..8e8763f6e5f5b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -111,6 +111,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/printk.h>
 #include <linux/leafops.h>
+#include <linux/node_private.h>
 #include <linux/gcd.h>
 
 #include <asm/tlbflush.h>
@@ -668,6 +669,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 	}
 	if (!queue_folio_required(folio, qp))
 		return;
+	if (folio_is_private_node(folio))
+		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma) ||
 	    !migrate_folio_add(folio, qp->pagelist, qp->flags))
@@ -722,7 +725,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 		}
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || folio_is_private_managed(folio))
 			continue;
 		if (folio_test_large(folio) && max_nr != 1)
 			nr = folio_pte_batch(folio, pte, ptent, max_nr);
@@ -797,6 +800,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 	folio = pfn_folio(pte_pfn(ptep));
 	if (!queue_folio_required(folio, qp))
 		goto unlock;
+	if (folio_is_private_node(folio))
+		goto unlock;
 	if (!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma)) {
 		qp->nr_failed++;
-- 
2.53.0-Meta

