Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6DA762113002F
 for <linux-nvdimm@lists.01.org>; Thu, 13 Sep 2018 11:18:42 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, build: Introduce --with-{bash,systemd}
Date: Thu, 13 Sep 2018 18:18:35 +0000
Message-ID: <1536862713.5995.209.camel@intel.com>
References: <153678309933.293708.8157261262222091779.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153678309933.293708.8157261262222091779.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <14164595F84F9E4495182EBDB6C2E8DE@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "rworkman@slackware.com" <rworkman@slackware.com>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2018-09-12 at 13:11 -0700, Dan Williams wrote:
> The --with-bash-completion-dir and --with-systemd-unit-dir are not
> arguments that set directory values, they are questions about whether
> ndctl should build extra functionality and pull extra pkgconfig
> variable information.
> 
> Clean them up to be --with-bash and --with-systemd and consistent.
> 
> This makes it clear that to disable systemd, for example, specify:
> 
>     --without-systemd
> 
> ...to the configure script.
> 
> Link: https://github.com/pmem/ndctl/issues/68
> Reported-by: Robby Workman <rworkman@slackware.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  autogen.sh        |    3 +--
>  configure.ac      |   46 +++++++++++++++++------------------------
> -----
>  ndctl/Makefile.am |    2 +-
>  3 files changed, 19 insertions(+), 32 deletions(-)

Looks good, applied both this and the other related one:
ndctl, spec: Use pkgconfig for systemd

> 
> diff --git a/autogen.sh b/autogen.sh
> index 21b0e250e672..2a52688bb403 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -17,8 +17,7 @@ libdir() {
>  
>  args="--prefix=/usr \
>  --sysconfdir=/etc \
> ---libdir=$(libdir /usr/lib) \
> ---with-systemd-unit-dir"
> +--libdir=$(libdir /usr/lib)"
>  
>  echo
>  echo "------------------------------------------------------------
> ----"
> diff --git a/configure.ac b/configure.ac
> index 7bfe5a7451b0..9dc11da194d1 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -115,22 +115,19 @@ PKG_CHECK_MODULES([UDEV], [libudev])
>  PKG_CHECK_MODULES([UUID], [uuid])
>  PKG_CHECK_MODULES([JSON], [json-c])
>  
> -AC_ARG_WITH([bash-completion-dir],
> -	AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
> -		[Install the bash auto-completion script in this
> directory. @<:@default=yes@:>@]),
> +AC_ARG_WITH([bash],
> +	AS_HELP_STRING([--with-bash],
> +		[Enable bash auto-completion. @<:@default=yes@:>@]),
>  	[],
> -	[with_bash_completion_dir=yes])
> +	[with_bash=yes])
>  
> -if test "x$with_bash_completion_dir" = "xyes"; then
> +if test "x$with_bash" = "xyes"; then
>  	PKG_CHECK_MODULES([BASH_COMPLETION], [bash-completion >=
> 2.0],
> -		[BASH_COMPLETION_DIR="`pkg-config --
> variable=completionsdir bash-completion`"],
> -		[BASH_COMPLETION_DIR="$datadir/bash-
> completion/completions"])
> -else
> -	BASH_COMPLETION_DIR="$with_bash_completion_dir"
> +		[BASH_COMPLETION_DIR=$($PKG_CONFIG --
> variable=completionsdir bash-completion)], [])
>  fi
>  
>  AC_SUBST([BASH_COMPLETION_DIR])
> -AM_CONDITIONAL([ENABLE_BASH_COMPLETION],[test
> "x$with_bash_completion_dir" != "xno"])
> +AM_CONDITIONAL([ENABLE_BASH_COMPLETION], [test "x$with_bash" =
> "xyes"])
>  
>  AC_ARG_ENABLE([local],
>          AS_HELP_STRING([--disable-local], [build against kernel
> ndctl.h @<:@default=system@:>@]),
> @@ -143,26 +140,18 @@ AC_CHECK_FUNCS([ \
>  	secure_getenv\
>  ])
>  
> -PKG_PROG_PKG_CONFIG
> -AC_ARG_WITH([systemd-unit-dir],
> -	AS_HELP_STRING([--with-systemd-unit-dir[=DIR]],
> -		[Directory for systemd service files]),
> -	[],
> -	[with_systemd_unit_dir=yes])
> -
> -if test "x$with_systemd_unit_dir" = "xyes"; then
> -	def_systemd_unit_dir=$($PKG_CONFIG --
> variable=systemdsystemunitdir systemd)
> -	if test "x$def_systemd_unit_dir" = "x"; then
> -		AC_MSG_ERROR([systemd support requested but pkg-
> config unable to query systemd package])
> -		with_systemd_unit_dir=no
> -	else
> -		with_systemd_unit_dir="$def_systemd_unit_dir"
> -	fi
> +AC_ARG_WITH([systemd],
> +	AS_HELP_STRING([--with-systemd],
> +		[Enable systemd functionality (monitor).
> @<:@default=yes@:>@]),
> +	[], [with_systemd=yes])
> +
> +if test "x$with_systemd" = "xyes"; then
> +	PKG_CHECK_MODULES([SYSTEMD], [systemd],
> +	[systemd_unitdir=$($PKG_CONFIG --
> variable=systemdsystemunitdir systemd)], [])
>  fi
>  
> -AS_IF([test "x$with_systemd_unit_dir" != "xno"],
> -	[AC_SUBST([systemd_unitdir], [$with_systemd_unit_dir])])
> -AM_CONDITIONAL([ENABLE_SYSTEMD_UNIT_DIR], [test
> "x$with_systemd_unit_dir" != "xno"])
> +AC_SUBST([systemd_unitdir])
> +AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" =
> "xyes"])
>  
>  AC_ARG_WITH([tmpfilesdir],
>  	[AS_HELP_STRING([--with-tmpfilesdir=DIR], [Directory for
> temporary runtime files])],
> @@ -215,7 +204,6 @@ AC_MSG_RESULT([
>          sysconfdir:             ${sysconfdir}
>          libdir:                 ${libdir}
>          includedir:             ${includedir}
> -	systemd-unit-dir:	${systemd_unitdir}
>          tmpfilesdir:            ${tmpfilesdir}
>  
>          compiler:               ${CC}
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 4b44294ef9aa..d6839e4a9fb6 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -48,7 +48,7 @@ monitor_configdir = $(sysconfdir)/ndctl/
>  monitor_config_DATA = $(monitor_config_file)
>  EXTRA_DIST += $(monitor_config_file)
>  
> -if ENABLE_SYSTEMD_UNIT_DIR
> +if ENABLE_SYSTEMD_UNITS
>  systemd_unit_DATA = ndctl-monitor.service
>  endif
>  
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
