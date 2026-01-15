Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5084212B94
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768515395; cv=none; b=sT98IOrruHBM4v837Pd7y5HPuTVuH5upvZVldLP0n2CayBAif3LCUhImz5YUz840jqY/WeRSoWaYGpTgm1AHNQQF//r/WTu+TwIzRjuYNCLHnJTf0Luvx9/48D4OsDJ9FVsjpmbLudnoEt+vDm3bD1ZiAMVIDr+vUkiQxoZ8e8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768515395; c=relaxed/simple;
	bh=z0cjYHnusEWc6hxVX+G4eCKI2UheF6cml3XKiWjqxMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RTGamzzYhWOZ1lYU42DLxziHTBlXczBkbnN5vKJDogau1G7viLp5oiw1imzN8HLwM7mRDtXQP5pHPBUf81AK/OESiXk3aV2U7VfI/NNLd1aKJfIbEWEHJDhKS1uqRiX5hQomSdRhiijTGgcMhq92u8mOw/BosLuIAGBJxd08Mqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JrcRd0j8; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JrcRd0j8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768515394; x=1800051394;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z0cjYHnusEWc6hxVX+G4eCKI2UheF6cml3XKiWjqxMs=;
  b=JrcRd0j8ASazflCf7WU4EWMF4XG9QhtMOVqe56zZcxRYUSzqWPdfef9I
   GjyjN7cQNxbqefrZRHuLKnUWfLQb1Udm5hyGuyVpdYs647g6a5ev5Jogy
   nKeor4i18w2JcZ30puhkZFaFanpz38hSrJGNBUlnVQvH/BJHsH+Saarqm
   nOB8jIXNZKnQUnoMmbOHg1qZaqRUOzPCALxA4m4j3bk6bHAgXhuVlC7jy
   DJ4fQhOZuKXtJdB/ALX2u9HAsXaIhwLuEiGyL3eURxdcoc8hP50BxfadO
   Y62VLaCz6VfNRwAzjnUruBsz+kIe6xSquBaDSCF3DFj4ZnA4WrmrBPuPw
   A==;
X-CSE-ConnectionGUID: mDpGEeY6RLW2KCwwGApgVQ==
X-CSE-MsgGUID: rGJ7sytxSpyidvztNhM04g==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69737802"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69737802"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 14:16:33 -0800
X-CSE-ConnectionGUID: 1OAsvVoaT/qE7tkeWCMXyg==
X-CSE-MsgGUID: btKEBsTeT0Ol+m5ufPEsWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="205478908"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.9])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 14:16:32 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] daxctl: Replace basename() usage with strrchr()
Date: Thu, 15 Jan 2026 14:16:28 -0800
Message-ID: <20260115221630.528423-1-alison.schofield@intel.com>
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
version.

In daxctl/device.c, basename() is called without any header, relying
on the GNU extension being implicitly available. And in daxctl/lib/
libdaxctl.c, libgen.h is included and the POSIX basename() used,
which works but is needlessly complex as POSIX basename() can modify
its argument.

Rather than conditionally including headers or dealing with platform
differences, replace both basename() usages with a new implementation
using strrchar to find the last '/' in the path and return everything
after it, or the whole string if no '/' is found.

Closes: https://github.com/pmem/ndctl/issues/283
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 daxctl/device.c        | 8 +++++---
 daxctl/lib/libdaxctl.c | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index e3993b17c260..44a0a0ddb1d4 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -362,11 +362,13 @@ static const char *parse_device_options(int argc, const char **argv,
 	};
 	unsigned long long units = 1;
 	int i, rc = 0;
-	char *device = NULL;
+	const char *device = NULL;
 
 	argc = parse_options(argc, argv, options, u, 0);
-	if (argc > 0)
-		device = basename(argv[0]);
+	if (argc > 0) {
+		device = strrchr(argv[0], '/');
+		device = device ? device + 1 : argv[0];
+	}
 
 	/* Handle action-agnostic non-option arguments */
 	if (argc == 0 &&
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index b7fa0de0b73d..eee1d02c3714 100644
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
@@ -408,7 +407,8 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
 	if (!mod_path)
 		return false;
 
-	mod_base = basename(mod_path);
+	mod_base = strrchr(mod_path, '/');
+	mod_base = mod_base ? mod_base + 1 : mod_path;
 	if (strcmp(mod_base, dax_modules[DAXCTL_DEV_MODE_RAM]) == 0) {
 		free(mod_path);
 		return true;
-- 
2.37.3

