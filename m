Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B8617F4F6
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 01:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761268898; cv=none; b=C8wNxFlFca1ktdWiPDgQsWaUJWpoarPnaySNERn6RzuKBINSCngZbMU6srXhCC/4Z0s3OIfWNU4GZuc1Plyi+fVnCJWVKCLTeLh/GwdQL5gGwK1J/fU0j99VDnwvaaqNOUkUBl0783yz8tQinA5MCci5Ob+OiW9XYmtCp7Nvw9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761268898; c=relaxed/simple;
	bh=7uktLTVlrJm7nB0yUepAnFd9bHjFwk36Uk/OBvinjps=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KleDn5Uy/qPz6KvpJ/WOKJGOQ26g/+kZz4AkmKQ2hyc0fCeBprdanw1GrGwi1I9eWamrReeHyXvDh7r0C53F3x3KiJxF85RwIxXaN/GERThpsVGQrSqhehP5u7b1nRZZATWmk5c0G/S+2H4vOds0DTc0dbmrnyC8236HKirO3PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LceACZe8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LceACZe8"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-471168953bdso15743815e9.1
        for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 18:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761268895; x=1761873695; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LmD4KoyqZKUw57P8WwHSWBVJ5vxbTrg41hvD9Exq1hg=;
        b=LceACZe8gqhsAxJ6YEyMj3Kj6qvEdwxc/tRt13H6XlAjXqitPRYvQ/ZZpXANqwSqZf
         t6dlOahMGqRcOYx1txcuufxeqED/rjx0bLKpW9G5+myqKYREeK5Me2PF5j1iIBN260nh
         712iAozqYEFSP6oSyvnJn28XtAGKN3yLKuXjr1v1CQlPGKOkpsvmr5fqygMOqPNZEy3o
         ZdfSXsfoJxJmG03XAusqttajcOwJMolbMtAQK2seZnNeckN4iwd0JRGQmf+cwpuEbGY8
         qQKVZ6dhmJI9O6FesgwWqvFoUkpAQHCzxLO/Lvy0U63ZWKlckuj7KlyZBJlaDN9Cps2c
         w5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761268895; x=1761873695;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LmD4KoyqZKUw57P8WwHSWBVJ5vxbTrg41hvD9Exq1hg=;
        b=vVx4XL0d5bwDLz229C1WTQ3pgvb+bV1XGO7A6PMWPscTu+pm25SXIwMneYTqU5zvqW
         kc54elZkkxBeei0bwCE6sY++v6gspCw65P7gbdcJKWU5Gpota9LutmPk82lWDlpx7tDB
         aMeCL1lMTLP2i7L271ZMUXe4qmi9Y8/TxpLn2EUStEr3X3tb+gC8K/siUmuen9UyZeiH
         VOjVhgvszGrWNdW6Q4m317+TBYEYZmM+j5S2rO0oK9iEuM7Q0dJlJJW7RFGqrd/4wUoQ
         oOZGbTDNPKNopsx83sVS3WogBibeWWDxH4C2wLw0qoS81/vbwfghEwVSQCXP+ZWFQ5en
         Vx8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVrennZEIc75m3fo27BPN9t2nDCoq8NHM7i8saPZ7jdjmI1RL+RogE2jaosCalR6uhxL/u2Eco=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIu5NcPqAxa2wrG489vbhazwyoq/+UEtDAhhUfoSFFZUdNy0co
	l89kG2bJ+tMabPzjAq0eCN01AHM2eY3mnOBUpa0c34p+xMDd0xZlM6pjYrLXmgm6/C58gm5GrfH
	ey5ROL9OXAv6EDbTNE/07Ig==
X-Google-Smtp-Source: AGHT+IGu3wOBe55z+Y8FldXJmulA4Ot9s9N1XFNSpEp8SZhKSHZbJJRFrsWPO5D8uzOhVCBt4ECj3Xzzht0Oqp7n
X-Received: from wmcn19.prod.google.com ([2002:a05:600c:c0d3:b0:46f:aa50:d705])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e8c:b0:46e:6339:79c5 with SMTP id 5b1f17b1804b1-475d241ce79mr5272425e9.5.1761268895505;
 Thu, 23 Oct 2025 18:21:35 -0700 (PDT)
Date: Fri, 24 Oct 2025 03:21:24 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
Message-ID: <20251024012124.1775781-1-mclapinski@google.com>
Subject: [PATCH v2 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to all dax drivers
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Comments in linux/device/driver.h say that the goal is to do async
probing on all devices. The current behavior unnecessarily slows down
the boot by synchronously probing dax devices, so let's change that.

For thousands of devices, this change saves >1s of boot time.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 drivers/dax/cxl.c       | 1 +
 drivers/dax/device.c    | 3 +++
 drivers/dax/hmem/hmem.c | 2 ++
 drivers/dax/kmem.c      | 3 +++
 drivers/dax/pmem.c      | 1 +
 5 files changed, 10 insertions(+)

diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..90734ddbd369 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -38,6 +38,7 @@ static struct cxl_driver cxl_dax_region_driver = {
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 2bb40a6060af..74f2381a7df6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -470,6 +470,9 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 static struct dax_device_driver device_dax_driver = {
 	.probe = dev_dax_probe,
 	.type = DAXDRV_DEVICE_TYPE,
+	.drv = {
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	},
 };
 
 static int __init dax_init(void)
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index c18451a37e4f..5a6d99d90f77 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -45,6 +45,7 @@ static struct platform_driver dax_hmem_driver = {
 	.probe = dax_hmem_probe,
 	.driver = {
 		.name = "hmem",
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
@@ -131,6 +132,7 @@ static struct platform_driver dax_hmem_platform_driver = {
 	.probe = dax_hmem_platform_probe,
 	.driver = {
 		.name = "hmem_platform",
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..4bfaab2cb728 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -274,6 +274,9 @@ static struct dax_device_driver device_dax_kmem_driver = {
 	.probe = dev_dax_kmem_probe,
 	.remove = dev_dax_kmem_remove,
 	.type = DAXDRV_KMEM_TYPE,
+	.drv = {
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	},
 };
 
 static int __init dax_kmem_init(void)
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..737654e8c5e8 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -77,6 +77,7 @@ static struct nd_device_driver dax_pmem_driver = {
 	.probe = dax_pmem_probe,
 	.drv = {
 		.name = "dax_pmem",
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.type = ND_DRIVER_DAX_PMEM,
 };
-- 
2.51.1.821.gb6fe4d2222-goog

