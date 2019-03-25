Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C852E211E2C1C
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 15:04:20 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id s24so100696otk.13
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 15:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <f34ee937-83d6-3ff6-12b3-c6cd9acbfc38@gmail.com>
 <CAL_JsqL0t_p8=Ueq4mHS5i2YEQdc7S7AtPWfkcOsj1g2SixUkA@mail.gmail.com>
 <CAFd5g47cDKSdXGAL8pbDxEU2O8A-9Ajq1wCM+PtPF40T4wYKow@mail.gmail.com>
 <ec4c1020-4b53-e0f2-4a9d-3fc73af56746@gmail.com>
In-Reply-To: <ec4c1020-4b53-e0f2-4a9d-3fc73af56746@gmail.com>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Mon, 25 Mar 2019 15:04:08 -0700
Message-ID: <CAFd5g46u8cQMVbcDv06HGL7mL=j35ziMxnqPXhrwYS5CD1ZeZA@mail.gmail.com>
Subject: Re: [RFC v3 00/19] kunit: introduce KUnit, the Linux kernel unit
 testing framework
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
To: Frank Rowand <frowand.list@gmail.com>
Cc: brakmo@fb.com, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 5:28 PM Frank Rowand <frowand.list@gmail.com> wrote:
>
> On 12/5/18 3:10 PM, Brendan Higgins wrote:
> > On Tue, Dec 4, 2018 at 5:49 AM Rob Herring <robh@kernel.org> wrote:
> >>
> >> On Tue, Dec 4, 2018 at 5:40 AM Frank Rowand <frowand.list@gmail.com> wrote:
> >>>
> >>> Hi Brendan, Rob,
> >>>
> >>> Pulling a comment from way back in the v1 patch thread:
> >>>
> >>> On 10/17/18 3:22 PM, Brendan Higgins wrote:
> >>>> On Wed, Oct 17, 2018 at 10:49 AM <Tim.Bird@sony.com> wrote:
> >>>
> >>> < snip >
> >>>
> >>>> The test and the code under test are linked together in the same
> >>>> binary and are compiled under Kbuild. Right now I am linking
> >>>> everything into a UML kernel, but I would ultimately like to make
> >>>> tests compile into completely independent test binaries. So each test
> >>>> file would get compiled into its own test binary and would link
> >>>> against only the code needed to run the test, but we are a bit of a
> >>>> ways off from that.
> >>>
> >>> I have never used UML, so you should expect naive questions from me,
> >>> exhibiting my lack of understanding.
> >>>
> >>> Does this mean that I have to build a UML architecture kernel to run
> >>> the KUnit tests?
> >>
> >> In this version of the patch series, yes.
> >>
> >>> *** Rob, if the answer is yes, then it seems like for my workflow,
> >>> which is to build for real ARM hardware, my work is doubled (or
> >>> worse), because for every patch/commit that I apply, I not only have
> >>> to build the ARM kernel and boot on the real hardware to test, I also
> >>> have to build the UML kernel and boot in UML.  If that is correct
> >>> then I see this as a major problem for me.
> >>
> >> I've already raised this issue elsewhere in the series. Restricting
> >> the DT tests to UML is a non-starter.
> >
>
> > I have already stated my position elsewhere on the matter, but in
> > summary: Ensuring most tests can run without external dependencies
> > (hardware, VM, etc) has a lot of benefits and should be supported in
> > nearly all cases, but such tests should also work when compiled to run
> > on real hardware/VM; the tooling might not be as good in the latter
> > case, but I understand that there are good reasons to support it
> > nonetheless.
>
> And my needs are the exact opposite.  My tests must run on real hardware,
> in the context of the real operating system subsystems and drivers
> potentially causing issues.

Right, Rob pointed this out, and I fixed this in v4. To be clear, as
of RFC v4 you can run KUnit tests on non-UML architectures, we tested
it on x86 and ARM.

>
> It is useful if the tests can also run without that dependency.

This, of course, is still the main intended use case, but there is
nothing to stop you from using it on real hardware.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
