Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FB9181F91
 for <linux-nvdimm@lists.01.org>; Fri,  9 Dec 2016 07:18:41 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.9-final
Date: Fri, 9 Dec 2016 15:18:39 +0000
Message-ID: <1481296717.13593.17.camel@intel.com>
Content-Language: en-US
Content-ID: <A10FCB9DD11F714EABA896B26EC85ECC@intel.com>
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

...to receive several fixes to the DSM (ACPI device specific method)
marshaling implementation.

I consider these urgent enough to send for 4.9 consideration since they
fix the kernel's handling of ARS (Address Range Scrub) commands.
Especially for platforms without machine-check-recovery capabilities,
successful execution of ARS commands enables the platform to
potentially break out of an infinite reboot problem if a media error is
present in the boot path. There is also a one line fix for a device-dax 
read-only mapping regression.

"acpi, nfit: fix extended status translations for ACPI DSMs" and
"device-dax: fix private mapping restriction, permit read-only" are
true regression fixes for changes introduced this cycle. "acpi, nfit,
libnvdimm: fix / harden ars_status output length handling" fixes the
kernel's handling of zero-length results, this never would have worked
in the past, but we only just recently discovered a BIOS implementation
that emits this arguably spec non-compliant result. The remaining two
commits are additional fall out from thinking through the implications
of a zero / truncated length result of the ARS Status command.

In order to mitigate the risk that these changes introduce yet more
regressions they are backstopped by a new unit test in
"tools/testing/nvdimm: unit test acpi_nfit_ctl()" that mocks inputs to
acpi_nfit_ctl().

Please consider pulling for 4.9, it has appeared in a -next release
with no reported issues.

The following changes since commit 3e5de27e940d00d8d504dfb96625fb654f641509:

  Linux 4.9-rc8 (2016-12-04 12:50:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 325896ffdf90f7cbd59fb873b7ba20d60d1ddf3c:

  device-dax: fix private mapping restriction, permit read-only (2016-12-06 17:42:37 -0800)

----------------------------------------------------------------
Dan Williams (5):
      acpi, nfit, libnvdimm: fix / harden ars_status output length handling
      acpi, nfit: validate ars_status output buffer size
      acpi, nfit: fix bus vs dimm confusion in xlat_status
      tools/testing/nvdimm: unit test acpi_nfit_ctl()
      device-dax: fix private mapping restriction, permit read-only

Vishal Verma (1):
      acpi, nfit: fix extended status translations for ACPI DSMs

 drivers/acpi/nfit/core.c              |  55 +++++---
 drivers/acpi/nfit/nfit.h              |   2 +
 drivers/dax/dax.c                     |   2 +-
 drivers/nvdimm/bus.c                  |  25 +++-
 include/linux/libnvdimm.h             |   2 +-
 tools/testing/nvdimm/Kbuild           |   1 +
 tools/testing/nvdimm/test/iomap.c     |  23 +++-
 tools/testing/nvdimm/test/nfit.c      | 236 +++++++++++++++++++++++++++++++++-
 tools/testing/nvdimm/test/nfit_test.h |   8 +-
 9 files changed, 326 insertions(+), 28 deletions(-)

commit 9a901f5495e26e691c7d0ea7b6057a2f3e6330ed
Author: Vishal Verma <vishal.l.verma@intel.com>
Date:   Mon Dec 5 17:00:37 2016 -0700

    acpi, nfit: fix extended status translations for ACPI DSMs
    
    ACPI DSMs can have an 'extended' status which can be non-zero to convey
    additional information about the command. In the xlat_status routine,
    where we translate the command statuses, we were returning an error for
    a non-zero extended status, even if the primary status indicated success.
    
    Return from each command's 'case' once we have verified both its status
    and extend status are good.
    
    Cc: <stable@vger.kernel.org>
    Fixes: 11294d63ac91 ("nfit: fail DSMs that return non-zero status by default")
    Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit efda1b5d87cbc3d8816f94a3815b413f1868e10d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 6 09:10:12 2016 -0800

    acpi, nfit, libnvdimm: fix / harden ars_status output length handling
    
    Given ambiguities in the ACPI 6.1 definition of the "Output (Size)"
    field of the ARS (Address Range Scrub) Status command, a firmware
    implementation may in practice return 0, 4, or 8 to indicate that there
    is no output payload to process.
    
    The specification states "Size of Output Buffer in bytes, including this
    field.". However, 'Output Buffer' is also the name of the entire
    payload, and earlier in the specification it states "Max Query ARS
    Status Output Buffer Size: Maximum size of buffer (including the Status
    and Extended Status fields)".
    
    Without this fix if the BIOS happens to return 0 it causes memory
    corruption as evidenced by this result from the acpi_nfit_ctl() unit
    test.
    
     ars_status00000000: 00020000 00000000                    ........
     BUG: stack guard page was hit at ffffc90001750000 (stack is ffffc9000174c000..ffffc9000174ffff)
     kernel stack overflow (page fault): 0000 [#1] SMP DEBUG_PAGEALLOC
     task: ffff8803332d2ec0 task.stack: ffffc9000174c000
     RIP: 0010:[<ffffffff814cfe72>]  [<ffffffff814cfe72>] __memcpy+0x12/0x20
     RSP: 0018:ffffc9000174f9a8  EFLAGS: 00010246
     RAX: ffffc9000174fab8 RBX: 0000000000000000 RCX: 000000001fffff56
     RDX: 0000000000000000 RSI: ffff8803231f5a08 RDI: ffffc90001750000
     RBP: ffffc9000174fa88 R08: ffffc9000174fab0 R09: ffff8803231f54b8
     R10: 0000000000000008 R11: 0000000000000001 R12: 0000000000000000
     R13: 0000000000000000 R14: 0000000000000003 R15: ffff8803231f54a0
     FS:  00007f3a611af640(0000) GS:ffff88033ed00000(0000) knlGS:0000000000000000
     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
     CR2: ffffc90001750000 CR3: 0000000325b20000 CR4: 00000000000406e0
     Stack:
      ffffffffa00bc60d 0000000000000008 ffffc90000000001 ffffc9000174faac
      0000000000000292 ffffffffa00c24e4 ffffffffa00c2914 0000000000000000
      0000000000000000 ffffffff00000003 ffff880331ae8ad0 0000000800000246
     Call Trace:
      [<ffffffffa00bc60d>] ? acpi_nfit_ctl+0x49d/0x750 [nfit]
      [<ffffffffa01f4fe0>] nfit_test_probe+0x670/0xb1b [nfit_test]
    
    Cc: <stable@vger.kernel.org>
    Fixes: 747ffe11b440 ("libnvdimm, tools/testing/nvdimm: fix 'ars_status' output buffer sizing")
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 82aa37cf09867c5e2c0326649d570e5b25c1189a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 6 12:45:24 2016 -0800

    acpi, nfit: validate ars_status output buffer size
    
    If an ARS Status command returns truncated output, do not process
    partial records or otherwise consume non-status fields.
    
    Cc: <stable@vger.kernel.org>
    Fixes: 0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d6eb270c57fef35798525004ddf2ac5dcdadd43b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 6 15:06:55 2016 -0800

    acpi, nfit: fix bus vs dimm confusion in xlat_status
    
    Given dimms and bus commands share the same command number space we need
    to be careful that we are translating status in the correct context.
    Otherwise we can, for example, fail an ND_CMD_GET_CONFIG_SIZE command
    because max_xfer is zero. It fails because that condition erroneously
    correlates with the 'cleared == 0' failure of ND_CMD_CLEAR_ERROR.
    
    Cc: <stable@vger.kernel.org>
    Fixes: aef253382266 ("libnvdimm, nfit: centralize command status translation")
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a7de92dac9f0dbf01deb56fe1d661d7baac097e1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 5 13:43:25 2016 -0800

    tools/testing/nvdimm: unit test acpi_nfit_ctl()
    
    A recent flurry of bug discoveries in the nfit driver's DSM marshalling
    routine has highlighted the fact that we do not have unit test coverage
    for this routine. Add a self-test of acpi_nfit_ctl() routine before
    probing the "nfit_test.0" device. This mocks stimulus to acpi_nfit_ctl()
    and if any of the tests fail "nfit_test.0" will be unavailable causing
    the rest of the tests to not run / fail.
    
    This unit test will also be a place to land reproductions of quirky BIOS
    behavior discovered in the field and ensure the kernel does not regress
    against implementations it has seen in practice.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 325896ffdf90f7cbd59fb873b7ba20d60d1ddf3c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 6 17:03:35 2016 -0800

    device-dax: fix private mapping restriction, permit read-only
    
    Hugh notes in response to commit 4cb19355ea19 "device-dax: fail all
    private mapping attempts":
    
      "I think that is more restrictive than you intended: haven't tried, but I
      believe it rejects a PROT_READ, MAP_SHARED, O_RDONLY fd mmap, leaving no
      way to mmap /dev/dax without write permission to it."
    
    Indeed it does restrict read-only mappings, switch to checking
    VM_MAYSHARE, not VM_SHARED.
    
    Cc: <stable@vger.kernel.org>
    Cc: Dave Hansen <dave.hansen@linux.intel.com>
    Cc: Pawel Lebioda <pawel.lebioda@intel.com>
    Fixes: 4cb19355ea19 ("device-dax: fail all private mapping attempts")
    Reported-by: Hugh Dickins <hughd@google.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
