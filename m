Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E6D4F55C2
	for <nvdimm@lists.linux.dev>; Fri,  4 Sep 2026 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535701; cv=none; b=TsIO7VIks4iiMmqy6QtAZWITzCM9P51G+NpGdffro4uvIZfWfdYHb/9Ti9vepn+TpF/N15C/xGv/rJXGt7Rw3M4Q2OBSPBJ3cGr0w1UCz04AYOpALHaV3nVlaCc/g3itdLCYjXUWyxZHZ2uRuk4epPAawkoIE9MYF7rLHvMxk6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535701; c=relaxed/simple;
	bh=svWZ9zpx2LBS4ke8ImROCzfa4vg56SD715HVVMsnjko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npUlhKKu2xlZlCsp6Ugkm1k5x9Ezhz8gsEIaCW5jnG3n19rEs32gxX06jJ3tTxmq1Nkjzc1nGbkceXFKjypu4pTDHDQko30SutGIWFQBtte1k0zx9DvyYPFBTthfihHsUU7IA1Y+iUsc404bvj/jagRcYLR6Xsec45+rPQbVEAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=reiFS/PK; arc=none smtp.client-ip=91.218.175.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="reiFS/PK"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=svWZ9zpx2LBS4ke8ImROCzfa4vg56SD715HVVMsnjko=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788535697; v=1; x=1789140497;
 b=reiFS/PKJLtEa8BcNqbi6xLO+tw1KajZgWqMk3wF90MaehHg81e7tQ/dfWbo7M31s21/Gy9I
 vPsS3j/HJQXlBctYC+tYZqkZidKrS7qBYBjS72cDmWiBwXuFTpCbdF2n3S22MyCcRLxb5pjK00n
 V+s8JtyyEydeMPK5HhCv8hIA=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 30bf5abb2794981b;
	Fri, 04 Sep 2026 15:28:17 +0000
X-Mizu-Trace-ID: 30bf5abb2794981b
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 2/2] fs/dax: Make dax_layout_busy_page_range() static
Date: Fri,  4 Sep 2026 23:27:49 +0800
Message-ID: <20260904152749.84493-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260904152749.84493-1-kaitao.cheng@linux.dev>
References: <20260904152749.84493-1-kaitao.cheng@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

dax_layout_busy_page_range() no longer has callers outside fs/dax.c.
Keeping the range helper exported unnecessarily exposes a low-level
implementation detail.

Make the helper static and remove its export and header definitions.

Also fix the stale dax_layout_busy_page_range() comment to match the
implementation.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 fs/dax.c            | 18 ++++++++----------
 include/linux/dax.h |  6 ------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1e19e4a354ce..c6ad9533aa54 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -770,24 +770,23 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 /**
  * dax_layout_busy_page_range - find first pinned page in @mapping
- * @mapping: address space to scan for a page with ref count > 1
+ * @mapping: address space to scan for a pinned page
  * @start: Starting offset. Page containing 'start' is included.
  * @end: End offset. Page containing 'end' is included. If 'end' is LLONG_MAX,
  *       pages from 'start' till the end of file are included.
  *
- * DAX requires ZONE_DEVICE mapped pages. These pages are never
- * 'onlined' to the page allocator so they are considered idle when
- * page->count == 1. A filesystem uses this interface to determine if
- * any page in the mapping is busy, i.e. for DMA, or other
- * get_user_pages() usages.
+ * DAX requires ZONE_DEVICE mapped pages. A page is considered busy when
+ * folio_ref_count(folio) exceeds folio_mapcount(folio). This helper is
+ * used to determine if any page in the mapping is busy, i.e. for DMA,
+ * or other get_user_pages() usages.
  *
  * It is expected that the filesystem is holding locks to block the
  * establishment of new mappings in this address_space. I.e. it expects
- * to be able to run unmap_mapping_range() and subsequently not race
+ * to be able to run unmap_mapping_pages() and subsequently not race
  * mapping_mapped() becoming true.
  */
-struct page *dax_layout_busy_page_range(struct address_space *mapping,
-					loff_t start, loff_t end)
+static struct page *dax_layout_busy_page_range(struct address_space *mapping,
+					       loff_t start, loff_t end)
 {
 	void *entry;
 	unsigned int scanned = 0;
@@ -839,7 +838,6 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
 	xas_unlock_irq(&xas);
 	return page;
 }
-EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
 
 static int __dax_invalidate_entry(struct address_space *mapping,
 				  pgoff_t index, bool trunc)
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 05e59e45a1c2..f2d47975d905 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -155,7 +155,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
 int dax_folio_reset_order(struct folio *folio);
 
-struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
 dax_entry_t dax_lock_folio(struct folio *folio);
 void dax_unlock_folio(struct folio *folio, dax_entry_t cookie);
 dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
@@ -172,11 +171,6 @@ static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,
 {
 	return -EOPNOTSUPP;
 }
-static inline struct page *dax_layout_busy_page_range(struct address_space *mapping, pgoff_t start, pgoff_t nr_pages)
-{
-	return NULL;
-}
-
 static inline int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc)
 {
-- 
2.50.1 (Apple Git-155)

