Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B35B225E4014
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 15:40:30 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 23-v6so8817496oir.11
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 15:47:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180322184007.25667-2-ross.zwisler@linux.intel.com>
References: <20180322184007.25667-1-ross.zwisler@linux.intel.com>
 <20180322184007.25667-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Mar 2018 15:47:01 -0700
Message-ID: <CAPcyv4hyx4zgdw4FH1Bpy6OPvjcy7Vv_axrQUtxazTc6vP8t+g@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] ndctl: fail NUMA filtering when unavailable
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 22, 2018 at 11:40 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Instead of just failing to find namespaces when trying to filter by NUMA
> node when CONFIG_NUMA wasn't enabled in the kernel, instead fail loudly as
> numactl does:
>
>   # numactl --cpunodebind=0 ls
>   numactl: This system does not support NUMA policy
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>
> This enabling requires numactl to create a pkg-config file, which it
> currently does not.  This support is added by the following patch which
> I just sent out:
>
> https://patchwork.kernel.org/patch/10302135/

Hmm, it's going to be a while for that to be picked up and filter out
into all the distributions so we can either wait for the next numactl
release to become commonly available, or rework this ndctl change to
be independent of pkgconfig dependency.

The other concern is that this affects the numa-node filtering, but it
doesn't effect the numa-node json field reported by 'ndctl list'. I
think it would be confusing to see numa-nodes in the listing, but
filtering fails just because of the way ndctl was configured at build
time.

[..]
> diff --git a/util/filter.c b/util/filter.c
> index 291d7ed..512f927 100644
> --- a/util/filter.c
> +++ b/util/filter.c
> @@ -10,6 +10,7 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>   * General Public License for more details.
>   */
> +#include <numa.h>
>  #include <stdio.h>
>  #include <string.h>
>  #include <stdlib.h>
> @@ -328,6 +329,16 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
>         }
>
>         if (param->numa_node && strcmp(param->numa_node, "all") != 0) {
> +#ifdef WITH_NUMA
> +               if (numa_available() < 0) {
> +                       error("This system does not support NUMA");
> +#else
> +               {
> +                       error("ndctl was not configured with NUMA support");
> +#endif
> +                       return -EINVAL;
> +               }
> +

Please push this #ifdef'ery into a header file.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
