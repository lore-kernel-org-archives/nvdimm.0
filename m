Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8B42211EB809
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 16:30:15 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id f196so4605118oib.7
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 16:30:15 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Apr 2019 16:30:02 -0700
Message-ID: <CAPcyv4gqXL4H8p-PB1196zx0Gm3+hCZcMUF5330eAGK6SWXoOw@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for 5.1-rc6
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
tags/libnvdimm-fixes-5.1-rc6

...to receive an optional libnvdimm update for v5.1-rc6. I debated
holding this back for the v5.2 merge window due to the size of the
"zero-key" changes, but affected users would benefit from having the
fixes sooner. It did not make sense to change the zero-key semantic in
isolation for the "secure-erase" command, but instead include it for
all security commands.

The short background on the need for these changes is that some NVDIMM
platforms enable security with a default zero-key rather than let the
OS specify the initial key. This makes the security enabling that
landed in v5.0 unusable for some users.

---

The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.1-rc6

for you to fetch changes up to 2170a0d53bee1a6c1a4ebd042f99d85aafc6c0ea:

  tools/testing/nvdimm: Retain security state after overwrite
(2019-04-08 09:39:32 -0700)

----------------------------------------------------------------
libnvdimm fixes v5.1-rc6

- Compatibility fix for nvdimm-security implementations with a default
  zero-key.

- Miscellaneous small fixes for out-of-bound accesses, cleanup after
  initialization failures, and missing debug messages.

----------------------------------------------------------------
Aditya Pakki (1):
      libnvdimm/btt: Fix a kmemdup failure check

Dan Williams (1):
      acpi/nfit: Always dump _DSM output payload

Dave Jiang (3):
      libnvdimm/security: provide fix for secure-erase to use zero-key
      libnvdimm/security, acpi/nfit: unify zero-key for all security commands
      tools/testing/nvdimm: Retain security state after overwrite

Kangjie Lu (1):
      libnvdimm/namespace: Fix a potential NULL pointer dereference

Li RongQing (1):
      libnvdimm/pmem: fix a possible OOB access when read and write pmem

 drivers/acpi/nfit/core.c         |  12 ++--
 drivers/acpi/nfit/intel.c        |  10 ++--
 drivers/nvdimm/btt_devs.c        |  18 ++++--
 drivers/nvdimm/namespace_devs.c  |   5 +-
 drivers/nvdimm/pmem.c            |   8 +--
 drivers/nvdimm/security.c        | 118 ++++++++++++++++++++++++---------------
 tools/testing/nvdimm/test/nfit.c |  17 ++++--
 7 files changed, 117 insertions(+), 71 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
