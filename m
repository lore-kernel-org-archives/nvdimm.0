Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795491242;
	b=0IfSLSjXpyIWcNnRYA/0s+p8UczvUtT3H38qHBUmcDtEvrMejT5upTp3/vMDrJkfYXsm
	 CI0lMdxQdpjYNy9nPWz+bEyODP2wopitXlpDCtqXVob8cZEspJO3qb6OTs/FeUqM6SOqK
	 5kvNtIkvwoHNl5dS9nqrXx3NjQIUCnW1gheKRHzFxS7cmU7BPE50TlqpkCUoSbwiMxdB5
	 eMspk1fTkGt4snoqccCGzqLDi3g7UJOfDlV93nbLST2zr4G40AU6T+AzLoKX0by/84XGf
	 Tvs7daVjXX9J/huvmxnSFhwj4N1AA5lbiyhc36eDN0GDsesJZIX0cefR2tHdiAPSh3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795491242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=fgziihkmWmv71dbB/QFn4V+nTlNArdPHdIiY2QssMfY=;
	b=DDq5dYcSaWUCbhsL8lhDLxEbhKFzz0ufJwiTWDOGWS5Uy7n6urDYbP1eFfPCP/CAmXJv
	 c5DK2E/CbdOv7TpRxAATRMz6033S9Ez+qRQAQR1/EwMTzv8PMNk37CQXcyQWllC6vkuKe
	 Gwd8BgzW1tOK0jyGNq+AvYNbylPEchu7uoknedg47s6BWIykAq0o36nvRwQQXgEBLHSSL
	 vR2thcf37kPXf44JnHOYmZVS7kOQ30YRuI34WsoUsFrRZ7xyQk8MZVLDc6x5/+3BSijqK
	 nCEMSBQr37H4LsvBsnVRJTj/aWQ3W7SirOCGgRAM2YH0lSn01AU17ME6TsJUaqAPJOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--nilayvaish.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VTaNDQdM;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668FE606A321
	for <nvdimm@lists.linux.dev>; Tue, 24 Nov 2026 03:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 668FE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nilayvaish.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VTaNDQdM
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3854627c1c8so5958590eec.1
        for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 19:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795491241; x=1796096041; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fgziihkmWmv71dbB/QFn4V+nTlNArdPHdIiY2QssMfY=;
        b=VTaNDQdMBRiCY5J4CBTJV3nZh0KLfYjYD1iEy6Qby/fnKBvYeW/TJ8mjBG7XX0mC+T
         ysJM7+bHX/3Q5HtykR54FN2e2dCXnGNy08//CFxSh1tfJNHQRvA9kmgi/eHIDRJssExA
         rP5l9vTAUqYlMrdWT+pDq0DmUgLVTsDTsuMqkqusBz195AKkf31wiFequGXQQdusApN5
         h7lWu0pdfz66iSjAvYnt9B34GIorMnux7E/VEjDkDEEG/909pfwJEJGp60lJboD/GyPr
         8Qugb/Fg9vKJwOZtYpKSF6Gr6RnZ0BDnTDS3hX7cXvlrHIwWwBKNE1KmDMCHwtvRzitB
         YtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795491241; x=1796096041;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fgziihkmWmv71dbB/QFn4V+nTlNArdPHdIiY2QssMfY=;
        b=biIinYciFwgIHSMRS5PhugKDqMpk+p4olifewf1lBV90jWofWuVpiEk3S+JY6A3jNN
         htTsUTdL7oVQD89/HoERluP1/M7ejyCPdqOffc/+hHxU3nQk9O2VvmNxi7DFKZCoD3Lx
         WO4El2kG8Oajq1G33VRc41W/FfZ9zWWJst3lRkdOGcnAclrvSAB6Iq0DTs64ys2erKxr
         4O/3DAM8/ibfq6Dl54364Xmrqf6aSyKU6EpbE6pUBEbFnCpNMsd9r0VSI0dgjO32J6r5
         1aeFlVTxBR3M6sIFFr8LjDda04avXO5Tbescb/XwUuIdA5+IQUYNJRVvhWIJmqEH44ME
         oTIA==
X-Forwarded-Encrypted: i=1; AL+hErHCkfm9PwfzAVmZrFL0ZxpZoLD2YBoutumOdMu7jayv/UNTogvpE1Umz498HqSQaJIraosDPJk=@lists.linux.dev
X-Gm-Message-State: APuU4Z/Qi32mYZh/kv3FXfqkzIMuHnteb7ib6Go3Z8mRtP8UFaVH53f3
	dYWb+hXYD/R6kFkeX6usvvkv7isq7G8G0nT+84yZX7qKUxAdzKREJNZsT/Gpr1pGhco/hwBG3DV
	Dv34LPOAZLW8/1IQseVcTVw==
X-Received: from dyw11.prod.google.com ([2002:a05:7300:880b:b0:36a:de0:d28a])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:87d6:20b0:386:bc19:6a30 with SMTP id 5a478bee46e88-386bc196d10mr2286489eec.20.1795491241112;
 Mon, 23 Nov 2026 19:34:01 -0800 (PST)
Date: Mon, 23 Nov 2026 19:33:57 -0800
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261124033357.830767-1-nilayvaish@google.com>
Subject: [PATCH] fs/dax: use page_ref_count() in dax_folio_put()
From: Nilay Vaish <nilayvaish@google.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"

Once dax_folio_reset_order() has turned a DAX folio back into single
pages, dax_folio_put() checks that none of them still holds a reference.
It does so by casting each struct page to struct folio and calling
folio_ref_count().

The cast relies on struct folio overlaying struct page. struct folio is
going to be allocated separately as part of the memdesc work, and casts
like this one have to go before that can happen.

page_ref_count() reads the same count from the page that the loop
already has, so use it.

No functional change.

Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---

Notes:
    This patch was written with the help of an AI coding assistant (Gemini).
    
    Based on next-20261123.

 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9d161d7ef3ef..16cad82c689f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -449,7 +449,7 @@ static inline unsigned long dax_folio_put(struct folio *folio)
 	for (i = 0; i < (1UL << order); i++) {
 		struct page *page = folio_page(folio, i);
 
-		WARN_ON_ONCE(folio_ref_count((struct folio *)page));
+		WARN_ON_ONCE(page_ref_count(page));
 	}
 
 	return ref;

base-commit: 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5
-- 
2.56.1.839.g22a8290db9-goog

