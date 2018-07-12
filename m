Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5D572097E27C
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 11:13:26 -0700 (PDT)
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.18-rc5
Date: Thu, 12 Jul 2018 18:13:12 +0000
Message-ID: <1531419190.22963.6.camel@intel.com>
Content-Language: en-US
Content-ID: <13D7101256C4E14B9EBC5DA22B9A4B0B@intel.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.18-rc5

...to receive, three fixes, a test unit fix, and a ratelimit change on output.

The following changes since commit 7daf201d7fe8334e2d2364d4e8ed3394ec9af819:

  Linux 4.18-rc2 (2018-06-24 20:54:29 +0800)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-4.18-rc5

for you to fetch changes up to ee6581ceba7f8314b81b2f2a81f1cf3f67c679e2:

  nfit: fix unchecked dereference in acpi_nfit_ctl (2018-07-11 10:25:24 -0700)

----------------------------------------------------------------
* fix one ensures that a variable passed in by reference to
acpi_nfit_ctl is always set to a value. An incremental patch is provided
due to notice from testing in -next. The rest of the commits did not
exhibit issues.

* fix two fixes a return path in nsio_rw_bytes() that was not
returning "bytes remain" as expected for the function.

* fix three addresses an issue where applications polling on
scrub-completion for the NVDIMM may falsely wakeup and read the wrong
state value and cause hang.

* the test unit changed the persistent capability to reflect the correct
attribute it's testing.

* An output ratelimit to dev_info is introduced to the dax device
check_vma() function since this is easily triggered from userspace.

----------------------------------------------------------------
Dan Williams (2):
      libnvdimm, pmem: Fix memcpy_mcsafe() return code handling in nsio_rw_bytes()
      acpi, nfit: Fix scrub idle detection

Dave Jiang (2):
      acpi/nfit: fix cmd_rc for acpi_nfit_ctl to always return a value
      nfit: fix unchecked dereference in acpi_nfit_ctl

Jeff Moyer (1):
      dev-dax: check_vma: ratelimit dev_info-s

Vishal Verma (1):
      tools/testing/nvdimm: advertise a write cache for nfit_test

 drivers/acpi/nfit/core.c         | 48 +++++++++++++++++++++++++++++++---------
 drivers/acpi/nfit/nfit.h         |  1 +
 drivers/dax/device.c             | 12 ++++++----
 drivers/nvdimm/claim.c           |  1 +
 tools/testing/nvdimm/test/nfit.c |  3 +--
 5 files changed, 48 insertions(+), 17 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
