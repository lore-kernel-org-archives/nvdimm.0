Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19D2A31
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631196; x=1695167196;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pfPNcLTJNo84gvexI3zu2cHwUZyU2v8zq5XeOdTTlAA=;
  b=WDOhpz5JRNuQt/BJaHo9AWCJm3L43fZyHZ6IGMDmZ4lDgx5mKA2ObaLt
   vNALSO6xR/aueewF0rMJtBvQWbOc54H/ls4PtAMTgage8Qsx3aZGpC31s
   lK8wnzyy9nIBGfGs5Ck2v2NKyuQrbIG192PJbe8kGpxtDjPmrTBI1RF4j
   K0TWrWgRky7hgAMll6vfUFjSu9/cccP6VJOZnfoUCw+zvw6V9KP5s+4vR
   AdiFlBBoFkqVZD9vXyS/hS77TTVJtyxaqN/A9jTyEEmhD0kN7L7UY9+ZM
   5p50Dsl11wPp62DSWC7SbTHXFCl9eQiYUk/W1KN5F7QnxkSHy3hSf9/JH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="300369118"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="300369118"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="722504425"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:34 -0700
Subject: [PATCH v2 0/9] cxl: add monitor support for trace events
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:46:34 -0700
Message-ID: 
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

v2:
- Simplify logging functions (Nathan)
- Drop ndctl prefix (Vishal)
- Reduce to single trace event system (Alison)
- Add systemd startup file
- Add man page

This patch series for ndctl implements the monitor command for the cxl
tool. The initial implementation will collect CXL trace events emitted
by the kernel. libtraceevent and libtracefs will be used to parse the
trace event buffer. The monitor will pend on an epoll fd and wait for
new event entries to be posted. The output will be in json format. By
default the events are emitted to stdio, but can also be logged to a
file. Each event is converted to a JSON object and logged as such.
All the fields exported are read by the monitor code and added to the
JSON object.

---

Dave Jiang (9):
      cxl: add helper function to parse trace event to json object
      cxl: add helper to parse through all current events
      cxl: add common function to enable event trace
      cxl: add common function to disable event trace
      cxl: add monitor function for event trace events
      cxl: add logging functions for monitor
      cxl: add monitor command to cxl
      cxl: add systemd service for monitor
      cxl: add man page documentation for monitor


 Documentation/cxl/cxl-monitor.txt |  77 ++++++++++
 cxl/builtin.h                     |   1 +
 cxl/cxl-monitor.service           |   9 ++
 cxl/cxl.c                         |   1 +
 cxl/event_trace.c                 | 228 ++++++++++++++++++++++++++++
 cxl/event_trace.h                 |  23 +++
 cxl/meson.build                   |   8 +
 cxl/monitor.c                     | 239 ++++++++++++++++++++++++++++++
 meson.build                       |   3 +
 ndctl.spec.in                     |   1 +
 10 files changed, 590 insertions(+)
 create mode 100644 Documentation/cxl/cxl-monitor.txt
 create mode 100644 cxl/cxl-monitor.service
 create mode 100644 cxl/event_trace.c
 create mode 100644 cxl/event_trace.h
 create mode 100644 cxl/monitor.c

--

