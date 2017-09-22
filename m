Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84BD720945B70
 for <linux-nvdimm@lists.01.org>; Thu, 21 Sep 2017 21:30:04 -0700 (PDT)
Subject: [PATCH v4 0/2] dax, dm: stop requiring dax for device-mapper
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Sep 2017 21:26:47 -0700
Message-ID: <150605440733.23744.13594748177867932146.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3 [1]:
* rebase on 4.14-rc1
* rewrite the changelog of patch2 to drop broken references to the
  "built-in portion of device-mapper" (Mike)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-August/011545.html

---

Bart points out that the DAX core is unconditionally enabled if
device-mapper is enabled. Add some config machinery and stub routines to
allow device-mapper to build and run with CONFIG_DAX=n.

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
