Received: from a10-27.smtp-out.amazonses.com (a10-27.smtp-out.amazonses.com [54.240.10.27])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7E733FE15
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159837; cv=none; b=KWDZ3GgSfw2PGXy7OJKKWpBLiMgq+VVd0Jn37X6yzTOwvVLrb5ZTlzU3RfCcWElNfS6RMKYZQR86vY55Hx119n2JPDyynAgZzS1+pgDcgmRfkKL9J0G96/VkNJ9BVED1LaQ21z491GWKVzZAc9P+2zQ6k2YQl72ErGqwD9cVk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159837; c=relaxed/simple;
	bh=ZEr4rH5sFsPpkQSuhtgi45OULySeed0QHY3Iak60oUw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=p/EuWXnwUbi54lKpXUwYNYw/iYrrAA1n/KNzhXybC+l2ALHnngSWJnArdZ0NfpfYIOlyPlfqy5eRvXsBEpNdXTBWcZG0oY+I21yIxWYy0xZZwLM+/vFMhWgIJya9jUrrmQVbKCdrgdQeF5ARh0bzUHkz2f6SCoFqw293/8Z/0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=cATWQ9w2; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=OBocTAe+; arc=none smtp.client-ip=54.240.10.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="cATWQ9w2";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="OBocTAe+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159835;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=ZEr4rH5sFsPpkQSuhtgi45OULySeed0QHY3Iak60oUw=;
	b=cATWQ9w2tGHmi2Rek2i8AiFZTSTCohFYcW8daCBCna8AM4s7Wo4nqEkEMmMDjaD1
	0hl6x7pcpxBCSKc2ZVxzC0Twf0lhTW6YPcxWD7B3TQK8LnrYc4qbbmIRigRrmKbC3w7
	uJuDNArISOwCErx7omwSP6U+twlQlHreCc3EnvuQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159835;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=ZEr4rH5sFsPpkQSuhtgi45OULySeed0QHY3Iak60oUw=;
	b=OBocTAe+pY2PI0LwfaFAnhccCLyjdW+4kdVsQSDBksdHND+1p2ZLRCjd91F4SXGF
	Do2rJwc3UdBQ6TQM2fH0duA8tQ8HzjwBkfP5ZNq/jSxBA6eRjmdF+PQhsCDfT0ml5Nz
	3w7W2rJmQ5xr+CiBu+KRd62dsCDSzw4w8JAQJbP4=
Subject: [PATCH V3 1/9] dax: fix misleading comment about share/index union
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
Date: Sat, 30 May 2026 16:50:35 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
References: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com> 
 <20260530165029.6601-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRu/08Q5QSLRQK1MWzkEF1dWQ==
Thread-Topic: [PATCH V3 1/9] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
X-Wm-Sent-Timestamp: 1780159833
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cb6bf6-4b48b7f5-c562-4591-aefe-730561f1b8c6-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.10.27

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

