Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59642F29
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 14:34:32 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso6184568pjm.4
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 06:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yqTwEL7kOTcKChIBcjkLKs2qIde8K14LqGVT2DBRTU0=;
        b=QfoqDLtleFoLTKKXN2gEfiVcozG97ChIFEO+Dxb9kfB8mws46ckDiFZ0spHu+3Ckwi
         KQZam58ZAHqgcYKidzpFN3iPnYbSqMyyJG9+H9OJMKcVySUshYFShTfVPilrnyzKLSYH
         /hwxBMauDgvjBwXaDv+t8Aigdr4S4kh8m6NusA04i61YrBQTjYU+aXUCrcvJKRfVAtto
         sw938xa5LtXWuBW9vMuJyLDJ7JhQtLB6VO31Lkk4zgYI1K22xsLAs86nIFN1bdsqem9D
         b9A0oRcRgZgOiBmtV/hB8lrUnmP7ugc5phBXv7BZKIExxz7n+Io5ja4QbCqxemwNNnNZ
         LTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yqTwEL7kOTcKChIBcjkLKs2qIde8K14LqGVT2DBRTU0=;
        b=eLntJ4H+bXgLYTiwcXfv2EMqu6oLQ/p8e8LzB8CrDENZuGXBHwA55z9K/BB7Cv74xV
         Md/osZnC54Thc4+puxwEbnXod9UfXSXcYM+YU8UQaSQubRqF7A0qoNuuhEa79UtuiW4c
         W7Yuicln6nIKN7VPLSkyRywEPaHRmLk0W92dqS7h6xjh/VsRaQpkSUayg3TyvCQA62Mf
         t/u8xCGNfL481g8gmwuFohYsipm1ATA6hGGEK0jFcPg2qDIF/1fT4wRsykjTmpIFYRB5
         GVy8W0VeWzmcUPS5BrZofa1bcQEqwumLRUuvvufp96vkVmaemtJntZUJGLRgKmYAxBNe
         aF0w==
X-Gm-Message-State: AOAM531ptmLMz/xsP/xZ30vsmHMP1AOFEBmbeDc66enbJNuZFy2T6qW9
	NfF8+t8x+0auESbDzPT/jDjyHQ==
X-Google-Smtp-Source: ABdhPJzSJUsu2k5lK4qLz9mFNP97HsqVWca02fgKwu6JP8Fe8B9Slwu6HkVpi8yiT/kqkiwV52Yk5Q==
X-Received: by 2002:a17:90a:cc07:: with SMTP id b7mr8389698pju.43.1643812472560;
        Wed, 02 Feb 2022 06:34:32 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id s9sm29079268pgm.76.2022.02.02.06.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 06:34:32 -0800 (PST)
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
Subject: [PATCH v2 2/6] dax: fix cache flush on PMD-mapped pages
Date: Wed,  2 Feb 2022 22:33:03 +0800
Message-Id: <20220202143307.96282-3-songmuchun@bytedance.com>
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
Replace it with flush_cache_range() to fix this issue.

Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 88be1c02a151..e031e4b6c13c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -857,7 +857,8 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
 				goto unlock_pmd;
 
-			flush_cache_page(vma, address, pfn);
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			pmd = pmdp_invalidate(vma, address, pmdp);
 			pmd = pmd_wrprotect(pmd);
 			pmd = pmd_mkclean(pmd);
-- 
2.11.0

