Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 0709A1A1E00
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 12:29:11 -0700 (PDT)
Date: Mon, 27 Jun 2016 13:28:12 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 4/9] ndctl, list: allow limiting namespace listing
Message-ID: <20160627192812.GD20767@omniknight.lm.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146698348937.40541.3876891950806088867.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146698348937.40541.3876891950806088867.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 06/26, Dan Williams wrote:
> In addition to filtering by bus, dimm, and/or region, introduce
> -n/--namespace to limit the listing to the given namespace.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/ndctl-list.txt |    6 ++++++
>  ndctl/builtin-list.c         |    6 ++++++
>  util/filter.c                |   21 +++++++++++++++++++++
>  util/filter.h                |    2 ++
>  4 files changed, 35 insertions(+)
> 
This needs a bash completion update as follows (feel free to squash in
or keep separatley..):

>From b6d09ff03b7ed16efdc4169aec0442d5c32053bd Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 27 Jun 2016 13:22:58 -0600
Subject: [PATCH] ndctl: bash completion updates for the --namespace= filter

Add completion for the new --namespace= filter.
This will list idle namespaces for completion. It could possibly be made
smarter by checking if a '--idle' or '-i' has been specified on the
command line so far, but maybe that's a bit confusing for the user?

For now, enable the simpler path of listing everything for completion.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index 5a7455f..b7a82fc 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -146,6 +146,9 @@ __ndctl_comp_options()
 		--dimm)
 			opts=$(__ndctl_get_dimms)
 			;;
+		--namespace)
+			opts=$(__ndctl_get_ns -i)
+			;;
 		--reconfig)
 			# It is ok to reconfig disabled namespaces
 			opts=$(__ndctl_get_ns -i)
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
