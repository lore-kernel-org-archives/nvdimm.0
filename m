Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42513202EDBB1
 for <linux-nvdimm@lists.01.org>; Thu, 15 Aug 2019 10:30:38 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id q20so6359798otl.0
 for <linux-nvdimm@lists.01.org>; Thu, 15 Aug 2019 10:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190731111207.12836-1-pagupta@redhat.com>
In-Reply-To: <20190731111207.12836-1-pagupta@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Aug 2019 10:28:30 -0700
Message-ID: <CAPcyv4gLqd43CLDuGYrDdx4xR1_oc3D0hzdETz8uQmV1C2Dp_Q@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: change disk name of virtio pmem disk
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 31, 2019 at 4:12 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> This patch adds prefix 'v' in disk name for virtio pmem.
> This differentiates virtio-pmem disks from the pmem disks.

I don't think the small matter that this device does not support
MAP_SYNC warrants a separate naming scheme.  That said I do think we
need to export this attribute in sysfs, likely at the region level,
and then display that information in ndctl. This is distinct from the
btt case where it is operating a different data consistency contract
than baseline pmem.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index a16e52251a30..8e5d29266fb0 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -182,8 +182,12 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
>                 char *name)
>  {
>         struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
> +       const char *prefix = "";
>         const char *suffix = NULL;
>
> +       if (!is_nvdimm_sync(nd_region))
> +               prefix = "v";
> +
>         if (ndns->claim && is_nd_btt(ndns->claim))
>                 suffix = "s";
>
> @@ -201,7 +205,7 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
>                         sprintf(name, "pmem%d.%d%s", nd_region->id, nsidx,
>                                         suffix ? suffix : "");
>                 else
> -                       sprintf(name, "pmem%d%s", nd_region->id,
> +                       sprintf(name, "%spmem%d%s", prefix, nd_region->id,
>                                         suffix ? suffix : "");
>         } else if (is_namespace_blk(&ndns->dev)) {
>                 struct nd_namespace_blk *nsblk;
> --
> 2.20.1
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
