Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B070212BF9DE
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jul 2019 18:24:33 -0700 (PDT)
Subject: [PATCH v2 0/7] libnvdimm: Fix async operations and locking
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:07:48 -0700
Message-ID: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Erwin Tsaur <erwin.tsaur@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:

- Fix an ioctl command corruption regression that manifested as an
  intermittent failure of the monitor.sh unit test. This is handled in
  the patch4 prep patch that makes it safe for nd_ioctl() to be
  re-entrant. (Vishal)

- Update the changelog for the driver-core 'lockdep_lock' hack to
  indicate Greg's non-NAK.

[1]: https://lore.kernel.org/lkml/156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com/

---

The libnvdimm subsystem uses async operations to parallelize device
probing operations and to allow sysfs to trigger device_unregister() on
deleted namepsaces. A multithreaded stress test of the libnvdimm sysfs
interface uncovered a case where device_unregister() is triggered
multiple times, and the subsequent investigation uncovered a broken
locking scenario.

The lack of lockdep coverage for device_lock() stymied the debug. That
is, until patch6 "driver-core, libnvdimm: Let device subsystems add
local lockdep coverage" solved that with a shadow lock, with lockdep
coverage, to mirror device_lock() operations. Given the time saved with
shadow-lock debug-hack, patch6 attempts to generalize device_lock()
debug facility that might be able to be carried upstream. Patch6 is
staged at the end of this fix series in case it is contentious and needs
to be dropped.

Patch1 "drivers/base: Introduce kill_device()" could be achieved with
local libnvdimm infrastructure. However, the existing 'dead' flag in
'struct device_private' aims to solve similar async register/unregister
races so the fix in patch2 "libnvdimm/bus: Prevent duplicate
device_unregister() calls" can be implemented with existing driver-core
infrastructure.

Patch3 is a rare lockdep warning that is intermittent based on
namespaces racing ahead of the completion of probe of their parent
region. It is not related to the other fixes, it just happened to
trigger as a result of the async stress test.

Patch5 and patch6 address an ABBA deadlock tripped by the stress test.

These patches pass the failing stress test and the existing libnvdimm
unit tests with CONFIG_PROVE_LOCKING=y and the new "dev->lockdep_mutex"
shadow lock with no lockdep warnings.

---

Dan Williams (7):
      drivers/base: Introduce kill_device()
      libnvdimm/bus: Prevent duplicate device_unregister() calls
      libnvdimm/region: Register badblocks before namespaces
      libnvdimm/bus: Prepare the nd_ioctl() path to be re-entrant
      libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()
      libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock
      driver-core, libnvdimm: Let device subsystems add local lockdep coverage


 drivers/acpi/nfit/core.c        |   28 +++--
 drivers/acpi/nfit/nfit.h        |   24 ++++
 drivers/base/core.c             |   30 ++++--
 drivers/nvdimm/btt_devs.c       |   16 +--
 drivers/nvdimm/bus.c            |  210 ++++++++++++++++++++++++++-------------
 drivers/nvdimm/core.c           |   10 +-
 drivers/nvdimm/dimm_devs.c      |    4 -
 drivers/nvdimm/namespace_devs.c |   36 +++----
 drivers/nvdimm/nd-core.h        |   71 +++++++++++++
 drivers/nvdimm/pfn_devs.c       |   24 ++--
 drivers/nvdimm/pmem.c           |    4 -
 drivers/nvdimm/region.c         |   24 ++--
 drivers/nvdimm/region_devs.c    |   12 +-
 include/linux/device.h          |    6 +
 14 files changed, 343 insertions(+), 156 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
