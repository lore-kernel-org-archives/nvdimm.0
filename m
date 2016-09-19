Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 627871A1DED
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 15:07:47 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: fix disable-dimm error message
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 15:04:43 -0700
Message-ID: <147432268390.5808.7591882075989403277.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

cmd_disable_dimm() expects a negative number for an error, otherwise we
end up reporting:

    # ndctl disable-dimm nmem1
    nmem1 is active, skipping...
    disabled 16 dimms

...instead of:

    # ndctl disable-dimm nmem1
    nmem1 is active, skipping...
    error disabling dimms: Device or resource busy

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xable-dimm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/builtin-xable-dimm.c b/ndctl/builtin-xable-dimm.c
index 4bdbc7f8eea3..f0d298837aeb 100644
--- a/ndctl/builtin-xable-dimm.c
+++ b/ndctl/builtin-xable-dimm.c
@@ -67,7 +67,7 @@ static int do_xable_dimm(const char *dimm_arg,
 
 	rc = success;
 	if (!success && skip)
-		rc = EBUSY;
+		rc = -EBUSY;
  out:
 	dimm_bus = NULL;
 	return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
