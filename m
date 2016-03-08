Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id CD8891A1F37
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:23 -0800 (PST)
Subject: [ndctl PATCH 3/8] ndctl: refresh dynamic pfn attributes from a
 duplicate
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:36:43 -0800
Message-ID: <20160308233643.18628.30522.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
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

When we find a duplicate of an existing ndctl_pfn instance in add_pfn,
it may have a more up to date value of the 'size' or 'resource' because
those values are only valid while the instance is active.  Copy those
updates over before throwing away the duplicate.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libndctl.c b/lib/libndctl.c
index 91e855bf525a..dde3ef5b72e4 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -3880,6 +3880,8 @@ static int add_pfn(void *parent, int id, const char *pfn_base)
 	free(path);
 	ndctl_pfn_foreach(region, pfn_dup)
 		if (pfn->id == pfn_dup->id) {
+			pfn_dup->resource = pfn->resource;
+			pfn_dup->size = pfn->size;
 			free_pfn(pfn, NULL);
 			return 1;
 		}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
