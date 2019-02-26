Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F10520886F3C
 for <linux-nvdimm@lists.01.org>; Tue, 26 Feb 2019 15:03:34 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id n71so12659244ota.10
 for <linux-nvdimm@lists.01.org>; Tue, 26 Feb 2019 15:03:34 -0800 (PST)
MIME-Version: 1.0
References: <20190225224307.6054-1-vishal.l.verma@intel.com>
 <20190225224307.6054-2-vishal.l.verma@intel.com>
 <70e74e8e47c107d531e45b301ab30c935d89ef5a.camel@intel.com>
 <ca608a0be92e8bd6c631a1e0f2961deb55c85328.camel@intel.com>
In-Reply-To: <ca608a0be92e8bd6c631a1e0f2961deb55c85328.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Feb 2019 15:03:23 -0800
Message-ID: <CAPcyv4g_FJkDa+0M9p-JwkwLLCkSr=NEw=-GAYnJ0NDD7Sbk2g@mail.gmail.com>
Subject: Re: [PATCH 2/2] nvdimm,
 btt: fix LBA masking during 'free list' population
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "pbarbuda@microsoft.com" <pbarbuda@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 26, 2019 at 2:52 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Mon, 2019-02-25 at 22:48 +0000, Verma, Vishal L wrote:
> > On Mon, 2019-02-25 at 15:43 -0700, Vishal Verma wrote:
> > > The Linux BTT implementation assumes that log entries will never have
> > > the 'zero' flag set, and indeed it never sets that flag for log entries
> > > itself.
> > >
> > > However, the UEFI spec is ambiguous on the exact format of the LBA field
> > > of a log entry, specifically as to whether it should include the
> > > additional flag bits or not. While a zero bit doesn't make sense in the
> > > context of a log entry, other BTT implementations might still have it set.
> > >
> > > If an implementation does happen to have it set, we would happily read
> > > it in as the next block to write to for writes. Since a high bit is set,
> > > it pushes the block number out of the range of an 'arena', and we fail
> > > such a write with an EIO.
> > >
> > > Follow the robustness principle, and tolerate such implementations by
> > > stripping out the zero flag when populating the free list during
> > > initialization. Additionally, use the same stripped out entries for
> > > detection of incomplete writes and map restoration that happens at this
> > > stage.
> > >
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Reported-by: Dexuan Cui <decui@microsoft.com>
> > > Reported-by: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
> > > Tested-by: Dexuan Cui <decui@microsoft.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> >
> > Forgot to include a change description:
> >
> > v1 -> v2:
> >
> > - Add a patch to remove unused code getting the old log entry
> > - Also use the stripped out versions of the log entries when testing for
> > incomplete writes.
> >
> v3: Add a sysfs file to indicate that the BTT is capable of handling
>   layouts that have zero flags set. This allows userspace tooling such
>   as 'ndctl check-namespace' perform repairs if needed based on kernel
>   support, and without relying on kernel version numbers.
>
> 8<-----
>
>
> From cc2a015dafd880f9419911079634af1a19d2eb94 Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Mon, 25 Feb 2019 12:00:32 -0700
> Subject: [PATCH v3] nvdimm, btt: fix LBA masking during 'free list' population
>
> The Linux BTT implementation assumes that log entries will never have
> the 'zero' flag set, and indeed it never sets that flag for log entries
> itself.
>
> However, the UEFI spec is ambiguous on the exact format of the LBA field
> of a log entry, specifically as to whether it should include the
> additional flag bits or not. While a zero bit doesn't make sense in the
> context of a log entry, other BTT implementations might still have it set.
>
> If an implementation does happen to have it set, we would happily read
> it in as the next block to write to for writes. Since a high bit is set,
> it pushes the block number out of the range of an 'arena', and we fail
> such a write with an EIO.
>
> Follow the robustness principle, and tolerate such implementations by
> stripping out the zero flag when populating the free list during
> initialization. Additionally, use the same stripped out entries for
> detection of incomplete writes and map restoration that happens at this
> stage.
>
> Add a sysfs file 'log_zero_flags' that indicates the ability to accept
> such a layout to userspace applications. This enables 'ndctl
> check-namespace' to recognize whether the kernel is able to handle zero
> flags, or whether it should attempt a fix-up under the --repair option.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Reported-by: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
> Tested-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/btt.c      | 22 +++++++++++++++++-----
>  drivers/nvdimm/btt_devs.c |  8 ++++++++
>  2 files changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index cd4fa87ea48c..294c48e45e74 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -542,8 +542,8 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
>  static int btt_freelist_init(struct arena_info *arena)
>  {
>         int new, ret;
> -       u32 i, map_entry;
>         struct log_entry log_new;
> +       u32 i, map_entry, log_oldmap, log_newmap;
>
>         arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
>                                         GFP_KERNEL);
> @@ -555,16 +555,21 @@ static int btt_freelist_init(struct arena_info *arena)
>                 if (new < 0)
>                         return new;
>
> +               /* old and new map entries with any flags stripped out */
> +               log_oldmap = ent_lba(le32_to_cpu(log_new.old_map));
> +               log_newmap = ent_lba(le32_to_cpu(log_new.new_map));
> +
>                 /* sub points to the next one to be overwritten */
>                 arena->freelist[i].sub = 1 - new;
>                 arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
> -               arena->freelist[i].block = le32_to_cpu(log_new.old_map);
> +               arena->freelist[i].block = log_oldmap;
>
>                 /*
>                  * FIXME: if error clearing fails during init, we want to make
>                  * the BTT read-only
>                  */
>                 if (ent_e_flag(log_new.old_map)) {
> +                       set_e_flag(arena->freelist[i].block);
>                         ret = arena_clear_freelist_error(arena, i);
>                         if (ret)
>                                 dev_err_ratelimited(to_dev(arena),
> @@ -572,7 +577,7 @@ static int btt_freelist_init(struct arena_info *arena)
>                 }
>
>                 /* This implies a newly created or untouched flog entry */
> -               if (log_new.old_map == log_new.new_map)
> +               if (log_oldmap == log_newmap)
>                         continue;
>
>                 /* Check if map recovery is needed */
> @@ -580,8 +585,15 @@ static int btt_freelist_init(struct arena_info *arena)
>                                 NULL, NULL, 0);
>                 if (ret)
>                         return ret;
> -               if ((le32_to_cpu(log_new.new_map) != map_entry) &&
> -                               (le32_to_cpu(log_new.old_map) == map_entry)) {
> +
> +               /*
> +                * The map_entry from btt_read_map is stripped of any flag bits,
> +                * so use the stripped out versions from the log as well for
> +                * testing whether recovery is needed. For restoration, use the
> +                * 'raw' version of the log entries as that captured what we
> +                * were going to write originally.
> +                */
> +               if ((log_newmap != map_entry) && (log_oldmap == map_entry)) {
>                         /*
>                          * Last transaction wrote the flog, but wasn't able
>                          * to complete the map write. So fix up the map.
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 795ad4ff35ca..90aad8af58e9 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -159,11 +159,19 @@ static ssize_t size_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(size);
>
> +static ssize_t log_zero_flags_show(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       return 0;

Lets do:

    return sprintf("Y\n");

...to match boolean flag attributes (see param_get_bool()).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
