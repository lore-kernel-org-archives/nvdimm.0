Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7F4B81F9C
 for <linux-nvdimm@lists.01.org>; Mon,  6 Feb 2017 17:41:49 -0800 (PST)
Received: by mail-oi0-x22b.google.com with SMTP id u143so57016057oif.3
 for <linux-nvdimm@lists.01.org>; Mon, 06 Feb 2017 17:41:49 -0800 (PST)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 6 Feb 2017 17:41:48 -0800
Message-ID: <CAPcyv4gskP8FMP8x8stU5Q+P0aDSBu+zDqa3mp0S-RncOT145g@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for 4.10
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

* Fix a crash that can result when SIGINT is sent to a process that is
awaiting completion of an address range scrub command. We were not
properly cleaning up the workqueue after wait_event_interruptible().

* Fix a memory hotplug failure condition that results from not
reserving enough space out of persistent memory for the memmap. By
default we align to 2M allocations that the memory hotplug code
assumes, but if the administrator specifies a non-default 4K-alignment
then we can fail to correctly size the reservation.

* A one line fix to improve the predictability of libnvdimm block
device names. A common operation is to reconfigure /dev/pmem0 into a
different mode. For example, a reconfiguration might set a new mode
that reserves some of the capacity for a struct page memmap array. It
surprises users if the device name changes to "/dev/pmem0.1" after the
mode change and then back to /dev/pmem0 after a reboot.

* Add 'const' to some function pointer tables.

None of these are showstoppers for 4.10 and could wait for 4.11 merge
window, but they are low enough risk for this late in the cycle and
the fixes have waiting users . They have received a build success
notification from the 0day robot, pass the latest ndctl unit tests,
and appeared in next-20170206.

The following changes since commit 7a308bb3016f57e5be11a677d15b821536419d36:

  Linux 4.10-rc5 (2017-01-22 12:54:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to bfb34527a32a1a576d9bfb7026d3ab0369a6cd60:

  libnvdimm, pfn: fix memmap reservation size versus 4K alignment
(2017-02-04 14:47:31 -0800)

----------------------------------------------------------------
Bhumika Goyal (1):
      nvdimm: constify device_type structures

Dan Williams (3):
      libnvdimm, namespace: do not delete namespace-id 0
      acpi, nfit: fix acpi_nfit_flush_probe() crash
      libnvdimm, pfn: fix memmap reservation size versus 4K alignment

 drivers/acpi/nfit/core.c        |  6 +++++-
 drivers/nvdimm/namespace_devs.c | 17 ++++++++++-------
 drivers/nvdimm/pfn_devs.c       |  7 ++-----
 3 files changed, 17 insertions(+), 13 deletions(-)

commit 970d14e3989160ee9e97c7d75ecbc893fd29dab9
Author: Bhumika Goyal <bhumirks@gmail.com>
Date:   Wed Jan 25 00:54:07 2017 +0530

    nvdimm: constify device_type structures

    Declare device_type structure as const as it is only stored in the
    type field of a device structure. This field is of type const, so add
    const to declaration of device_type structure.

    File size before:
      text   data    bss    dec    hex filename
      19278   3199     16  22493   57dd nvdimm/namespace_devs.o

    File size after:
      text   data    bss    dec    hex filename
      19929   3160     16  23105   5a41 nvdimm/namespace_devs.o

    Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9d032f4201d39e5cf43a8709a047e481f5723fdc
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Jan 25 00:54:07 2017 +0530

    libnvdimm, namespace: do not delete namespace-id 0

    Given that the naming of pmem devices changes from the pmemX form to the
    pmemX.Y form when namespace id is greater than 0, arrange for namespaces
    with id-0 to be exempt from deletion. Otherwise a simple reconfiguration
    of an existing namespace to a new mode results in a name change of the
    resulting block device:

        # ndctl list --namespace=namespace1.0
        {
          "dev":"namespace1.0",
          "mode":"raw",
          "size":2147483648,
          "uuid":"3dadf3dc-89b9-4b24-b20e-abc8a4707ce3",
          "blockdev":"pmem1"
        }

        # ndctl create-namespace --reconfig=namespace1.0 --mode=memory --force
        {
          "dev":"namespace1.1",
          "mode":"memory",
          "size":2111832064,
          "uuid":"7b4a6341-7318-4219-a02c-fb57c0bbf613",
          "blockdev":"pmem1.1"
        }

    This change does require tooling changes to explicitly look for
    namespaceX.0 if the seed has already advanced to another namespace.

    Cc: <stable@vger.kernel.org>
    Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of
multiple pmem-namespaces per region")
    Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e471486c13b82b1338d49c798f78bb62b1ed0a9e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Feb 2 10:31:00 2017 -0800

    acpi, nfit: fix acpi_nfit_flush_probe() crash

    We queue an on-stack work item to 'nfit_wq' and wait for it to complete
    as part of a 'flush_probe' request. However, if the user cancels the
    wait we need to make sure the item is flushed from the queue otherwise
    we are leaving an out-of-scope stack address on the work list.

     BUG: unable to handle kernel paging request at ffffbcb3c72f7cd0
     IP: [<ffffffffa9413a7b>] __list_add+0x1b/0xb0
     [..]
     RIP: 0010:[<ffffffffa9413a7b>]  [<ffffffffa9413a7b>] __list_add+0x1b/0xb0
     RSP: 0018:ffffbcb3c7ba7c00  EFLAGS: 00010046
     [..]
     Call Trace:
      [<ffffffffa90bb11a>] insert_work+0x3a/0xc0
      [<ffffffffa927fdda>] ? seq_open+0x5a/0xa0
      [<ffffffffa90bb30a>] __queue_work+0x16a/0x460
      [<ffffffffa90bbb08>] queue_work_on+0x38/0x40
      [<ffffffffc0cf2685>] acpi_nfit_flush_probe+0x95/0xc0 [nfit]
      [<ffffffffc0cf25d0>] ? nfit_visible+0x40/0x40 [nfit]
      [<ffffffffa9571495>] wait_probe_show+0x25/0x60
      [<ffffffffa9546b30>] dev_attr_show+0x20/0x50

    Fixes: 7ae0fa439faf ("nfit, libnvdimm: async region scrub workqueue")
    Cc: <stable@vger.kernel.org>
    Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bfb34527a32a1a576d9bfb7026d3ab0369a6cd60
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Feb 4 14:47:31 2017 -0800

    libnvdimm, pfn: fix memmap reservation size versus 4K alignment

    When vmemmap_populate() allocates space for the memmap it does so in 2MB
    sized chunks. The libnvdimm-pfn driver incorrectly accounts for this
    when the alignment of the device is set to 4K. When this happens we
    trigger memory allocation failures in altmap_alloc_block_buf() and
    trigger warnings of the form:

     WARNING: CPU: 0 PID: 3376 at arch/x86/mm/init_64.c:656
arch_add_memory+0xe4/0xf0
     [..]
     Call Trace:
      dump_stack+0x86/0xc3
      __warn+0xcb/0xf0
      warn_slowpath_null+0x1d/0x20
      arch_add_memory+0xe4/0xf0
      devm_memremap_pages+0x29b/0x4e0

    Fixes: 315c562536c4 ("libnvdimm, pfn: add 'align' attribute,
default to HPAGE_SIZE")
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
