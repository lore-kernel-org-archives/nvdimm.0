Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH] libnvdimm, nfit: Use ACPI_SIG_NFIT instead of hard coded string
Date: Thu, 21 Jan 2016 20:32:10 +0800
Message-Id: <1453379530-21727-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

It's minor but that's still better to use ACPI_SIG_NFIT instead of hard
coded string.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/acpi/nfit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index aa45d48..9fb1a6a 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1739,7 +1739,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	acpi_size sz;
 	int rc;
 
-	status = acpi_get_table_with_size("NFIT", 0, &tbl, &sz);
+	status = acpi_get_table_with_size(ACPI_SIG_NFIT, 0, &tbl, &sz);
 	if (ACPI_FAILURE(status)) {
 		/* This is ok, we could have an nvdimm hotplugged later */
 		dev_dbg(dev, "failed to find NFIT at startup\n");
-- 
2.1.4
