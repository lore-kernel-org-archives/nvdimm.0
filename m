Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F076C1B0435;
	Fri, 11 Jul 2025 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752273234; cv=none; b=TQFWf7tn1Rf5tLLtmNxoioG3W82xQQhf1Ne6nQIDfahIt/sQ+mQ52PwiaN6OlWtZ44D+CAruYwIOiy1BXnuZKhvIB6tbqbfPRuH/rMQq+uhIh2hhFPcP5bSk+OY1PN+6W7QeujHZhqpDn7VGNWuNsHpWcT0fPlAvjV/EgXUc9Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752273234; c=relaxed/simple;
	bh=TiNC02bSmxcR9KFB7z1SuBRLv1cwriKXmd1vMrmXJDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xmre/0RQNPKKzXUzaekLLEb0QHg5975wM3P/sj62Pg2WCt3LbadTltO1/IVr4ns+pGWTfIUsM4iQ8n0BNpSs5oy4TajcEahyoup1PYnn0YctOmCElzGKoYUNHfCA2Hinqpii7fvNzieXym8xmaNjVbtp1PaGbrzXXfILQZvuM5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611A1C4CEED;
	Fri, 11 Jul 2025 22:33:52 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v2] cxl: Add helper function to verify port is in memdev hierarchy
Date: Fri, 11 Jul 2025 15:33:50 -0700
Message-ID: <20250711223350.3196213-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.50.0
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
v2:
- Remove usages of cxl_port_get_dport_by_memdev() and add documentation to explain
  when cxl_port_get_dport_by_memdev() should be used. (Alison)
---
 Documentation/cxl/lib/libcxl.txt |  5 +++++
 cxl/filter.c                     |  2 +-
 cxl/lib/libcxl.c                 | 31 +++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  5 +++++
 cxl/libcxl.h                     |  3 +++
 cxl/port.c                       |  4 ++--
 6 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 2a512fd9d276..aecbfde4de84 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -348,11 +348,16 @@ struct cxl_dport *cxl_dport_get_first(struct cxl_port *port);
 struct cxl_dport *cxl_dport_get_next(struct cxl_dport *dport);
 struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
                                                struct cxl_memdev *memdev);
+bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
+				 struct cxl_port *port);
 
 #define cxl_dport_foreach(port, dport)                                     \
        for (dport = cxl_dport_get_first(port); dport != NULL;              \
             dport = cxl_dport_get_next(dport))
 ----
+cxl_port_get_dport_by_memdev() is only usable when the memdev driver is bound
+and therefore the ports and dports in between the root port and the endpoint are
+enumerated.
 
 ===== DPORT: Attributes
 ----
diff --git a/cxl/filter.c b/cxl/filter.c
index 91097b3cdcd0..b135c043ed77 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -564,7 +564,7 @@ static bool __memdev_filter_by_port(struct cxl_memdev *memdev,
 	struct cxl_endpoint *endpoint;
 
 	if (util_cxl_port_filter(port, port_ident, CXL_PF_SINGLE) &&
-	    cxl_port_get_dport_by_memdev(port, memdev))
+	    cxl_memdev_is_port_ancestor(memdev, port))
 		return true;
 
 	cxl_endpoint_foreach(port, endpoint)
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
index 89f3916d85aa..90beed7ccd0d 100644
--- a/cxl/port.c
+++ b/cxl/port.c
@@ -67,7 +67,7 @@ static int action_disable(struct cxl_port *port)
 	}
 
 	cxl_memdev_foreach(ctx, memdev) {
-		if (!cxl_port_get_dport_by_memdev(port, memdev))
+		if (!cxl_memdev_is_port_ancestor(memdev, port))
 			continue;
 		if (cxl_memdev_is_enabled(memdev))
 			active_memdevs++;
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
2.50.0

