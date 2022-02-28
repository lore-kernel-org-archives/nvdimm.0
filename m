Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E832512D
	for <nvdimm@lists.linux.dev>; Mon, 28 Feb 2022 06:36:04 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id bx5so10251264pjb.3
        for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 22:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dOhvmpBLieRVF+NKQPb4pdavGDEjnXCIzLlMLWWpOKA=;
        b=GLedueKeHKRO2HkdYcdfxC2EEpOAVOh+ibI1MzEf9M9KEnYukSMBeJqZ6sb5fecmh9
         R8NyktTgdG0x5Z8DW9eNTXhARk8wE61mQcydrkh0HLuj7P7SeO0WwM/sBC8K98q6OP8p
         IERc1o2vniYjYyIE4NkC+baW8ic1VU7rpHUmGU5X0QD3luAibl2XNs9c4D80ydzqjHWn
         CNW9quMGgyhAf8u7OKUuHd1KuzjLgHeLvTZVSUX8Gy0+kfVcWJG0BWoIhvOQtOdv6srh
         0mxLOeOYimflwRkRO1fDCadVjMJE3S4xQwk2h0AlhCmAyM7v6XyS7tsYSsMRtXgj2QsO
         WnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOhvmpBLieRVF+NKQPb4pdavGDEjnXCIzLlMLWWpOKA=;
        b=etnrtFZd8B9KvethV0pZBjkujOCtROSJIYM6wnE7AND9aezKURRuu7Tf8EX45zeI31
         HY+JL1iG1GAlqMcaPn516BBJxEC0+uXU36B2IlGHFeOC7krO2xFKio+Pvi9neOsrBRaN
         mmoIwPv5nvSUCckvlW/CCb78vOhAlF/8EQEnAjpFjeiPsQGECXXGIg+0L/Oi8fpy1ocq
         0gfPhw2D68cA6HDoSgusmYROF6rSOpM21wHqvp6j9JwO+cdIWXC9n8Fv38LPFA+BQ5pk
         0fswu+XJV+LHdS+6mxdcSYrZBl1MRT1RLRV3AHa5slSPPDGHj7fBmI3lDxPhKZ7ZmqDi
         GUrw==
X-Gm-Message-State: AOAM532cQttWvp/zuk1iH965kxiawnysA2N3QnMVWU7LEISEtr+oTXdj
	1ILN9kdHjnAgmXe4zL0zJXpghA==
X-Google-Smtp-Source: ABdhPJwToVZOj3y/qJS6gPvMQ/JUzaojXn+cxmZ3XptNaVSIvdrv3PQbOne/2kTWhsRv6czal7dTHw==
X-Received: by 2002:a17:902:d882:b0:14f:efee:6de0 with SMTP id b2-20020a170902d88200b0014fefee6de0mr19598400plz.116.1646030163867;
        Sun, 27 Feb 2022 22:36:03 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7960d000000b004f13804c100sm11126472pfg.165.2022.02.27.22.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 22:36:03 -0800 (PST)
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
Subject: [PATCH v3 1/6] mm: rmap: fix cache flush on THP pages
Date: Mon, 28 Feb 2022 14:35:31 +0800
Message-Id: <20220228063536.24911-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220228063536.24911-1-songmuchun@bytedance.com>
References: <20220228063536.24911-1-songmuchun@bytedance.com>
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

