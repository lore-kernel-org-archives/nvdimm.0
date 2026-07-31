Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9D9390C85
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487787; cv=none; b=gn84vu/9ce/HJhHeDZhFDB3uzrZy1UYvXTY2zT09T7hgF8zGboXDbmK/2ql+UKVtwkkUNGg27x+DyJZcFvm2BSJma9EMCLg77r+LJZ79DomnXu7BjwosdHR5OGV95SdIgHh1+R/eybtD3yAc76CAqLTa4bsYZ9JXiwmj8IboFqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487787; c=relaxed/simple;
	bh=hC92LITz7Yccr/XageZqVp/voSi/++OW1y3xLwXgptM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So7+QqFtaLTLOSqIc3WzK5QfJkhJ/Jcg3Sz/7kg5aQK1ijOx4/K1Lzgq2IwPj287p3v6zjsgAL7JEE0WrPE6enPwcISLZ1VNNI58YffZJj6s/fut2JNHrgP/kYVa11Rcbk8tAwRN8qw/+lAzIO8JPkz1tbmy7aNpmO62EtzP37U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y3bfnWnI; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3bfnWnI"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cc97653887so7500005ad.1
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487786; x=1786092586; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kAapaizwDkinO3KVOW2bB2GwZSS0Ne6+YXNPHio3Jxc=;
        b=Y3bfnWnI7S7+1PFg01hvgd4vtqyd9L5Prz+DNZ+aIgKw7SNjhQhcQ6r5VEP706doYQ
         BHAWhyW/MLZ8+IeDVz5o68GnFcnMdWfIU0cgPorYE0CnDz3IICMmWK5hg0ie+hJx5Oak
         ry9l26EzQWlntEhohQAX+b1H7IxLOy9uzzIF1yl/sPiqnnbR5qFWMyQkFkrflZlSPwTy
         Val7OfBN7Te2hkAG+6gY8sGalsqqjBjKebIbhyu1eKSq1Gd0wRSSevqAdgX5QwuFlNFz
         +Coppixm6YOYg3mWXDnPHpVU/eG4jf8QkYNdsJ0VQw+SZAyPyB6EP5Pg2gc6qP6tkPeo
         toWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487786; x=1786092586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kAapaizwDkinO3KVOW2bB2GwZSS0Ne6+YXNPHio3Jxc=;
        b=jJ5LtMJPF+4jDbjHnwfcwsHK0il8RgXMyr6Z4SJQuS8D+gqBhLS0Sq+iMPEPKYbg/i
         kZrOsdOrzsv6qm0vZxbBAriaSKA31X7fEv292QmGpgEjGJ0kWIyInF35w2rFg3LV/0Gi
         FXSkTZc9AsQ6ioDJtLvfKDUkA5h4zlslggN+OZfhP5NMNSY36JoaILWdGXxmTg0Yimxp
         fxlDligjwaL0XvtNkN6WvEm5pFvtA2A1aKQ71UZSiWJAzBlJDk+oQg4JhwUbo4xtv++y
         XTbEEwjHfwbuWRXGCOB7HNrnaxWHFYhaEwCUzCWwNVZdQFwyBPckJP/vS9cXv5HX0ASV
         rplA==
X-Gm-Message-State: AOJu0YyfYV+H5QOnAofbUeMg5RFnwhlnjzeo3O+sIJPGGd/6fJt+hNxW
	ibnMlyl9IyNoqgm6jD+p7cB4BastgpHRWut51t+Ze23RBsu9JhYVCPzC
X-Gm-Gg: AR+sD12Y9C7GnYsmp5X7fiTayGip3/e9QZivO8czYkkMfcHJ8HYApLJr+nnZqPHwnNR
	ayaOfv4744Mj6LPwKzdO+Uw/dfy3ubnnns1UNYtvyOGVtNRedY/1h4oQMAXJG6Zt5d+QQAS0g/k
	YdnVF9epzrITxrINtk4OulBwr4OQUDXObDcgsuthrFpzC9rp0gH/lvLafyQhh+EMhxSWtMJNVGX
	U0JIJD2s7hi9i7qbiOfYN59L65zjtmMKSPSg1cg0S16/CXN+CHQ84x2nCT3bPWK2/SHj4Ebr3OG
	6P/VEeqq1rJ3O5z9a/bN5DBhYVKn4pNNMyjp/yFjIiWHjyOAA/t8bPkD3uRKLUuXDrPsxAY3A2D
	5p71DsjCb6FvHTO1qQF78cjif52YPpg8zE4r4AhpmGIFBWeUJcXACfKzrONHUsTKHBMxFHPi6Qv
	RonZ25PUbLC4ToWi+21kLYtJTPfvui6xp79raQxql/ugms+InX3Swru0pnc9b3+BBiaOJXKsQND
	KJwY+Tk6A0hDFZn04tnqZb8rmcjxwIvQugYycd9GwGK
X-Received: by 2002:a17:903:2ac3:b0:2ca:5a42:d8c5 with SMTP id d9443c01a7336-2d046f0318emr12343185ad.46.1785487785643;
        Fri, 31 Jul 2026 01:49:45 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:49:45 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v12 4/8] cxl/events: Split event msgnum configuration from irq setup
Date: Fri, 31 Jul 2026 01:48:09 -0700
Message-ID: <20260731084901.1512819-5-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731084901.1512819-1-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 9b320a2b6fe0..8e122de1876b 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -599,35 +599,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
 	return cxl_event_get_int_policy(mds, policy);
 }
 
-static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
+static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
+			      struct cxl_event_interrupt_policy *policy)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
-	struct cxl_event_interrupt_policy policy;
 	int rc;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
-	if (rc)
-		return rc;
-
-	rc = cxl_event_req_irq(cxlds, policy.info_settings);
+	rc = cxl_event_req_irq(cxlds, policy->info_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
+	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
+	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
+	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
 		return rc;
@@ -674,11 +670,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_event_config_msgnums(mds, &policy);
+	if (rc)
+		return rc;
+
 	rc = cxl_mem_alloc_event_buf(mds);
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds);
+	rc = cxl_event_irqsetup(mds, &policy);
 	if (rc)
 		return rc;
 
-- 
2.43.0

