From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fix for v5.3-rc8
Date: Fri, 6 Sep 2019 13:00:00 -0700
Message-ID: <CAPcyv4jDWgZDJTAgghrFX1MQXPJX_6jiqsmx9sQUOL7ZaWtk+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jmoyer <jmoyer@redhat.com>
List-Id: linux-nvdimm@lists.01.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fix-5.3-rc8

...to receive a fix for a regression introduced in v5.3-rc1. The
latest version has shipped in -next with no reported issues.

---

The following changes since commit a55aa89aab90fae7c815b0551b07be37db359d76:

  Linux 5.3-rc6 (2019-08-25 12:01:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fix-5.3-rc8

for you to fetch changes up to 274b924088e93593c76fb122d24bc0ef18d0ddf4:

  libnvdimm/pfn: Fix namespace creation on misaligned addresses
(2019-08-28 10:33:13 -0700)

----------------------------------------------------------------
libnvdimm fix v5.3-rc8

- Restore support for 1GB alignment namespaces, truncate the end of
  misaligned namespaces.

----------------------------------------------------------------
Jeff Moyer (1):
      libnvdimm/pfn: Fix namespace creation on misaligned addresses

 drivers/nvdimm/pfn_devs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
