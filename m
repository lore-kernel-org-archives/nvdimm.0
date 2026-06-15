Received: from a10-70.smtp-out.amazonses.com (a10-70.smtp-out.amazonses.com [54.240.10.70])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BA5407CD3
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539608; cv=none; b=UiZgHHvqQizaP3f9769zOpp7xMBp8u1TWlBoqRiYymNLJTonk+xKNzEVFxvzQPPHBHv5Y0CHZPpiyNc+Z/y6HA7DCwA2Cl7GKIpZSv8PQXIx11qFA+lWN72Fsuuik5oz/Pn/J5YNMRfR23waQ5TvO3y6Cq4pOzRSmdp0G70mOsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539608; c=relaxed/simple;
	bh=4tanUO3miWAURhJritZbKxZlEXb0a0H/iJgHp+eqKpA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=GGQiUQdtIIoLOfnWJLf7ul8AlpYTsednICHI3ZyjSJhZ6b3Z0Rj5YknglfLtNjwtyAB6nDFUFKm6fWgZ94OW2I5jDiOQF8m63akQ7Zu1hpjEPNSozJ+AYYI3OWUgg8StX427ETMnLekWhcAo2AL2KeTpqmCmjOQzTB1PRayAv0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=uHeI251+; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=irzn/fue; arc=none smtp.client-ip=54.240.10.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="uHeI251+";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="irzn/fue"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539606;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=4tanUO3miWAURhJritZbKxZlEXb0a0H/iJgHp+eqKpA=;
	b=uHeI251+FCzko1Pys43EZVpVDG63utZaaN0uWGdFpZTXxB267mWOH/XWXlNDH4Ll
	VUFS7UtItZdyATKcDGY9whzQOS+TVxECTfCK8Us+Tb81rfmRSeQLW9j+vqayITfguoK
	mb7ya8twzP1A1AL47YVIQ3vLwIm+JZwmgGj834bI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539606;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=4tanUO3miWAURhJritZbKxZlEXb0a0H/iJgHp+eqKpA=;
	b=irzn/fuerbzL/95GBCWW0Re3lkVuSzS6ko2z1la0JhXPr79tGMOfx++Us9UNBhbz
	HXjmDQKqv8QwvitH38DNo/ij3unvTY5SyWuJEADB1pfHeatFUuuZAykO3nlypCLtepc
	wKfDseMMfYSEC/unZdupGnf8OK7nQK8nKt1f9Yqg=
Subject: [PATCH V6 03/10] dax/fsdev: clear vmemmap_shift when binding static
 pgmap
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
Date: Mon, 15 Jun 2026 16:06:46 +0000
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
 <20260615160634.17496-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAACfmC
Thread-Topic: [PATCH V6 03/10] dax/fsdev: clear vmemmap_shift when binding
 static pgmap
X-Wm-Sent-Timestamp: 1781539604
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc090eea-7c46f51e-5393-402c-850d-78059bb6d343-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.10.70

From: John Groves <John@Groves.net>

Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
device from device_dax (which may set vmemmap_shift based on alignment) to
fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
zero it before devm_memremap_pages() so the vmemmap is built for order-0
folios as fsdev requires.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index f315533b299e9..dbd722ed7ab05 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -237,6 +237,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		}
 
 		pgmap = dev_dax->pgmap;
+		pgmap->vmemmap_shift = 0;
 	} else {
 		size_t pgmap_size;
 
-- 
2.53.0

