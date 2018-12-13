Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 012BC211A209B
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 12:47:35 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id y23so2776322oia.4
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 12:47:35 -0800 (PST)
MIME-Version: 1.0
References: <154471935968.55644.4424661179787827497.stgit@djiang5-desk3.ch.intel.com>
 <154471976765.55644.14520312588475610982.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154471976765.55644.14520312588475610982.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Dec 2018 12:47:22 -0800
Message-ID: <CAPcyv4ie-iESc8xi_AO2NmPnmLm7HmKmtWkB7fL0K1yV7VLgvQ@mail.gmail.com>
Subject: Re: [PATCH v14 12/17] acpi/nfit, libnvdimm/security: Add security DSM
 overwrite support
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
Cc: David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 13, 2018 at 8:49 AM Dave Jiang <dave.jiang@intel.com> wrote:
>
> We are adding support for the security calls of ovewrite and query
> overwrite introduced from Intel DSM spec v1.7. This will allow triggering
> of overwrite on Intel NVDIMMs. The overwrite operation can take tens
> of minutes. When the overwrite DSM is issued successfully, the NVDIMMs
> will be unaccessible. The kernel will do backoff polling to detect when
> the overwrite process is completed. According to the DSM spec v1.7,
> the 128G NVDIMMs can take up to 15mins to perform overwrite and larger
> DIMMs will take longer.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/core.c   |    5 ++
>  drivers/acpi/nfit/intel.c  |   91 +++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/nfit.h   |    1
>  drivers/nvdimm/bus.c       |   14 +++++
>  drivers/nvdimm/dimm_devs.c |   22 +++++++-
>  drivers/nvdimm/nd-core.h   |    7 +++
>  drivers/nvdimm/security.c  |  120 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/libnvdimm.h  |    6 ++
>  8 files changed, 263 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 77f188cd8023..173517eb35b1 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2043,6 +2043,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>                 if (!nvdimm)
>                         continue;
>
> +               rc = nvdimm_security_setup_events(nvdimm);
> +               if (rc < 0)
> +                       dev_warn(acpi_desc->dev,
> +                               "security event setup failed: %d\n", rc);
> +
>                 nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
>                 if (nfit_kernfs)
>                         nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> index ae1fd394caa0..fdb318de2e52 100644
> --- a/drivers/acpi/nfit/intel.c
> +++ b/drivers/acpi/nfit/intel.c
> @@ -27,6 +27,10 @@ static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
>         if (!test_bit(NVDIMM_INTEL_GET_SECURITY_STATE, &nfit_mem->dsm_mask))
>                 return -ENXIO;
>
> +       /* Short circuit the state retrieval while we are doing overwrite */

Extend this comment to note that per the spec the state is
indeterminate until the overwrite completes. Otherwise the comment is
just saying "what" and not the more important "why".

> +       if (nfit_mem->overwrite)
> +               return NVDIMM_SECURITY_OVERWRITE;
> +
>         rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
>         if (rc < 0)
>                 return rc;
> @@ -248,6 +252,91 @@ static int intel_security_erase(struct nvdimm *nvdimm,
>         return 0;
>  }
>
> +static int intel_security_query_overwrite(struct nvdimm *nvdimm)
> +{
> +       int rc;
> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +       struct {
> +               struct nd_cmd_pkg pkg;
> +               struct nd_intel_query_overwrite cmd;
> +       } nd_cmd = {
> +               .pkg = {
> +                       .nd_command = NVDIMM_INTEL_QUERY_OVERWRITE,
> +                       .nd_family = NVDIMM_FAMILY_INTEL,
> +                       .nd_size_in = 0,

That zero-init snuck back in again.

> +                       .nd_size_out = ND_INTEL_STATUS_SIZE,
> +                       .nd_fw_size = ND_INTEL_STATUS_SIZE,
> +               },
> +       };
> +
> +       if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
> +               return -ENOTTY;
> +
> +       rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> +       if (rc < 0)
> +               return rc;
> +
> +       switch (nd_cmd.cmd.status) {
> +       case 0:
> +               break;
> +       case ND_INTEL_STATUS_OQUERY_INPROGRESS:
> +               return -EBUSY;
> +       default:
> +               return -ENXIO;
> +       }
> +
> +       /* flush all cache before we make the nvdimms available */
> +       nvdimm_invalidate_cache();
> +       nfit_mem->overwrite = false;
> +       return 0;
> +}
> +
> +static int intel_security_overwrite(struct nvdimm *nvdimm,
> +               const struct nvdimm_key_data *nkey)
> +{
> +       int rc;
> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +       struct {
> +               struct nd_cmd_pkg pkg;
> +               struct nd_intel_overwrite cmd;
> +       } nd_cmd = {
> +               .pkg = {
> +                       .nd_command = NVDIMM_INTEL_OVERWRITE,
> +                       .nd_family = NVDIMM_FAMILY_INTEL,
> +                       .nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
> +                       .nd_size_out = ND_INTEL_STATUS_SIZE,
> +                       .nd_fw_size = ND_INTEL_STATUS_SIZE,
> +               },
> +       };
> +
> +       if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
> +               return -ENOTTY;

I think we're missing a state check here to

> +
> +       /* flush all cache before we erase DIMM */
> +       nvdimm_invalidate_cache();
> +       if (nkey)
> +               memcpy(nd_cmd.cmd.passphrase, nkey->data,
> +                               sizeof(nd_cmd.cmd.passphrase));
> +       rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> +       if (rc < 0)
> +               return rc;
> +
> +       switch (nd_cmd.cmd.status) {
> +       case 0:
> +               nfit_mem->overwrite = true;
> +               break;

Just "return 0" here, no need to "break" like the other cases that
have some common follow-on work to do.

> +       case ND_INTEL_STATUS_OVERWRITE_UNSUPPORTED:
> +               return -ENOTSUPP;
> +       case ND_INTEL_STATUS_INVALID_PASS:
> +               return -EINVAL;
> +       case ND_INTEL_STATUS_INVALID_STATE:
> +       default:
> +               return -ENXIO;
> +       }
> +
> +       return 0;
> +}
> +
>  /*
>   * TODO: define a cross arch wbinvd equivalent when/if
>   * NVDIMM_FAMILY_INTEL command support arrives on another arch.
> @@ -272,6 +361,8 @@ static const struct nvdimm_security_ops __intel_security_ops = {
>  #ifdef CONFIG_X86
>         .unlock = intel_security_unlock,
>         .erase = intel_security_erase,
> +       .overwrite = intel_security_overwrite,
> +       .query_overwrite = intel_security_query_overwrite,
>  #endif
>  };
>
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index 33691aecfcee..e0ee54049c89 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -208,6 +208,7 @@ struct nfit_mem {
>         unsigned long flags;
>         u32 dirty_shutdown;
>         int family;
> +       bool overwrite;

Can this just be replaced by NDD_SECURITY_BUSY? ...or the new name for
the flag... see below.

>  };
>
>  struct acpi_nfit_desc {
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index eae17d8ee539..74f167ba06ea 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -394,8 +394,20 @@ static int child_unregister(struct device *dev, void *data)
>          */
>         if (dev->class)
>                 /* pass */;

Let's just make this "return 0;"

> -       else
> +       else {
> +               if (is_nvdimm(dev)) {

Then we can save quite a bit of indentation.

> +                       struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +                       if (test_bit(NDD_SECURITY_OVERWRITE,
> +                                               &nvdimm->flags)) {
> +                               clear_bit(NDD_SECURITY_OVERWRITE,
> +                                               &nvdimm->flags);

I think NDD_SECURITY_OVERWRITE and NDD_SECURITY_BUSY are confusing flag names.

I would rename NDD_SECURITY_BUSY to NDD_SECURITY_OVERWRITE because
there's no other generic way to make the security state busy, so just
call it OVERWRITE.

Then rename NDD_SECURITY_OVERWRITE to NDD_WORK_PENDING because it's
tracking whether or not there is a pending device reference in some
asynchronous context to drop. The shutdown sequence should be:

nvdimm_bus_lock()
if (test_and_clear_bit(NDD_WORK_PENDING))
    put = true; <-- we won the race so we get to free the device, but...
nvdimm_bus_unlock()
cancel_delayed_work_sync();
if (put)
    put_device() <--- ...need to wait until here to know that the
workqueue is good and dead and not actively looking at the memory.

The above also assumes that the work can't be re-queued after
cancel_delayed_work_sync(), are we protected there?

> +                               cancel_delayed_work_sync(&nvdimm->dwork);
> +                               put_device(dev);
> +                       }
> +               }
>                 nd_device_unregister(dev, ND_SYNC);
> +       }
>         return 0;
>  }
>
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index e9f11d35ff2b..8afe6bc4f450 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -201,6 +201,7 @@ static void nvdimm_release(struct device *dev)
>  {
>         struct nvdimm *nvdimm = to_nvdimm(dev);
>
> +       cancel_delayed_work_sync(&nvdimm->dwork);

Too late / not needed, otherwise it's a bug.

>         ida_simple_remove(&dimm_ida, nvdimm->id);
>         kfree(nvdimm);
>  }
> @@ -395,7 +396,8 @@ static ssize_t security_show(struct device *dev,
>         C( OP_FREEZE,           "freeze",       1),     \
>         C( OP_DISABLE,          "disable",      2),     \
>         C( OP_UPDATE,           "update",       3),     \
> -       C( OP_ERASE,            "erase",        2)
> +       C( OP_ERASE,            "erase",        2),     \
> +       C( OP_OVERWRITE,        "overwrite",    2)
>  #undef C
>  #define C(a, b, c) a
>  enum nvdimmsec_op_ids { OPS };
> @@ -452,6 +454,9 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
>         } else if (i == OP_ERASE) {
>                 dev_dbg(dev, "erase %u\n", key);
>                 rc = nvdimm_security_erase(nvdimm, key);
> +       } else if (i == OP_OVERWRITE) {
> +               dev_dbg(dev, "overwrite %u\n", key);
> +               rc = nvdimm_security_overwrite(nvdimm, key);
>         } else
>                 return -EINVAL;
>
> @@ -503,7 +508,8 @@ static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
>         /* Are there any state mutation ops? */
>         if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable
>                         || nvdimm->sec.ops->change_key
> -                       || nvdimm->sec.ops->erase)
> +                       || nvdimm->sec.ops->erase
> +                       || nvdimm->sec.ops->overwrite)
>                 return a->mode;
>         return 0444;
>  }
> @@ -546,6 +552,8 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>         dev->devt = MKDEV(nvdimm_major, nvdimm->id);
>         dev->groups = groups;
>         nvdimm->sec.ops = sec_ops;
> +       nvdimm->sec.overwrite_tmo = 0;
> +       INIT_DELAYED_WORK(&nvdimm->dwork, nvdimm_security_overwrite_query);
>         /*
>          * Security state must be initialized before device_add() for
>          * attribute visibility.
> @@ -557,6 +565,16 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>  }
>  EXPORT_SYMBOL_GPL(__nvdimm_create);
>
> +int nvdimm_security_setup_events(struct nvdimm *nvdimm)
> +{
> +       nvdimm->sec.overwrite_state = sysfs_get_dirent(nvdimm->dev.kobj.sd,
> +                       "security");
> +       if (!nvdimm->sec.overwrite_state)
> +               return -ENODEV;
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvdimm_security_setup_events);
> +
>  int nvdimm_security_freeze(struct nvdimm *nvdimm)
>  {
>         int rc;
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index 3c8cdd40c456..657231ba0607 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -21,6 +21,7 @@
>  extern struct list_head nvdimm_bus_list;
>  extern struct mutex nvdimm_bus_list_mutex;
>  extern int nvdimm_major;
> +extern struct workqueue_struct *nvdimm_wq;
>
>  struct nvdimm_bus {
>         struct nvdimm_bus_descriptor *nd_desc;
> @@ -45,7 +46,10 @@ struct nvdimm {
>         struct {
>                 const struct nvdimm_security_ops *ops;
>                 enum nvdimm_security_state state;
> +               unsigned int overwrite_tmo;
> +               struct kernfs_node *overwrite_state;
>         } sec;
> +       struct delayed_work dwork;
>  };
>
>  static inline enum nvdimm_security_state nvdimm_security_state(
> @@ -62,6 +66,9 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
>                 unsigned int new_keyid);
>  int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid);
>
> +int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid);
> +void nvdimm_security_overwrite_query(struct work_struct *work);
> +
>  /**
>   * struct blk_alloc_info - tracking info for BLK dpa scanning
>   * @nd_mapping: blk region mapping boundaries
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 1edd298e6e27..f1ccdebba7b0 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -315,3 +315,123 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
>         nvdimm->sec.state = nvdimm_security_state(nvdimm);
>         return rc;
>  }
> +
> +int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
> +{
> +       struct device *dev = &nvdimm->dev;
> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> +       struct key *key;
> +       int rc;
> +
> +       /* The bus lock should be held at the top level of the call stack */
> +       lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
> +
> +       if (!nvdimm->sec.ops || !nvdimm->sec.ops->overwrite
> +                       || nvdimm->sec.state < 0)
> +               return -EIO;
> +
> +       if (atomic_read(&nvdimm->busy)) {
> +               dev_warn(dev, "Unable to overwrite while DIMM active.\n");
> +               return -EBUSY;
> +       }
> +
> +       if (dev->driver == NULL) {
> +               dev_warn(dev, "Unable to overwrite while DIMM active.\n");
> +               return -EINVAL;
> +       }
> +
> +       if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
> +               dev_warn(dev, "Incorrect security state: %d\n",
> +                               nvdimm->sec.state);
> +               return -EIO;
> +       }

I think this protects us from racing teardown with new overwrite
requests, but we maybe we should change the state to frozen while
shutting down to make sure no one attempts to sneak anything in?

> +
> +       if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags)) {
> +               dev_warn(dev, "Security operation in progress.\n");
> +               return -EBUSY;
> +       }
> +
> +       if (keyid == 0)
> +               key = NULL;
> +       else {
> +               key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
> +               if (!key)
> +                       return -ENOKEY;
> +       }
> +
> +       rc = nvdimm->sec.ops->overwrite(nvdimm, key ? key_data(key) : NULL);
> +       dev_dbg(dev, "key: %d overwrite submission: %s\n", key_serial(key),
> +                       rc == 0 ? "success" : "fail");
> +
> +       nvdimm_put_key(key);
> +       if (rc == 0) {
> +               set_bit(NDD_SECURITY_BUSY, &nvdimm->flags);
> +               set_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags);
> +               nvdimm->sec.state = NVDIMM_SECURITY_OVERWRITE;
> +               /*
> +                * Make sure we don't lose device while doing overwrite
> +                * query.
> +                */
> +               get_device(dev);
> +               queue_delayed_work(system_wq, &nvdimm->dwork, 0);
> +       }
> +       return rc;
> +}
> +
> +void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
> +{
> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
> +       int rc;
> +       unsigned int tmo;
> +
> +       /* The bus lock should be held at the top level of the call stack */
> +       lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
> +
> +       /*
> +        * Abort and release device if we no longer have the overwrite
> +        * flag set. It means the work has been canceled.
> +        */
> +       if (!test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {

This should be:

if (test_and_clear_bit(NDD_WORK_PENDING...
    put_device();
else
   return; <--- shutdown got to work_pending before us, get out of the way.

> +               put_device(&nvdimm->dev);
> +               return;
> +       }
> +
> +       tmo = nvdimm->sec.overwrite_tmo;
> +
> +       if (!nvdimm->sec.ops || !nvdimm->sec.ops->query_overwrite
> +                       || nvdimm->sec.state < 0)
> +               return;
> +
> +       rc = nvdimm->sec.ops->query_overwrite(nvdimm);
> +       if (rc == -EBUSY) {
> +
> +               /* setup delayed work again */
> +               tmo += 10;
> +               queue_delayed_work(system_wq, &nvdimm->dwork, tmo * HZ);
> +               nvdimm->sec.overwrite_tmo = min(15U * 60U, tmo);
> +               return;
> +       }
> +
> +       if (rc < 0)
> +               dev_warn(&nvdimm->dev, "overwrite failed\n");
> +       else
> +               dev_dbg(&nvdimm->dev, "overwrite completed\n");
> +
> +       if (nvdimm->sec.overwrite_state)
> +               sysfs_notify_dirent(nvdimm->sec.overwrite_state);
> +       nvdimm->sec.overwrite_tmo = 0;
> +       clear_bit(NDD_SECURITY_BUSY, &nvdimm->flags);
> +       clear_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags);
> +       put_device(&nvdimm->dev);
> +       nvdimm->sec.state = nvdimm_security_state(nvdimm);
> +}
> +
> +void nvdimm_security_overwrite_query(struct work_struct *work)
> +{
> +       struct nvdimm *nvdimm =
> +               container_of(work, typeof(*nvdimm), dwork.work);
> +
> +       nvdimm_bus_lock(&nvdimm->dev);
> +       __nvdimm_security_overwrite_query(nvdimm);
> +       nvdimm_bus_unlock(&nvdimm->dev);
> +}
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 8507d2896ae0..bcd5171805a1 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -40,6 +40,8 @@ enum {
>         NDD_LOCKED = 2,
>         /* memory under security wipes should not be accessed */
>         NDD_SECURITY_BUSY = 3,
> +       /* state bit for overwrite query worker function */
> +       NDD_SECURITY_OVERWRITE = 4,
>
>         /* need to set a limit somewhere, but yes, this is likely overkill */
>         ND_IOCTL_MAX_BUFLEN = SZ_4M,
> @@ -184,6 +186,9 @@ struct nvdimm_security_ops {
>                         const struct nvdimm_key_data *key_data);
>         int (*erase)(struct nvdimm *nvdimm,
>                         const struct nvdimm_key_data *key_data);
> +       int (*overwrite)(struct nvdimm *nvdimm,
> +                       const struct nvdimm_key_data *key_data);
> +       int (*query_overwrite)(struct nvdimm *nvdimm);
>  };
>
>  void badrange_init(struct badrange *badrange);
> @@ -221,6 +226,7 @@ static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>                         cmd_mask, num_flush, flush_wpq, NULL, NULL);
>  }
>
> +int nvdimm_security_setup_events(struct nvdimm *nvdimm);
>  const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
>  const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
>  u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
