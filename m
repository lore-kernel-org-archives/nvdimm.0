Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDE71E496
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 20:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QDOrP7s/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701204293; x=1732740293;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r6ztm90LVsZRH55jJr9e9qtn7fJDOjZJdPTHkbldxko=;
  b=QDOrP7s/Jw/3ETOzmfzVa9eQGzU1zGGHLwMHBTvwWmDIGx3WfI6A/V5R
   sIwSOygaPUHGhhhXw9X/TiewA1+lM7sFfmP7Skc8Q93+fQMy2/JCQT4Z3
   PVWIycktCIkjpemeKMZ0C55ugP2hliHthzhsGhu5pVo+KxkrSblEqRXN9
   AClFC2mZTJLKbys6XIvx0nMVNnxEjwxHvXLm73dqRquzYTJMheSOybkWv
   r8X0UaLJEBr2uB0G6dpWHImJ+DklogCbJCQ+ITpLM+VvnaHGcrzNl8GGz
   5p/69TH+N+QTN4EM13KVy0sHtar1SnloQiJGWzFkMlym1+SBMtCTtRAfO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="424171236"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="424171236"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 12:43:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="834761157"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="834761157"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.164.208])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 12:43:52 -0800
Subject: [NDCTL PATCH v2 1/2] cxl: Save the number of decoders committed to a
 port
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com, caoqq@fujitsu.com
Date: Tue, 28 Nov 2023 13:43:51 -0700
Message-ID: <170120423159.2725915.14670830315829916850.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Save the number of decoders committed to a port exposed by the kernel to the
libcxl cxl_port context. The attribute is helpful for determing if a region is
active.  Add libcxl API to retrieve the number of decoders committed.
Add the decoders_committed attribute to the port for cxl list command.

Link: https://lore.kernel.org/linux-cxl/169645700414.623072.3893376765415910289.stgit@djiang5-mobl3/T/#t
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v2:
- Rebase against latest pending branch
---
 Documentation/cxl/lib/libcxl.txt |    1 +
 cxl/json.c                       |    4 ++++
 cxl/lib/libcxl.c                 |    9 +++++++++
 cxl/lib/libcxl.sym               |    1 +
 cxl/lib/private.h                |    1 +
 cxl/libcxl.h                     |    1 +
 6 files changed, 17 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index bcb89288afaf..93c32b54f19e 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -295,6 +295,7 @@ bool cxl_port_is_endpoint(struct cxl_port *port);
 int cxl_port_get_depth(struct cxl_port *port);
 bool cxl_port_hosts_memdev(struct cxl_port *port, struct cxl_memdev *memdev);
 int cxl_port_get_nr_dports(struct cxl_port *port);
+struct cxl_port *cxl_port_decoders_committed(struct cxl_port *port);
 ----
 The port type is communicated via cxl_port_is_<type>(). An 'enabled' port
 is one that has succeeded in discovering the CXL component registers in
diff --git a/cxl/json.c b/cxl/json.c
index 6fb17582a1cb..477e35a5157a 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1331,6 +1331,10 @@ static struct json_object *__util_cxl_port_to_json(struct cxl_port *port,
 			json_object_object_add(jport, "state", jobj);
 	}
 
+	jobj = json_object_new_int(cxl_port_decoders_committed(port));
+	if (jobj)
+		json_object_object_add(jport, "decoders_committed", jobj);
+
 	json_object_set_userdata(jport, port, NULL);
 	return jport;
 }
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index bdec2959508b..c1a127f66a1d 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1880,6 +1880,10 @@ static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		port->module = util_modalias_to_module(ctx, buf);
 
+	sprintf(path, "%s/decoders_committed", cxlport_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		port->decoders_committed = strtoul(buf, NULL, 0);
+
 	free(path);
 	return 0;
 err:
@@ -3121,6 +3125,11 @@ cxl_port_get_dport_by_memdev(struct cxl_port *port, struct cxl_memdev *memdev)
 	return NULL;
 }
 
+CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
+{
+	return port->decoders_committed;
+}
+
 static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
 {
 	const char *devname = devpath_to_devname(cxlbus_base);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 42f523fda16d..16eca09b3d8b 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -277,4 +277,5 @@ global:
 	cxl_cmd_new_set_alert_config;
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
+	cxl_port_decoders_committed;
 } LIBCXL_6;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b26a8629e047..30c898940dec 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -87,6 +87,7 @@ struct cxl_port {
 	int dports_init;
 	int nr_dports;
 	int depth;
+	int decoders_committed;
 	struct cxl_ctx *ctx;
 	struct cxl_bus *bus;
 	enum cxl_port_type type;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 1154f4ce34d1..f7db400f574a 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -145,6 +145,7 @@ bool cxl_port_hosts_memdev(struct cxl_port *port, struct cxl_memdev *memdev);
 int cxl_port_get_nr_dports(struct cxl_port *port);
 int cxl_port_disable_invalidate(struct cxl_port *port);
 int cxl_port_enable(struct cxl_port *port);
+int cxl_port_decoders_committed(struct cxl_port *port);
 struct cxl_port *cxl_port_get_next_all(struct cxl_port *port,
 				       const struct cxl_port *top);
 


