Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5115733BBB9
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 02:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774579991; cv=none; b=USf/ya0xmILNxGi7Hj0DCIYjE3jiO04haKXjlB74cVRf9/h1TaJfpJBIQI1wZWkwTNf4KQi1SbjQZ7rHTLis4xP0lilaaxx9hZ0h/Rj/VgdseKHjACrHz5tV6XbBtSABuHJpd05R99dczx5vFOAifzrOXgGnqZrlnifmGjMt7Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774579991; c=relaxed/simple;
	bh=xl8Yjtsmf/LOTxnNIp5Gj1vMxE/NDSq35Ka1d1Gh+I0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y4Bko8KDSUAvCMk6vhlQ9vTWOFZ1mm+/1WBrTY5hL4sx3NWLcc4IxZgZiP8N1Ch1iO4bFnTlbhz/HxCG6Xs2d2gzoIgLql+ey43uiX1ZdaqFXmuIILLj/2gQ86kjTxmql1yHSl2VX4iy4UDaJofj1ByUUxBukZTaccK8iAO2cBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=opGt94+7; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="opGt94+7"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35a1230c60eso793930a91.3
        for <nvdimm@lists.linux.dev>; Thu, 26 Mar 2026 19:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774579989; x=1775184789; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=avGTCAkGqpe176u6UmBj7ABXLWeOPjmdqkyMCsgMSh8=;
        b=opGt94+7lNndRd0tFNVNbZ6AvRfBz/E7/a7T+D224bAhEM1PXdMYBqGLETBNEJFDek
         6eFms/9OtIsEjrG2sGF7wylkpE8gbL1s8EMCbbJaX6eJaixTGg2XgpQJ0iT/qqhbCplr
         hXnb5UsagP8QXcwgHAdxfdoIYtswVpNuTNLdRq0EfsszUZ2Ac9farhqHx+lYSNsFuvU2
         FNdGNaBGW6KLsybFQv7JwepS1cEkUL3iWKsFkoKzaV4MciK5GnL6zFeuB25sHnT5Dag2
         /FhRdiwn/+wTq9d7FERwFR9ZIgTdPBsG8VU7OZPUCK7u/i0zj8H+5W4GegBAcf6svfJu
         WSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774579989; x=1775184789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=avGTCAkGqpe176u6UmBj7ABXLWeOPjmdqkyMCsgMSh8=;
        b=PhFUp7Mvb0ZzzDWKD77snV3GHUv3GDMqg2lh32168u3r7L/FXi97Bz+nTYqEtQubiD
         JtWnqgg30j6H5t1DnlsdF9eR4HwZ1h6rjtvWTNtexVeRBKRXj0sf5LpUzsi6WvbG2EZi
         MOqJB42Jt8UrDTxteWOMi/5+4gA7I2eUIo8yZimgxjevBZ33bxiwj8NZhPxaXuQ+6DCU
         ByboX14iSluEV/cA7TaUok0ykpdbs8ySv7C3cYnEwEGjXZAkug8K4cdb+1OflrMx9uxr
         Fm8r4jMzVyoIrKYaB4R5lan/ogPIfHI24YoU3XUn5LI1URePlqobUxYyLYYRUXDugEVq
         k2Fw==
X-Gm-Message-State: AOJu0YxT6nBEc8hKV1jOCzd99qoPKj3xFHGXjI/FcJN1x+N9yBRYq+JA
	480sK0G1boSQ2JTz1zoHPDn/r4ymvKi2AZdWx9ZzzRcccR2jZP38f81+odE0/Rp8
X-Gm-Gg: ATEYQzz4bDGVt23yQNdlFilTWYQjv0qMz3HfZJnOivnRBreqgA00HcI0jS9moNis7X0
	yU3H2ttdJ+QFkhz7wGBgI3w1zqzD6jhErablxOu+cJgxcZ9cgmgibj5uAYWQyDU2UybORaf3J/n
	13TFLvWtF2aS+p1mgEdEJzRGHs/iUmCQBFrDsgkDKugZ6JNpjG2ODDhHKmUGP/1qZdEF9Re80XS
	EnsW2KkhWemFT7ePiGVTbeT+e/9Tmxflsuj3ukWEBKq/UV+Kv2mjgGDRuX72KXy0GWT/qmqOXuW
	Xn6HGOpKX6vBCTlT7BcC1LQEGWKcaBHcMnI3uOpURbZh0+lqbdSm13yNpLTOCw3lkZzItt3VbEb
	Jh9I01drV+33dhzjKUO5FvsOP+84zVSsaxx7trahEwfnkDXo4hRFXrEPh5prG0bGBlqXXQOf7WC
	W/xs4WuCekLjiWHDzVLOv2oewn0Wd1WHRvILx9Yagbzk8ppf5IblPeqng=
X-Received: by 2002:a17:90b:2e83:b0:35b:a9f3:62ee with SMTP id 98e67ed59e1d1-35c300949fdmr953818a91.27.1774579989424;
        Thu, 26 Mar 2026 19:53:09 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22d8c26asm3644515a91.11.2026.03.26.19.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 19:53:08 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nvdimm: use struct_size for allocation
Date: Thu, 26 Mar 2026 19:52:51 -0700
Message-ID: <20260327025251.7688-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/nvdimm/region_devs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f..1350a34a34ce 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -104,7 +104,7 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
 
 static int get_flush_data(struct nd_region *nd_region, size_t *size, int *num_flush)
 {
-	size_t flush_data_size = sizeof(void *);
+	size_t flush_data_size = 0;
 	int _num_flush = 0;
 	int i;
 
@@ -117,11 +117,10 @@ static int get_flush_data(struct nd_region *nd_region, size_t *size, int *num_fl
 			return -EBUSY;
 
 		/* at least one null hint slot per-dimm for the "no-hint" case */
-		flush_data_size += sizeof(void *);
 		_num_flush = min_not_zero(_num_flush, nvdimm->num_flush);
 		if (!nvdimm->num_flush)
 			continue;
-		flush_data_size += nvdimm->num_flush * sizeof(void *);
+		flush_data_size += nvdimm->num_flush;
 	}
 
 	*size = flush_data_size;
@@ -145,7 +144,7 @@ int nd_region_activate(struct nd_region *nd_region)
 	if (rc)
 		return rc;
 
-	ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
+	ndrd = devm_kzalloc(dev, struct_size(ndrd, flush_wpq, flush_data_size), GFP_KERNEL);
 	if (!ndrd)
 		return -ENOMEM;
 	dev_set_drvdata(dev, ndrd);
-- 
2.53.0

