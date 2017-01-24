Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE4C281F07
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 11:24:20 -0800 (PST)
Received: by mail-pf0-x242.google.com with SMTP id e4so12627999pfg.0
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 11:24:20 -0800 (PST)
From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] nvdimm: constify device_type structures
Date: Wed, 25 Jan 2017 00:54:07 +0530
Message-Id: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: julia.lawall@lip6.fr, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Declare device_type structure as const as it is only stored in the
type field of a device structure. This field is of type const, so add
const to declaration of device_type structure.

File size before:
  text	   data	    bss	    dec	    hex	filename
  19278	   3199	     16	  22493	   57dd	nvdimm/namespace_devs.o

File size after:
  text	   data	    bss	    dec	    hex	filename
  19929	   3160	     16	  23105	   5a41	nvdimm/namespace_devs.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/nvdimm/namespace_devs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 6307088..b8c40b8 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -52,17 +52,17 @@ static void namespace_blk_release(struct device *dev)
 	kfree(nsblk);
 }
 
-static struct device_type namespace_io_device_type = {
+static const struct device_type namespace_io_device_type = {
 	.name = "nd_namespace_io",
 	.release = namespace_io_release,
 };
 
-static struct device_type namespace_pmem_device_type = {
+static const struct device_type namespace_pmem_device_type = {
 	.name = "nd_namespace_pmem",
 	.release = namespace_pmem_release,
 };
 
-static struct device_type namespace_blk_device_type = {
+static const struct device_type namespace_blk_device_type = {
 	.name = "nd_namespace_blk",
 	.release = namespace_blk_release,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
