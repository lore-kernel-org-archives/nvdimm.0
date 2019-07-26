Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EED2A212E13DB
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jul 2019 15:56:26 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id r21so50865790otq.6
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jul 2019 15:54:00 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jul 2019 15:53:47 -0700
Message-ID: <CAPcyv4gqE6zOoSibTgjbWWHE3VVQ0wSJN-NxwF288nTe2Z3yzA@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for 5.3-rc2
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.3-rc2

...to receive a collection of locking and async operations fixes for
v5.3-rc2. These had been soaking in a branch targeting the merge
window, but missed due to a regression hunt. This fixed up version has
otherwise been in -next this past week with no reported issues.

In order to gain confidence in the locking changes the pull also
includes a debug / instrumentation patch to enable lockdep coverage
for libnvdimm subsystem operations that depend on the device_lock for
exclusion. As mentioned in the changelog it is a hack, but it works
and documents the locking expectations of the sub-system in a way that
others can use lockdep to verify. The driver core touches got an ack
from Greg.

Please pull, but I'll understand if you want a resend with the debug
patch dropped.

---

The following changes since commit d1fdb6d8f6a4109a4263176c84b899076a5f8008:

  Linux 5.2-rc4 (2019-06-08 20:24:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.3-rc2

for you to fetch changes up to 87a30e1f05d73a34e6d1895065541369131aaf1c:

  driver-core, libnvdimm: Let device subsystems add local lockdep
coverage (2019-07-18 16:23:27 -0700)

----------------------------------------------------------------
libnvdimm fixes v5.3-rc2

- Fix duplicate device_unregister() calls (multiple threads competing to
  do unregister work when scheduling device removal from a sysfs attribute
  of the self-same device).

- Fix badblocks registration order bug. Ensure region badblocks are
  initialized in advance of namespace registration.

- Fix a deadlock between the bus lock and probe operations.

- Export device-core infrastructure to coordinate async operations via
  the device ->dead state.

- Add device-core infrastructure to validate device_lock() usage with
  lockdep.

----------------------------------------------------------------
Dan Williams (7):
      drivers/base: Introduce kill_device()
      libnvdimm/bus: Prevent duplicate device_unregister() calls
      libnvdimm/region: Register badblocks before namespaces
      libnvdimm/bus: Prepare the nd_ioctl() path to be re-entrant
      libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()
      libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock
      driver-core, libnvdimm: Let device subsystems add local lockdep coverage

 drivers/acpi/nfit/core.c        |  28 +++---
 drivers/acpi/nfit/nfit.h        |  24 +++++
 drivers/base/core.c             |  30 ++++--
 drivers/nvdimm/btt_devs.c       |  16 +--
 drivers/nvdimm/bus.c            | 210 ++++++++++++++++++++++++++--------------
 drivers/nvdimm/core.c           |  10 +-
 drivers/nvdimm/dimm_devs.c      |   4 +-
 drivers/nvdimm/namespace_devs.c |  36 +++----
 drivers/nvdimm/nd-core.h        |  71 +++++++++++++-
 drivers/nvdimm/pfn_devs.c       |  24 ++---
 drivers/nvdimm/pmem.c           |   4 +-
 drivers/nvdimm/region.c         |  24 ++---
 drivers/nvdimm/region_devs.c    |  12 ++-
 drivers/nvdimm/region.c         |  24 ++---
 drivers/nvdimm/region_devs.c    |  12 ++-
 include/linux/device.h          |   6 ++
 14 files changed, 343 insertions(+), 156 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
