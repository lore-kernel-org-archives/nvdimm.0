From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v2 00/14] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 25 Oct 2018 14:25:28 -0700
Message-ID: <CAFd5g44RGcYzEb68y0jBpcpZPhbY9=M-==+9cNvs0XyMamobLA@mail.gmail.com>
References: <20181023235750.103146-1-brendanhiggins@google.com> <20181024091449.GL324@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181024091449.GL324@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, mcgrof@kernel.org, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com
Cc: daniel@ffwll.ch
List-Id: linux-nvdimm@lists.01.org

On Wed, Oct 24, 2018 at 2:14 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Tue, Oct 23, 2018 at 04:57:36PM -0700, Brendan Higgins wrote:
<snip>
> > ## Changes Since Last Version
> >
> >  - Updated patchset to apply cleanly on 4.19.
> >  - Stripped down patchset to focus on just the core features (I dropped
> >    mocking, spying, and the MMIO stuff for now; you can find these
> >    patches here: https://kunit-review.googlesource.com/c/linux/+/1132),
> >    as suggested by Rob.
> >  - Cleaned up some of the commit messages and tweaked commit order a
> >    bit based on suggestions.
>
> Do you have some example unit tests somewhere? The docs are all neat, but
> real example helps a lot with the tried&true art of copypasting :-)

Yes! So I have quite a few tests for KUnit itself, but they are mostly
in the patches that I cut from the previous version of the RFC:
https://kunit.googlesource.com/linux/+/c58019fb4fe15f820e51f857ae4ff14cd34075af/kunit/mock-macro-test.c
https://kunit.googlesource.com/linux/+/c58019fb4fe15f820e51f857ae4ff14cd34075af/kunit/mock-test.c
https://kunit.googlesource.com/linux/+/c58019fb4fe15f820e51f857ae4ff14cd34075af/kunit/string-stream-test.c
https://kunit.googlesource.com/linux/+/c58019fb4fe15f820e51f857ae4ff14cd34075af/kunit/test-stream-test.c
https://kunit.googlesource.com/linux/+/c58019fb4fe15f820e51f857ae4ff14cd34075af/kunit/test-test.c

There are some in this patchset (like here:
https://lore.kernel.org/patchwork/patch/1002904/), but I should
probably include some more...

In any case, if you are looking for a more "realistic" example, you
could look at these sets of tests, which I think is pretty good, and
actually found a couple bugs in existing code:
https://kunit.googlesource.com/linux/+/e10484ad2f9fc7926412ec84739fe105981b4771/drivers/i2c/busses/i2c-aspeed-test.c
https://kunit.googlesource.com/linux/+/4b41b1594ffeab70f1b4364721940cb909509d97/net/ipv6/route-test.c

>
> I'd like to give this a test spin with some of the unit tests we already
> have in drm. And especially figuring out how we could integrate this with
> our existing infrastructure.

Awesome! I am looking forward to hearing how it goes!

Cheers
