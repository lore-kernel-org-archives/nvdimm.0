Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A92D5221660EF
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 11:03:51 -0800 (PST)
Subject: [PATCH v6 1/2] dax: introduce CONFIG_DAX_DRIVER
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Nov 2017 11:00:00 -0800
Message-ID: <151198200084.7051.8668235721724414674.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

In support of allowing device-mapper to compile out idle/dead code when
there are no dax providers in the system, introduce the DAX_DRIVER
symbol. This is selected by all leaf drivers that device-mapper might be
layered on top. This allows device-mapper to conditionally 'select DAX'
only when a provider is present.

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
 arch/powerpc/platforms/Kconfig |    2 +-
 drivers/dax/Kconfig            |    5 ++++-
 drivers/nvdimm/Kconfig         |    2 +-
 drivers/s390/block/Kconfig     |    2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 5a96a2763e4a..1c14b943d9ff 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -296,7 +296,7 @@ config CPM2
 config AXON_RAM
 	tristate "Axon DDR2 memory device driver"
 	depends on PPC_IBM_CELL_BLADE && BLOCK
-	select DAX
+	select DAX_DRIVER
 	default m
 	help
 	  It registers one block device per Axon's DDR2 memory bank found
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index b79aa8f7a497..e0700bf4893a 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,3 +1,7 @@
+config DAX_DRIVER
+	select DAX
+	bool
+
 menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
 	select SRCU
@@ -16,7 +20,6 @@ config DEV_DAX
 	  baseline memory pool.  Mappings of a /dev/daxX.Y device impose
 	  restrictions that make the mapping behavior deterministic.
 
-
 config DEV_DAX_PMEM
 	tristate "PMEM DAX: direct access to persistent memory"
 	depends on LIBNVDIMM && NVDIMM_DAX && DEV_DAX
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index a65f2e1d9f53..40cbdb16e23e 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -20,7 +20,7 @@ if LIBNVDIMM
 config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
-	select DAX
+	select DAX_DRIVER
 	select ND_BTT if BTT
 	select ND_PFN if NVDIMM_PFN
 	help
diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
index 31f014b57bfc..5c4d6f8ff0e5 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -14,7 +14,7 @@ config BLK_DEV_XPRAM
 
 config DCSSBLK
 	def_tristate m
-	select DAX
+	select DAX_DRIVER
 	prompt "DCSSBLK support"
 	depends on S390 && BLOCK
 	help

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
