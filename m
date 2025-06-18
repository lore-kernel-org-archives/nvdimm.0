Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A17188006;
	Wed, 18 Jun 2025 20:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750279279; cv=none; b=D54mu/XI+rVH38DQViNKr6UfQRhvCsPlbPYiuXrdhd1lmBJeQk5R7jvkPrk0TmTOMy0cRW55uj0A5TfRbaq29sYyXxT78M7clNsHWJ0LpFju8xtI8T0Wqw5MAfJLa9klxSt+tBZ0RtUIq/qEDQhMp6UlqFWj4VCoMooQKoydV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750279279; c=relaxed/simple;
	bh=O4HA3iwZlFIFlpKwbnMUzLJLnJoqRYO06yEEbTvYnqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sfCISM4X8eBfRWDOgchiB4AMXu7UtXDJgAsnQCXlqVH/6ye+hqiCQYTJReRayJpQ4J96zP5sA22HvktXr/oqcUWjQrMLtcvdthj6MlFPTOQahXS3El+vfMcjy/yl7TPtw6jJhU3S3pjQHMOr4l45ojlOvyWXPJ7V+x2uRLK+Qms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19C6C4CEE7;
	Wed, 18 Jun 2025 20:41:18 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH] cxl: Add helper function to verify port is in memdev hierarchy
Date: Wed, 18 Jun 2025 13:41:17 -0700
Message-ID: <20250618204117.4039030-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
memdevs that are associated with a port in order to enable those
associated memdevs. When the kernel switch to delayed dport
initialization by enumerating the dports during memdev probe, the
dports are no longer valid until the memdev is probed. This means
that cxl_port_get_dport_by_memdev() will not find any memdevs under
the port.

Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
port is in the memdev hierarchy via the memdev->host_path where the sysfs
path contains all the devices in the hierarchy. This call is also backward
compatible with the old behavior.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/lib/libcxl.c   | 31 +++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  5 +++++
 cxl/libcxl.h       |  3 +++
 cxl/port.c         |  2 +-
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 5d97023377ec..cafde1cee4e8 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2024,6 +2024,37 @@ CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
 	return is_enabled(path);
 }
 
+CXL_EXPORT bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
+					    struct cxl_port *port)
+{
+	const char *uport = cxl_port_get_host(port);
+	const char *start = "devices";
+	const char *pstr = "platform";
+	char *host, *pos;
+
+	host = strdup(memdev->host_path);
+	if (!host)
+		return false;
+
+	pos = strstr(host, start);
+	pos += strlen(start) + 1;
+	if (strncmp(pos, pstr, strlen(pstr)) == 0)
+		pos += strlen(pstr) + 1;
+	pos = strtok(pos, "/");
+
+	while (pos) {
+		if (strcmp(pos, uport) == 0) {
+			free(host);
+			return true;
+		}
+		pos = strtok(NULL, "/");
+	}
+
+	free(host);
+
+	return false;
+}
+
 static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
 			 enum cxl_port_type type, struct cxl_ctx *ctx, int id,
 			 const char *cxlport_base)
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 3ad0cd06e25a..e01a676cdeb9 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -295,3 +295,8 @@ global:
 	cxl_fwctl_get_major;
 	cxl_fwctl_get_minor;
 } LIBECXL_8;
+
+LIBCXL_10 {
+global:
+	cxl_memdev_is_port_ancestor;
+} LIBCXL_9;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 54d97d7bb501..54bc025b121d 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -179,6 +179,9 @@ bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
 struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
 					       struct cxl_memdev *memdev);
 
+bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
+				 struct cxl_port *port);
+
 #define cxl_dport_foreach(port, dport)                                         \
 	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
 	     dport = cxl_dport_get_next(dport))
diff --git a/cxl/port.c b/cxl/port.c
index 89f3916d85aa..c951c0c771e8 100644
--- a/cxl/port.c
+++ b/cxl/port.c
@@ -102,7 +102,7 @@ static int action_enable(struct cxl_port *port)
 		return rc;
 
 	cxl_memdev_foreach(ctx, memdev)
-		if (cxl_port_get_dport_by_memdev(port, memdev))
+		if (cxl_memdev_is_port_ancestor(memdev, port))
 			cxl_memdev_enable(memdev);
 	return 0;
 }

base-commit: 74b9e411bf13e87df39a517d10143fafa7e2ea92
-- 
2.49.0

