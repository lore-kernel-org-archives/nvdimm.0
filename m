Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28BA3B4E9C
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 13:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776088604; cv=none; b=mEZMzXgdgx9MfebaLIhfMJtV33odNUxnpX5scE/fC79vejAWbODEaqZtWrPH2aMTCaAucC5BhQT+wEtvdRQv5mdi45BFvqPY7u8uFYdeOchG4+1KcI/AuNt816JZ6JABWuadCU8tqy7XM2Uj4tQOJdBL6KMARV82sU0VFABBmBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776088604; c=relaxed/simple;
	bh=Hpvv+IN2EELEEcnD5YwW84ys/b/L7dP7YW1BRzo/t8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F9QDNXgFpgIFOCcTfizu14un2fFMENFLrmHvGmR/Okr38C1Yj+Yj6+2SS5MTyZqv2ubewwFSSsp/8slR2eGQILT6gaAIS7POOcaYQglJB4gVOo23SpaBuM2uNH89Q/8ratGiFgjWAvmBmRMGFTB8JObxI+PZFmxbAtl0PVnH1jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hGKkWrwJ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGKkWrwJ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2addb31945aso26962165ad.1
        for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 06:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776088602; x=1776693402; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IwI7fhoIYuDnAceYOXsnx6dLQgMpnwbjObgo8mwaSj4=;
        b=hGKkWrwJtFraYa4HxnrVOtqB1YOcmYLZ7iHmbc7MNiTcXlLCWf9EJUhQ7P9WKkEWUA
         GFNbApuzHsCCtN+i5+k4M6jk5QNqQqJNry5sNYVEk2JuAkERYhP6NY95keDNo4QQ9Yko
         bpY2RX+ChDLRFTlBWBso2L2BjGcL/dtht0riDFZ8BwHGNa4mj325AHI8gikT2gP9Y9BR
         i+RNi/buSHGGD1vnL0nK3nxB6nxsjR3IwUlMDPFcgRsdQr/V+dFKlGL3NxxGlqaLUSYF
         IiIlkmZr3ajOpFX22oSG3su0B8qvz6pSFR0x5KzLx2YqvgfC7747xlZcKpw+jEPpV345
         fGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776088602; x=1776693402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwI7fhoIYuDnAceYOXsnx6dLQgMpnwbjObgo8mwaSj4=;
        b=QgxMhqtyVCRXuOwTQQ0dr6EnKvLDli/bJaBt6+Z8f+8O1guzzHU6ZA/fnmaqzb5tt0
         XAkVNnWmtImydEbYU9Yp6hYTo32MOfMhpJKEHFwKACifHhg84H7dR/g6C+SFOx7UuRau
         HzSZpYrhj+FUvWrZSm5NxACGL9st28Hl5zkjS3S+g0Pnc0Gg4aNJL+aED1xRsK9bkZzs
         AqjBddIjYxq32RHxuPc09ql0Uwg9JNIHqTSAmXOQyzvnhvEuXoU8o8MmyPy80l3U4T+2
         vLH2pEaWWfamBAp9p9ipwJhFjMHn75LtdI/Ys4lNfWzM09+cl506sN8ke3rKo0kvBMMs
         cHxw==
X-Forwarded-Encrypted: i=1; AFNElJ+Nne72CWtORLnkFY6+bce55oAuNpiM6eHPxZWyoad3s+A2zH0LatBMGznBA6/FfVa5Uvo06Lk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz67YHANYGriYi1oQOWDBFnXKaCxiQIrHpy5Z/Z+ovF/1RGB4KV
	bhcPY7HFhDHTtXXKpxGxVpZ4Am7paPWwO6OLTSYvFaiQ9LsVQgKt923q
X-Gm-Gg: AeBDiesJ7rf/V1FCJlIF4Ycx3LNBPsG1siygqbt6kGaxnFZBxDV2/LAvOMFmqwoe+0S
	mP7fLtf5aSANKMlclNNX8EJJRYASQraxfFSkhNJxrzQG3oLLm9tLBpTOtc0cotBQAurQ/BrWJ+H
	YT4szC+YAubjr3gCB3z52J3+pL4GpA/OHATy+h/Hi4LG+ZPNFde8ASsSKmC9TzflSOiRlSH8Nm9
	LtKRGjA+S31CsGW+g0ynDYD/NIBgoG89+v4r66rmvFyBrph2BHvs6Ej38cfwvigInn4tz3+K42o
	eNBFQknJ67xFj5Kjb9KZHRtPYSO9yUkBsshu8p9eqw9vlWJ6FiKInwJ0LA6HATA7v9c3t+QLCdz
	OnLM/ys+77tYnZ/5QC4srwPOTz97Qxth6lrD3eR3VhXUXl3GP42sKFLJp/EsoSIWtcB1CRZcJrk
	sjvEmOOMG5LVOkUGlib/hff58d4OQyc20=
X-Received: by 2002:a17:902:b698:b0:2b2:aa93:cc5f with SMTP id d9443c01a7336-2b2d597609dmr100423715ad.10.1776088602230;
        Mon, 13 Apr 2026 06:56:42 -0700 (PDT)
Received: from lgs.. ([2409:893d:1188:142d:6c67:74e8:5200:1f39])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b468273ccfsm12585665ad.43.2026.04.13.06.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 06:56:41 -0700 (PDT)
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
Subject: [PATCH v3] device-dax: Fix refcount leak in __devm_create_dev_dax() error path
Date: Mon, 13 Apr 2026 21:56:25 +0800
Message-ID: <20260413135625.2890908-1-lgs201920130244@gmail.com>
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

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix this by assigning dev->type before device_initialize(), so the
release callback is available, use put_device() in the
post-initialization error paths, and keep dev_dax range cleanup explicit
since it is not handled by dev_dax_release().

Fixes: c2f3011ee697f ("device-dax: add an allocation interface for device-dax instances")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v3:
  - note that the issue was identified by my static analysis tool
  - and confirmed by manual review

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

