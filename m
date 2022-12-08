Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FCDA460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534920; x=1702070920;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1wfekAm9kpx/WXmzIWhyvCfLMvpi/cDVCYcJnpVryrw=;
  b=ZL57wEMlRX4TnLVorMWqtcCiy6/sPf+wCH60xh/zZichF16N8orC2fMq
   VrlphGGg+L3eEJ0YzJcoNWXHl+znqlZF2CftZ4laqhZhwuWO1shG5uS0Y
   c/ckhSD8PFYpjSFhFPy0GOG5HLRPGY2RWIkZHLYuqMg57o+BLryaNpSYC
   WI+SUzbzzlPUMIYeB5SOIsnHJ4u7WY8ssfOF4zLJwhc3HZ0cfID5YpOVc
   qVM9G7G1pWiqjbc7lUPPuF8RjyWwAVk2WDrvmFJEbdII83v2J4AzGFoKd
   kyeNvsqsjLklguQO+EQGF/rIFbtwHxc/t/JvBf7HwQV44fLrlu7eSpFYf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319170324"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="319170324"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753756119"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="753756119"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:39 -0800
Subject: [ndctl PATCH v2 07/18] cxl/list: Add parent_dport attribute to port
 listings
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:39 -0800
Message-ID: <167053491908.582963.7783814693644991382.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit


---
 cxl/json.c         |    8 ++++++++
 cxl/lib/libcxl.c   |   38 ++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |    1 +
 cxl/lib/private.h  |    2 ++
 cxl/libcxl.h       |    1 +
 5 files changed, 50 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 5cff532acb13..2f3639ede2f8 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -783,6 +783,14 @@ static struct json_object *__util_cxl_port_to_json(struct cxl_port *port,
 	if (jobj)
 		json_object_object_add(jport, "host", jobj);
 
+	if (cxl_port_get_parent_dport(port)) {
+		struct cxl_dport *dport = cxl_port_get_parent_dport(port);
+
+		jobj = json_object_new_string(cxl_dport_get_devname(dport));
+		if (jobj)
+			json_object_object_add(jport, "parent_dport", jobj);
+	}
+
 	jobj = json_object_new_int(cxl_port_get_depth(port));
 	if (jobj)
 		json_object_object_add(jport, "depth", jobj);
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index a69e31bc8a6e..9475d0e51f8c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -162,6 +162,7 @@ static void __free_port(struct cxl_port *port, struct list_head *head)
 	free(port->dev_buf);
 	free(port->dev_path);
 	free(port->uport);
+	free(port->parent_dport_path);
 }
 
 static void free_port(struct cxl_port *port, struct list_head *head)
@@ -1488,6 +1489,20 @@ static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
 	if (!port->uport)
 		goto err;
 
+	/*
+	 * CXL root devices have no parents and level 1 ports are both
+	 * CXL root targets and hosts of the next level, so:
+	 *     parent_dport == uport
+	 * ...at depth == 1
+	 */
+	if (port->depth > 1) {
+		rc = snprintf(port->dev_buf, port->buf_len, "%s/parent_dport",
+			      cxlport_base);
+		if (rc >= port->buf_len)
+			goto err;
+		port->parent_dport_path = realpath(port->dev_buf, NULL);
+	}
+
 	sprintf(path, "%s/modalias", cxlport_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		port->module = util_modalias_to_module(ctx, buf);
@@ -2465,6 +2480,29 @@ CXL_EXPORT const char *cxl_port_get_host(struct cxl_port *port)
 	return devpath_to_devname(port->uport);
 }
 
+CXL_EXPORT struct cxl_dport *cxl_port_get_parent_dport(struct cxl_port *port)
+{
+	struct cxl_port *parent;
+	struct cxl_dport *dport;
+	const char *name;
+
+	if (port->parent_dport)
+		return port->parent_dport;
+
+	if (!port->parent_dport_path)
+		return NULL;
+
+	parent = cxl_port_get_parent(port);
+	name = devpath_to_devname(port->parent_dport_path);
+	cxl_dport_foreach(parent, dport)
+		if (strcmp(cxl_dport_get_devname(dport), name) == 0) {
+			port->parent_dport = dport;
+			return dport;
+		}
+
+	return NULL;
+}
+
 CXL_EXPORT bool cxl_port_hosts_memdev(struct cxl_port *port,
 				      struct cxl_memdev *memdev)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 490ed1fda5d3..cc5c1d543484 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -222,4 +222,5 @@ LIBCXL_4 {
 global:
 	cxl_target_get_firmware_node;
 	cxl_dport_get_firmware_node;
+	cxl_port_get_parent_dport;
 } LIBCXL_3;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index e378339ec353..da2fce33cb07 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -62,6 +62,8 @@ struct cxl_port {
 	size_t buf_len;
 	char *dev_path;
 	char *uport;
+	char *parent_dport_path;
+	struct cxl_dport *parent_dport;
 	int ports_init;
 	int endpoints_init;
 	int decoders_init;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 1e0076908901..8d75330886f8 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -96,6 +96,7 @@ bool cxl_port_is_endpoint(struct cxl_port *port);
 struct cxl_endpoint *cxl_port_to_endpoint(struct cxl_port *port);
 struct cxl_bus *cxl_port_get_bus(struct cxl_port *port);
 const char *cxl_port_get_host(struct cxl_port *port);
+struct cxl_dport *cxl_port_get_parent_dport(struct cxl_port *port);
 bool cxl_port_hosts_memdev(struct cxl_port *port, struct cxl_memdev *memdev);
 int cxl_port_get_nr_dports(struct cxl_port *port);
 int cxl_port_disable_invalidate(struct cxl_port *port);

