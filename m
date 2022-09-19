Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361E2747F
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631249; x=1695167249;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KSFZB3ntka+bSSvolTA/Uf4WdX3s1HtcDYCRMCLVZIU=;
  b=m5rSXVco9glL5uCoVp2ynMUMAVOPPXGiv6k81Nl2U/aSG4Tn4EgLG0KW
   pdhBw8fMH6u37t1+QKpe5UIZnFJwpnO9Rn9Gy/bPCGF1KUBbWlecNoNW+
   4kDctJKzPKmLQmLMz7W8RxL4w/l4VXYIVa+1yMTc/RlJoU3h2v2113NEx
   lpRZ/nUsab+nV+jOH3u8+TuyblCd3hJkWfKRH9tr+57KnPVja7ltq6LmI
   6WYUhfaGIOvv1pV4JI3XcIK8b9HSocPIEdv2Sly74w2kzEClZ6DXbaY6k
   abUv1U5TUAfoegBuLAeUriBIOI/UOnE9IY8oeOgou0Ke1s/kTlLyyQsdI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="279278487"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="279278487"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="744305591"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:27 -0700
Subject: [PATCH v2 9/9] cxl: add man page documentation for monitor
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:47:27 -0700
Message-ID: 
 <166363124742.3861186.7691291186058723572.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add man page documentation to explain the usage of cxl monitor.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/cxl-monitor.txt |   77 +++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 Documentation/cxl/cxl-monitor.txt

diff --git a/Documentation/cxl/cxl-monitor.txt b/Documentation/cxl/cxl-monitor.txt
new file mode 100644
index 000000000000..43c2ece72220
--- /dev/null
+++ b/Documentation/cxl/cxl-monitor.txt
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-monitor(1)
+================
+
+NAME
+----
+cxl-monitor - Monitor the CXL kernel trace events
+
+SYNOPSIS
+--------
+[verse]
+'cxl monitor' [<options>]
+
+DESCRIPTION
+-----------
+Cxl monitor is used for monitoring the CXL trace events emitted by
+the kernel and convert them to json objects and dumping the json format
+notifications to standard output or a logfile.
+
+Both, the values in configuration file and in options will work. If
+there is a conflict, the values in options will override the values in
+the configuration file. Any updated values in the configuration file will
+take effect only after the monitor process is restarted.
+
+EXAMPLES
+--------
+
+Run a monitor as a daemon to monitor events and output to a log file.
+[verse]
+cxl monitor --daemon --log=/var/log/cxl-monitor.log
+
+Run a monitor as a one-shot command and output the notifications to stdio.
+[verse]
+cxl monitor
+
+Run a monitor daemon as a system service
+[verse]
+systemctl start cxl-monitor.service
+
+OPTIONS
+-------
+-l::
+--log=::
+	Send log messages to the specified destination.
+	- "<file>":
+	  Send log messages to specified <file>. When fopen() is not able
+	  to open <file>, log messages will be forwarded to syslog.
+	- "standard":
+	  Send messages to standard output.
+
+The default log destination is '/var/log/cxl-monitor.log' if "--daemon" is specified,
+otherwise 'standard'. Note that standard and relative path for <file>
+will not work if "--daemon" is specified.
+
+--daemon::
+	Run a monitor as a daemon.
+
+-u::
+--human::
+	Output monitor notification as human friendly json format instead
+	of the default machine friendly json format.
+
+-v::
+--verbose::
+	Emit extra debug messages to log.
+
+COPYRIGHT
+---------
+Copyright (c) 2022, Intel Corp. License GPLv2: GNU GPL version 2
+<http://gnu.org/licenses/gpl.html>. This is free software: you are
+free to change and redistribute it. There is NO WARRANTY, to the
+extent permitted by law.
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1]


