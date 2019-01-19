Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BC8D209688E8
 for <linux-nvdimm@lists.01.org>; Sat, 19 Jan 2019 13:01:20 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: libnvdimm fixes 5.0-rc3
Date: Sat, 19 Jan 2019 21:01:19 +0000
Message-ID: <1992f8e8823f44f583a36d6d027f6e6ef5b3909a.camel@intel.com>
Content-Language: en-US
Content-ID: <049E1EF1D7C85743BC795666A8AC3979@intel.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.0-rc3

...to receive a crash fix, a build warning fix, a miscellaneous small
cleanups.

In case anyone is looking for them, there was a regression caught by
testing that caused 2 patches to be dropped from this update. Those
patches [1] [2] have been reworked and will soak for another week / re-
target 5.0-rc4.

[1]: "acpi/nfit: Block function zero DSMs"
https://patchwork.kernel.org/patch/10765211/
[2]: "acpi/nfit: Fix command-supported detection" 
https://patchwork.kernel.org/patch/10772123/

Everything else has been in -next release with no reported issues.

---

The following changes since commit bfeffd155283772bbe78c6a05dec7c0128ee500c:

  Linux 5.0-rc1 (2019-01-06 17:08:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.0-rc3

for you to fetch changes up to faa8bd6e12e6aeea289d8e6ba74777b72a69434c:

  libnvdimm/security: Fix nvdimm_security_state() state request selection (2019-01-15 13:54:33 -0800)

----------------------------------------------------------------
libnvdimm v5.0-rc3

* Fix driver initialization crash due to the inability to report an
  'error' state for a DIMM's security capability.
* Build warning fix for little-endian ARM64 builds
* Fix a potential race between the EDAC driver's usage of the NFIT
  SMBIOS id for a DIMM and the driver shutdown path.
* A small collection of one-line benign cleanups for duplicate variable
  assignments, a duplicate header include and a mis-typed function
  argument.

----------------------------------------------------------------
Dan Williams (1):
      libnvdimm/dimm: Fix security capability detection for non-Intel NVDIMMs

Dave Jiang (1):
      libnvdimm/security: Fix nvdimm_security_state() state request selection

Nathan Chancellor (1):
      nfit: Mark some functions as __maybe_unused

Tony Luck (1):
      acpi/nfit: Fix race accessing memdev in nfit_get_smbios_id()

Wei Yang (1):
      acpi/nfit: Remove duplicate set nd_set in acpi_nfit_init_interleave_set()

Xiaochun Lee (2):
      ACPI/nfit: delete the redundant header file
      ACPI/nfit: delete the function to_acpi_nfit_desc

 drivers/acpi/nfit/core.c  | 20 +++++++-------------
 drivers/acpi/nfit/intel.c |  8 ++++----
 drivers/nvdimm/nd-core.h  |  4 ++--
 include/linux/libnvdimm.h |  1 +
 4 files changed, 14 insertions(+), 19 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
