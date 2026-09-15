Received: from mail-pz2-f13.google.com (mail-pz2-f13.google.com [74.125.228.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B348821F
	for <nvdimm@lists.linux.dev>; Tue, 15 Sep 2026 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466197; cv=none; b=Vs27SKcpSNX4SUHaKXmN94UjKzLc5psUZ/Ln45hzWHQ36W/oE2Kwto7uUmo1IwadsedDJHl0XLZrzxNolsk69il0ocz8uekT2bHUr4dNp2DZWhq0KIRE7QtHSi0T6+gjhQzIwatm1WW1fsldPXwH8HD2C2GsQsHzrXGq0eNmlyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466197; c=relaxed/simple;
	bh=0ldLI0jIdMK8AiSGipfQlJFMXUeME3rzoXRpb5rfrmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRvwiTL7JwwShqF5Qj5PGdTHlBjSvgH3c6T00lL29HtT3tkIELv78S9zlbwqF7XzwL1ej+TE81i5AyS/vJN/A6JSkFx1YtTbbL0fH4TzjzrDoDWVHQhN2qzLqeSf3A6OGk0qCIJK4E1p6uemUMKtqr51vqWhPzpS5qqdvRx9TsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=EsouPPij; arc=none smtp.client-ip=74.125.228.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="EsouPPij"
Received: by mail-pz2-f13.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so44771a12.3
        for <nvdimm@lists.linux.dev>; Tue, 15 Sep 2026 02:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789466194; x=1790070994; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvp3AKdBFRuYXKGE5C8H1XVVcyDgnt4wpE1IB5bJa88=;
        b=EsouPPijPlkbrylXWnKKqNErQIRT05f0ZNNNiFttKRH1iZDjE3t6oyougiSqRkRTQZ
         vh/cFq+T8cUZdsrPGVbHyDsBBTOE8rVrG3gdevI4og4x93Qja+Xel6zeUHCQbC7hwAx8
         m09o85F0UNiMupdoAslKZqfopAO3E1Xf4JktZS4qhZHVUH5SzSMhaBXDsou6g7gfbRPY
         liqEQMvpwXVEh74QXNeb08tYwaSixW/2GgyJPAvLB1xOCKDFO5kE5OILw0DnmQ8GmOS5
         1qw2ZlGxCm1QVi7u2ULAgK3Le1OLlIZXGq9jAAJHDzCD5dh97+oHW6DToDV50FEE2HgA
         8h1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789466194; x=1790070994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvp3AKdBFRuYXKGE5C8H1XVVcyDgnt4wpE1IB5bJa88=;
        b=J6gaJLJ8b1p26Wh6HRnnYUykFbGkVSh8xcNp6s2f9phnkw07HCoIUyP+7xLLB9i/x3
         Wlzo4XNdJ6Jro90r17KCW85wShyEi5utjVnxwstzZ05fKPp35r0ntQsbhvGc16TfDm6P
         M36jpWR9H43H4+ipLoOAyiSGimfy9A+PgCGiJitdDdI2wysy2FK/T+xukWHPAubes33f
         302xphbmxmQu8b0ce+M5U8AhJ26BZkucmMu0LeD0QAsl529POW+1K76eLGzW1EZCeYBp
         lEuWpX4UYw3EXLyqh/fn/HRVzw+bmwb9AZ0bF3Ux8UHDhxqFLHEzO5xXO2z2XJJC8OYY
         /7Sw==
X-Forwarded-Encrypted: i=1; AKwUvBxnyzUbb/nPH/md7ZZmBWhOPkY9O3Q2GEx0hB38vF/SDC5ujWFdKxkYlfJBuyva89ZYBLDP9ro=@lists.linux.dev
X-Gm-Message-State: AFuF++kMjGRq1dB/GGKpcQcvfO4IVqGF20eQp4fIc7WjCKysvWVQIJuT
	yKGfJ6hEGjdRwWi+/uwDltwGotlDvx3cH5iwKIUJgrM/FVzS1ClWBW9VWJzs3tKkOKE=
X-Gm-Gg: AYBFou103n3BgA2Mzu1S9eqNCvv7zZF+aRVKEa0Dpyq7vK15YtonoLvCQo5cjl6Dd2e
	rJIoONvuDtmzKvi/4IDyD3z89PtPf9lPKECvqntEJOgnmhXK6hKswa7dKOpeZCJaAuJxoCZj0Gy
	xs2tTiWniF9N68Y0N/nr0sesCyPhoO2hqwYQ1iqHl6uLHe9t3k1cEYqmW6r7FWCdreqGOk9N+L2
	YyE2P+zKsBjAsmk2XJCukiXNPGup+zeVCU+DiII4TJMMtTzf2AkilZm+psmlwXHruoxi9oBPE/2
	17T6LC7GYCdtH0mNe+mKOj5wHAObrkHouWIyKwxn56hR/t6p2rtHsH+SVpbZf1J/YKV49ilbbDg
	7EQ6IqqE/8kXgZsGRqc2a09z2pSQJI4pW0FNq24yV/rqGzEoe/qo1JX42Zg+CVhnq6z5weIuuJq
	ca/4zdC7ptIR2nUE1uHfQlXxJDu6ZNTUVTM2BKpGo38lSwD2f7Yh1MeK82UP58wv9L7fpgvv5Xy
	Vwmaf07QeI1xXj9ZVNU
X-Received: by 2002:a17:90b:2c8f:b0:398:ba9e:75ff with SMTP id 98e67ed59e1d1-39e1107004emr273952a91.21.1789466193983;
        Tue, 15 Sep 2026 02:56:33 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfd6b9687sm4477827a91.0.2026.09.15.02.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:56:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 2/2] dax/bus: fix mapping attribute error reporting
Date: Tue, 15 Sep 2026 17:56:21 +0800
Message-ID: <20260915095621.3744167-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260915095621.3744167-1-songmuchun@bytedance.com>
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the DAX configuration locking was converted to rwsems, successful
lock acquisition leaves rc set to zero in mapping_store(). If the requested
range size is misaligned, the allocation is skipped and the zero rc is
converted to len. The sysfs write therefore reports success without
allocating the requested range.

Call alloc_dev_dax_range() unconditionally and let its full range
validation return -EINVAL for a misaligned start or size.

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/dax/bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 54e4bbc98218..f232001ff5b7 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1276,8 +1276,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	to_alloc = range_len(&r);
-	if (size_is_aligned(dev_dax, to_alloc))
-		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+	rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
-- 
2.54.0

