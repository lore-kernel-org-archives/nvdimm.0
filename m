Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F03D81DDF
 for <linux-nvdimm@lists.01.org>; Fri, 28 Oct 2016 11:17:28 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.9-rc3
Date: Fri, 28 Oct 2016 18:17:27 +0000
Message-ID: <1477678645.21985.7.camel@intel.com>
Content-Language: en-US
Content-ID: <916D42E254729F4198FE9E7F00D4722E@intel.com>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

A compilation fix, a NULL de-reference found by static analysis, a
misuse of the percpu_ref_exit() (tagged for -stable), and notification
of failed attempts to clear media errors.

These patches have received a build success notification from the 0day-
kbuild-robot and appeared in next-20161028.

---

The following changes since commit 1001354ca34179f3db924eb66672442a173147dc:

  Linux 4.9-rc1 (2016-10-15 12:17:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 52e73eb2872c9af6f382b2b22954ca8214397a4e:

  device-dax: fix percpu_ref_exit ordering (2016-10-27 17:04:05 -0700)

----------------------------------------------------------------
Arnd Bergmann (1):
      nvdimm: make CONFIG_NVDIMM_DAX 'bool'

Dan Carpenter (1):
      libnvdimm, namespace: potential NULL deref on allocation error

Dan Williams (1):
      device-dax: fix percpu_ref_exit ordering

Toshi Kani (1):
      pmem: report error on clear poison failure

 drivers/dax/Kconfig             |  2 +-
 drivers/dax/pmem.c              |  2 +-
 drivers/nvdimm/Kconfig          |  2 +-
 drivers/nvdimm/namespace_devs.c | 14 ++++++++------
 drivers/nvdimm/pmem.c           |  8 ++++++--
 5 files changed, 17 insertions(+), 11 deletions(-)

---

commit 75d29713b792da4782cadfaa87e802183440694e
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Wed Oct 12 09:34:29 2016 +0300

    libnvdimm, namespace: potential NULL deref on allocation error
    
    If the kcalloc() fails then "devs" can be NULL and we dereference it
    checking "devs[i]".
    
    Fixes: 1b40e09a1232 ('libnvdimm: blk labels and namespace instantiation')
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3115bb02b5c23d960df5f1bf551ec394a9bb10ec
Author: Toshi Kani <toshi.kani@hpe.com>
Date:   Thu Oct 13 09:54:21 2016 -0600

    pmem: report error on clear poison failure
    
    ACPI Clear Uncorrectable Error DSM function may fail or may be
    unsupported on a platform.  pmem_clear_poison() returns without clearing
    badblocks in such cases.  This failure is detected at the next read
    (-EIO).
    
    This behavior can lead to an issue when user keeps writing but does not
    read immediately.  For instance, flight recorder file may be only read
    when it is necessary for troubleshooting.
    
    Change pmem_do_bvec() and pmem_clear_poison() to return -EIO so that
    filesystem can log an error message on a write error.
    
    Cc: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 867dfe342118b1ea0256a85f7c0d9ceb0ead032a
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Oct 25 17:52:04 2016 +0200

    nvdimm: make CONFIG_NVDIMM_DAX 'bool'
    
    A bugfix just tried to address a randconfig build problem and introduced
    a variant of the same problem: with CONFIG_LIBNVDIMM=y and
    CONFIG_NVDIMM_DAX=m, the nvdimm module now fails to link:
    
    drivers/nvdimm/built-in.o: In function `to_nd_device_type':
    bus.c:(.text+0x1b5d): undefined reference to `is_nd_dax'
    drivers/nvdimm/built-in.o: In function `nd_region_notify_driver_action.constprop.2':
    region_devs.c:(.text+0x6b6c): undefined reference to `is_nd_dax'
    region_devs.c:(.text+0x6b8c): undefined reference to `to_nd_dax'
    drivers/nvdimm/built-in.o: In function `nd_region_probe':
    region.c:(.text+0x70f3): undefined reference to `nd_dax_create'
    drivers/nvdimm/built-in.o: In function `mode_show':
    namespace_devs.c:(.text+0xa196): undefined reference to `is_nd_dax'
    drivers/nvdimm/built-in.o: In function `nvdimm_namespace_common_probe':
    (.text+0xa55f): undefined reference to `is_nd_dax'
    drivers/nvdimm/built-in.o: In function `nvdimm_namespace_common_probe':
    (.text+0xa56e): undefined reference to `to_nd_dax'
    
    This reverts the earlier fix, making NVDIMM_DAX a 'bool' option again
    as it should be (it gets linked into the libnvdimm module). To fix
    the original problem, I'm adding a dependency on LIBNVDIMM to
    DEV_DAX_PMEM, which ensures we can't have that one built-in if the
    rest is a module.
    
    Fixes: 4e65e9381c7a ("/dev/dax: fix Kconfig dependency build breakage")
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 52e73eb2872c9af6f382b2b22954ca8214397a4e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Oct 27 17:04:05 2016 -0700

    device-dax: fix percpu_ref_exit ordering
    
    We need to wait until the percpu_ref is released before exit. Otherwise,
    we sometimes lose the race and trigger this new warning that was added
    in v4.9 (commit a67823c1ed10 "percpu-refcount: init ->confirm_switch
    member properly"):
    
     WARNING: CPU: 0 PID: 3629 at lib/percpu-refcount.c:107 percpu_ref_exit+0x51/0x60
     [..]
     Call Trace:
      [<ffffffff814bf093>] dump_stack+0x85/0xc2
      [<ffffffff810b15db>] __warn+0xcb/0xf0
      [<ffffffff810b170d>] warn_slowpath_null+0x1d/0x20
      [<ffffffff814d70c1>] percpu_ref_exit+0x51/0x60
      [<ffffffffa005706a>] dax_pmem_percpu_exit+0x1a/0x50 [dax_pmem]
      [<ffffffff81615f1f>] devm_action_release+0xf/0x20
    
    Cc: <stable@vger.kernel.org>
    Fixes: ab68f2622136 ("/dev/dax, pmem: direct access to persistent memory")
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
