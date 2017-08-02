Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BE1A21AEB0A0
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 11:02:18 -0700 (PDT)
Subject: [PATCH v3 0/2] dax, dm: stop requiring dax for device-mapper
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 02 Aug 2017 10:57:59 -0700
Message-ID: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: snitzer@redhat.com
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:
* rebase on -next to integrate with commit 273752c9ff03 "dm, dax: Make
  sure dm_dax_flush() is called if device supports it" (kbuild robot)
* fix CONFIG_DAX dependencies to upgrade CONFIG_DAX=m to CONFIG_DAX=y
  (kbuild robot)

[1]: https://www.spinics.net/lists/kernel/msg2570522.html

---

Bart points out that the DAX core is unconditionally enabled if
device-mapper is enabled. Add some config machinery and some
stub-static-inline routines to allow dax infrastructure to be deleted
from device-mapper at compile time.

Since this depends on commit 273752c9ff03 that's already in -next, this
should go through the device-mapper tree.
---

Dan Williams (2):
      dax: introduce CONFIG_DAX_DRIVER
      dm: allow device-mapper to operate without dax support


 arch/powerpc/platforms/Kconfig |    1 +
 drivers/block/Kconfig          |    1 +
 drivers/dax/Kconfig            |    4 +++-
 drivers/md/Kconfig             |    2 +-
 drivers/md/dm-linear.c         |    6 ++++++
 drivers/md/dm-stripe.c         |    6 ++++++
 drivers/md/dm.c                |   10 ++++++----
 drivers/nvdimm/Kconfig         |    1 +
 drivers/s390/block/Kconfig     |    1 +
 include/linux/dax.h            |   30 ++++++++++++++++++++++++------
 10 files changed, 50 insertions(+), 12 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
