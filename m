Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 355BB211B63CA
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 20:37:08 -0800 (PST)
Subject: [daxctl PATCH v2 0/2] daxctl: Opt-in to /sys/bus/dax ABI
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 20:24:31 -0800
Message-ID: <154752627111.1710673.1469336464670065810.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:
* Make the opt-in based on an explicit command rather than an implicit
  side-effect of installing a new daxctl.
* Split the daxctl support from the patch implementing the opt-in
* Rebase on command harness reworks and other ndctl cleanups
[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-November/018677.html

---

Quote patch2:

The kernel is implementing a '/sys/bus/dax' ABI to allow for alternate
device-DAX drivers to be bound to device instances. While the kernel
conversion to '/sys/bus/dax' does not effect the primary ndctl use case
of putting namespaces into 'devdax' mode since that uses libnvdimm
namespace device relative paths, it does break current implementations
of 'ndctl list -X' and 'daxctl list'.  It is also known to break fio and
some pmdk versions that explicitly reference "/sys/class/dax".

In order to avoid userspace regressions the kernel can be configured to
maintain '/sys/class/dax' as the default ABI. However, once all
'/sys/class/dax' users have been converted, or removed from the
installation, an administrator can opt-in to the new '/sys/bus/dax' ABI.
The 'dax migrate-device-model' command installs a modprobe rule to
blacklist the dax_pmem_compat module and arrange for the dax_pmem module
to auto-load in response to the detection of device-DAX instances
emitted from the libnvdimm subsystem.

---

Dan Williams (2):
      daxctl: Support the /sys/bus/dax ABI
      daxctl: Opt-in to /sys/bus/dax ABI


 .gitignore                                         |    1 
 Documentation/daxctl/Makefile.am                   |    3 +
 .../daxctl/daxctl-migrate-device-model.txt         |   47 +++++++++++++
 configure.ac                                       |    5 +
 daxctl/Makefile.am                                 |   10 +++
 daxctl/builtin.h                                   |    1 
 daxctl/daxctl.c                                    |    1 
 daxctl/lib/Makefile.am                             |    2 +
 daxctl/lib/daxctl.conf                             |    2 +
 daxctl/lib/libdaxctl-private.h                     |   11 +++
 daxctl/lib/libdaxctl.c                             |   70 ++++++++++++++------
 daxctl/migrate.c                                   |   41 ++++++++++++
 ndctl.spec.in                                      |    1 
 util/sysfs.c                                       |    2 -
 14 files changed, 175 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/daxctl/daxctl-migrate-device-model.txt
 create mode 100644 daxctl/lib/daxctl.conf
 create mode 100644 daxctl/migrate.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
