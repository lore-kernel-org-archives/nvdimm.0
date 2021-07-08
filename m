Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CB9173
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 18:37:54 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="231332236"
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="231332236"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:37:48 -0700
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="411017427"
Received: from janandra-mobl.amr.corp.intel.com ([10.251.31.93])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:37:47 -0700
From: James Anandraj <james.sushanth.anandraj@intel.com>
To: nvdimm@lists.linux.dev,
	james.sushanth.anandraj@intel.com
Subject: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and reconfigure-region commands
Date: Thu,  8 Jul 2021 11:37:37 -0700
Message-Id: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
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

This patch set introduces a new utility pcdctl that implements
basic provisioning as described in the provisioning specification
document at https://cdrdv2.intel.com/v1/dl/getContent/634430 .

The pcdctl utility provides enumeration and region reconfiguration
commands for "nvdimm" subsystem devices (Non-volatile Memory). This
is implemented as a separate tool rather than as a feature of ndctl as
the steps for provisioning are specific to Intel Optane devices and 
are as follows.
1..Generate a new region configuration request using this utility.
2. Reset the platform.
3. Use this utility to list the status of operation.

James Sushanth Anandraj (4):
  Documentation/pcdctl: Add documentation for pcdctl tool and commands
  pcdctl/list: Add pcdctl-list command to enumerate 'nvdimm' devices
  pcdctl/reconfigure: Add pcdctl-reconfigure-region command
  pcdctl/reconfigure: Add support for pmem and iso-pmem modes

 Documentation/pcdctl/Makefile.am              |   59 +
 .../pcdctl/asciidoctor-extensions.rb          |   30 +
 Documentation/pcdctl/pcdctl-list.txt          |   56 +
 .../pcdctl/pcdctl-reconfigure-region.txt      |   50 +
 Documentation/pcdctl/pcdctl.txt               |   40 +
 Documentation/pcdctl/theory-of-operation.txt  |   28 +
 Makefile.am                                   |    4 +-
 configure.ac                                  |    2 +
 pcdctl/Makefile.am                            |   18 +
 pcdctl/builtin.h                              |    9 +
 pcdctl/list.c                                 |  114 ++
 pcdctl/list.h                                 |   11 +
 pcdctl/pcat.c                                 |   59 +
 pcdctl/pcat.h                                 |   13 +
 pcdctl/pcd.h                                  |  381 +++++
 pcdctl/pcdctl.c                               |   88 +
 pcdctl/reconfigure.c                          | 1458 +++++++++++++++++
 pcdctl/reconfigure.h                          |   12 +
 util/main.h                                   |    1 +
 19 files changed, 2431 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/pcdctl/Makefile.am
 create mode 100644 Documentation/pcdctl/asciidoctor-extensions.rb
 create mode 100644 Documentation/pcdctl/pcdctl-list.txt
 create mode 100644 Documentation/pcdctl/pcdctl-reconfigure-region.txt
 create mode 100644 Documentation/pcdctl/pcdctl.txt
 create mode 100644 Documentation/pcdctl/theory-of-operation.txt
 create mode 100644 pcdctl/Makefile.am
 create mode 100644 pcdctl/builtin.h
 create mode 100644 pcdctl/list.c
 create mode 100644 pcdctl/list.h
 create mode 100644 pcdctl/pcat.c
 create mode 100644 pcdctl/pcat.h
 create mode 100644 pcdctl/pcd.h
 create mode 100644 pcdctl/pcdctl.c
 create mode 100644 pcdctl/reconfigure.c
 create mode 100644 pcdctl/reconfigure.h

-- 
2.20.1

