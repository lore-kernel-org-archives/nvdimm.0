Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 12/24] memconsole: fix __iomem mishandling,
 switch to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:54:45 -0400
Message-ID: <20150730165445.33962.95437.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, mcgrof@suse.com, linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

The memconsole driver is not using proper accessors for __iomem.  Switch
to memremap to fix this issue, and this also prepares the driver for the
removal of ioremap_cache.

Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/firmware/google/memconsole.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/google/memconsole.c b/drivers/firmware/google/memconsole.c
index 2f569aaed4c7..fd5041716860 100644
--- a/drivers/firmware/google/memconsole.c
+++ b/drivers/firmware/google/memconsole.c
@@ -52,14 +52,15 @@ static ssize_t memconsole_read(struct file *filp, struct kobject *kobp,
 	char *memconsole;
 	ssize_t ret;
 
-	memconsole = ioremap_cache(memconsole_baseaddr, memconsole_length);
+	memconsole = memremap(memconsole_baseaddr, memconsole_length,
+			MEMREMAP_WB);
 	if (!memconsole) {
-		pr_err("memconsole: ioremap_cache failed\n");
+		pr_err("memconsole: memremap failed\n");
 		return -ENOMEM;
 	}
 	ret = memory_read_from_buffer(buf, count, &pos, memconsole,
 				      memconsole_length);
-	iounmap(memconsole);
+	memunmap(memconsole);
 	return ret;
 }
 

