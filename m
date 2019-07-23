From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 04/18] kunit: test: add kunit_stream a std::stream like
 logger
Date: Mon, 22 Jul 2019 17:32:19 -0700
Message-ID: <CAFd5g46h9XSRfA1H4kZR7u0Eh_F-fgPjoLPzqzLgFTXxeb105g@mail.gmail.com>
References: <20190712081744.87097-1-brendanhiggins@google.com>
 <CAFd5g47ikJmA0uGoavAFsh+hQvDmgsOi26tyii0612R=rt7iiw@mail.gmail.com>
 <CAFd5g44_axVHNMBzxSURQB_-R+Rif7cZcg7PyZ_SS+5hcy5jZA@mail.gmail.com>
 <20190716175021.9CA412173C@mail.kernel.org>
 <CAFd5g453vXeSUCZenCk_CzJ-8a1ym9RaPo0NVF=FujF9ac-5Ag@mail.gmail.com>
 <20190718175024.C3EC421019@mail.kernel.org>
 <CAFd5g46a7C1+R6ZcE_SkqaYqgrH5Rx3M=X7orFyaMgFLDbeYYA@mail.gmail.com>
 <20190719000834.GA3228@google.com> <20190722200347.261D3218C9@mail.kernel.org>
 <CAFd5g45hdCxEavSxirr0un_uLzo5Z-J4gHRA06qjzcQrTzmjVg@mail.gmail.com>
 <20190722235411.06C1320840@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190722235411.06C1320840-+nuXSHJNwjE76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild <linux-kbuild-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Jul 22, 2019 at 4:54 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Quoting Brendan Higgins (2019-07-22 15:30:49)
> > On Mon, Jul 22, 2019 at 1:03 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > >
> > > What's the calling context of the assertions and expectations? I still
> > > don't like the fact that string stream needs to allocate buffers and
> > > throw them into a list somewhere because the calling context matters
> > > there.
> >
> > The calling context is the same as before, which is anywhere.
>
> Ok. That's concerning then.

Yeah. Luis suggested just not supporting the IRQ context until later.
See my later comment.

> > > I'd prefer we just wrote directly to the console/log via printk
> > > instead. That way things are simple because we use the existing
> > > buffering path of printk, but maybe there's some benefit to the string
> > > stream that I don't see? Right now it looks like it builds a string and
> > > then dumps it to printk so I'm sort of lost what the benefit is over
> > > just writing directly with printk.
> >
> > It's just buffering it so the whole string gets printed uninterrupted.
> > If we were to print out piecemeal to printk, couldn't we have another
> > call to printk come in causing it to garble the KUnit message we are
> > in the middle of printing?
>
> Yes, printing piecemeal by calling printk many times could lead to
> interleaving of messages if something else comes in such as an interrupt
> printing something. Printk has some support to hold "records" but I'm
> not sure how that would work here because KERN_CONT talks about only
> being used early on in boot code. I haven't looked at printk in detail
> though so maybe I'm all wrong and KERN_CONT just works?

It says KERN_CONT is not SMP safe, and it isn't supposed to contain
newlines, so it doesn't sound like it does any buffering for you. I
looked at it a while ago and those comments agreed with my
understanding of the code, but I could be wrong.

> Can printk be called once with whatever is in the struct?

Unfortunately, no. That is part of what I was trying to illustrate
with this patch. Most of the messages are deterministic, but
hardcoding all the possible message types would lead to a massive
number of hard coded strings. However, even this would break down for
the mocking formatters. All the different ways a function can be
called are just too complex to encode into a finite set of hard coded
fmt strings.

> Otherwise if
> this is about making printk into a structured log then maybe printk
> isn't the proper solution anyway. Maybe a dev interface should be used
> instead that can handle starting and stopping tests (via ioctl) in
> addition to reading test results, records, etc. with read() and a
> clearing of the records. Then the seqfile API works naturally. All of

Ehhh...I wouldn't mind providing such an interface, but I would really
like to be able to provide the results without having to depend on a
userland doing something to get test results. That has always been a
pretty important goal for me.

> this is a bit premature, but it looks like you're going down the path of
> making something akin to ftrace that stores binary formatted
> assertion/expectation records in a lockless ring buffer that then
> formats those records when the user asks for them.

Like you said, I think it is a bit premature to go that far.

In anycase, I don't see a way to get rid of string_stream, without
significantly sacrificing usability.

> I can imagine someone wanting to write unit tests that check conditions
> from a simulated hardirq context via irq works (a driver mock
> framework?), so this doesn't seem far off.

Yep, I actually presented the first pieces of that in the RFC v1 that
I linked to you earlier in this discussion. I have a more fleshed out
example here:

https://kunit.googlesource.com/linux/+/e10484ad2f9fc7926412ec84739fe105981b4771/drivers/i2c/busses/i2c-aspeed-test.c

I actually already have some people at Google playing around with it.
So yeah, not far off at all! However, in these cases we are not
actually running in the IRQ context (despite the fact that we are
testing IRQ code) because we provide a fake IRQ chip, or some other
fake mechanism that triggers the IRQ. Still, I could see someone
wanting to do it in a non-fake-IRQ context.

Luis' suggestion was just to hold off on the IRQ safe stuff at the
outset, since that is going to require a lot more effort to review. I
know that's kind of the future coding argument again, but maybe the
answer will be to just restrict what features an IRQ user has access
to (maybe just really simple expectations, for example). I mean, we
will probably have to restrict what they are allowed to use anyway.

Luis, do you have any ideas?

Cheers
