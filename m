From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v3 01/19] kunit: test: add KUnit test runner core
Date: Fri, 30 Nov 2018 17:51:11 -0800
Message-ID: <CAFd5g47t94RR78_sZ7Xr7ArDh+hJGYHNwmmG2HJb7AW+i=u3ew@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-2-brendanhiggins@google.com> <20181130031438.GQ4922@garbanzo.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130031438.GQ4922@garbanzo.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mcgrof@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Sasha Levin <Alexander.Levin@microsoft.com>, levinsasha
List-Id: linux-nvdimm@lists.01.org

On Thu, Nov 29, 2018 at 7:14 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Wed, Nov 28, 2018 at 11:36:18AM -0800, Brendan Higgins wrote:
> > +#define module_test(module) \
> > +             static int module_kunit_init##module(void) \
> > +             { \
> > +                     return kunit_run_tests(&module); \
> > +             } \
> > +             late_initcall(module_kunit_init##module)
>
> Here in lies an assumption that suffices. I'm inclined to believe we
> need new initcall level here so to ensure we *do* run after all the
> respective kernels iniut calls. Otherwise we're left at the whims of
> link order for kunit. For instance if a kunit test relies on frameworks
> which are also late_initcall() we'd have complete incompatibility with
> anything linked *after* kunit.

Yep, I have some patches that address this, but I thought this is
sufficient for the initial patchset (I figured that's the type of
thing that people will have opinions about so best to get it out of
the critical path). Do you want me to add those in the next revision?

>
> > diff --git a/kunit/Kconfig b/kunit/Kconfig
> > new file mode 100644
> > index 0000000000000..49b44c4f6630a
> > --- /dev/null
> > +++ b/kunit/Kconfig
> > @@ -0,0 +1,17 @@
> > +#
> > +# KUnit base configuration
> > +#
> > +
> > +menu "KUnit support"
> > +
> > +config KUNIT
> > +     bool "Enable support for unit tests (KUnit)"
> > +     depends on UML
>
> Consider using:
>
> if UML
>    ...
> endif
>
> That allows the depends to be done once.

If you want to eliminate depends, wouldn't it be best to have KUNIT
depend on whatever it needs, and then do `if KUNIT` below that? That
seems cleaner over the long term. Anyway, Kees actually asked me to
change it to the way it is now; I really don't care either way.

>
> > +     help
> > +       Enables support for kernel unit tests (KUnit), a lightweight unit
> > +       testing and mocking framework for the Linux kernel. These tests are
> > +       able to be run locally on a developer's workstation without a VM or
> > +       special hardware.
>
>
> Some mention of UML may be good here?

Good point.
>
> > For more information, please see
> > +       Documentation/kunit/
> > +
> > +endmenu
>
> I'm a bit conflicted here. This currently depends on UML but yet you
> noted on RFC v2 that your intention is to liberate kunit from UML and
> ideally allow unit tests to depend only on userspace. I've addressed
> tests using both selftests kernels drivers and also re-written kernel
> APIs to userspace to test there. I think we may need to live with both.

I am not entirely opposed. The greater isolation we can achieve, the
fewer dependencies, and barriers to setting up test fixtures the
better. I think the best way to do that in most cases is allowing
minimal test binaries to be built that have the absolute minimum
amount of code necessary to test the desired property. That being
said, integration tests are a thing and drawing a line between them
and unit tests is not always possible, so supporting other
architectures might be necessary.

>
> Then for the UML stuff, I think if we *really* accept that UML will
> always be a viable option we should probably consider now throwing these
> things under drivers/platform/uml/. This follows the pattern of arch
> specific drivers. Whether or not we end up with a complete userspace
> component independent of UML may implicate having a shared component
> somewhere else.

Fair enough. What specifically are you suggesting should go in
`drivers/platform/uml`? Just the bits that are completely tied to UML
or a concrete architecture?

>
> Likewise, I realize the goal is to *avoid* using a virtual machine for
> these tests, but would it in any way make sense to share kunit to be
> supported for other architectures to allow easier-to-write tests as
> well?

You are not the first person to ask for this.

For the vast majority of tests, I think we can (and consequently
should) make them run without any external dependencies. Doing so
makes it such that someone can run a test without knowing anything
about it, which allows you to do a lot of things. For one, I, as a
developer, don't have to hunt down somebody's QEMU patches, or
whatever. But it also means I, as someone maintaining part of the
kernel, can make nice test runners and build things like presubmit
servers on top of them.

Nevertheless, I accept that there are things which are just easier to
do with hardware or a VM (for integration tests it is necessary).
Still, I think we need to make sure the vast majority of unit tests do
not depend on real hardware or a VM.
