Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB46C2565
	for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 13:49:49 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id b13so14079495pfv.0
        for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 06:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qCp2b48ULThIjDs7kZ69Cjh0BLYiJwB01qLpS62xP+w=;
        b=Jar+sTN8J6FAXOFb7BXYhLAXyRgigam+L7qPx28Z5edW3JyP3P6JHWeb2bLTRguazc
         SjpC/ypJCbFX/ajZVHDSDqni5U8ITqmnuOup25CPNWU54sPtLLF6LiZIWWYzvpzYHTgC
         k9wnNqKqGo/1GzqBqOc6VqRLxftOHupN+lmJwjQKTo0yrNNVI19TB+ENyA+aJNvEzEvC
         4kCQFtgdIRbEb7xMywi2TakGdJ5HnWvuECSJvLUuNL6T7xJIPM+veTI0gmlSGWT2iso8
         VdcBqyyuLihOgQjHs+9PwRAccmVb8/VV6SQGLGwzIL7cy5hpOdt9uiOByhluEpyB2CoO
         Catg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qCp2b48ULThIjDs7kZ69Cjh0BLYiJwB01qLpS62xP+w=;
        b=Nu3W+WY8f9H9kQLZwqyN5X9XAoFtJJxVGAoLrOOxgSYQCymP76Om6zUrykCzT+CQhE
         54g5ZLyxgq40k5LmaZMmvRtRV0To+DTJa4xNWWTxvL6QsNaip3Oc5pBgk6+MJvcH4h3g
         owKAhipP4Z63CsPYDZ0rwSkmV6suU4hsmwAQVQJB6QY0408d22l1bp/ZVAYfRd7phecY
         Sbkv1oHxQaIiGkFJ100G3bUGa72cps4RG7Dy8/9910USEvzxFcSnRHATMiq+ykA7OjE0
         qypGyKs8OOdiSvlw5AqiR0qDJVGcZ6FkFJkEv/gWVx4PMT1b3FhzS9Xp/DbnH5iHTMxm
         tqcQ==
X-Gm-Message-State: AOAM532lZuhrneiGfysg7LmM73La2Pbjp5usRhUPgmEwIelkhzsgvVK5
	SZNBgqi9PTYuTu6+v4lxUEwnvQ==
X-Google-Smtp-Source: ABdhPJwIyVhxdz8+cNA2oBRKlLOaDoMyukZC+uWljQRRd5G8K+hiEQjPnAjv0Umpi70bDPH8wlP4Bw==
X-Received: by 2002:a63:5b48:0:b0:381:10:43e5 with SMTP id l8-20020a635b48000000b00381001043e5mr2093565pgm.544.1648561789075;
        Tue, 29 Mar 2022 06:49:49 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id o14-20020a056a0015ce00b004fab49cd65csm20911293pfu.205.2022.03.29.06.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:49:48 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 2/6] dax: fix cache flush on PMD-mapped pages
Date: Tue, 29 Mar 2022 21:48:49 +0800
Message-Id: <20220329134853.68403-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220329134853.68403-1-songmuchun@bytedance.com>
References: <20220329134853.68403-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page.
Replace it with flush_cache_range() to fix this issue.  This is just a
documentation issue with the respect to properly documenting the expected
usage of cache flushing before modifying the pmd.  However, in practice
this is not a problem due to the fact that DAX is not available on
architectures with virtually indexed caches per:

  commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 67a08a32fccb..a372304c9695 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -845,7 +845,8 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
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

