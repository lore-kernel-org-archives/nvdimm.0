Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEBB721ED1C75
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 10:17:18 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id r30so2978874otr.2
 for <linux-nvdimm@lists.01.org>; Wed, 07 Mar 2018 10:23:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180307180237.9289-1-ross.zwisler@linux.intel.com>
References: <20180307180237.9289-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Mar 2018 10:23:32 -0800
Message-ID: <CAPcyv4hW_EN4Lc0bDVvs8N9_+zDr9HxcqRG6vahhAOfuE1eUaQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ndctl: don't print erroneous namespace numa_nodes
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

On Wed, Mar 7, 2018 at 10:02 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> If the kernel has CONFIG_NUMA unset namespaces in sysfs will lack a
> numa_node attribute.  In such cases ndctl will report a value of 0 for the
> namespace numa_node in 'ndctl list'.  Instead of reporting potentially bad
> data just hide the numa_node field if it is unsupported.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Fixes: commit f7d3de80a121 ("ndctl: support machines without numa")
> ---
>  ndctl/lib/libndctl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ed5a65b..b7180e8 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -3008,6 +3008,8 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
>         sprintf(path, "%s/numa_node", ndns_base);
>         if (sysfs_read_attr(ctx, path, buf) == 0)
>                 ndns->numa_node = strtol(buf, NULL, 0);
> +       else
> +               ndns->numa_node = -1;

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
