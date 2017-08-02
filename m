Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3B2A21E1DAE1
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 11:02:18 -0700 (PDT)
Subject: [PATCH v3 1/2] dax: introduce CONFIG_DAX_DRIVER
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 02 Aug 2017 10:58:04 -0700
Message-ID: <150169668471.39569.16909537840684693909.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In support of allowing device-mapper to compile out idle/dead code when
there are no dax providers in the system, introduce the DAX_DRIVER
symbol. This is selected by all leaf drivers that device-mapper might be
layered on top. This allows device-mapper to 'select DAX', i.e. upgrade
it from DAX=m to DAX=y, when a provider is present.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/platforms/Kconfig |    1 +
 drivers/block/Kconfig          |    1 +
 drivers/dax/Kconfig            |    4 +++-
 drivers/nvdimm/Kconfig         |    1 +
 drivers/s390/block/Kconfig     |    1 +
 5 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 4fd64d3f5c44..4561340c1f92 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -296,6 +296,7 @@ config AXON_RAM
 	tristate "Axon DDR2 memory device driver"
 	depends on PPC_IBM_CELL_BLADE && BLOCK
 	select DAX
+	select DAX_DRIVER
 	default m
 	help
 	  It registers one block device per Axon's DDR2 memory bank found
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 8ddc98279c8f..e1b6f4d2a716 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -324,6 +324,7 @@ config BLK_DEV_SX8
 config BLK_DEV_RAM
 	tristate "RAM block device support"
 	select DAX if BLK_DEV_RAM_DAX
+	select DAX_DRIVER if BLK_DEV_RAM_DAX
 	---help---
 	  Saying Y here will allow you to use a portion of your RAM memory as
 	  a block device, so that you can make file systems on it, read and
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index b79aa8f7a497..9bf940eb9c06 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,3 +1,6 @@
+config DAX_DRIVER
+	bool
+
 menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
 	select SRCU
@@ -16,7 +19,6 @@ config DEV_DAX
 	  baseline memory pool.  Mappings of a /dev/daxX.Y device impose
 	  restrictions that make the mapping behavior deterministic.
 
-
 config DEV_DAX_PMEM
 	tristate "PMEM DAX: direct access to persistent memory"
 	depends on LIBNVDIMM && NVDIMM_DAX && DEV_DAX
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5bdd499b5f4f..afe4018d76cf 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -21,6 +21,7 @@ config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
 	select DAX
+	select DAX_DRIVER
 	select ND_BTT if BTT
 	select ND_PFN if NVDIMM_PFN
 	help
diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
index 31f014b57bfc..3f563f2f33d6 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -15,6 +15,7 @@ config BLK_DEV_XPRAM
 config DCSSBLK
 	def_tristate m
 	select DAX
+	select DAX_DRIVER
 	prompt "DCSSBLK support"
 	depends on S390 && BLOCK
 	help

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
