Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3E05380
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591341; x=1692127341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hWdnQGSa5Du+Yzjo1XKDR7Gzv21wnxh5foUJXYJfm4I=;
  b=I1zHikFmLCHFKKKAeEciGJ1ARaMTveEG18vQwzXKjBs5vazFEZzZ9O9u
   61rNFamCPzIZgYkr5PdlbMCoyD7DXMZKYkTld5Znwrj8garR4IJjMExxN
   H6fKgvg1dAleEhql31s09pSPK1dWrHpzzooKdGzkEZKYHthODt1aLw+YN
   QPrf2mIM4ewYKh1g017lDTPmmdab1Bi25B+N+hZT85vs0dAyrSvIa5nc7
   3SIwnr4Ta/0Aa9Yi7NR+DDc5HGAGJTvSnsnTAuiyJyByvFE6lg+SRB2Hb
   4+y0itgCrmU0zVt2oTvfdKJmr+W3X2Fs6avKdTMMhKfJD45L7rSu3GYcY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038709"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038709"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758243"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:18 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 02/11] cxl/port: Consolidate the debug option in cxl-port man pages
Date: Mon, 15 Aug 2022 13:22:05 -0600
Message-Id: <20220815192214.545800-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2436; h=from:subject; bh=hWdnQGSa5Du+Yzjo1XKDR7Gzv21wnxh5foUJXYJfm4I=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jy1T4txFP074dWHG/zNkyPcl98UsY4oOVsXqv59wvM1 YcoPOkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCR2ZMY/ofwVSRcrLCZ0bn+yvWWi/ euXZn6JiLbNubFxdqTvB2VvPMZGZZvenv6nCf35j+nd/Xm1BiWHe0+LlHXtn//9sLJ+qte2vECAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

In preparation for additional commands that implement the --debug
option, consolidate the option description from the cxl-port man pages
into an include.

The port man pages also mentioned the debug option requiring a build
with debug enabled, which wasn't true - so remove that part.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-disable-port.txt | 5 +----
 Documentation/cxl/cxl-enable-port.txt  | 5 +----
 Documentation/cxl/debug-option.txt     | 4 ++++
 Documentation/cxl/meson.build          | 1 +
 4 files changed, 7 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/cxl/debug-option.txt

diff --git a/Documentation/cxl/cxl-disable-port.txt b/Documentation/cxl/cxl-disable-port.txt
index ac56f20..7a22efc 100644
--- a/Documentation/cxl/cxl-disable-port.txt
+++ b/Documentation/cxl/cxl-disable-port.txt
@@ -30,10 +30,7 @@ OPTIONS
 	firmware and disabling an active device is akin to force removing memory
 	from a running system.
 
---debug::
-	If the cxl tool was built with debug disabled, turn on debug
-	messages.
-
+include::debug-option.txt[]
 
 include::../copyright.txt[]
 
diff --git a/Documentation/cxl/cxl-enable-port.txt b/Documentation/cxl/cxl-enable-port.txt
index 9a37cef..50b53d1 100644
--- a/Documentation/cxl/cxl-enable-port.txt
+++ b/Documentation/cxl/cxl-enable-port.txt
@@ -31,10 +31,7 @@ OPTIONS
 	memdev is only enabled after all CXL ports in its device topology
 	ancestry are enabled.
 
---debug::
-	If the cxl tool was built with debug enabled, turn on debug
-	messages.
-
+include::debug-option.txt[]
 
 include::../copyright.txt[]
 
diff --git a/Documentation/cxl/debug-option.txt b/Documentation/cxl/debug-option.txt
new file mode 100644
index 0000000..70b922f
--- /dev/null
+++ b/Documentation/cxl/debug-option.txt
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+
+--debug::
+	Turn on additional debug messages including library debug.
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index d019dfc..423be90 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -22,6 +22,7 @@ filedeps = [
   '../copyright.txt',
   'memdev-option.txt',
   'labels-options.txt',
+  'debug-option.txt',
 ]
 
 cxl_manpages = [
-- 
2.37.1

