From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 16/17] kernel/sysctl-test: Add null pointer test for
 sysctl.c:proc_dointvec()
Date: Fri, 3 May 2019 08:42:41 +0200
Message-ID: <20190503064241.GC20723@kroah.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-17-brendanhiggins@google.com>
 <20190502110347.GE12416@kroah.com>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770A3A0@USCULXMSG01.am.sony.com>
 <CAFd5g471Wawu6g14p0AO3aY8VPBKLA0mjHSdfR1qStFGzp3iGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFd5g471Wawu6g14p0AO3aY8VPBKLA0mjHSdfR1qStFGzp3iGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: "Bird, Timothy" <Tim.Bird@sony.com>, Frank Rowand <frowand.list@gmail.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah@kernel.org, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, Sasha Levin <Alexander.Levin@microsoft.com>, Amir Goldstein <amir73il@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, May 02, 2019 at 11:45:43AM -0700, Brendan Higgins wrote:
> On Thu, May 2, 2019 at 11:15 AM <Tim.Bird@sony.com> wrote:
> >
> >
> >
> > > -----Original Message-----
> > > From: Greg KH
> > >
> > > On Wed, May 01, 2019 at 04:01:25PM -0700, Brendan Higgins wrote:
> > > > From: Iurii Zaikin <yzaikin@google.com>
> > > >
> > > > KUnit tests for initialized data behavior of proc_dointvec that is
> > > > explicitly checked in the code. Includes basic parsing tests including
> > > > int min/max overflow.
> > > >
> > > > Signed-off-by: Iurii Zaikin <yzaikin@google.com>
> > > > Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> > > > ---
> > > >  kernel/Makefile      |   2 +
> > > >  kernel/sysctl-test.c | 292
> > > +++++++++++++++++++++++++++++++++++++++++++
> > > >  lib/Kconfig.debug    |   6 +
> > > >  3 files changed, 300 insertions(+)
> > > >  create mode 100644 kernel/sysctl-test.c
> > > >
> > > > diff --git a/kernel/Makefile b/kernel/Makefile
> > > > index 6c57e78817dad..c81a8976b6a4b 100644
> > > > --- a/kernel/Makefile
> > > > +++ b/kernel/Makefile
> > > > @@ -112,6 +112,8 @@ obj-$(CONFIG_HAS_IOMEM) += iomem.o
> > > >  obj-$(CONFIG_ZONE_DEVICE) += memremap.o
> > > >  obj-$(CONFIG_RSEQ) += rseq.o
> > > >
> > > > +obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
> > >
> > > You are going to have to have a "standard" naming scheme for test
> > > modules, are you going to recommend "foo-test" over "test-foo"?  If so,
> > > that's fine, we should just be consistant and document it somewhere.
> > >
> > > Personally, I'd prefer "test-foo", but that's just me, naming is hard...
> >
> > My preference would be "test-foo" as well.  Just my 2 cents.
> 
> I definitely agree we should be consistent. My personal bias
> (unsurprisingly) is "foo-test," but this is just because that is the
> convention I am used to in other projects I have worked on.
> 
> On an unbiased note, we are currently almost evenly split between the
> two conventions with *slight* preference for "foo-test": I ran the two
> following grep commands on v5.1-rc7:
> 
> grep -Hrn --exclude-dir="build" -e "config [a-zA-Z_0-9]\+_TEST$" | wc -l
> grep -Hrn --exclude-dir="build" -e "config TEST_[a-zA-Z_0-9]\+" | wc -l
> 
> "foo-test" has 36 occurrences.
> "test-foo" has 33 occurrences.
> 
> The things I am more concerned about is how this would affect file
> naming. If we have a unit test for foo.c, I think foo_test.c is more
> consistent with our namespacing conventions. The other thing, is if we
> already have a Kconfig symbol called FOO_TEST (or TEST_FOO) what
> should we name the KUnit test in this case? FOO_UNIT_TEST?
> FOO_KUNIT_TEST, like I did above?

Ok, I can live with "foo-test", as you are right, in a directory listing
and config option, it makes more sense to add it as a suffix.

thanks,

greg k-h
