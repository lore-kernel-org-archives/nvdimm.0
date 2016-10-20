Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD3511A1E31
 for <linux-nvdimm@lists.01.org>; Thu, 20 Oct 2016 12:33:23 -0700 (PDT)
Date: Thu, 20 Oct 2016 13:32:34 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 0/8] dimm label space initialization support
Message-ID: <20161020193231.GA7106@omniknight.lm.intel.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: qemu-devel@nongnu.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 10/19, Dan Williams wrote:
> The 4.9 kernel added support for sub-dividing PMEM.  With this kernel
> patch [1] on top of that baseline, the PMEM-sub-division support can be
> enabled for QEMU-KVM and any other platforms that advertise both un-aliased
> PMEM regions and support for the label DSM commands [2].
> 
> Given this increasing need to perform a label management operation
> across a set of DIMMs this update also adds glob(3) support.  For
> example you can now write commands like:
> 
>     ndctl zero-labels nmem[2-4]
> 
> ...as a shorthand for:
> 
>     ndctl zero-labels nmem2 nmem3 nmem4
> 
> This support extends to all the commands that take an undecorated dimm /
> nmem device as a parameter:
> 
>     disable-dimm
>     enable-dimm
>     read-labels
>     zero-labels
>     init-labels
>     check-labels
> 
> The patch "libndctl: fix error returns for unsigned apis" was something
> noticed while developing "init-labels", but is otherwise unrelated to
> the rest of the set.
> 
> [1]: https://patchwork.kernel.org/patch/9384741/
> [2]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example-V1.2.pdf
> 
> ---
> 
> Dan Williams (8):
>       libndctl: fix error returns for unsigned apis
>       ndctl: consolidate label commands into a single file
>       ndctl: glob support for label commands
>       ndctl: merge {enable,disable}-dimm with label commands
>       libndctl: add ndctl_cmd_cfg_read_get_size()
>       ndctl: provide a read_labels() helper
>       ndctl: init-labels command
>       ndctl: check-labels command
>

Hi Dan,

Here is the bash completion patch for the new commands:

8<-----


>From 53e3090ecd124562540bb25948783c33d9390112 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 20 Oct 2016 13:29:03 -0600
Subject: [PATCH] ndctl: bash completion for {init, check}-labels

Add bash completion for the new init-labels and check-labels commands.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/contrib/ndctl b/contrib/ndctl
index 2c04504..ea7303c 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -206,6 +206,10 @@ __ndctl_comp_non_option_args()
 	disable-dimm)
 		opts="$(__ndctl_get_dimms) all"
 		;;
+	init-labels)
+		;&
+	check-labels)
+		;&
 	read-labels)
 		;&
 	zero-labels)
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
