From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 21 Mar 2019 15:07:22 -0700
Message-ID: <CAFd5g47G=mTdk+=wpO+rkyO0+mAbEfPAg=Pr7_507Uek4sdWeA@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <6d9b3b21-1179-3a45-7545-30aa15306cb4@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <6d9b3b21-1179-3a45-7545-30aa15306cb4-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Bird,
 Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux
List-Id: linux-nvdimm@lists.01.org

On Wed, Mar 20, 2019 at 6:08 PM Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>
> Hi,
>
> On 2019-02-14 2:37 p.m., Brendan Higgins wrote:
> > This patch set proposes KUnit, a lightweight unit testing and mocking
> > framework for the Linux kernel.
>
> I haven't followed the entire conversation but I saw the KUnit write-up
> on LWN and ended up, as an exercise, giving it a try.

Awesome! Thanks for taking the time to try it out and to give me feedback!

>
> I really like the idea of having a fast unit testing infrastructure in
> the kernel. Occasionally, I write userspace tests for tricky functions
> that I essentially write by copying the code over to a throw away C file
> and exercise them as I need. I think it would be great to be able to
> keep these tests around in a way that they can be run by anyone who
> wants to touch the code.
>
> I was just dealing with some functions that required some mocked up
> tests so I thought I'd give KUnit a try. I found writing the code very
> easy and the infrastructure I was testing was quite simple to mock out
> the hardware.
>
> However, I got a bit hung up by one issue: I was writing unit tests for
> code in the NTB tree which itself depends on CONFIG_PCI which cannot be
> enabled in UML (for what should be obvious reasons). I managed to work
> around this because, as luck would have it, all the functions I cared
> about testing were actually static inline functions in headers. So I
> placed my test code in the kunit folder (so it would compile) and hacked
> around a couple a of functions I didn't care about that would not be
> compiled.

A couple of points, as for needing CONFIG_PCI; my plan to deal with
that type of thing has been that we would add support for a KUnit/UML
version that is just for KUnit. It would mock out the necessary bits
to provide a fake hardware implementation for anything that might
depend on it. I wrote a prototype for mocking/faking MMIO that I
presented to the list here[1]; it is not part of the current patchset
because we decided it would be best to focus on getting an MVP in, but
I plan on bringing it back up at some point. Anyway, what do you
generally think of this approach?

>
> In the end I got it to work acceptably, but I get the impression that

Awesome, I looked at the code you posted and it doesn't look like you
have had too many troubles. One thing that stood out to me, why did
you need to put it in the kunit/ dir?

> KUnit will not be usable for wide swaths of kernel code that can't be
> compiled in UML. Has there been any discussion or ideas on how to work

For the most part, I was planning on relying on mocking or faking the
hardware out as you have done. I have found this worked pretty well in
other instances. I know there are some edge cases for which even this
won't work like code in arch/; for that you *can* compile KUnit for
non-UML, but that is not really unit testing any more, but I included
it that as more of a last ditch effort, debugging aid, or to allow a
user to write integration tests (also very much because other people
asked me to do it ;-) ). So the main plan here is mocking and faking.

There has been some additional discussion here[2] (see the replies);
this thread is more about the future of trying to pull out kernel
dependencies which I discussed further with Luis (off list) here[3]
(in reality the discussion has been spread across a number of
different threads, but I think those are places you could at least get
context to jump in and talk about mocking and faking hardware and
Linux kernel resources).

In short, I think the idea is we are using UML as scaffolding and we
will gradually try to make it more independent by either reducing
dependencies on kernel resources (by providing high quality fakes) or
by somehow providing a better view of the dependencies so that you can
specify more directly what piece of code you need for your test. This
part is obviously very long term, but I think that's what we need to
do if we want to do really high quality unit testing, regardless of
whether we use KUnit or not. In anycase, right now, we are just
working on the basic tools to write *a* unit test for the kernel.

> around this so it can be more generally useful? Or will this feature be
> restricted roughly to non-drivers and functions in headers that don't
> have #ifdefs around them?

I hope not.

The #ifdef thing is something that I don't have a good answer for at
this time. Luis and I talked about it, but haven't come up with any
good ideas, sorry.

As for drivers, I found that testing drivers is quite doable. You can
see an example of a test I wrote for a i2c bus driver here[4]. I know
the i2c subsystem is pretty simple, but the general principle should
apply elsewhere.

>
> If you're interested in seeing the unit tests I ended up writing you can
> find the commits here[1].
>
> Thanks,
>
> Logan
>
> [1] https://github.com/sbates130272/linux-p2pmem/ ntb_kunit

I am looking forward to see what you think!

Cheers

[1] https://lkml.org/lkml/2018/10/17/122
[2] https://lkml.org/lkml/2018/11/29/93
[3] https://groups.google.com/forum/#!topic/kunit-dev/EQ1x0SzrUus
[4] https://kunit.googlesource.com/linux/+/e10484ad2f9fc7926412ec84739fe105981b4771/drivers/i2c/busses/i2c-aspeed-test.c
