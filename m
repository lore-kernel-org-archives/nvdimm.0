Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544B2388880
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529865; cv=none; b=JZNpaEXKC78ktUNMab4SRo91efXW77HcWBXAsu80b0wNPkbFbpXT+6dEvGSDLsENPePrs3oKurgS5rteEdfYPG0VL0me1HUT/gj6vugmiNTMf2tQ0qQDC8ocRufcK+9rdp1fZDpklmaQt9mqTd0a+9Mvt4BNmFG6UiQu4+nRiX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529865; c=relaxed/simple;
	bh=tFqQsGU4YMclvzyjM/t/SmKlVFs+8DFj8coV+9Hd2UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh1E9QosL8EtYsFmEGyYTl6nXxeIvY6XcFlOsUYbmQO2DRH3/jHlFGEnCrFHeGQr/nObFLeAmgW5NXAjUJfkJMavO+GKXG8HyyFLvn1Lj4JiFre5/gSy4IbK+mgrKWHAAR4g9NUOpBbLPXFtoVEdvLbNCbQ8iwux9xk3RQmtq84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYeujhtm; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYeujhtm"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-30455f77e0eso1450653eec.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529862; x=1780134662; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aodjqU71q5Sim+/ucvlcfxJnExv66QvS4xQXwlcU+co=;
        b=QYeujhtm84Iyio4qFoPYLFTLo4AJxh9B0/dXsn1VyNoG7b7IbEMi1DEAT3SQJVZbWM
         wah67k4wQ9w0TKIJpTePbHE2x7hGw2F09wkBRC+RWaB0cKyJzmOGqFlXiLHkbuCxXhwc
         93jL4luvKnPayr6ZKwsB+doD5rvSkaIgfPMSPQmUdGpAfMA7qvDVLe55jXE8kx58zd4P
         kir5hX0IgMtFlMtWjN9JYHOrQ6lBDShRAkwABN3dYX4VQTjVF6ZBOoV4f8Q6U7tqqnPt
         EzPH8/4ohHDQzOIUs8nEbSs+fLRWTbtIpbnpL4cVANYSKtC33f/dFy7PAw/h107qXXtz
         dpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529862; x=1780134662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aodjqU71q5Sim+/ucvlcfxJnExv66QvS4xQXwlcU+co=;
        b=hUbrke2iuzkbeufdRe2oF48UDoFMdwkvvP47RSiwdpEfXkUDmuwLmlvnYLzjz7SdwG
         Z4YvhRbplnCy36f7d8AtCZ8VrpyHUTQBtxq4H6yguykN/DNmt87a+9ZN5h5driJA20S2
         RPHf4K+invovtk8lm2ovN6CksKXv68CJEnRa7u6Bp0X7CT3Vyq+zMQtl0W+UcVHxJ60y
         2ys6KuaU0acS3Ml0r1PxlIFjjy8Q5IdAzlB3j/o/+a/JJd42YAw1qTNU/dssnEYywHhf
         AUk6EoIa1bertIGTmqzNghWd1dXVz1l6S5wN6nYybUsnqR/GpayWVQxthAilTqmw7r8P
         p5fg==
X-Gm-Message-State: AOJu0Yzr4stwZvXpDOver6sOuedc52+IWgdFpdaNjXQo8jydIePe0jRG
	zNVIxGyafqJGE7mEjqHQtTNI53t1nycaEqB3hJHAuF6ubDpX9CuehsEZ
X-Gm-Gg: Acq92OFF1ZnRnTTBgSi0Gl9ix2t0Ao4/cODK1OR5f5Kj1OTXU+Qyhg5qYLWSBH3sMI/
	GkuKPHCvMnFhvqBDU1sGjO++6NeEjf5zFx4LtOPq9wLA9ZZHB0BfYJMczl98U9r1HrIQUxlpuLR
	9HjoxuO6OpSFtlZFdjTJuZILRVS4mo5Gt0KoniGEHIfjnK0NTbdH/PvjhEuxlEXVYwiq7sMVbCg
	avl5IgpgJ1kIfraPHcY84/NUkxU+q1d9QZuWJKyi6N5XqNTEP28FtjBtv7vKM06J2d0eQXrv/sQ
	AODaEzZiyQCX6b7EcIsKgMS4unlnB0a7rsCL3QpM3/cOo3AA8Da+iZ0iSFhzB2D8mvBdq7szXMU
	8aZ8kN8+Th91uUoF+LTOiV/77CIcUMaWr/+A/Yeb2bZSTBEBtNKCD6wknClz4RqRS/QAUv47omx
	9kf/8N6s4lecmDg3q/7ep/Hgx6kmaxeK9/TxUEzZ/MFG911yyEZ6GQ3WUIiZD/zt+SAWi/3QPWI
	+D46kER3Ic1QB9dWg==
X-Received: by 2002:a05:7301:4918:b0:2e6:e868:4f38 with SMTP id 5a478bee46e88-30449024c7bmr3195686eec.3.1779529862486;
        Sat, 23 May 2026 02:51:02 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm4595756eec.25.2026.05.23.02.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:51:02 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>,
	Anisa Su <anisa.su887@gmail.com>
Subject: [PATCH v6 6/7] daxctl: Add --uuid option to create-device for sparse regions
Date: Sat, 23 May 2026 02:50:41 -0700
Message-ID: <20260523095043.471098-7-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
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
(LIBDAXCTL_11) and document the option in the man page.

Signed-off-by: Anisa Su <anisa.su887@gmail.com>
---
 Documentation/daxctl/daxctl-create-device.txt | 12 ++++
 daxctl/device.c                               | 72 +++++++++++++------
 daxctl/lib/libdaxctl.c                        | 44 ++++++++++++
 daxctl/lib/libdaxctl.sym                      |  5 ++
 daxctl/libdaxctl.h                            |  1 +
 5 files changed, 114 insertions(+), 20 deletions(-)

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
index a4e36b1..21a941e 100644
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
@@ -85,7 +86,9 @@ OPT_BOOLEAN('C', "check-config", &param.check_config, \
 #define CREATE_OPTIONS() \
 OPT_STRING('s', "size", &param.size, "size", "size to switch the device to"), \
 OPT_STRING('a', "align", &param.align, "align", "alignment to switch the device to"), \
-OPT_STRING('\0', "input", &param.input, "input", "input device JSON file")
+OPT_STRING('\0', "input", &param.input, "input", "input device JSON file"), \
+OPT_STRING('\0', "uuid", &param.uuid, "uuid", \
+	"claim sparse dax_resource(s) matching this uuid (\"0\" for untagged)")
 
 #define DESTROY_OPTIONS() \
 OPT_BOOLEAN('f', "force", &param.force, \
@@ -808,6 +811,22 @@ static int do_create(struct daxctl_region *region, long long val,
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
@@ -816,33 +835,46 @@ static int do_create(struct daxctl_region *region, long long val,
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
index 02ae7e5..fe07939 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1107,6 +1107,50 @@ DAXCTL_EXPORT int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long
 	return 0;
 }
 
+DAXCTL_EXPORT int daxctl_dev_set_uuid(struct daxctl_dev *dev, uuid_t uuid)
+{
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	char buf[SYSFS_ATTR_SIZE];
+	char *path = dev->dev_buf;
+	int len = dev->buf_len;
+
+	if (snprintf(path, len, "%s/uuid", dev->dev_path) >= len) {
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
+	if (sysfs_write_attr(ctx, path, buf) < 0) {
+		err(ctx, "%s: failed to set uuid\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
+	}
+
+	/*
+	 * On a sparse region the kernel populates the device size as a
+	 * side effect of claiming the matching dax_resource(s); refresh
+	 * the cached size so callers see the post-claim value.
+	 */
+	if (snprintf(path, len, "%s/size", dev->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
+	}
+	if (sysfs_read_attr(ctx, path, buf) < 0) {
+		err(ctx, "%s: failed to read back size\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
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
index 3098811..16792eb 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -104,3 +104,8 @@ LIBDAXCTL_10 {
 global:
 	daxctl_dev_is_system_ram_capable;
 } LIBDAXCTL_9;
+
+LIBDAXCTL_11 {
+global:
+	daxctl_dev_set_uuid;
+} LIBDAXCTL_10;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 53c6bbd..cdd5995 100644
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

