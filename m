Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22C6021173C84
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 17:59:16 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 22-v6so16665521oiz.2
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 17:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
 <153938332661.20740.4982467030035033155.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153938332661.20740.4982467030035033155.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Oct 2018 17:59:03 -0700
Message-ID: <CAPcyv4j9Du71NbskGBXgKtSzpc5P=WXiefSR7GXohoDGMwCwdw@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] ndctl: add update to security support
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

On Fri, Oct 12, 2018 at 3:28 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add API call for triggering sysfs knob to update the security for a DIMM
> in libndctl. Also add the ndctl "update-security" to trigger that as well.
> ndctl does not actually handle the passphrase file. It only initiates the
> update and expects all the necessary mechanisms are already in place.

One of the mistakes of create-namespace was trying to combine multiple
verbs ('create' and 'reconfigure') into one command. Since this is
operating on the passphrase state of the DIMM and we may have
non-passphrase based security in the future lets make the command set:

enable-passphrase
disable-passphrase
change-passphrase

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am               |    3 -
>  Documentation/ndctl/ndctl-update-security.txt |   56 ++++++++++
>  builtin.h                                     |    1
>  configure.ac                                  |    5 +
>  ndctl.spec.in                                 |    1
>  ndctl/Makefile.am                             |    3 -
>  ndctl/dimm.c                                  |   90 ++++++++++++++--
>  ndctl/lib/Makefile.am                         |    4 +
>  ndctl/lib/dimm.c                              |   24 ++++
>  ndctl/lib/keys.c                              |  139 +++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym                        |    3 +
>  ndctl/libndctl.h                              |   14 +++
>  ndctl/ndctl.c                                 |    1
>  13 files changed, 330 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-update-security.txt
>  create mode 100644 ndctl/lib/keys.c
>
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index a30b139b..2c064c3a 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -47,7 +47,8 @@ man1_MANS = \
>         ndctl-inject-smart.1 \
>         ndctl-update-firmware.1 \
>         ndctl-list.1 \
> -       ndctl-monitor.1
> +       ndctl-monitor.1 \
> +       ndctl-update-security.1
>
>  CLEANFILES = $(man1_MANS)
>
> diff --git a/Documentation/ndctl/ndctl-update-security.txt b/Documentation/ndctl/ndctl-update-security.txt
> new file mode 100644
> index 00000000..96d519b1
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-update-security.txt
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-update-security(1)
> +========================
> +
> +NAME
> +----
> +ndctl-update-security - enabling or update the security passphrase for a
> +NVDIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl update-security' <dimm> [<options>]
> +
> +DESCRIPTION
> +-----------
> +Provide a generic interface for enabling or updating security passphrase for
> +NVDIMM. The use of this depends on support from the underlying libndctl,
> +kernel, as well as the platform itself.

No need to mention "underlying libndctl". The packaging guarantees
that the library version is always installed from the same package as
the binary. I.e. you can't update the binaries without it force
updating to the latest library.

I'd rewrite this to be in terms of something they can detect. I.e.
something like "if 'ndctl list -D' shows a 'security:' attribute then
passphrase management is available".

Hmm, now as I type that I wonder if we should call all of this
'passphrase' in all the user facing names? Since 'security' mechanisms
can change from one DIMM vendor to the next.

> +
> +For the reference passphrase setup, /etc/nvdimm.passwd is read for passphrase

I assume that's where the upcall binary is going to look? Lets convert
that to /etc/ndctl/passphrase.d so we can support a file per dimm
device.

I'd also drop the mention of "reference" and instead provide a way to
read passphrase material over stdio or optionally a file.

I think we need a:

generate-passphrase

...helper that takes an nmemX list and spits out properly formatted /
randomly generated passphrase for the given DIMM.

That way you can do something like:

ndctl generate-passphrase nmem{0,1,2,3} > /etc/ndctl/passphrase.d/keys.conf
ndctl enable-passphrase < /etc/ndctl/passphrase.d/keys.conf

...where enable-passphrase should be able to identify the DIMM to
operate on by description-id.

> +retrieval:
> +
> +The nvdimm.passwd is formatted as:
> +<description id>:<passphrase with padded 0 to 32bytes>
> +cdab-0a-07e0-feffffff:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> +
> +To update a DIMM that has passphrase already enabled, the format is done as:
> +<description id>:<new passphrase with padded 0 to 32bytes>:<old passphrase with padded 0
> +to 32 bytes>
> +
> +cdab-0a-07e0-feffffff:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> +
> +The accepted key will replace the old payload with the new payload in the
> +cached key that resides in the kernel key ring.

I think having an extended format for the change key operation is
awkward. We could just make the requirement that when you want to
change the key input stream needs to list the key exactly twice. The
first occurrence is the old key and the second the new one. Then you
could do something like:

cat old-keys.conf keys.conf | ndctl change-passphrase

> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-i::
> +--insecure::
> +       Using the default reference support to parse the nvdimm passphrase
> +       file, inject the key, and initiate update operation. This is labeled
> +       as insecure as it just provides a reference to how to inject keys
> +       for the nvdimm. The passphrase is in clear text and is not considered
> +       as secure as it can be.

If the command supports taking input over stdio then we're secure as
we can be unless / until we can update the kernel implementation to
take TPM or other wrapped keys.

> +-e::
> +--exec::
> +       The external binary module that would inject the passphrase and
> +       initiate the update operation. Use this or -i, not both.

Does stdio support negate the need for this option?

> +
> +include::../copyright.txt[]
> diff --git a/builtin.h b/builtin.h
> index 675a6ce7..37404c79 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -48,4 +48,5 @@ int cmd_bat(int argc, const char **argv, void *ctx);
>  #endif
>  int cmd_update_firmware(int argc, const char **argv, void *ctx);
>  int cmd_inject_smart(int argc, const char **argv, void *ctx);
> +int cmd_key_update(int argc, const char **argv, void *ctx);
>  #endif /* _NDCTL_BUILTIN_H_ */
> diff --git a/configure.ac b/configure.ac
> index bb6b0332..1cfd9718 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -153,6 +153,11 @@ fi
>  AC_SUBST([systemd_unitdir])
>  AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
>
> +AC_CHECK_HEADERS([keyutils.h],,[
> +       AC_MSG_ERROR([keyutils.h not found, consider installing
> +                     keyutils-libs-devel.])
> +                 ])

It shouldn't be an error to build without keyutils support. I'd gate
this with an optional "--with=keyutils" specified to the configure
script.

> +
>  my_CFLAGS="\
>  -D DEF_CONF_FILE='\"${sysconfdir}/ndctl/monitor.conf\"' \
>  -Wall \
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 26396d4a..f57b4fd5 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -21,6 +21,7 @@ BuildRequires:        pkgconfig(uuid)
>  BuildRequires: pkgconfig(json-c)
>  BuildRequires: pkgconfig(bash-completion)
>  BuildRequires: pkgconfig(systemd)
> +BuildRequires: keyutils

'keyutils' does not provide any build material. Looking at nfs-utils
it only has "Requires: keyutils", and looking even closer it was only
required there because of
https://bugzilla.redhat.com/show_bug.cgi?id=769724

So I think make this "BuildRequires: keyutils-libs-devel".

>
>  %description
>  Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 8a5e5f87..5b62251b 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -30,7 +30,8 @@ ndctl_LDADD =\
>         ../libutil.a \
>         $(UUID_LIBS) \
>         $(KMOD_LIBS) \
> -       $(JSON_LIBS)
> +       $(JSON_LIBS) \
> +       -lkeyutils

Should be gated on a conditional if keyutils support is enabled.

>
>  if ENABLE_TEST
>  ndctl_SOURCES += ../test/libndctl.c \
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 699ab57d..62a102b4 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -40,6 +40,20 @@ struct action_context {
>         struct update_context update;
>  };
>
> +static struct parameters {
> +       const char *bus;
> +       const char *outfile;
> +       const char *infile;
> +       const char *labelversion;
> +       const char *key_exec;
> +       bool force;
> +       bool json;
> +       bool verbose;
> +       bool key_insecure;
> +} param = {
> +       .labelversion = "1.1",
> +};
> +
>  static int action_disable(struct ndctl_dimm *dimm, struct action_context *actx)
>  {
>         if (ndctl_dimm_is_active(dimm)) {
> @@ -824,17 +838,44 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
>         return rc;
>  }
>
> -static struct parameters {
> -       const char *bus;
> -       const char *outfile;
> -       const char *infile;
> -       const char *labelversion;
> -       bool force;
> -       bool json;
> -       bool verbose;
> -} param = {
> -       .labelversion = "1.1",
> -};
> +static int action_key(struct ndctl_dimm *dimm,
> +               struct action_context *actx)
> +{
> +       int rc, po_valid, pn_valid;
> +       char old_payload[ND_PASSPHRASE_SIZE];
> +       char new_payload[ND_PASSPHRASE_SIZE];
> +       key_serial_t old_key, new_key;
> +       char *po;
> +
> +       if (param.key_exec)
> +               return execl(param.key_exec, ndctl_dimm_get_devname(dimm),
> +                               ndctl_dimm_get_unique_id(dimm), (char *)NULL);
> +
> +       if (!param.key_insecure)
> +               return -EINVAL;
> +
> +       rc = ndctl_dimm_get_key_payload(dimm, new_payload, &pn_valid,
> +                       old_payload, &po_valid);
> +       if (rc < 0)
> +               return rc;
> +
> +       /*
> +        * If we are turning on security rather than updating, then
> +        * we would not have an old key.
> +        */
> +       po = po_valid ? old_payload : NULL;
> +       rc = ndctl_dimm_add_keys(dimm, &new_key, new_payload,
> +                       &old_key, po);
> +       if (rc < 0)
> +               return rc;
> +
> +       /* now do actual writing to update */
> +       rc = ndctl_dimm_set_change_key(dimm, old_key, new_key);
> +       if (rc < 0)
> +               return rc;
> +
> +       return rc;
> +}
>
>  static int __action_init(struct ndctl_dimm *dimm,
>                 enum ndctl_namespace_version version, int chk_only)
> @@ -925,6 +966,12 @@ OPT_BOOLEAN('f', "force", &param.force, \
>  OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
>         "namespace label specification version (default: 1.1)")
>
> +#define KEY_OPTIONS() \
> +OPT_BOOLEAN('i', "insecure", &param.key_insecure, \
> +               "insecure reference passphrase update method"), \
> +OPT_STRING('e', "exec", &param.key_exec, "external-exec", \
> +               "external exec module for passphrase update")
> +
>  static const struct option read_options[] = {
>         BASE_OPTIONS(),
>         READ_OPTIONS(),
> @@ -954,6 +1001,12 @@ static const struct option init_options[] = {
>         OPT_END(),
>  };
>
> +static const struct option key_options[] = {
> +       BASE_OPTIONS(),
> +       KEY_OPTIONS(),
> +       OPT_END(),
> +};
> +
>  static int dimm_action(int argc, const char **argv, void *ctx,
>                 int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
>                 const struct option *options, const char *usage)
> @@ -1024,6 +1077,11 @@ static int dimm_action(int argc, const char **argv, void *ctx,
>                 }
>         }
>
> +       if (action == action_key && param.key_insecure && param.key_exec) {
> +                       usage_with_options(u, options);
> +                       return -EINVAL;
> +       }
> +
>         if (param.verbose)
>                 ndctl_set_log_priority(ctx, LOG_DEBUG);
>
> @@ -1181,3 +1239,13 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
>                         count > 1 ? "s" : "");
>         return count >= 0 ? 0 : EXIT_FAILURE;
>  }
> +
> +int cmd_key_update(int argc, const char **argv, void *ctx)
> +{
> +       int count = dimm_action(argc, argv, ctx, action_key, key_options,
> +                       "ndctl update-security <nmem0> [<nmem1>..<nmemN>] [<options>]");
> +
> +       fprintf(stderr, "security updated for %d nmem%s.\n", count >= 0 ? count : 0,
> +                       count > 1 ? "s" : "");
> +       return count >= 0 ? 0 : EXIT_FAILURE;
> +}
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index 77970399..245b78a9 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -22,13 +22,15 @@ libndctl_la_SOURCES =\
>         msft.c \
>         ars.c \
>         firmware.c \
> +       keys.c \
>         libndctl.c
>
>  libndctl_la_LIBADD =\
>         ../../daxctl/lib/libdaxctl.la \
>         $(UDEV_LIBS) \
>         $(UUID_LIBS) \
> -       $(KMOD_LIBS)
> +       $(KMOD_LIBS) \
> +       $(KEYUTILS_LIBS)

Does this work? I thought these _LIBS variables were generated by the
autotools pkgconfig support.

>
>  EXTRA_DIST += libndctl.sym
>
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index 4470d5fe..c9ef894a 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -599,3 +599,27 @@ NDCTL_EXPORT int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm,
>
>         return sysfs_read_attr(ctx, path, state);
>  }
> +
> +static int ndctl_dimm_write_security(struct ndctl_dimm *dimm, const char *cmd)

If it's static, it does not need the ndctl_dimm_ prefix.

> +{
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +       char *path = dimm->dimm_buf;
> +       int len = dimm->buf_len;
> +
> +       if (snprintf(path, len, "%s/security", dimm->dimm_path) >= len) {
> +               err(ctx, "%s: buffer too small!\n",
> +                               ndctl_dimm_get_devname(dimm));
> +               return -ERANGE;
> +       }
> +
> +       return sysfs_write_attr(ctx, path, cmd);
> +}
> +
> +NDCTL_EXPORT int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm,
> +               key_serial_t ckey, key_serial_t nkey)
> +{
> +       char buf[SYSFS_ATTR_SIZE];
> +
> +       sprintf(buf, "update %d %d\n", ckey, nkey);
> +       return ndctl_dimm_write_security(dimm, buf);
> +}

I don't think we need to have an ndctl api that exposes the raw
keyutils details. I think the ndctl apis should only deal in
passphrases and DIMMs.

It might be useful to have a helper api that takes a file stream and
converts it to a key list as that seems to be a common operation that
the ndctl passphrase operations will want to do.

> diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
> new file mode 100644
> index 00000000..b21d11f0
> --- /dev/null
> +++ b/ndctl/lib/keys.c
> @@ -0,0 +1,139 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

Checkpatch complained to me that the "official" way to do SPDX in C
code was with a C++ // style comment. Who knew?

> +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> +
> +#include <stdio.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <sys/param.h>
> +#include <keyutils.h>
> +#include <syslog.h>
> +
> +#include <ndctl.h>
> +#include <ndctl/libndctl.h>
> +#include "private.h"
> +
> +NDCTL_EXPORT int ndctl_dimm_get_key_payload(struct ndctl_dimm *dimm,
> +               char *pass, int *pass_valid,
> +               char *oldpass, int *oldpass_valid)

What's the intended use case of this api, and the next?

> +{
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +       ssize_t rc = 0;
> +       static FILE *fp;
> +       const char *dimm_id;
> +       size_t size = 0, i;
> +       char *line = NULL, *desc, *pass1, *pass2;
> +       int found = 0, comment = 0;
> +
> +       *pass_valid = 0;
> +       *oldpass_valid = 0;
> +
> +       dimm_id = ndctl_dimm_get_unique_id(dimm);
> +       if (!dimm_id)
> +               return -EINVAL;
> +
> +       fp = fopen(PASS_PATH, "r+");
> +       if (!fp) {
> +               err(ctx, "fopen: %s\n", strerror(errno));
> +               return -errno;
> +       }
> +
> +       while ((rc = getline(&line, &size, fp)) != -1) {
> +               /* skip comments */
> +               for (i = 0; i < size; i++) {
> +                       if (isspace(line[i]))
> +                               continue;
> +                       if (line[i] == '#')
> +                               comment = 1;
> +               }
> +
> +               if (comment) {
> +                       comment = 0;
> +                       continue;
> +               }
> +
> +               desc = strtok(line, ":");
> +               if (!desc)
> +                       break;
> +               if (strcmp(desc, dimm_id) == 0) {
> +                       found = 1;
> +                       rc = 0;
> +                       break;
> +               }
> +       }
> +
> +       memset(oldpass, 0, ND_PASSPHRASE_SIZE);
> +       memset(pass, 0, ND_PASSPHRASE_SIZE);
> +       if (rc == 0 && found) {
> +               pass1 = strtok(NULL, ":");
> +               pass2 = strtok(NULL, ":");
> +               if (!pass1) {
> +                       rc = -EINVAL;
> +                       goto out;
> +               }
> +
> +               if (strlen(pass1) > ND_PASSPHRASE_SIZE)
> +                       pass1[ND_PASSPHRASE_SIZE] = '\0';
> +
> +               if (pass2 && strlen(pass2) > ND_PASSPHRASE_SIZE)
> +                       pass2[ND_PASSPHRASE_SIZE] = '\0';
> +
> +               memcpy(pass, pass1, strlen(pass1));
> +               *pass_valid = 1;
> +
> +               if (pass2) {
> +                       memcpy(oldpass, pass2, strlen(pass2));
> +                       *oldpass_valid = 1;
> +               }
> +       } else
> +               rc = -ENXIO;
> +
> +out:
> +       free(line);
> +       fclose(fp);
> +       return rc;
> +}
> +
> +NDCTL_EXPORT int ndctl_dimm_add_keys(struct ndctl_dimm *dimm,
> +               key_serial_t *new_key, const char *payload1,
> +               key_serial_t *old_key, const char *payload2)
> +{
> +       int rc;
> +       char desc[ND_KEY_DESC_LEN + ND_KEY_DESC_PREFIX];
> +       char odesc[ND_KEY_DESC_LEN + 4 + ND_KEY_DESC_PREFIX];
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +
> +       rc = sprintf(desc, "nvdimm:%s", ndctl_dimm_get_unique_id(dimm));
> +       if (rc < 0) {
> +               err(ctx, "sprintf: %s\n", strerror(errno));
> +               return -errno;
> +       }
> +
> +       rc = sprintf(odesc, "nvdimm_old:%s", ndctl_dimm_get_unique_id(dimm));
> +       if (rc < 0) {
> +               err(ctx, "sprintf: %s\n", strerror(errno));
> +               return -errno;
> +       }
> +
> +       *new_key = add_key("logon", desc, payload1, ND_PASSPHRASE_SIZE,
> +                       KEY_SPEC_USER_KEYRING);
> +       if (*new_key == -1) {
> +               err(ctx, "add_key: %s\n", strerror(errno));
> +               return -errno;
> +       }
> +
> +       if (payload2) {
> +               *old_key = add_key("logon", odesc, payload2,
> +                               ND_PASSPHRASE_SIZE, KEY_SPEC_USER_KEYRING);
> +               if (*old_key == -1) {
> +                       err(ctx, "add_key: %s\n", strerror(errno));
> +                       return -errno;
> +               }
> +       } else
> +               *old_key = 0;
> +
> +       return 0;
> +}

I think we need a family of apis that makes it straightforward for an
application to handle passphrases.

ndctl_dimm_set_current_passphrase - cache a passphrase on the DIMM object
ndctl_dimm_set_next_passphrase - cache a passphrase on the DIMM object
ndctl_dimm_get_current_passphrase - return the cached passphrase
ndctl_dimm_get_next_passphrase - return the cached next passphrase
ndctl_dimm_enable_passphrase - try to turn on security with the cached
passphrase
ndctl_dimm_disable_passphrase - disable, clear out cached passphrase
ndctl_dimm_change_passphrase - use cached current and next passphrases
to perform key update to kernel, cache the next passphrase as current
ndctl_dimm_dump_current_passphrase - write the current configuration
ndctl_dimm_dump_next_passphrase - write the next
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
