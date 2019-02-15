Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17E95202E531F
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 11:56:51 -0800 (PST)
Subject: [PATCH v2 5/6] nfit/ars: Allow root to busy-poll the ARS state machine
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 11:44:13 -0800
Message-ID: <155025985341.1043225.5482732552253707094.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155025982726.1043225.15436410616433285475.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155025982726.1043225.15436410616433285475.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Erwin Tsaur <erwin.tsaur@oracle.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The ARS implementation implements exponential back-off on the poll
interval to prevent high-frequency access to the DIMM / platform
interface. Depending on when the ARS completes the poll interval may
exceed the completion event by minutes. Allow root to reset the timeout
each time it probes the status. A one-second timeout is still enforced,
but root can otherwise can control the poll interval.

Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    8 ++++++++
 drivers/acpi/nfit/nfit.h |    1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 90312892093e..629cf91649d2 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1333,6 +1333,13 @@ static ssize_t scrub_show(struct device *dev,
 	busy = test_bit(ARS_BUSY, &acpi_desc->scrub_flags)
 		&& !test_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
 	rc = sprintf(buf, "%d%s", acpi_desc->scrub_count, busy ? "+\n" : "\n");
+	/* Allow an admin to poll the busy state at a higher rate */
+	if (busy && capable(CAP_SYS_RAWIO) && !test_and_set_bit(ARS_POLL,
+				&acpi_desc->scrub_flags)) {
+		acpi_desc->scrub_tmo = 1;
+		mod_delayed_work(nfit_wq, &acpi_desc->dwork, HZ);
+	}
+
 	mutex_unlock(&acpi_desc->init_mutex);
 	device_unlock(dev);
 	return rc;
@@ -3187,6 +3194,7 @@ static void acpi_nfit_scrub(struct work_struct *work)
 	else
 		notify_ars_done(acpi_desc);
 	memset(acpi_desc->ars_status, 0, acpi_desc->max_ars);
+	clear_bit(ARS_POLL, &acpi_desc->scrub_flags);
 	mutex_unlock(&acpi_desc->init_mutex);
 }
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 897ce10192a0..d14bad687fb8 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -213,6 +213,7 @@ struct nfit_mem {
 enum scrub_flags {
 	ARS_BUSY,
 	ARS_CANCEL,
+	ARS_POLL,
 };
 
 struct acpi_nfit_desc {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
