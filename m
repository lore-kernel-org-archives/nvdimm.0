Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842A823D4
	for <nvdimm@lists.linux.dev>; Wed, 22 Mar 2023 11:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1679483499; i=@fujitsu.com;
	bh=D5zehFzp2M705qZ/aeVuz3slw23MEz2KodT39f4ljmo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=xEeHnttUtxqVxN4Kc2mp+ktyb1WbS2bIwf86BE90PUQmSfpAs7K1DFe0ytiv0NVEC
	 0SPai0PMZswz7eOcONciLER3RFbq06SjXDJygEFzUIYayTFfN0xk9NlGfsjKanD+mt
	 g3Zkgo6lOw6qK1hfETc1PgjFpn/YWc6f+c0PhOQaIfw6h2mUcToTGt5+z89NyrPEiJ
	 fpKzxqD5xegFS0YfJgwY1Xqw68vDyeF+5btxh/ArltiCEHMOXe0grhZjgTC5yLpo5P
	 vA0gAnfOfTvszMQteqm3S3uC8yk4dVfbehMRIw47Ny9ZjEVfGU/iQo98YB1EE7zfPK
	 7et4OtYvbitTg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRWlGSWpSXmKPExsViZ8OxWTf1kVS
  KwcfNAhZz1q9hs5g+9QKjxeUnfBazpzczWezZe5LFYuWPP6wWv3/MYXNg99i8Qstj8Z6XTB6b
  VnWyeZyY8ZvF48XmmYweZxYcYff4vEkugD2KNTMvKb8igTXj86bPbAXTuSqOv9VtYNzN0cXIx
  SEksJFR4tXnXcxdjJxAzhImiX1/CiASxxglzm/exAiSYBPQkbiw4C8riC0iYCux+PYZsDizQI
  VE46J/QM0cHMICARLT3paDhFkEVCX+vd/LDmLzCjhLND87wARiSwgoSEx5+J4ZIi4ocXLmExa
  IMRISB1+8YIaoUZK4+PUOK4QNNH76IaheNYmr5zYxT2Dkn4WkfRaS9gWMTKsYzYpTi8pSi3QN
  zfSSijLTM0pyEzNz9BKrdBP1Ukt1y1OLS3QN9RLLi/VSi4v1iitzk3NS9PJSSzYxAkM/pZj55
  Q7GE31/9Q4xSnIwKYnyvrkrlSLEl5SfUpmRWJwRX1Sak1p8iFGGg0NJgvfUQ6CcYFFqempFWm
  YOMA5h0hIcPEoivD/uAaV5iwsSc4sz0yFSpxgVpcR5s0H6BEASGaV5cG2w2L/EKCslzMvIwMA
  gxFOQWpSbWYIq/4pRnINRSZhXGmQKT2ZeCdz0V0CLmYAWx82QAFlckoiQkmpgal3TIO15rjHZ
  Zsr2tewTJryJvHyBKeD6vLiKfzM7Ap5czcoOPec5uVgnKHfvw5iswE1sUT3Jhb6Kgbvq/3N8a
  j8255l8g/WhWe9Ljxxr+jUjVr9I/elRsci17hf+m+e99f08eQLHmvqvoXy+N/hOBv+bunb6iT
  Nn3pzQuXYrrqji1c2A50nHDG7v669wMj98bP9lpcb0zpevPRTOyz84s/L+ctllmxTdX1w7rnK
  qofPbwf0XTU2uHdK49Xw6q0lp0iHjnm8zv5zpPXn+nKlpcH3rmZ5L0x08G9YeYajkipNiNfpm
  +/8yu5An+/mafqvbC1eflbZ9VatVPFXx9kEDMW6uNeyVpdeKwtzSlfSPViqxFGckGmoxFxUnA
  gCZbnnieAMAAA==
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-17.tower-591.messagelabs.com!1679483493!530805!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 6417 invoked from network); 22 Mar 2023 11:11:33 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-17.tower-591.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 22 Mar 2023 11:11:33 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id D1096153;
	Wed, 22 Mar 2023 11:11:32 +0000 (GMT)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id C403E150;
	Wed, 22 Mar 2023 11:11:32 +0000 (GMT)
Received: from d45b9faa733c.g08.fujitsu.local (10.167.234.230) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Wed, 22 Mar 2023 11:11:29 +0000
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
	<akpm@linux-foundation.org>, <djwong@kernel.org>
Subject: [PATCH] fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
Date: Wed, 22 Mar 2023 11:11:09 +0000
Message-ID: <1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

unshare copies data from source to destination. But if the source is
HOLE or UNWRITTEN extents, we should zero the destination, otherwise the
result will be unexpectable.

Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9800b93ee14d..5d2e9b10030e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1258,15 +1258,20 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 	/* don't bother with blocks that are not shared to start with */
 	if (!(iomap->flags & IOMAP_F_SHARED))
 		return length;
-	/* don't bother with holes or unwritten extents */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
-		return length;
 
 	id = dax_read_lock();
 	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
+	/* zero the distance if srcmap is HOLE or UNWRITTEN */
+	if (srcmap->flags & IOMAP_F_SHARED || srcmap->type == IOMAP_UNWRITTEN) {
+		memset(daddr, 0, length);
+		dax_flush(iomap->dax_dev, daddr, length);
+		ret = length;
+		goto out_unlock;
+	}
+
 	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
-- 
2.39.2

