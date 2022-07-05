Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1250917E2
	for <nvdimm@lists.linux.dev>; Tue,  5 Jul 2022 12:35:42 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id fz10so5933722pjb.2
        for <nvdimm@lists.linux.dev>; Tue, 05 Jul 2022 05:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P8dLNO3XSVpB5X1jg4KVwtpXwWMCvyBucMCZ4xYCRcE=;
        b=YvIK0lrmI2mmJifbiC13P9zSa4jhgWrCSf8HfCcWHJeRvq/2xkb1o4YgiN5i3z09tp
         9gjXqgJccr/RTi1IiNDqr6D8MVorTHbLO1jtVDyuYjTeI3kwWWXhiQQ2TrQXZp4R3Fyc
         gAg8b1Xktofgk5Kju+be+WvUsysFwFRsMwUspJoICZi2ITNn1orttaMB7Hu9XGSP2Wmp
         Wx5L3SOcTvfXsH1MEAI4qEFT/TzHEnmLTkz25L9J0/PjOwfRvTbJ2875wc/+WzeDbrGw
         QrdhzE9iE0rO0PUQ94DCPnJeTPvzYHio319Xu9Fr3vu3PcLHckf80vLg/ZO9PtWpsvvW
         eX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P8dLNO3XSVpB5X1jg4KVwtpXwWMCvyBucMCZ4xYCRcE=;
        b=8CUKdulEAOwrv2zVBkUZJP85R4/B+CZlaLL8vBUCGZa8qNJDtNoo45U9U0a934HIyx
         iCP/8MQT+JCRgfFecQoIzeiJBssBoq87SWA5OAd78sApbsoq0sSLUsWxZByjDUvP0DlB
         E9K+gjFlEmYnpJKS0HwjM3M/L9amy85wYeIEFQdXgn9/ErLTJhtzc4HMuLJlpQ7Bq/0e
         pOJA+kSCjbd7Ds3raHd3nOBQbr9bWutpb+OTuvaGKhXXiwhNl8TyT4U9OBjTEfhY8ySd
         BdIEX9Rn5N/KdGMl2pNBGgDmEIHLEq0iZds2ihA45HS+NKlyUTNhxPPJ0bxRbcwIuWug
         tQ6g==
X-Gm-Message-State: AJIora94CfKnvWm7fKmsi+W5DWfoEkDTSn+lPK/GfPrfozLpsTyBO4rd
	bKWCBEsMo6TSdpfkl4MiK3cTSQ==
X-Google-Smtp-Source: AGRyM1tGmro/IOsy0F1j/gU/vPekilw0RyPAVRgsAlBkibEGJXezSBOKSTDCC9D3AROIwcb5MCGdfQ==
X-Received: by 2002:a17:902:a601:b0:16a:6632:7f14 with SMTP id u1-20020a170902a60100b0016a66327f14mr42460871plq.2.1657024542238;
        Tue, 05 Jul 2022 05:35:42 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id k6-20020a63ba06000000b0041278f0025esm1154191pgf.12.2022.07.05.05.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 05:35:41 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: akpm@linux-foundation.org,
	willy@infradead.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	william.kucharski@oracle.com,
	dan.j.williams@intel.com,
	jack@suse.cz
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: fix missing wake-up event for FSDAX pages
Date: Tue,  5 Jul 2022 20:35:32 +0800
Message-Id: <20220705123532.283-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
1, then the page is freed.  The FSDAX pages can be pinned through GUP,
then they will be unpinned via unpin_user_page() using a folio variant
to put the page, however, folio variants did not consider this special
case, the result will be to miss a wakeup event (like the user of
__fuse_dax_break_layouts()).  Since FSDAX pages are only possible get
by GUP users, so fix GUP instead of folio_put() to lower overhead.

Fixes: d8ddc099c6b3 ("mm/gup: Add gup_put_folio()")
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
---
v2:
 - Fix GUP instead of folio_put() suggested by Matthew.

 include/linux/mm.h | 14 +++++++++-----
 mm/gup.c           |  6 ++++--
 mm/memremap.c      |  6 +++---
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 517f9deba56f..b324c9fa2940 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1157,23 +1157,27 @@ static inline bool is_zone_movable_page(const struct page *page)
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-bool __put_devmap_managed_page(struct page *page);
-static inline bool put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page_refs(struct page *page, int refs);
+static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	return __put_devmap_managed_page(page);
+	return __put_devmap_managed_page_refs(page, refs);
 }
-
 #else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-static inline bool put_devmap_managed_page(struct page *page)
+static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	return false;
 }
 #endif /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
 
+static inline bool put_devmap_managed_page(struct page *page)
+{
+	return put_devmap_managed_page_refs(page, 1);
+}
+
 /* 127: arbitrary random number, small enough to assemble well */
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
diff --git a/mm/gup.c b/mm/gup.c
index 4e1999402e71..965ba755023f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -87,7 +87,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	 * belongs to this folio.
 	 */
 	if (unlikely(page_folio(page) != folio)) {
-		folio_put_refs(folio, refs);
+		if (!put_devmap_managed_page_refs(&folio->page, refs))
+			folio_put_refs(folio, refs);
 		goto retry;
 	}
 
@@ -176,7 +177,8 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	folio_put_refs(folio, refs);
+	if (!put_devmap_managed_page_refs(&folio->page, refs))
+		folio_put_refs(folio, refs);
 }
 
 /**
diff --git a/mm/memremap.c b/mm/memremap.c
index f0955785150f..58b20c3c300b 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -509,7 +509,7 @@ void free_zone_device_page(struct page *page)
 }
 
 #ifdef CONFIG_FS_DAX
-bool __put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
@@ -519,9 +519,9 @@ bool __put_devmap_managed_page(struct page *page)
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (page_ref_dec_return(page) == 1)
+	if (page_ref_sub_return(page, refs) == 1)
 		wake_up_var(&page->_refcount);
 	return true;
 }
-EXPORT_SYMBOL(__put_devmap_managed_page);
+EXPORT_SYMBOL(__put_devmap_managed_page_refs);
 #endif /* CONFIG_FS_DAX */
-- 
2.11.0

