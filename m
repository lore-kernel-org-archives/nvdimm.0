Received: from a48-184.smtp-out.amazonses.com (a48-184.smtp-out.amazonses.com [54.240.48.184])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BAC224AF9
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 19:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477531; cv=none; b=hk2DUNUafVfdhF4iBp/DHIc8PRwdBC0/megpW+ChJ04H3djBsHMS0pDrImi0noJ0sPwfl7CC2DlhCjxCuVIREbfeVN6EUpbACf6gQxBKye+orHQiV3CFY0L4DW6T5IrduGBXcfFdXrH52RQ1Vz2yZFyqPkwy2s/WovGEMGa4kLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477531; c=relaxed/simple;
	bh=ZEr4rH5sFsPpkQSuhtgi45OULySeed0QHY3Iak60oUw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=kdyEYcjj4x5MANodL6frJyx8ZieKquarlT9z97kB52/QrpGkr4833hHO65B25Fyqcd7lNTVf4ti96rxyL24ui0avT4+VZaZ3o+rcHI8np5k302loJSUdQzt7Z+tu8ThZRfS/mnx+AyoiDbpP+6fl4A2PzqNCGlbUq3tv9yxISFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=vn/rsM5c; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ZgS/Zt+U; arc=none smtp.client-ip=54.240.48.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="vn/rsM5c";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ZgS/Zt+U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779477529;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=ZEr4rH5sFsPpkQSuhtgi45OULySeed0QHY3Iak60oUw=;
	b=vn/rsM5cgdmpAxt2EtwoNb+7W9cMUKqIo+AK/zazSBc9SzOW3S4xyGGyw2PdemTp
	RXdJ4xztM/0OMzMOqyzq2ZELxoo2gfAUksMre3xyriaqpNB5TrmwO1QU+21mJBQKzcP
	DX6hu81OWnB4TGeEP1EmnidZJaOVnrxe76vG42o4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779477529;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=ZEr4rH5sFsPpkQSuhtgi45OULySeed0QHY3Iak60oUw=;
	b=ZgS/Zt+UTA1kvLyER5bGrjKMMmPLJD26zfciucyfxUfb1BSFkPfLyYxslRIPodny
	pbMFhFRJ3vwxFHyrgPoI4/Kp+AltTXtcACFAhxGJS+/3UWgXm/HBzkRfx0B0A7mqXp9
	EDQ16VLxdy/4KreRxdDG+JjoA/Ck74LLV4gm+z1E=
Subject: [PATCH V2 1/7] dax: fix misleading comment about share/index union
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
Date: Fri, 22 May 2026 19:18:49 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
References: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com> 
 <20260522191843.79132-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc6h/Qss1/hrKVRpePc6yzczysHQ==
Thread-Topic: [PATCH V2 1/7] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
X-Wm-Sent-Timestamp: 1779477528
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e512043a6-62e6e881-6d31-48e2-86f0-bb2c32248f0a-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.22-54.240.48.184

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

