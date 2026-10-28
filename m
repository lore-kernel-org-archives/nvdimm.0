Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793170211;
	b=GMy08+2exk6fSkgNnL358G033IxCtVzRuBdOHTBgBLbFckFYnhkG6r+cs/AkH4QNlkIN
	 ktVgHLpdf3Bqez7Hl35FkXRH64gsTC2hHRKk0guemd2zD86gmu921QC6eh1+A+l8HXFn6
	 QC2Pk+rZMJ3aUr945k+RfmKcqUIOizM+jX1qB1wyjeo+sYQVls0/wh/GIdB57fHVYGj1w
	 2golXQnao893+zhkkUfBCXHosZyDO6hNbMUUVUXntHjeMWrer8TdisfEEWSIU2+hWF/1G
	 lNR5tm+BMiK0T020/iXKfSmSHBkAkoC34oBMs8xtGu2EVFc+wVyWhMiBh+/LXlayNgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793170211;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sFhRdI8EQ8MK0p+CW7dH/qNlkXIP7SsPBqhbqXWLgo8=;
	b=yN9yFtPUFRPkZb43tsBad69uEbShwIajemkNRZJNTbX8i76Qm44qaERU84Wpkc4TkOF6
	 ys6jcg5X5tcDu25Z2gmFOFSG0F0FcrDXgEfTfcqRmEU6b4qbjBryKVsmFvX8i28tc//ZV
	 f0UqLFLwL/u9ybdUwOBD4yI1MRCMaHcIa4OSBIyIhHQYnVE/pABDjEjp3T+Zqf4cCDl/d
	 Q6D2guN6cwLOzfF9qMXAfRA+rIGeFtvjfB1D6nGuiDumlAnLd0SkBtLqIUpx2GMMGxMFn
	 NRhq+87D7WX2DGP3wa9jQkil/pK0gYWKn58a66nh/2dMDUBn14LuNyEthDfnL4fYV+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CsggMyLS;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4AB606A31A
	for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 06:50:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A4AB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CsggMyLS
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso388299f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 23:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793170209; x=1793775009; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sFhRdI8EQ8MK0p+CW7dH/qNlkXIP7SsPBqhbqXWLgo8=;
        b=CsggMyLSZQ4U0mPWwWKCno5qx3COlMfcO5N5i9aHyxVbhSxV+JPFCnbRr7OVMRxAM2
         FbrUwMRFGjCHKwx/hr0OotTlv2MLnO9B8EfFpSyIV/z/UYYQIGEW4bnGgfPYrBzRdTfj
         eNtVhTdg0L6ivJwhe3jRndVMAXYVFKkiFsazvdPY1s+uv+6gDM4BElVVxGmLz6Rm6N2V
         gHXRJlD96OLMMXekn0wDd4COsbJ2xPFSExUN+ApFOGtjMSlW6RI+6933V1gjSjrGik5m
         eTd2fe2Oc7oQ6jpKDkg2NQhrxo4GFxpRUdA7cjkOBDSaP5yF7iMD711bLmeaCVmCUBll
         RXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793170209; x=1793775009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sFhRdI8EQ8MK0p+CW7dH/qNlkXIP7SsPBqhbqXWLgo8=;
        b=QvVaDce37xhjmqbCFawvyrMn540t68lw/gbhiKp7jONNG2amdHZ7N48DoF1pnCWpOv
         G0nyv/OAgXocU5GMVaMbKum7kwER690BzE32KHCx1ApGJScTJBL3Qt3hL3AkZuuVTSSb
         Kf9l31BRyOJ4KNCPNCO9XPBb0UxuL2N8i8gYtfmXgOX0Su8Da06YJ5V7Gpqjj4UHV2na
         Xwr6WJpEwuuOlA+KGibYwIIbLuTV0w7uG/9/Fk8yA6U7NNfntl+zaCXzqSiTwKAsxPTi
         zC0/7OyEI4jtkJsUPXm1BWcYqY8Veq5U0cly/J1KT1KZXkf7DthhAgEJeDcYIkvrej8r
         UqYg==
X-Forwarded-Encrypted: i=1; AKwUvBxRenTKiaWAKpJQrDwxomH0Ei9ZF5Y6PxDOWPhHiuEbOv00FH8VPETTpCEGOxIjn7h+L6p46Pg=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ3EtBujHuxvpUZ1nv4dioICZ570HJa28mElheznUCiUoB9913I
	jAdmRf8YstOnsvrRoS1uCV/ZOK0sO7NYEIodjHN1CMs8hKzOLVZssTi+
X-Gm-Gg: AYBFou3aTgroJ85uv92C6zFkaDycShIdMBbIzjDZ4OEI7EDUUoikSuJQMg5q1yUoeC0
	sgjhgVfez35pE+QmpryGYPGyxvFhKajosO1Rz8KxEpHAApgwwAVlEjn/rMeYpUmsHRNy77pSLRb
	MLmfUjw/V89EDNM6gttXQH2TByIiQHusXQpQcXr9VbHUNguqn14o0QhWbuX/tNA4uA6BfBKO5tT
	3kHFYyu9tpH7jyptyICYeNqBPeVW9L+iJ7e+cbAZVKDdxtVQGRlsKI3hfrpDWqJgcRp39ARTeOM
	vnHRDpOjJ9p7RfZfbon3dfqVKVppAmr+U1pjNmkYT43L+hST6kaTNk+Xfy3ndUKRMmoC1hdzt9P
	O1sJkaNEJt3AeG7jmFFSB78iae0UGLso4feF8QpsHJ1Rjy4OAAfxti5VWOgxoMqS0n2CHaqCXfv
	9F+2pXcSe4ijq6chgp3QZIqq3BQfxYgNKL3rjjmPX9pInbKNYJqWqof/9FKeO4F6wOTgLCWwo5s
	Dx1VYMNm7h+7WqbH/2CG+nPanYV26NgC1OU8RKoo47ysZjQs+6g1t/LPlf4+aIdSCNeLYOhGIiR
	hK92mzLcSPputxMVR8ZTlUGGEw4vvhcBABE=
X-Received: by 2002:a05:600c:154a:b0:4a2:fe3:121b with SMTP id 5b1f17b1804b1-4a9678c268dmr27227395e9.28.1793170208726;
        Tue, 27 Oct 2026 23:50:08 -0700 (PDT)
Received: from LAPTOP-AVI.lan ([2a06:c701:4778:c500:80cd:d127:b224:9e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a978d57b39sm38767015e9.10.2026.10.27.23.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:50:08 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] dax/bus: clear parent drvdata when releasing a region
Date: Wed, 28 Oct 2026 08:50:01 +0200
Message-ID: <20261028065000.580077-2-thnkslprpt@gmail.com>
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

alloc_dax_region() sets parent drvdata before reserving the resource
and registering sysfs attributes. If either operation fails, the
region is freed but drvdata still points to it. A later allocation
on the same parent is rejected by the non-NULL drvdata check.

The devres unregister action also leaves drvdata pointing to the
released region. Clear drvdata on both allocation error and
unregister paths.

Fixes: d7fe1a67f658 ("dax: add region 'id', 'size', and 'align' attributes")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 drivers/dax/bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b809e1a264afa..dceaa395760e7 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -627,6 +627,7 @@ static void dax_region_unregister(void *region)
 	sysfs_remove_groups(&dax_region->dev->kobj,
 			dax_region_attribute_groups);
 	release_resource(&dax_region->res);
+	dev_set_drvdata(dax_region->dev, NULL);
 	dax_region_put(dax_region);
 }
 
@@ -685,6 +686,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 err_sysfs:
 	release_resource(&dax_region->res);
 err_res:
+	dev_set_drvdata(parent, NULL);
 	dax_region_put(dax_region);
 	return NULL;
 }

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.43.0

