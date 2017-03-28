Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1380F21DFA7BA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 16:19:28 -0700 (PDT)
Subject: [ndctl PATCH 5/6] ndctl,
 dimm: fix count display in the presence of errors
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 16:14:17 -0700
Message-ID: <149074285782.18735.18215464978773558065.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The dimm commands return zero when some operations succeed, return the
count separately from the error code.

    Before:
    # ndctl zero-labels all
    zeroed 0 nmem

    After:
    # ndctl zero-labels all
    zeroed 6 nmems

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index b20a84911489..4d25417fb2ae 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -952,9 +952,9 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	 * count if some actions succeeded, 0 if none were attempted,
 	 * negative error code otherwise.
 	 */
-	if (rc < 0)
-		return rc;
-	return count;
+	if (count > 0)
+		return count;
+	return rc;
 }
 
 int cmd_write_labels(int argc, const char **argv, void *ctx)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
