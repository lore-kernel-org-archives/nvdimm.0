Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE6D321BADAB2
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 15:48:20 -0700 (PDT)
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [PATCH v6 04/11] nfit/libnvdimm: add unlock of nvdimm support
 for Intel DIMMs
Date: Tue, 31 Jul 2018 22:48:18 +0000
Message-ID: <112A412BB11A1242B37129D931BCE5348379A31C@fmsmsx117.amr.corp.intel.com>
References: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
 <153255233354.51274.8552293701029405599.stgit@djiang5-desk3.ch.intel.com>
 <20180731220441.GA31500@alison-desk.jf.intel.com>
In-Reply-To: <20180731220441.GA31500@alison-desk.jf.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "ebiggers3@gmail.com" <ebiggers3@gmail.com>, "dhowells@redhat.com" <dhowells@redhat.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Schofield, Alison
> Sent: Tuesday, July 31, 2018 3:05 PM
> To: Jiang, Dave <dave.jiang@intel.com>
> Cc: linux-nvdimm@lists.01.org; Williams, Dan J <dan.j.williams@intel.com>; keyrings@vger.kernel.org; dhowells@redhat.com;
> keescook@chromium.org; elliott@hpe.com; ebiggers3@gmail.com
> Subject: Re: [PATCH v6 04/11] nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
> 
> On Wed, Jul 25, 2018 at 01:58:53PM -0700, Dave Jiang wrote:
> > Add support to allow query the security status of the Intel nvdimms and
> > also unlock the dimm via the kernel key management APIs. The passphrase is
> > expected to be pulled from userspace through keyutils. Moving the Intel
> > related bits to its own source file as well.
> >
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/acpi/nfit/Makefile |    1
> >  drivers/acpi/nfit/core.c   |    3 +
> >  drivers/acpi/nfit/intel.c  |  152 ++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/acpi/nfit/intel.h  |   15 ++++
> >  drivers/nvdimm/dimm.c      |    7 ++
> >  drivers/nvdimm/dimm_devs.c |  132 ++++++++++++++++++++++++++++++++++++++
> >  drivers/nvdimm/nd-core.h   |    4 +
> >  drivers/nvdimm/nd.h        |    2 +
> >  include/linux/libnvdimm.h  |   24 +++++++
> >  security/keys/key.c        |    1
> 
> Dave - Why don't I see a config change "depends on KEYS" to make
> LIBNVDIMM build?

Good catch Alison. I'll add.

> 
> 
> >  10 files changed, 338 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/acpi/nfit/intel.c
> >
> > diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
> > index a407e769f103..443c7ef4e6a6 100644
> > --- a/drivers/acpi/nfit/Makefile
> > +++ b/drivers/acpi/nfit/Makefile
> > @@ -1,3 +1,4 @@
> >  obj-$(CONFIG_ACPI_NFIT) := nfit.o
> >  nfit-y := core.o
> > +nfit-$(CONFIG_X86) += intel.o
> >  nfit-$(CONFIG_X86_MCE) += mce.o
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index 21235d555b5f..9cb6a108ecba 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -1904,7 +1904,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
> >  		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
> >  				acpi_nfit_dimm_attribute_groups,
> >  				flags, cmd_mask, flush ? flush->hint_count : 0,
> > -				nfit_mem->flush_wpq, &nfit_mem->id[0]);
> > +				nfit_mem->flush_wpq, &nfit_mem->id[0],
> > +				acpi_nfit_get_security_ops(nfit_mem->family));
> >  		if (!nvdimm)
> >  			return -ENOMEM;
> >
> > diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> > new file mode 100644
> > index 000000000000..4bfc1c1da339
> > --- /dev/null
> > +++ b/drivers/acpi/nfit/intel.c
> > @@ -0,0 +1,152 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> > +/*
> > + * Intel specific NFIT ops
> > + */
> > +#include <linux/libnvdimm.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/ndctl.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/delay.h>
> > +#include <linux/acpi.h>
> > +#include <linux/io.h>
> > +#include <linux/nd.h>
> > +#include <asm/cacheflush.h>
> > +#include <asm/smp.h>
> > +#include <acpi/nfit.h>
> > +#include "intel.h"
> > +#include "nfit.h"
> > +
> > +static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
> > +		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
> > +{
> > +	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> > +	int cmd_rc, rc = 0;
> > +	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> > +	struct {
> > +		struct nd_cmd_pkg pkg;
> > +		struct nd_intel_unlock_unit cmd;
> > +	} nd_cmd = {
> > +		.pkg = {
> > +			.nd_command = NVDIMM_INTEL_UNLOCK_UNIT,
> > +			.nd_family = NVDIMM_FAMILY_INTEL,
> > +			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
> > +			.nd_size_out = ND_INTEL_STATUS_SIZE,
> > +			.nd_fw_size = ND_INTEL_STATUS_SIZE,
> > +		},
> > +		.cmd = {
> > +			.status = 0,
> > +		},
> > +	};
> > +
> > +	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
> > +		return -ENOTTY;
> > +
> > +	memcpy(nd_cmd.cmd.passphrase, nkey->data,
> > +			sizeof(nd_cmd.cmd.passphrase));
> > +	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
> > +			sizeof(nd_cmd), &cmd_rc);
> > +	if (rc < 0)
> > +		goto out;
> > +	if (cmd_rc < 0) {
> > +		rc = cmd_rc;
> > +		goto out;
> > +	}
> > +
> > +	switch (nd_cmd.cmd.status) {
> > +	case 0:
> > +		break;
> > +	case ND_INTEL_STATUS_INVALID_PASS:
> > +		rc = -EINVAL;
> > +		goto out;
> > +	case ND_INTEL_STATUS_INVALID_STATE:
> > +	default:
> > +		rc = -ENXIO;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * TODO: define a cross arch wbinvd when/if NVDIMM_FAMILY_INTEL
> > +	 * support arrives on another arch.
> > +	 */
> > +	/* DIMM unlocked, invalidate all CPU caches before we read it */
> > +	wbinvd_on_all_cpus();
> > +
> > + out:
> > +	return rc;
> > +}
> > +
> > +static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
> > +		struct nvdimm *nvdimm, enum nvdimm_security_state *state)
> > +{
> > +	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> > +	int cmd_rc, rc = 0;
> > +	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> > +	struct {
> > +		struct nd_cmd_pkg pkg;
> > +		struct nd_intel_get_security_state cmd;
> > +	} nd_cmd = {
> > +		.pkg = {
> > +			.nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
> > +			.nd_family = NVDIMM_FAMILY_INTEL,
> > +			.nd_size_in = 0,
> > +			.nd_size_out =
> > +				sizeof(struct nd_intel_get_security_state),
> > +			.nd_fw_size =
> > +				sizeof(struct nd_intel_get_security_state),
> > +		},
> > +		.cmd = {
> > +			.status = 0,
> > +			.state = 0,
> > +		},
> > +	};
> > +
> > +	if (!test_bit(NVDIMM_INTEL_GET_SECURITY_STATE, &nfit_mem->dsm_mask)) {
> > +		*state = NVDIMM_SECURITY_UNSUPPORTED;
> > +		return 0;
> > +	}
> > +
> > +	*state = NVDIMM_SECURITY_DISABLED;
> > +	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
> > +			sizeof(nd_cmd), &cmd_rc);
> > +	if (rc < 0)
> > +		goto out;
> > +	if (cmd_rc < 0) {
> > +		rc = cmd_rc;
> > +		goto out;
> > +	}
> > +
> > +	switch (nd_cmd.cmd.status) {
> > +	case 0:
> > +		break;
> > +	case ND_INTEL_STATUS_RETRY:
> > +		rc = -EAGAIN;
> > +		goto out;
> > +	case ND_INTEL_STATUS_NOT_READY:
> > +	default:
> > +		rc = -ENXIO;
> > +		goto out;
> > +	}
> > +
> > +	/* check and see if security is enabled and locked */
> > +	if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
> > +		*state = NVDIMM_SECURITY_UNSUPPORTED;
> > +	else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
> > +		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
> > +			*state = NVDIMM_SECURITY_LOCKED;
> > +		else
> > +			*state = NVDIMM_SECURITY_UNLOCKED;
> > +	} else
> > +		*state = NVDIMM_SECURITY_DISABLED;
> > +
> > + out:
> > +	if (rc < 0)
> > +		*state = NVDIMM_SECURITY_INVALID;
> > +	return rc;
> > +}
> > +
> > +const struct nvdimm_security_ops intel_security_ops = {
> > +	.state = intel_dimm_security_state,
> > +	.unlock = intel_dimm_security_unlock,
> > +};
> > diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
> > index a6f8f4bc8ebb..f9ac718776ca 100644
> > --- a/drivers/acpi/nfit/intel.h
> > +++ b/drivers/acpi/nfit/intel.h
> > @@ -8,6 +8,8 @@
> >
> >  #ifdef CONFIG_X86
> >
> > +extern const struct nvdimm_security_ops intel_security_ops;
> > +
> >  #define ND_INTEL_STATUS_SIZE		4
> >  #define ND_INTEL_PASSPHRASE_SIZE	32
> >
> > @@ -64,4 +66,17 @@ struct nd_intel_query_overwrite {
> >  } __packed;
> >  #endif /* CONFIG_X86 */
> >
> > +static inline const struct nvdimm_security_ops *
> > +acpi_nfit_get_security_ops(int family)
> > +{
> > +	switch (family) {
> > +#ifdef CONFIG_X86
> > +	case NVDIMM_FAMILY_INTEL:
> > +		return &intel_security_ops;
> > +#endif
> > +	default:
> > +		return NULL;
> > +	}
> > +}
> > +
> >  #endif
> > diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> > index 6c8fb7590838..b6381ddbd6c1 100644
> > --- a/drivers/nvdimm/dimm.c
> > +++ b/drivers/nvdimm/dimm.c
> > @@ -51,6 +51,13 @@ static int nvdimm_probe(struct device *dev)
> >  	get_device(dev);
> >  	kref_init(&ndd->kref);
> >
> > +	nvdimm_security_get_state(dev);
> > +
> > +	/* unlock DIMM here before touch label */
> > +	rc = nvdimm_security_unlock_dimm(dev);
> > +	if (rc < 0)
> > +		dev_warn(dev, "failed to unlock dimm %s\n", dev_name(dev));
> > +
> >  	/*
> >  	 * EACCES failures reading the namespace label-area-properties
> >  	 * are interpreted as the DIMM capacity being locked but the
> > diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> > index e753b2095402..5b247f94807a 100644
> > --- a/drivers/nvdimm/dimm_devs.c
> > +++ b/drivers/nvdimm/dimm_devs.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/key.h>
> >  #include <linux/init_task.h>
> > +#include <keys/user-type.h>
> >  #include "nd-core.h"
> >  #include "label.h"
> >  #include "pmem.h"
> > @@ -28,6 +29,133 @@
> >  static DEFINE_IDA(dimm_ida);
> >  static struct key *nvdimm_keyring;
> >
> > +/*
> > + * Find key in kernel keyring
> > + */
> > +static struct key *nvdimm_search_key(struct device *dev)
> > +{
> > +	struct nvdimm *nvdimm = to_nvdimm(dev);
> > +	struct key *key;
> > +
> > +	if (!nvdimm->security_ops)
> > +		return NULL;
> > +
> > +	key = key_lookup(nvdimm->key_id);
> > +	if (IS_ERR(key))
> > +		key = NULL;
> > +	else
> > +		key_get(key);
> > +
> > +	dev_dbg(dev, "%s: key found: %d\n", __func__, key_serial(key));
> > +	return key;
> > +}
> > +
> > +#define NVDIMM_UPDATE_PREFIX   "nvdimm.update:"
> > +#define NVDIMM_PREFIX          "nvdimm:"
> > +
> > +/*
> > + * Retrieve kernel key for DIMM and request from user space if necessary.
> > + */
> > +static struct key *nvdimm_request_key(struct device *dev, bool update)
> > +{
> > +	struct nvdimm *nvdimm = to_nvdimm(dev);
> > +	struct key *key = NULL;
> > +	char desc[NVDIMM_KEY_DESC_LEN + strlen(NVDIMM_UPDATE_PREFIX)];
> > +
> > +	if (!nvdimm->security_ops)
> > +		return NULL;
> > +
> > +	sprintf(desc, "%s%s", update ? NVDIMM_UPDATE_PREFIX : NVDIMM_PREFIX,
> > +			nvdimm->dimm_id);
> > +	key = request_key(&key_type_logon, desc, desc);
> > +	if (IS_ERR(key))
> > +		key = NULL;
> > +
> > +	return key;
> > +}
> > +
> > +static int nvdimm_check_key_len(unsigned short len, bool update)
> > +{
> > +	if (len == (NVDIMM_PASSPHRASE_LEN * 2) && update)
> > +		return 0;
> > +
> > +	if (len == NVDIMM_PASSPHRASE_LEN)
> > +		return 0;
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +int nvdimm_security_get_state(struct device *dev)
> > +{
> > +	struct nvdimm *nvdimm = to_nvdimm(dev);
> > +	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> > +
> > +	if (!nvdimm->security_ops)
> > +		return 0;
> > +
> > +	return nvdimm->security_ops->state(nvdimm_bus, nvdimm,
> > +			&nvdimm->state);
> > +}
> > +
> > +int nvdimm_security_unlock_dimm(struct device *dev)
> > +{
> > +	struct nvdimm *nvdimm = to_nvdimm(dev);
> > +	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> > +	struct key *key;
> > +	struct user_key_payload *payload;
> > +	int rc;
> > +	bool cached_key = false;
> > +
> > +	if (!nvdimm->security_ops)
> > +		return 0;
> > +
> > +	if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED ||
> > +			nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED ||
> > +			nvdimm->state == NVDIMM_SECURITY_DISABLED)
> > +		return 0;
> > +
> > +	key = nvdimm_search_key(dev);
> > +	if (!key)
> > +		key = nvdimm_request_key(dev, false);
> > +	else
> > +		cached_key = true;
> > +	if (!key)
> > +		return -ENXIO;
> > +
> > +	if (!cached_key) {
> > +		rc = nvdimm_check_key_len(key->datalen, false);
> > +		if (rc < 0) {
> > +			key_invalidate(key);
> > +			key_put(key);
> > +			return rc;
> > +		}
> > +	}
> > +
> > +	dev_dbg(dev, "%s: key: %#x\n", __func__, key_serial(key));
> > +	down_read(&key->sem);
> > +	payload = key->payload.data[0];
> > +	rc = nvdimm->security_ops->unlock(nvdimm_bus, nvdimm,
> > +			(void *)payload->data);
> > +	up_read(&key->sem);
> > +
> > +	if (rc == 0) {
> > +		if (!cached_key) {
> > +			key_link(nvdimm_keyring, key);
> > +			nvdimm->key_id = key_serial(key);
> > +		}
> > +		nvdimm->state = NVDIMM_SECURITY_UNLOCKED;
> > +		dev_info(dev, "DIMM %s unlocked\n", dev_name(dev));
> > +	} else {
> > +		key_unlink(nvdimm_keyring, key);
> > +		key_invalidate(key);
> > +		dev_warn(dev, "Failed to unlock dimm: %s\n", dev_name(dev));
> > +	}
> > +
> > +	key_put(key);
> > +	nvdimm_security_get_state(dev);
> > +	return rc;
> > +}
> > +
> >  /*
> >   * Retrieve bus and dimm handle and return if this bus supports
> >   * get_config_data commands
> > @@ -401,7 +529,8 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
> >  struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
> >  		const struct attribute_group **groups, unsigned long flags,
> >  		unsigned long cmd_mask, int num_flush,
> > -		struct resource *flush_wpq, const char *dimm_id)
> > +		struct resource *flush_wpq, const char *dimm_id,
> > +		const struct nvdimm_security_ops *sec_ops)
> >  {
> >  	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
> >  	struct device *dev;
> > @@ -416,6 +545,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
> >  	}
> >
> >  	nvdimm->dimm_id = dimm_id;
> > +	nvdimm->security_ops = sec_ops;
> >  	nvdimm->provider_data = provider_data;
> >  	nvdimm->flags = flags;
> >  	nvdimm->cmd_mask = cmd_mask;
> > diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> > index ed650f1607d8..ff8919f9b67a 100644
> > --- a/drivers/nvdimm/nd-core.h
> > +++ b/drivers/nvdimm/nd-core.h
> > @@ -18,6 +18,7 @@
> >  #include <linux/sizes.h>
> >  #include <linux/mutex.h>
> >  #include <linux/nd.h>
> > +#include <linux/key.h>
> >
> >  extern struct list_head nvdimm_bus_list;
> >  extern struct mutex nvdimm_bus_list_mutex;
> > @@ -43,6 +44,9 @@ struct nvdimm {
> >  	int id, num_flush;
> >  	struct resource *flush_wpq;
> >  	const char *dimm_id;
> > +	const struct nvdimm_security_ops *security_ops;
> > +	enum nvdimm_security_state state;
> > +	key_serial_t key_id;
> >  };
> >
> >  /**
> > diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> > index 9d17abd9f8d0..9c80e0f8c327 100644
> > --- a/drivers/nvdimm/nd.h
> > +++ b/drivers/nvdimm/nd.h
> > @@ -424,4 +424,6 @@ static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
> >  resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
> >  const u8 *nd_dev_to_uuid(struct device *dev);
> >  bool pmem_should_map_pages(struct device *dev);
> > +int nvdimm_security_unlock_dimm(struct device *dev);
> > +int nvdimm_security_get_state(struct device *dev);
> >  #endif /* __ND_H__ */
> > diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> > index 3c1f18fdf76f..257ff2637ce1 100644
> > --- a/include/linux/libnvdimm.h
> > +++ b/include/linux/libnvdimm.h
> > @@ -155,9 +155,30 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
> >
> >  }
> >
> > +enum nvdimm_security_state {
> > +	NVDIMM_SECURITY_INVALID = 0,
> > +	NVDIMM_SECURITY_DISABLED,
> > +	NVDIMM_SECURITY_UNLOCKED,
> > +	NVDIMM_SECURITY_LOCKED,
> > +	NVDIMM_SECURITY_UNSUPPORTED,
> > +};
> > +
> >  #define NVDIMM_PASSPHRASE_LEN		32
> >  #define NVDIMM_KEY_DESC_LEN		22
> >
> > +struct nvdimm_key_data {
> > +	u8 data[NVDIMM_PASSPHRASE_LEN];
> > +};
> > +
> > +struct nvdimm_security_ops {
> > +	int (*state)(struct nvdimm_bus *nvdimm_bus,
> > +			struct nvdimm *nvdimm,
> > +			enum nvdimm_security_state *state);
> > +	int (*unlock)(struct nvdimm_bus *nvdimm_bus,
> > +			struct nvdimm *nvdimm,
> > +			const struct nvdimm_key_data *nkey);
> > +};
> > +
> >  void badrange_init(struct badrange *badrange);
> >  int badrange_add(struct badrange *badrange, u64 addr, u64 length);
> >  void badrange_forget(struct badrange *badrange, phys_addr_t start,
> > @@ -181,7 +202,8 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm);
> >  struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
> >  		const struct attribute_group **groups, unsigned long flags,
> >  		unsigned long cmd_mask, int num_flush,
> > -		struct resource *flush_wpq, const char *dimm_id);
> > +		struct resource *flush_wpq, const char *dimm_id,
> > +		const struct nvdimm_security_ops *sec_ops);
> >  const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
> >  const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
> >  u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
> > diff --git a/security/keys/key.c b/security/keys/key.c
> > index d97c9394b5dd..5aa367b2fd24 100644
> > --- a/security/keys/key.c
> > +++ b/security/keys/key.c
> > @@ -679,6 +679,7 @@ struct key *key_lookup(key_serial_t id)
> >  	spin_unlock(&key_serial_lock);
> >  	return key;
> >  }
> > +EXPORT_SYMBOL(key_lookup);
> >
> >  /*
> >   * Find and lock the specified key type against removal.
> >
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
