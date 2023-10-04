Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6D323750
	for <nvdimm@lists.linux.dev>; Wed,  4 Oct 2023 22:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPtlkrHm"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696457306; x=1727993306;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l647W1SzLNdo8dKq+XdGkRJFTnEUB5OFZNgQUrP2giY=;
  b=LPtlkrHmd7WD8be0C8Zp+6xL2yxqgWn1BzVta2SGigMR8lDUzJgnqOeS
   8gHmOOlXpHZH5wSZ23fx/garqOv4SqesAKES3EHRdS0Yi+5XElqXROwk4
   aD05at3pQnpragKRJxk2XO/R/7VHCcgL2zQp8Gw4cqrgYq2oKsKcGBqdU
   L/+3mJrO83tmPtAdGOT692FXQpi2u5ibKxJ+5VLzHPGXB8x4f7GX6OJnV
   GwHN+ZFg0DZ4GolMPiJmlR25/hb8xY80OUN+vp/M2eH/h5DUkvEaniNDU
   svJk2rFq53qN+Y/HHKSrMx6lM/geMrqztwNhBZ1K/a/OTN5fXE+5j/ERO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="383223388"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="383223388"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 15:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="895155782"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="895155782"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.213.170.46])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 15:06:57 -0700
Subject: [NDCTL PATCH 1/2] cxl: Save the number of decoders committed to a
 port
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Wed, 04 Oct 2023 15:08:23 -0700
Message-ID: <169645730392.624805.16511039948183288287.stgit@djiang5-mobl3>
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
 Documentation/cxl/lib/libcxl.txt |    1 +
 cxl/json.c                       |    4 ++++
 cxl/lib/libcxl.c                 |    9 +++++++++
 cxl/lib/libcxl.sym               |    5 +++++
 cxl/lib/private.h                |    1 +
 cxl/libcxl.h                     |    1 +
 6 files changed, 21 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 31bc85511270..0b51d8b0012c 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -294,6 +294,7 @@ bool cxl_port_is_endpoint(struct cxl_port *port);
 int cxl_port_get_depth(struct cxl_port *port);
 bool cxl_port_hosts_memdev(struct cxl_port *port, struct cxl_memdev *memdev);
 int cxl_port_get_nr_dports(struct cxl_port *port);
+struct cxl_port *cxl_port_decoders_committed(struct cxl_port *port);
 ----
 The port type is communicated via cxl_port_is_<type>(). An 'enabled' port
 is one that has succeeded in discovering the CXL component registers in
diff --git a/cxl/json.c b/cxl/json.c
index 7678d02020b6..33800c6f9024 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1120,6 +1120,10 @@ static struct json_object *__util_cxl_port_to_json(struct cxl_port *port,
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
index af4ca44eae19..759713110cd1 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1833,6 +1833,10 @@ static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		port->module = util_modalias_to_module(ctx, buf);
 
+	sprintf(path, "%s/decoders_committed", cxlport_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		port->decoders_committed = strtoul(buf, NULL, 0);
+
 	free(path);
 	return 0;
 err:
@@ -3071,6 +3075,11 @@ cxl_port_get_dport_by_memdev(struct cxl_port *port, struct cxl_memdev *memdev)
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
index 8fa1cca3d0d7..17b43ac39056 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -264,3 +264,8 @@ global:
 	cxl_memdev_update_fw;
 	cxl_memdev_cancel_fw_update;
 } LIBCXL_5;
+
+LIBCXL_7 {
+global:
+	cxl_port_decoders_committed;
+} LIBCXL_6;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index a641727000f1..aaaecba74096 100644
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
index 0f4f4b2648fb..9d9b4cc57769 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -145,6 +145,7 @@ bool cxl_port_hosts_memdev(struct cxl_port *port, struct cxl_memdev *memdev);
 int cxl_port_get_nr_dports(struct cxl_port *port);
 int cxl_port_disable_invalidate(struct cxl_port *port);
 int cxl_port_enable(struct cxl_port *port);
+int cxl_port_decoders_committed(struct cxl_port *port);
 struct cxl_port *cxl_port_get_next_all(struct cxl_port *port,
 				       const struct cxl_port *top);
 


