Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id EA4211A1EF0
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 17:54:35 -0700 (PDT)
Subject: [PATCH] libnvdimm: fix smart data retrieval
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 17:53:44 -0700
Message-ID: <20160407005344.30117.84197.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

It appears that smart data retrieval has been broken the since the
initial implementation.  Fix the payload size to be 128-bytes per the
specification.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index fc82743aefb6..19f822d7f652 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -407,7 +407,7 @@ static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
 	[ND_CMD_IMPLEMENTED] = { },
 	[ND_CMD_SMART] = {
 		.out_num = 2,
-		.out_sizes = { 4, 8, },
+		.out_sizes = { 4, 128, },
 	},
 	[ND_CMD_SMART_THRESHOLD] = {
 		.out_num = 2,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
