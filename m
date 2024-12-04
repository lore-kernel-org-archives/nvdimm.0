Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC4B18EA2
	for <nvdimm@lists.linux.dev>; Wed,  4 Dec 2024 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733328926; cv=pass; b=haxw8Pff3mA3ng2xqxQH1EZttLxI56o8/0mf54kPUuV+jsx48zbeexbYqbexbm3nFXc+kmuEYT/Yckk51OUDINdEZu/NZ8BMCP/f6KKqU5PqaW+yCk1FwA/2KeTEXlX8Dm7oAJcxqiEJBo5WKslyl9CBALtL+vY2xyVs7vpJomQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733328926; c=relaxed/simple;
	bh=OX/V4KlZfSnNLcTlLdUTMS6t1F3r/nPVmwrkxH79iag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XOheuJwGJLcQrOYrbVbhyyfl8nuvfOcU/QUeu1nre6q8kobHiBUxM1OM0EBaPBd0y93ZMbuqCFSprPNZ9RYYwg+OZCd71+Kd9IYkVftKyBnIRUagPPW/9fT3/Lpk+gMxAGTDHVyLFbVXyDnToHsx4GZW5dDrs9IfT/sbfyS8LwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b=ANisJxXu; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b="ANisJxXu"
ARC-Seal: i=1; a=rsa-sha256; t=1733328922; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Rxd2l2cXNQsmBr8me1001Bw3VQyQFEqqye9gStGO0s4rIeQHUa2uM/0qg0+e4DmR8ckdFTvtqK25aD0fBcs6/hZub99cim3OX3C7zsvut0t/iq2QUJe4zrJjTLs/1gb+RAhCRKfn0Mg8lUdLcSVN3HigWdtDcQRjese8M1yioq8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733328922; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=s962vGgSth/vx7IdJH0sb+PTyuWEB5Gy4WfjWaKSjLw=; 
	b=m39RSFnUnpNKUOkhu5VXmoALAK4vBD/ZJpA121m5jZ2zU1Q/6rLwrreAeeQkxTo1raz/NTLRWk6PyBl4pme2wyyis/IsxyhFJWkq6DYH/tk/edlH4ZAj1iY5MGCdUCDcyRl7vaUP7t5ctOlAWWcAGignTeU+tnh9Rxh8TBQjH6E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=ming.li@zohomail.com;
	dmarc=pass header.from=<ming.li@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733328922;
	s=zm2022; d=zohomail.com; i=ming.li@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Reply-To;
	bh=s962vGgSth/vx7IdJH0sb+PTyuWEB5Gy4WfjWaKSjLw=;
	b=ANisJxXugQMvji/EykZGSplHxZBMdCwold8jMHOIMsrdo2Kk7QlSGG5HxClAq/AQ
	lkMbxzeni7AUAX7AAvatYXrSaEw+ZbGJSnu3e88+LG6Q9wSu2bzU+JS/mdam8eysbq+
	Hf0TCUnrv/KGzwDElsDFFYSOJMzLxs3qUEz48ig8=
Received: by mx.zohomail.com with SMTPS id 1733328919184892.0434640061868;
	Wed, 4 Dec 2024 08:15:19 -0800 (PST)
From: Li Ming <ming.li@zohomail.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Li Ming <ming.li@zohomail.com>
Subject: [ndctl PATCH 1/1] daxctl: Output more information if memblock is unremovable
Date: Thu,  5 Dec 2024 00:14:56 +0800
Message-Id: <20241204161457.1113419-1-ming.li@zohomail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr08011227890bf58059f41c7efb69e6cb0000228972e0e64473f4f5a5039d8f09f8ca762e1bc9bd197f2486:zu08011227538e16bb626ed09b61ed76be00002bb35925f177902e5f8deb78d71ff18188d91c29b8fd6cf97f:rf08011226f6b6b3176d73fa9bc254296600002c9646dd75971544093d59887b1e1d4b2031c3b3a2b8b8df:ZohoMail
X-ZohoMailClient: External

If CONFIG_MEMORY_HOTREMOVE is disabled by kernel, memblocks will not be
removed, so 'dax offline-memory all' will output below error logs:

  libdaxctl: offline_one_memblock: dax0.0: Failed to offline /sys/devices/system/node/node6/memory371/state: Invalid argument
  dax0.0: failed to offline memory: Invalid argument
  error offlining memory: Invalid argument
  offlined memory for 0 devices

The log does not clearly show why the command failed. So checking if the
target memblock is removable before offlining it by querying
'/sys/devices/system/node/nodeX/memoryY/removable', then output specific
logs if the memblock is unremovable, output will be:

  libdaxctl: offline_one_memblock: dax0.0: memory371 is unremovable
  dax0.0: failed to offline memory: Operation not supported
  error offlining memory: Operation not supported
  offlined memory for 0 devices

Besides, delay to set up string 'path' for offlining memblock operation,
because string 'path' is stored in 'mem->mem_buf' which is a shared
buffer, it will be used in memblock_is_removable().

Signed-off-by: Li Ming <ming.li@zohomail.com>
---
 daxctl/lib/libdaxctl.c | 52 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 9fbefe2e8329..b7fa0de0b73d 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1310,6 +1310,37 @@ static int memblock_is_online(struct daxctl_memory *mem, char *memblock)
 	return 0;
 }
 
+static int memblock_is_removable(struct daxctl_memory *mem, char *memblock)
+{
+	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
+	const char *devname = daxctl_dev_get_devname(dev);
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	int len = mem->buf_len, rc;
+	char buf[SYSFS_ATTR_SIZE];
+	char *path = mem->mem_buf;
+	const char *node_path;
+
+	node_path = daxctl_memory_get_node_path(mem);
+	if (!node_path)
+		return -ENXIO;
+
+	rc = snprintf(path, len, "%s/%s/removable", node_path, memblock);
+	if (rc < 0)
+		return -ENOMEM;
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc) {
+		err(ctx, "%s: Failed to read %s: %s\n",
+			devname, path, strerror(-rc));
+		return rc;
+	}
+
+	if (strtoul(buf, NULL, 0) == 0)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int online_one_memblock(struct daxctl_memory *mem, char *memblock,
 		enum memory_zones zone, int *status)
 {
@@ -1362,6 +1393,20 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
 	char *path = mem->mem_buf;
 	const char *node_path;
 
+	/* if already offline, there is nothing to do */
+	rc = memblock_is_online(mem, memblock);
+	if (rc < 0)
+		return rc;
+	if (!rc)
+		return 1;
+
+	rc = memblock_is_removable(mem, memblock);
+	if (rc) {
+		if (rc == -EOPNOTSUPP)
+			err(ctx, "%s: %s is unremovable\n", devname, memblock);
+		return rc;
+	}
+
 	node_path = daxctl_memory_get_node_path(mem);
 	if (!node_path)
 		return -ENXIO;
@@ -1370,13 +1415,6 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
 	if (rc < 0)
 		return -ENOMEM;
 
-	/* if already offline, there is nothing to do */
-	rc = memblock_is_online(mem, memblock);
-	if (rc < 0)
-		return rc;
-	if (!rc)
-		return 1;
-
 	rc = sysfs_write_attr_quiet(ctx, path, mode);
 	if (rc) {
 		/* check if something raced us to offline (unlikely) */
-- 
2.34.1

