Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 381E6209831EC
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 16:00:15 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/4] misc fixups for ndctl-monitor
Date: Thu, 19 Jul 2018 16:59:54 -0600
Message-Id: <20180719225958.6814-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fix a couple of issues reported by static analysis, improve the error
reporting, and add a missing option to the monitor man page

Vishal Verma (4):
  ndctl, monitor: Add a config-file section to the man page
  ndctl, monitor: fix memory leak in read_config_file
  ndctl, monitor: Fix memory leak in monitor_event
  ndctl, monitor: improve error reporting throughout monitor.c

 Documentation/ndctl/ndctl-monitor.txt |   5 ++
 ndctl/monitor.c                       | 129 +++++++++++++++++-----------------
 2 files changed, 69 insertions(+), 65 deletions(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
