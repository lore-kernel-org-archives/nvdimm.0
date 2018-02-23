Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5167C220F33CE
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:08:14 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/2] libnvdimm,
 label: change min label storage size per UEFI 2.7
Date: Fri, 23 Feb 2018 14:59:21 -0700
Message-Id: <20180223215922.25415-2-toshi.kani@hpe.com>
In-Reply-To: <20180223215922.25415-1-toshi.kani@hpe.com>
References: <20180223215922.25415-1-toshi.kani@hpe.com>
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

UEFI 2.7 defines in page 758 that:

  Initial Label Storage Area Configuration
     :
  The minimum size of the Label Storage Area is large enough to
  hold 2 index blocks and 2 labels.

The mininum index block size is 256 bytes, and the minimum label size
is also 256 bytes.

Change ND_LABEL_MIN_SIZE to (256 * 4) so that NVDIMM devices with
the minimum label storage area do not fail with the size check in
nvdimm_init_config_data().

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 1ebf4d3d01ba..18bbe183b3a9 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -33,7 +33,7 @@ enum {
 	BTTINFO_UUID_LEN = 16,
 	BTTINFO_FLAG_ERROR = 0x1,    /* error state (read-only) */
 	BTTINFO_MAJOR_VERSION = 1,
-	ND_LABEL_MIN_SIZE = 512 * 129, /* see sizeof_namespace_index() */
+	ND_LABEL_MIN_SIZE = 256 * 4, /* see sizeof_namespace_index() */
 	ND_LABEL_ID_SIZE = 50,
 	ND_NSINDEX_INIT = 0x1,
 };
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
