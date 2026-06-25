Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565DE3E0255
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389600; cv=none; b=p1Vhdo4VUC7jdwjhJ99rspHzTPgYQ4qcA11d1cuSupUT7gRxpFa9GgBFS7K8ivqwS0lDBc0TUIuTD7W5QseWMuKcyumJBMDwG4s+HcZvlkzY22shDEER9ew8TTVNFRNhDfZMXtNL5D374xDakD+rB56k8rq+RYksma9fYS8LZo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389600; c=relaxed/simple;
	bh=E0KCu+shOnjqoTTudhIIT2SmGguJsEGXVPKrXtwW66M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpJF7pUSL8A/wrS+fZ8+CuugReaR/nvvJplFaCrlyDnwWlmuaiT055FwNMYQRcVY4WA3xaNOFfeBvza7aDROfawDojEDWhuXQA+eAOhBMeOijL7kuVydNmvFnd5g9NkK2rFm1czH5Q9nTHIgUzB5ygAKAsYH5wDsygFYgWDVcUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JD3fhP4B; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JD3fhP4B"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-139b5e604b9so2508434c88.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 05:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782389598; x=1782994398; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfG1GvsOHrjJK0b4qKYTwwusEHt1awKD6HYfwbXh22U=;
        b=JD3fhP4BUsDB8AqQupRuucA9iMMmFA4MEVSLsWzy7uUY8pVfNX/gcWppGqiXL8icv+
         dHrRpu2EAfGhTegRBY6q5ycrx8uBS0qRw+96lN1RzFYVtG90c2qa+xoufU18qY0kNP9r
         TzOhclFvTIQVs5z8Tns4+bKldCARX1sa6hrubWlDrrQJ6N+0htknuDdS0vDFEFDGq7B5
         jZDJhrL0S/ZKGX96GPueRxKrjn3kFTiEyMVeOZtQnrZYQAYfVfI7pCJerpkeXx8Qt/4S
         wFu6R0DmgciWP0HLWFDMyfo7wC87XTPImkSbE5h/N0D25f5k6sOoBzTW2SKmTqe50JFg
         wR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782389598; x=1782994398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dfG1GvsOHrjJK0b4qKYTwwusEHt1awKD6HYfwbXh22U=;
        b=oS6HUq8KRX95ic4PKImWLpxo7rsAbAgZ1HXA7lsEZTPZwza0cF+4Vkvo9FzQmKuuWm
         xAsqwHFKRxiVeZ38blnmgxaytoF1SSA6RAW+rVWaWvoyKLP8tpaa356kFB8iteT6Ambl
         4baotWvAMZNDy34AniE4EoLGJ/I1j/bEjeStPiEON5bCE95y8pt9Xd4cLTt5pmlo7u7i
         skXWyS9LSSLGYABJTMh5R4N+Sulipthgv9oYIj9RhxE5qU8XUs0faA/7GaPWvQI4FeBW
         rQk1ohAI6NRQ0QhMTzl1obiV8fOfsn/V4oYt+PYRnIlh9W/3Kj0Rq7/MO0skanEENscZ
         iNMw==
X-Gm-Message-State: AOJu0Yxd2jaO8VmlkEN11Ryg3jnLzMs3oduNoVMzhVPxG31VGaqwYNTb
	knGAq3DroHlo7XrEXlWiiCPjy8YfN1hZzLK0RbcNcmm9sXMpkw9goBdz
X-Gm-Gg: AfdE7clACuJgmqwFMxyqMGSE2Y6uqhs2046XTraqhNky7K3Gw1iMQU4Q0sIgAw4uUIO
	f0y35PpuNLgELTwysV//gW7Klmeq7PCsaXso526tgsUvkal3vgBFfZCII3XSNQp960G+RGqQrNq
	igN+NcSqqRdDkkofU+4Z0OOvV/08502j63DtPxG+V7Qc2Ms01c2VO49guC0up+iD/jR/ScumTnl
	L+xjFQlu7fr4aVQK0NHUgwkKVy6j8X/7wQJ8jq8+NWjzEP+81jtaiAOP6zFfotYok65OG8UIU/6
	TafCHkNxNTz56wWiQU8JsovXvaaIhld1SWWd0Nkb9Ak92A7zf8PSsF6k5TRmZ49xc4LnfV1du+b
	/D3NDddTOwsxa7Ng/gmi7gMHRAhHneMhC3vTuc922IwepyXDQueLvV2rfr3L6fYgijC5SToY4Vc
	NXpUEke8iFN8YnxiDUbQeNeOFARM1IDdqaEpOera/PPYxnpJnq2JL2VFPahx81Te38LIWa
X-Received: by 2002:a05:7022:69a0:b0:137:fe07:8a2c with SMTP id a92af1059eb24-139dbac2ef7mr2452942c88.22.1782389598245;
        Thu, 25 Jun 2026 05:13:18 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f77602sm7422206c88.8.2026.06.25.05.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 05:13:17 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>
Subject: [NDCTL PATCH v7 4/5] daxctl: Add --uuid option to create-device for sparse regions
Date: Thu, 25 Jun 2026 05:09:38 -0700
Message-ID: <20260625121242.603807-5-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625121242.603807-1-anisa.su@samsung.com>
References: <20260625121242.603807-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a --uuid option to 'daxctl create-device' that writes the given
uuid to the new dax device's sysfs 'uuid' attribute.  On sparse (DCD)
regions this claims dax_resources whose tag matches and populates the
seed device with their capacity; size is determined by the claim, so
--uuid is mutually exclusive with --size.

Pass "0" to claim a single untagged dax_resource.  A claim that
matches no dax_resource leaves the device at size 0; the kernel
returns ENOENT.

Plumb the write through a new daxctl_dev_set_uuid() libdaxctl helper
(LIBDAXCTL_12) and document the option in the man page.

Signed-off-by: Anisa Su <anisa.su@samsung.com>
---
 Documentation/daxctl/daxctl-create-device.txt | 12 ++++
 daxctl/device.c                               | 72 +++++++++++++------
 daxctl/lib/libdaxctl.c                        | 53 ++++++++++++++
 daxctl/lib/libdaxctl.sym                      |  5 ++
 daxctl/libdaxctl.h                            |  1 +
 5 files changed, 123 insertions(+), 20 deletions(-)

diff --git a/Documentation/daxctl/daxctl-create-device.txt b/Documentation/daxctl/daxctl-create-device.txt
index b774b86..27b87d0 100644
--- a/Documentation/daxctl/daxctl-create-device.txt
+++ b/Documentation/daxctl/daxctl-create-device.txt
@@ -82,6 +82,18 @@ include::region-option.txt[]
 
 	The size must be a multiple of the region alignment.
 
+	Mutually exclusive with --uuid.
+
+--uuid=::
+	For dax devices on sparse (DCD) regions, claim dax_resource(s) whose
+	tag matches the given UUID.  The device's size is determined by the
+	claimed capacity, so --uuid cannot be combined with --size.
+
+	A non-null UUID claims every matching dax_resource in the parent
+	region.  The value "0" is shorthand for the null UUID and claims a
+	single untagged dax_resource.  A write that matches no dax_resource
+	fails with ENOENT and the device is left at size 0.
+
 -a::
 --align::
 	Applications that want to establish dax memory mappings with
diff --git a/daxctl/device.c b/daxctl/device.c
index 47942f1..4213420 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -30,6 +30,7 @@ static struct {
 	const char *size;
 	const char *align;
 	const char *input;
+	const char *uuid;
 	bool check_config;
 	bool no_online;
 	bool no_movable;
@@ -86,7 +87,9 @@ OPT_BOOLEAN('C', "check-config", &param.check_config, \
 #define CREATE_OPTIONS() \
 OPT_STRING('s', "size", &param.size, "size", "size to switch the device to"), \
 OPT_STRING('a', "align", &param.align, "align", "alignment to switch the device to"), \
-OPT_STRING('\0', "input", &param.input, "input", "input device JSON file")
+OPT_STRING('\0', "input", &param.input, "input", "input device JSON file"), \
+OPT_STRING('\0', "uuid", &param.uuid, "uuid", \
+	"claim sparse dax_resource(s) matching this uuid (\"0\" for untagged)")
 
 #define DESTROY_OPTIONS() \
 OPT_BOOLEAN('f', "force", &param.force, \
@@ -864,6 +867,22 @@ static int do_create(struct daxctl_region *region, long long val,
 	struct daxctl_dev *dev;
 	int i, rc = 0;
 	long long alloc = 0;
+	uuid_t uuid;
+
+	if (param.uuid) {
+		if (param.size) {
+			fprintf(stderr,
+				"--uuid and --size are mutually exclusive\n");
+			return -EINVAL;
+		}
+		if (strcmp(param.uuid, "0") == 0) {
+			uuid_clear(uuid);
+		} else if (uuid_parse(param.uuid, uuid) < 0) {
+			fprintf(stderr, "failed to parse uuid '%s'\n",
+				param.uuid);
+			return -EINVAL;
+		}
+	}
 
 	if (daxctl_region_create_dev(region))
 		return -ENOSPC;
@@ -872,33 +891,46 @@ static int do_create(struct daxctl_region *region, long long val,
 	if (!dev)
 		return -ENOSPC;
 
-	if (val == -1)
-		val = daxctl_region_get_available_size(region);
-
-	if (val <= 0)
-		return -ENOSPC;
-
 	if (align > 0) {
 		rc = daxctl_dev_set_align(dev, align);
 		if (rc < 0)
 			return rc;
 	}
 
-	/* @maps is ordered by page_offset */
-	for (i = 0; i < nmaps; i++) {
-		rc = daxctl_dev_set_mapping(dev, maps[i].start, maps[i].end);
-		if (rc < 0)
+	if (param.uuid) {
+		rc = daxctl_dev_set_uuid(dev, uuid);
+		if (rc < 0) {
+			fprintf(stderr,
+				"%s: failed to claim uuid '%s': %s\n",
+				daxctl_dev_get_devname(dev), param.uuid,
+				strerror(-rc));
 			return rc;
-		alloc += (maps[i].end - maps[i].start + 1);
-	}
-
-	if (nmaps > 0 && val > 0 && alloc != val) {
-		fprintf(stderr, "%s: allocated %lld but specified size %lld\n",
-			daxctl_dev_get_devname(dev), alloc, val);
+		}
 	} else {
-		rc = daxctl_dev_set_size(dev, val);
-		if (rc < 0)
-			return rc;
+		if (val == -1)
+			val = daxctl_region_get_available_size(region);
+
+		if (val <= 0)
+			return -ENOSPC;
+
+		/* @maps is ordered by page_offset */
+		for (i = 0; i < nmaps; i++) {
+			rc = daxctl_dev_set_mapping(dev, maps[i].start,
+						    maps[i].end);
+			if (rc < 0)
+				return rc;
+			alloc += (maps[i].end - maps[i].start + 1);
+		}
+
+		if (nmaps > 0 && val > 0 && alloc != val) {
+			fprintf(stderr,
+				"%s: allocated %lld but specified size %lld\n",
+				daxctl_dev_get_devname(dev), alloc, val);
+		} else {
+			rc = daxctl_dev_set_size(dev, val);
+			if (rc < 0)
+				return rc;
+		}
 	}
 
 	rc = daxctl_dev_enable_devdax(dev);
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 01b1915..0302bd6 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1166,6 +1166,59 @@ DAXCTL_EXPORT int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long
 	return 0;
 }
 
+DAXCTL_EXPORT int daxctl_dev_set_uuid(struct daxctl_dev *dev, uuid_t uuid)
+{
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	char buf[SYSFS_ATTR_SIZE];
+	char *path = dev->dev_buf;
+	int len = dev->buf_len;
+	int rc;
+
+	rc = snprintf(path, len, "%s/uuid", dev->dev_path);
+	if (rc < 0)
+		return rc;
+	if (rc >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
+	}
+
+	if (uuid_is_null(uuid))
+		sprintf(buf, "0\n");
+	else
+		uuid_unparse(uuid, buf);
+
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0) {
+		err(ctx, "%s: failed to set uuid\n",
+				daxctl_dev_get_devname(dev));
+		return rc;
+	}
+
+	/*
+	 * On a sparse region the kernel populates the device size as a
+	 * side effect of claiming the matching dax_resource(s); refresh
+	 * the cached size so callers see the post-claim value.
+	 */
+	rc = snprintf(path, len, "%s/size", dev->dev_path);
+	if (rc < 0)
+		return rc;
+	if (rc >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
+	}
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0) {
+		err(ctx, "%s: failed to read back size\n",
+				daxctl_dev_get_devname(dev));
+		return rc;
+	}
+	dev->size = strtoull(buf, NULL, 0);
+
+	return 0;
+}
+
 DAXCTL_EXPORT unsigned long daxctl_dev_get_align(struct daxctl_dev *dev)
 {
 	return dev->align;
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index 43dd60b..e020abf 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -113,3 +113,8 @@ global:
 	daxctl_dev_get_mode;
 	daxctl_dev_is_system_ram_mode;
 } LIBDAXCTL_10;
+
+LIBDAXCTL_12 {
+global:
+	daxctl_dev_set_uuid;
+} LIBDAXCTL_11;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 7ec159e..17e46ac 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -63,6 +63,7 @@ int daxctl_dev_get_minor(struct daxctl_dev *dev);
 unsigned long long daxctl_dev_get_resource(struct daxctl_dev *dev);
 unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev);
 int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long size);
+int daxctl_dev_set_uuid(struct daxctl_dev *dev, uuid_t uuid);
 unsigned long daxctl_dev_get_align(struct daxctl_dev *dev);
 int daxctl_dev_set_align(struct daxctl_dev *dev, unsigned long align);
 int daxctl_dev_set_mapping(struct daxctl_dev *dev, unsigned long long start,
-- 
2.43.0

