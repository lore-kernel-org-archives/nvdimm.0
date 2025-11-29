Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9728469A
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406931; cv=none; b=K5SGWfpiRvshSJdbaoGv2tqIWFc+ewHby4kIbJX638Xz76TGgMZPf4YY7lMBNDVICabf+1TN5If44FMAX4uZ5T81pgQulg4vYT1L+GbGg1MoX6PB05iJEBja3n9bYc3f4mDLrByiYYeyrZBDiSEnH0G45pli/XV7Abyq2TegONs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406931; c=relaxed/simple;
	bh=FvdW5UGbfZbg4/JUFTbGCNNccxPDUjVX1PnGr5SdWKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CnLAe3lvUg2xXS53BVJmGs5dqNSpWYT+O6LozjxbCI5EJLBGvIiF3ob0yLvL2JQtb5nSWmz37OXXkeg8fCTSxStdxXkuCRdBEW/Bqo/A9protwcGlKspDKsLeqIJ3+uHyhP4tKcwJEITDH4vzjEoFP7fp8JS7zOhhwub06hAcNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sut2w6uG; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sut2w6uG"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso1910733b3a.1
        for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406928; x=1765011728; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=Sut2w6uGhsId2Yk2OtlET3e6SuiWi3wlms/Aov+int5QuSVhkIXpu34Ckemd8b4Tas
         C2Vdyj8S0X5eDm+hwbSCmJSQQF4Y9UfAOMx1yVcb8oXDwSDgU+WgkO0vl/oAEpUnwHdb
         otl1J4G+tKyPA8l35Rla+YcgSI8qNw/1j4IBxFFsHgkUMeKp9vohV8JwnAGICgxEJIaH
         RclDbY+vEffp5mLujhm0DIrS6LZfDWWsi4Z6ltKxuJGOhyHsz5zyOCfYt7+sbxOdoDcZ
         NnC4Jp4WmH75tUBCrn3jiKpM1G+rWLnHY4cRanI/atrElMqEPkjyqTu880UkvEOHdyvq
         WRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406928; x=1765011728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=Vyk+CDl+QblgzE9/eLhAumUDdT/Xgc/+gU62heKT2itrgQxbSYLsIRBVbemobnqfwH
         nf/9myl6TZ4Y0WIJsNWIpBDAiGtqX478wcVUIOY1Z1z7BXSfqctfBTwwJ1rj3pnGGjkb
         bzQqLnPyAJ/HK4202M4Ab+MWthFwgmvllaunqscZAgvkfhNuxVu+WlNmw3JzWaxdV2UE
         Xd/lE9S+kmRK3UQ49ChEX0TGKY9m2SIlth8c95WGBCncIsfnaFCsvgwjqSU+gK6Carqb
         neMNYeYtBWjP5WdVtj9CMk+pN4RZIuZxn/vYkBSgl1sAQXzf4vRhzFKHRSzKXG9jgl1M
         XpsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAZFePEn01ORZBt//d9tstxcRt63eu+fdWIgzYETDkxLsUryOzvazphk15mwhhIMkDtXTTSe8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxgqn/F2cE4nCc+kDrmspbg3K/qRN6Wnl/nw4fAmmPbj+RnC04p
	FpwnPpu4i67Wcrd3wTAfHIDzTr4Rl14/Vmud+vIJnLHPaAilfB1K4zcn
X-Gm-Gg: ASbGncuYCDmqiPYw8sm+8fAeyl4GgO0dfecuw5ibk2EZ/3H5U9Nftmdl4+JwwHpau7H
	4LcoqFa42oHkxj4wwH1W5Edo50fSpOmzbRwET8sqxG8Whr14kOC9tZWzm+eCvqR7M4W/OBCkROz
	AS0a1qOzPsUw6yUKs8NS1uEbipmNfYOW6B0nPo5IFF3U7AaTv7SzIDDvNdwzGY8xrIdyVr+cGaf
	xsXLzivxzc+rX2xQJb2g64ne1fvM6VbLg6VPGuwFPp4hLJeW0W/r2MFm09dXQmTwnp6s7lljfVd
	gF4LFES/2w2xQx1SfYqK0sK7mkuGqFqxlMIptiaUcG3HVK3lz9q2VtQwjQ4kLnfx1NHWIpoFno1
	kIiz7XeawZYgkEf7yZhCZak51SK2FlOQQaTLEQkJ7VUfRrfq3BW/SfuFXtlEOo13AEqLW4Q0bjC
	w7tIp2Zh4PYVhGKErFvedEYvoOpw==
X-Google-Smtp-Source: AGHT+IFpam2VF00mu2rmyIi1m2lRR+Kb7w2Y0p3kOg5DIMgR5i6hM310V7yybDkza8FyIBCJgjbVWA==
X-Received: by 2002:a05:7022:4186:b0:119:e55a:9bf8 with SMTP id a92af1059eb24-11cb3ef2761mr13917973c88.20.1764406927773;
        Sat, 29 Nov 2025 01:02:07 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:07 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 7/9] fs/ntfs3: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:20 +0800
Message-Id: <20251129090122.2457896-8-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
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

