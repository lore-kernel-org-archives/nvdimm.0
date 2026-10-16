Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6157340EB91
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 21:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186980; cv=none; b=tAXlt63czD6wSO5Vy1X85rVeebAHjxdEaWqlH3JBCnem8i1UeOCnVAp0eV8EnG2rdi+06SZwqkXN5U5xZWXUjfv93ENZCBwEt4xAdaoWFkN3hEYQ5gqxarrq0UYElvJ3L9WV7XtcEWTmyDiL/EvF7zAkxQdKChcBGTIAkOYTMRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186980; c=relaxed/simple;
	bh=MaJyLKfEFkwt0tCY+isqmy8S4HZq1gBm/vsuIioFA0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3uaZeRnabp+OYkjba4yhPluU8aJGbjIVW2+BItQbPdhKiQFVmIUjQ8xjWYkyEmc2RdIF8LYkI5m5/3YGmouYp+Dru2fMoGsS3SndDFbGD/AYVgUCdEC9HOcddrbMgCOe8vxVA1KELDkAfXNT/Xw4b4JkycnagD+BLUgsU0hvM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=hze5Ziax; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="hze5Ziax"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-9179bfa9e9cso6578196d6.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792186978; x=1792791778; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7MJLgBfxx+DZnWh1hc6BeLSdrKP2xfVHQ/GKNMuuDIE=;
        b=hze5ZiaxYR/6g/sBi0OnJjVaGRkX9LMVyvO9bQnPRmFpmH5pfoSWsPk6OYSFVqhuGr
         XdcjjKGE4EZ6vKJFZ9HRxsGvcTH0CuY2poPG7KFXsOvPIbqzY0Ov2CZCnnSAywuaPMn3
         onwg09a0PYY42F391SuVvdeeoNuLMV7uSg1nubFj4fOwD32hypxV71XSM2JHIjjYDOTr
         aMRpLfEkZL3KnDclXmrhqHGWZZkgXouWQuQ6puvFLK4myVC7p3WAXD92UHktJLHvGNIZ
         M9l4SJqwuV+zMoFqzrvgwGmtYDOh79qBOYZs3VZiugwtHnH0qRJ8JdnE9tV5KBcFCwE2
         8B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792186978; x=1792791778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7MJLgBfxx+DZnWh1hc6BeLSdrKP2xfVHQ/GKNMuuDIE=;
        b=dxAfcaXO9+COI1zvRbjN8ZQM+sX9cjdo6YvyAr5AFT7tPy3fKMlQ4il3msPWtMybIy
         pGmIDI2vErJdoBcVIaUjzmAH7xKHhs9iGC+HSZupOZ/24ctBNUParmR37nrr/urm7do/
         4kqMjhuRdXokGuhb3mBuh0Wq6YSySm3dKXYcuwxShBIPxd5O/rXrYH58Y1g5SFqpqUwQ
         i9qnytu6MLnqOq3XarOQ9BwZpGGisTGPKZCrqjbBq9n0OwwWcvmzrdCl4pPlsoIIDPVa
         bT8/Qm6ZYY0T6rPSPeXrHAPpsy+krbqNQEvQwJpHdvifeh4aK3izg9zE1T8RjlTNRjgM
         qcfw==
X-Gm-Message-State: AFq9FYIGadXMYU3F9sfOlUSJqV6fD93D9+PakWYN9QgkuVDG2lqDObi7
	vBDfjaoM2JpIvRGZ5FCkGaPZmmv7oXHxxRI52kV7qlGHptJL77UvSSUuDBtbN2i66IYlFPG3JPo
	RswErgsQ=
X-Gm-Gg: AYBFou2eGqajBoSQUR7WlzCnRBV9B1JbwZPIjRRaLLUacXWZWCshLemIljd6hZgT01j
	IjoyDTzHy78iHR318Iqrr1Sn5vmIrF1AGzBK0ZRxhbWMUIKOlj1ksnoQpBv4jSTU2nhU54VqM9q
	ojUxX0JS0xnvaEPsDMBWl1vC13M7f/uBLZ5BBQUJZZNZu8gLEGWSQKszvOgbYdRPRCfQK4lBy8I
	tSoUgBh0IOA2AXNNTLiDyxX72l9BRmP+KmQk/CsAADQ8fbC38Z91fBXmmqg5SzDg56Dfz8A7Qn1
	33cA9X7GJDU9rKn6VIDtw366l1jLtNMvPmfByPKvBSs/laqv7XgMYWoYgGIhDHp/RWjAk4/QK16
	7JODkcAqgVWH3lPPmg/CLjOWhKdGcmmoLwnzpo/vJGdSCLqpcnowiupiqvnJcBIgHCqG6rA18mX
	IktXgDNGS9v/kiBoS+lsj4XqZsVXnGe07xDLpoDOmBR7Dxl+bVT7NGzRityoNTcVdOUAMvD8bNJ
	MzYpUZb8Yp06aB1due9D8VfBpZ4IlBYcqPxkNMq/tQqFCcmtGTrH8wmGV4+
X-Received: by 2002:a05:620a:7018:b0:93e:4d60:d389 with SMTP id af79cd13be357-93f29cccec2mr230239585a.25.1792186978398;
        Fri, 16 Oct 2026 14:42:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a8ee1sm312622985a.34.2026.10.16.14.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:42:58 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH 3/6] daxctl: offline whole-device memory via atomic unplug when available
Date: Fri, 16 Oct 2026 17:42:45 -0400
Message-ID: <20261016214248.443247-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016214248.443247-1-gourry@gourry.net>
References: <20261016214248.443247-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gregory Price <gourry@gourry.net>

When the kernel provides daxX.Y/state, offline by writing 'unplugged'.
The kernel offlines and removes the whole device atomically, so no
agent can online blocks before a later unbind. On failure the device
is left unchanged.

The memory blocks are removed rather than left offline, including
when they are all offline already; 'daxctl online-memory' restores
them. If they are all offline and the unplug fails (e.g. no memory
hotremove support), this remains a no-op.

Unplugging a node's last memory removes its sysfs directory, so treat
a missing node directory as zero blocks when the device is unplugged.
'daxctl list' likewise omits 'movable' for a device with no blocks.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 daxctl/device.c        | 51 +++++++++++++++++++++++++++++++++++++++---
 daxctl/json.c          |  6 ++++-
 daxctl/lib/libdaxctl.c | 12 ++++++++--
 3 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index fd84799..99c0d96 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -694,7 +694,8 @@ static int dev_offline_memory(struct daxctl_dev *dev)
 {
 	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
 	const char *devname = daxctl_dev_get_devname(dev);
-	int num_sections, num_on, num_off, rc;
+	int num_sections, num_on, num_off, rc, unplug;
+	enum daxctl_kmem_state state;
 
 	if (!mem) {
 		fprintf(stderr, "%s: failed to get the memory object\n",
@@ -717,17 +718,61 @@ static int dev_offline_memory(struct daxctl_dev *dev)
 		return num_on;
 	}
 
+	/*
+	 * Unplug atomically where supported, even if already offline, so
+	 * no agent can online blocks before a later unbind.
+	 */
+	state = daxctl_dev_get_kmem_state(dev);
+	unplug = state != DAXCTL_KMEM_UNKNOWN && state != DAXCTL_KMEM_UNPLUGGED;
+
 	num_off = num_sections - num_on;
-	if (num_off == num_sections) {
+	if (num_off == num_sections && !unplug) {
 		fprintf(stderr, "%s: all memory sections (%d) already offline\n",
 			devname, num_off);
 		return 1;
 	}
-	if (num_off)
+	if (num_off && num_on)
 		fprintf(stderr, "%s: %d memory section%s already offline\n",
 			devname, num_off,
 			num_off == 1 ? "" : "s");
 
+	if (unplug) {
+		rc = daxctl_dev_set_kmem_state(dev, DAXCTL_KMEM_UNPLUGGED);
+		if (rc < 0 && num_on == 0) {
+			/* already offline, unplug is best effort */
+			if (param.verbose)
+				fprintf(stderr, "%s: unplug failed: %s\n",
+					devname, strerror(-rc));
+			fprintf(stderr, "%s: all memory sections (%d) already offline\n",
+				devname, num_off);
+			return 1;
+		}
+		if (rc < 0) {
+			fprintf(stderr, "%s: failed to offline memory: %s\n",
+				devname, strerror(-rc));
+			return rc;
+		}
+		if (param.verbose)
+			fprintf(stderr, "%s: %d memory section%s unplugged\n",
+				devname, num_sections,
+				num_sections == 1 ? "" : "s");
+
+		/* blocks are removed, none should remain online */
+		num_on = daxctl_memory_is_online(mem);
+		if (num_on < 0) {
+			fprintf(stderr, "%s: failed to determine online state: %s\n",
+				devname, strerror(-num_on));
+			return num_on;
+		}
+		if (num_on) {
+			fprintf(stderr, "%s: failed to offline %d memory sections\n",
+				devname, num_on);
+			return -ENXIO;
+		}
+
+		return 0;
+	}
+
 	/* offline the remaining sections */
 	rc = daxctl_memory_offline(mem);
 	if (rc < 0) {
diff --git a/daxctl/json.c b/daxctl/json.c
index 8da91b1..cf81fe6 100644
--- a/daxctl/json.c
+++ b/daxctl/json.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+#include <errno.h>
 #include <limits.h>
 #include <string.h>
 #include <util/json.h>
@@ -79,7 +80,10 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 		if (jobj)
 			json_object_object_add(jdev, "total_memblocks", jobj);
 
-		movable = daxctl_memory_is_movable(mem);
+		/* an unplugged device has no zone */
+		movable = -ENXIO;
+		if (num_sections > 0)
+			movable = daxctl_memory_is_movable(mem);
 		if (movable == 1)
 			jobj = json_object_new_boolean(true);
 		else if (movable == 0)
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index cbb42e3..eedf4dd 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1644,8 +1644,16 @@ static int daxctl_memory_op(struct daxctl_memory *mem, enum memory_op op)
 	}
 
 	node_dir = opendir(node_path);
-	if (!node_dir)
-		return -errno;
+	if (!node_dir) {
+		rc = -errno;
+		/* unplugging a node's last memory removes its directory */
+		if (rc == -ENOENT &&
+		    daxctl_dev_get_kmem_state(dev) == DAXCTL_KMEM_UNPLUGGED) {
+			dbg(ctx, "%s: unplugged, no blocks to count\n", devname);
+			return 0;
+		}
+		return rc;
+	}
 
 	errno = 0;
 	while ((de = readdir(node_dir)) != NULL) {
-- 
2.53.0-Meta

