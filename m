Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A3BBA27
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 22:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671055227; x=1702591227;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JccO0gN9kEfLD1TxKiyJlWK0f5UxLjSFMPXrUfOVJeA=;
  b=DQnzIOGMZSmlvOBrJKVxKXJyIH43mFSqCisD3jIgy99drGpEo1ZoXyvI
   6OMgy2JZI9whr4W5sbI593scD9n2itupfth4kuYvKGggvRCyekMhCrX38
   OEv/9yJqc6uJHhb56qcxoydzRFFMVyVhR/lQz+BFDjNaUe5kaWaGdDCed
   vhDNFHNEgde+gdiFIU4sjsPVHuYo6n9dH1qvI9DmkiWLQo8sTiUyrIekQ
   DcUcwukLX4USZGv9skLpYLfIaRa9teTYPiUFGu/h0om6MjRSQmJBb0rPH
   Gll0ORzRmq1vuUshpgSlAoBhkMCl1dkk2TPx4YRAg5FkDt7bDSz80WgrN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="316159212"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="316159212"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="679907672"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="679907672"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:26 -0800
Subject: [ndctl PATCH v2 1/4] ndctl: add CXL bus detection
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 14 Dec 2022 15:00:25 -0700
Message-ID: 
 <167105522584.3034751.8329537593759406601.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
References: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add a CXL bus type, and detect whether a 'dimm' is backed by the CXL
subsystem.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>

---
v2:
- Improve commit log. (Vishal)
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
index 75c32b9d4967..2892544d1985 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -464,4 +464,5 @@ LIBNDCTL_27 {
 } LIBNDCTL_26;
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


