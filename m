Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBE915A3
	for <nvdimm@lists.linux.dev>; Mon,  4 Jul 2022 08:03:39 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id f85so4447523pfa.3
        for <nvdimm@lists.linux.dev>; Mon, 04 Jul 2022 01:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f9ptmB3XGt31Pq8FBcI5MbA2yBypm+2JGBZYReeKeY8=;
        b=Q9uOsaM9gkzoT9XZMryjeJeF4CqBEe4f122QMdyvIZ9OW46Gs7GZNeNtv9XtFxnCJJ
         fJqRhw9DxUt5HANWF5eFN4LhPRwVHx/FispChp8KKIr9C6S/zq1dZ9KG9pK2KmbLIap8
         uS3E0XSoWiw8KERhpzJsdlrcOYmCZE9mIS152hhNij8jcjSAnsvF0v726taSw+Dj8qt6
         2pGaOxOcxT5Q98YX++uFB1kri4Vpa1ZLOLSXgZR6PtXp0jdOhRjRdMI8kPpt3zrDBKDe
         Vy3YfYkRNeVmXc3niV/aK3gvgb6va+fJXbTRWgmK+kKE3xJvF326absJFF6oeeKY+VSS
         cCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f9ptmB3XGt31Pq8FBcI5MbA2yBypm+2JGBZYReeKeY8=;
        b=fBHzZfj9gVhL9LbLvKxJ+Qvyaz805vKyQ3Gqr1wTgUCjF5fniEpBUl0mEsCVrb4kb1
         LNdyUZQMilzhAWvycaeNJQdFmBsnnRS17PALtciTAV9153dd5ohyUmPqyhqxPDjtdS9l
         lnQSM5w9PzlunhTzw1o8o/oVFh48oBGFUna136lzJvuG0lTWAZ979C8hQuYruTf9LKAZ
         0cnxrX7/Re9ICX5H8jUGAXw54AvBB44HdCxjObJdT5mJU9mPmPpTB2MS8afmUMLk0TLI
         b+gtzikVz9Rpxq45BnMnzuukVIhkUCezV4/I1j9vqjebhozLcapWM39nMrzv6YXglDGi
         /TnA==
X-Gm-Message-State: AJIora+70wrxD8FcYgNz8lj021YgXXJ1PY4YKiOK+xyYGYpx3TQM+YuI
	aR4FXuiQsVK3+6OwJK9svMk+XA==
X-Google-Smtp-Source: AGRyM1svsqJoBsj5Q1XvMG+PjZFAD50xTrVz1dkapvyAi5JFA6rZcft884USVJUlz+5c+8OcIXlzng==
X-Received: by 2002:a65:640e:0:b0:412:2906:bb25 with SMTP id a14-20020a65640e000000b004122906bb25mr6567449pgv.82.1656921818983;
        Mon, 04 Jul 2022 01:03:38 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id s8-20020aa78d48000000b0052089e1b88esm20352965pfe.192.2022.07.04.01.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 01:03:38 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: fix missing wake-up event for FSDAX pages
Date: Mon,  4 Jul 2022 15:40:54 +0800
Message-Id: <20220704074054.32310-1-songmuchun@bytedance.com>
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
__fuse_dax_break_layouts()).

Fixes: d8ddc099c6b3 ("mm/gup: Add gup_put_folio()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 517f9deba56f..32aaa7b06f5a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1223,6 +1223,9 @@ static inline __must_check bool try_get_page(struct page *page)
  */
 static inline void folio_put(struct folio *folio)
 {
+	if (put_devmap_managed_page(&folio->page))
+		return;
+
 	if (folio_put_testzero(folio))
 		__folio_put(folio);
 }
@@ -1243,8 +1246,13 @@ static inline void folio_put(struct folio *folio)
  */
 static inline void folio_put_refs(struct folio *folio, int refs)
 {
-	if (folio_ref_sub_and_test(folio, refs))
-		__folio_put(folio);
+	/*
+	 * For fsdax managed pages we need to catch refcount transition
+	 * from 2 to 1:
+	 */
+	if (refs > 1)
+		folio_ref_sub(folio, refs - 1);
+	folio_put(folio);
 }
 
 void release_pages(struct page **pages, int nr);
@@ -1268,15 +1276,7 @@ static inline void folios_put(struct folio **folios, unsigned int nr)
 
 static inline void put_page(struct page *page)
 {
-	struct folio *folio = page_folio(page);
-
-	/*
-	 * For some devmap managed pages we need to catch refcount transition
-	 * from 2 to 1:
-	 */
-	if (put_devmap_managed_page(&folio->page))
-		return;
-	folio_put(folio);
+	folio_put(page_folio(page));
 }
 
 /*
-- 
2.11.0

