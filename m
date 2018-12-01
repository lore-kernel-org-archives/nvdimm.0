Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D903121196824
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 18:57:40 -0800 (PST)
Received: by mail-pg1-f195.google.com with SMTP id 80so3299298pge.4
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 18:57:40 -0800 (PST)
Date: Fri, 30 Nov 2018 18:57:35 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 01/19] kunit: test: add KUnit test runner core
Message-ID: <20181201025735.GI28501@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-2-brendanhiggins@google.com>
 <20181130031438.GQ4922@garbanzo.do-not-panic.com>
 <CAFd5g47t94RR78_sZ7Xr7ArDh+hJGYHNwmmG2HJb7AW+i=u3ew@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFd5g47t94RR78_sZ7Xr7ArDh+hJGYHNwmmG2HJb7AW+i=u3ew@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm@lists.01.org, richard@nod.at, Knut Omang <knut.omang@oracle.com>, kieran.bingham@ideasonboard.com, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, rostedt@goodmis.org, Julia Lawall <julia.lawall@lip6.fr>, levinsasha928@gmail.com, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 30, 2018 at 05:51:11PM -0800, Brendan Higgins wrote:
> On Thu, Nov 29, 2018 at 7:14 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Wed, Nov 28, 2018 at 11:36:18AM -0800, Brendan Higgins wrote:
> > > +#define module_test(module) \
> > > +             static int module_kunit_init##module(void) \
> > > +             { \
> > > +                     return kunit_run_tests(&module); \
> > > +             } \
> > > +             late_initcall(module_kunit_init##module)
> >
> > Here in lies an assumption that suffices. I'm inclined to believe we
> > need new initcall level here so to ensure we *do* run after all the
> > respective kernels iniut calls. Otherwise we're left at the whims of
> > link order for kunit. For instance if a kunit test relies on frameworks
> > which are also late_initcall() we'd have complete incompatibility with
> > anything linked *after* kunit.
> 
> Yep, I have some patches that address this, but I thought this is
> sufficient for the initial patchset (I figured that's the type of
> thing that people will have opinions about so best to get it out of
> the critical path). Do you want me to add those in the next revision?
> 
> >
> > > diff --git a/kunit/Kconfig b/kunit/Kconfig
> > > new file mode 100644
> > > index 0000000000000..49b44c4f6630a
> > > --- /dev/null
> > > +++ b/kunit/Kconfig
> > > @@ -0,0 +1,17 @@
> > > +#
> > > +# KUnit base configuration
> > > +#
> > > +
> > > +menu "KUnit support"
> > > +
> > > +config KUNIT
> > > +     bool "Enable support for unit tests (KUnit)"
> > > +     depends on UML
> >
> > Consider using:
> >
> > if UML
> >    ...
> > endif
> >
> > That allows the depends to be done once.
> 
> If you want to eliminate depends, wouldn't it be best to have KUNIT
> depend on whatever it needs, and then do `if KUNIT` below that? That
> seems cleaner over the long term. Anyway, Kees actually asked me to
> change it to the way it is now; I really don't care either way.

Yes, that works better. The idea is to just avoid having to write in
depends on over and over again.

> > I'm a bit conflicted here. This currently depends on UML but yet you
> > noted on RFC v2 that your intention is to liberate kunit from UML and
> > ideally allow unit tests to depend only on userspace. I've addressed
> > tests using both selftests kernels drivers and also re-written kernel
> > APIs to userspace to test there. I think we may need to live with both.
> 
> I am not entirely opposed. The greater isolation we can achieve, the
> fewer dependencies, and barriers to setting up test fixtures the
> better. I think the best way to do that in most cases is allowing
> minimal test binaries to be built that have the absolute minimum
> amount of code necessary to test the desired property. That being
> said, integration tests are a thing and drawing a line between them
> and unit tests is not always possible, so supporting other
> architectures might be necessary.

Then lets pave the way for it to be done easily.

> > Then for the UML stuff, I think if we *really* accept that UML will
> > always be a viable option we should probably consider now throwing these
> > things under drivers/platform/uml/. This follows the pattern of arch
> > specific drivers. Whether or not we end up with a complete userspace
> > component independent of UML may implicate having a shared component
> > somewhere else.
> 
> Fair enough. What specifically are you suggesting should go in
> `drivers/platform/uml`? Just the bits that are completely tied to UML
> or a concrete architecture?

The bits that are UML specific. As I see it, with the above intention
clarified, kunit is a framework for architectures and UML is supported
first. The code doesn't currently reflect this.

> > Likewise, I realize the goal is to *avoid* using a virtual machine for
> > these tests, but would it in any way make sense to share kunit to be
> > supported for other architectures to allow easier-to-write tests as
> > well?
> 
> You are not the first person to ask for this.
> 
> For the vast majority of tests, I think we can (and consequently
> should) make them run without any external dependencies. Doing so
> makes it such that someone can run a test without knowing anything
> about it, which allows you to do a lot of things. For one, I, as a
> developer, don't have to hunt down somebody's QEMU patches, or
> whatever. But it also means I, as someone maintaining part of the
> kernel, can make nice test runners and build things like presubmit
> servers on top of them.
> 
> Nevertheless, I accept that there are things which are just easier to
> do with hardware or a VM (for integration tests it is necessary).
> Still, I think we need to make sure the vast majority of unit tests do
> not depend on real hardware or a VM.

When possible, sure.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
