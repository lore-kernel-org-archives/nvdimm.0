Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2108F1A1DEC
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 10:15:09 -0700 (PDT)
Subject: [PATCH v2 0/2] acpi, nfit: nvdimm notification support + tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Sep 2016 10:12:09 -0700
Message-ID: <147318192936.31512.1001529917260869136.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

While testing v1, I was able to produce the following crash when
removing the nfit module:

 general protection fault: 0000 [#1] SMP
 [..]
 RIP: 0010:[<ffffffff81319f7e>]  [<ffffffff81319f7e>] kernfs_put+0x1e/0x1b0
 RSP: 0018:ffff880461107d50  EFLAGS: 00010286
 RAX: ffff880a67df1b60 RBX: ffff880a67df1b00 RCX: 0000000000000006
 RDX: 0000000000000006 RSI: ffff8804683bb940 RDI: 6b6b6b6b6b6b6b6b
 RBP: ffff880461107d88 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b6b
 R13: ffff880a68cf5a80 R14: ffff880a61c66738 R15: 6b6b6b6b6b6b6b6b
 FS:  00007fbc62a47700(0000) GS:ffff880a6f0c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000558e4f0093c0 CR3: 000000046640c000 CR4: 00000000001406e0
 Stack:
  ffff88046f408b40 00000000ba9be0cd ffff880a67df1b00 ffff880a68cf5b80
  ffff880a68cf5a80 ffff880a61c66738 6b6b6b6b6b6b6b6b ffff880461107dc0
  ffffffffa004742c ffff880a67e01778 ffff880461107e00 ffff880469d28290
 Call Trace:
  [<ffffffffa004742c>] acpi_nfit_destruct+0x6c/0x100 [nfit]
  [<ffffffff815fdecf>] devm_action_release+0xf/0x20
  [<ffffffff815fe9a9>] release_nodes+0x129/0x230
  [<ffffffff815fed1c>] devres_release_all+0x3c/0x60
  [<ffffffff815f9c79>] __device_release_driver+0xa9/0x160
  [<ffffffff815fa8bb>] driver_detach+0xbb/0xc0
  [<ffffffff815f9618>] bus_remove_driver+0x58/0xd0
  [<ffffffff815fb32c>] driver_unregister+0x2c/0x50
  [<ffffffff8153efd9>] acpi_bus_unregister_driver+0x15/0x17
  [<ffffffffa004c177>] nfit_exit+0x15/0xe9e [nfit]
  [<ffffffff8114d99a>] SyS_delete_module+0x1ba/0x220
  [<ffffffff81a0437c>] entry_SYSCALL_64_fastpath+0x1f/0xbd

This was due to the fact that all 'nfit_mem' objects are already freed
by the time we reach acpi_nfit_destruct().  Instead, we now register
shutdown_dimm_notification() via devm_add_action_or_reset() to fire
before 'nfit_mem' instances are torn down.

I maintained the reviewed-by's and acked-by's from v1.

---

Dan Williams (2):
      acpi, nfit: add dimm device notification support
      tools/testing/nvdimm: unit test for acpi_nvdimm_notify()


 drivers/acpi/nfit/core.c         |   99 ++++++++++++++++++++++++++++++++++++--
 drivers/acpi/nfit/nfit.h         |    6 ++
 drivers/nvdimm/dimm_devs.c       |    6 ++
 include/linux/libnvdimm.h        |    1 
 tools/testing/nvdimm/test/nfit.c |   45 +++++++++++++++++
 5 files changed, 153 insertions(+), 4 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
