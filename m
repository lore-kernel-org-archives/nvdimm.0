Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61165409277
	for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724745; cv=none; b=guilA9aIXJU+BV1/gelWT8TGWDMQqlARr0xfe4gWXWRRxay9TbYn9g7HiiIvZerC8ZhS05cSZeqVb1CMNLppVYeGvkaRTma3yz89OPY4OxRBs4/eVldf+PLGkyOG/YXfCUdawUxXwvrD0GVvJNN7e3XW7EIe7FW93tylFnwYL4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724745; c=relaxed/simple;
	bh=jF1efb+ZrlgHhorgaaDDjAX1MA7rXrB1bO2VMnF5pJI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=stWX7dg2gZC6S/2f/eYMOElzlsaLRJpzfc6xtN7+M8vzoWmhnGguNxelg9Thy7WZ3D3NqWHOrGBHjle44OF9YXTTawsox3Tmtk4cMLkA7MP6j6pyMTrjJLIQCWPX9Vp9wemZ2N8321mY1T90gfQTUXg1FvrCe6HxPx0KmJ12+RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvxwCljX; arc=none smtp.client-ip=74.125.227.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvxwCljX"
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-3a51696a650so808557a91.1
        for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 06:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791724741; x=1792329541; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sEBEPrTg9k6NVyRZZeBkgKa7OkmMhAqWYWxj4Tiunk0=;
        b=AvxwCljXwTwXKNiB8N1FjZabYx3TZX400LNk5xczXS1zMPOdpi2wzbpamh/YHf1FS9
         WK2Sacvm6jN/hPOFDUzGUf44UmdkepigjLw8IZA6RNBzhhOs08HpAH6ifZmgCS90/vaZ
         UVisQegQ0mYcGH2VS06dx9X4j+xk0LdB4NLR4IHOTRYc+FFSPtTJ2ihMkHqsDSp6yHGi
         8ZkBjmEP8cyXh65odYNGbH57aZv40QIG1eHDtfcIEW3PawojAYPXPsSnsmODsDZcdMxa
         T1OOfGyCOOweAUEN9w0MbCe6+ex38cdxPrHvnpZ5IdObhQVrJRFVyEhu90Y8a+qPS9Ns
         5bHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791724741; x=1792329541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sEBEPrTg9k6NVyRZZeBkgKa7OkmMhAqWYWxj4Tiunk0=;
        b=WeYd1UmP2VV2pAHNm7sE3wVNxxW/OBQ/2IxAU+OlQ/fmFV0Tvc8ZjJ8aQ83DQNuOaL
         b7TKq4eF5foe1PVMeZohnXhluIfgSuwrXu1EKWfBGggFSZ9iv7J+lakNI0StRjAAbxUw
         8xP/qrN/POYg/LO+av3cAhYMYrCsMAmIHx2ByTyGTtaZ8vv+RzA8PqDxkTTbRcUcdVyq
         yGDteUY1caIgQS5qjBuZ/eMuXMgrwN/86cLlyLyGTsYOn2WwM5FdryLyanlyOfqEkCuG
         8qbtdjRGbIYWnM/RBVpFeTDse/dz46mjHwUJJCiOt84AmgU4nGAiRPhSFxwgVAbXnZ+E
         kz2w==
X-Forwarded-Encrypted: i=1; AKwUvBxNAHqEojxy4CpO00asVMmwwr8Dmsk5OggHuZgFt7NYZmY2QmfzC/KaEo6hnpVQIQcSWpTLTp0=@lists.linux.dev
X-Gm-Message-State: AFq9FYLLzbeVFx9iijiRcqTyhbUmuc5kJzAzYFx2hhx1i97Ctqy8/Mo9
	Snh1XjToPOdcb3o5J5zWRXbMIGGBGp8UQDWWergkzGf6RdbXxBNm9WGU
X-Gm-Gg: AYBFou3Yp5bo3VRGO19GKSF59t1hZ57X1SxiVg/BHlTyWDzV4zqXDjKDnMHh3IORZSG
	+/cVPR5HwECMByZVfV8mOedEjLFSo3RusFlKvVCAp+p28tw4RLDm5vIkcpIr1jLRl4XLVvGa/rc
	oAxAoziM3R9LlKdNX0Up5em0zB1DNTqjlRyucBNH4h8ezBrAxg6TXjchnlulDjf6nJfaSQIaTdU
	freVYs9UW/s3N0yFmxSz9XJrwYrvPD0osLjVHBpJ1Y7Ir7PaxpKkDI1BTgT52Z6cSvG+xOVYAhZ
	6oDeGvAGa4M3fsX6s/YHN+Wc2vlYCJvPv+vzQtfEdSZrPLXvvSm11IpW3o/H3dzZF2JxyKOSSf1
	W1B6qSmzdgOrsGfZiwuW4RThaRSgVoYzy6cDV3pSitSqNoRu1T4gY28Li5yqRww7nCvhv6RTJ1a
	+AXEWU9Q5ypia9zCiP/D/ETJ3RU3NyRL5RSi+alogeaRn1v2/NWFvb1nTYDp8xyXGt29GyXfnoX
	rRW6GGAIJlij0lhRnyL6M0lzURBNam24hQo9iajFusaPzofG00pMYlgi+oN
X-Received: by 2002:a17:90b:5845:b0:3ab:c80:936c with SMTP id 98e67ed59e1d1-3ab3a98f7ebmr5720767a91.33.1791724741527;
        Sun, 11 Oct 2026 06:19:01 -0700 (PDT)
Received: from localhost (ec2-13-231-150-91.ap-northeast-1.compute.amazonaws.com. [13.231.150.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab338676besm7158093a91.1.2026.10.11.06.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 06:19:01 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev (open list:DEVICE DIRECT ACCESS (DAX)),
	linux-cxl@vger.kernel.org (open list:DEVICE DIRECT ACCESS (DAX))
Subject: [PATCH] dax: fix mapping_store() returning 0 instead of error code
Date: Sun, 11 Oct 2026 21:18:57 +0800
Message-Id: <20261011131857.30481-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

When the region driver is not loaded, mapping_store() returns rc
which is 0 at that point, instead of an error code. Set it to
-ENXIO to match the equivalent check in size_store().

Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b809e1a264af..262f97b5e7aa 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 	if (!dax_region->dev->driver) {
 		up_write(&dax_region_rwsem);
-		return rc;
+		return -ENXIO;
 	}
 	rc = down_write_killable(&dax_dev_rwsem);
 	if (rc) {
-- 
2.34.1

