Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CCC2C21EA15BD
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 18:52:24 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/4] add error injection commands to nfit_test
Date: Thu,  5 Oct 2017 19:53:36 -0600
Message-Id: <20171006015340.29722-1-vishal.l.verma@intel.com>
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

These patches add error injection support to nfit_test by emulating the
ACPI6.2 ARS error injection commands. The commands are sent via the
ND_CMD_CALL interface, so only nfit_test knows of the various
definitions related to this.

Note that this patch set will break ndctl unit tests unless the ndctl
patches for error injection are also applied.

Dave Jiang (2):
  libnvdimm: move poison list functions to a new 'badrange' file
  nfit_test: add error injection DSMs

Vishal Verma (2):
  libnvdimm, badrange: remove a WARN for list_empty
  nfit_test: when clearing poison, also remove badrange entries

 drivers/acpi/nfit/core.c              |   2 +-
 drivers/acpi/nfit/mce.c               |   2 +-
 drivers/acpi/nfit/nfit.h              |   1 +
 drivers/nvdimm/Makefile               |   1 +
 drivers/nvdimm/badrange.c             | 293 ++++++++++++++++++++++++++++++++++
 drivers/nvdimm/bus.c                  |  24 +--
 drivers/nvdimm/core.c                 | 260 +-----------------------------
 drivers/nvdimm/nd-core.h              |   3 +-
 drivers/nvdimm/nd.h                   |   6 -
 include/linux/libnvdimm.h             |  21 ++-
 tools/testing/nvdimm/Kbuild           |   1 +
 tools/testing/nvdimm/test/nfit.c      | 199 +++++++++++++++++++----
 tools/testing/nvdimm/test/nfit_test.h |   4 +
 13 files changed, 503 insertions(+), 314 deletions(-)
 create mode 100644 drivers/nvdimm/badrange.c

-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
