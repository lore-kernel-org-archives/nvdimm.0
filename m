Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0C5305E3B
	for <nvdimm@lists.linux.dev>; Thu, 24 Sep 2026 02:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790218249; cv=none; b=Z+bT7lqDJiDSsYTWw9xXJWdnSAZNudgLF6TmhmKIzCM8eDxo7ErU1zzo4jvVRuBlRx5xSE34NLOsa9wNt2GMJcd2P8Ebji9dkfpGhFdurs/ka/cgs7P6lzCOJHdGHG+vkbZWLlq1ERVpNz5WwZkkgc9bYe27S8xXkzaGgtsQEsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790218249; c=relaxed/simple;
	bh=mCoA/4PWkcVLARDW7POm/fUPES/RjctwuWoj85qvfHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj0wKbdInlTk5wQyZMqB/08sxRjvKvGAhR8a31MBCczOfEzoFmyRfUrbs53onVVJdnoDWfRDWGKjqrnmSCkiwu3kVzmyYyAlqqLNxczPVcUtBUeLWieUI8NkHti0a2haJeI90zW+QrbB3U06OGpxMWHAj6BsvfKHEJNv2FL5ExE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UinCxzUU; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UinCxzUU"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d8fbef5018so11412425ad.0
        for <nvdimm@lists.linux.dev>; Wed, 23 Sep 2026 19:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790218247; x=1790823047; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UHHDPzFrQhdNJxIffI/oMYWvvRfPgA0Kd3oP3j+c7uM=;
        b=UinCxzUU0FA8QUzqwdzixgaKmms/z3zDhQ1kabPhpu4Rp3Y0a21HEfWTwFRTzNe1lN
         HN0QEWiUNSlLyR2FBEhnuyDKCIOXeJUWmp0mTNTxcGnX1EyKDqmnJ1nFyjpa0D7maEw3
         xUlRZDxhgQm81qHBF1Mtv7t8zFa25rzIgtYDgwPmQ82DBKrO+MC8H/VuPWdswVU/9G69
         kmOufPAxKEi16pv4Xg/cZnLXBkGGGIrAY64kmoN6Y5nQY5E8/KsqFWXe3k8cBCuzKLic
         qyWbURsiVMRdIbNkh+okfLdaqPp1+kofmSUAr2iI3KHBMV1jw1OIUuaHU9TDVnZ67L6V
         7hjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790218247; x=1790823047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UHHDPzFrQhdNJxIffI/oMYWvvRfPgA0Kd3oP3j+c7uM=;
        b=kPgXTpxSg9Gn+6uJBf+SvbU031PoTnQUz2LzkU0us6bWhxy1hETV34zFy4S4XvbE/v
         jhlj1tMk9n1ViYhn4Nws/UKbFXdGKLuKfwJ0XNpgNNaXFvqoMX0SlFmFxlGOvuhFPvoD
         ahthCLelaPxBW0/akx46m6867vXjSSZBLR5J+NhxjR3g61V54n3UpeK5W0a0wgeX/zMg
         YZHceB2oISnvv6jZ7AcnglyHYp+eK6L4+egikOLV9+KacAW5Tuaa1QHdHr3fD6OY74zL
         /g3dbPVsu2R9rKn4PwsUi4c19sfooXRVJ3UeAYBTqmopc4FFnYn7Am56T8iZrKrvJ9DB
         yVFQ==
X-Forwarded-Encrypted: i=1; AKwUvBy1MvDlu6ynKdFspklLKpJrwO7Zh+Mid2HgZq26ODFNGNpxm991jjCHXFNXM/eWddMzt678s8c=@lists.linux.dev
X-Gm-Message-State: AFuF++nBRwrFTnxaa6rYuOgYInoAoRRw/xP934jYrXNmhyOGum0Etj44
	3/PAsbu6+3DZsm3YEBKr/PXbD/ZxxfwUn3PAMsy5MNy6YyctNJBHKhw8+EeNDHr6qHg=
X-Gm-Gg: AYBFou3Op1j1mNPgyIGydTnukSnzIEeEcQth5rbpjmjfS+N1yI9C+jRQYcCvKMrO76X
	Ex4310E5jcR4rn4+lhX4HvCKyob9es6ezyPTtod9kQ2yb7vTBplKK96zextAoDSp2tX6OqMRdPT
	Zx5JMr7prGcSPaf1ACLWFtTxnkBWbsL09Ok4nfydGhHVMntojXeHxv2iFaVVDFwmW4kynrs9/w0
	X5pHyGIP45K4hcKdZqfiiStbiPkCEjuzgcQOjhd+mr3W7SAKnV18Le309esD6zbD7/DASwPhcgx
	wCBubKh0hwLeNdoCYzjolp8EdneVzuCzgVJsnr3sdnHBhxYxdxqJeHTyw1cs/673WUCP8oDE6TM
	L9wqxsF+Eqa9+Rxp7E2rmzDWf3OJEA8ivQGHYo/SSgrg/vkKpaDkB31SMe5GUsucV7nWa8Y1Cl/
	EMnBA2ByT9XHbqxOiLVvQ/v/7TTF49ge/SGJ1h2pPM2xmYowJK8HdHhtGW954P0GrQbhXusrAkj
	a/qXfjSg4n2dmwd40D0
X-Received: by 2002:a17:902:f70d:b0:2da:eba4:b640 with SMTP id d9443c01a7336-2df7dd77c83mr9879905ad.6.1790218246767;
        Wed, 23 Sep 2026 19:50:46 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a4f6bsm18638185ad.15.2026.09.23.19.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:50:45 -0700 (PDT)
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
Subject: [PATCH v3 1/2] dax/bus: fix mapping attribute error reporting
Date: Thu, 24 Sep 2026 10:50:34 +0800
Message-ID: <20260924025035.1265035-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924025035.1265035-1-songmuchun@bytedance.com>
References: <20260924025035.1265035-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the DAX configuration locking was converted to rwsems, successful
lock acquisition leaves rc set to zero in mapping_store(). Two error
paths can return this stale value: an unbound region driver and a
misaligned range size. The sysfs write therefore reports success without
allocating the requested range.

Return -ENXIO when the region driver is not bound and -EINVAL when the
range size is misaligned.

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
v3:
- Collect Reviewed-by from Dave Jiang

v2:
- Return explicit errors before Device DAX range allocation
  (suggested by Dave Jiang)
- Move the patch before range alignment validation for independent
  backports (suggested by Dave Jiang)
---
 drivers/dax/bus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b809e1a264af..e40c25401cf0 100644
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
@@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	to_alloc = range_len(&r);
-	if (alloc_is_aligned(dev_dax, to_alloc))
+	if (!alloc_is_aligned(dev_dax, to_alloc)) {
+		dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
+		rc = -EINVAL;
+	} else {
 		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+	}
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
-- 
2.54.0

