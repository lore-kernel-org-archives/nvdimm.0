Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E05C2CA8
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418357; x=1672954357;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iz6AwOBqRhVIF+2BPFBwyfgVIPz0neV1GHLBEx3UFBs=;
  b=mIExy2hg05OCdmokg3U31IYZAxwKLFq7ft7SK1XuNb9yieRE7Txr0wsb
   FWLC4BqyFr+2TTQbx12hTCjaHCTc1Dc3T1enkVjD62E/IOXyPST6EGlhX
   sMEmaIOzuKEP8nZ5/uWBNMy70kqO7QYNnMqlyhnMqhMDUrFCP42yicWGL
   8OqfIIT6FheqKMkVZgKvpWzhsOhYPEW2BNoofd9WSgCTpFkdmXqzM7rLJ
   H770I8hAV+5HrWbGsJDJgQxt3pXMQ/cH644X/qGISHU95FhAFgPykHfCU
   AWt1cdBDy8QrjYn/f0QOde5Za9OAXsI1cbNeT0wPC4ufm2tn+o1N50TR9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229863231"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="229863231"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="470718904"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:37 -0800
Subject: [ndctl PATCH v3 11/16] build: Drop unnecessary $tool/config.h
 includes
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:37 -0800
Message-ID: <164141835727.3990253.12971738434561351928.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
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
index 8b600a4e762b..ae694c614593 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -11,7 +11,6 @@
 #include <util/parse-options.h>
 #include <util/parse-configs.h>
 #include <util/strbuf.h>
-#include <ndctl/config.h>
 #include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <sys/epoll.h>

