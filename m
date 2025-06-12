Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3944222F744
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 11:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749728554; cv=none; b=tHzy5Lzgw3EHGsR2p5SVWB+bA+lKz4szQ8nyePSA60coyo3FO4N5TiR0LB3pXGJqcYZcK3zJc+z+mxGy2keM3ARGsJidht79YQsfEl33hxC8OojIdBoKSJm7Axpl3J2DCudX2j38iai82E6dgNZv87ZFHPCjkHOZ9BX8HHr8kcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749728554; c=relaxed/simple;
	bh=uyh332o1pAPuEY2uH91QWERhySxOdcUopuo5d5VLyZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LTsPmUa8DlzhTh7WdVI5KipX/JcLVepg1nudvPLEkTD5xuzhDr6rcNndZH6sz5GJoPOvxwJzKGA+9V1EEhTweMzCSJKM0bibHnG2nLsCsqICG9Xo2LNgZPMEfIeeO5AlFpOxe578e9myXJo8PeRMwRb6Um++z3VyiJJu1e84Bvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uj3coY1Y; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uj3coY1Y"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6083f613f0eso1028324a12.1
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 04:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749728550; x=1750333350; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ny50wxbGCl9/p7vQHYlJ5hEC+vKtyReCBNsYASuV5I=;
        b=Uj3coY1Y3Sodpgdva+MwDUBNjRIBI82RrYBmsPmhTC7n+IScqkIobXw1joeM4VSTPM
         YFj+dXEg26Dx3Vel12l72VC6sxIos9NMMz10dErsnu2VKVb3l9HCy9Z6u5jSG4HCvkXe
         NBfxEJ7TbNhWOmOO1DNxeqF5nLjnJ/fElW6//iUzKt/dl9JbLcKazwtNKJfi0LiEpDQb
         hEZwndYtSg+gYY4c8qLiRzxjsAEhGrlp2dqLWtrk3ccMdWt/kN7bbWkszh2pQv/yUcFs
         1Est4iV9hlUqoYP5MjWiTaia8YWho4o7uiKBjbis5+PQH0Zq0QxrwW2ptS2VpEImYr2y
         xWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749728550; x=1750333350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ny50wxbGCl9/p7vQHYlJ5hEC+vKtyReCBNsYASuV5I=;
        b=MjyMYVX6xqPuTYYjONfsF/MZxVFQNBf1VJbdAWsUmeVe+fKKc2DtTFu6uvxdpLpIJR
         QSV94FsrogPoitT2GtYeuPxW4kkDXbLKhomIkTJuViZCtDSjjl7EO+hrVZ1LoG0nzlpL
         2Tal/T2cWJ6npKkhqgyXrNhSpixoUOKn2GxDJPITFcKWVAPfds82uXPGzQpdL2FDh/fW
         ug4Evm0PUMPmvftF4vOZ8a1zU/vaB8ZLg6ycdSK1nqdDPmtP4mwlTDQW57+PINn9Sm2b
         s2mHxNcJyb5F6Zm6RQG5XZs/nBEo+wYDYQ1GOrdGz8YIHX41+A9cAzBoZ0Jnuc+FCvWX
         RhmA==
X-Forwarded-Encrypted: i=1; AJvYcCXmAdUdyJ4ZO9uaMWYzHeVXPFIt/UqNVFzdBiMU0k0fva5zFkK3eM+XuAFFhE8pmCly/DjKoqY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx30S29/ktB7hGbBHyilLalwG9vNvZ7Soj0rLca/oOx5RJr61xS
	M2mKYXE2WBfaZlYxZKTsyQSUXu7nymRK+18mJexK8KTndrhC2FE5wPWhE116+vqCrmFyfZxqyW+
	oNdA0bHWhK0tWa+lOfmSFEw==
X-Google-Smtp-Source: AGHT+IHDD1UnNT+nvBQNPFZnom0wa4E2j3MQhNuNSWlQgOSnWJg+n1r0cAtiW4veuvHINkkCDUQd+Ll58aoDNRGI
X-Received: from edvw21.prod.google.com ([2002:a05:6402:1295:b0:608:558a:1de1])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13c9:b0:602:201:b46e with SMTP id 4fb4d7f45d1cf-60846baa5fcmr5909183a12.31.1749728550520;
 Thu, 12 Jun 2025 04:42:30 -0700 (PDT)
Date: Thu, 12 Jun 2025 13:42:10 +0200
In-Reply-To: <20250612114210.2786075-1-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250612114210.2786075-1-mclapinski@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250612114210.2786075-3-mclapinski@google.com>
Subject: [PATCH v3 2/2] libnvdimm: add nd_e820.pmem automatic devdax conversion
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

Those devices will not have metadata blocks. The whole device will be
accessible by the user.

Changes include:
1. Modified the nd_e820.pmem argument to include mode and align params.
   They are saved in the nd_region_desc struct.
2. When mode=devdax, invoke a new function nd_pfn_set_dax_defaults
   instead of nd_pfn_validate. nd_pfn_validate validates the dax
   signature and initializes data structes with the data from the
   info-block. nd_pfn_set_dax_defaults just initializes the data
   structures with some defaults and the alignment if provided in the
   pmem arg. If the alignment is not provided, the maximum possible
   alignment is applied.
3. Extracted some checks to a new function nd_pfn_checks.
4. Skipped requesting metadata area for our default dax devices.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   5 +-
 drivers/dax/pmem.c                            |   2 +-
 drivers/nvdimm/dax_devs.c                     |   5 +-
 drivers/nvdimm/e820.c                         |  62 ++++++-
 drivers/nvdimm/nd.h                           |   6 +
 drivers/nvdimm/pfn_devs.c                     | 158 +++++++++++++-----
 include/linux/libnvdimm.h                     |   3 +
 7 files changed, 189 insertions(+), 52 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 63af03eb850e..bd2d1f3fb7d8 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3849,13 +3849,16 @@
 
 	n2=		[NET] SDL Inc. RISCom/N2 synchronous serial card
 
-	nd_e820.pmem=ss[KMG],nn[KMG]
+	nd_e820.pmem=ss[KMG],nn[KMG][,mode=fsdax/devdax,align=aa[KMG]]
 			Divide one e820 entry specified by memmap=x!ss
 			(that is starting at ss) into pmem devices of size nn.
 			There can be only one pmem parameter per one e820
 			entry. The size of the e820 entry has to be divisible
 			by the device size.
 
+			Named parameters are optional. Currently align affects
+			only the devdax alignment.
+
 	netdev=		[NET] Network devices parameters
 			Format: <irq>,<io>,<mem_start>,<mem_end>,<name>
 			Note that mem_start is often overloaded to mean
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index c8ebf4e281f2..2af9d51e73c0 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -39,7 +39,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	pfn_sb = nd_pfn->pfn_sb;
 	offset = le64_to_cpu(pfn_sb->dataoff);
 	nsio = to_nd_namespace_io(&ndns->dev);
-	if (!devm_request_mem_region(dev, nsio->res.start, offset,
+	if (offset && !devm_request_mem_region(dev, nsio->res.start, offset,
 				dev_name(&ndns->dev))) {
 		dev_warn(dev, "could not reserve metadata\n");
 		return ERR_PTR(-EBUSY);
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 37b743acbb7b..52480c396bb2 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -113,7 +113,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn = &nd_dax->nd_pfn;
 	nd_pfn->pfn_sb = pfn_sb;
-	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
+	if (test_bit(ND_REGION_DEVDAX, &nd_region->flags))
+		rc = nd_pfn_set_dax_defaults(nd_pfn);
+	else
+		rc = nd_pfn_validate(nd_pfn, DAX_SIG);
 	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
 	if (rc < 0) {
 		nd_detach_ndns(dax_dev, &nd_pfn->ndns);
diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 0cd2d739af70..4dd4ebcc3180 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/numa.h>
 #include <linux/moduleparam.h>
+#include <linux/parser.h>
 #include <linux/string.h>
 #include <linux/xarray.h>
 
@@ -49,8 +50,51 @@ module_param_cb(pmem, &pmem_param_ops, NULL, 0);
 
 struct pmem_entry {
 	unsigned long region_size;
+	bool treat_as_devdax;
+	unsigned long align;
 };
 
+static int parse_one_optional_pmem_param(struct pmem_entry *entry, char *p)
+{
+	int token;
+	char *parse_end;
+	substring_t args[MAX_OPT_ARGS];
+
+	enum {
+		OPT_MODE_DEVDAX,
+		OPT_MODE_FSDAX,
+		OPT_ALIGN,
+		OPT_ERR,
+	};
+
+	static const match_table_t tokens = {
+		{OPT_MODE_DEVDAX, "mode=devdax"},
+		{OPT_MODE_FSDAX, "mode=fsdax"},
+		{OPT_ALIGN, "align=%s"},
+		{OPT_ERR, NULL}
+	};
+
+	token = match_token(p, tokens, args);
+	switch (token) {
+	case OPT_MODE_DEVDAX:
+		entry->treat_as_devdax = true;
+		break;
+	case OPT_MODE_FSDAX:
+		break;
+	case OPT_ALIGN:
+		entry->align = memparse(args[0].from, &parse_end);
+		if (parse_end == args[0].from || parse_end != args[0].to) {
+			pr_err("Can't parse pmem align: %s\n", args[0].from);
+			return -EINVAL;
+		}
+		break;
+	default:
+		pr_warn("Unexpected parameter: %s\n", p);
+	}
+
+	return 0;
+}
+
 static int parse_one_pmem_arg(struct xarray *xarray, char *whole_arg)
 {
 	int rc = -EINVAL;
@@ -85,8 +129,11 @@ static int parse_one_pmem_arg(struct xarray *xarray, char *whole_arg)
 		goto err;
 	}
 
-	while ((p = strsep(&char_iter, ",")) != NULL)
-		pr_warn("Unexpected parameter: %s\n", p);
+	while ((p = strsep(&char_iter, ",")) != NULL) {
+		rc = parse_one_optional_pmem_param(entry, p);
+		if (rc)
+			goto err;
+	}
 
 	rc = xa_err(xa_store(xarray, start, entry, GFP_KERNEL));
 	if (rc)
@@ -107,7 +154,8 @@ static void e820_pmem_remove(struct platform_device *pdev)
 	nvdimm_bus_unregister(nvdimm_bus);
 }
 
-static int register_one_pmem(struct resource *res, struct nvdimm_bus *nvdimm_bus)
+static int register_one_pmem(struct resource *res, struct nvdimm_bus *nvdimm_bus,
+			     struct pmem_entry *entry)
 {
 	struct nd_region_desc ndr_desc;
 	int nid = phys_to_target_node(res->start);
@@ -117,6 +165,10 @@ static int register_one_pmem(struct resource *res, struct nvdimm_bus *nvdimm_bus
 	ndr_desc.numa_node = numa_map_to_online_node(nid);
 	ndr_desc.target_node = nid;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
+	if (entry && entry->treat_as_devdax) {
+		set_bit(ND_REGION_DEVDAX, &ndr_desc.flags);
+		ndr_desc.provider_data = (void *)entry->align;
+	}
 	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
 		return -ENXIO;
 	return 0;
@@ -138,7 +190,7 @@ static int e820_handle_one_entry(struct resource *res, void *data)
 	entry = xa_load(walk_data->pmem_xarray, res->start);
 
 	if (!entry)
-		return register_one_pmem(res, walk_data->nvdimm_bus);
+		return register_one_pmem(res, walk_data->nvdimm_bus, NULL);
 
 	if (entry_size % entry->region_size != 0) {
 		pr_err("Entry size %lu is not divisible by region size %lu\n",
@@ -149,7 +201,7 @@ static int e820_handle_one_entry(struct resource *res, void *data)
 	res_local.start = res->start;
 	res_local.end = res->start + entry->region_size - 1;
 	while (res_local.end <= res->end) {
-		rc = register_one_pmem(&res_local, walk_data->nvdimm_bus);
+		rc = register_one_pmem(&res_local, walk_data->nvdimm_bus, entry);
 		if (rc)
 			return rc;
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 5ca06e9a2d29..d53393d9e027 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -571,6 +571,7 @@ struct device *nd_pfn_create(struct nd_region *nd_region);
 struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
 		struct nd_namespace_common *ndns);
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig);
+int nd_pfn_set_dax_defaults(struct nd_pfn *nd_pfn);
 extern const struct attribute_group *nd_pfn_attribute_groups[];
 #else
 static inline int nd_pfn_probe(struct device *dev,
@@ -593,6 +594,11 @@ static inline int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	return -ENODEV;
 }
+
+static inline int nd_pfn_set_dax_defaults(struct nd_pfn *nd_pfn)
+{
+	return -ENODEV;
+}
 #endif
 
 struct nd_dax *to_nd_dax(struct device *dev);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index cfdfe0eaa512..4fea24df6e56 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -438,6 +438,76 @@ static bool nd_supported_alignment(unsigned long align)
 	return false;
 }
 
+static unsigned long nd_best_supported_alignment(unsigned long start,
+						 unsigned long end)
+{
+	int i;
+	unsigned long ret = 0, supported[MAX_NVDIMM_ALIGN] = { [0] = 0, };
+
+	nd_pfn_supported_alignments(supported);
+	for (i = 0; supported[i]; i++)
+		if (IS_ALIGNED(start, supported[i]) &&
+		    IS_ALIGNED(end + 1, supported[i]))
+			ret = supported[i];
+		else
+			break;
+
+	return ret;
+}
+
+static int nd_pfn_checks(struct nd_pfn *nd_pfn, u64 offset,
+			 unsigned long start_pad, unsigned long end_trunc)
+{
+	/*
+	 * These warnings are verbose because they can only trigger in
+	 * the case where the physical address alignment of the
+	 * namespace has changed since the pfn superblock was
+	 * established.
+	 */
+	struct nd_namespace_common *ndns = nd_pfn->ndns;
+	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	struct resource *res = &nsio->res;
+	resource_size_t res_size = resource_size(res);
+	unsigned long align = nd_pfn->align;
+
+	if (align > nvdimm_namespace_capacity(ndns)) {
+		dev_err(&nd_pfn->dev, "alignment: %lx exceeds capacity %llx\n",
+			align, nvdimm_namespace_capacity(ndns));
+		return -EOPNOTSUPP;
+	}
+
+	if (offset >= res_size) {
+		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
+			dev_name(&ndns->dev));
+		return -EOPNOTSUPP;
+	}
+
+	if ((align && !IS_ALIGNED(res->start + offset + start_pad, align)) ||
+	    !IS_ALIGNED(offset, PAGE_SIZE)) {
+		dev_err(&nd_pfn->dev,
+			"bad offset: %#llx dax disabled align: %#lx\n",
+			offset, align);
+		return -EOPNOTSUPP;
+	}
+
+	if (!IS_ALIGNED(res->start + start_pad, memremap_compat_align())) {
+		dev_err(&nd_pfn->dev, "resource start misaligned\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!IS_ALIGNED(res->end + 1 - end_trunc, memremap_compat_align())) {
+		dev_err(&nd_pfn->dev, "resource end misaligned\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (offset >= (res_size - start_pad - end_trunc)) {
+		dev_err(&nd_pfn->dev, "bad offset with small namespace\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 /**
  * nd_pfn_validate - read and validate info-block
  * @nd_pfn: fsdax namespace runtime state / properties
@@ -450,10 +520,7 @@ static bool nd_supported_alignment(unsigned long align)
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	u64 checksum, offset;
-	struct resource *res;
 	enum nd_pfn_mode mode;
-	resource_size_t res_size;
-	struct nd_namespace_io *nsio;
 	unsigned long align, start_pad, end_trunc;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
@@ -572,52 +639,53 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		}
 	}
 
-	if (align > nvdimm_namespace_capacity(ndns)) {
-		dev_err(&nd_pfn->dev, "alignment: %lx exceeds capacity %llx\n",
-				align, nvdimm_namespace_capacity(ndns));
-		return -EOPNOTSUPP;
-	}
+	return nd_pfn_checks(nd_pfn, offset, start_pad, end_trunc);
+}
+EXPORT_SYMBOL(nd_pfn_validate);
 
-	/*
-	 * These warnings are verbose because they can only trigger in
-	 * the case where the physical address alignment of the
-	 * namespace has changed since the pfn superblock was
-	 * established.
-	 */
-	nsio = to_nd_namespace_io(&ndns->dev);
-	res = &nsio->res;
-	res_size = resource_size(res);
-	if (offset >= res_size) {
-		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
-				dev_name(&ndns->dev));
-		return -EOPNOTSUPP;
-	}
+int nd_pfn_set_dax_defaults(struct nd_pfn *nd_pfn)
+{
+	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
+	struct nd_namespace_common *ndns = nd_pfn->ndns;
+	struct nd_region *nd_region = to_nd_region(nd_pfn->dev.parent);
+	struct nd_namespace_io *nsio;
+	struct resource *res;
+	unsigned long align;
 
-	if ((align && !IS_ALIGNED(res->start + offset + start_pad, align))
-			|| !IS_ALIGNED(offset, PAGE_SIZE)) {
-		dev_err(&nd_pfn->dev,
-				"bad offset: %#llx dax disabled align: %#lx\n",
-				offset, align);
-		return -EOPNOTSUPP;
-	}
+	if (!pfn_sb || !ndns)
+		return -ENODEV;
 
-	if (!IS_ALIGNED(res->start + start_pad, memremap_compat_align())) {
-		dev_err(&nd_pfn->dev, "resource start misaligned\n");
-		return -EOPNOTSUPP;
-	}
+	if (!is_memory(nd_pfn->dev.parent))
+		return -ENODEV;
 
-	if (!IS_ALIGNED(res->end + 1 - end_trunc, memremap_compat_align())) {
-		dev_err(&nd_pfn->dev, "resource end misaligned\n");
-		return -EOPNOTSUPP;
+	if (nd_region->provider_data) {
+		align = (unsigned long)nd_region->provider_data;
+	} else {
+		nsio = to_nd_namespace_io(&ndns->dev);
+		res = &nsio->res;
+		align = nd_best_supported_alignment(res->start, res->end);
+		if (!align) {
+			dev_err(&nd_pfn->dev, "init failed, resource misaligned\n");
+			return -EOPNOTSUPP;
+		}
 	}
 
-	if (offset >= (res_size - start_pad - end_trunc)) {
-		dev_err(&nd_pfn->dev, "bad offset with small namespace\n");
-		return -EOPNOTSUPP;
+	memset(pfn_sb, 0, sizeof(*pfn_sb));
+
+	if (!nd_pfn->uuid) {
+		nd_pfn->uuid = kmemdup(pfn_sb->uuid, 16, GFP_KERNEL);
+		if (!nd_pfn->uuid)
+			return -ENOMEM;
+		nd_pfn->align = align;
+		nd_pfn->mode = PFN_MODE_RAM;
 	}
-	return 0;
+
+	pfn_sb->align = cpu_to_le64(nd_pfn->align);
+	pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
+
+	return nd_pfn_checks(nd_pfn, 0, 0, 0);
 }
-EXPORT_SYMBOL(nd_pfn_validate);
+EXPORT_SYMBOL(nd_pfn_set_dax_defaults);
 
 int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 {
@@ -704,7 +772,7 @@ static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap)
 	};
 	pgmap->nr_range = 1;
 	if (nd_pfn->mode == PFN_MODE_RAM) {
-		if (offset < reserve)
+		if (offset && offset < reserve)
 			return -EINVAL;
 		nd_pfn->npfns = le64_to_cpu(pfn_sb->npfns);
 	} else if (nd_pfn->mode == PFN_MODE_PMEM) {
@@ -729,7 +797,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	resource_size_t start, size;
-	struct nd_region *nd_region;
+	struct nd_region *nd_region = to_nd_region(nd_pfn->dev.parent);
 	unsigned long npfns, align;
 	u32 end_trunc;
 	struct nd_pfn_sb *pfn_sb;
@@ -748,6 +816,9 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	else
 		sig = PFN_SIG;
 
+	if (test_bit(ND_REGION_DEVDAX, &nd_region->flags))
+		return nd_pfn_set_dax_defaults(nd_pfn);
+
 	rc = nd_pfn_validate(nd_pfn, sig);
 	if (rc == 0)
 		return nd_pfn_clear_memmap_errors(nd_pfn);
@@ -757,7 +828,6 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	/* no info block, do init */;
 	memset(pfn_sb, 0, sizeof(*pfn_sb));
 
-	nd_region = to_nd_region(nd_pfn->dev.parent);
 	if (nd_region->ro) {
 		dev_info(&nd_pfn->dev,
 				"%s is read-only, unable to init metadata\n",
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index e772aae71843..a07f3f81975c 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -70,6 +70,9 @@ enum {
 	/* Region was created by CXL subsystem */
 	ND_REGION_CXL = 4,
 
+	/* Region is supposed to be treated as devdax */
+	ND_REGION_DEVDAX = 5,
+
 	/* mark newly adjusted resources as requiring a label update */
 	DPA_RESOURCE_ADJUSTED = 1 << 0,
 };
-- 
2.50.0.rc1.591.g9c95f17f64-goog

