Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307233D813D
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386903; cv=none; b=S/UGCjwUGhqVOayXE8pXtkMutLtEJrzr26LgG8cJLSapJ1BNPicLxL9CvnzoDcdGaXIcenpf0PKXrBfLFuyRHQm9zW+jVndPKqZHA3UR0aeAo7nAONLMJQpNi4OPGw6dCcTLgHhf3XuezoZ32g8hMi9E7a3uhnBLAf0K4lj2fg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386903; c=relaxed/simple;
	bh=MH96XZs7MF5UV1+fZ2jQQiPTR+7dlAPgtIOhHTm8MGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVVo/nms81ofq6qo6TirHA5bRK2GB9/XdLkQbO87pmcoSK4k0qTWL64/CXrt4iAVOgkrKkF8Sj8w2FWL2cmF9rCglv78x5B4TyL8avdH8aj6Mng223XueoRpbKHv6t9sR2vzXX9BMfZ+5eibfvcbxSs3Y0pKKF31RVza//S31FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cY0EK7Ps; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cY0EK7Ps"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-304f590dd91so2539166eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386901; x=1782991701; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWGYp5PimR7iNvegHe/tRkVtZEJJWTBhNsd/pXJaxDQ=;
        b=cY0EK7PsghAhm4GgbAOYLANIN0Phzy62n+M2zPcVHWdPI25PsDasEfgUnQhBZSsSUc
         WSYBaRcQH5bJ8LCEETpDjyn+vjij7qZ0E28zxm8oRyAwyCCxFKZgpoJcxFdugWlJRkGr
         kgdH9hfjtvtYvl+8mvKiO+g+0riiH3cRbOFSTlS3AkOAXGTRK6lshAm8K3P7mCcH77p5
         RCQUy5+jDMVP+ZlZfPAAeFbLFwZ2vzK5cGtJqfTOz1WP5Vepxh/lIq5jVDgWeI7DxrlY
         Ng0BoVxCCJUJEtbnxfhmNgkmtWfj0W3bL7CprV3UjUyElpdmolMdUkxrl4paX6DQ1QpU
         EiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386901; x=1782991701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zWGYp5PimR7iNvegHe/tRkVtZEJJWTBhNsd/pXJaxDQ=;
        b=clagQ+zbRvS/YQt34UOBR+BxRJ4jAvJnWgSBc4utuKlNsbZdwttPY8WAzw1Bupk8O1
         TwX0g7ueOXh0jJjl2MO7R+hxPDie2sYBjrP0/0LNVDT8gXsSU8x2PCGobNnlqcf5MJXN
         lRiIh9y5Cd4zRMnPRvqajuNA1Op6TgD9kibaNGeM7hel0sb8JIxEdKlfGfZ9kkypBnOC
         7Zkv1xlberSrHdz9sPee4ZcfIECWAgqLqbWmMnUmzFi4puizrvx7ryCk+jf5w9A/lG0k
         h5cHAVSf2pn3DswKUbxUgIXb2MdEe9ZUNQ/rB/ro/3VNXvWEM5HvKlq47roPQEfpfNJc
         YuOg==
X-Gm-Message-State: AOJu0Yzct/RZS89YaU2u709NOoBmUbAoIEZGIBp9fLKHqpwqd+gDYbuo
	p6EXn5OHBaTqzJB/j4XBxSTfhTYLAPjrQ+TMrnmINLjsGlZzBxWR3s7r
X-Gm-Gg: AfdE7cl6ivCyVZp0l2g58gC3O7Jgtq3WfCjmVvz0bq0wB+CyCRsEsB1eTCSWbpYtSEL
	6a27ibGc+wU0m0ZSvYah4N3lw5BXaOyW0NCrYuGmZezPEQOlFaeZ7M+uXRZF0ZLUvZgH5NzH3fx
	PTeSYFxYcfNw409EE9XgoMlom2lr0b/fehFP/r3DXXEllJEM5sV4wIS61u9bkHvEgaXnp2v72xW
	T9EFyondaeA82TN+yJHh83bve10CVwsQrI1U1qFy0bvBcvCoijp9a3vYhq+irlUFA0fwXijrZlE
	8XYcS/hZ9VD3Be+R/TmTCoeM8T7vyPWT1aasKb6lDiL4cph5DRfHlr3alkHvHt2RQ2GkBKkGgX3
	iFdIMEr1yLuhzRF01hbvFGlw0xFoj1+SQusuFUZDjtCNE1dXlOcFEjkLbYLJNAJTXSpeg+ff7c5
	SyuII8j9+bXkP+GipmiNcN2+qkSxh79NlNu1BfdcnTC/a4yQW/x5NZKgN/YOANA0sy+Rq9
X-Received: by 2002:a05:7300:7246:b0:30c:5a5:df4f with SMTP id 5a478bee46e88-30c84eb9cf8mr2905159eec.16.1782386901207;
        Thu, 25 Jun 2026 04:28:21 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:20 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>
Subject: [PATCH v11 08/31] cxl/events: Split event msgnum configuration from irq setup
Date: Thu, 25 Jun 2026 04:04:45 -0700
Message-ID: <20260625112638.550691-9-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
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
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 60f9fa05d9ef..35942b2ace53 100644
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

