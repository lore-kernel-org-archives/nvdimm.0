Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com
 [IPv6:2607:f8b0:4864:20::841])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3486212C01FB
 for <linux-nvdimm@lists.01.org>; Thu, 18 Jul 2019 07:39:47 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id d17so27356709qtj.8
 for <linux-nvdimm@lists.01.org>; Thu, 18 Jul 2019 07:37:19 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Jul 2019 07:37:07 -0700
Message-ID: <CAPcyv4jMjvPYTa00hbq=64LZ=Vcu-gi7hLcgDTnD9d4dF0t9ng@mail.gmail.com>
Subject: [GIT PULL] dax for 5.3
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
Cc: Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-for-5.3

...to receive the fruits of a bug hunt in the fsdax implementation
with Willy and a small feature update for device-dax. These have
appeared in a -next release with no reported issues.

---

The following changes since commit 9e0babf2c06c73cda2c0cd37a1653d823adb40ec:

  Linux 5.2-rc5 (2019-06-16 08:49:45 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-for-5.3

for you to fetch changes up to 23c84eb7837514e16d79ed6d849b13745e0ce688:

  dax: Fix missed wakeup with PMD faults (2019-07-16 19:30:59 -0700)

----------------------------------------------------------------
- Fix a hang condition that started triggering after the Xarray
  conversion of fsdax in the v4.20 kernel.

- Add a 'resource' (root-only physical base address) sysfs attribute to
  device-dax instances to correlate memory-blocks onlined via the kmem
  driver with a given device instance.

----------------------------------------------------------------
Matthew Wilcox (Oracle) (1):
      dax: Fix missed wakeup with PMD faults

Vishal Verma (1):
      device-dax: Add a 'resource' attribute

 drivers/dax/bus.c | 19 +++++++++++++++++++
 fs/dax.c          | 53 +++++++++++++++++++++++++++++++++--------------------
 2 files changed, 52 insertions(+), 20 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
