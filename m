Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8821B21BADAD8
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 09:08:23 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 0/7] Enable DSM pass thru for root functions
Date: Fri, 30 Jun 2017 10:09:33 -0600
Message-Id: <cover.1498810220.git.jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The ACPI 6.2 spec added NVDIMM root DSM functions that managibility
and test software need to call.

This patch set enables the calling of root functions DSMs via the
pass thru mechanism.

Changes v4
----------
1. Minor refactoring of patch sequence.

Changes v3
----------
1. Fix checkpatch warnings

2. modify bus_dsm_mask_show to display name "dsm_mask" in sysfs.

3. modified submittal comments.

Changes v2
----------
1. Add bus_dsm_mask to filter root pass thru calls.

2. Add bus_dsm_mask_show to display bus_dsm_mask in sysfs

3. Extend override_dsm_mask to be used for bus_dms_mask also.




Details v1
----------

__nd_ioctl:
Check pass thru functions against nd_cmd_clear_to_send.

acpi_nfit_init_dsms:
Set additional bits in cmd_mask for new functions.

ndctl.h:
Define data structure for the new 6.2 functions.

Jerry Hoemann (6):
  libnvdimm: passthru functions clear to send
  acpi, nfit: Enable DSM pass thru for root functions.
  libnvdimm, acpi, nfit: Add bus level dsm mask for pass thru.
  acpi, nfit: Show bus_dsm_mask in sysfs
  libnvdimm: New ACPI 6.2 DSM functions
  nfit allow override of root dsm mask

 drivers/acpi/nfit/core.c   | 23 +++++++++++++++++++++++
 drivers/nvdimm/bus.c       |  4 +++-
 include/linux/libnvdimm.h  |  1 +
 include/uapi/linux/ndctl.h | 41 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 67 insertions(+), 2 deletions(-)

-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
