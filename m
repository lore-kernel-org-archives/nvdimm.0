Received: from a11-70.smtp-out.amazonses.com (a11-70.smtp-out.amazonses.com [54.240.11.70])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F86A3FFD
	for <nvdimm@lists.linux.dev>; Sun,  7 Jun 2026 19:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780860794; cv=none; b=Z/FXYDYF6KFmMSRcNioTajxuqcrSkibS0MIkLe0LJ/lEzxKs6Vt5MRzivGm9DNWJiyaG6SEww1EpRqI2if5V09xNiUpjy9ha+pOCaFnqeJG8mSvPgw1cJFT7Qu48kznOL1XGblofrKdyJ24ws4TFUkLwBtWxg/hI5KEHrePW3pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780860794; c=relaxed/simple;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=DiOpn1MMg8BjnmvEsNSosaZzgSBFs8uFxft1sFDgkCWfIfNS/X59ocbwcGdr3F3hZ4eQKZuLunMv1xqAUaP2EMXQg+tV1HuAiXxBB3B0b0Lo55Dkkxy0G3fccc9mwWi+P9076Mvc4Ez+gDcO5GzUVp39JiGDX8LQ7Yy+SMNk0Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=ryfxiKBj; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=T9pG2DrP; arc=none smtp.client-ip=54.240.11.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="ryfxiKBj";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="T9pG2DrP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780860792;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	b=ryfxiKBjqBi1wyxi9nJFc4NHL3MJ96y0F9bTcmPcMdgvMokLDiSN2m9ykEY/zmt2
	Q/f4Gw88ui0CgmcBAVzkeQJlaSzzxgOhta5ANoZSpmQlO5/ltmNBgVt+wLmPjxipYMF
	+Zm00hb/pwixGBlh3KBPwEPieabiZJluZSPnYXOg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780860792;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Obr6K+WtReHjNaqSTV7QO+J9GmsqvqYkwE7r4Q1gGUk=;
	b=T9pG2DrPZ3aiSiAEupPGO2dGnAjecQNe4utLTN5t5lZ5XrgWH0Gun5C5Ii3MqqXt
	TloZXj7DJIxDFZ7UMSth44EDSy4bfxAcW9CXHJSm2xpWh9WSlCv9EANZ/D4pmYwL6UT
	F3MJ/0ftKFV6nVPZdC7nz3myK1WEkwQUCqq6ErQ4=
Subject: [PATCH V4 1/9] dax: fix misleading comment about share/index union
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
Date: Sun, 7 Jun 2026 19:33:11 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
References: 
 <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com> 
 <20260607193305.94271-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc9rRhSPXw4ZdTQtuvnkZG9OrQIgAABhDR
Thread-Topic: [PATCH V4 1/9] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
X-Wm-Sent-Timestamp: 1780860790
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ea3932c9b-91164474-4e3f-48ee-844a-be310f330793-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.07-54.240.11.70

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

