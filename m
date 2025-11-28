Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1886C2FD7CD
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318812; cv=none; b=eM/zJQffYKWOHhVrxtlCIAADo2+glk8UcK26+O8wjLQgdsdXBhmZviJmPdzOmOqmHq2NQ3Wfb2khYxbh2fZNU5pE6GFUK6deJG1czPBQteuPR4znn7DMcVdWNTPFeNtrljgDjzwcTABgdSeTb7GpeE30gsmo2K3Hzv3bhMNkfJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318812; c=relaxed/simple;
	bh=TbxNohFMmSKnHTWH+mnyMfPFRdWdcWW/LS3/VsufZdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N/YEf7GkGfrwDMgxq4YaL0Mp6fhqfMtP5V7MpTyEyTYTOb7bFbGe9DJYPKbTdj6j0zA8T/WSnCI9l84mi/Xx5WuiL4OyenKoG7SikrWQLal4tcoJFN6wwlpXMsgTP1w8DZmEPNtLeUwh4zy5tYxlw3Zu7Xob7O7U3TPC2H9uU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EE62MRX0; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EE62MRX0"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bdcae553883so1459166a12.0
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318808; x=1764923608; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=EE62MRX0atIaRAQP7wjFlyAOKNbJKyyLvIE6107ew5CLRL4pGzUhJwgHmkMnXm95G+
         BNM5FVWwaHisy0BhjrJ+gYlTvGsgoKc2k3IjfNvGt+WFJwq4t5MUyxKjvvN6iYVNVRYi
         +6TAMomOaLm20VKIXU1dhb6XT3w62E0yvhHLv6tA7HhexPOc/wd32EfBzNhlXIdc1FzU
         dH/f204qY0hTQkLX6T/GZjHSoeiGVBLL2bZPUlzXGlyQhuH9A30Llv3dHOpEjkFK+two
         jF9p/qBz4fs/tkQenQm/tHYai6SAxdSxvzSdyCEutvIQb6kYCnXUyEuirDBJcf7YaMt4
         ehcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318808; x=1764923608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=SJy63jVBZ9+ILyRMH40z5f39N+qNQ65HDjijUgKPf9K/ktvYVPF3Ga7qUuy5/8RF9w
         6mdQJU0MJat4G+OfL5YV+6NlcXWwMxWng2C6mzO13t/Cm/q3ho2DksaINSq5co9A63/p
         TWMzt2IHbRzTrrEuvReytH+cv1HSNSue69bsYUn1FNBikHFGDFSegZ6pCfwMa9uFTJsD
         i2obh4BNW3j14y31tP5LEV6Lq2Ph2VykXAbuq9NtCAa5xmBhx1fgj5QCXPoI6m1QjiON
         MMU5iQL7H9LnvNkRtQS0V0NVONQgJr81kNwJsc14+QNiGJPXg8gxluMWcWsRcPC5ia2c
         ryrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdC6ZFXy1Dg188njOyuh8qGSVOKjIIUDEDgBMu8zGiyuwcas+ET59/tYW/NFNNMGyRG9Hs5Ts=@lists.linux.dev
X-Gm-Message-State: AOJu0YyphBtEWGcgZ+f2HGhZygizbtV1aEnrsXUw8Y8oLhWH9X0PKC1j
	AT+XF2mZ07jqMiQhGDIm3dSBwEyg/aLOTogGoPbSv6r3dLlQ6LgVREpp
X-Gm-Gg: ASbGnctzl3DZzzgIiooY3dgS8eSbjzSRAPDVndP8TIQk6y38sE6ivNE7E06Rqt8Dvio
	QUYw23rGB3FsH6vtaGDrZL9BgJUubXd2C+8C5cFEWsQOy6y3fBNtIic9qm9YhfbZose6Ox0mT3L
	A9d+BhLKPiPar4SweSQXw8Ch/6/q6+leCcLlTlz0wrdand3jcpw8KwqBGjdwUtT8ZBvafe8/Hnr
	5mWYHheiSVRfOVlV79mB0fhEfn3Owrb8677vBnKD63nyOFsyGwO2mUqLqMoCQyqK0YAxUKpC3/6
	HvjG11CUQy0mbIpSQheOVyMcTaP9YNEVKj3AdGZbHIdZUCsQBGykPbHRjkhPFiv6je/Hocw9G/g
	x2cpjUkoOpohnN5JmIuDDA01J1vw4faCk3r4yhBXctZcZJkhFHByUpC4VUAXEfMLmMpjp8cWZBa
	VnvG8Mtlia1ArpQ/WFKPtL6tFvboilG8oDt/kb
X-Google-Smtp-Source: AGHT+IHDsMToqUoj0PcNSA32TYDuHE8zhBuDir1BrYt+w5Y/wAZYCWlUzMNg1Dgih3T9wVkLcbd8Tg==
X-Received: by 2002:a05:693c:2488:b0:2a4:3593:6464 with SMTP id 5a478bee46e88-2a71929687fmr16240699eec.20.1764318807899;
        Fri, 28 Nov 2025 00:33:27 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:27 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 10/12] zram: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:17 +0800
Message-Id: <20251128083219.2332407-11-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a4307465753..084de60ebaf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -730,8 +730,7 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
-	bio_chain(bio, parent);
-	submit_bio(bio);
+	bio_chain_and_submit(bio, parent);
 }
 
 static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
-- 
2.34.1

