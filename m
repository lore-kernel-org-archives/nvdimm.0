Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FB46D0F
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 19:53:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="197038220"
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="197038220"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 12:52:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="428909490"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 12:52:57 -0700
Subject: [ndctl PATCH 3/6] build: Drop unnecessary $tool/config.h includes
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Date: Fri, 09 Jul 2021 12:52:56 -0700
Message-ID: <162586037675.1431180.18352963282603697078.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
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
index ed869d383641..f90ac1f1a6db 100644
--- a/ndctl/keys.c
+++ b/ndctl/keys.c
@@ -14,7 +14,6 @@
 #include <syslog.h>
 
 #include <ndctl.h>
-#include <ndctl/config.h>
 #include <ndctl/libndctl.h>
 
 #include "keys.h"
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

