Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A56AC21A08D63
 for <linux-nvdimm@lists.01.org>; Tue, 13 Jun 2017 08:26:19 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] ndctl, completion: show idle namespaces for 'destroy'
Date: Tue, 13 Jun 2017 09:25:57 -0600
Message-Id: <20170613152557.26673-1-vishal.l.verma@intel.com>
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

The canonical way to destroy a namespace is to first disable it, then
destroy it. Thus typically, namespaces about to be destroyed will be
'idle'. Enable idle namespaces for completion of destroy-namespace.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index 076423f..fd560cb 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -203,7 +203,7 @@ __ndctl_comp_non_option_args()
 	disable-namespace)
 		;&
 	destroy-namespace)
-		opts="$(__ndctl_get_ns) all"
+		opts="$(__ndctl_get_ns -i) all"
 		;;
 	check-namespace)
 		opts="$(__ndctl_get_ns -i) all"
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
