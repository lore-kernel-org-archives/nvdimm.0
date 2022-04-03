Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1189C1FBD
	for <nvdimm@lists.linux.dev>; Sun,  3 Apr 2022 05:41:17 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id z16so6142275pfh.3
        for <nvdimm@lists.linux.dev>; Sat, 02 Apr 2022 22:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xp6qCxwTnE0C1FxChih956SdBv3W6L+dQXT7C0J3Dts=;
        b=2ABETFqdsMhesFHDHhEUmJyVsW7RZ5Js5waMUtu7AgAnw7NQJE9KF6VPHqmSdvMej+
         2OJl2yUuMkKlsJntBOzaVw6h3FbkNTEtAUb7NgwTf/4KS8Unjkp0AkIDihqOM4AQy0E9
         b0D1cmPFHN/ZT3IC0qJD0E+WI024G3g/JHnvtyGmSNaBRaaNOf62Cjctp4an9NRZ9b6z
         vPzjHQqLtX8FSAzX5BdZbUx0QSmSsl5esFSgUJJfPkwZ9OBGd+Ki5S02q7b/3idXLY9Q
         v3WBGcPbhY5PtafSU0qiWng1lLj8uoWDT3H3wd0bwa2IQYzXzlExfT+r6ROb2/HljUOo
         gBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xp6qCxwTnE0C1FxChih956SdBv3W6L+dQXT7C0J3Dts=;
        b=AVJu+wF/KOix6bXUYJHk/acc/S0XPj7wOWfChdYpPDJcTmS1nCbnNg8W9phbI1n4uW
         Jam8HLSbJzZ5+m01WCvGfGTS6oXk2wtwvAX77X23TkKpyRBXGnLgBHnxOg/J5bxi7OHe
         W/w0vAANUsjehCmERCvZ0ZPhgH3a5ChwYS9LACQ9MMWSRyi80UiFD89C6MsMMibb6hVA
         /jGlngT4As4FGUnIykNRe0xbMfoTTS7GT8r+cKFmYa9AURbt+UozCLWCTViIdAkekE88
         OAp8JcHgCpr2vctH31do2BJlA3BthCQkJIme/rFwhz3WzJ5Ub1ogPFyyA/iQvWT84wiY
         lgiQ==
X-Gm-Message-State: AOAM533gXRGN+vxvCSnOBWKe6sldSsBehtMz+YZdAPfHRdO+hf8mX02Z
	zrjjpSmkHWux1H96HjHTVzmmOA==
X-Google-Smtp-Source: ABdhPJyZBSv2yEKXE7ELYRPowq8GlcSVl+mBvyh+Dr/+2j3dfmhbMmgifEOf+lzxBO7utJytI2ZQWA==
X-Received: by 2002:a05:6a00:b95:b0:4fa:ec15:7eb7 with SMTP id g21-20020a056a000b9500b004faec157eb7mr18416062pfj.74.1648964477478;
        Sat, 02 Apr 2022 22:41:17 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm8262479pfx.34.2022.04.02.22.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 22:41:17 -0700 (PDT)
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
Subject: [PATCH v7 1/6] mm: rmap: fix cache flush on THP pages
Date: Sun,  3 Apr 2022 13:39:52 +0800
Message-Id: <20220403053957.10770-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220403053957.10770-1-songmuchun@bytedance.com>
References: <20220403053957.10770-1-songmuchun@bytedance.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

