Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0D3A21275441
 for <linux-nvdimm@lists.01.org>; Sat, 25 May 2019 09:05:15 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id l17so11399201otq.1
 for <linux-nvdimm@lists.01.org>; Sat, 25 May 2019 09:05:15 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 25 May 2019 09:05:03 -0700
Message-ID: <CAPcyv4ghA3bGeTFw+wVV5N8cb-izpwdi9BQU5Ec6wNTw8ZywMw@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for v5.2-rc2
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
tags/libnvdimm-fixes-5.2-rc2

...to receive a regression fix, a small (2 line code change)
performance enhancement, and some miscellaneous compilation warning
fixes. These have soaked in -next the past week with no known issues.
The device-mapper touches have Mike's ack, and the hardened user-copy
bypass was reviewed with Kees.

---

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.2-rc2

for you to fetch changes up to 52f476a323f9efc959be1c890d0cdcf12e1582e0:

  libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead (2019-05-20
20:43:32 -0700)

----------------------------------------------------------------
libnvdimm fixes v5.2-rc2

- Fix a regression that disabled device-mapper dax support

- Remove unnecessary hardened-user-copy overhead (>30%) for dax
  read(2)/write(2).

- Fix some compilation warnings.

----------------------------------------------------------------
Dan Williams (2):
      dax: Arrange for dax_supported check to span multiple devices
      libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead

Qian Cai (1):
      libnvdimm: Fix compilation warnings with W=1

 drivers/dax/super.c          | 88 ++++++++++++++++++++++++++++----------------
 drivers/md/dm-table.c        | 17 ++++++---
 drivers/md/dm.c              | 20 ++++++++++
 drivers/md/dm.h              |  1 +
 drivers/nvdimm/bus.c         |  4 +-
 drivers/nvdimm/label.c       |  2 +
 drivers/nvdimm/label.h       |  2 -
 drivers/nvdimm/pmem.c        | 11 +++++-
 drivers/s390/block/dcssblk.c |  1 +
 include/linux/dax.h          | 26 +++++++++++++
 10 files changed, 129 insertions(+), 43 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
