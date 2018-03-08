Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74BC522568613
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 15:51:05 -0800 (PST)
Date: Thu, 8 Mar 2018 16:57:20 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 3/3] ndctl: add filtering based on numa_node
Message-ID: <20180308235720.GA14624@linux.intel.com>
References: <CAPcyv4gSMyVRbVNRubtdQ7_mrY8NpKWwx0p1vdz6j1KLGssSEw@mail.gmail.com>
 <20180307185355.4425-1-ross.zwisler@linux.intel.com>
 <20180308210809.GA11622@vverma7-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180308210809.GA11622@vverma7-desk1.amr.corp.intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 08, 2018 at 02:08:09PM -0700, Vishal Verma wrote:
> On 03/07, Ross Zwisler wrote:
> > Add support to 'ndctl list' so that we can filter DIMMs, regions and
> > namespaces based on numa node.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> > v2: Use NUMA_NO_NODE intead of hard coding -1 (Dan).
> > ---
> >  Documentation/ndctl/ndctl-list.txt |  4 ++++
> >  ndctl/list.c                       |  2 ++
> >  util/filter.c                      | 40 ++++++++++++++++++++++++++++++++++++--
> >  util/filter.h                      |  1 +
> >  4 files changed, 45 insertions(+), 2 deletions(-)
> > 
> 
> Here is the bash completion update for this option.
> I've tested it on my single-node VM, but Ross, can you test it on your
> setup and let me know if it completes for the available nodes fine?
> 
> Thanks,
> 	-Vishal
> 
> 8<-----
> 
> From c744e77f26a27e10cc9dd8ca9b1092a45d9d9dcd Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Thu, 8 Mar 2018 13:56:59 -0700
> Subject: [ndctl PATCH] ndctl, bash-completion: add completion for --numa-node
> 
> ndctl list can now accept a --numa-node option for filtering by numa
> node. Use the nodes in /sys/devices/system/node to provide completion
> options for available nodes.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Yep, this works like a charm.  You can add:

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>

For v3 of my patch which changed numa_node to numa-node I had to make the
following changes to your patch (just s/numa_node/numa-node/ in 2 places):

diff --git a/contrib/ndctl b/contrib/ndctl
index b1f5e59..a3a8675 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
        COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
        for cword in "${COMPREPLY[@]}"; do
-               if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware|--media-temperature|--ctrl-temperature|--spares|--media-temperature-threshold|--ctrl-temperature-threshold|--spares-threshold|--media-temperature-alarm|--ctrl-temperature-alarm|--spares-alarm|--numa_node) ]]; then
+               if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware|--media-temperature|--ctrl-temperature|--spares|--media-temperature-threshold|--ctrl-temperature-threshold|--spares-threshold|--media-temperature-alarm|--ctrl-temperature-alarm|--spares-alarm|--numa-node) ]]; then
                        COMPREPLY[$i]="${cword}="
                else
                        COMPREPLY[$i]="${cword} "
@@ -232,7 +232,7 @@ __ndctl_comp_options()
                --spares-alarm)
                        opts="on off"
                        ;;
-               --numa_node)
+               --numa-node)
                        opts=$(__ndctl_get_nodes)
                        ;;
                *)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
