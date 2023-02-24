Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03517CE
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 05:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677217562; x=1708753562;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=J4ddzLR+psc4696uSLVSdXy/gmpvIlpCfH9vfaohT5U=;
  b=J9lav/kEwGhgYqTz2mnUEA/QCh3sxTcBDIDWcsa+tzs/H3imAiRDGfvf
   L30wPJKDcjfe8rnXMyYj9WhSdP07Svn9e84KbxfX3/WG2AnUDvpIUGQ3X
   aNlTGdiZpUkD0VLsev7aG+cT7nVSFqlxTjykUO6BbC/FOxGTACkjQRZsI
   gqo7eabpqMUzfb8+Dqh5R9ndxFM3/mnVXLAG2084fmoWAa14Ih2IJ1kj3
   n3LXmJN7f1mlqyDQd9yyzNJi7FpJKni29Ou399sZBd3CwKK3XiC3O4iD4
   mRJrfq49JToHwUpD/FckPSOGb52WSeaPFMKyfqCrSSqtt2JYlHjkLI8wX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="398137019"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="398137019"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:46:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="1001701697"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="1001701697"
Received: from kwameopo-mobl1.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.85.102])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:45:59 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 23 Feb 2023 22:45:38 -0700
Subject: [PATCH ndctl 1/2] cxl/monitor: fix include paths for tracefs and
 traceevent
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230223-meson-build-fixes-v1-1-5fae3b606395@intel.com>
References: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
In-Reply-To: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
To: linux-cxl@vger.kernel.org
Cc: =?utf-8?q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
 Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=2196;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=J4ddzLR+psc4696uSLVSdXy/gmpvIlpCfH9vfaohT5U=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMk//MVt7mmtq5upI5NzTmrbNtcyt/T6q3sjjPuLP4jU5
 X0VsI3tKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwERS+xj+ClyvOVl2SeXF68n8
 4WfSbxxymtkhe9j6e+XXHQdeHXUN38HIcGqDkWpqkLO6fOAO46j42duXy/CalzhXL8nmq990dGY
 7NwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Distros vary on whether the above headers are placed in
{prefix}/libtracefs/ or {prefix}/tracefs/, and likewise for traceevent.

Since both of these libraries do ship with pkgconfig info to determine
the exact include path, the respective #include statements can drop the
{lib}trace{fs,event}/ prefix.

Since the libraries are declared using meson's dependency() function, it
already does the requisite pkgconfig parsing. Drop the above
prefixes to allow the includes work on all distros.

Link: https://github.com/pmem/ndctl/issues/234
Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
Fixes: 7b237bc7a8ae ("cxl: add a helper to go through all current events and parse them")
Reported-by: Michal Suchánek <msuchanek@suse.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/event_trace.c | 4 ++--
 cxl/monitor.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index 76dd4e7..926f446 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -2,14 +2,14 @@
 // Copyright (C) 2022, Intel Corp. All rights reserved.
 #include <stdio.h>
 #include <errno.h>
+#include <event-parse.h>
 #include <json-c/json.h>
 #include <util/json.h>
 #include <util/util.h>
 #include <util/strbuf.h>
 #include <ccan/list/list.h>
 #include <uuid/uuid.h>
-#include <traceevent/event-parse.h>
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 #include "event_trace.h"
 
 #define _GNU_SOURCE
diff --git a/cxl/monitor.c b/cxl/monitor.c
index 749f472..e3469b9 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <errno.h>
+#include <event-parse.h>
 #include <json-c/json.h>
 #include <libgen.h>
 #include <time.h>
@@ -16,8 +17,7 @@
 #include <util/strbuf.h>
 #include <sys/epoll.h>
 #include <sys/stat.h>
-#include <traceevent/event-parse.h>
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 #include <cxl/libcxl.h>
 
 /* reuse the core log helpers for the monitor logger */

-- 
2.39.1

