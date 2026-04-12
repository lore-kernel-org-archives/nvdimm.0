Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117061A681D
	for <nvdimm@lists.linux.dev>; Sun, 12 Apr 2026 07:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775977226; cv=none; b=WpIJKQLoES42c2p+OLzPhcp6SUr3c3+3TgBDx9U9SrMfzSEcIK7lu82imyFIvAJZDV+ot8tM6jFHdKV5BgBGYcHpy2FMegQLaOJToa19npPvGGuYgz/gBsIXkwwlWXirdG7HIFRK7UyAE2wBBsFFFIPpq9H6/j2xIcS2AKbUKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775977226; c=relaxed/simple;
	bh=ad9MM76H3qA9Zm7zGQguyywPJdrDLgkSlTE6M7PNjQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KosX6CdIn02Fyq3Ob43jH+CTMLz6ju7JYTrYrykZcJ+g2/ukOZ6pfFS36fm5kO7lWDN1a0kbwKyv4hgA5iNc8ayq4S+zXRRAxYYtzAvnoNxcASqgsjxkzcd2QdlgQnVBaKhYmgaZ/xC6t0y1FBvbwywLzS6gahjvpGOJJVIldVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iTbmYLpf; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iTbmYLpf"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2adbfab4501so13812995ad.2
        for <nvdimm@lists.linux.dev>; Sun, 12 Apr 2026 00:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775977224; x=1776582024; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=agxSRs+wZOd7cJK+5GqSX8xmNcbffxfyow5lUhwJHXU=;
        b=iTbmYLpfsUEkpMzr+BN2HMmnHcTweL+WhYWNSprt75IAqHaxdN9fPS8Sz1k4rQwl+V
         wtTYT4Zz7x5NEjMuqOGLfTKaxOMforXfAouR330jzXUXdx2CFLdAic2bI0AlC10umSq5
         +sB93QOgt4eOatHxFq9nYdSDzwgYx7aY7kVqGjvVSvLpcgkMm/SEBUxLYUvUqWnTlwd4
         +TzyZXDURplDLpVheBFuU16CMvm2z5pacQZj0bXxgvQ6aPht5o6IMKcD0Hdfve+7HKSS
         pGzZpYiQoNL223qDJVbP/hBKifEnUcAhjsErMph0tEveX40z/FvcO3JzWTswKg4b2M3Z
         7g0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775977224; x=1776582024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agxSRs+wZOd7cJK+5GqSX8xmNcbffxfyow5lUhwJHXU=;
        b=FPvnaJdR+0wkaa5ofEiEVgaPVxEWqluheqLBkEGUi+ZMTHBr0s8WnfijcSgIXubbZo
         P1iQDylb9pvS7Cq4JQd8uCpTU7+t1/MpotKGY/k3X2TnX9DlI7M5+TBR0ErOhx8YDQvO
         J14JuTvjDebHWgSQdih1yKWnrb8lNdqT4m42MpCP6v8QIhklH805Ebn1fa6fWFNuUvHm
         yW3FxofHwEilGqx+t3sryMh4ikqvFRRJKeg+/N6rifHmD3u47LKdGbCpoJmJmqd0f67h
         GIDbG8igo91K6pMBjl4OrmB8sUnXT1QlUbjHBDNFAo2ifkn/VfEJoqRF8yUQX8jfZK1Y
         MJKw==
X-Forwarded-Encrypted: i=1; AFNElJ+Vj8mu0C8rmspp7urlGShSVzm6jcEDvx3qgkyY6CQtO/PdAhyHUk1/1zJ3KC9tmuyKCBbv3DE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjOaW+O85S31m6qBA/flpyKhT28K9Nk64g1D0NE67TWzbj9OT1
	sTDKF+6mApZ86V9ZobDtTVSq2F9SZB8aMYz2QN4qpaHoVA0NdEtRoy5w
X-Gm-Gg: AeBDieso+bmb5cpCNXMKuFfQUJztWyxuv3Xo5Z8kxeJ3UbNAx9qmAp8eddfMzz+89QM
	6NtrvKiSTHaCAUgLxsD+HFb/bEsXuMkLjUERxcVDNPifOPTC9LWqtkb9YYTim/8u1Xp/HGyqPXr
	fTpyeYwLgODXt1iL45iwqzTsV2DA0XB0FgvnlZX01tSO/Ugq0m6vcfaKinOilMRdok7VpJdIIxt
	PEh4aTDsilOVgZebtrZ2dwyC0esZj8tN3hF9p7TQDVGhxf3UxfdAivM90GAQlQEHhrgRr2ok7d/
	Irq/Luaq3ZqUJ21utc+CHClQc7Rmni8aO6raM2IVauDfvz2ZxdCg6rZR8F8nNzpoVkH9Ia/Xnyj
	0qYrVKKvvXjs3Jpjd6/tJCrjBkm+KHwPykQBEam2nmGD4N9hQ8rPpCLx3mX5BHvxK7Cnb37qvrr
	xSMtZgqphXa/FJnmnIQbJv
X-Received: by 2002:a17:903:b8e:b0:2b2:647b:a744 with SMTP id d9443c01a7336-2b2d5a584d8mr101853925ad.24.1775977222380;
        Sun, 12 Apr 2026 00:00:22 -0700 (PDT)
Received: from lgs.. ([223.80.110.53])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b45c217ba6sm1798355ad.36.2026.04.12.00.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 00:00:22 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] device-dax: Fix refcount leak in __devm_create_dev_dax() error path
Date: Sun, 12 Apr 2026 15:00:10 +0800
Message-ID: <20260412070010.2402830-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After device_initialize(), the embedded struct device in dev_dax is
expected to be released through the device core with put_device().

In __devm_create_dev_dax(), several failure paths after
device_initialize() free dev_dax directly instead of dropping the device
reference, which bypasses the normal device core lifetime handling and
leaks the reference held on the embedded struct device.

Fix this by assigning dev->type before device_initialize(), so the
release callback is available, use put_device() in the
post-initialization error paths, and keep dev_dax range cleanup explicit
since it is not handled by dev_dax_release().

Fixes: c2f3011ee697f ("device-dax: add an allocation interface for device-dax instances")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - clarify the commit message around the device reference leak
  - drop the unsupported use-after-free claim
  - set dev->type before device_initialize() so put_device() can use the
    release callback on post-init failures
  - simplify the post-initialization error paths to use explicit range
    cleanup plus put_device()

 drivers/dax/bus.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..2d92674d0d6e 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1453,6 +1453,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	}
 
 	dev = &dev_dax->dev;
+	dev->type = &dev_dax_type;
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
@@ -1499,7 +1500,6 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	dev->devt = inode->i_rdev;
 	dev->bus = &dax_bus_type;
 	dev->parent = parent;
-	dev->type = &dev_dax_type;
 
 	rc = device_add(dev);
 	if (rc) {
@@ -1522,14 +1522,13 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	return dev_dax;
 
 err_alloc_dax:
-	kfree(dev_dax->pgmap);
 err_pgmap:
 	free_dev_dax_ranges(dev_dax);
 err_range:
-	free_dev_dax_id(dev_dax);
+	put_device(dev);
+	return ERR_PTR(rc);
 err_id:
 	kfree(dev_dax);
-
 	return ERR_PTR(rc);
 }
 
-- 
2.43.0

