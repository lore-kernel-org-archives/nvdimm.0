Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD4F2EF662
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 04:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537863; cv=none; b=bxoqVoCC4sZYfaFHpUJ4WPds39BAfsL2lvll8aUi8NTKFynAnBttk8q/tCOb67UdjvDhpdMFKTIUvhIVd1LmnprRyF7eIAFtQs9T4gswK+D0bQtaDwfJ45apigIsaW87txKk6Fb/jH0QTrj80NQYY75LK0pLZ1qC+/0clhE7/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537863; c=relaxed/simple;
	bh=WcrqGHbrn7JRjSnA2ff2MHrB1Q9nAfkMwbNduF9au8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mFCMF/6b4nCYo6ucY6g0hupAe7xz448Nov3K9ebYawIYc9k3T2AjkgZcvZHe6YNkaD+lHwkriHLxEYTLT2laWHNwv4YWIfgibyyjtRIhLIt6foojVAhUJBPLxAXR/dMI6ZA0lMhlXyrjFXFjNUQTX/DGGYV+f9ORSRjkL0+o4AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cSdaosY1; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cSdaosY1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768537862; x=1800073862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WcrqGHbrn7JRjSnA2ff2MHrB1Q9nAfkMwbNduF9au8E=;
  b=cSdaosY1v94ge2UorwgQQ789iUfQ834/03P0ihuTT7QWRCtxvgoRYGvm
   TR36+erR/4rHl9f+LGZSW+Nq0OoVh35K057tqLZpPbmeUqb7/+EtzrrpH
   l6XGKej8yAGmJEYtUDeQ8oSEDlGxsnOJiG0ISPGaIe9aZy8o9icFeAqCU
   83J79NuusF/4IorCUm4II38hFfZSylEz8LiyYjlT3BDwtVjVO4bgQuLR1
   o5b9XQRiwkXJZgA3kkgI6rxx8wKrQsVapcaQ9rKE8mrdYJZHuAwJW6A6/
   7l/i6XCFSQ3mTG5YDJLfDaLbcT2amn2y3oPQ6pt8vcfA3H/4t7eNP4t63
   A==;
X-CSE-ConnectionGUID: I1Ni/pBXTy2HTteXsYLhqQ==
X-CSE-MsgGUID: LcnMayziQ+qKewUJNurSmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="68862892"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="68862892"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 20:31:02 -0800
X-CSE-ConnectionGUID: gHXEZBd7Tc2pSPW0lAAm3g==
X-CSE-MsgGUID: cjDQCFcBQouMDxMD0CctsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209624826"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.9])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 20:31:01 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2] daxctl: replace basename() usage with new path_basename()
Date: Thu, 15 Jan 2026 20:30:53 -0800
Message-ID: <20260116043056.542346-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A user reports that ndctl fails to compile on MUSL systems:

daxctl/device.c: In function 'parse_device_options':
daxctl/device.c:377:26: error: implicit declaration of function 'basename' [-Wimplicit-function-declaration]
  377 |                 device = basename(argv[0]);
      |                          ^~~~~~~~

There are two versions of basename() with different behaviors:
	GNU basename() from <string.h>: doesn't modify its argument
	POSIX basename() from <libgen.h>: may modify its argument

glibc provides both versions, while MUSL libc only provides the POSIX
version. Previous code relied on the GNU extension without a header
or used the POSIX version inconsistently.

Introduce a new helper path_basename() that returns the portion of a
path after the last '/', the full string if no '/' is present, and a
trailing '/' returns an empty string. This avoids libc-specific
basename() behavior and is safe for argv style and arbitrary paths.

Closes: https://github.com/pmem/ndctl/issues/283
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2: 
- Replace open coded strrchr() logic with new helper (Marc, Dan)
- Comment that new helper (Marc)
- Update commit msg


 daxctl/device.c        |  4 ++--
 daxctl/lib/libdaxctl.c |  7 ++++---
 util/util.h            | 15 +++++++++++++++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index e3993b17c260..a4e36b130a09 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -362,11 +362,11 @@ static const char *parse_device_options(int argc, const char **argv,
 	};
 	unsigned long long units = 1;
 	int i, rc = 0;
-	char *device = NULL;
+	const char *device = NULL;
 
 	argc = parse_options(argc, argv, options, u, 0);
 	if (argc > 0)
-		device = basename(argv[0]);
+		device = path_basename(argv[0]);
 
 	/* Handle action-agnostic non-option arguments */
 	if (argc == 0 &&
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index b7fa0de0b73d..02ae7e50b123 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -3,7 +3,6 @@
 #include <stdio.h>
 #include <errno.h>
 #include <limits.h>
-#include <libgen.h>
 #include <stdlib.h>
 #include <dirent.h>
 #include <unistd.h>
@@ -15,6 +14,7 @@
 #include <ccan/array_size/array_size.h>
 
 #include <util/log.h>
+#include <util/util.h>
 #include <util/sysfs.h>
 #include <util/iomem.h>
 #include <daxctl/libdaxctl.h>
@@ -389,7 +389,8 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
 {
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
-	char *mod_path, *mod_base;
+	const char *mod_base;
+	char *mod_path;
 	char path[200];
 	const int len = sizeof(path);
 
@@ -408,7 +409,7 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
 	if (!mod_path)
 		return false;
 
-	mod_base = basename(mod_path);
+	mod_base = path_basename(mod_path);
 	if (strcmp(mod_base, dax_modules[DAXCTL_DEV_MODE_RAM]) == 0) {
 		free(mod_path);
 		return true;
diff --git a/util/util.h b/util/util.h
index 58db06530c37..b7913b499d82 100644
--- a/util/util.h
+++ b/util/util.h
@@ -93,6 +93,21 @@ static inline int is_absolute_path(const char *path)
 	return path[0] == '/';
 }
 
+/*
+ * path_basename() is a basename() style helper for paths that may not
+ * contain a '/'. Unlike devpath_to_devname() in util/sysfs.h, which
+ * assumes a valid sysfs-style path and requires at least one '/', this
+ * helper can return the full string when no path separator is present.
+ * It avoids libc-specific basename() behavior and is safe for argv style
+ * inputs.
+ */
+static inline const char *path_basename(const char *path)
+{
+	const char *p = strrchr(path, '/');
+
+	return p ? p + 1 : path;
+}
+
 void usage(const char *err) NORETURN;
 void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
 int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
-- 
2.37.3

