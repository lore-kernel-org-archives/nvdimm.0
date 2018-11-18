Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF7592118EF65
 for <linux-nvdimm@lists.01.org>; Sat, 17 Nov 2018 18:59:34 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.20-rc3
Date: Sun, 18 Nov 2018 02:59:31 +0000
Message-ID: <629da405d226a802394ba4e1cba4ff24b8589c85.camel@intel.com>
Content-Language: en-US
Content-ID: <D8CE84CF7D9CAC4F8D16492785FE0EF9@intel.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.20-rc3

...to receive a small batch of fixes for v4.20-rc3.

These have soaked in -next for a few releases. The overflow
continuation fix addresses something that has been broken for several
releases. Arguably it could wait even longer, but it's a one line fix
and this finishes the last of the known address range scrub bug
reports. The revert addresses a lockdep regression. The unit tests are
not critical to fix, but no reason to hold this fix back.

---

The following changes since commit 651022382c7f8da46cb4872a545ee1da6d097d2a:

  Linux 4.20-rc1 (2018-11-04 15:37:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.20-rc3

for you to fetch changes up to 2121db09630113e67b51ae78c18115f1858f648a:

  Revert "acpi, nfit: Further restrict userspace ARS start requests" (2018-11-10 09:54:28 -0800)

----------------------------------------------------------------
libnvdimm 4.20-rc3

- Address Range Scrub overflow continuation handling has been broken
  since it was initially merged. It was only recently that error injection
  and platform-BIOS support enabled this corner case to be exercised.

- The recent attempt to provide more isolation for the kernel Address
  Range Scrub state machine from userapace initiated sessions triggers a
  lockdep report. Revert and try again at the next merge window.

- Fix a kasan reported buffer overflow in libnvdimm unit test
  infrastrucutre (nfit_test)

----------------------------------------------------------------
Dan Williams (2):
      acpi, nfit: Fix ARS overflow continuation
      Revert "acpi, nfit: Further restrict userspace ARS start requests"

Masayoshi Mizuma (1):
      tools/testing/nvdimm: Fix the array size for dimm devices.

 drivers/acpi/nfit/core.c         | 19 +++++--------------
 tools/testing/nvdimm/test/nfit.c |  8 ++++----
 2 files changed, 9 insertions(+), 18 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
