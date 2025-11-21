Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C9833EAE5
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713107; cv=none; b=PMUuCR8uUAuhgoZofqYT1mizpIpbijxj1PZAkBRtRoXkEryNFlLXjHA/C6YZrf+kNoMLvEZLGjuGgiILGu2WltMU4a1F3bYfIRtfWWVMw8BdSKyG5wqjDnBsyx5oIDi1An80KVkiDXp9+2M6KNC6UTcWQlXtO5/w4BNYcKWGfPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713107; c=relaxed/simple;
	bh=IQk4UzcYY75MLGhtAKmFDWXe3EWxpLfeGLiZbBZmOTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ICVkKCgOHQ3zI6B2OLg2+E0lN6Y9hZ6vl/qFVTy5+aqEcAWxt3DT4n3ypkZBSCZyBj49rYwFy7MlW8Coursq0ngwEyA7ci7sv9C6INwG0OH+QmBa7NyNrZ808h1riBd/WmCSNxYNaUEFYZe4UXQiDvGZSwApKK/yoL2KOci2Yh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VNn2zvaH; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VNn2zvaH"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2a484a0b7cfso2707863eec.1
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713105; x=1764317905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9uQUsysFrv2eFtHnu17b6ejhzRgB/BOqXyxbR99K8c=;
        b=VNn2zvaH1dla8AYLvTewYko7Ry4+H1pNkClbU0EHjR4Pjax9W1Z5AeUzKGkGmapwhu
         Zn/eAHO2juPdsB+bdpwRogURwMXs8AjraBZkeEUWo4Y0hBjlpmviRmvj2PRGII8MZZ/W
         02vzTPtd6NbjOs/QdX7o5rEld+t9ZNsnTSSTG6M9Vm+3TGaAfXtITwX3dBqopZ64U4o3
         dQB0I/BumzvDR3g9L+V56HYdYVsP9rWr9pWOM3z5qNrAzwA4jw0CiCGhUCIafLlbJkNW
         sFCBTEoUlAorSrrXs5VOvL9XCDjYwx3SpOEHu05B/XNz8ZDg63tj5kt5NErXdmAqTR6w
         A/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713105; x=1764317905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I9uQUsysFrv2eFtHnu17b6ejhzRgB/BOqXyxbR99K8c=;
        b=Fz+59zgAzBbioz71jzZoj2jLNfGDtBF2FxPHrwY0kNFSBW7Ck73fRZXeAIm4/McUGu
         alCtXo9kUdRPzouA3W9MoFm+YNaovXpQUryZ8HzNKwAplSr3mnxsdAaq+G+tT8mn1jwZ
         6Qr5fmjWq9vwinT4BSZbbGZeBTedLTbM2Yr4iNwXw4PU+R6XhRP1dO2ouAJOIf+W+Uhb
         mjyx5iZF3AViv0GMT9LSJdsMmPn5+a06So7Ncx6cU8Nh74oc8obUa7P/Twr4a+007fkA
         KrfF5DZSe4H2VAU61PrltOK71m4YwWWxOCZY5ZWNRvQ8aSC7TTRy1sZrX12w3iU2RFiU
         uPOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHb5LLKDakVsmDAFPLHZzm5CH5DezVzhvKq8AeIv7UNX6X5uu6XCn6LnRrhpzOLVQ+sMQqRN4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5jLw87i2vF/qTi5l7q9WqlgoCRqA+22MTJfbKgSUuX14vg89g
	m+fubJ0K/n3A4JcsjzvG0E/fXQJlU9ttf2FRD+1OQLI55ZTJZHoLcF/G
X-Gm-Gg: ASbGnctO097LxW7lI/RxTzPxiE5xOs7cOK5VYCSI+AVTZ59EitfB6AHc/VJOgiyTm6L
	+mLg6+7xkibpbkJ9aiJqxORn3DfhTBt8zMO+wGmy5RXfL0zxD4tM2dxD/VsBisjLTb16KW9ad6p
	eIvisHevyR1MMsUJkIgBWcY2BC5z36rG8ieE480kaZFaVPiBCWX6Del96ZXZq3YNb1wg2b5g+7j
	SAFFZsaqoRdz1LzdOqt8VyQcZqMWe5pchneN+TJmLR+RgMCaLO6Ox9BCy6VeJuoyAdw9AIBoLn/
	hVKaPOZc13Z6n79gS/mQOtJyc9xCwXzTO7E9+psq6RUYudFnRJ/uqS+u9uAm0Y666Ra+JbSHguS
	1NOAQxY/SoIOSPjrFg3sf1KF817nymirVtrpZyDIMmHpL+lg5QX22kBaY/CYY+zg0hUtaFfSwzq
	/AK6Lsweonyk8ee+R0AcqxjX70oQ==
X-Google-Smtp-Source: AGHT+IHMz3ddZnRtvaJ/THHwP1wUMl1t1R0JBJZczRRfd42vINt7DVj8VsCW+6dMTczCFjZ0JXIsxw==
X-Received: by 2002:a05:7022:a93:b0:11b:a738:65b2 with SMTP id a92af1059eb24-11c94aefcabmr2003355c88.5.1763713104659;
        Fri, 21 Nov 2025 00:18:24 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:24 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 6/9] fs/ntfs3: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:45 +0800
Message-Id: <20251121081748.1443507-7-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/ntfs3/fsntfs.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index c7a2f191254..35685ee4ed2 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1514,11 +1514,7 @@ int ntfs_bio_pages(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 		len = ((u64)clen << cluster_bits) - off;
 new_bio:
 		new = bio_alloc(bdev, nr_pages - page_idx, op, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		while (len) {
@@ -1611,11 +1607,7 @@ int ntfs_bio_fill_1(struct ntfs_sb_info *sbi, const struct runs_tree *run)
 		len = (u64)clen << cluster_bits;
 new_bio:
 		new = bio_alloc(bdev, BIO_MAX_VECS, REQ_OP_WRITE, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		for (;;) {
-- 
2.34.1

