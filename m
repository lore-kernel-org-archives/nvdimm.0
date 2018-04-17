Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFB6F2263DD6D
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 17:39:47 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, bash-completion: add completion for {start,
 wait}-scrub commands
Date: Mon, 16 Apr 2018 18:39:28 -0600
Message-Id: <20180417003928.23709-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Complete the new ARS control commands with the available buses (and
'all') for non-option arguments.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/contrib/ndctl b/contrib/ndctl
index a3a8675..7a99baf 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -290,6 +290,11 @@ __ndctl_comp_non_option_args()
 	inject-smart)
 		opts="$(__ndctl_get_dimms -i)"
 		;;
+	wait-scrub)
+		;&
+	start-scrub)
+		opts="$(__ndctl_get_buses) all"
+		;;
 	*)
 		return
 		;;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
