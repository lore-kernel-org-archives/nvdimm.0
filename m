Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFE03FDB
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 20:43:29 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="282951016"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="282951016"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:43:16 -0700
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="691676385"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:43:16 -0700
Subject: [ndctl PATCH v2 3/6] build: Drop unnecessary $tool/config.h includes
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org
Date: Thu, 02 Sep 2021 13:43:16 -0700
Message-ID: <163061539621.1943957.15148388017989435698.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163061537869.1943957.8491829881215255815.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163061537869.1943957.8491829881215255815.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for support for meson as the build infrastructure remove
some explicit config.h includes that will be replaced by a unified config.h
at the top of the project.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/migrate.c |    1 -
 ndctl/keys.c     |    1 -
 ndctl/monitor.c  |    1 -
 3 files changed, 3 deletions(-)

diff --git a/daxctl/migrate.c b/daxctl/migrate.c
index 5fbe970fdaff..c51106625849 100644
--- a/daxctl/migrate.c
+++ b/daxctl/migrate.c
@@ -5,7 +5,6 @@
 #include <stdio.h>
 #include <errno.h>
 #include <fcntl.h>
-#include <daxctl/config.h>
 #include <daxctl/libdaxctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
diff --git a/ndctl/keys.c b/ndctl/keys.c
index 876b34714b7e..2f33b8fb488c 100644
--- a/ndctl/keys.c
+++ b/ndctl/keys.c
@@ -13,7 +13,6 @@
 #include <keyutils.h>
 #include <syslog.h>
 
-#include <ndctl/config.h>
 #include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 85890c5367d3..fde5b1209565 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -10,7 +10,6 @@
 #include <util/util.h>
 #include <util/parse-options.h>
 #include <util/strbuf.h>
-#include <ndctl/config.h>
 #include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <sys/epoll.h>

