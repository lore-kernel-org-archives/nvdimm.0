Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0693B21219AE5
 for <linux-nvdimm@lists.01.org>; Fri,  3 May 2019 14:32:41 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/8] daxctl: add a new reconfigure-device command
Date: Fri,  3 May 2019 15:32:23 -0600
Message-Id: <20190503213231.12280-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a new daxctl-reconfigure-device command that lets us reconfigure DAX
devices back and forth between 'system-ram' and 'device-dax' modes. It
also includes facilities to online any newly hot-plugged memory
(default), and attempt to offline memory before converting away from the
system-ram mode (not default, requires a --attempt-offline option).

Currently missing from this series is a way to persistently store which
devices have been 'marked' for use as system-ram. This depends on a
config system overhaul in ndctl, and patches for those will follow
separately and are independent of this work.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>


Vishal Verma (8):
  libdaxctl: add interfaces in support of device modes
  libdaxctl: cache 'subsystem' in daxctl_ctx
  daxctl: add libdaxctl interfaces to enable/disable devices
  ndctl: add helpers to get/set the online state for a node
  daxctl: add a new reconfigure-device command
  Documentation/daxctl: add a man page for daxctl-reconfigure-device
  contrib/ndctl: fix region-id completions for daxctl
  contrib/ndctl: add bash-completion for daxctl-reconfigure-device

 Documentation/daxctl/Makefile.am              |   3 +-
 .../daxctl/daxctl-reconfigure-device.txt      |  74 +++
 contrib/ndctl                                 |  34 +-
 daxctl/Makefile.am                            |   2 +
 daxctl/builtin.h                              |   1 +
 daxctl/daxctl.c                               |   1 +
 daxctl/device.c                               | 217 ++++++++
 daxctl/lib/Makefile.am                        |   3 +-
 daxctl/lib/libdaxctl-private.h                |  21 +
 daxctl/lib/libdaxctl.c                        | 511 +++++++++++++++++-
 daxctl/lib/libdaxctl.sym                      |  13 +
 daxctl/libdaxctl.h                            |  15 +
 12 files changed, 884 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/daxctl/daxctl-reconfigure-device.txt
 create mode 100644 daxctl/device.c

-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
