Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F45E2576
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 08:29:13 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id n15so955851plf.4
        for <nvdimm@lists.linux.dev>; Wed, 02 Mar 2022 00:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dOhvmpBLieRVF+NKQPb4pdavGDEjnXCIzLlMLWWpOKA=;
        b=Eqy9IPjbLYYbIstc/J+JZ8WTf619n0h2r8uqKqJ+e6S9Uv+eWqpcul4UbryOb5p+/u
         MaSxXNwLLByowHTqGTJmAsxIcHxjSri8rtIKgWnK7dAxgThGETtK7a3vlVgTsAIso5ar
         jz6a8FaGafuyrVazLBfr548UwTAKf5gemmCc1q/mdgh/EBxhT2Wvwoij1uyTH3KARIXd
         jcdjAZ9+pZL04jxy94vLnK5/fYv2dad6VTjRS0mMTD7NNmpGZHjiGq1JUbhrnPSfBT1F
         4WAiWLScu72rwaHUnfiXZdJgAL3fWS9Qcg6grtWwG0Zxwea9ard9epbbCH3a5Is0pfue
         VlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOhvmpBLieRVF+NKQPb4pdavGDEjnXCIzLlMLWWpOKA=;
        b=fdJ8HbeXYuGv/+Jzl9Maoz9NT2jXFA8XilRWUfArNl8BrxJAsQ9FmkXwBpMXWyHceF
         1tGON+WvWmnRZyRlDTY40zcUR+XTkdPNv2JNhHoWw/guGAkKFzdC/OjFpumbK4ro/tiw
         ZpcllrurQWghMCyLlietXAqHMyiLL38lfQz7/umvdFANUZxHErWe2FbooYnk+Mep+tdO
         s/fWNx9Ebwat9qi7OfKpmtEQdgHFfnQ5BbRc7FmwIlSHGrH/CxZsQvBsFcQxxNSKx7n3
         8WWxJCTWrm5drgcmoylReIFSrinkKnhg1vAx3c05nP7e6803NNlducZbvRQEi8Xh+yX+
         s8MA==
X-Gm-Message-State: AOAM533nzwPVD1ZFP7ypG/LMXJ2WXa0ZjSkErKghKv4F9bk/JSgdaZSU
	Y9z3c/vA/3BedP41scNxSuN2Pg==
X-Google-Smtp-Source: ABdhPJy4/KlcXCarIW7Ivk1JNvCCmPY83Lz2efEDwfG2djMlcALEZNHFvUurWjFDAawaZRfirDGOSw==
X-Received: by 2002:a17:90a:ec09:b0:1bc:d7c2:b2d5 with SMTP id l9-20020a17090aec0900b001bcd7c2b2d5mr25500689pjy.22.1646209752693;
        Wed, 02 Mar 2022 00:29:12 -0800 (PST)
Received: from FVFYT0MHHV2J.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id a20-20020a056a000c9400b004f396b965a9sm20922228pfv.49.2022.03.02.00.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:29:12 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	shy828301@gmail.com,
	rcampbell@nvidia.com,
	hughd@google.com,
	xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com,
	zwisler@kernel.org,
	hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	duanxiongchun@bytedance.com,
	smuchun@gmail.com,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 1/6] mm: rmap: fix cache flush on THP pages
Date: Wed,  2 Mar 2022 16:27:13 +0800
Message-Id: <20220302082718.32268-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220302082718.32268-1-songmuchun@bytedance.com>
References: <20220302082718.32268-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page.
Replace it with flush_cache_range() to fix this issue. At least, no
problems were found due to this. Maybe because the architectures that
have virtual indexed caches is less.

Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
---
 mm/rmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index fc46a3d7b704..723682ddb9e8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -970,7 +970,8 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
 				continue;
 
-			flush_cache_page(vma, address, folio_pfn(folio));
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
-- 
2.11.0

