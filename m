Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A26D2211F9D69
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 13:32:05 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] libnvdimm/label: Check for a disabled nmem when deleting
 labels
Date: Mon, 15 Apr 2019 16:32:03 -0400
Message-ID: <x49bm17qabg.fsf@segfault.boston.devel.redhat.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

We ran into a situation where one dimm's label area was corrupt (it had
multiple entries for the same DPA), and so that nmem was disabled.  The
region as a whole was enabled, though.  In this case, there was a single
namespace that showed up as disabled.  Trying to reconfigure that
namespace resulted in the following panic:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
[  108.386384] #PF error: [normal kernel read fault]
[  108.391090] PGD 11c3eae5067 P4D 11c3eae5067 PUD 11c262c9067 PMD 0 
[  108.397267] Oops: 0000 [#1] SMP NOPTI
[  108.400936] CPU: 39 PID: 3838 Comm: ndctl Not tainted 5.1.0-rc5 #1
[  108.407114] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS SE5C620.86B.0D.01.0286.011120190816 01/11/2019
[  108.417200] RIP: 0010:preamble_next+0xd/0x60 [libnvdimm]
...

The problem is that there is no driver data associated with the
nd_mapping in this case.  Check for that.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Zhang Yi <yizhan@redhat.com>

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index f3d753d3169c..da1f28d8c9e6 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1217,7 +1217,7 @@ static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
 		return 0;
 
 	/* no index || no labels == nothing to delete */
-	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+	if (!ndd || !preamble_next(ndd, &nsindex, &free, &nslot))
 		return 0;
 
 	mutex_lock(&nd_mapping->lock);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
