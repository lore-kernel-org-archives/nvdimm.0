Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260A033B6F5
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713097; cv=none; b=tFXGR6ow9maKST7WUTlJFyQmHY+ZYqY1iZu+AJYMPCa1DZjrGHrS40BFOrrdxWDxWMBb4viZ7ehY3A7sqQa72BercAW5Dy6PYtnfypzIxTP6cAMBIGyii/NrQDxVRXOhkDiAxSCihFm2dRB8vjyivL3IroSClwCcLbOHL2tK77U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713097; c=relaxed/simple;
	bh=ERpHvRnw+l3wstR+WAIvwtnoTvXWleFvGGT+ROO3fSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=INm0wcTTC4syt//xHGHMNzrhGmlGvT6yRhzmZBQnPWV2lvjUA2lJsvm4RSCqWEq/IPfoIJmwEpJ3AshUpSN8tTFD1J2c+5ZMLSVIHN0E33CCwCPfo/jWb9hvPEWpIx5JDrMNMH4D2Qn24Xew5/9trEKAkiv8YeuS+65U4ETDoJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bzrvxciq; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzrvxciq"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7baf61be569so2054276b3a.3
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713095; x=1764317895; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1V/r9ZPcuPpDeS+hBrkkwoFJqMj16O3RGCN2/vaCDuA=;
        b=bzrvxciqo/CnwlsezPt6oLQQqLXos5pkXOQx8mW4vyTqKzcpJeNCKQepdZjvw3r5qh
         jEvF8x1lnKeTaA7AP9xeb5UISIi852pSILFeUVo8vb6mi3nWCGs0U+87K3pq+d34Tg5B
         x8eYtq21Wxj3uHvDpQfp8BVwp7sjpJumzd+WtdZneZ2ck2SMY2YgQfiAb/koymStrQgy
         To164Gxv5i51wgsoPtD9iRqqPgHkmQPZ9cKWK1+vocZVXFGpScBhW+HGrS5Zn8jUAgp4
         OrxfubssrFxHv6V9GcLIPitkaclsGyvU1jvevoGznuFM+wOtlNmOjOjURVuBTUbEfgy6
         /KpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713095; x=1764317895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1V/r9ZPcuPpDeS+hBrkkwoFJqMj16O3RGCN2/vaCDuA=;
        b=fOntR9Znaagw0kRRdp571G75nmwbxiTZpgNa4UrnV/KbU3CkcVJXJzuMFAEIp51lGW
         YoDLQYjWZhtNau+WPZvM6J4IhssbC2Zubf67XR73D77kbeOCvFgTsKMA4V6NxmU6OY9R
         rX8RkP7qTkV5e7/JAeLqRucOStvV015mR9F4WSjgV3NpAdo8nE/tIiZkC5r6CtMSBma0
         BQtzhftuH2czopVpUuLep4bxAUt4oq+GM+aUln1LOCIoA5K+owvo2Mflnivf23kTK9GH
         8AhqkchNNQkwhiVRha+MR3yM1WTjkcciZguYTkARj9vUcM38QLZU5tA32TbwoNpoaVP8
         SKiA==
X-Forwarded-Encrypted: i=1; AJvYcCUwv5PM+BbvroexCZ8TKgm0+FqHNiT8q4uvGfFS796FaQjguleNtc9+A7UpQ4yMg5FtQBbVqao=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6YzdtDeXmR5zjsXtuKUjeQUVIOw6zQKc+IiNGcRDXHfoGe9oZ
	ak0z2gU5DllzO3GFVw6jv64GqLb7r01wQKk9psFu5PWS8RvJBuH6qHjc
X-Gm-Gg: ASbGncucY/hRr8hmmV1jVSXglC9tvTnYFGCRI9ktV7KYZzQHdhoJJ4FO5dIbcri6/tY
	wLcKBcSf0sR5VX3UkLb9g0HTegBtmEns1zHxU5O86wqpdkbPpLO86OKb5SjFNMJ0b+zvAzs02T+
	e6oW7GxHaiqBrbrGmI+RIXvEoOncZvjZK3olaDV933fTl5qAoaVAKdKmFjGyRM76KlO1VgOsTAJ
	pngZuEsQzfrbqh3qqHxqieB89NaW3GNVDjbJE+oHZH3sMLV+lymyiJSG5FJi1g+o77B37jxCOUS
	WV4WAriFSuIy0VuneZp7DSQEECvUwOKDlfuLNI5gic9ckgS7j0xfgWOy34X+nuebH9NKHDBq7gd
	4p91A14SybncPpPT6fMp0/i5RsPTBGsp4SBUkHKkKdO30P8jCBpHpo630fCN7oD5+GiPxTkPYL2
	VqjjZb7oqHThif7Umb2d+ikw4d8Q==
X-Google-Smtp-Source: AGHT+IEHu/E6NqM3wgnO0PzNJHfm7ylIJ91XqRa53EvuqqhyyBcUb7YMg890bib+mDDMVjekZVw8IQ==
X-Received: by 2002:a05:7022:4419:b0:119:e569:f25f with SMTP id a92af1059eb24-11c9d70b0d1mr568161c88.8.1763713095153;
        Fri, 21 Nov 2025 00:18:15 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:14 -0800 (PST)
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
Subject: [PATCH 3/9] gfs2: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:42 +0800
Message-Id: <20251121081748.1443507-4-zhangshida@kylinos.cn>
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
 fs/gfs2/lops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c..c8c48593449 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,8 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
-	submit_bio(prev);
+	bio_chain_and_submit(prev, new);	
 	return new;
 }
 
-- 
2.34.1

