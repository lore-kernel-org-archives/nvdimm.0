From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 01/18] kunit: test: add KUnit test runner core
Date: Wed, 26 Jun 2019 17:05:13 -0700
Message-ID: <CAFd5g46yp3B6SB9OZRoum8-CDA-BW_En7BGz5WH8qFRx1d=8iA@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-2-brendanhiggins@google.com>
 <20190620001526.93426218BE@mail.kernel.org>
 <CAFd5g46Jhxsz6_VXHEVYvTeDRwwzgKpr=aUWLL5b3S4kUukb8g@mail.gmail.com>
 <20190625214427.GN19023@42.do-not-panic.com>
 <CAFd5g47OABqN127cPKqoCOA_Wr9w=LFh_0XkF7LXu2iY9sFkSw@mail.gmail.com>
 <20190625230253.GQ19023@42.do-not-panic.com>
 <CAFd5g45fSdpytudDyD3Yo1ti=kU_JJ6S9yz53_L=pnZTjQFU9A@mail.gmail.com>
 <20190626220204.GZ19023@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190626220204.GZ19023-24ieFPqdLRAUX4Zk0b6cZUEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild <linux-kbuild-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jun 26, 2019 at 3:02 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Tue, Jun 25, 2019 at 11:41:47PM -0700, Brendan Higgins wrote:
> > On Tue, Jun 25, 2019 at 4:02 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Tue, Jun 25, 2019 at 03:14:45PM -0700, Brendan Higgins wrote:
> > > > On Tue, Jun 25, 2019 at 2:44 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > > Since its a new architecture and since you seem to imply most tests
> > > > > don't require locking or even IRQs disabled, I think its worth to
> > > > > consider the impact of adding such extreme locking requirements for
> > > > > an initial ramp up.
> > > >
> > > > Fair enough, I can see the point of not wanting to use irq disabled
> > > > until we get someone complaining about it, but I think making it
> > > > thread safe is reasonable. It means there is one less thing to confuse
> > > > a KUnit user and the only penalty paid is some very minor performance.
> > >
> > > One reason I'm really excited about kunit is speed... so by all means I
> > > think we're at a good point to analyze performance optimizationsm if
> > > they do make sense.
> >
> > Yeah, but I think there are much lower hanging fruit than this (as you
> > point out below). I am all for making/keeping KUnit super fast, but I
> > also don't want to waste time with premature optimizations and I think
> > having thread safe expectations and non-thread safe expectations hurts
> > usability.
> >
> > Still, I am on board with making this a mutex instead of a spinlock for now.
> >
> > > While on the topic of parallization, what about support for running
> > > different test cases in parallel? Or at the very least different kunit
> > > modules in parallel.  Few questions come up based on this prospect:
> > >
> > >   * Why not support parallelism from the start?
> >
> > Just because it is more work and there isn't much to gain from it right now.
> >
> > Some numbers:
> > I currently have a collection of 86 test cases in the branch that this
> > patchset is from.
>
> Impressive, imagine 86 tests and kunit is not even *merged yet*.

Full disclaimer, about half of them are KUnit tests for KUnit - to
make sure KUnit works, so I don't know if you consider that cheating.

> > I turned on PRINTK_TIME and looked at the first
> > KUnit output and the last. On UML, start time was 0.090000, and end
> > time was 0.090000. Looks like sched_clock is not very good on UML.
>
> Since you have a python thing that kicks tests, what if you just run
> time on it?

That's what I did on the this following paragraph (I just couldn't
time the tests by themselves in this case):

> > Still it seems quite likely that all of these tests run around 0.01
> > seconds or less on UML: I ran KUnit with only 2 test cases enabled
> > three times and got an average runtime of 1.55867 seconds with a
> > standard deviation of 0.0346747. I then ran it another three times
> > with all test cases enabled and got an average runtime of 1.535
> > seconds with a standard deviation of 0.0150997. The second average is
> > less, but that doesn't really mean anything because it is well within
> > one standard deviation with a very small sample size. Nevertheless, we
> > can conclude that the actual runtime of those 84 test cases is most
> > likely within one standard deviation, so on the order of 0.01 seconds.
> >
> > On x86 running on QEMU, first message from KUnit was printed at
> > 0.194251 and the last KUnit message was printed at 0.340915, meaning
> > that all 86 test cases ran in about 0.146664 seconds.
>
> Pretty impressive numbers. But can you blame me for expressing the
> desire to possibly being able to do better? I am not saying -- let's
> definitely have parallelism in place *now*. Just wanted to hear out
> tangibles of why we *don't* want it now.

I agree, faster is almost always better in these types of things, and
certainly is in this case.

In fairness to you, I also short sold the speed of KUnit in the cover
letter. I was too lazy to do this complete of an analysis back when I
wrote it (even if I did a complete timing like this, I would have to
put a bunch of asterisks since it wouldn't include the time to "boot"
the kernel or to build it, which vastly outstrip the speed of
individual test cases). And given the original numbers, I think
speeding things up would probably seem more urgent. So no, I really
cannot blame you.

Sorry if it came across that I was frustrated or impatient, but I am
actually glad you asked because I now have this public email where I
did the full analysis of how fast KUnit really is which I can refer to
in the future.

> And.. also, since we are reviewing now, try to target so that the code
> can later likely get a face lift to support parallelism without
> requiring much changes.

Also fair.

> > In any case, running KUnit tests in parallel is definitely something I
> > plan on adding it eventually, but it just doesn't really seem worth it
> > right now.
>
> Makes sense!
>
> > I find the incremental build time of the kernel to
> > typically be between 3 and 30 seconds, and a clean build to be between
> > 30 seconds to several minutes, depending on the number of available
> > cores, so I don't think most users would even notice the amount of
> > runtime contributed by the actual unit tests until we start getting
> > into the 1000s of test cases. I don't suspect it will become an issue
> > until we get into the 10,000s of test cases. I think we are a pretty
> > long way off from that.
>
> All makes sense, and agreed based on the numbers you are providing.
> Thanks for the details!
>
> > >   * Are you opposed to eventually having this added? For instance, there is
> > >     enough code on lib/test_kmod.c for batching tons of kthreads each
> > >     one running its own thing for testing purposes which could be used
> > >     as template.
> >
> > I am not opposed to adding it eventually at all. I actually plan on
> > doing so, just not in this patchset. There are a lot of additional
> > features, improvements, and sugar that I really want to add, so much
> > so that most of it doesn't belong in this patchset; I just think this
> > is one of those things that belongs in a follow up. I tried to boil
> > down this patchset to as small as I could while still being useful;
> > this is basically an MVP. Maybe after this patchset gets merged I
> > should post a list of things I have ready for review, or would like to
> > work on, and people can comment on what things they want to see next.
>
> Groovy.

Cool, I will do that then!

> > >   * If we eventually *did* support it:
> > >     - Would logs be skewed?
> >
> > Probably, before I went with the TAP approach, I was tagging each
> > message with the test case it came from and I could have parsed it and
> > assembled a coherent view of the logs using that; now that I am using
> > TAP conforming output, that won't work. I haven't really thought too
> > hard about how to address it, but there are ways. For the UML users, I
> > am planning on adding a feature to guarantee hermeticity between tests
> > running in different modules by adding a feature that allows a single
> > kernel to be built with all tests included, and then determine which
> > tests get run by passing in command line arguments or something. This
> > way you can get the isolation from running tests in separate
> > environments without increasing the build cost. We could also use this
> > method to achieve parallelism by dispatching multiple kernels at once.
>
> Indeed. Or... wait for it... containers... There tools for these sorts
> of things already. And I'm evaluating such prospects now for some other
> tests I care for.

Containers could definitely be useful in the long run. I have a long
term goal to build and run just parts of the kernel as I have
mentioned to you, and doing so in a totally hermetic environment could
provide a lot of value; in this case I would probably only want a
chroot, but if I want to deploy tests to run on different machines
containers could be very useful.

Actually, on the topic of containers for running tests, the presubmit
system I have set up for KUnit uses containers for deploying KUnit on
servers for testing[1]. Actually, I have some experimental patches to
make it work with LKML instead of Gerrit, but I am not sure whether it
makes more sense to go that route, with one of the many patchworks
clones that support presubmit, or something else.

> > That only works for UML, but I imagine you could do something similar
> > for users running tests under qemu.
>
> Or containers.
>
> > >     - Could we have a way to query: give me log for only kunit module
> > >       named "foo"?
> >
> > Yeah, I think that would make sense as part of the hermeticity thing I
> > mentioned above.
> >
> > Hope that seems reasonable!
>
> All groovy. Thanks for the details!

[1] https://kunit-review.googlesource.com/c/linux/+/1809/2#message-c243e1c9086d9432d2dcabc67a42a977b8a020ff
