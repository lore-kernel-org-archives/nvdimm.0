Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41ED421A04830
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 14:13:30 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id r203so78101270oib.3
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 14:13:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149211329997.65042.10283420064460739184.stgit@djiang5-desk3.ch.intel.com>
References: <149211329997.65042.10283420064460739184.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Apr 2017 14:13:28 -0700
Message-ID: <CAPcyv4geHoJZ2Mw6KKQxGNPMQzv-fNynFxQ5=ezqpDBMJ+HAmg@mail.gmail.com>
Subject: Re: [PATCH v5] libnvdimm: fix clear poison locking with spinlock and
 GFP_NOWAIT allocation
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 13, 2017 at 1:02 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The following warning results from holding a lane spinlock,
> preempt_disable(), or the btt map spinlock and then trying to take the
> reconfig_mutex to walk the poison list and potentially add new entries.
>
> BUG: sleeping function called from invalid context at kernel/locking/mutex.
> c:747
> in_atomic(): 1, irqs_disabled(): 0, pid: 17159, name: dd
> [..]
> Call Trace:
> dump_stack+0x85/0xc8
> ___might_sleep+0x184/0x250
> __might_sleep+0x4a/0x90
> __mutex_lock+0x58/0x9b0
> ? nvdimm_bus_lock+0x21/0x30 [libnvdimm]
> ? __nvdimm_bus_badblocks_clear+0x2f/0x60 [libnvdimm]
> ? acpi_nfit_forget_poison+0x79/0x80 [nfit]
> ? _raw_spin_unlock+0x27/0x40
> mutex_lock_nested+0x1b/0x20
> nvdimm_bus_lock+0x21/0x30 [libnvdimm]
> nvdimm_forget_poison+0x25/0x50 [libnvdimm]
> nvdimm_clear_poison+0x106/0x140 [libnvdimm]
> nsio_rw_bytes+0x164/0x270 [libnvdimm]
> btt_write_pg+0x1de/0x3e0 [nd_btt]
> ? blk_queue_enter+0x30/0x290
> btt_make_request+0x11a/0x310 [nd_btt]
> ? blk_queue_enter+0xb7/0x290
> ? blk_queue_enter+0x30/0x290
> generic_make_request+0x118/0x3b0
>
> A spinlock is introduced to protect the poison list. This allows us to not
> having to acquire the reconfig_mutex for touching the poison list. The
> add_poison() function has been broken out into two helper functions. One to
> allocate the poison entry and the other to apppend the entry. This allows us
> to unlock the poison_lock in non-I/O path and continue to be able to allocate
> the poison entry with GFP_KERNEL. We will use GFP_NOWAIT in the I/O path in
> order to satisfy being in atomic context.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v2:
> Dan
> - remove mempool and just use GFP_NOWAIT
>
> v3:
> Vishal
> - remove unneeded code
>
> v4:
> Dan
> - fixup commit header
> - GFP_NOWAIT only in I/O path
>
> v5:
> Dan
> - address issue where when lock released to allocate, the list has updated

Looks good, a couple more tiny cleanups...

>
>  drivers/nvdimm/bus.c      |    7 +++--
>  drivers/nvdimm/core.c     |   65 ++++++++++++++++++++++++++++-----------------
>  drivers/nvdimm/nd-core.h  |    1 +
>  include/linux/libnvdimm.h |    2 -
>  4 files changed, 46 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 5ad2e59..d214ac44 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -296,6 +296,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
>         init_waitqueue_head(&nvdimm_bus->probe_wait);
>         nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
>         mutex_init(&nvdimm_bus->reconfig_mutex);
> +       spin_lock_init(&nvdimm_bus->poison_lock);
>         if (nvdimm_bus->id < 0) {
>                 kfree(nvdimm_bus);
>                 return NULL;
> @@ -364,9 +365,9 @@ static int nd_bus_remove(struct device *dev)
>         nd_synchronize();
>         device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
>
> -       nvdimm_bus_lock(&nvdimm_bus->dev);
> +       spin_lock(&nvdimm_bus->poison_lock);
>         free_poison_list(&nvdimm_bus->poison_list);
> -       nvdimm_bus_unlock(&nvdimm_bus->dev);
> +       spin_unlock(&nvdimm_bus->poison_lock);
>
>         nvdimm_bus_destroy_ndctl(nvdimm_bus);
>
> @@ -990,7 +991,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>
>                 if (clear_err->cleared) {
>                         /* clearing the poison list we keep track of */
> -                       __nvdimm_forget_poison(nvdimm_bus, clear_err->address,
> +                       nvdimm_forget_poison(nvdimm_bus, clear_err->address,
>                                         clear_err->cleared);
>
>                         /* now sync the badblocks lists */
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index 40a3da0..280ab69 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -518,28 +518,48 @@ void nvdimm_badblocks_populate(struct nd_region *nd_region,
>  }
>  EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
>
> +static struct nd_poison * alloc_poison_entry(struct nvdimm_bus *nvdimm_bus,
> +               gfp_t flags)
> +{
> +       return kzalloc(sizeof(struct nd_poison), flags);
> +}

This routine doesn't use nvdimm_bus (since we got rid of the mempool),
lets just open code kzalloc() calls where they are needed.

> +
> +static void append_poison_entry(struct nvdimm_bus *nvdimm_bus,
> +               struct nd_poison *pl, u64 addr, u64 length)
> +{
> +       lockdep_assert_held(&nvdimm_bus->poison_lock);
> +       pl->start = addr;
> +       pl->length = length;
> +       list_add_tail(&pl->list, &nvdimm_bus->poison_list);
> +}
> +
>  static int add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length,
>                         gfp_t flags)
>  {
>         struct nd_poison *pl;
>
> -       pl = kzalloc(sizeof(*pl), flags);
> +       pl = alloc_poison_entry(nvdimm_bus, flags);
>         if (!pl)
>                 return -ENOMEM;
>
> -       pl->start = addr;
> -       pl->length = length;
> -       list_add_tail(&pl->list, &nvdimm_bus->poison_list);
> -
> +       append_poison_entry(nvdimm_bus, pl, addr, length);
>         return 0;
>  }
>
>  static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
>  {
> -       struct nd_poison *pl;
> +       struct nd_poison *pl, *pl_new;
>
> -       if (list_empty(&nvdimm_bus->poison_list))
> -               return add_poison(nvdimm_bus, addr, length, GFP_KERNEL);
> +       spin_unlock(&nvdimm_bus->poison_lock);
> +       pl_new = alloc_poison_entry(nvdimm_bus, GFP_KERNEL);
> +       spin_lock(&nvdimm_bus->poison_lock);
> +
> +       if (list_empty(&nvdimm_bus->poison_list)) {
> +               if (!pl_new)
> +                       return -ENOMEM;
> +               append_poison_entry(nvdimm_bus, pl_new, addr, length);
> +               return 0;
> +       }
>
>         /*
>          * There is a chance this is a duplicate, check for those first.
> @@ -551,6 +571,8 @@ static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
>                         /* If length has changed, update this list entry */
>                         if (pl->length != length)
>                                 pl->length = length;
> +                       if (pl_new)
> +                               kfree(pl_new);

kfree() already checks for NULL internally so this "if" can be dropped.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
