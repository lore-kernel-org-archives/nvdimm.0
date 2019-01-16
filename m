Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F947211B7F85
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 20:41:18 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id t5so92121otk.1
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 20:41:18 -0800 (PST)
MIME-Version: 1.0
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
 <154749641327.63704.408766037773865134.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154749641327.63704.408766037773865134.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jan 2019 20:41:06 -0800
Message-ID: <CAPcyv4hORnh0Xx6Wi9z_2-P+3AULAPARR5miNCsbBjCSorf3jg@mail.gmail.com>
Subject: Re: [PATCH v8 03/12] ndctl: add disable security support
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 14, 2019 at 12:07 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add support for disable security to libndctl and also command line option
> of "disable-passphrase" for ndctl. This provides a way to disable security
> on the nvdimm.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                  |    3 +-
>  Documentation/ndctl/ndctl-disable-passphrase.txt |   33 +++++++++++++++++++
>  ndctl/builtin.h                                  |    1 +
>  ndctl/dimm.c                                     |   38 ++++++++++++++++++++--
>  ndctl/lib/dimm.c                                 |    9 +++++
>  ndctl/lib/keys.c                                 |   29 +++++++++++++++++
>  ndctl/lib/libndctl.sym                           |    2 +
>  ndctl/libndctl.h                                 |    8 +++++
>  ndctl/ndctl.c                                    |    1 +
>  9 files changed, 120 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-disable-passphrase.txt
>
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index 7ad6666b..31570a77 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -49,7 +49,8 @@ man1_MANS = \
>         ndctl-list.1 \
>         ndctl-monitor.1 \
>         ndctl-enable-passphrase.1 \
> -       ndctl-update-passphrase.1
> +       ndctl-update-passphrase.1 \
> +       ndctl-disable-passphrase.1
>
>  CLEANFILES = $(man1_MANS)
>
> diff --git a/Documentation/ndctl/ndctl-disable-passphrase.txt b/Documentation/ndctl/ndctl-disable-passphrase.txt
> new file mode 100644
> index 00000000..49f25898
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-disable-passphrase.txt
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-disable-passphrase(1)
> +===========================
> +
> +NAME
> +----
> +ndctl-disable-passphrase - disabling passphrase for an NVDIMM

How about, "Stop a DIMM from locking at power-loss and requiring a
passphrase to access media"

Similar to how enable-passphrase seems like an awkward name given how
much work it is doing, how about calling this command
"remove-passphrase"?

> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl disable-passphrase' <dimm> [<options>]

In the source it states:

    "ndctl disable-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]"

...that multiple DIMMs are supported. Like patch2 it would be nice if
the optional options were indeed optional, or not required altogether
if the key-encryption-key details are stored in a configuration file.

> +
> +DESCRIPTION
> +-----------
> +Provide a generic interface for disabling passphrase for NVDIMM.

Drop this sentence since this is implied.

> +
> +Search the user key ring for the associated NVDIMM.

"NVDIMM key", perhaps?

> If not found,
> +attempt to load the key blob from the default location. After disabling

Maybe drop the "default location" qualifier since I'm not sure what
the use case is for allowing non-default key material locations. Just
consider /etc/ndctl/keys like libnvdimm-sysfs. There's only one path,
take it or leave it. If a user wants to do a custom key management
scheme they can just avoid ndctl altogether.

> +the passphrase, remove the key and the key blob.

Ah, see, it *is* a "remove-passphrase" command.

> +
> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-p::
> +--key-path=::
> +       Path to where key related files resides. This parameter is optional
> +       and the default is set to /etc/ndctl/keys.
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
>                         param.key_path);
>  }
>
> +static int action_passphrase_disable(struct ndctl_dimm *dimm,
> +               struct action_context *actx)
> +{
> +       if (!ndctl_dimm_security_supported(dimm)) {
> +               error("%s: security operation not supported\n",
> +                               ndctl_dimm_get_devname(dimm));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       return ndctl_dimm_disable_key(dimm, param.key_path);
> +}
> +
>  static int __action_init(struct ndctl_dimm *dimm,
>                 enum ndctl_namespace_version version, int chk_only)
>  {
> @@ -953,12 +965,14 @@ OPT_BOOLEAN('f', "force", &param.force, \
>  OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
>         "namespace label specification version (default: 1.1)")
>
> -#define KEY_OPTIONS() \
> -OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
> -               "master key for security"), \
> +#define KEY_BASE_OPTIONS() \
>  OPT_FILENAME('p', "key-path", &param.key_path, "key-path", \
>                 "override the default key path")
>
> +#define KEY_OPTIONS() \
> +OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
> +               "master key for security")
> +

Same key-encryption-key recommendation as patch 2.

>  static const struct option read_options[] = {
>         BASE_OPTIONS(),
>         READ_OPTIONS(),
> @@ -988,8 +1002,15 @@ static const struct option init_options[] = {
>         OPT_END(),
>  };
>
> +static const struct option key_base_options[] = {
> +       BASE_OPTIONS(),
> +       KEY_BASE_OPTIONS(),
> +       OPT_END(),
> +};
> +
>  static const struct option key_options[] = {
>         BASE_OPTIONS(),
> +       KEY_BASE_OPTIONS(),
>         KEY_OPTIONS(),
>         OPT_END(),
>  };
> @@ -1253,3 +1274,14 @@ int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx)
>                         count > 1 ? "s" : "");
>         return count >= 0 ? 0 : EXIT_FAILURE;
>  }
> +
> +int cmd_disable_passphrase(int argc, const char **argv, void *ctx)
> +{
> +       int count = dimm_action(argc, argv, ctx, action_passphrase_disable,
> +                       key_base_options,
> +                       "ndctl disable-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
> +
> +       fprintf(stderr, "passphrase disabled %d nmem%s.\n", count >= 0 ? count : 0,
> +                       count > 1 ? "s" : "");
> +       return count >= 0 ? 0 : EXIT_FAILURE;
> +}
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index b64c9568..076ccbf6 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -663,3 +663,12 @@ NDCTL_EXPORT int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
>         sprintf(buf, "update %ld %ld\n", ckey, nkey);
>         return write_security(dimm, buf);
>  }
> +
> +NDCTL_EXPORT int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm,
> +               long key)
> +{
> +       char buf[SYSFS_ATTR_SIZE];
> +
> +       sprintf(buf, "disable %ld\n", key);
> +       return write_security(dimm, buf);
> +}
> diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
> index de18ddf7..6dfbfd49 100644
> --- a/ndctl/lib/keys.c
> +++ b/ndctl/lib/keys.c
> @@ -388,3 +388,32 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
>
>         return 0;
>  }
> +
> +NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm,
> +               const char *keypath)

    ndctl_dimm_remove_key()?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
