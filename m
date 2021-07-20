Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEE470
	for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 15:51:17 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="209360455"
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="209360455"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 08:51:16 -0700
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="510808269"
Received: from janandra-mobl.amr.corp.intel.com ([10.212.182.134])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 08:51:16 -0700
From: James Anandraj <james.sushanth.anandraj@intel.com>
To: nvdimm@lists.linux.dev,
	james.sushanth.anandraj@intel.com
Subject: [PATCH v2 0/4] ndctl: Add ipmregion tool with ipmregion list and reconfigure-region commands
Date: Tue, 20 Jul 2021 08:51:06 -0700
Message-Id: <20210720155110.14680-1-james.sushanth.anandraj@intel.com>
X-Mailer: git-send-email 2.21.0.windows.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>

The Intel Optane Persistent Memory OS provisioning specification
describes how to support basic provisioning for Intel Optane
persistent memory 100 and 200 series for use in different
operating modes using OS software.

This patch set introduces a new utility ipmregion that implements
basic provisioning as described in the provisioning specification
document at https://cdrdv2.intel.com/v1/dl/getContent/634430 .

The ipmregion utility provides enumeration and region reconfiguration
commands for "nvdimm" subsystem devices (Non-volatile Memory). This
is implemented as a separate tool rather than as a feature of ndctl as
the steps for provisioning are specific to Intel Optane devices and 
are as follows.
1..Generate a new region configuration request using this utility.
2. Reset the platform.
3. Use this utility to list the status of operation.

Since v1:
 * Change name of tool to ipmregion.
 * Change reconfigure-region modes to fault-isolation-pmem and performance-pmem.

James Sushanth Anandraj (4):
  Documentation/ipmregion: Add documentation for ipmregion tool and
    commands
  ipmregion/list: Add ipmregion-list command to enumerate 'nvdimm'
    devices
  ipmregion/reconfigure: Add ipmregion-reconfigure-region command
  ipmregion/reconfigure: Add support for different pmem region modes

 Documentation/ipmregion/Makefile.am           |   59 +
 .../ipmregion/asciidoctor-extensions.rb       |   30 +
 Documentation/ipmregion/ipmregion-list.txt    |   56 +
 .../ipmregion-reconfigure-region.txt          |   51 +
 Documentation/ipmregion/ipmregion.txt         |   40 +
 .../ipmregion/theory-of-operation.txt         |   29 +
 Makefile.am                                   |    4 +-
 configure.ac                                  |    2 +
 ipmregion/Makefile.am                         |   18 +
 ipmregion/builtin.h                           |    9 +
 ipmregion/ipmregion.c                         |   88 +
 ipmregion/list.c                              |  114 ++
 ipmregion/list.h                              |   11 +
 ipmregion/pcat.c                              |   59 +
 ipmregion/pcat.h                              |   13 +
 ipmregion/pcd.h                               |  381 +++++
 ipmregion/reconfigure.c                       | 1458 +++++++++++++++++
 ipmregion/reconfigure.h                       |   12 +
 util/main.h                                   |    1 +
 19 files changed, 2433 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ipmregion/Makefile.am
 create mode 100644 Documentation/ipmregion/asciidoctor-extensions.rb
 create mode 100644 Documentation/ipmregion/ipmregion-list.txt
 create mode 100644 Documentation/ipmregion/ipmregion-reconfigure-region.txt
 create mode 100644 Documentation/ipmregion/ipmregion.txt
 create mode 100644 Documentation/ipmregion/theory-of-operation.txt
 create mode 100644 ipmregion/Makefile.am
 create mode 100644 ipmregion/builtin.h
 create mode 100644 ipmregion/ipmregion.c
 create mode 100644 ipmregion/list.c
 create mode 100644 ipmregion/list.h
 create mode 100644 ipmregion/pcat.c
 create mode 100644 ipmregion/pcat.h
 create mode 100644 ipmregion/pcd.h
 create mode 100644 ipmregion/reconfigure.c
 create mode 100644 ipmregion/reconfigure.h

-- 
2.20.1

