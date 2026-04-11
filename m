Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466A9385510
	for <nvdimm@lists.linux.dev>; Sat, 11 Apr 2026 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775919468; cv=none; b=OmN5zTZMp4bQn/VcI/i0RX/C57nmjPB/5QkkI33Y8KjwrvZHvRL2UaloMtsZNS4SezP84lhFUFMWj0PissjOrA+bVlM/QXCS1wjMlfPJ6mlvP4BwKTwQey4pv1D/Sc0Potbhh9Hm6nuKjnLdYJId9qwey4P8Ab8PU4h9CUu31F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775919468; c=relaxed/simple;
	bh=KZhRFKvZZu8iovP22IupFjT2Gu6PJku17dMapEr38Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d435z8rziEbj0yYxqGgdda5mW0nKk278n4mDu5QZlg8lBWT+Akv33TA4IUkRD2GX1pawfUJJCM5YjM+tO3D26PWGE/ilwIu4MssljGPb+Wn9veil8hEcR88vYZqPwJ580S0nMt/Ha4RTytBg6ht+8ABgfYnXuFFb373niDF5phg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KoHOqYcH; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoHOqYcH"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82f206f2b54so141785b3a.0
        for <nvdimm@lists.linux.dev>; Sat, 11 Apr 2026 07:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775919466; x=1776524266; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=scV4iKj0YWAH3OkdMKrFOu3wLw5+cHFeHwRQSwEoBmA=;
        b=KoHOqYcHjvKAL4HGxsrTilmsvBmhe1CXgwxINxq8ENHWrVuIGozwJlDXKE6tHwFXtZ
         E/0vDZaEkSdc1XNYsIRXo8eLjcSc9kWf9P5hEuE89BINMhPjigaygSquuCU9BTc3FYOo
         F/k0TpdUJ0vHMeqFmsXA5e6qCBWzEAR7Ypmk2onLyHMW0mZssdWqrcIh9kpxDfoNabFG
         KkC3f6e8tU7aExwCIa4J/gKdn/aHui8qdJ7fpUddHpzzwXYesQEtI2/4d+AF0F8A0z7d
         WauCmx9N6uerrULblmKXHjgmwCMvNn9HzOI4OOyFkNNygdnZEbZKLQ0ZjaGRhJn8da94
         jSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775919466; x=1776524266;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scV4iKj0YWAH3OkdMKrFOu3wLw5+cHFeHwRQSwEoBmA=;
        b=QNO8xHtc0k8XmctYSLwiI+eHVfS2Z45AYREwhU5SwzL5RYtNicOM5tX3zqInMWvlf2
         nBV24iXHYfsjclcnUXjHdU+GZ9M1gbEZ4LGwp06zLFBucj/D34wZXsdlHKqdEmmiNnhX
         FDY2ovCLSgI0TC+f+WQ83k/QzcjWihGWX8t7yL3K44AnXwPlVfbirz6Sn+cjtZudx+t+
         KOJ86QmjxAeIGI3NwAYcjcHTI0o/KCNPI1ATOhuhuW/5NtT0r6LO/SgZlQ+/88U2vpL+
         eH4MrEF7alc9IrXS4PyqwxQEDhqgqh07Hs3DbFGs++0vZIJzRchHuftlSor6KlcHySi6
         iczA==
X-Forwarded-Encrypted: i=1; AJvYcCWDYWzgmI+JWwRIAZh9ShHPq5iRQVfaB15KZjjr6E/FMqhqa7qTYVll6UBlQIzVJIp4au8/RKI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeLeIrZxtNUYzkSdQkztWC6HhFkZ0w3+6pWNqDkyxw+6BJMfd7
	7eNEeW+iQLt+v7dLXz+ylmBRGkIvDZmu++z9JPQoBQOE70zm2DWuU4cA
X-Gm-Gg: AeBDievmwFVjypDnIaIn4RRT3LMFhCJC1E8MIiEI7kxk25akyD86B7BfJGsWjdcXcFr
	Zv05gxHFT967roRGm2WIot0wBCTHo4BUYs547ySUSVTjLWS0dc/E9nxaC1OPiyNX3WTbHv04igo
	Ax8cJKZz5MNQJxfOMj4yN22m7/ZlIT8H3Ep5LOSOpkhLaQDTNEe8Q+ZjzWyb9p5C/NwVV2WaFon
	8SPxRnVkB9YTJsa9I9+o331f1mqqIYsjPZq0/qRSWY/MWDmdNLOx+USQa+j6fxCijxznnfWFt10
	W8aB86ZKYsB2Qiw7ZxdZw6poKU/Oh37JSoSuxSXZsBVkO+0m0GeTq202jVBtMpDD7808Pa5bSna
	og3Qtb9lAqRGW7l2P53TzqMMDNWS6iSCfik1rUppm0M1Sdpp84v/oN1clXNVxKHL/DFECeX3EZQ
	HzweGORkaLvnCm4rs=
X-Received: by 2002:a05:6a00:6702:b0:82f:1a0b:eb30 with SMTP id d2e1a72fcca58-82f1a0bf063mr3058573b3a.11.1775919466368;
        Sat, 11 Apr 2026 07:57:46 -0700 (PDT)
Received: from lgs.. ([199.182.234.55])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4b17fcsm5949399b3a.33.2026.04.11.07.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 07:57:46 -0700 (PDT)
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
Subject: [PATCH] device-dax: Fix refcount leak in __devm_create_dev_dax() error path
Date: Sat, 11 Apr 2026 22:57:26 +0800
Message-ID: <20260411145726.2299438-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After device_initialize(), the lifetime of the embedded struct device is
expected to be managed through the device core reference counting.

In __devm_create_dev_dax(), several failure paths after
device_initialize() free dev_dax directly instead of releasing the
device reference with put_device(). This bypasses the normal device
lifetime rules and may leave the reference count of the embedded struct
device unbalanced, resulting in a refcount leak and potentially leading
to a use-after-free.

Fix this by assigning dev->type before device_initialize(), so the
release callback is available for put_device(), and use put_device() in
the post-initialization error paths. Keep dev_dax range cleanup explicit
in the error path.

Fixes: c2f3011ee697f ("device-dax: add an allocation interface for device-dax instances")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/dax/bus.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..8753115cd371 100644
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
@@ -1523,14 +1523,21 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 
 err_alloc_dax:
 	kfree(dev_dax->pgmap);
+	dev_dax->pgmap = NULL;
+
 err_pgmap:
 	free_dev_dax_ranges(dev_dax);
+	put_device(dev);
+	return ERR_PTR(rc);
+
 err_range:
-	free_dev_dax_id(dev_dax);
+	put_device(dev);
+	return ERR_PTR(rc);
+
 err_id:
 	kfree(dev_dax);
-
 	return ERR_PTR(rc);
+
 }
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
-- 
2.43.0

