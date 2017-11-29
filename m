Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B41E8221660EF
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 11:03:45 -0800 (PST)
Subject: [PATCH v6 0/2] dax, dm: stop requiring dax for device-mapper
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Nov 2017 10:59:55 -0800
Message-ID: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v5 [1]:
* Make DAX_DRIVER select DAX to simplify the Kconfig dependencies
  (Michael)
* Rebase on 4.15-rc1 and add new IS_ENABLED(CONFIG_DAX_DRIVER) checks in
  drivers/md/dm-log-writes.c.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-September/012569.html

---

Hi Mike,

Bart points out that the DAX core is unconditionally enabled if
device-mapper is enabled. Add some config machinery and some
stub/static-inline routines to allow dax infrastructure to be deleted
from device-mapper at compile time.

---

Dan Williams (2):
      dax: introduce CONFIG_DAX_DRIVER
      dm: allow device-mapper to operate without dax support


 arch/powerpc/platforms/Kconfig |    2 -
 drivers/dax/Kconfig            |    5 ++
 drivers/md/Kconfig             |    1 
 drivers/md/dm-linear.c         |    6 +++
 drivers/md/dm-log-writes.c     |   95 +++++++++++++++++++++-------------------
 drivers/md/dm-stripe.c         |    6 +++
 drivers/md/dm.c                |   10 +++-
 drivers/nvdimm/Kconfig         |    2 -
 drivers/s390/block/Kconfig     |    2 -
 include/linux/dax.h            |   30 ++++++++++---
 10 files changed, 99 insertions(+), 60 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
