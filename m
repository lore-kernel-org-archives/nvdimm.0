Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8839E222F4E13
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 12:24:43 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.15-rc5
Date: Sat, 23 Dec 2017 20:29:32 +0000
Message-ID: <1514060957.17984.4.camel@intel.com>
Content-Language: en-US
Content-ID: <8BFBA7B1181F394D8549A59DE538859C@intel.com>
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

* NVDIMM namespaces, configured to enforce 1GB alignment, fail to
initialize on platforms that mis-align the start or end of the physical
address range.

* The Linux implementation of the BTT (Block Translation Table) is
incompatible with the UEFI 2.7 definition of the BTT format. The BTT
layers a software atomic sector semantic on top of an NVDIMM namespace.
Linux needs to be compatible with the UEFI definition to enable boot
support or any pre-OS access of data on a BTT enabled namespace.

* A fix for ACPI SMART notification events, this allows a userspace
monitor to register for health events rather than poll. This has been
broken since it was initially merged as the unit test inadvertently
worked around the problem. The urgency for fixing this during the -rc
series is driven by how expensive it is to poll for this data (System
Management Mode entry).

These fixes are all tagged for -stable and have received a build
success notification from the kbuild robot. Full changelogs below:

---

The following changes since commit ae64f9bd1d3621b5e60d7363bc20afb46aede215:

  Linux 4.15-rc2 (2017-12-03 11:01:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 24e3a7fb60a9187e5df90e5fa655ffc94b9c4f77:

  libnvdimm, btt: Fix an incompatibility in the log layout (2017-12-21 14:59:27 -0800)

----------------------------------------------------------------
Dan Williams (3):
      acpi, nfit: fix health event notification
      libnvdimm, pfn: fix start_pad handling for aligned namespaces
      libnvdimm, dax: fix 1GB-aligned namespaces vs physical misalignment

Vishal Verma (2):
      libnvdimm, btt: add a couple of missing kernel-doc lines
      libnvdimm, btt: Fix an incompatibility in the log layout

 drivers/acpi/nfit/core.c  |   9 ++-
 drivers/nvdimm/btt.c      | 201 ++++++++++++++++++++++++++++++++++++++--------
 drivers/nvdimm/btt.h      |  47 ++++++++++-
 drivers/nvdimm/pfn_devs.c |  20 +++--
 4 files changed, 236 insertions(+), 41 deletions(-)


commit adf6895754e2503d994a765535fd1813f8834674
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Nov 30 19:42:52 2017 -0800

    acpi, nfit: fix health event notification
    
    Integration testing with a BIOS that generates injected health event
    notifications fails to communicate those events to userspace. The nfit
    driver neglects to link the ACPI DIMM device with the necessary driver
    data so acpi_nvdimm_notify() fails this lookup:
    
            nfit_mem = dev_get_drvdata(dev);
            if (nfit_mem && nfit_mem->flags_attr)
                    sysfs_notify_dirent(nfit_mem->flags_attr);
    
    Add the necessary linkage when installing the notification handler and
    clean it up when the nfit driver instance is torn down.
    
    Cc: <stable@vger.kernel.org>
    Cc: Toshi Kani <toshi.kani@hpe.com>
    Cc: Vishal Verma <vishal.l.verma@intel.com>
    Fixes: ba9c8dd3c222 ("acpi, nfit: add dimm device notification support")
    Reported-by: Daniel Osawa <daniel.k.osawa@intel.com>
    Tested-by: Daniel Osawa <daniel.k.osawa@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 19deaa217bc04e83b59b5e8c8229eb0e53ad9efc
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 19 15:07:10 2017 -0800

    libnvdimm, pfn: fix start_pad handling for aligned namespaces
    
    The alignment checks at pfn driver startup fail to properly account for
    the 'start_pad' in the case where the namespace is misaligned relative
    to its internal alignment. This is typically triggered in 1G aligned
    namespace, but could theoretically trigger with small namespace
    alignments. When this triggers the kernel reports messages of the form:
    
        dax2.1: bad offset: 0x3c000000 dax disabled align: 0x40000000
    
    Cc: <stable@vger.kernel.org>
    Fixes: 1ee6667cd8d1 ("libnvdimm, pfn, dax: fix initialization vs autodetect...")
    Reported-by: Jane Chu <jane.chu@oracle.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 41fce90f26333c4fa82e8e43b9ace86c4e8a0120
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 4 14:07:43 2017 -0800

    libnvdimm, dax: fix 1GB-aligned namespaces vs physical misalignment
    
    The following namespace configuration attempt:
    
        # ndctl create-namespace -e namespace0.0 -m devdax -a 1G -f
        libndctl: ndctl_dax_enable: dax0.1: failed to enable
          Error: namespace0.0: failed to enable
    
        failed to reconfigure namespace: No such device or address
    
    ...fails when the backing memory range is not physically aligned to 1G:
    
        # cat /proc/iomem | grep Persistent
        210000000-30fffffff : Persistent Memory (legacy)
    
    In the above example the 4G persistent memory range starts and ends on a
    256MB boundary.
    
    We handle this case correctly when needing to handle cases that violate
    section alignment (128MB) collisions against "System RAM", and we simply
    need to extend that padding/truncation for the 1GB alignment use case.
    
    Cc: <stable@vger.kernel.org>
    Fixes: 315c562536c4 ("libnvdimm, pfn: add 'align' attribute...")
    Reported-and-tested-by: Jane Chu <jane.chu@oracle.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 13b7954c0b8dd2d6382b4ddb5053f09e389d5c6e
Author: Vishal Verma <vishal.l.verma@intel.com>
Date:   Thu Dec 14 17:26:13 2017 -0700

    libnvdimm, btt: add a couple of missing kernel-doc lines
    
    Recent updates to btt.h neglected to add corresponding kernel-doc lines
    for new structure members. Add them.
    
    Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 24e3a7fb60a9187e5df90e5fa655ffc94b9c4f77
Author: Vishal Verma <vishal.l.verma@intel.com>
Date:   Mon Dec 18 09:28:39 2017 -0700

    libnvdimm, btt: Fix an incompatibility in the log layout
    
    Due to a spec misinterpretation, the Linux implementation of the BTT log
    area had different padding scheme from other implementations, such as
    UEFI and NVML.
    
    This fixes the padding scheme, and defaults to it for new BTT layouts.
    We attempt to detect the padding scheme in use when probing for an
    existing BTT. If we detect the older/incompatible scheme, we continue
    using it.
    
    Reported-by: Juston Li <juston.li@intel.com>
    Cc: Dan Williams <dan.j.williams@intel.com>
    Cc: <stable@vger.kernel.org>
    Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
    Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
