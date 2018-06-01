Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 57CD7210CEA29
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 21:16:28 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id n3-v6so27834060ota.5
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 21:16:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180531233636.7775-1-elliott@hpe.com>
References: <20180531233636.7775-1-elliott@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 May 2018 21:16:27 -0700
Message-ID: <CAPcyv4jQeOU4TbE=JWLP-2419u3b=fGf3j1eM0aTy+LMenkoag@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: preserve read-only setting for pmem devices
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
To: Robert Elliott <elliott@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31, 2018 at 4:36 PM, Robert Elliott <elliott@hpe.com> wrote:
> The pmem driver don't honor a forced read-only setting for very long:
>         $ blockdev --setro /dev/pmem0
>         $ blockdev --getro /dev/pmem0
>         1
>
> followed by various commands like these:
>         $ blockdev --rereadpt /dev/pmem0
>         or
>         $ mkfs.ext4 /dev/pmem0
>
> results in this in the kernel serial log:
>          nd_pmem namespace0.0: region0 read-write, marking pmem0 read-write
>
> with the read-only setting lost:
>         $ blockdev --getro /dev/pmem0
>         0
>
> That's from bus.c nvdimm_revalidate_disk(), which always applies the
> setting from nd_region (which is initially based on the ACPI NFIT
> NVDIMM state flags not_armed bit).
>
> In contrast, commit 20bd1d026aac ("scsi: sd: Keep disk read-only when
> re-reading partition") fixed this issue for SCSI devices to preserve
> the previous setting if it was set to read-only.
>
> This patch modifies bus.c to preserve any previous read-only setting.
> It also eliminates the kernel serial log print except for cases where
> read-write is changed to read-only, so it doesn't print read-only to
> read-only non-changes.
>
> Signed-off-by: Robert Elliott <elliott@hpe.com>

Looks good to me. I'll also add the FIxes: tag and Cc: stable when applying.

One small nit below that I'll fixup when applying.

> ---
>  drivers/nvdimm/bus.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index a64023690cad..87762afa45b0 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -566,14 +566,17 @@ int nvdimm_revalidate_disk(struct gendisk *disk)
>  {
>         struct device *dev = disk_to_dev(disk)->parent;
>         struct nd_region *nd_region = to_nd_region(dev->parent);
> -       const char *pol = nd_region->ro ? "only" : "write";
> +       int disk_ro = get_disk_ro(disk);
>
> -       if (nd_region->ro == get_disk_ro(disk))
> +       /* upgrade to read-only if the region is read-only
> +        * preserve as read-only if the disk is already read-only
> +        */
> +       if (disk_ro || nd_region->ro == disk_ro)
>                 return 0;

The comment style in libnvdimm for a multi-line comment starts with /*
on a line by itself.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
