Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A8229CA
	for <nvdimm@lists.linux.dev>; Sat, 15 Jan 2022 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642210366; x=1673746366;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wF+/mzy+jEdUKRAg8p0FTEdV+0D9MTr5GjHaxV5K1eo=;
  b=YD7jfITd6ELgqnNoygYQSmmZiLk4aaMrMxBp0u5fADZoydfPU/yoKzf4
   uDrq0rCkPlD1oRe/TUkTsF0M1TLPhdykirG/XX3ww9o8RDXC3SmP+U/1m
   ibXF4B8f/WUqzqhhDHrZdU8yHD3/dtXv6Yq9M3jrS0Km4umnjK49RDlKh
   +iH7a/Thk2PG3ow+bIyEE6+6m5g3pT4DH5DrTQJgGi+Gr7KmOzfwBzFIh
   op1/FkyitT3ZwOg/jC/hZbMactRyKXGRo6gbqFxTzExLC2jTIWJw7kfDg
   U1eOOsxaQc0xkKEBgqUiEtfUT0ogxxNcs61iuC9tgStFZvyj3hN0kwuqn
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10227"; a="243179192"
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="243179192"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 17:32:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="692428559"
Received: from rmedecig-mobl2.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.212.74.53])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 17:32:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jane Chu <jane.chu@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [ndctl PATCH] ndctl: update README.md for meson build
Date: Fri, 14 Jan 2022 18:32:29 -0700
Message-Id: <20220115013229.1604139-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2676; h=from:subject; bh=wF+/mzy+jEdUKRAg8p0FTEdV+0D9MTr5GjHaxV5K1eo=; b=owGbwMvMwCXGf25diOft7jLG02pJDImPVBSe36qXnyR8SOAz43o2LilTZsesG7pK0/beXPVlzcUz /f0yHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIegIjw1n/nwH3bGIXa+rbbM7UY3 ppsv1VbsqPuY2dAS+kJB6uamD4K/GK13jideHXE3fUMy86HsLBGaTRE1t7S6T3tOuTOW15PAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Update the README to replace the autotools build and test instructions
with meson equivalents. Also provide an example for setting meson
configuration options by illustrating the destructive unit tests use
case.

Reported-by: Alison Schofield <alison.schofield@intel.com>
Reported-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 README.md | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/README.md b/README.md
index 6f36a6d..f3fe65b 100644
--- a/README.md
+++ b/README.md
@@ -9,11 +9,14 @@ Build
 =====
 
 ```
-./autogen.sh
-./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64
-make
-make check
-sudo make install
+meson setup build;
+meson compile -C build;
+```
+
+Optionally, to install:
+
+```
+meson install -C build
 ```
 
 There are a number of packages required for the build steps that may not
@@ -34,7 +37,7 @@ https://nvdimm.wiki.kernel.org/start
 
 Unit Tests
 ==========
-The unit tests run by `make check` require the nfit_test.ko module to be
+The unit tests run by `meson test` require the nfit_test.ko module to be
 loaded.  To build and install nfit_test.ko:
 
 1. Obtain the kernel source.  For example,  
@@ -78,8 +81,16 @@ loaded.  To build and install nfit_test.ko:
    sudo make modules_install
    ```
 
-1. Now run `make check` in the ndctl source directory, or `ndctl test`,
-   if ndctl was built with `--enable-test`.
+1. Now run `meson test -C build` in the ndctl source directory, or `ndctl test`,
+   if ndctl was built with `-Dtest=enabled` as a configuration option to meson.
+
+1. To run the 'destructive' set of tests that may clobber existing pmem
+   configurations and data, configure meson with the destructive option after the
+   `meson setup` step:
+
+   ```
+   meson configure -Dtest=enabled -Ddestructive=enabled build;
+   ```
 
 Troubleshooting
 ===============
@@ -87,9 +98,9 @@ Troubleshooting
 The unit tests will validate that the environment is set up correctly
 before they try to run. If the platform is misconfigured, i.e. the unit
 test modules are not available, or the test versions of the modules are
-superseded by the "in-tree/production" version of the modules `make
-check` will skip tests and report a message like the following in
-test/test-suite.log:  
+superseded by the "in-tree/production" version of the modules `meson
+test` will skip tests and report a message like the following in
+`build/meson-logs/testlog.txt`
 
 ```
 SKIP: libndctl
-- 
2.33.1

