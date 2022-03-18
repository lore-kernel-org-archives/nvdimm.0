Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55044350
	for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 07:47:27 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id o68-20020a17090a0a4a00b001c686a48263so2477148pjo.1
        for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 00:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bccyIuXNgVgWTsjz+RBd2YEFs26+BYj7DbFQevsUcHE=;
        b=ktwgzcqdcBQJ1VBS2U8dc8HWvMuXzX7CD5ssYWniZs0fpuGzRFxB1aStyFCE16xcf6
         bcRfs6g0fk+CWkXNzt6qW0s/4Q23/4jyHcZIq72vUBXRSN4mI6my0+E3RHhk6p16z+qP
         1KpeJB4aEPeXiEEgTskBN+kSgEOBSnQdHPesRKu6XQOAcIwTpDHh9GMkta7O1zDayXsm
         xqK3CcRPDjTvqUC3Ubi+eoVjJYhQrYRRzqjhy/v14B2DJRPNWrQjrLwzgIm/1O6bL6Um
         zSRSXHAWTNtfm08hQ62lXI7xgcKxzgxlar1CtPWd3dyB5eCwhROhwdwPEj4FQIDlG+2i
         1IAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bccyIuXNgVgWTsjz+RBd2YEFs26+BYj7DbFQevsUcHE=;
        b=719NIwrQooTFhhJdEaIdy6s2bHa7Kzfrosp/mfXkbtu7zfOqHWMNudSBSNSFnM3pBB
         NKckbrtJk9S7bYWoRR4Yy97K4/daq83mBfKrzNiwxkZsUM0cLhCbBXCEesnyYRbqd9NB
         OKtQfaj6Kgta7L4PAsKUHd68E1emj/fhePKay9iEdjhvBgupE1/jNvYIM0zWH8NoBOQF
         6IYjus/ReiP/yKeW9Kgz3kaTUTZKZs35LvUPQUVANEn7yIbKFdQT7QybN6lumovl4WCN
         qZd1pWIiOIV5ddkYCIo+L2OcW6iepO4FVNDZkGrIudwHHkfZouunpVhE44SxYfyZveEL
         tbdg==
X-Gm-Message-State: AOAM531Lrq4jZEVpo0doCvJYXS/CUGYwlpIHRDj3QUonLBoK/iwJs+dw
	+GI3mVW1ku2S/yl7NvbJzlZi4A==
X-Google-Smtp-Source: ABdhPJxSaBc1N16M3AnXxYKSnMl0pGq/ZYMWFizlkbiINUdEnODL2hPebHnmfwE4By9faArbEr62/g==
X-Received: by 2002:a17:90b:1bc3:b0:1bf:7461:7838 with SMTP id oa3-20020a17090b1bc300b001bf74617838mr20460132pjb.3.1647589647396;
        Fri, 18 Mar 2022 00:47:27 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f72acd4dadsm8770941pfx.81.2022.03.18.00.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 00:47:27 -0700 (PDT)
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
Subject: [PATCH v5 1/6] mm: rmap: fix cache flush on THP pages
Date: Fri, 18 Mar 2022 15:45:24 +0800
Message-Id: <20220318074529.5261-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220318074529.5261-1-songmuchun@bytedance.com>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

