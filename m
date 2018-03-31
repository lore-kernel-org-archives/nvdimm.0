Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D48DA2095744B
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 21:12:48 -0700 (PDT)
Subject: [PATCH v8 08/18] dax: introduce CONFIG_DAX_DRIVER
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:02:52 -0700
Message-ID: <152246897244.36038.14718237765737542802.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: jack@suse.cz, snitzer@redhat.com, Heiko Carstens <heiko.carstens@de.ibm.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In support of allowing device-mapper to compile out idle/dead code when
there are no dax providers in the system, introduce the DAX_DRIVER
symbol. This is selected by all leaf drivers that device-mapper might be
layered on top. This allows device-mapper to conditionally 'select DAX'
only when a provider is present.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig        |    5 ++++-
 drivers/nvdimm/Kconfig     |    2 +-
 drivers/s390/block/Kconfig |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

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
index 1444333210c7..9ac7574e3cfb 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -15,8 +15,8 @@ config BLK_DEV_XPRAM
 
 config DCSSBLK
 	def_tristate m
-	select DAX
 	select FS_DAX_LIMITED
+	select DAX_DRIVER
 	prompt "DCSSBLK support"
 	depends on S390 && BLOCK
 	help

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
