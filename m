Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFDA1B2194
	for <nvdimm@lists.linux.dev>; Mon, 16 Dec 2024 12:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734352647; cv=none; b=cnq5ASfNCN6atEYxXut8GOXDAqBIY7bmapMTHWIQpKIAPLL6/5ei4Lkd15wO+CGXjYd3/MKJxznYqtHrAZVUIDJvav761dzZfahwSnAKfrkCPSXqaaWhYGfTT5vDvg1fZaKtpToPzzU50KoPnyHvxH5HG2KtRO5SLUcFLn2Gxjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734352647; c=relaxed/simple;
	bh=2Jvc2ooaXI+L9g+8T5Kx3Exr0MpOlbtxQtFd6k1AXE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qjRKSGjVQcaDObtp7FwRHLY+6lOoA+shagI88QuHQmBbXhy46a6HRQRhDffzSOV86QlFEkUeT7M9hjKAv6Rkuc07GInFfupY7MZlRqhpFHDJqnrcP0FmVpNKZ2drkXwCOhHT0lEPUn9HLdUul9eEpazxzkM+WvfDNj4nFfGZ1uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=nohrOpoZ; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="nohrOpoZ"
Received: from mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:78a6:0:640:2e35:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 4B2CA60D32;
	Mon, 16 Dec 2024 15:37:15 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id DbOdoh1OiCg0-WXpELXyJ;
	Mon, 16 Dec 2024 15:37:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1734352634; bh=CE+8LA/Pi41fWGZYLgoIDsaUdC79MUcJltgEITotazk=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=nohrOpoZIN068pwgwNnzIF7kC+1HWqIukJHTPEblqdQ4GSJHnDuRBD3kOYfh9xIqQ
	 jvKPR2lOqU/pb0AxU9VnYo2tvlHD7+m7XVavBbVgWw3Vv9vjhZgZ5ONXFxFralovSr
	 9OLZHKGhBvRsTL56QZ23b7mA5Jwx14ymjCssRIwY=
Authentication-Results: mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] nvdimm: add extra LBA check for map read and write operations
Date: Mon, 16 Dec 2024 15:37:12 +0300
Message-ID: <20241216123712.297722-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'btt_map_read()' and '__btt_map_write()', add an extra check
whether requested LBA may be represented as valid offset against
an offset of the map area of the given arena. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/nvdimm/btt.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 423dcd190906..2bd03143c8c3 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -96,12 +96,17 @@ static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
 static int __btt_map_write(struct arena_info *arena, u32 lba, __le32 mapping,
 		unsigned long flags)
 {
-	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
+	u32 lba_off;
+	u64 ns_off;
 
-	if (unlikely(lba >= arena->external_nlba))
+	if (unlikely(lba >= arena->external_nlba ||
+		     check_mul_overflow(lba, MAP_ENT_SIZE, &lba_off)))
 		dev_err_ratelimited(to_dev(arena),
 			"%s: lba %#x out of range (max: %#x)\n",
 			__func__, lba, arena->external_nlba);
+
+	ns_off = arena->mapoff + lba_off;
+
 	return arena_write_bytes(arena, ns_off, &mapping, MAP_ENT_SIZE, flags);
 }
 
@@ -154,14 +159,17 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
 {
 	int ret;
 	__le32 in;
-	u32 raw_mapping, postmap, ze, z_flag, e_flag;
-	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
+	u64 ns_off;
+	u32 raw_mapping, postmap, ze, z_flag, e_flag, lba_off;
 
-	if (unlikely(lba >= arena->external_nlba))
+	if (unlikely(lba >= arena->external_nlba ||
+		     check_mul_overflow(lba, MAP_ENT_SIZE, &lba_off)))
 		dev_err_ratelimited(to_dev(arena),
 			"%s: lba %#x out of range (max: %#x)\n",
 			__func__, lba, arena->external_nlba);
 
+	ns_off = arena->mapoff + lba_off;
+
 	ret = arena_read_bytes(arena, ns_off, &in, MAP_ENT_SIZE, rwb_flags);
 	if (ret)
 		return ret;
-- 
2.47.1

