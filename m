Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793383889;
	b=qA1Fb9XR+kQHtkftvA+HsJYRiUOZrgn9ynJoq8uIbO+4n9WkphyjVz+0hDy+SjDj5loU
	 BtyNddE2uNsU8069l0yH7JrN6oYCu17yAFRUnO2qJXh0pTLB9LErgsRi79Q/HgOLe8+a6
	 VRZKeT3OrpNLHX7KhDcFAPqnGoG71kYA/LVYeogXD3Y5TJgNhhO5ynpTffEfTvaoiWSAj
	 XIkteozgU+XyoYZRxisY6fWkYfjgk9uo9w5u29gyjSIxiOS/Nl3xMPTc06ezvzUGBN1JP
	 nuO25WYPpe5WOtXig5k5munFJ0ctveFjVEnDLEznMlQvpycPYJ8bXyvcDyu9r8fLvPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793383889;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TkCDMgI0nYwsnZMbQsOhZbm/PIle4lIzutchhQauMqU=;
	b=5qzkFlPFcHYcDq+nZvXirXBezQhP+AbWQuVMHgblFc/DP8yelcrvV3AJAGB0aMN2QbYA
	 XoW9GpbGz6ZT8tJzliwUCQ7JsLkdjO0SWOjKv6e/LyE9h5lHGa6qt1wR7I6Q4XaKLqjly
	 Ajo0ch5uN7o3YL6o9W+iwom4M/QjUlvUPZa91ZeFuUpgAeW74MP4HnRj12/5pLjWjVLcn
	 obW6okHmmr/x2UaEcdyh2Vp85p03x7tKwd+/YIiWJf8RwQk6C/BfEkLlrUH6lYTFw5RQD
	 ogLr+sOB37n2/Do87rSOx9BjpX4shSCZbYLDRMLJL/JcjRL5hfQcAGJogmb1N9GTBmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="P/OqSI4u";
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48443606A31D
	for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 18:11:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48443606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P/OqSI4u
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so568902f8f.3
        for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 11:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793383887; x=1793988687; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TkCDMgI0nYwsnZMbQsOhZbm/PIle4lIzutchhQauMqU=;
        b=P/OqSI4u7KaWHCIZ+K0qOGTlgvrl0e3Vao70cI8tJxz0QtUcUFxiEq8GSfoJkFNiha
         nEwARcqQBHi1kFZocZBWzqNpD3HSBKGZu+M9iJiDrGnrU4v8JB/hVcDY93FxFXiZcu81
         4+v6CRKiquftIQs5cvbZYU2/eLHHUcPTkZ6b0dQnBDTiftQdHQeuF+YmquIfbU2/i7nJ
         eW8Jv6AM442+ZLMAH2lQm7gCfj0RQjvqUfiHPWP8xIegvzMuVXNJyuOe3isjKnA6ZnKt
         MAan2QiC4nQ+0+HeNAgoO4exl5qRwj537I3VBoJzlIV9UHLKujK0NIj7b0gT5mLmpUoH
         Cyzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793383887; x=1793988687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TkCDMgI0nYwsnZMbQsOhZbm/PIle4lIzutchhQauMqU=;
        b=FHXcI5CnoygVG3LaC1iMltWyA7jrxEO0jGEkl9IxuSovEwRRj0A7gdqhxacRf4cQKv
         DC0bigsl/WkcTYBKLOjIuwPUWeBSspUdlnM3y1tqShVXJcWS7Mdfp/rdTqR1qfkG6W7b
         RrQyfQskUyvbojzHO+qDN2diwHvkZT+Fcuk4Jl1/XV2gSOnWdlgTng9qIAzCJU4BrJIV
         ODk+iUZJIhjuLEDMHjUItZX4aWKM5PSBLFmVC10cs/z3IvDj0G1I5Z2lZTg/+ahFFAk+
         gtbnUo0IPtiX4TaWC21nbL+57pXBzSuyZzy9cgAsKzotNZtM8r2qgn5D1NW0Px8SC3Q0
         I8Pg==
X-Forwarded-Encrypted: i=1; AKwUvBwGrJF7IlOCP0f8jb9CxEbnd243H+rtDwynMBG7akO+3lWugS59FLmkfbz58uccS+Nr69rRFhc=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ8ZRT4ZWQsdVAjsZoO4tvDDJyeCJLDQvGOhty/fWKxzP7m3630
	cMfp/7tUUOf1BnDIKWu17brq4zrzBtfPFm5dFqITJlrMo5f5g7p2AP4iEjDyKMVA
X-Gm-Gg: AYBFou1qwiu7HTB/+68I0CH/Vhg2QHcN/KvizeJNrbEneWnvXsx1qvx5o2dXvfn6W+h
	PcJ1vXAJqoY0Bgea+t7AcHGZJDcQgYRKxAxqFA0/BLSq3bRO0w1a3iOqIXhC+TRnAJCr/qrvWCb
	41m61tEkoy3Lmziv/Cv+DyHBcqQkUGIYR8p9OuS/1BFfgkO2laFAZyt59oq5a0dFGR9KsC8aGKF
	R89JjBI2uyIlGG9HPAYSO89rcmk8qqQaVM5L2C6kSwLBlYTCQLG+djRKQpCnc/OZr0qzLl/sNRf
	wtx8yzCV9RJ+fAt9mYUqpOI7F3CdBZXwu19g9TWIVBRX/j8RR6XqPvKF8K2GWjUZ3DX6AhDCZrw
	rqedELleLt0lF59u8fIuHFiRViXIcoYwnLKVi34UDAchnrDYjyAXgv+J+3xFVyodyuWZKsZM/tw
	T4wgqLImcybN7bSoXSpr2iZrkJ3b4rglupBLBa0iJ/IYghsLtdYop2cxikhFrj53ZnmmuQdeXKm
	s3XFRp4TDKS76uoN2UPXHJR3PImYjMu7dRJ/hKFp8d+6U1FeTae3BeqNawU4OSjx+W2JC51CBG5
	bcmODzdsyZJ3freLxKhkxOGP3nW8xjfhQ3ZPa+7tutXLuA==
X-Received: by 2002:a05:600c:8b55:b0:4a3:59c9:a744 with SMTP id 5b1f17b1804b1-4ac17191117mr68137095e9.7.1793383887412;
        Fri, 30 Oct 2026 11:11:27 -0700 (PDT)
Received: from localhost.localdomain ([2a06:c701:4773:6f00:2e51:6545:bdeb:4fd7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ab69b54742sm192996575e9.15.2026.10.30.11.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:11:26 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	nvdimm@lists.linux.dev
Subject: [PATCH] nvdimm/pmem: propagate personality discovery errors
Date: Fri, 30 Oct 2026 20:11:12 +0200
Message-ID: <20261030181111.2614274-2-thnkslprpt@gmail.com>
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

nd_pmem_probe() ignores errors from nd_btt_probe() and only propagates
-EOPNOTSUPP from nd_pfn_probe() and nd_dax_probe(). An allocation
failure such as -ENOMEM can therefore be overwritten by subsequent
personality probes, allowing the namespace to be attached as raw PMEM.

Return discovery errors other than -ENODEV and -ENXIO. Preserve the
existing raw-PMEM fallback for those error codes.

Fixes: 8c2f7e8658df ("libnvdimm: infrastructure for btt devices")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 drivers/nvdimm/pmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0766a6949b28..78acc9b0b1a0 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -632,6 +632,8 @@ static int nd_pmem_probe(struct device *dev)
 	ret = nd_btt_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
+	else if (ret != -ENODEV && ret != -ENXIO)
+		return ret;
 
 	/*
 	 * We have two failure conditions here, there is no
@@ -647,13 +649,13 @@ static int nd_pmem_probe(struct device *dev)
 	ret = nd_pfn_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
+	else if (ret != -ENODEV && ret != -ENXIO)
 		return ret;
 
 	ret = nd_dax_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
+	else if (ret != -ENODEV && ret != -ENXIO)
 		return ret;
 
 	/* probe complete, attach handles namespace enabling */

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.43.0

