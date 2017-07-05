Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20B9920958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 13:53:28 -0700 (PDT)
Subject: [ndctl PATCH 1/6] ndctl, test: push btt-check test back to 4.14
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:48:40 -0700
Message-ID: <149928772041.25150.17654067912742762665.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Until the kernel is able to issue clear-error _DSM routines from outside
atomic context the btt error clearing assumptions in this test will
continue to be invalid.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/btt-check.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/btt-check.sh b/test/btt-check.sh
index 5ec224b1d582..06d0f35f6c5d 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -54,7 +54,7 @@ check_min_kver()
 	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
 }
 
-check_min_kver "4.13" || { echo "kernel $KVER may not support badblocks clearing on pmem via btt"; exit $rc; }
+check_min_kver "4.14" || { echo "kernel $KVER may not support badblocks clearing on pmem via btt"; exit $rc; }
 
 create()
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
