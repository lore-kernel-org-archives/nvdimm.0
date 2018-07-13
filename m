Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D34DB21B02845
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 12:06:29 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v12 3/5] ndctl, monitor: add the unit file of
 systemd for ndctl-monitor service
Date: Fri, 13 Jul 2018 19:05:39 +0000
Message-ID: <1531508737.7574.141.camel@intel.com>
References: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
 <20180713155403.30020-4-qi.fuli@jp.fujitsu.com>
 <e4211959-a46c-2eb7-e39e-b7280374134b@gmail.com>
In-Reply-To: <e4211959-a46c-2eb7-e39e-b7280374134b@gmail.com>
Content-Language: en-US
Content-ID: <E64CA0B88D28E84CB7A9B25FC99C6AC5@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>
Cc: "tokunaga.keiich@jp.fujitsu.com" <tokunaga.keiich@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-07-13 at 14:24 -0400, Masayoshi Mizuma wrote:
> Hi Qi,
> 
> On 07/13/2018 11:54 AM, QI Fuli wrote:
> > This patch adds the systemd unit file for ndctl-monitor service.
> > The systemd unit directory can be configured by setting environment
> > variable "--with-systemd-unit-dir[=DIR]".
> > 
> > A monitor daemon can be started as a system service:
> >    # systemctl start ndctl-monitor.service
> > 
> > Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> > ---
> >  autogen.sh                  |  3 ++-
> >  configure.ac                | 22 ++++++++++++++++++++++
> >  ndctl.spec.in               |  1 +
> >  ndctl/Makefile.am           |  4 ++++
> >  ndctl/ndctl-monitor.service |  7 +++++++
> >  5 files changed, 36 insertions(+), 1 deletion(-)
> >  create mode 100644 ndctl/ndctl-monitor.service
> > 
> > diff --git a/autogen.sh b/autogen.sh
> > index 2a52688..21b0e25 100755
> > --- a/autogen.sh
> > +++ b/autogen.sh
> > @@ -17,7 +17,8 @@ libdir() {
> >  
> >  args="--prefix=/usr \
> >  --sysconfdir=/etc \
> > ---libdir=$(libdir /usr/lib)"
> > +--libdir=$(libdir /usr/lib) \
> > +--with-systemd-unit-dir"
> >  
> >  echo
> >  echo "----------------------------------------------------------
> > ------"
> > diff --git a/configure.ac b/configure.ac
> > index cf44260..a5ba9a1 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -143,6 +143,27 @@ AC_CHECK_FUNCS([ \
> >  	secure_getenv\
> >  ])
> >  
> > +PKG_PROG_PKG_CONFIG
> > +AC_ARG_WITH([systemd-unit-dir],
> > +	AS_HELP_STRING([--with-systemd-unit-dir[=DIR]],
> > +		[Directory for systemd service files]),
> > +	[],
> > +	[with_systemd_unit_dir=yes])
> > +
> > +if test "x$with_systemd_unit_dir" = "xyes"; then
> > +	def_systemd_unit_dir=$($PKG_CONFIG --
> > variable=systemdsystemunitdir systemd)
> > +	if test "x$def_systemd_unit_dir" = "x"; then
> > +		AC_MSG_ERROR([systemd support requested but pkg-
> > config unable to query systemd package])
> > +		with_systemd_unit_dir=no
> > +	else
> > +		with_systemd_unit_dir="$def_systemd_unit_dir"
> > +	fi
> > +fi
> > +
> > +AS_IF([test "x$with_systemd_unit_dir" != "xno"],
> > +	[AC_SUBST([systemd_unitdir], [$with_systemd_unit_dir])])
> > +AM_CONDITIONAL([ENABLE_SYSTEMD_UNIT_DIR], [test
> > "x$with_systemd_unit_dir" != "xno"])
> > +
> >  my_CFLAGS="\
> >  -Wall \
> >  -Wchar-subscripts \
> > @@ -184,6 +205,7 @@ AC_MSG_RESULT([
> >          sysconfdir:             ${sysconfdir}
> >          libdir:                 ${libdir}
> >          includedir:             ${includedir}
> > +	systemd-unit-dir:	${systemd_unitdir}
> 
> not tab, white space is good here.
> 
> >  
> >          compiler:               ${CC}
> >          cflags:                 ${CFLAGS}
> > diff --git a/ndctl.spec.in b/ndctl.spec.in
> > index 42760fa..6f7d299 100644
> > --- a/ndctl.spec.in
> > +++ b/ndctl.spec.in
> > @@ -142,6 +142,7 @@ make check
> >  %{_libdir}/libndctl.so
> >  %{_libdir}/pkgconfig/libndctl.pc
> >  %{_sysconfdir}/ndctl/monitor.conf
> > +%{_unitdir}/ndctl-monitor.service
> 
> The monitor conf and service should be included in ndctl package, so,
> why don't you add such as the following ?
> 
> %files
> %defattr(-,root,root)
> %license util/COPYING licenses/BSD-MIT licenses/CC0
> %{_bindir}/ndctl
> %{_mandir}/man1/ndctl*
> %{bashcompdir}/
> %{_sysconfdir}/ndctl/monitor.conf
> %{_unitdir}/ndctl-monitor.service
> 
Yes these files need to be in the %files section, and not in the
%files -n DNAME section (which is for the ndctl-devel package).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
