Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793809135;
	b=cGRfTIeEpOLw6+P9X+/zNZis9bu9Ut+7uGDi+LyMmzV5JukeRjMsw+dCaknnyAfiIwQ0
	 XngKIol7ZwiR2dAQR6L1dBBwXb2oEBICCt3yxIGmqGtam6tt0kMKoSbAcHJ5dtHPSaK/L
	 1W53TWuJAsPVU1RBIqjdZcD7169juWGFqWsZTHUozqPs9/bUoXlu2K7WleZkMx2y1fXJ7
	 ncFiLA8McmYl9rlNx3cIU6qOXk2laq00ek5Hr2RxiPSvA58ZMqhqgF+7JhX8X8P6BWCRC
	 xHHKqdhcc6Z21l8FAYWkcK5PJJQEXkx0ETfqWulwed1GAWrszFF72Jv7ndEssPFMDnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809135;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=M1hCDG4NOD4S35LqwF3S+gJOTx2TfVlPQ8MZ6qz04uE=;
	b=BTdGBE+tN6hBPm8rHWTmCCF6LEbZj+V/emWdRj+Pyp8PakKBfuaK7G6id/G+I9E8lI2C
	 gYdAUbT4qzswNI0+dCPfgixpMtMLmUCkmTXvW4XDumoIy7sRrxPQbXMii/mpzb0xdoBtN
	 oaw7m1QQRmF+kDyZ7+7n/mBsmEK3qLOrk4XGO7W+sj5Iv7UZpdVnnPpWPKdFi8zrMCUOf
	 YOviFRl2JBoyN0tQVosioOPYZIQyCPlwnP0YKPesOrkGwLkYS/wG6APQp03fO2uyfs8oy
	 M+grqmhYxSLW+U0+U2SuL0qKUtHGgx51lESysiEjALlNUX1tcu4yhnGFzAPKZPWUe2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X5IDnKCN;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6019606AAC0
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 16:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6019606AAC0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X5IDnKCN
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36d6e342f98so793045eec.0
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 08:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793809134; x=1794413934; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M1hCDG4NOD4S35LqwF3S+gJOTx2TfVlPQ8MZ6qz04uE=;
        b=X5IDnKCNdWpudAVGX1c8Q0PvCTr9UdkHd65oG942q0vPoA8WSEsmJ/APubaMc5OChD
         G0BwqYSI8tsNBvgQb1T3eyP+9xg2Yx3+QHO3Vb1fjlIacccGstdwW3SGyqI6+TEDc1BN
         8tiH7AGWszNxF2ZimRp18kqUc0lJLGVINEn0+1rl8WDuRAedjqKF8OJG2U3lFSp0rSKd
         gDEFAKALXp8s61V9xsmPfswtDxWkyQv5DO3dvczflkDGDqH5UxGu78sRKcsyrkuRGnze
         YtxqtMJ/whYoFTr1Vlz5EA1qn7X7moesT+X/RNAIkooqpumhqhkgSM5iRMQzx3a2Ck/p
         BWQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793809134; x=1794413934;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M1hCDG4NOD4S35LqwF3S+gJOTx2TfVlPQ8MZ6qz04uE=;
        b=tfRJZvlT0PMAKLd3U9+rAAKqWru8UvXqqLESFoet/HCfaTgJ8Y4ZMxchsUcQcaKsF1
         Aak4ou+tgg/uBgj/dTatfOAjKeROp2xB3tis+oxcKReQkSQ1chWe9wWD9awsltLNNJOg
         OSRXTS11GLshZFfkrgt5ISxPZ+o6DqUAS0tzsrQz/ZZRFCG8PyjtMaQEKvCnfrLbGM9r
         1xaLSCqOrJQN8W1kGH11JVBWtIftMR4DMoFVCfYy5ki/U5hVfESf5Gb/Cn+QEAdqjAja
         dzxj17RlZhrYutcTs8KSVluwl80+AbH6iLqLZK4/xzWstxDYl79EwSB6QtHzl6K8Ja3K
         iIug==
X-Forwarded-Encrypted: i=1; AKwUvBxcjqnRSy/+7MUow5c2tIIsB9jjawK7ueURYC8FgUTe9SNzmQWKrtPLqU7k7UpJFMq/VMsf5AE=@lists.linux.dev
X-Gm-Message-State: APuU4Z8Hy8su/uDv7rpDcQGYwePojGf57xFpVqa10i1HAzgkqQ+VRUim
	cgdKQ8LvyPEZZc6zGpFicEbLPY0sIyVNjiYqxvzzEQQ+MtmP077n8p5O
X-Gm-Gg: AYBFou3mGZynodydnKf6QMtgBdEgdgWGCWQo9UpMMGKJezayvae9ddEHjFXUv5v5w0e
	qYSxfReOxco0/XnQDdxHWLKVUSNKsltd9HKIh8X7Wn5i5dWlLxAVgcwzWTPG+dynsrpPW8XVZfq
	dg/1UKxIbswjM5h46Ak2pHj3Y1/mk+AaDDfvrkpWqKK1kRk/G91II7+tVrviUYMzv52N2Gx3Nrp
	4Zi+wu4Bj9pvQlGDWKshO635/Zy5LY+ADVqZu6VVjtckLKeaqoOy/mF5AzlVqzTOtuu6rVCEqCu
	67wQxoz0bk84yGLI5qUtiyUnVClsex3yFfCiIowksn4k2ks+tmtY4MOl2cCNp7YUgS57QyP1o1V
	cB9a7D3NwHDyC1N7SUL4FaxxTrBfmkBqLPX66wr+qNHEQCzJ8TQoTBaji3yL/88Pk01TLCWEf1Z
	hyK4KD5gmoyLuTc7hExHDTRXC+tHIVWCpnw+Lam5vvBY3+gysbnyK3TvQRv/5TPBDyTAtupzsnE
	s9PWbG4OZI0SlhGrZI+Ih01XtKyAoYvsiI4SxaWfUbN9uVl9QPGJh0rbo3H24ZRF8lLKtwEQIHI
	AKflsL09aPKwp0WkX9QwDB+66A8O
X-Received: by 2002:a05:7301:e101:b0:36a:1c46:2766 with SMTP id 5a478bee46e88-36a42217ec1mr21526302eec.3.1793809133629;
        Wed, 04 Nov 2026 08:18:53 -0800 (PST)
Received: from ubuntu.. ([2405:201:8026:213e:52c8:76f2:6711:5a40])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38f53a6sm7880710eec.15.2026.11.04.08.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 08:18:52 -0800 (PST)
From: mdshahid03@gmail.com
To: djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Cc: iweiny@kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mohammad Shahid <mdshahid03@gmail.com>
Subject: [PATCH] nvdimm/pmem: Fix disk resource cleanup on initialization failure
Date: Wed,  4 Nov 2026 21:48:25 +0530
Message-ID: <20261104161825.314835-1-mdshahid03@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohammad Shahid <mdshahid03@gmail.com>

pmem_attach_disk() allocates a disk using blk_alloc_disk()
before initializing badblocks.

If devm_init_badblocks() fails, the function return directly
without releasing the previously allocated disk.

Use the existing cleanup path to release the disk and preserve
the original error code returned by devm_init_badblocks().

Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
---
 drivers/nvdimm/pmem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5fb86595e8bd..76e80eccc8e7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -563,8 +563,9 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
+	rc = devm_init_badblocks(dev, &pmem->bb);
+	if (rc)
+		goto out;
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.43.0

