Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AC07212B2042
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jul 2019 17:11:27 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a127so5977496oii.2
 for <linux-nvdimm@lists.01.org>; Thu, 04 Jul 2019 17:11:27 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Jul 2019 17:11:16 -0700
Message-ID: <CAPcyv4hs6bncxc3_vOKYYc-XdL+-dv_dJkmV8EduRrshv3rBgQ@mail.gmail.com>
Subject: [GIT PULL] dax fix for v5.2-rc8
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
Cc: Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/dax-fix-5.2-rc8

...to receive a single dax fix that has been soaking awaiting other
fixes under discussion to join it. As it is getting late in the cycle
lets proceed with this fix and save follow-on changes for
post-v5.3-rc1.

---

The following changes since commit f2c7c76c5d0a443053e94adb9f0918fa2fb85c3a:

  Linux 5.2-rc3 (2019-06-02 13:55:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/dax-fix-5.2-rc8

for you to fetch changes up to 1571c029a2ff289683ddb0a32253850363bcb8a7:

  dax: Fix xarray entry association for mixed mappings (2019-06-06
22:18:49 -0700)

----------------------------------------------------------------
dax fix v5.2-rc8

- Ensure proper accounting page->index and page->mapping, needed for
  memory error handling, when downgrading a PMD mapping/entry to PTE size.

----------------------------------------------------------------
Jan Kara (1):
      dax: Fix xarray entry association for mixed mappings

 fs/dax.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
