Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7E1A21AE30D1
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 10:03:51 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH 0/3] Enable DSM pass thru for root functions
Date: Wed,  7 Jun 2017 11:04:54 -0600
Message-Id: <cover.1496852665.git.jerry.hoemann@hpe.com>
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

The new ACPI 6.2 spec has added new NVDIMM root DSM functions
that managibility and test software needs to call.

This patch set enables the calling of root functions DSMs via the
pass thru mechanism.

Details

__nd_ioctl:
Check pass thru functions against nd_cmd_clear_to_send.

acpi_nfit_init_dsms:
Set additional bits in cmd_mask for new functions.

ndctl.h:
Define data structure for the new 6.2 functions.
Add new function names to nvdimm_bus_cmd_name.



Jerry Hoemann (3):
  libnvdimm: passthru functions clear to send
  acpi, nfit: Enable DSM pass thru for root functions.
  libnvdimm: New ACPI 6.2 DSM functions

 drivers/acpi/nfit/core.c   |  3 ++-
 drivers/nvdimm/bus.c       |  4 +++-
 include/uapi/linux/ndctl.h | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 3 deletions(-)

-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
