Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BCE6211EC670
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 12:34:45 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id v10so14860482oib.1
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 12:34:45 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Apr 2019 12:34:33 -0700
Message-ID: <CAPcyv4g97hof42jNAx__GpZ9ATPLv4J2AFo56nRzH-whCj7vgg@mail.gmail.com>
Subject: [GIT PULL] Fileystem-DAX fix for v5.1-rc6
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
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/fsdax-fix-5.1-rc6

...to receive a single filesystem-dax fix. It has been lingering in
-next for a long while and there are no other fsdax fixes on the
horizon.

---

The following changes since commit e4b3448bc346fedf36db64124a664a959995b085:

  dax: Flush partial PMDs correctly (2019-03-01 17:24:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/fsdax-fix-5.1-rc6

for you to fetch changes up to 11cf9d863dcb583345723b0ed72173348761e9c0:

  fs/dax: Deposit pagetable even when installing zero page (2019-03-13
13:58:46 -0700)

----------------------------------------------------------------
fsdax fix 5.1-rc6

- Avoid a crash scenario with architectures like powerpc that require
  'pgtable_deposit' for the zero page.

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      fs/dax: Deposit pagetable even when installing zero page

 fs/dax.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
