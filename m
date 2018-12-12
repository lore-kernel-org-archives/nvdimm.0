Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAE2D2119AC3F
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 16:33:03 -0800 (PST)
Subject: Re: [PATCH v13 12/17] acpi/nfit, libnvdimm/security: Add security DSM
 overwrite support
References: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
 <154455999070.26509.9588337660184604278.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4h1H_hJyQii-+B0h-vycLH2iY7CgL2a1TDAWjGv5A0sNQ@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <1b2e6216-2192-47dd-c5b5-860356e95128@intel.com>
Date: Tue, 11 Dec 2018 17:33:01 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h1H_hJyQii-+B0h-vycLH2iY7CgL2a1TDAWjGv5A0sNQ@mail.gmail.com>
Content-Language: en-US
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
Cc: David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 12/11/18 4:44 PM, Dan Williams wrote:
> On Tue, Dec 11, 2018 at 12:26 PM Dave Jiang <dave.jiang@intel.com> wrote:
>>
>> We are adding support for the security calls of ovewrite and query
>> overwrite introduced from Intel DSM spec v1.7. This will allow triggering
>> of overwrite on Intel NVDIMMs. The overwrite operation can take tens
>> of minutes. When the overwrite DSM is issued successfully, the NVDIMMs
>> will be unaccessible. The kernel will do backoff polling to detect when
>> the overwrite process is completed. According to the DSM spec v1.7,
>> the 128G NVDIMMs can take up to 15mins to perform overwrite and larger
>> DIMMs will take longer.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/acpi/nfit/core.c   |    5 ++
>>  drivers/acpi/nfit/intel.c  |   93 ++++++++++++++++++++++++++++++++++++++++++
>>  drivers/acpi/nfit/nfit.h   |    1
>>  drivers/nvdimm/core.c      |    3 +
>>  drivers/nvdimm/dimm_devs.c |   35 +++++++++++++++-
>>  drivers/nvdimm/nd-core.h   |    8 ++++
>>  drivers/nvdimm/security.c  |   98 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/libnvdimm.h  |    4 ++
>>  8 files changed, 245 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 77f188cd8023..173517eb35b1 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -2043,6 +2043,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>>                 if (!nvdimm)
>>                         continue;
>>
>> +               rc = nvdimm_security_setup_events(nvdimm);
>> +               if (rc < 0)
>> +                       dev_warn(acpi_desc->dev,
>> +                               "security event setup failed: %d\n", rc);
>> +
>>                 nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
>>                 if (nfit_kernfs)
>>                         nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,
>> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
>> index ce65111ea4e1..3c3f99dfc32c 100644
>> --- a/drivers/acpi/nfit/intel.c
>> +++ b/drivers/acpi/nfit/intel.c
>> @@ -254,6 +254,97 @@ static int intel_security_erase(struct nvdimm *nvdimm,
>>         return 0;
>>  }
>>
>> +static int intel_security_query_overwrite(struct nvdimm *nvdimm)
>> +{
>> +       int rc;
>> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>> +       struct {
>> +               struct nd_cmd_pkg pkg;
>> +               struct nd_intel_query_overwrite cmd;
>> +       } nd_cmd = {
>> +               .pkg = {
>> +                       .nd_command = NVDIMM_INTEL_QUERY_OVERWRITE,
>> +                       .nd_family = NVDIMM_FAMILY_INTEL,
>> +                       .nd_size_in = 0,
>> +                       .nd_size_out = ND_INTEL_STATUS_SIZE,
>> +                       .nd_fw_size = ND_INTEL_STATUS_SIZE,
>> +               },
>> +               .cmd = {
>> +                       .status = 0,
>> +               },
>> +       };
>> +
>> +       if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
>> +               return -ENOTTY;
>> +
>> +       rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
>> +       if (rc < 0)
>> +               return rc;
>> +
>> +       switch (nd_cmd.cmd.status) {
>> +       case 0:
>> +               break;
>> +       case ND_INTEL_STATUS_OQUERY_INPROGRESS:
>> +               return -EBUSY;
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +
>> +       /* flush all cache before we make the nvdimms available */
>> +       nvdimm_invalidate_cache();
>> +       nfit_mem->overwrite = false;
>> +       return 0;
>> +}
>> +
>> +static int intel_security_overwrite(struct nvdimm *nvdimm,
>> +               const struct nvdimm_key_data *nkey)
>> +{
>> +       int rc;
>> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>> +       struct {
>> +               struct nd_cmd_pkg pkg;
>> +               struct nd_intel_overwrite cmd;
>> +       } nd_cmd = {
>> +               .pkg = {
>> +                       .nd_command = NVDIMM_INTEL_OVERWRITE,
>> +                       .nd_family = NVDIMM_FAMILY_INTEL,
>> +                       .nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
>> +                       .nd_size_out = ND_INTEL_STATUS_SIZE,
>> +                       .nd_fw_size = ND_INTEL_STATUS_SIZE,
>> +               },
>> +               .cmd = {
>> +                       .status = 0,
>> +               },
>> +       };
>> +
>> +       if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
>> +               return -ENOTTY;
>> +
>> +       /* flush all cache before we erase DIMM */
>> +       nvdimm_invalidate_cache();
>> +       if (nkey)
>> +               memcpy(nd_cmd.cmd.passphrase, nkey->data,
>> +                               sizeof(nd_cmd.cmd.passphrase));
>> +       rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
>> +       if (rc < 0)
>> +               return rc;
>> +
>> +       switch (nd_cmd.cmd.status) {
>> +       case 0:
>> +               nfit_mem->overwrite = true;
>> +               break;
>> +       case ND_INTEL_STATUS_OVERWRITE_UNSUPPORTED:
>> +               return -ENOTSUPP;
>> +       case ND_INTEL_STATUS_INVALID_PASS:
>> +               return -EINVAL;
>> +       case ND_INTEL_STATUS_INVALID_STATE:
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>  /*
>>   * TODO: define a cross arch wbinvd equivalent when/if
>>   * NVDIMM_FAMILY_INTEL command support arrives on another arch.
>> @@ -278,6 +369,8 @@ static const struct nvdimm_security_ops __intel_security_ops = {
>>  #ifdef CONFIG_X86
>>         .unlock = intel_security_unlock,
>>         .erase = intel_security_erase,
>> +       .overwrite = intel_security_overwrite,
>> +       .query_overwrite = intel_security_query_overwrite,
>>  #endif
>>  };
>>
>> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
>> index 33691aecfcee..e0ee54049c89 100644
>> --- a/drivers/acpi/nfit/nfit.h
>> +++ b/drivers/acpi/nfit/nfit.h
>> @@ -208,6 +208,7 @@ struct nfit_mem {
>>         unsigned long flags;
>>         u32 dirty_shutdown;
>>         int family;
>> +       bool overwrite;
> 
> What is this for? It's not used in this patch.

I'm missing couple lines in intel_dimm_security_state() to short circuit
things and set NVDIMM_SECURITY_OVERWRITE when this is set when I was
moving things to the squashed tree.

> 
>>  };
>>
>>  struct acpi_nfit_desc {
>> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
>> index acce050856a8..b2496c06178b 100644
>> --- a/drivers/nvdimm/core.c
>> +++ b/drivers/nvdimm/core.c
>> @@ -437,6 +437,9 @@ static __init int libnvdimm_init(void)
>>  {
>>         int rc;
>>
>> +       rc = nvdimm_devs_init();
>> +       if (rc)
>> +               return rc;
>>         rc = nvdimm_bus_init();
>>         if (rc)
>>                 return rc;
>> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
>> index bfdc4824ba11..fa42774efb15 100644
>> --- a/drivers/nvdimm/dimm_devs.c
>> +++ b/drivers/nvdimm/dimm_devs.c
>> @@ -24,6 +24,7 @@
>>  #include "nd.h"
>>
>>  static DEFINE_IDA(dimm_ida);
>> +struct workqueue_struct *nvdimm_wq;
> 
> static?
> 
> Or why not use the system workqueue? I don't think this necessarily
> needs its own workqueue.
> 
>>
>>  /*
>>   * Retrieve bus and dimm handle and return if this bus supports
>> @@ -439,6 +440,15 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
>>                 rc = nvdimm_security_erase(nvdimm, key);
>>                 if (rc < 0)
>>                         return rc;
>> +       } else if (sysfs_streq(cmd, "overwite")) {
> 
> "overwrite"
> 
>> +               if (rc != 2)
>> +                       return -EINVAL;
>> +               rc = kstrtouint(keystr, 0, &key);
>> +               if (rc < 0)
>> +                       return rc;
>> +               rc = nvdimm_security_overwrite(nvdimm, key);
>> +               if (rc < 0)
>> +                       return rc;
>>         } else
>>                 return -EINVAL;
>>
>> @@ -491,7 +501,8 @@ static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
>>         /* Are there any state mutation ops? */
>>         if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable
>>                         || nvdimm->sec.ops->change_key
>> -                       || nvdimm->sec.ops->erase)
>> +                       || nvdimm->sec.ops->erase
>> +                       || nvdimm->sec.ops->overwrite)
>>                 return a->mode;
>>         return 0444;
>>  }
>> @@ -534,6 +545,8 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>>         dev->devt = MKDEV(nvdimm_major, nvdimm->id);
>>         dev->groups = groups;
>>         nvdimm->sec.ops = sec_ops;
>> +       nvdimm->sec.overwrite_tmo = 0;
>> +       INIT_DELAYED_WORK(&nvdimm->dwork, nvdimm_security_overwrite_query);
>>         /*
>>          * Security state must be initialized before device_add() for
>>          * attribute visibility.
>> @@ -545,6 +558,16 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>>  }
>>  EXPORT_SYMBOL_GPL(__nvdimm_create);
>>
>> +int nvdimm_security_setup_events(struct nvdimm *nvdimm)
>> +{
>> +       nvdimm->sec.overwrite_state = sysfs_get_dirent(nvdimm->dev.kobj.sd,
>> +                       "security");
>> +       if (!nvdimm->sec.overwrite_state)
>> +               return -ENODEV;
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nvdimm_security_setup_events);
>> +
>>  int nvdimm_security_freeze(struct nvdimm *nvdimm)
>>  {
>>         int rc;
>> @@ -839,7 +862,17 @@ int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
>>  }
>>  EXPORT_SYMBOL_GPL(nvdimm_bus_check_dimm_count);
>>
>> +int __init nvdimm_devs_init(void)
>> +{
>> +       nvdimm_wq = create_singlethread_workqueue("nvdimm");
>> +       if (!nvdimm_wq)
>> +               return -ENOMEM;
>> +
>> +       return 0;
>> +}
>> +
>>  void __exit nvdimm_devs_exit(void)
>>  {
>> +       destroy_workqueue(nvdimm_wq);
> 
> I don't see a call to cancel_delayed_work_sync(), what ensures that
> the dimm is not hot removed while overwrite is in flight? It's
> probably ok to not wait for completion because the driver will
> reacquire the state at the next driver load, but the work needs to be
> cancelled, shutoff, and flushed before the device_del() of the nvdimm
> device.
> 
> 
> 
>>         ida_destroy(&dimm_ida);
>>  }
>> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
>> index 353f945cda5b..2c93e2139346 100644
>> --- a/drivers/nvdimm/nd-core.h
>> +++ b/drivers/nvdimm/nd-core.h
>> @@ -21,6 +21,7 @@
>>  extern struct list_head nvdimm_bus_list;
>>  extern struct mutex nvdimm_bus_list_mutex;
>>  extern int nvdimm_major;
>> +extern struct workqueue_struct *nvdimm_wq;
>>
>>  struct nvdimm_bus {
>>         struct nvdimm_bus_descriptor *nd_desc;
>> @@ -45,7 +46,10 @@ struct nvdimm {
>>         struct {
>>                 const struct nvdimm_security_ops *ops;
>>                 enum nvdimm_security_state state;
>> +               unsigned int overwrite_tmo;
>> +               struct kernfs_node *overwrite_state;
>>         } sec;
>> +       struct delayed_work dwork;
>>  };
>>
>>  static inline enum nvdimm_security_state nvdimm_security_state(
>> @@ -78,6 +82,9 @@ static inline void nvdimm_clear_security_busy(struct nvdimm *nvdimm)
>>         clear_bit(NDD_SECURITY_BUSY, &nvdimm->flags);
>>  }
>>
>> +int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid);
>> +void nvdimm_security_overwrite_query(struct work_struct *work);
>> +
>>  /**
>>   * struct blk_alloc_info - tracking info for BLK dpa scanning
>>   * @nd_mapping: blk region mapping boundaries
>> @@ -110,6 +117,7 @@ static inline bool is_memory(struct device *dev)
>>  struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
>>  int __init nvdimm_bus_init(void);
>>  void nvdimm_bus_exit(void);
>> +int nvdimm_devs_init(void);
>>  void nvdimm_devs_exit(void);
>>  void nd_region_devs_exit(void);
>>  void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
>> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
>> index 5a03dffd0056..3603c5fda1cf 100644
>> --- a/drivers/nvdimm/security.c
>> +++ b/drivers/nvdimm/security.c
>> @@ -282,7 +282,7 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
>>         struct key *key;
>>         int rc;
>>
>> -       /* The bus lock should be held at the top level of the call stack */
>> +       /* the bus lock should be held at the top level of the call stack */
> 
> Unintended change? Capitalized sentences is the local nvdimm custom.
> 
>>         lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>>
>>         if (!nvdimm->sec.ops || !nvdimm->sec.ops->erase
>> @@ -318,3 +318,99 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
>>         nvdimm->sec.state = nvdimm_security_state(nvdimm);
>>         return rc;
>>  }
>> +
>> +int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
>> +{
>> +       struct device *dev = &nvdimm->dev;
>> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
>> +       struct key *key;
>> +       int rc;
>> +
>> +       /* the bus lock should be held at the top level of the call stack */
>> +       lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>> +
>> +       if (!nvdimm->sec.ops || !nvdimm->sec.ops->overwrite
>> +                       || nvdimm->sec.state < 0)
>> +               return -EIO;
>> +
>> +       if (atomic_read(&nvdimm->busy)) {
>> +               dev_warn(dev, "Unable to overwrite while DIMM active.\n");
>> +               nvdimm_clear_security_busy(nvdimm);
>> +               return -EBUSY;
>> +       }
>> +
>> +       if (dev_get_drvdata(dev)) {
> 
> Use "dev->driver != NULL" as the "is enabled" test. dev_get_drvdata()
> works today, but I've seen driver-core patches that tried to make
> assumptions about the availability of drvdata for the core to use
> while dev->driver is NULL.
> 
> 
>> +               dev_warn(dev, "Unable to overwrite while DIMM active.\n");
>> +               nvdimm_clear_security_busy(nvdimm);
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
>> +               dev_warn(dev, "Incorrect security state: %d\n",
>> +                               nvdimm->sec.state);
>> +               return -EIO;
>> +       }
>> +
>> +       rc = nvdimm_security_check_busy(nvdimm);
>> +       if (rc < 0) {
>> +               dev_warn(dev, "Security operation in progress.\n");
>> +               return rc;
>> +       }
>> +
>> +       if (keyid == 0)
>> +               key = NULL;
>> +       else {
>> +               key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
>> +               if (!key)
>> +                       return -ENOKEY;
>> +       }
>> +
>> +       rc = nvdimm->sec.ops->overwrite(nvdimm, key ? key_data(key) : NULL);
>> +       dev_dbg(dev, "key: %d overwrite submission: %s\n", key_serial(key),
>> +                       rc == 0 ? "success" : "fail");
>> +
>> +       nvdimm_put_key(key);
>> +       nvdimm->sec.state = nvdimm_security_state(nvdimm);
>> +       nvdimm_set_security_busy(nvdimm);
>> +       return rc;
>> +}
>> +
>> +void nvdimm_security_overwrite_query(struct work_struct *work)
>> +{
>> +       struct nvdimm_bus *nvdimm_bus;
>> +       struct nvdimm *nvdimm;
>> +       int rc;
>> +       unsigned int tmo;
>> +
>> +       nvdimm = container_of(work, typeof(*nvdimm), dwork.work);
>> +       nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
>> +       tmo = nvdimm->sec.overwrite_tmo;
>> +
>> +       /* The bus lock should be held at the top level of the call stack */
>> +       lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>> +
> 
> The reconfig_mutex should have been dropped after the work was queued,
> so we would need to reacquire and revalidate state here.
> 
> We'd also need to abort and not re-queue if the nvdimm device is going away.
> 
>> +       if (!nvdimm->sec.ops || !nvdimm->sec.ops->query_overwrite
>> +                       || nvdimm->sec.state < 0)
>> +               return;
>> +
>> +       rc = nvdimm->sec.ops->query_overwrite(nvdimm);
>> +       if (rc == -EBUSY) {
>> +
>> +               /* setup delayed work again */
>> +               tmo += 10;
>> +               queue_delayed_work(nvdimm_wq, &nvdimm->dwork, tmo * HZ);
>> +               nvdimm->sec.overwrite_tmo = min(15U * 60U, tmo);
>> +               return;
>> +       }
>> +
>> +       if (rc < 0)
>> +               dev_warn(&nvdimm->dev, "overwrite failed\n");
>> +       else
>> +               dev_info(&nvdimm->dev, "overwrite completed\n");
> 
> Let's do dev_dbg(), no need to be chatty on success, and the driver is
> already notifying userspace of the completion event.
> 
>> +
>> +       if (nvdimm->sec.overwrite_state)
>> +               sysfs_notify_dirent(nvdimm->sec.overwrite_state);
>> +       nvdimm->sec.overwrite_tmo = 0;
>> +       nvdimm_clear_security_busy(nvdimm);
>> +       nvdimm->sec.state = nvdimm_security_state(nvdimm);
>> +}
>> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
>> index 8507d2896ae0..b728952ccb28 100644
>> --- a/include/linux/libnvdimm.h
>> +++ b/include/linux/libnvdimm.h
>> @@ -184,6 +184,9 @@ struct nvdimm_security_ops {
>>                         const struct nvdimm_key_data *key_data);
>>         int (*erase)(struct nvdimm *nvdimm,
>>                         const struct nvdimm_key_data *key_data);
>> +       int (*overwrite)(struct nvdimm *nvdimm,
>> +                       const struct nvdimm_key_data *key_data);
>> +       int (*query_overwrite)(struct nvdimm *nvdimm);
>>  };
>>
>>  void badrange_init(struct badrange *badrange);
>> @@ -221,6 +224,7 @@ static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>>                         cmd_mask, num_flush, flush_wpq, NULL, NULL);
>>  }
>>
>> +int nvdimm_security_setup_events(struct nvdimm *nvdimm);
>>  const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
>>  const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
>>  u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
>>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
