Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F3644AB60
	for <nvdimm@lists.linux.dev>; Tue,  1 Sep 2026 19:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292661; cv=none; b=cxAIvUugAFcynTKrlNeqmbgosYlmbKeld9Ojv/TgKWYCH3kkkGbjJArfPXDiE/tmV4/zXx6+w1o+kSzOmqL2vHKlxTyEiwzrNRfJu0fg38ac/nOxDxLN4LReF+lc+OiD+Wpo0AFSwmnMP2wbh6sIgy1ooGw5cNGEcwQlhVQXt4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292661; c=relaxed/simple;
	bh=5w6WK6ckMcNcdsPN84mqG9HbEEH2Klk7PGq7GyeYxtM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rz6W7ui3NanDqOjJ25cIBqr/1eVPSGzVirJWUKc9Gc0k1begOqUhag27f9dwJyuYQOmZwGvCFLX5FtgKIQTadePKWs/g9Uq022I3phqNYDS1PKhoebJm/DNVNl0o6hXrgdvhb868nNL3rA7idcgpjjM2OFDoFLAwlGxfbQpHTVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=RrU2ym6W; arc=none smtp.client-ip=198.252.153.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="RrU2ym6W"
Received: from fews03-sea.riseup.net (fews03-sea-pn.riseup.net [10.0.1.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.riseup.net (Postfix) with ESMTPS id 4hZGqR27jPzDqZr;
	Tue,  1 Sep 2026 19:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1788292659; bh=gCrZ2kSnGtpRxBPsoU7WbHukzNsvY2+Zqypb5Ip0FNc=;
	h=From:To:Cc:Subject:Date:From;
	b=RrU2ym6Wn1z+ntQU1+HfgMQWjJ6YeR4UEG6YfoHeKRnNDljr8ui27LiLSi9rj+Wsl
	 +A3A1pEg3u4IUMg55ktYUjs56z2xMF+v/CR8tve808meyUMdGav/fR36vSffs5iNzN
	 efaydnjq0c9xyOD+duz/jn0PfR1Jypwg20YsdIRE=
X-Riseup-User-ID: 898E2F13D4BC060C95F747CF15E55FF0C098F2357342D492BF37A15503CF2D9E
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews03-sea.riseup.net (Postfix) with ESMTPSA id 4hZGqP1vTtz1xp8;
	Tue,  1 Sep 2026 19:57:37 +0000 (UTC)
From: Kiara Grouwstra <cinereal@riseup.net>
To: Dan Williams <djbw@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alistair Popple <apopple@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kiara Grouwstra <cinereal@riseup.net>
Subject: [PATCH] fs/dax: get the folio of an entry only after the entry has one
Date: Tue,  1 Sep 2026 21:56:58 +0200
Message-ID: <20260901195658.4027962-1-cinereal@riseup.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dax_associate_entry(), dax_disassociate_entry() and dax_busy_page() each
compute dax_to_folio(entry) in the declaration, one statement before the
test that returns early when the entry is a zero entry or an empty entry.
An empty entry holds no pfn, so dax_to_folio() reads vmemmap[0].

Where the memory map starts at pfn 0 this reads a struct page that exists,
the value is discarded, and nothing shows. Where the lowest present section
is above pfn 0 there is no struct page for pfn 0 and the read faults.
grab_mapping_entry() gives the first fault on a file an empty entry, so on
such a machine every first DAX fault on a file ends in:

  BUG: unable to handle page fault for address: ffffea0000000008
  RIP: 0010:dax_to_folio+0x14/0x60
   dax_insert_entry+0xb2/0x3c0
   dax_fault_iter+0x200/0x600
   dax_iomap_pte_fault+0x193/0x3d0

Found on a kernel that boots on one high region of system RAM, which has
no struct page for the memory below it.

Move each call after the early return. The other callers of dax_to_folio()
in this file already only run for an entry that holds a pfn.

Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiara Grouwstra <cinereal@riseup.net>
---
 fs/dax.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..90305996b106 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 				unsigned long address, bool shared)
 {
 	unsigned long size = dax_entry_size(entry), index;
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	index = linear_page_index(vma, address & ~(size - 1));
 	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
 		if (folio->mapping)
@@ -505,21 +506,20 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 				bool trunc)
 {
-	struct folio *folio = dax_to_folio(entry);
-
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
-	dax_folio_put(folio);
+	dax_folio_put(dax_to_folio(entry));
 }
 
 static struct page *dax_busy_page(void *entry)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return NULL;
 
+	folio = dax_to_folio(entry);
 	if (folio_ref_count(folio) - folio_mapcount(folio))
 		return &folio->page;
 	else
-- 
2.55.0

