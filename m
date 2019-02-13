Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F73A2194EB76
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 18:34:57 -0800 (PST)
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 052/105] acpi/nfit: Fix race accessing memdev in
 nfit_get_smbios_id()
Date: Tue, 12 Feb 2019 21:32:43 -0500
Message-Id: <20190213023336.19019-52-sashal@kernel.org>
In-Reply-To: <20190213023336.19019-1-sashal@kernel.org>
References: <20190213023336.19019-1-sashal@kernel.org>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 0919871ac37fdcf46c7657da0f1742efe096b399 ]

Possible race accessing memdev structures after dropping the
mutex. Dan Williams says this could race against another thread
that is doing:

 # echo "ACPI0012:00" > /sys/bus/acpi/drivers/nfit/unbind

Reported-by: Jane Chu <jane.chu@oracle.com>
Fixes: 23222f8f8dce ("acpi, nfit: Add function to look up nvdimm...")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 8535e7999769..2a2d7ec77252 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -724,6 +724,7 @@ int nfit_get_smbios_id(u32 device_handle, u16 *flags)
 	struct acpi_nfit_memory_map *memdev;
 	struct acpi_nfit_desc *acpi_desc;
 	struct nfit_mem *nfit_mem;
+	u16 physical_id;
 
 	mutex_lock(&acpi_desc_lock);
 	list_for_each_entry(acpi_desc, &acpi_descs, list) {
@@ -731,10 +732,11 @@ int nfit_get_smbios_id(u32 device_handle, u16 *flags)
 		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
 			memdev = __to_nfit_memdev(nfit_mem);
 			if (memdev->device_handle == device_handle) {
+				*flags = memdev->flags;
+				physical_id = memdev->physical_id;
 				mutex_unlock(&acpi_desc->init_mutex);
 				mutex_unlock(&acpi_desc_lock);
-				*flags = memdev->flags;
-				return memdev->physical_id;
+				return physical_id;
 			}
 		}
 		mutex_unlock(&acpi_desc->init_mutex);
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
