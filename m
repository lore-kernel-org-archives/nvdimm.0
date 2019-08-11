Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1E23212E4B65
 for <linux-nvdimm@lists.01.org>; Sun, 11 Aug 2019 12:03:41 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id r20so1718762ota.5
 for <linux-nvdimm@lists.01.org>; Sun, 11 Aug 2019 12:01:14 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 11 Aug 2019 12:01:02 -0700
Message-ID: <CAPcyv4iaYiXbv2sf-Znn5dYphLKEi77NjafkEzXA2kAEMqyR0w@mail.gmail.com>
Subject: [GIT PULL] dax fixes v5.3-rc4
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
tags/dax-fixes-5.3-rc4

...a filesystem-dax and device-dax fix for v5.3. The filesystem-dax
fix is tagged for stable as the implementation has been mistakenly
throwing away all cow pages on any truncate or hole punch operation as
part of the solution to coordinate device-dma vs truncate to dax
pages. The device-dax change fixes up a regression this cycle from the
introduction of a common 'internal per-cpu-ref' implementation.

The filesystem-dax fix has appeared in -next. The device-dax has not,
but it has been exposed on a kbuild-robot visible branch for the past
few days, and passes the nvdimm unit tests.

---

The following changes since commit e21a712a9685488f5ce80495b37b9fdbe96c230d:

  Linux 5.3-rc3 (2019-08-04 18:40:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/dax-fixes-5.3-rc4

for you to fetch changes up to 06282373ff57a2b82621be4f84f981e1b0a4eb28:

  mm/memremap: Fix reuse of pgmap instances with internal references
(2019-08-09 14:16:15 -0700)

----------------------------------------------------------------
dax fixes v5.3-rc4

- Fix dax_layout_busy_page() to not discard private cow pages of fs/dax
  private mappings.

- Update the memremap_pages core to properly cleanup on behalf of
  internal reference-count users like device-dax.

----------------------------------------------------------------
Dan Williams (1):
      mm/memremap: Fix reuse of pgmap instances with internal references

Vivek Goyal (1):
      dax: dax_layout_busy_page() should not unmap cow pages

 fs/dax.c      | 2 +-
 mm/memremap.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
