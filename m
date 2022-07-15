Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58CE20E0
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 06:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657866370; x=1689402370;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NQ4NuWAlV2dadlW4eVcTlcLJAcETtWo3wyISjTFm6B8=;
  b=Pu9IpE48vA0gGj3nLG7MjpeC3GAZq/xPirdKGTZbRkjLtZs9WbLpsq7z
   MGZPrKqhn5Qr7K/x7VB9EeqPURMnD0g4ITmkjmAwQA1g1coiXf6YuuvHP
   ExMKGYy/QMC1Hm4imaHKkr9Iy5GcKjiMvMYfvk3vWCNfAGjG+RbUwnjCU
   PVqCIez97JN+RYWHMtPMlyNLr8Z4QrliUerq1fg9R+ESVtIeLmdA9z+mp
   sUB9JlaElZqoG5oKTzeuZYAp7IqKCRtzgZisuhX3MeZSFB57+P8SvvQCL
   nxiXG0TMmreKHsLLXYuHZZEtDfXyBpi1ynjKtyFUlzJzve/wtbaFxfs1l
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266125533"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="266125533"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:09 -0700
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="546544608"
Received: from saseiper-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.71.32])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:08 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/8] cxl/port: Consolidate the debug option in cxl-port man pages
Date: Fri, 15 Jul 2022 00:25:44 -0600
Message-Id: <20220715062550.789736-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715062550.789736-1-vishal.l.verma@intel.com>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2382; h=from:subject; bh=NQ4NuWAlV2dadlW4eVcTlcLJAcETtWo3wyISjTFm6B8=; b=owGbwMvMwCXGf25diOft7jLG02pJDEkXOXIN7t98y7rdxlU6YvHnKQ2TjHiZ49efsf6YyiDn8YPv xZF7HaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjIIXuGP3zXQpdzbVEpnhPUv1rAXz I59ISE7V6u2E3HPKo2CKjPWM3IsP2efIbOb+mYkJmJnJLTul6dn/Dx/Hu7/cfLj8SatHCmswIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

In preparation for additional commands that implement the --debug
option, consolidate the option description from the cxl-port man pages
into an include.

The port man pages also mentioned the debug option requiring a build
with debug enabled, which wasn't true - so remove that part.

Cc: Dan Williams <dan.j.williams@intel.com>
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
2.36.1

