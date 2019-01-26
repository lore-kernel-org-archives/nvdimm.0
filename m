Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABC16211B63E5
 for <linux-nvdimm@lists.01.org>; Sat, 26 Jan 2019 15:31:00 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for v5.0-rc4
Date: Sat, 26 Jan 2019 23:30:58 +0000
Message-ID: <f0086a11a40fb97503fb559b53dcc94c9f873e32.camel@intel.com>
Content-Language: en-US
Content-ID: <D9368736BB26C24CB193A8E5C580E28D@intel.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.0-rc4

...to receive a fix for namespace label support for non-Intel NVDIMMs
that implement the ACPI standard label method. This has apparently
never worked and could wait for v5.1. However it has enough visibility
with hardware vendors [1] and distro bug trackers [2], and low enough
risk that I decided it should go in for -rc4. The other fixups target
the new, for v5.0, nvdimm security functionality. The larger init path
fixup closes a memory leak and a potential userspace lockup due to
missed notifications.

These have all soaked in -next for a week with no reported issues.

[1]: https://github.com/pmem/ndctl/issues/78
[2]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1811785

---

The following changes since commit 49a57857aeea06ca831043acbb0fa5e0f50602fd:

  Linux 5.0-rc3 (2019-01-21 13:14:44 +1300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.0-rc4

for you to fetch changes up to 11189c1089da413aa4b5fd6be4c4d47c78968819:

  acpi/nfit: Fix command-supported detection (2019-01-21 09:58:31 -0800)

----------------------------------------------------------------
libnvdimm v5.0-rc4

* Fix support for NVDIMMs that implement the ACPI standard label
  methods.
* Fix error handling for security overwrite (memory leak / userspace
  hang condition), and another one-line security cleanup

----------------------------------------------------------------
Dan Williams (3):
      libnvdimm/security: Require nvdimm_security_setup_events() to succeed
      acpi/nfit: Block function zero DSMs
      acpi/nfit: Fix command-supported detection

Dave Jiang (1):
      nfit_test: fix security state pull for nvdimm security nfit_test

 drivers/acpi/nfit/core.c         | 66 ++++++++++++++++++++++++++++------------
 drivers/nvdimm/dimm.c            |  6 ++++
 drivers/nvdimm/dimm_devs.c       | 22 +++++++++++---
 drivers/nvdimm/nd.h              |  1 +
 include/linux/libnvdimm.h        |  1 -
 tools/testing/nvdimm/dimm_devs.c |  4 +--
 6 files changed, 73 insertions(+), 27 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
