Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 06E581A1DEB
 for <linux-nvdimm@lists.01.org>; Wed, 28 Sep 2016 17:11:00 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/3] misc updates for Address Range Scrub
Date: Wed, 28 Sep 2016 18:10:08 -0600
Message-Id: <1475107811-8880-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Patch 1 changes the default behaviour on machine check exceptions to
just adding the error address to badblocks accounting instead of starting
a full ARS. The old behaviour can be enabled via sysfs.

Patch 2 and 3 fix a problem where stale badblocks could show up after an
on-demand ARS or an MCE triggered scrub because when clearing poison, we
didn't clear the internal nvdimm_bus->poison_list.


Vishal Verma (3):
  nfit: don't start a full scrub by default for an MCE
  pmem: reduce kmap_atomic sections to the memcpys only
  libnvdimm: clear the internal poison_list when clearing badblocks

 drivers/acpi/nfit/core.c  | 23 +++++++++++++--
 drivers/acpi/nfit/mce.c   | 24 ++++++++++++----
 drivers/acpi/nfit/nfit.h  |  6 ++++
 drivers/nvdimm/bus.c      |  2 ++
 drivers/nvdimm/core.c     | 73 ++++++++++++++++++++++++++++++++++++++++++++---
 drivers/nvdimm/pmem.c     | 28 ++++++++++++++----
 include/linux/libnvdimm.h |  2 ++
 7 files changed, 141 insertions(+), 17 deletions(-)

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
