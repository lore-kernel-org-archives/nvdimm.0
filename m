Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E83E1A1F76
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 00:06:02 -0800 (PST)
Date: Fri, 11 Mar 2016 09:05:43 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH] ndctl: Grab kernel version from utsname()
Message-ID: <20160311080543.GL16624@c203.arch.suse.de>
References: <1457620089-28984-1-git-send-email-jthumshirn@suse.de>
 <CAPcyv4h62dZs=82Vb3E3s85jazAeVWUCf=6Mc=jTDsVzPZ92qw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h62dZs=82Vb3E3s85jazAeVWUCf=6Mc=jTDsVzPZ92qw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 10, 2016 at 10:57:42AM -0800, Dan Williams wrote:
> On Thu, Mar 10, 2016 at 6:28 AM, Johannes Thumshirn <jthumshirn@suse.de> =
wrote:
> > Grab the kernel version used for tests dynamically via utsname() instea=
d of
> > hardcoding the version of the build host.
> >
> > Otherwise tests will be skipped if the build host had a too old kernel
> > version.
> >
> > flodin:~ # ./ndctl test
> > __ndctl_test_attempt: skip test_libndctl:1950 requires: 4.2.0 current: =
4.1.0
> > test-libndctl: SKIP
> > __ndctl_test_attempt: skip test_dpa_alloc:300 requires: 4.2.0 current: =
4.1.0
> > test-dpa-alloc: SKIP
> > __ndctl_test_attempt: skip test_parent_uuid:230 requires: 4.3.0 current=
: 4.1.0
> > test-parent-uuid: SKIP
> > attempted: 3 skipped: 3
> >
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  test/core.c |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > --- a/test/core.c
> > +++ b/test/core.c
> > @@ -1,4 +1,5 @@
> >  #include <linux/version.h>
> > +#include <sys/utsname.h>
> >  #include <stdlib.h>
> >  #include <stdio.h>
> >  #include <test.h>
> > @@ -11,6 +12,18 @@ struct ndctl_test {
> >         int skip;
> >  };
> >
> > +static unsigned int get_system_kver(void)
> > +{
> > +       struct utsname utsname;
> > +       int a, b, c;
> > +
> > +       uname(&utsname);
> > +
> > +       sscanf(utsname.version, "%d.%d.%d", &a, &b, &c);
> > +
> > +       return KERNEL_VERSION(a,b,c);
> > +}
> =

> Hmm, on my workstation utsname.version is "#1 SMP Fri Feb 26 18:45:40
> UTC 2016" while utsname.release is "4.4.3-300.fc23.x86_64".  Do
> different distros define release and version differently?

Having a look at the manpage you're right. I wonder why it worked for me. I=
'll
respin with utsname.release and see if it still works. /me is a bit puzzled
why it worked.

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
