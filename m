From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v3 00/19] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Wed, 5 Dec 2018 15:10:50 -0800
Message-ID: <CAFd5g47cDKSdXGAL8pbDxEU2O8A-9Ajq1wCM+PtPF40T4wYKow@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <f34ee937-83d6-3ff6-12b3-c6cd9acbfc38@gmail.com> <CAL_JsqL0t_p8=Ueq4mHS5i2YEQdc7S7AtPWfkcOsj1g2SixUkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqL0t_p8=Ueq4mHS5i2YEQdc7S7AtPWfkcOsj1g2SixUkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, mcgrof@kernel.org, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, Knut Omang <knut.omang@oracle.com>
List-Id: linux-nvdimm@lists.01.org

On Tue, Dec 4, 2018 at 5:49 AM Rob Herring <robh@kernel.org> wrote:
>
> On Tue, Dec 4, 2018 at 5:40 AM Frank Rowand <frowand.list@gmail.com> wrote:
> >
> > Hi Brendan, Rob,
> >
> > Pulling a comment from way back in the v1 patch thread:
> >
> > On 10/17/18 3:22 PM, Brendan Higgins wrote:
> > > On Wed, Oct 17, 2018 at 10:49 AM <Tim.Bird@sony.com> wrote:
> >
> > < snip >
> >
> > > The test and the code under test are linked together in the same
> > > binary and are compiled under Kbuild. Right now I am linking
> > > everything into a UML kernel, but I would ultimately like to make
> > > tests compile into completely independent test binaries. So each test
> > > file would get compiled into its own test binary and would link
> > > against only the code needed to run the test, but we are a bit of a
> > > ways off from that.
> >
> > I have never used UML, so you should expect naive questions from me,
> > exhibiting my lack of understanding.
> >
> > Does this mean that I have to build a UML architecture kernel to run
> > the KUnit tests?
>
> In this version of the patch series, yes.
>
> > *** Rob, if the answer is yes, then it seems like for my workflow,
> > which is to build for real ARM hardware, my work is doubled (or
> > worse), because for every patch/commit that I apply, I not only have
> > to build the ARM kernel and boot on the real hardware to test, I also
> > have to build the UML kernel and boot in UML.  If that is correct
> > then I see this as a major problem for me.
>
> I've already raised this issue elsewhere in the series. Restricting
> the DT tests to UML is a non-starter.

I have already stated my position elsewhere on the matter, but in
summary: Ensuring most tests can run without external dependencies
(hardware, VM, etc) has a lot of benefits and should be supported in
nearly all cases, but such tests should also work when compiled to run
on real hardware/VM; the tooling might not be as good in the latter
case, but I understand that there are good reasons to support it
nonetheless.

So I am going to try to add basic support for running tests on other
architectures in the next version or two.

>
> > Brenden, in the above quote you said that in the future you would
> > like to make the "tests compile into completely independent test
> > binaries".  I am assuming those are intended to run as standalone
> > user space programs instead of inside UML.  Is that correct?  If
> > so, how will KUnit tests be able to test code that uses locking
> > mechanisms that require instructions that are not available to
> > user space execution?  (I _think_ that such instructions may be
> > present, depending on which locking mechanism, but I might be
> > mistaken.)
>
> I think he means as kernel modules as kunit is for testing internal
> kernel interfaces. kselftest is userspace level tests.

Frank is right: my long term goal is to make it so unit tests can run
as stand alone user space programs.

>
> If this were true about locking, then UML itself would not be viable.
>
> > Another possible concern that I have for removing the devicetree
> > unit tests from my normal kernel build process is that I think
> > that the ability to use sparse to analyze the source in the
> > unit tests is removed.  Please correct me if I misunderstand
> > that.
> >
> > Another issue is that the devicetree unit tests will no longer
> > be cross compiled with my ARM compiler, so I lose a small
> > amount of testing for compiler related issues.
>
> 0-day does that for you. :)
>
> > Overall, I'm still trying to learn enough to determine whether
> > the gains from moving to KUnit outweigh the losses.

Of course.

>From what I have seen so far, the DT unittests seem like a pretty good
use case for KUnit. If you don't mind, what frustrates you most about
the tests you have now?

What are the most common breakages you see?

When do they get caught?

My initial reaction when I looked at the tests was that it seemed like
it would be hard to understand what caused a failure and it seemed
non-obvious where a test for a new feature should go.

To me, the thing that seemed like it needed the most work was
refactoring the tests to make them easier to understand. For example,
one thing I found when I started breaking the tests apart I found some
cases that I really had to stare at (or run diff on them) to figure
out what they did differently.

Looking forward to get your thoughts.
