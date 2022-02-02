Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C8E2F29
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 14:34:25 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id j16so18443420plx.4
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 06:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpzrZ3UL1NNnyKoM6H+wPQyBpC1NKCVMLCNYU70r2B0=;
        b=FP6uo0J+XGUKU/YjQtKSKRs4FCJsisKC/hx8Y5wk6tYiUm9x62TdWeN3eu9+XCbJ1T
         TbJ16jy2DDntW86mp/sgYUpOOoGM5nlDBwUdy22h9MAmHMjRI0elhETTyVqpGzEgkHLZ
         Amj6MaV9Qz8yIzmzZqDG+kqBaTuwIfrJgFh+n6YxIPB2UkmIVsx2Rh9lrv9c4GRca5au
         mia8XrC7PMNdb8X6VPlKHtUztzZlvGKzqqXwjAXp+wfogI4Bs/9xJRbFy6cgBidDMhNw
         SSMl2asEvsdP1oodO1jj7EY/xuSnAsGCMdXd7EfYxgPrjWGi6QUaCnO4/rnadNS6lvow
         LU7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpzrZ3UL1NNnyKoM6H+wPQyBpC1NKCVMLCNYU70r2B0=;
        b=La1yblzJW9JIzgFr7mC7Eh+v/Z0gv11FQuCm+66BPb7+k888EVoHvNxaVxm9HK7qrn
         oCFogjMEzUxWkJwoEhsapXBwqAujrrXr1GH7DXMDzrlOLzcSqk3j3lwVJBvrwAot+T2R
         xlyMD92x7t8u86kDKKq7SZlVAgxw9+8IgVFlMatKOY+Tx66bw1OZ/sEN7xD7qW/Ak9zL
         IJcrlTK2r136ufCBxMHCydAPQquVf2FUdA5RR2H3apMcAhOK6v+mLZ/Ih1ZR/URPSB+N
         BSq8y4suQbOm9tq2le82yN1r3TvtriIwZf8Ya7qn92bNT9EkoYlOpnDkAzJRfOqncv1z
         Bq5w==
X-Gm-Message-State: AOAM531qV3cPB4IPij0RCdwE9Qs8dc7qIZsGLJ5J9TQzKRsvQYhq3Ta3
	KJg+KnHI80owUYt2yOeOa1Ue2Q==
X-Google-Smtp-Source: ABdhPJx1R74lXZlM/Cxg6cfKwxH1FD4NPDRYz154Mh+OGethIUvLeH+xKUNAPo6FkkGG3/cUrVF6pQ==
X-Received: by 2002:a17:902:c412:: with SMTP id k18mr30904459plk.142.1643812465457;
        Wed, 02 Feb 2022 06:34:25 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id s9sm29079268pgm.76.2022.02.02.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 06:34:25 -0800 (PST)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 1/6] mm: rmap: fix cache flush on THP pages
Date: Wed,  2 Feb 2022 22:33:02 +0800
Message-Id: <20220202143307.96282-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220202143307.96282-1-songmuchun@bytedance.com>
References: <20220202143307.96282-1-songmuchun@bytedance.com>
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
index b0fd9dc19eba..0ba12dc9fae3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -974,7 +974,8 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
 				continue;
 
-			flush_cache_page(vma, address, page_to_pfn(page));
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
-- 
2.11.0

