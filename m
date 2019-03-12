Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Mar 2019 16:20:52 -0700
Message-ID: <CAPcyv4g5NH=4wKs7+V3hTw1Qv6peBQbb7xCyjjQn3bhj7J0WTw@mail.gmail.com>
Subject: [GIT PULL] Filesystem-DAX fixes for 5.1
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/fsdax-for-5.1

...to receive a small collection of cleanups and an Xarray fix for
v5.1-rc1. It has soaked in -next without issue, although the Xarray
fix was recently re-flowed to fix up a tracepoint argument and add
Jan's reviewed-by.

---

The following changes since commit d13937116f1e82bf508a6325111b322c30c85eb9:

  Linux 5.0-rc6 (2019-02-10 14:42:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/fsdax-for-5.1

for you to fetch changes up to e4b3448bc346fedf36db64124a664a959995b085:

  dax: Flush partial PMDs correctly (2019-03-01 17:24:48 -0800)

----------------------------------------------------------------
filesystem-dax for 5.1

* Fix handling of PMD-sized entries in the Xarray that lead to a crash
  scenario.

* Miscellaneous cleanups and small fixes

----------------------------------------------------------------
Ira Weiny (1):
      fs/dax: NIT fix comment regarding start/end vs range

Matthew Wilcox (1):
      dax: Flush partial PMDs correctly

Souptick Joarder (1):
      fs/dax: Convert to use vmf_error()

 fs/dax.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)
