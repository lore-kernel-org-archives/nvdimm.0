Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E43FA201B0442
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 12:32:04 -0800 (PST)
Subject: [PATCH v2] nfit/ars: Allow root to busy-poll the ARS state machine
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 12:19:26 -0800
Message-ID: <155017550946.954637.8586902409974005660.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155017502147.944049.2893295352368862579.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155017502147.944049.2893295352368862579.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Change since v1: Use mod_delayed_work() instead of queue_delayed_work()
to modify the timeout for existing work.

 drivers/acpi/nfit/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 934be96dc149..b1ab593a808a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1328,6 +1328,12 @@ static ssize_t scrub_show(struct device *dev,
 		rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
 				acpi_desc->scrub_busy
 				&& !acpi_desc->cancel ? "+\n" : "\n");
+		/* Allow an admin to poll the busy state at a higher rate */
+		if (acpi_desc->scrub_busy && !acpi_desc->cancel
+				&& capable(CAP_SYS_RAWIO)) {
+			acpi_desc->scrub_tmo = 1;
+			mod_delayed_work(nfit_wq, &acpi_desc->dwork, HZ);
+		}
 		mutex_unlock(&acpi_desc->init_mutex);
 	}
 	device_unlock(dev);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
