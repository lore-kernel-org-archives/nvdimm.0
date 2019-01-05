Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BC94211A2DB8
 for <linux-nvdimm@lists.01.org>; Fri,  4 Jan 2019 16:07:49 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 02/12] ndctl: add passphrase update to ndctl
Date: Sat, 5 Jan 2019 00:07:46 +0000
Message-ID: <486ed11992eb33030875805937c874d40a94f84a.camel@intel.com>
References: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
 <154482175422.65434.6566526945900238068.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154482175422.65434.6566526945900238068.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <A32DAC36ECA98149B1267E93DDB653D1@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-12-14 at 14:09 -0700, Dave Jiang wrote:
> Add API call for triggering sysfs knob to update the security for a DIMM
> in libndctl. Also add the ndctl "update-passphrase" to trigger the
> operation.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                 |    4 
>  Documentation/ndctl/ndctl-enable-passphrase.txt |   35 ++
>  Documentation/ndctl/ndctl-update-passphrase.txt |   33 ++
>  builtin.h                                       |    2 

This and a few other files conflict with Dan's recent monitor/builtin
cleanups. Would you mind rebasing upon those? I've pushed those out in
the pending branch.

>  configure.ac                                    |   14 +
>  ndctl.spec.in                                   |    2 
>  ndctl/Makefile.am                               |    3 
>  ndctl/dimm.c                                    |   86 ++++-
>  ndctl/lib/Makefile.am                           |    8 
>  ndctl/lib/dimm.c                                |   39 ++
>  ndctl/lib/keys.c                                |  389 +++++++++++++++++++++++
>  ndctl/lib/libndctl.sym                          |    4 
>  ndctl/libndctl.h                                |   31 ++
>  ndctl/ndctl.c                                   |    2 
>  14 files changed, 639 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-enable-passphrase.txt
>  create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
>  create mode 100644 ndctl/lib/keys.c
> 
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index a30b139b..7ad6666b 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -47,7 +47,9 @@ man1_MANS = \
>  	ndctl-inject-smart.1 \
>  	ndctl-update-firmware.1 \
>  	ndctl-list.1 \
> -	ndctl-monitor.1
> +	ndctl-monitor.1 \
> +	ndctl-enable-passphrase.1 \
> +	ndctl-update-passphrase.1
>  
>  CLEANFILES = $(man1_MANS)
>  
> diff --git a/Documentation/ndctl/ndctl-enable-passphrase.txt b/Documentation/ndctl/ndctl-enable-passphrase.txt
> new file mode 100644
> index 00000000..8de5410c
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-enable-passphrase.txt
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-enable-passphrase(1)
> +==========================
> +
> +NAME
> +----
> +ndctl-enable-passphrase - enabling the security passphrase for a NVDIMM
                             ^enable
for consistency

> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl enable-passphrase' <dimm> [<options>]
> +
> +DESCRIPTION
> +-----------
> +Provide a generic interface for enabling security for NVDIMM.

Consider changing to:
Provide a generic interface to enable the security passphrase for the
NVDIMM.

Also, "Provide a generic interface to" can probably be replaced by
"Command to"

Same comments apply to the update-passphrase man page below.

> +It is expected that the master key has already been loaded into the user
> +key ring. The encrypted key blobs will be created in /etc/nvdimm directory
> +with the file name of "nvdimm-<hostname>-<dimm unique id>.blob".
> +
> +The command will fail if the nvdimm key is already in the user key ring and/or
> +the key blob already resides in /etc/nvdimm. Do not touch the /etc/nvdimm
> +directory and let ndctl manage the keys, unless you know what you are doing.
> +
> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-m::
> +--master=::
> +	Key name for the master key used to seal the NVDIMM security keys.
> +
> +include::../copyright.txt[]
> diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
> new file mode 100644
> index 00000000..9ed39cca
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-update-passphrase.txt
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-update-passphrase(1)
> +==========================
> +
> +NAME
> +----
> +ndctl-update-passphrase - update the security passphrase for a NVDIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl update-passphrase' <dimm> [<options>]
> +
> +DESCRIPTION
> +-----------
> +Provide a generic interface for updating security key for NVDIMM.
> +It is expected that the current and the new (if new master key is desired)
> +master key has already been loaded into the user key ring. The new encrypted
> +key blobs will be created in /etc/nvdimm directory
> +with the file name of "nvdimm-<hostname>-<dimm unique id>.blob".
> +
> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-m::
> +--master::
> +	New key name for the master key to seal the new nvdimm key, or the
> +	existing master key name. i.e trusted:master-key.
> +
> +include::../copyright.txt[]
> diff --git a/builtin.h b/builtin.h
> index 675a6ce7..ed018d96 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -48,4 +48,6 @@ int cmd_bat(int argc, const char **argv, void *ctx);
>  #endif
>  int cmd_update_firmware(int argc, const char **argv, void *ctx);
>  int cmd_inject_smart(int argc, const char **argv, void *ctx);
> +int cmd_passphrase_setup(int argc, const char **argv, void *ctx);
> +int cmd_passphrase_update(int argc, const char **argv, void *ctx);
>  #endif /* _NDCTL_BUILTIN_H_ */
> diff --git a/configure.ac b/configure.ac
> index bb6b0332..ac4f56c3 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -153,6 +153,20 @@ fi
>  AC_SUBST([systemd_unitdir])
>  AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
>  
> +AC_ARG_WITH([keyutils],
> +	    AS_HELP_STRING([--with-keyutils],
> +			[Enable keyutils functionality (security).  @<:@default=yes@:>@]), [], [with_keyutils=yes])
> +
> +if test "x$with_keyutils" = "xyes"; then
> +	AC_CHECK_HEADERS([keyutils.h],,[
> +		AC_MSG_ERROR([keyutils.h not found, consider installing
> +			      keyutils-libs-devel.])
> +		])
> +fi
> +AS_IF([test "x$with_keyutils" = "xyes"],
> +	[AC_DEFINE([ENABLE_KEYUTILS], [1], [Enable keyutils support])])
> +AM_CONDITIONAL([ENABLE_KEYUTILS], [test "x$with_keyutils" = "xyes"])
> +
>  my_CFLAGS="\
>  -D DEF_CONF_FILE='\"${sysconfdir}/ndctl/monitor.conf\"' \
>  -Wall \

We should be passing the /etc/ndctl/keys path here. Once you rebase
upon Dan's recent reworks, see how monitor.conf is now setup.

> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 26396d4a..66466db6 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -21,6 +21,7 @@ BuildRequires:	pkgconfig(uuid)
>  BuildRequires:	pkgconfig(json-c)
>  BuildRequires:	pkgconfig(bash-completion)
>  BuildRequires:	pkgconfig(systemd)
> +BuildRequires:	keyutils-libs-devel
>  
>  %description
>  Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
> @@ -119,6 +120,7 @@ make check
>  %{bashcompdir}/
>  %{_sysconfdir}/ndctl/monitor.conf
>  %{_unitdir}/ndctl-monitor.service
> +%{_sysconfdir}/ndctl/keys/
>  
>  %files -n daxctl
>  %defattr(-,root,root)
> 

<...>

> diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
> new file mode 100644
> index 00000000..a005c6a6
> --- /dev/null
> +++ b/ndctl/lib/keys.c
> @@ -0,0 +1,389 @@
> +// SPDX-License-Identifier: GPL-2.0
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
> +#define PATH_SIZE	512
> +#define HOSTNAME_SIZE	64
> +#define DESC_SIZE	128
> +#define KEY_CMD_SIZE	128
> +
> +static int get_key_path(struct ndctl_dimm *dimm, char *path,
> +		enum ndctl_key_type key_type)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	char hostname[HOSTNAME_SIZE];
> +	int rc;
> +
> +	rc = gethostname(hostname, HOSTNAME_SIZE-1);

Spaces around the '-'

Also do we need to subtract 1? The man page says "gethostname() returns
the null-terminated hostname in the character array name, which has a
length of len bytes." Which means if the array was 64B it will use all
of it to fill in the hostname + NUL.

And finally, why redefine HOSTNAME_SIZE, instead of using
HOST_NAME_MAX. Perhaps malloc it since we don't know its size.

> +	if (rc < 0) {
> +		err(ctx, "gethostname: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +
> +	if (key_type == ND_USER_OLD_KEY) {
> +		rc = sprintf(path, "%s/nvdimmold_%s_%s.blob",
> +				ND_PASS_PATH,
> +				ndctl_dimm_get_unique_id(dimm),
> +				hostname);
> +	} else {
> +		rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
> +				ND_PASS_PATH,
> +				ndctl_dimm_get_unique_id(dimm),
> +				hostname);
> +	}
> +
> +	if (rc < 0) {
> +		err(ctx, "sprintf: %s\n", strerror(errno));

This applies to everywhere else - an error starting with "sprintf: " is
very debug centric, i.e. a user may not know what to make of it. It
might be friendlier to describe what went wrong. So in this case:

		err(ctx, "error setting path: %s\n", strerror(errno));

> +		return -errno;
> +	}
> +
> +	return 0;
> +}
> +
> +static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
> +		enum ndctl_key_type key_type)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	int rc;
> +
> +	if (key_type == ND_USER_OLD_KEY)
> +		rc = sprintf(desc, "nvdimm-old:%s",
> +				ndctl_dimm_get_unique_id(dimm));
> +	else
> +		rc = sprintf(desc, "nvdimm:%s",
> +				ndctl_dimm_get_unique_id(dimm));
> +
> +	if (rc < 0) {
> +		err(ctx, "sprintf: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +
> +	return 0;
> +}
> +
> +static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
> +{
> +	struct stat st;
> +	FILE *bfile = NULL;
> +	ssize_t read;
> +	int rc;
> +	char *blob, *pl;
> +	char prefix[] = "load ";
> +
> +	rc = stat(path, &st);
> +	if (rc < 0) {
> +		err(ctx, "stat: %s\n", strerror(errno));
> +		return NULL;
> +	}
> +	if ((st.st_mode & S_IFMT) != S_IFREG) {
> +		err(ctx, "%s not a regular file\n", path);
> +		return NULL;
> +	}
> +
> +	if (st.st_size == 0 || st.st_size > 4096) {
> +		err(ctx, "Invalid blob file size\n");
> +		return NULL;
> +	}
> +
> +	*size = st.st_size + sizeof(prefix) - 1;
> +	blob = malloc(*size);
> +	if (!blob) {
> +		err(ctx, "Unable to allocate memory for blob\n");
> +		return NULL;
> +	}
> +
> +	bfile = fopen(path, "r");
> +	if (!bfile) {
> +		err(ctx, "Unable to open %s: %s\n", path, strerror(errno));
> +		free(blob);
> +		return NULL;
> +	}
> +
> +	memcpy(blob, prefix, sizeof(prefix) - 1);
> +	pl = blob + sizeof(prefix) - 1;
> +	read = fread(pl, st.st_size, 1, bfile);
> +	if (read < 0) {
> +		err(ctx, "Fail to read from blob file: %s\n",
			  ^Failed

> +				strerror(errno));
> +		free(blob);
> +		fclose(bfile);
> +		return NULL;
> +	}
> +
> +	fclose(bfile);
> +	return blob;
> +}
> +
> +static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
> +		enum ndctl_key_type key_type)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	char desc[DESC_SIZE];
> +	int rc;
> +
> +	rc = get_key_desc(dimm, desc, key_type);
> +	if (rc < 0) {
> +		err(ctx, "sprintf: %d\n", rc);
> +		return rc;
> +	}

get_key_desc also prints the same error message, so this seems
redundant. This seems to be the only spot for this call with an extra
print.

> +
> +	return keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted", desc, 0);
> +}
> +
> +static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
> +		const char *master)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	char desc[DESC_SIZE];
> +	char path[PATH_SIZE];
> +	char cmd[KEY_CMD_SIZE];
> +	key_serial_t key;
> +	void *buffer;
> +	int rc;
> +	ssize_t size;
> +	FILE *fp;
> +	ssize_t wrote;
> +	struct stat st;
> +
> +	if (ndctl_dimm_is_active(dimm)) {
> +		err(ctx, "regions active on %s, op failed\n",
> +				ndctl_dimm_get_devname(dimm));
> +		return -EBUSY;
> +	}
> +
> +	rc = get_key_desc(dimm, desc, ND_USER_KEY);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* make sure it's not already in the key ring */
> +	key = keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted", desc, 0);
> +	if (key > 0) {
> +		err(ctx, "key already in user keyring, can't create new.\n");

Perhaps just "Error: key is already present in the user keyring."

> +		return -EAGAIN;

Why EAGAIN? EAGAIN usually means "try again later", which doesn't make
sense in this case. EEXIST might be a better option. Same below.

> +	}
> +
> +	rc = get_key_path(dimm, path, ND_USER_KEY);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = stat(path, &st);
> +	if (rc == 0) {
> +		err(ctx, "%s already exists!\n", path);
> +		return -EAGAIN;
> +	}
> +
> +	rc = sprintf(cmd, "new enc32 %s 32", master);
> +	if (rc < 0) {
> +		err(ctx, "sprintf: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +
> +	key = add_key("encrypted", desc, cmd, strlen(cmd),
> +			KEY_SPEC_USER_KEYRING);
> +	if (key < 0) {
> +		err(ctx, "add_key failed: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +
> +	size = keyctl_read_alloc(key, &buffer);
> +	if (size < 0) {
> +		err(ctx, "keyctl_read_alloc failed: %ld\n", size);
> +		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
> +		return rc;
> +	}
> +
> +	fp = fopen(path, "w");
> +	if (!fp) {
> +		rc = -errno;
> +		err(ctx, "fopen: %s\n", strerror(errno));

Perhaps print the error similar to the other fopen in this file - i.e.
"Unable to open %s: %s", path, strerror...

> +		free(buffer);
> +		return rc;
> +	}
> +
> +	 wrote = fwrite(buffer, size, 1, fp);

We're writing a character stream here yes? If so, we should make the
'size' argument '1', and 'nitems' as the number of characters (buffer
len). fwrite will return the number of items written, which could be
less than 'nitems', so we should subsequently check for (wrote <
nitems) to catch a partial write.

> +	 if (wrote < 0) {
> +		 rc = -errno;
> +		 err(ctx, "fwrite failed: %s\n", strerror(errno));

Similar to the cases, "Failed to write to <path>: error-string" is more
user friendly.

> +		 free(buffer);
> +		 return rc;
> +	 }
> +
> +	 fclose(fp);
> +	 free(buffer);
> +	 return key;
> +}
> +
> +static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
> +		enum ndctl_key_type key_type)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	key_serial_t key;
> +	char desc[DESC_SIZE];
> +	char path[PATH_SIZE];
> +	int rc;
> +	char *blob;
> +	int size;
> +
> +	if (ndctl_dimm_is_active(dimm)) {
> +		err(ctx, "regions active on %s, op failed\n",
> +				ndctl_dimm_get_devname(dimm));
> +		return -EBUSY;
> +	}
> +
> +	rc = get_key_desc(dimm, desc, key_type);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = get_key_path(dimm, path, key_type);
> +	if (rc < 0)
> +		return rc;
> +
> +	blob = load_key_blob(ctx, path, &size);
> +	if (!blob)
> +		return -ENOMEM;
> +
> +	key = add_key("encrypted", desc, blob, size, KEY_SPEC_USER_KEYRING);
> +	free(blob);
> +	if (key < 0) {
> +		err(ctx, "add_key failed: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +
> +	return key;
> +}
> +
> +/*
> + * The function will check to see if the existing key is there and remove
> + * from user key ring if it is. Rename the existing key blob to old key
> + * blob, and then attempt to inject the key as old key into the user key
> + * ring.
> + */
> +static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	int rc;
> +	key_serial_t key;
> +	char old_path[PATH_SIZE];
> +	char new_path[PATH_SIZE];
> +
> +	if (ndctl_dimm_is_active(dimm)) {
> +		err(ctx, "regions active on %s, op failed\n",
> +				ndctl_dimm_get_devname(dimm));
> +		return -EBUSY;
> +	}
> +
> +	key = dimm_check_key(dimm, ND_USER_KEY);
> +	if (key > 0)
> +		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
> +
> +	rc = get_key_path(dimm, old_path, ND_USER_KEY);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = get_key_path(dimm, new_path, ND_USER_OLD_KEY);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = rename(old_path, new_path);

Probably add an err() here printing the strerror() for why the rename
failed.

> +	if (rc < 0)
> +		return -errno;
> +
> +	return dimm_load_key(dimm, ND_USER_OLD_KEY);
> +}
> +
> +static int dimm_remove_key(struct ndctl_dimm *dimm,
> +		enum ndctl_key_type key_type)
> +{
> +	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +	key_serial_t key;
> +	char path[PATH_SIZE];
> +	int rc;
> +
> +	key = dimm_check_key(dimm, key_type);
> +	if (key > 0)
> +		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
> +
> +	rc = get_key_path(dimm, path, key_type);
> +	if (rc < 0) {
> +		err(ctx, "get key file path failed: %d\n", rc);
> +		return rc;
> +	}

get_key_path already prints the error.

> +
> +	rc = unlink(path);
> +	if (rc < 0) {
> +		err(ctx, "unlink: %s\n", strerror(errno));

Add 'path' into the error message.

> +		return -errno;
> +	}
> +
> +	return 0;
> +}
> +
> +NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
> +		const char *master)
> +{
> +	key_serial_t key;
> +	int rc;
> +
> +	key = dimm_create_key(dimm, master);
> +	if (key < 0)
> +		return (int)key;

Is the typecast needed here?

> +
> +	rc = ndctl_dimm_update_passphrase(dimm, 0, key);
> +	if (rc < 0) {
> +		dimm_remove_key(dimm, ND_USER_KEY);
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
> +		const char *master)
> +{
> +	int rc;
> +	key_serial_t old_key, new_key;
> +
> +	/*
> +	 * 1. check if current key is loaded and remove
> +	 * 2. move current key blob to old key blob
> +	 * 3. load old key blob
> +	 * 4. trigger change key with old and key key

s/key key/new key/ ?

> +	 * 5. remove old key
> +	 * 6. remove old key blob
> +	 */
> +	old_key = move_key_to_old(dimm);
> +	if (old_key < 0)
> +		return old_key;
> +
> +	new_key = dimm_create_key(dimm, master);
> +	/* need to create new key here */
> +	if (new_key < 0) {
> +		new_key = dimm_load_key(dimm, ND_USER_KEY);
> +		if (new_key < 0)
> +			return new_key;
> +	}
> +
> +	rc = ndctl_dimm_update_passphrase(dimm, old_key, new_key);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = dimm_remove_key(dimm, ND_USER_OLD_KEY);
> +	if (rc < 0)
> +		return rc;
> +
> +	return 0;
> +}
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 1bd63fa1..a790b1ea 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -389,4 +389,8 @@ global:
>  LIBNDCTL_19 {
>  global:
>  	ndctl_dimm_get_security;
> +	ndctl_dimm_security_supported;
> +	ndctl_dimm_enable_key;
> +	ndctl_dimm_update_key;
> +	ndctl_dimm_update_passphrase;
>  } LIBNDCTL_18;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index a9f9167a..00ec1907 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -19,6 +19,7 @@
>  #include <unistd.h>
>  #include <errno.h>
>  #include <limits.h>
> +#include <keyutils.h>
>  
>  #ifdef HAVE_LIBUUID
>  #include <uuid/uuid.h>
> @@ -681,6 +682,11 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
>  struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
>  int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
>  
> +#define ND_PASSPHRASE_SIZE	32
> +#define ND_PASS_PATH		"/etc/ndctl/keys"

This should not be hard coded, should be derived from autoconf (I think
monitor now does this correctly, so could copy from there).

> +#define ND_KEY_DESC_LEN	22
> +#define ND_KEY_DESC_PREFIX  7
> +
>  enum nd_security_state {
>  	ND_SECURITY_INVALID = -1,
>  	ND_SECURITY_UNSUPPORTED = 0,
> @@ -693,6 +699,31 @@ enum nd_security_state {
>  
>  int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
>  		enum nd_security_state *sstate);
> +bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm);
> +int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
> +		long ckey, long nkey);
> +
> +enum ndctl_key_type {
> +	ND_USER_KEY,
> +	ND_USER_OLD_KEY,
> +};
> +
> +#ifdef ENABLE_KEYUTILS
> +int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
> +int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master);
> +#else
> +static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
> +		const char *master)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
> +		const char *master)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
>  
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index 73dabfac..4336c94c 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -88,6 +88,8 @@ static struct cmd_struct commands[] = {
>  	{ "inject-smart", cmd_inject_smart },
>  	{ "wait-scrub", cmd_wait_scrub },
>  	{ "start-scrub", cmd_start_scrub },
> +	{ "enable-passphrase", cmd_passphrase_setup },
> +	{ "update-passphrase", cmd_passphrase_update },
>  	{ "list", cmd_list },
>  	{ "monitor", cmd_monitor},
>  	{ "help", cmd_help },
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
