Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB13F225B1
	for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 12:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemi500025.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SB72Q0wsVzrRg3;
	Thu, 19 Oct 2023 20:54:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 19 Oct 2023 20:56:50 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <michal.wilczynski@intel.com>, <rafael@kernel.org>
CC: <linuxarm@huawei.com>, <linux-acpi@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] Install Notify() handler before getting NFIT table
Date: Thu, 19 Oct 2023 21:01:21 +0800
Message-ID: <1697720481-150095-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500025.china.huawei.com (7.221.188.170)
X-CFilter-Loop: Reflected

From: Xiang Chen <chenxiang66@hisilicon.com>

If there is no NFIT at startup, it will return 0 immediately in function 
acpi_nfit_add() and will not install Notify() handler. If hotplugging 
a nvdimm device later, it will not be identified as there is no Notify() 
handler.
So move handler installing before getting NFI table in function 
acpi_nfit_add() to avoid above issue.

Fixes: dcca12ab62a2 ("ACPI: NFIT: Install Notify() handler directly")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/acpi/nfit/core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 3826f49..9923855 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3339,6 +3339,16 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	acpi_size sz;
 	int rc = 0;
 
+	rc = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
+					     acpi_nfit_notify, adev);
+	if (rc)
+		return rc;
+
+	rc = devm_add_action_or_reset(dev, acpi_nfit_remove_notify_handler,
+					adev);
+	if (rc)
+		return rc;
+
 	status = acpi_get_table(ACPI_SIG_NFIT, 0, &tbl);
 	if (ACPI_FAILURE(status)) {
 		/* The NVDIMM root device allows OS to trigger enumeration of
@@ -3386,17 +3396,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	if (rc)
 		return rc;
 
-	rc = devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
-	if (rc)
-		return rc;
-
-	rc = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-					     acpi_nfit_notify, adev);
-	if (rc)
-		return rc;
-
-	return devm_add_action_or_reset(dev, acpi_nfit_remove_notify_handler,
-					adev);
+	return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
 }
 
 static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
-- 
2.8.1

