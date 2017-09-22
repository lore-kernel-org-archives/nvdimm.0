Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE2C621E43B61
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 00:44:45 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 3C9D6AC02D9
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 16:47:47 +0900 (JST)
Date: Fri, 22 Sep 2017 16:47:40 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH v4 2/3] acpi nfit: Enable to show what feature is supported
 via ND_CMD_CALL for nfit_test
In-Reply-To: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
References: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170922164736.4A3B.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Though nfit_test need to show what feature is supported via ND_CMD_CALL on
device/nfit/dsm_mask, currently there is no way to tell it.
This patch makes to enable it.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 drivers/acpi/nfit/core.c | 1 +
 drivers/acpi/nfit/nfit.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 42221e7..f952508 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1645,6 +1645,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	int i;
 
 	nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
+	nd_desc->bus_dsm_mask = acpi_desc->bus_nfit_cmd_force_en;
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev)
 		return;
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 54292db..f2c6380 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -167,6 +167,7 @@ struct acpi_nfit_desc {
 	unsigned int init_complete:1;
 	unsigned long dimm_cmd_force_en;
 	unsigned long bus_cmd_force_en;
+	unsigned long bus_nfit_cmd_force_en;
 	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
 			void *iobuf, u64 len, int rw);
 };



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
