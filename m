Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hillosipuli.retiisi.org.uk (retiisi.org.uk [95.216.213.190])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 509E82194EB7B
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 06:21:12 -0700 (PDT)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Date: Fri, 22 Mar 2019 15:21:06 +0200
Message-Id: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
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
To: Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-pci@vger.kernel.org, sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, ceph-devel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, drbd-dev@lists.linbit.com
List-ID: <linux-nvdimm@lists.01.org>

Hi all,

The printk family of functions supports %ps and %pS conversion specifiers
to print function names. Yet the deprecated %pf and %pF conversion
specifiers with equivalent functionality remain supported. A number of
users of %pf and %pF remain.

This patchsets converts the existing users of %pf and %pF to %ps and %pS,
respectively, and removes support for the deprecated %pf and %pF.

The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
%pf or %pF users have been added in the meantime so the patch is
sufficient as itself on linux-next, too.

Sakari Ailus (2):
  treewide: Switch printk users from %pf and %pF to %ps and %pS,
    respectively
  vsprintf: Remove support for %pF and %pf in favour of %pS and %ps

 Documentation/core-api/printk-formats.rst | 10 ----------
 arch/alpha/kernel/pci_iommu.c             | 20 ++++++++++----------
 arch/arm/mach-imx/pm-imx6.c               |  2 +-
 arch/arm/mm/alignment.c                   |  2 +-
 arch/arm/nwfpe/fpmodule.c                 |  2 +-
 arch/microblaze/mm/pgtable.c              |  2 +-
 arch/sparc/kernel/ds.c                    |  2 +-
 arch/um/kernel/sysrq.c                    |  2 +-
 arch/x86/include/asm/trace/exceptions.h   |  2 +-
 arch/x86/kernel/irq_64.c                  |  2 +-
 arch/x86/mm/extable.c                     |  4 ++--
 arch/x86/xen/multicalls.c                 |  2 +-
 drivers/acpi/device_pm.c                  |  2 +-
 drivers/base/power/main.c                 |  6 +++---
 drivers/base/syscore.c                    | 12 ++++++------
 drivers/block/drbd/drbd_receiver.c        |  2 +-
 drivers/block/floppy.c                    | 10 +++++-----
 drivers/cpufreq/cpufreq.c                 |  2 +-
 drivers/mmc/core/quirks.h                 |  2 +-
 drivers/nvdimm/bus.c                      |  2 +-
 drivers/nvdimm/dimm_devs.c                |  2 +-
 drivers/pci/pci-driver.c                  | 14 +++++++-------
 drivers/pci/quirks.c                      |  4 ++--
 drivers/pnp/quirks.c                      |  2 +-
 drivers/scsi/esp_scsi.c                   |  2 +-
 fs/btrfs/tests/free-space-tree-tests.c    |  4 ++--
 fs/f2fs/f2fs.h                            |  2 +-
 fs/pstore/inode.c                         |  2 +-
 include/trace/events/btrfs.h              |  2 +-
 include/trace/events/cpuhp.h              |  4 ++--
 include/trace/events/preemptirq.h         |  2 +-
 include/trace/events/rcu.h                |  4 ++--
 include/trace/events/sunrpc.h             |  2 +-
 include/trace/events/timer.h              |  8 ++++----
 include/trace/events/vmscan.h             |  4 ++--
 include/trace/events/workqueue.h          |  4 ++--
 include/trace/events/xen.h                |  2 +-
 init/main.c                               |  6 +++---
 kernel/async.c                            |  4 ++--
 kernel/events/uprobes.c                   |  2 +-
 kernel/fail_function.c                    |  2 +-
 kernel/irq/debugfs.c                      |  2 +-
 kernel/irq/handle.c                       |  2 +-
 kernel/irq/manage.c                       |  2 +-
 kernel/irq/spurious.c                     |  4 ++--
 kernel/rcu/tree.c                         |  2 +-
 kernel/stop_machine.c                     |  2 +-
 kernel/time/sched_clock.c                 |  2 +-
 kernel/time/timer.c                       |  2 +-
 kernel/workqueue.c                        | 12 ++++++------
 lib/error-inject.c                        |  2 +-
 lib/percpu-refcount.c                     |  4 ++--
 lib/vsprintf.c                            |  8 ++------
 mm/memblock.c                             | 12 ++++++------
 mm/memory.c                               |  2 +-
 mm/vmscan.c                               |  2 +-
 net/ceph/osd_client.c                     |  2 +-
 net/core/net-procfs.c                     |  2 +-
 net/core/netpoll.c                        |  4 ++--
 scripts/checkpatch.pl                     |  5 -----
 60 files changed, 111 insertions(+), 130 deletions(-)

-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
