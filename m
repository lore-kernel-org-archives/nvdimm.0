Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBFA7C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663794163; x=1695330163;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GULeu/RFvUc9KSKnjHluC8brt8xJw9osYPaSSwzRAas=;
  b=NBhy/mPt93tbMZoRgX4WGICBNSb+rcUsO9+C7FLUY/7nIH/TmwjGr+O1
   o7c9BK4rld3CU/uf3FmtRBLRIsCifpHaNNmi5N2Fe88O69gVSHWCc6dr7
   k4uv3TG3j3oQMwy9j1dRqK3eOtPxatMIw3p+feQNDLfnfyM/ZW7yXUqPc
   En7E7jLkMOx+NGZ8RRMnd4WLBgFNoTlwRBRcCaqe1OYRKbHa5PuMMr+2j
   DN6tSpZOen1TuUTTXQIquqpSeOAUpSU9DZr0VDkz6jg6j818HtOb3kXck
   r2N3oOimDN/WYj9iWs0ODKEz7kdiFPDyhW7FfRazU8N5G0MsiN6avZ2CO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="279848610"
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="279848610"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:02:42 -0700
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="681934762"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:02:42 -0700
Subject: [PATCH 1/4] ndctl: add cxl bus detection
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 21 Sep 2022 14:02:42 -0700
Message-ID: 
 <166379416245.433612.3109623615684575549.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add helper function to detect that the bus is cxl based.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/libndctl.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/lib/private.h    |    1 +
 ndctl/libndctl.h       |    1 +
 4 files changed, 56 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ad54f0626510..10422e24d38b 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -12,6 +12,7 @@
 #include <ctype.h>
 #include <fcntl.h>
 #include <dirent.h>
+#include <libgen.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/ioctl.h>
@@ -876,6 +877,48 @@ static enum ndctl_fwa_method fwa_method_to_method(const char *fwa_method)
 	return NDCTL_FWA_METHOD_RESET;
 }
 
+static int is_ndbus_cxl(const char *ctl_base)
+{
+	char *path, *ppath, *subsys;
+	char tmp_path[PATH_MAX];
+	int rc;
+
+	/* get the real path of ctl_base */
+	path = realpath(ctl_base, NULL);
+	if (!path)
+		return -errno;
+
+	/* setup to get the nd bridge device backing the ctl */
+	sprintf(tmp_path, "%s/device", path);
+	free(path);
+
+	path = realpath(tmp_path, NULL);
+	if (!path)
+		return -errno;
+
+	/* get the parent dir of the ndbus, which should be the nvdimm-bridge */
+	ppath = dirname(path);
+
+	/* setup to get the subsystem of the nvdimm-bridge */
+	sprintf(tmp_path, "%s/%s", ppath, "subsystem");
+	free(path);
+
+	path = realpath(tmp_path, NULL);
+	if (!path)
+		return -errno;
+
+	subsys = basename(path);
+
+	/* check if subsystem is cxl */
+	if (!strcmp(subsys, "cxl"))
+		rc = 1;
+	else
+		rc = 0;
+
+	free(path);
+	return rc;
+}
+
 static void *add_bus(void *parent, int id, const char *ctl_base)
 {
 	char buf[SYSFS_ATTR_SIZE];
@@ -919,6 +962,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 	else
 		bus->has_of_node = 1;
 
+	if (is_ndbus_cxl(ctl_base))
+		bus->has_cxl = 1;
+	else
+		bus->has_cxl = 0;
+
 	sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		bus->nfit_dsm_mask = 0;
@@ -1050,6 +1098,11 @@ NDCTL_EXPORT int ndctl_bus_has_of_node(struct ndctl_bus *bus)
 	return bus->has_of_node;
 }
 
+NDCTL_EXPORT int ndctl_bus_has_cxl(struct ndctl_bus *bus)
+{
+	return bus->has_cxl;
+}
+
 NDCTL_EXPORT int ndctl_bus_is_papr_scm(struct ndctl_bus *bus)
 {
 	char buf[SYSFS_ATTR_SIZE];
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index c933163c0380..3a3e8bbd63ef 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -465,4 +465,5 @@ LIBNDCTL_27 {
 
 LIBNDCTL_28 {
 	ndctl_dimm_disable_master_passphrase;
+	ndctl_bus_has_cxl;
 } LIBNDCTL_27;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index e5c56295556d..46bc8908bd90 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -163,6 +163,7 @@ struct ndctl_bus {
 	int regions_init;
 	int has_nfit;
 	int has_of_node;
+	int has_cxl;
 	char *bus_path;
 	char *bus_buf;
 	size_t buf_len;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index c52e82a6f826..91ef0f42f654 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -133,6 +133,7 @@ struct ndctl_bus *ndctl_bus_get_next(struct ndctl_bus *bus);
 struct ndctl_ctx *ndctl_bus_get_ctx(struct ndctl_bus *bus);
 int ndctl_bus_has_nfit(struct ndctl_bus *bus);
 int ndctl_bus_has_of_node(struct ndctl_bus *bus);
+int ndctl_bus_has_cxl(struct ndctl_bus *bus);
 int ndctl_bus_is_papr_scm(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_major(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_minor(struct ndctl_bus *bus);


