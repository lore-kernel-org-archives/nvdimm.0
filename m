Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BB7221F34
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 11:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749728551; cv=none; b=Tg+frhIbv8wlmiA3jy7ljL6Q++DlJrwLKMvAMWft+ToXSnl2ip8Qh40E/8OJRSAcettrew1lVg13yKAgaZuq5NnT2H79UNJEf1GbKOTXxhK4diaDXVZiTGnbcoQSdMjMqKg5F431HO523PVbWT6xRBecBuRze51k5R/RpakiMS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749728551; c=relaxed/simple;
	bh=M68nUWVIIwtURxYosMRH8VARWW4Z+lgLzYE+UyooFck=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aFeq64xo9IPD5pwoTGhVXcMOsD+s/2zT+cZ/Py0T9eXx0W3egq1AMEbVpQUPBvGrtuLNyhXuYAR2W8K7Pw2Pj6hnHoxy+8+hANKlABqGtoivCxA3lVaT1Q5UzPpgFLxCk/Qjd6pi6pEHvlSmfzoekS9a4j9/J/G2N9BIGOx4MV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qU8WRXf3; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qU8WRXf3"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-60724177a1fso926454a12.3
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749728548; x=1750333348; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nviQMUi3+6AKU5MNp5yJhHLaI5w/byMGPK73HIbgdRU=;
        b=qU8WRXf3dvaJM2JIuswQnAX5tz8311V2VtxhCeYqatyB7WPRNG7NAlRcRhnnmMUL8o
         N39TPEZi/b8SbeGajCISONUAcsOm1ODGk6yKiHk6W6guYPCbWSm3F/ubUF3fKOheIAeP
         Azc3nZH3Uq8ojQYGva8EdxaaS9B0wFkkLO5aN/DMYI9pxJWDLvx7m1R/mvypGbmKtlfk
         BwqsaT1HfN7adHlv6WBMz0xLA34K/ShagACFNxmiqTNyY/EZm9hgkqXV1TZVr9I4Mnf1
         egfNbYKpZAVAuoneSI18kiMP1guS0fR3yruaW8ll1PmvtrdJoiBUY0ViXzW0b+C5xR0H
         XpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749728548; x=1750333348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nviQMUi3+6AKU5MNp5yJhHLaI5w/byMGPK73HIbgdRU=;
        b=a76ddbTYtW2SflklI3qGm/IRCeRGA5Fq8HbO4FXmvwP9+DhPc6HPjmy+n6/CpKlN4r
         VHKnfJC5l+kxBH9WTzxYgxt6y7XZcp5JrYIWX0Yc6wMitC5VN+2g87CLgxc0c6tNmwEK
         DwtDp2uPie6XIrY5frRmAj+uJoCpdTJ3CJrQXcC0fhAOWKQrrniJ4Cbkp3Y6jCSBmg+F
         J3d2rHxjPXR0E7tiKdT+UoKDE2hzvS2ZaKw1i8Q1aD5oes/nRnU4wbE6sAxw5xgWg1Kl
         MHqH28tlpoKRK/k3cKXSsnZtLDqnQiy6dTwwIqaAuQ4UxT6XqZoggm2nwlr/cRTRR4u7
         P4vA==
X-Forwarded-Encrypted: i=1; AJvYcCUwqylReGE21rASSou0g7CB+iJM8dZS8rlWRdRQ5sZQ14ziySwo15hT1SuCL8X85gazLw809OM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFqW4ezMxopVmz/GNRJAsXdEfgtA1Y7fR+P7h06G/eTqvPbo9e
	wlTHDLyOGR3RvBGoTXGPabJ5I1j7d3bV1wY4kebM6IxdVQi8HHPeRmTEGCmWfJpdNVrC1L4n1ZI
	Ha9c5f/CIYRryIXjC+Eqfyw==
X-Google-Smtp-Source: AGHT+IHh9Pqjdn0VY8skR++NPQM27iqtbpRfUClylA8WtEhMMU8qe/JEYEVgqZUowB3UCVviOhARIH/e2yrT3GW1
X-Received: from edqo14.prod.google.com ([2002:aa7:c50e:0:b0:608:806a:7dbf])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:524c:b0:608:1357:d1f7 with SMTP id 4fb4d7f45d1cf-60863ae5590mr3454890a12.22.1749728548037;
 Thu, 12 Jun 2025 04:42:28 -0700 (PDT)
Date: Thu, 12 Jun 2025 13:42:09 +0200
In-Reply-To: <20250612114210.2786075-1-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250612114210.2786075-1-mclapinski@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250612114210.2786075-2-mclapinski@google.com>
Subject: [PATCH v3 1/2] libnvdimm/e820: Add a new parameter to split e820
 entry into many regions
From: Michal Clapinski <mclapinski@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Thomas Huth <thuth@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Ard Biesheuvel <ardb@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, the user has to specify each memory region to be used with
nvdimm via the memmap parameter. Due to the character limit of the
command line, this makes it impossible to have a lot of pmem devices.
This new parameter solves this issue by allowing users to divide
one e820 entry into many nvdimm regions.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   7 +
 drivers/nvdimm/e820.c                         | 159 +++++++++++++++++-
 2 files changed, 163 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index fb8752b42ec8..63af03eb850e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3849,6 +3849,13 @@
 
 	n2=		[NET] SDL Inc. RISCom/N2 synchronous serial card
 
+	nd_e820.pmem=ss[KMG],nn[KMG]
+			Divide one e820 entry specified by memmap=x!ss
+			(that is starting at ss) into pmem devices of size nn.
+			There can be only one pmem parameter per one e820
+			entry. The size of the e820 entry has to be divisible
+			by the device size.
+
 	netdev=		[NET] Network devices parameters
 			Format: <irq>,<io>,<mem_start>,<mem_end>,<name>
 			Note that mem_start is often overloaded to mean
diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 41c67dfa8015..0cd2d739af70 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -8,6 +8,97 @@
 #include <linux/libnvdimm.h>
 #include <linux/module.h>
 #include <linux/numa.h>
+#include <linux/moduleparam.h>
+#include <linux/string.h>
+#include <linux/xarray.h>
+
+#define MAX_PMEM_ARGUMENTS 32
+
+static char *pmem[MAX_PMEM_ARGUMENTS];
+static int pmem_count;
+
+static int pmem_param_set(const char *arg, const struct kernel_param *kp)
+{
+	int rc;
+	struct kernel_param kp_new;
+
+	kp_new.name = kp->name;
+	kp_new.arg = &pmem[pmem_count];
+	rc = param_set_charp(arg, &kp_new);
+	if (rc)
+		return rc;
+	++pmem_count;
+	return 0;
+}
+
+static void pmem_param_free(void *arg)
+{
+	int i;
+
+	for (i = 0; i < pmem_count; ++i)
+		param_free_charp(&pmem[i]);
+
+	pmem_count = 0;
+}
+
+static const struct kernel_param_ops pmem_param_ops = {
+	.set =		pmem_param_set,
+	.free =		pmem_param_free,
+};
+module_param_cb(pmem, &pmem_param_ops, NULL, 0);
+
+struct pmem_entry {
+	unsigned long region_size;
+};
+
+static int parse_one_pmem_arg(struct xarray *xarray, char *whole_arg)
+{
+	int rc = -EINVAL;
+	char *whole_arg_copy, *char_iter, *p, *oldp;
+	unsigned long start;
+	struct pmem_entry *entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+
+	if (!entry)
+		return -ENOMEM;
+
+	whole_arg_copy = kstrdup(whole_arg, GFP_KERNEL);
+	if (!whole_arg_copy) {
+		rc = -ENOMEM;
+		goto err_str;
+	}
+
+	char_iter = whole_arg_copy;
+
+	p = strsep(&char_iter, ",");
+	oldp = p;
+	start = memparse(p, &p);
+	if (p == oldp || p == NULL) {
+		pr_err("Can't parse pmem start: %s\n", oldp);
+		goto err;
+	}
+
+	p = strsep(&char_iter, ",");
+	oldp = p;
+	entry->region_size = memparse(p, &p);
+	if (p == oldp) {
+		pr_err("Can't parse pmem region size: %s\n", oldp);
+		goto err;
+	}
+
+	while ((p = strsep(&char_iter, ",")) != NULL)
+		pr_warn("Unexpected parameter: %s\n", p);
+
+	rc = xa_err(xa_store(xarray, start, entry, GFP_KERNEL));
+	if (rc)
+		pr_err("Failed to store 0x%lx in xarray, error %d\n", start, rc);
+
+err:
+	kfree(whole_arg_copy);
+err_str:
+	if (rc)
+		kfree(entry);
+	return rc;
+}
 
 static void e820_pmem_remove(struct platform_device *pdev)
 {
@@ -16,10 +107,9 @@ static void e820_pmem_remove(struct platform_device *pdev)
 	nvdimm_bus_unregister(nvdimm_bus);
 }
 
-static int e820_register_one(struct resource *res, void *data)
+static int register_one_pmem(struct resource *res, struct nvdimm_bus *nvdimm_bus)
 {
 	struct nd_region_desc ndr_desc;
-	struct nvdimm_bus *nvdimm_bus = data;
 	int nid = phys_to_target_node(res->start);
 
 	memset(&ndr_desc, 0, sizeof(ndr_desc));
@@ -32,12 +122,64 @@ static int e820_register_one(struct resource *res, void *data)
 	return 0;
 }
 
+struct walk_data {
+	struct xarray *pmem_xarray;
+	struct nvdimm_bus *nvdimm_bus;
+};
+
+static int e820_handle_one_entry(struct resource *res, void *data)
+{
+	struct walk_data *walk_data = data;
+	struct resource res_local;
+	struct pmem_entry *entry;
+	unsigned long entry_size = resource_size(res);
+	int rc;
+
+	entry = xa_load(walk_data->pmem_xarray, res->start);
+
+	if (!entry)
+		return register_one_pmem(res, walk_data->nvdimm_bus);
+
+	if (entry_size % entry->region_size != 0) {
+		pr_err("Entry size %lu is not divisible by region size %lu\n",
+		       entry_size, entry->region_size);
+		return -EINVAL;
+	}
+
+	res_local.start = res->start;
+	res_local.end = res->start + entry->region_size - 1;
+	while (res_local.end <= res->end) {
+		rc = register_one_pmem(&res_local, walk_data->nvdimm_bus);
+		if (rc)
+			return rc;
+
+		res_local.start += entry->region_size;
+		res_local.end += entry->region_size;
+	}
+
+	return 0;
+}
+
+static void free_pmem_xarray(struct xarray *pmem_xarray)
+{
+	unsigned long start;
+	struct pmem_entry *entry;
+
+	xa_for_each(pmem_xarray, start, entry) {
+		kfree(entry);
+	}
+	xa_destroy(pmem_xarray);
+}
+
 static int e820_pmem_probe(struct platform_device *pdev)
 {
 	static struct nvdimm_bus_descriptor nd_desc;
 	struct device *dev = &pdev->dev;
 	struct nvdimm_bus *nvdimm_bus;
+	struct xarray pmem_xarray;
+	struct walk_data walk_data = {.pmem_xarray = &pmem_xarray};
 	int rc = -ENXIO;
+	int i;
 
 	nd_desc.provider_name = "e820";
 	nd_desc.module = THIS_MODULE;
@@ -46,8 +188,19 @@ static int e820_pmem_probe(struct platform_device *pdev)
 		goto err;
 	platform_set_drvdata(pdev, nvdimm_bus);
 
+	xa_init(&pmem_xarray);
+	for (i = 0; i < pmem_count; i++) {
+		rc = parse_one_pmem_arg(&pmem_xarray, pmem[i]);
+		if (rc != 0 && rc != -EINVAL) {
+			free_pmem_xarray(&pmem_xarray);
+			goto err;
+		}
+	}
+
+	walk_data.nvdimm_bus = nvdimm_bus;
 	rc = walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY_LEGACY,
-			IORESOURCE_MEM, 0, -1, nvdimm_bus, e820_register_one);
+		IORESOURCE_MEM, 0, -1, &walk_data, e820_handle_one_entry);
+	free_pmem_xarray(&pmem_xarray);
 	if (rc)
 		goto err;
 	return 0;
-- 
2.50.0.rc1.591.g9c95f17f64-goog

