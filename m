Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com
 [IPv6:2607:f8b0:4864:20::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3015921277791
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 17:06:10 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id a132so1201481oib.2
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 17:06:10 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 May 2019 17:05:58 -0700
Message-ID: <CAPcyv4iXv7Jh4rjO9XQAFpeCJEZ4-4nvb46nZyQP554uLNbOyg@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for v5.2-rc1
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.2-rc1

...to receive just a small collection of fixes this time around. The
new virtio-pmem driver is nearly ready, but some last minute
device-mapper acks and virtio questions made it prudent to await v5.3.
Other major topics that were brewing on the linux-nvdimm mailing list
like sub-section hotplug, and other devm_memremap_pages() reworks will
go upstream through Andrew's tree.

These have seen multiple -next releases with no reported issues.

---

The following changes since commit 085b7755808aa11f78ab9377257e1dad2e6fa4bb:

  Linux 5.1-rc6 (2019-04-21 10:45:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.2-rc1

for you to fetch changes up to 67476656febd7ec5f1fe1aeec3c441fcf53b1e45:

  drivers/dax: Allow to include DEV_DAX_PMEM as builtin (2019-05-07
07:48:06 -0700)

----------------------------------------------------------------
libnvdimm fixes 5.2-rc1

* Fix a long standing namespace label corruption scenario when
  re-provisioning capacity for a namespace.

* Restore the ability of the dax_pmem module to be built-in.

* Harden the build for the 'nfit_test' unit test modules so that the
  userspace test harness can ensure all required test modules are
  available.

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      drivers/dax: Allow to include DEV_DAX_PMEM as builtin

Dan Williams (1):
      libnvdimm/namespace: Fix label tracking error

Vishal Verma (2):
      dax/pmem: Fix whitespace in dax_pmem
      tools/testing/nvdimm: add watermarks for dax_pmem* modules

 drivers/dax/Kconfig                         |  3 +--
 drivers/dax/pmem/core.c                     |  6 +++---
 drivers/nvdimm/label.c                      | 29 ++++++++++++++++-------------
 drivers/nvdimm/namespace_devs.c             | 15 +++++++++++++++
 drivers/nvdimm/nd.h                         |  4 ++++
 tools/testing/nvdimm/Kbuild                 |  3 +++
 tools/testing/nvdimm/dax_pmem_compat_test.c |  8 ++++++++
 tools/testing/nvdimm/dax_pmem_core_test.c   |  8 ++++++++
 tools/testing/nvdimm/dax_pmem_test.c        |  8 ++++++++
 tools/testing/nvdimm/test/nfit.c            |  3 +++
 tools/testing/nvdimm/watermark.h            |  3 +++
 11 files changed, 72 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/nvdimm/dax_pmem_compat_test.c
 create mode 100644 tools/testing/nvdimm/dax_pmem_core_test.c
 create mode 100644 tools/testing/nvdimm/dax_pmem_test.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
