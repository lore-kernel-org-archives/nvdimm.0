Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x242.google.com (mail-qt0-x242.google.com
 [IPv6:2607:f8b0:400d:c0d::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E58E2097FABC
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 11:24:11 -0700 (PDT)
Received: by mail-qt0-x242.google.com with SMTP id a5-v6so13374057qtp.2
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 11:24:11 -0700 (PDT)
Subject: Re: [ndctl PATCH v12 3/5] ndctl, monitor: add the unit file of
 systemd for ndctl-monitor service
References: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
 <20180713155403.30020-4-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <e4211959-a46c-2eb7-e39e-b7280374134b@gmail.com>
Date: Fri, 13 Jul 2018 14:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <20180713155403.30020-4-qi.fuli@jp.fujitsu.com>
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
To: qi.fuli@jp.fujitsu.com, linux-nvdimm@lists.01.org
Cc: tokunaga.keiich@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Qi,

On 07/13/2018 11:54 AM, QI Fuli wrote:
> This patch adds the systemd unit file for ndctl-monitor service.
> The systemd unit directory can be configured by setting environment
> variable "--with-systemd-unit-dir[=DIR]".
> 
> A monitor daemon can be started as a system service:
>    # systemctl start ndctl-monitor.service
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  autogen.sh                  |  3 ++-
>  configure.ac                | 22 ++++++++++++++++++++++
>  ndctl.spec.in               |  1 +
>  ndctl/Makefile.am           |  4 ++++
>  ndctl/ndctl-monitor.service |  7 +++++++
>  5 files changed, 36 insertions(+), 1 deletion(-)
>  create mode 100644 ndctl/ndctl-monitor.service
> 
> diff --git a/autogen.sh b/autogen.sh
> index 2a52688..21b0e25 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -17,7 +17,8 @@ libdir() {
>  
>  args="--prefix=/usr \
>  --sysconfdir=/etc \
> ---libdir=$(libdir /usr/lib)"
> +--libdir=$(libdir /usr/lib) \
> +--with-systemd-unit-dir"
>  
>  echo
>  echo "----------------------------------------------------------------"
> diff --git a/configure.ac b/configure.ac
> index cf44260..a5ba9a1 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -143,6 +143,27 @@ AC_CHECK_FUNCS([ \
>  	secure_getenv\
>  ])
>  
> +PKG_PROG_PKG_CONFIG
> +AC_ARG_WITH([systemd-unit-dir],
> +	AS_HELP_STRING([--with-systemd-unit-dir[=DIR]],
> +		[Directory for systemd service files]),
> +	[],
> +	[with_systemd_unit_dir=yes])
> +
> +if test "x$with_systemd_unit_dir" = "xyes"; then
> +	def_systemd_unit_dir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)
> +	if test "x$def_systemd_unit_dir" = "x"; then
> +		AC_MSG_ERROR([systemd support requested but pkg-config unable to query systemd package])
> +		with_systemd_unit_dir=no
> +	else
> +		with_systemd_unit_dir="$def_systemd_unit_dir"
> +	fi
> +fi
> +
> +AS_IF([test "x$with_systemd_unit_dir" != "xno"],
> +	[AC_SUBST([systemd_unitdir], [$with_systemd_unit_dir])])
> +AM_CONDITIONAL([ENABLE_SYSTEMD_UNIT_DIR], [test "x$with_systemd_unit_dir" != "xno"])
> +
>  my_CFLAGS="\
>  -Wall \
>  -Wchar-subscripts \
> @@ -184,6 +205,7 @@ AC_MSG_RESULT([
>          sysconfdir:             ${sysconfdir}
>          libdir:                 ${libdir}
>          includedir:             ${includedir}

> +	systemd-unit-dir:	${systemd_unitdir}

not tab, white space is good here.

>  
>          compiler:               ${CC}
>          cflags:                 ${CFLAGS}
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 42760fa..6f7d299 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -142,6 +142,7 @@ make check
>  %{_libdir}/libndctl.so
>  %{_libdir}/pkgconfig/libndctl.pc

>  %{_sysconfdir}/ndctl/monitor.conf
> +%{_unitdir}/ndctl-monitor.service

The monitor conf and service should be included in ndctl package, so,
why don't you add such as the following ?

%files
%defattr(-,root,root)
%license util/COPYING licenses/BSD-MIT licenses/CC0
%{_bindir}/ndctl
%{_mandir}/man1/ndctl*
%{bashcompdir}/
%{_sysconfdir}/ndctl/monitor.conf
%{_unitdir}/ndctl-monitor.service

Thanks,
Masa

>  
>  %files -n DAX_DNAME
>  %defattr(-,root,root)
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 4d0cccc..087ddc5 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -47,3 +47,7 @@ monitor_config_file = monitor.conf
>  monitor_configdir = /etc/ndctl/
>  monitor_config_DATA = $(monitor_config_file)
>  EXTRA_DIST += $(monitor_config_file)
> +
> +if ENABLE_SYSTEMD_UNIT_DIR
> +systemd_unit_DATA = ndctl-monitor.service
> +endif
> diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
> new file mode 100644
> index 0000000..44f9326
> --- /dev/null
> +++ b/ndctl/ndctl-monitor.service
> @@ -0,0 +1,7 @@
> +[Unit]
> +Description=Ndctl Monitor Daemon
> +
> +[Service]
> +Type=forking
> +ExecStart=/usr/bin/ndctl monitor --daemon
> +ExecStop=/bin/kill ${MAINPID}
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
