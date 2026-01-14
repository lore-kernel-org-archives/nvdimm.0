Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64848352FB2
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426401; cv=none; b=KqKmJfqZI49zYmJUI+Omr6obSkkshFAfUd25AqF1vkLUTMheWj7SA0nmfmfcro6d/B9ouRmnQ4+L4XT40Q/NN37SI+kRFLY4T9S8U2+eabDP/6e93iWT5GP8EeDv8gjdacm03d0smyCc9f8rhpG/j7OI28duiKgQ+v4MMNgt8yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426401; c=relaxed/simple;
	bh=Z7q2dDcOGE5HHI9QjGkZF0YF9uZw21LuZRZPZpdyNIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKmfLnyLuRL6MIGFakabQIEEdoLVULxsE2sgOnyhqLMfLttzFfzyr9oUqGS3r3wrNisq0Mg5js5sIzOUxyUCmz399YtLaxiXV9BDy1ZAtyJPYT4iO4DXsq2LD+AhtZciwD05zXQGebXq/ZI5DtUj2wVXx99fg9dTDFTBMsbiS8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WGRYQ2Rg; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGRYQ2Rg"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c7533dbd87so195604a34.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426398; x=1769031198; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSGuW77Tqa7tA2WLBhJJdwtXNnuVhxLeXVZSIZi6p4U=;
        b=WGRYQ2RgH6iY5iggIB26OF7YTNKgMU+BpZuvbacX4TbVbf6x6DtlUFxbfiueIKVnfe
         /kDa+1sKFWlHDPDTjhb1MRuZwnyfLaiy9PyjqABLbQ8v2xodESN/a7mJC+eKb0BWsbP+
         8Y/uEuFtnhTuzQ1ps4JOJ4a0OUql5z93Wzd1OD+WfcDHmXX4LDcblEpT50jDzCOLzTFp
         D+5TGc0+F63zXJODvxF1tG8bDGB189jEbBT4v6dDzpbqJm1kVEZ6k3098Ci7mXFDhi2w
         GXhS9oyYlFMxoE8p8t6NiZ8V2DOZKmieNR64xbUBA67FNkVc/OWGqzbK5+MEzDnjqpBF
         f4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426398; x=1769031198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSGuW77Tqa7tA2WLBhJJdwtXNnuVhxLeXVZSIZi6p4U=;
        b=uDaVNlkuRyU9R++yeVnbTFtSh/FIbjN5QptA6cn5khCyUspIqPcLAiKpFWd1iOlbIm
         oLKG1+4TWb+I6f68PUtI6B81HP8Bj44YRnunUmCZeOURROvrYPYxQJtdlslVFXt1cdml
         WhiteZy6gdxo9/EcqmDz/yx4xc0ydh6KmUoPigbNCPufnZa+RdQU9XtNMVWWegxjXFv8
         pKmhQKETjADgGt+Z8NlmuDkC0Jg+O3Ou287Kib1w1qD9LE38g6lBPCtmCisNbGcRI6bo
         EnlOztUzdTxhGxpzDLipzDHpUZuzckObgw7L6Zidxnf5unCNS4MfUc/7+tJ/G0IgfDmG
         BCNA==
X-Forwarded-Encrypted: i=1; AJvYcCUtoN4GsFfD0aUu/HrQt5juf47+mg2DDaoxvS7KOzirybjfqgbqSKjTzsKzkovN6WlHXYtT8hM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8DtCSP3fBSg1KW30197fvH0rR6tNd53HlKobfwr0Evr7xQ4cj
	jvN2XH6RrTv+pX1x7OJQF2Cdgf7x3XUyhaY///MmdEsO7YY2qQ3NE9pZ
X-Gm-Gg: AY/fxX5LEELAPOVfFsWr+GYSxO9p5KpC1bk4+zl4mg/g7Fh0ddozQKuRgUT0Ugtb2O3
	Je3Tl8ZWVnXhxBemNFT+kjrGdI72x4NNHYfNzl3Z+LhDCtCUacl6CqXAOSl9HWxk5yxMOMkU0m2
	ekUZsi8eILaacLYa1pXgzoTmn7ZxAEano8cMET8tWggBxJfvq8v2fQBb/jKYcFMlg/AhANcj2y4
	jxk5GQx9KHMV495y8Jbn5sY67LAfSi8jfpBqlSyfVodqQvLLH4DGfwrAENWqFU6dlwGj6dAYgMK
	igZhYsv75xYtvnSAA4kPLCIM8Y1C2ANnkIvoFabDx6E0tO/E5uRvlLCqFNAPYQwswaW9XjBplH/
	IOEzAisSBIEl0+GKh+Qa8vkZ5eNRLggJ3C/Zi9BJhsSHT369ChJLIaS4vneba40kTJrLlAZ8JdG
	db2JkI+3IHGJIJk1Z3KShrKCy8Q2ueZ5wYvw1vlLDKvIlJ
X-Received: by 2002:a05:6830:44a4:b0:7c7:4bb:dc06 with SMTP id 46e09a7af769-7cfc8965df3mr3143110a34.0.1768426397962;
        Wed, 14 Jan 2026 13:33:17 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfd68b13fesm76200a34.3.2026.01.14.13.33.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:33:17 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V4 02/19] dax: Factor out dax_folio_reset_order() helper
Date: Wed, 14 Jan 2026 15:31:49 -0600
Message-ID: <20260114213209.29453-3-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114213209.29453-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114213209.29453-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

Both fs/dax.c:dax_folio_put() and drivers/dax/fsdev.c:
fsdev_clear_folio_state() (the latter coming in the next commit after this
one) contain nearly identical code to reset a compound DAX folio back to
order-0 pages. Factor this out into a shared helper function.

The new dax_folio_reset_order() function:
- Clears the folio's mapping and share count
- Resets compound folio state via folio_reset_order()
- Clears PageHead and compound_head for each sub-page
- Restores the pgmap pointer for each resulting order-0 folio
- Returns the original folio order (for callers that need to advance by
  that many pages)

This simplifies fsdev_clear_folio_state() from ~50 lines to ~15 lines while
maintaining the same functionality in both call sites.

Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: John Groves <john@groves.net>
---
 fs/dax.c | 60 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 289e6254aa30..7d7bbfb32c41 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -378,6 +378,45 @@ static void dax_folio_make_shared(struct folio *folio)
 	folio->share = 1;
 }
 
+/**
+ * dax_folio_reset_order - Reset a compound DAX folio to order-0 pages
+ * @folio: The folio to reset
+ *
+ * Splits a compound folio back into individual order-0 pages,
+ * clearing compound state and restoring pgmap pointers.
+ *
+ * Returns: the original folio order (0 if already order-0)
+ */
+int dax_folio_reset_order(struct folio *folio)
+{
+	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
+	int order = folio_order(folio);
+	int i;
+
+	folio->mapping = NULL;
+	folio->share = 0;
+
+	if (!order) {
+		folio->pgmap = pgmap;
+		return 0;
+	}
+
+	folio_reset_order(folio);
+
+	for (i = 0; i < (1UL << order); i++) {
+		struct page *page = folio_page(folio, i);
+		struct folio *f = (struct folio *)page;
+
+		ClearPageHead(page);
+		clear_compound_head(page);
+		f->mapping = NULL;
+		f->share = 0;
+		f->pgmap = pgmap;
+	}
+
+	return order;
+}
+
 static inline unsigned long dax_folio_put(struct folio *folio)
 {
 	unsigned long ref;
@@ -391,28 +430,13 @@ static inline unsigned long dax_folio_put(struct folio *folio)
 	if (ref)
 		return ref;
 
-	folio->mapping = NULL;
-	order = folio_order(folio);
-	if (!order)
-		return 0;
-	folio_reset_order(folio);
+	order = dax_folio_reset_order(folio);
 
+	/* Debug check: verify refcounts are zero for all sub-folios */
 	for (i = 0; i < (1UL << order); i++) {
-		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
 		struct page *page = folio_page(folio, i);
-		struct folio *new_folio = (struct folio *)page;
 
-		ClearPageHead(page);
-		clear_compound_head(page);
-
-		new_folio->mapping = NULL;
-		/*
-		 * Reset pgmap which was over-written by
-		 * prep_compound_page().
-		 */
-		new_folio->pgmap = pgmap;
-		new_folio->share = 0;
-		WARN_ON_ONCE(folio_ref_count(new_folio));
+		WARN_ON_ONCE(folio_ref_count((struct folio *)page));
 	}
 
 	return ref;
-- 
2.52.0

