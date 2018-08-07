Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA589210DF5D4
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 16:35:44 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 1/2] Create Intel pmem shutdown latch rule
Date: Tue, 7 Aug 2018 23:35:43 +0000
Message-ID: <1533684941.18175.55.camel@intel.com>
References: <20180807222656.14346-1-keith.busch@intel.com>
In-Reply-To: <20180807222656.14346-1-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <23C3A9D374CD704192EFD945FD629CD3@intel.com>
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
To: "Busch, Keith" <keith.busch@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-08-07 at 16:26 -0600, Keith Busch wrote:
> This patch provides a udev rule and the program it runs for Intel

Like we talked about, I think this should work for all NVDIMMs (at
least any that use the generic DIMM ops APIs that libndctl provides),
so we can remove any Intel specificity here.

> nvdimms. The program the rule executes runs two commands to allow
> applications to manage unsafe shutdowns.
> 
> The first command enables the shutdown latch. Without this, the last
> shutdown status will remain fixed to the status set when the latch was
> last enabled.
> 
> The second command retrieves the unclean shutdown counts and saves it
> in a known location. Only root can access the health's shutdown count,
> so we have to stash it somewhere accessible to non-privileged users. A
> successful execution of the rule will write USC to the run time tmpfs
> location. By default, the location will be set to:
> 
>   /run/ndctl/<dimm-id>/usc
> 
> A distro may change this location using the '--with-tmpfsdir=[DIR]'.

For consistency with the rpm macro, I'd suggest changing this to
--with-tmpfilesdir=

> 
> Reading the file will report the count observed when the dimm was
> added.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  .gitignore                  |   1 +
>  Makefile.am                 |   3 +
>  configure.ac                |  10 ++++
>  contrib/80-intel-pmem.rules |   1 +
>  ndctl.spec.in               |   5 +-
>  ndctl/Makefile.am           |   5 ++
>  ndctl/latch-shutdown.c      | 140 ++++++++++++++++++++++++++++++++++++++++++++

I think we can also rename this file to something more generic like
"ndctl-udev.c" so that any future udev actions can go here. We are
already doing two things in it, latching and saving the USCs.

>  7 files changed, 164 insertions(+), 1 deletion(-)
>  create mode 100644 contrib/80-intel-pmem.rules
>  create mode 100644 ndctl/latch-shutdown.c
> 
> diff --git a/.gitignore b/.gitignore
> index 1016b3b..1601738 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -25,6 +25,7 @@ daxctl/lib/libdaxctl.pc
>  *.a
>  ndctl/lib/libndctl.pc
>  ndctl/ndctl
> +ndctl/latch-shutdown
>  rhel/
>  sles/ndctl.spec
>  util/log.lo
> diff --git a/Makefile.am b/Makefile.am
> index e0c463a..9d3913e 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -42,6 +42,9 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
>  dist_bashcompletion_DATA = contrib/ndctl
>  endif
>  
> +udevrulesdir = $(UDEVDIR)/rules.d
> +dist_udevrules_DATA = contrib/80-intel-pmem.rules
> +
>  noinst_LIBRARIES = libccan.a
>  libccan_a_SOURCES = \
>  	ccan/str/str.h \
> diff --git a/configure.ac b/configure.ac
> index cf44260..15f336b 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -143,7 +143,16 @@ AC_CHECK_FUNCS([ \
>  	secure_getenv\
>  ])
>  
> +AC_ARG_WITH([tmpfsdir],
> +  [AS_HELP_STRING([--with-tmpfsdir=DIR], [Directory for temporary runtime files])],
> +  [tmpfsdir=$withval],
> +  [tmpfsdir="/run"])
> +
> +UDEVDIR="$(pkg-config udev --variable=udevdir)"
> +AC_SUBST([UDEVDIR])
> +
>  my_CFLAGS="\
> +-D DEF_TMPFS_DIR='\"${tmpfsdir}/ndctl\"' \
>  -Wall \
>  -Wchar-subscripts \
>  -Wformat-security \
> @@ -182,6 +191,7 @@ AC_MSG_RESULT([
>  
>          prefix:                 ${prefix}
>          sysconfdir:             ${sysconfdir}
> +        tmpfsdir:               ${tmpfsdir}
>          libdir:                 ${libdir}
>          includedir:             ${includedir}
>  
> diff --git a/contrib/80-intel-pmem.rules b/contrib/80-intel-pmem.rules
> new file mode 100644
> index 0000000..20fcef9
> --- /dev/null
> +++ b/contrib/80-intel-pmem.rules
> @@ -0,0 +1 @@
> +ACTION=="add", KERNEL=="nmem*", RUN+="latch-shutdown $kernel"
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index e2c879c..25edf7e 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -90,7 +90,7 @@ control API for these devices.
>  %build
>  echo %{version} > version
>  ./autogen.sh
> -%configure --disable-static --disable-silent-rules
> +%configure --disable-static --disable-silent-rules --with-tmpfsdir=%{_tmpfilesdir}
>  make %{?_smp_mflags}
>  
>  %install
> @@ -109,6 +109,7 @@ make check
>  %postun -n DAX_LNAME -p /sbin/ldconfig
>  
>  %define bashcompdir %(pkg-config --variable=completionsdir bash-completion)
> +%define udevdir  %(pkg-config --variable=udevdir udev)
>  
>  %files
>  %defattr(-,root,root)
> @@ -116,6 +117,8 @@ make check
>  %{_bindir}/ndctl
>  %{_mandir}/man1/ndctl*
>  %{bashcompdir}/
> +%{_udevrulesdir}/80-intel-pmem.rules
> +%{udevdir}/latch-shutdown
>  
>  %files -n daxctl
>  %defattr(-,root,root)
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 0f56871..155179b 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -41,3 +41,8 @@ ndctl_SOURCES += ../test/libndctl.c \
>  		 ../test/core.c \
>  		 test.c
>  endif
> +
> +latch_shutdowndir = $(UDEVDIR)
> +latch_shutdown_PROGRAMS = latch-shutdown
> +latch_shutdown_SOURCES = latch-shutdown.c
> +latch_shutdown_LDADD = lib/libndctl.la
> diff --git a/ndctl/latch-shutdown.c b/ndctl/latch-shutdown.c
> new file mode 100644
> index 0000000..704fb8f
> --- /dev/null
> +++ b/ndctl/latch-shutdown.c
> @@ -0,0 +1,140 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> +
> +#include <ctype.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stddef.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <ndctl/libndctl.h>
> +
> +/**
> + * mkdir_p
> + *
> + * Copied from util-linux lib/fileutils.c
> + */
> +static int mkdir_p(const char *path, mode_t mode)
> +{
> +	char *p, *dir;
> +	int rc = 0;
> +
> +	if (!path || !*path)
> +		return -EINVAL;
> +
> +	dir = p = strdup(path);
> +	if (!dir)
> +		return -ENOMEM;
> +
> +	if (*p == '/')
> +		p++;
> +
> +	while (p && *p) {
> +		char *e = strchr(p, '/');
> +		if (e)
> +			*e = '\0';
> +		if (*p) {
> +			rc = mkdir(dir, mode);
> +			if (rc && errno != EEXIST)
> +				break;
> +			rc = 0;
> +		}
> +		if (!e)
> +			break;
> +		*e = '/';
> +		p = e + 1;
> +	}
> +
> +	free(dir);
> +	return rc;
> +}
> +
> +static struct ndctl_dimm *find_dimm(struct ndctl_ctx *ctx, char *devname)
> +{
> +	struct ndctl_bus *bus;
> +	struct ndctl_dimm *dimm;
> +
> +	ndctl_bus_foreach(ctx, bus) {
> +		ndctl_dimm_foreach(bus, dimm) {
> +			if (strcmp(ndctl_dimm_get_devname(dimm), devname) == 0)
> +				return dimm;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct ndctl_ctx *ctx;
> +	struct ndctl_cmd *cmd;
> +	struct ndctl_dimm *dimm = NULL;
> +	char *path, *usc, count[16];
> +	const char *id;
> +	unsigned int shutdown;
> +	int rc, fd;
> +
> +	if (argc < 2)
> +		return EINVAL;
> +
> +	rc = ndctl_new(&ctx);
> +	if (rc)
> +		return ENOMEM;
> +
> +	dimm = find_dimm(ctx, argv[1]);
> +	if (!dimm)
> +		return ENODEV;
> +
> +	cmd = ndctl_dimm_cmd_new_ack_shutdown_count(dimm);
> +	if (!cmd)
> +		return ENOMEM;
> +
> +	rc = ndctl_cmd_submit(cmd);
> +	if (rc)
> +		return rc;
> +	ndctl_cmd_unref(cmd);

I think we'd need to break any dependency between the two functions
here, latching and reading the USCs. We should read the USCs
irrespective of whether the latching succeeded and the other way round.

Let's refactor this a bit, splitting off each 'operation' into a
function, and then main just calls all the functions independently.
This should make any future additions cleaner.

> +
> +	id = ndctl_dimm_get_unique_id(dimm);
> +	if (!id)
> +		return ENXIO;

Let's just use the nmemX style name here. ndctl and sysfs both always
refer to dimms like that, so this can be the same.

> +
> +	cmd = ndctl_dimm_cmd_new_smart(dimm);
> +	if (!cmd)
> +		return ENOMEM;
> +
> +	rc = ndctl_cmd_submit(cmd);
> +	if (rc)
> +		return rc;
> +
> +	shutdown = ndctl_cmd_smart_get_shutdown_count(cmd);
> +	ndctl_cmd_unref(cmd);
> +
> +	rc = asprintf(&path, DEF_TMPFS_DIR "/%s", id);
> +	if (rc < 0)
> +		return ENOMEM;
> +	ndctl_unref(ctx);
> +
> +	rc = mkdir_p(path, 0755);
> +	if (rc)
> +		return rc;
> +
> +	rc = asprintf(&usc, "%s/usc", path);
> +	if (rc < 0)
> +		return ENOMEM;
> +	free(path);
> +
> +	fd = open(usc, O_WRONLY | O_CREAT, 0644);
> +	if (!fd)
> +		return errno;
> +	free(usc);
> +
> +	rc = snprintf(count, sizeof(count), "%u\n", shutdown);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (write(fd, count, strlen(count)))
> +		return errno;
> +	return 0;
> +}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
