Received: from a11-123.smtp-out.amazonses.com (a11-123.smtp-out.amazonses.com [54.240.11.123])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACA7408609
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539587; cv=none; b=otrtdMOOux7OeL12orIIZlic1NvTLezUQsrZ6n+pL7FhCBG+/qJs9QGg1ee5C3D5Bm+9JaiaCtYz+10ChSbkYo3mAaKTbwwcM4lrVrw8uYmXjDchz9GQxGVI6S1xuxn0zvoQIQwU2p2DoFU1/pTNoQB3aJokG+K9X8Q7ecdiiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539587; c=relaxed/simple;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=kH8r69f1AIxeI9azASuVmNZ6Z74xIqEm0JL805yED5U0fZPLinXh7CZHXwwYmJJbXnEPzZC+AGLf4jq6pcQfHMwPTns3oeVjq1Bnnf/h1tapguRxhkmrFQyPsrwBgIqTHOTK/erriPJccJWHUwgwmtjQWpVkfTFJOg4vbdkdzgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=SpZ5VL6j; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=YbFV0NFX; arc=none smtp.client-ip=54.240.11.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="SpZ5VL6j";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="YbFV0NFX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539584;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	b=SpZ5VL6jmdvUlBhiSn/YI6cOG7gn1HpnABeoW3+IRQykQKVeKZNn2pLj1HNB3mF3
	O8Zmr0k6792K4namtEXjm33v8riadFoLL8yo/QFxa+sI+7FvKvaml7oNUw/BfAeIaak
	cO+Ml36oN/8IeTNy26hitEECBHJ/FAlZY545tCKU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539584;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	b=YbFV0NFX732zF8aGKmDU57SkLCn299N8Jw0GM7hb7/x0nAtrMyjzWqs1JtyT55dz
	wbCsL/HRCSAJAaA1umd8HcCNnSULC2dxZYyDP6ByJCcKTpHxarT4l0jz2avWVRxupPx
	lgaYAniVxAHEfbIGux5FBaSjTSYpKBck2lVJ4A8s=
Subject: [PATCH V6 01/10] dax: fix misleading comment about share/index union
 in dax_folio_reset_order()
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 15 Jun 2026 16:06:24 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
References: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com> 
 <20260615160616.17456-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAABrh6
Thread-Topic: [PATCH V6 01/10] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
X-Wm-Sent-Timestamp: 1781539583
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc08b8cd-4ee80eeb-1341-4f67-8478-7298129440e9-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.11.123

From: John Groves <John@Groves.net>

The comment in dax_folio_reset_order() claims that DAX maintains an
invariant where folio->share != 0 only when folio->mapping == NULL,
implying folio->share is zero whenever mapping is non-NULL. This is
misleading because folio->share and folio->index are a union -- for
non-shared folios with mapping != NULL, reading folio->share returns
the file page offset (folio->index), which is typically non-zero.

Reword the comment to accurately describe the union aliasing: the
assignment clears whichever interpretation of the union word is active
(index for non-shared folios, share for shared folios), which is correct
because the folio is being released in either case.

No functional change -- the code was already correct, only the
justification was wrong.

Fixes: 59eb73b98ae0b ("dax: Factor out dax_folio_reset_order() helper")

Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 fs/dax.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99b..df19c9317d10e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -392,12 +392,12 @@ int dax_folio_reset_order(struct folio *folio)
 	int order = folio_order(folio);
 
 	/*
-	 * DAX maintains the invariant that folio->share != 0 only when
-	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
-	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
-	 * Callers ensure share has been decremented to zero before
-	 * calling here, so unconditionally clearing both fields is
-	 * correct.
+	 * Clear the mapping and the index/share union word. folio->share
+	 * and folio->index occupy the same union in struct folio. For
+	 * non-shared folios (mapping != NULL), the union holds folio->index
+	 * (file page offset); for shared folios (mapping == NULL), it holds
+	 * folio->share (reference count). Either way, we are releasing the
+	 * folio and both fields should be zeroed.
 	 */
 	folio->mapping = NULL;
 	folio->share = 0;
-- 
2.53.0

