Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EB032119927D
 for <linux-nvdimm@lists.01.org>; Sat,  8 Dec 2018 22:18:04 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.20-rc6
Date: Sun, 9 Dec 2018 06:18:02 +0000
Message-ID: <705f91734ecb4ffbddb2470a797541c876745c6e.camel@intel.com>
Content-Language: en-US
Content-ID: <103E65E7473D4945B0049B4CE4477988@intel.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.20-rc6

...to receive a regression fix for the Address Range Scrub
implementation, yes another one, and support for platforms that
misalign persistent memory relative to the Linux memory hotplug section
constraint. Longer term, support for sub-section memory hotplug would
alleviate alignment waste, but until then this hack allows a 'struct
page' memmap to be established for these misaligned memory regions.

These have all appeared in a -next release, and thanks to Patrick for
reporting and testing the alignment padding fix.

---

The following changes since commit 9ff01193a20d391e8dbce4403dd5ef87c7eaaca6:

  Linux 4.20-rc3 (2018-11-18 13:33:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.20-rc6

for you to fetch changes up to b5fd2e00a60248902315fb32210550ac3cb9f44c:

  acpi/nfit: Fix user-initiated ARS to be "ARS-long" rather than "ARS-short" (2018-12-05 14:16:13 -0800)

----------------------------------------------------------------
libnvdimm fixes 4.20-rc6

* Unless and until the core mm handles memory hotplug units smaller than
  a section (128M), persistent memory namespaces must be padded to
  section alignment. The libnvdimm core already handled section
  collision with "System RAM", but some configurations overlap
  independent "Persistent Memory" ranges within a section, so additional
  padding injection is added for that case.

* The recent reworks of the ARS (address range scrub) state machine to
  reduce the number of state flags inadvertantly missed a conversion of
  acpi_nfit_ars_rescan() call sites. Fix the regression whereby
  user-requested ARS results in a "short" scrub rather than a "long"
  scrub.

* Fixup the unit tests to handle / test the 128M section alignment of
  mocked test resources.

----------------------------------------------------------------
Dan Williams (3):
      tools/testing/nvdimm: Align test resources to 128M
      libnvdimm, pfn: Pad pfn namespaces relative to other regions
      acpi/nfit: Fix user-initiated ARS to be "ARS-long" rather than "ARS-short"

 drivers/acpi/nfit/core.c         |  2 +-
 drivers/nvdimm/nd-core.h         |  2 ++
 drivers/nvdimm/pfn_devs.c        | 64 +++++++++++++++++++++++-----------------
 drivers/nvdimm/region_devs.c     | 41 +++++++++++++++++++++++++
 tools/testing/nvdimm/test/nfit.c | 35 ++++++++++++++++++++--
 5 files changed, 114 insertions(+), 30 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
