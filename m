Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D1F4212DC5B8
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jul 2019 15:00:17 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v7 12/13] contrib/ndctl: add bash-completion for the new
 daxctl commands
Date: Wed, 24 Jul 2019 15:57:40 -0600
Message-Id: <20190724215741.18556-13-vishal.l.verma@intel.com>
In-Reply-To: <20190724215741.18556-1-vishal.l.verma@intel.com>
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>
List-ID: <linux-nvdimm@lists.01.org>

Add bash completion helpers for the new daxctl-reconfigure-device,
daxctl-online-memory, and daxctl-offline-memory commands.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index cacee2d..680fe6a 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -547,7 +547,7 @@ __daxctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--region|--dev) ]]; then
+		if [[ "$cword" == @(--region|--dev|--mode) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -572,6 +572,9 @@ __daxctl_comp_options()
 		--dev)
 			opts="$(__daxctl_get_devs -i)"
 			;;
+		--mode)
+			opts="system-ram devdax"
+			;;
 		*)
 			return
 			;;
@@ -582,8 +585,23 @@ __daxctl_comp_options()
 
 __daxctl_comp_non_option_args()
 {
-	# there aren't any commands that accept non option arguments yet
-	return
+	local subcmd=$1
+	local cur=$2
+	local opts
+
+	case $subcmd in
+	reconfigure-device)
+		;&
+	online-memory)
+		;&
+	offline-memory)
+		opts="$(__daxctl_get_devs -i) all"
+		;;
+	*)
+		return
+		;;
+	esac
+	__daxctlcomp "$opts" "$cur"
 }
 
 __daxctl_main()
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
