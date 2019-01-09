Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6E3C211AD36A
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 14:14:24 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v7 03/12] ndctl: add disable security support
Date: Wed, 9 Jan 2019 22:14:21 +0000
Message-ID: <df2f05c9fe1c0ab104cf7d13d7cb221491d70b3e.camel@intel.com>
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
 <154705644837.23227.5730479339395960908.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154705644837.23227.5730479339395960908.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <9EDA02FA560A3B47A0583066103AF1D0@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-01-09 at 10:54 -0700, Dave Jiang wrote:
> Add support for disable security to libndctl and also command line option
> of "disable-passphrase" for ndctl. This provides a way to disable security
> on the nvdimm.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                  |    3 +-
>  Documentation/ndctl/ndctl-disable-passphrase.txt |   32 +++++++++++++++++++
>  ndctl/builtin.h                                  |    1 +
>  ndctl/dimm.c                                     |   38 ++++++++++++++++++++--
>  ndctl/lib/dimm.c                                 |    9 +++++
>  ndctl/lib/keys.c                                 |   29 +++++++++++++++++
>  ndctl/lib/libndctl.sym                           |    2 +
>  ndctl/libndctl.h                                 |    8 +++++
>  ndctl/ndctl.c                                    |    1 +
>  9 files changed, 119 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-disable-passphrase.txt
> 
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index 7ad6666b..31570a77 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -49,7 +49,8 @@ man1_MANS = \
>  	ndctl-list.1 \
>  	ndctl-monitor.1 \
>  	ndctl-enable-passphrase.1 \
> -	ndctl-update-passphrase.1
> +	ndctl-update-passphrase.1 \
> +	ndctl-disable-passphrase.1
>  
>  CLEANFILES = $(man1_MANS)
>  
> diff --git a/Documentation/ndctl/ndctl-disable-passphrase.txt b/Documentation/ndctl/ndctl-disable-passphrase.txt
> new file mode 100644
> index 00000000..3c8bfe47
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-disable-passphrase.txt
> @@ -0,0 +1,32 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-disable-passphrase(1)
> +===========================
> +
> +NAME
> +----
> +ndctl-disable-passphrase - disabling passphrase for an NVDIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl disable-passphrase' <dimm> [<options>]
> +
> +DESCRIPTION
> +-----------
> +Provide a generic interface for disabling passphrase for NVDIMM.
> +Ndctl will search the user key ring for the associated DIMM. If no key is
> +found, it will attempt to load the key blob from the expected location. Ndctl
> +will remove the key and the key blob once passphrase is disabled.

This applies to the Description section of a few of the other patches
as well. the 'Ndctl' capitalized drew my attention to it, but thinking
about it, we should never say something like 'ndctl will do xyz'
the ndctl is implied, just rephrase as 'do xyz' in each of these cases.

So -

Provide a command for disabling the passphrase on an NVDIMM.

Search the user key ring for the associated NVDIMM. If not found,
attempt to load the key blob from the default location. After disabling
the passphrase, remove the key and the key blob.

You can adapt this to the other patches that reference ndctl in the
description section.

> +
> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-p::
> +--key-path=::
> +	Path to where key related files resides. This parameter is optional
> +	and the default is set to /etc/ndctl/keys.
> +
> +include::../copyright.txt[]
> diff --git a/ndctl/builtin.h b/ndctl/builtin.h
> index 231fda25..821ea690 100644
> --- a/ndctl/builtin.h
> +++ b/ndctl/builtin.h
> @@ -34,4 +34,5 @@ int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx);
>  int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
>  int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
>  int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
> +int cmd_disable_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
>  #endif /* _NDCTL_BUILTIN_H_ */
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 1ab6b29f..4f0466a1 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -864,6 +864,18 @@ static int action_key_update(struct ndctl_dimm *dimm,
>  			param.key_path);
>  }
>  
> +static int action_passphrase_disable(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	if (!ndctl_dimm_security_supported(dimm)) {
> +		error("%s: security operation not supported\n",
> +				ndctl_dimm_get_devname(dimm));
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return ndctl_dimm_disable_key(dimm, param.key_path);
> +}
> +
>  static int __action_init(struct ndctl_dimm *dimm,
>  		enum ndctl_namespace_version version, int chk_only)
>  {
> @@ -953,12 +965,14 @@ OPT_BOOLEAN('f', "force", &param.force, \
>  OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
>  	"namespace label specification version (default: 1.1)")
>  
> -#define KEY_OPTIONS() \
> -OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
> -		"master key for security"), \
> +#define KEY_BASE_OPTIONS() \
>  OPT_FILENAME('p', "key-path", &param.key_path, "key-path", \
>  		"override the default key path")
>  
> +#define KEY_OPTIONS() \
> +OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
> +		"master key for security")
> +
>  static const struct option read_options[] = {
>  	BASE_OPTIONS(),
>  	READ_OPTIONS(),
> @@ -988,8 +1002,15 @@ static const struct option init_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option key_base_options[] = {
> +	BASE_OPTIONS(),
> +	KEY_BASE_OPTIONS(),
> +	OPT_END(),
> +};
> +
>  static const struct option key_options[] = {
>  	BASE_OPTIONS(),
> +	KEY_BASE_OPTIONS(),
>  	KEY_OPTIONS(),
>  	OPT_END(),
>  };
> @@ -1253,3 +1274,14 @@ int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx)
>  			count > 1 ? "s" : "");
>  	return count >= 0 ? 0 : EXIT_FAILURE;
>  }
> +
> +int cmd_disable_passphrase(int argc, const char **argv, void *ctx)
> +{
> +	int count = dimm_action(argc, argv, ctx, action_passphrase_disable,
> +			key_base_options,
> +			"ndctl disable-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
> +
> +	fprintf(stderr, "passphrase disabled %d nmem%s.\n", count >= 0 ? count : 0,
> +			count > 1 ? "s" : "");
> +	return count >= 0 ? 0 : EXIT_FAILURE;
> +}
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index b64c9568..076ccbf6 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -663,3 +663,12 @@ NDCTL_EXPORT int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
>  	sprintf(buf, "update %ld %ld\n", ckey, nkey);
>  	return write_security(dimm, buf);
>  }
> +
> +NDCTL_EXPORT int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm,
> +		long key)
> +{
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	sprintf(buf, "disable %ld\n", key);
> +	return write_security(dimm, buf);
> +}
> diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
> index d6eb2690..2bfc7a05 100644
> --- a/ndctl/lib/keys.c
> +++ b/ndctl/lib/keys.c
> @@ -392,3 +392,32 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
>  
>  	return 0;
>  }
> +
> +NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm,
> +		const char *keypath)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	key_serial_t key;
> +	int rc;
> +
> +	key = dimm_check_key(dimm, false);
> +	if (key < 0) {
> +		key = dimm_load_key(dimm, false, keypath);
> +		if (key < 0) {
> +			err(ctx, "Unable to load key\n");
> +			return -ENOKEY;
> +		}
> +	}
> +
> +	rc = ndctl_dimm_disable_passphrase(dimm, key);
> +	if (rc < 0) {
> +		err(ctx, "Failed to disable security for %s\n",
> +				ndctl_dimm_get_devname(dimm));
> +		return rc;
> +	}
> +
> +	rc = dimm_remove_key(dimm, false, keypath);
> +	if (rc < 0)
> +		err(ctx, "Unable to cleanup key.\n");
> +	return 0;
> +}
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index a790b1ea..90038e75 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -393,4 +393,6 @@ global:
>  	ndctl_dimm_enable_key;
>  	ndctl_dimm_update_key;
>  	ndctl_dimm_update_passphrase;
> +	ndctl_dimm_disable_passphrase;
> +	ndctl_dimm_disable_key;
>  } LIBNDCTL_18;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 87384f71..cb58f89c 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -701,6 +701,7 @@ int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
>  bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm);
>  int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
>  		long ckey, long nkey);
> +int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
>  
>  enum ndctl_key_type {
>  	ND_USER_KEY,
> @@ -712,6 +713,7 @@ int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master,
>  		const char *keypath);
>  int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master,
>  		const char *keypath);
> +int ndctl_dimm_disable_key(struct ndctl_dimm *dimm, const char *keypath);
>  #else
>  static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
>  		const char *master, const char *keypath)
> @@ -724,6 +726,12 @@ static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
>  {
>  	return -EOPNOTSUPP;
>  }
> +
> +static inline int ndctl_dimm_disable_key(struct ndctl_dimm *dimm,
> +		const char *keypath)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  #ifdef __cplusplus
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index 9d109b34..21f1b834 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -90,6 +90,7 @@ static struct cmd_struct commands[] = {
>  	{ "start-scrub", { cmd_start_scrub } },
>  	{ "enable-passphrase", { cmd_passphrase_setup } },
>  	{ "update-passphrase", { cmd_passphrase_update } },
> +	{ "disable-passphrase", { cmd_disable_passphrase } },
>  	{ "list", { cmd_list } },
>  	{ "monitor", { cmd_monitor } },
>  	{ "help", { cmd_help } },
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
