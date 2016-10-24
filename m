Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E47C91A1E3A
 for <linux-nvdimm@lists.01.org>; Mon, 24 Oct 2016 14:59:12 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [4.4, 4.7 stable PATCH] acpi,
 nfit: check for the correct event code in notifications
Date: Mon, 24 Oct 2016 15:58:06 -0600
Message-Id: <1477346286-27012-1-git-send-email-vishal.l.verma@intel.com>
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
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

commit c09f12186d6b03b798832d95289af76495990192 upstream.

Commit 209851649dc4 "acpi: nfit: Add support for hot-add" added
support for _FIT notifications, but it neglected to verify the
notification event code matches the one in the ACPI spec for
"NFIT Update". Currently there is only one code in the spec, but
once additional codes are added, older kernels (without this fix)
will misbehave by assuming all event notifications are for an
NFIT Update.

Fixes: 209851649dc4 ("acpi: nfit: Add support for hot-add")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

Note that the patch doesn't directly apply to stable-4.4, but using
'git am -3' works. Is this sufficient, or should I send a sepatate
patch for 4.4?

 drivers/acpi/nfit.c | 3 +++
 drivers/acpi/nfit.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 375c10f..a071fe4 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -2605,6 +2605,9 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 
 	dev_dbg(dev, "%s: event: %d\n", __func__, event);
 
+	if (event != NFIT_NOTIFY_UPDATE)
+		return;
+
 	device_lock(dev);
 	if (!dev->driver) {
 		/* dev->driver may be null if we're being removed */
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 02b9ea1..e602fd2 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -73,6 +73,10 @@ enum {
 	NFIT_ARS_TIMEOUT = 90,
 };
 
+enum nfit_root_notifiers {
+	NFIT_NOTIFY_UPDATE = 0x80,
+};
+
 struct nfit_spa {
 	struct acpi_nfit_system_address *spa;
 	struct list_head list;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
