Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BC54F55BC
	for <nvdimm@lists.linux.dev>; Fri,  4 Sep 2026 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535694; cv=none; b=O0FtGyPLMwqT180zGDbQDKWBZZqNW/vExm6Fe6ZP1ngf8PjzSzjGx934/lsYUttC3iMPE6xwGjyRvIJcT/1ti/flaxujH3OKu+1xCGoK6wfnVM4vjO/NvNoq8dVqWdAc/sfiZ+4alK8DnB6/I36ajNV6GyB2Z5QEzp/yNNM8U2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535694; c=relaxed/simple;
	bh=vyXmZDCwjau2jk1K8j4vYUfZu4OC5buvBp5C3LE071U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILbEZRlFPLALMnNYEgCGpCe0xnNxZpf+3JmqkHIJegTgqsBW+NFX9TTcHDugxO40r+JM7O/eOWUl9YnhXOIfOF8k5dmPTJyv6V63tGIcfULW+NijmrNtqAdLw1OPujIbDagI5zUTuh3Wb8Rc3CMfuWCaBsQKEAh09k++KeUa6Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tu5VGnDV; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tu5VGnDV"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vyXmZDCwjau2jk1K8j4vYUfZu4OC5buvBp5C3LE071U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788535690; v=1; x=1789140490;
 b=tu5VGnDVQzFBPBeLZ67fMxlpYqId5qe3jV8tJ9iEuS+NIvQA4V3S7MiTJjrlJc2K9vDhFw78
 8HjIGTWxSAjVMMZHVz18uUwWTn7+NO8k6ATx+vgOcYnQ4FEFvwVFeiGtnK2rZssVLGzfSih2vHn
 4rwDniKvZMksNyd+e6Km1n54=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c0f3e87759aec0cb;
	Fri, 04 Sep 2026 15:28:10 +0000
X-Mizu-Trace-ID: c0f3e87759aec0cb
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
Subject: [PATCH 1/2] fs/dax: Remove unused dax_layout_busy_page()
Date: Fri,  4 Sep 2026 23:27:48 +0800
Message-ID: <20260904152749.84493-2-kaitao.cheng@linux.dev>
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

dax_layout_busy_page() used to let filesystems scan an entire DAX
mapping for pinned pages. All callers now use dax_break_layout(),
which also handles waiting for busy pages and deleting DAX mapping
entries once the range becomes idle.

The remaining function is only a wrapper around
dax_layout_busy_page_range() and has no in-tree users. Remove it
together with its declaration, !CONFIG_FS_DAX stub, and exported
symbol.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 fs/dax.c            | 6 ------
 include/linux/dax.h | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index dad4efea7964..1e19e4a354ce 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -841,12 +841,6 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
 
-struct page *dax_layout_busy_page(struct address_space *mapping)
-{
-	return dax_layout_busy_page_range(mapping, 0, LLONG_MAX);
-}
-EXPORT_SYMBOL_GPL(dax_layout_busy_page);
-
 static int __dax_invalidate_entry(struct address_space *mapping,
 				  pgoff_t index, bool trunc)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index fe6c3ded1b50..05e59e45a1c2 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -155,7 +155,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
 int dax_folio_reset_order(struct folio *folio);
 
-struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
 dax_entry_t dax_lock_folio(struct folio *folio);
 void dax_unlock_folio(struct folio *folio, dax_entry_t cookie);
@@ -173,11 +172,6 @@ static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,
 {
 	return -EOPNOTSUPP;
 }
-static inline struct page *dax_layout_busy_page(struct address_space *mapping)
-{
-	return NULL;
-}
-
 static inline struct page *dax_layout_busy_page_range(struct address_space *mapping, pgoff_t start, pgoff_t nr_pages)
 {
 	return NULL;
-- 
2.50.1 (Apple Git-155)

