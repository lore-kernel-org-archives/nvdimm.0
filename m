From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 21 Mar 2019 20:13:56 +0100
Message-ID: <73b62e929f631038a9d8d21d261aa22ac3c18949.camel@oracle.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <6d9b3b21-1179-3a45-7545-30aa15306cb4@deltatee.com>
 <01b2a950f661e8ebd6acbc45c2f89c8f10063daf.camel@oracle.com>
 <ce355f5c-189c-816c-cde4-fb4e816d44e7@deltatee.com>
 <CAFd5g45LKU+SZAFzn3RNCoxhzum0NAr9t+UJ80SJDMc_FeKgBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAFd5g45LKU+SZAFzn3RNCoxhzum0NAr9t+UJ80SJDMc_FeKgBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Bird,
 Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TZUIDd8j+nm9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, 2019-03-21 at 09:55 -0700, Brendan Higgins wrote:
> On Thu, Mar 21, 2019 at 8:56 AM Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
> > 
> > 
> > On 2019-03-20 11:23 p.m., Knut Omang wrote:
> > > Testing drivers, hardware and firmware within production kernels was the
> > > use
> > > case that inspired KTF (Kernel Test Framework). Currently KTF is available
> > > as a
> > > standalone git repository. That's been the most efficient form for us so
> > > far,
> > > as we typically want tests to be developed once but deployed on many
> > > different
> > > kernel versions simultaneously, as part of continuous integration.
> > 
> > Interesting. It seems like it's really in direct competition with KUnit.
> 
> I won't speak for Knut, but I don't think we are in competition. 

I would rather say we have some overlap in functionality :)
My understanding is that we have a common goal of providing better
infrastructure for testing, but have approached this whole problem complex from
somewhat different perspectives.

> I see
> KTF as a novel way to do a kind of white box end-to-end testing for
> the Linux kernel, which is a valuable thing, especially in some
> circumstances. I could see KTF having a lot of value for someone who
> wants to maintain out of tree drivers, in particular.

The best argument here is really good examples.
I'm not sure the distinction between "black box" and "white box" testing is
useful here, there's always underlying assumptions behind specific,
deterministic tests. Writing a test is a very good way to get to 
understand a piece of code. Just look at the flow of the example in
https://blogs.oracle.com/linux/writing-kernel-tests-with-the-new-kernel-test-framework-ktf, clearly unit tests, but the knowledge gathering is an important
part and motivation!

> Nevertheless, I don't really see KTF as a real unit testing framework
> for a number of different reasons; you pointed out some below, but I
> think the main one being that it requires booting a real kernel on
> actual hardware; 

That depends on what you want to test. If you need hardware (or simulated or
emulated hardware) for the test, of course you would need to have that hardware,
but if, lets say, you just wanted to run tests like the skbuff example tests
(see link above) you wouldn't need anything more than what you need to run KUnit
tests.

> I imagine it could be made to work on a VM, but that
> isn't really the point; it fundamentally depends on having part of the
> test, or at least driving the test from userspace on top of the kernel
> under test. Knut, myself, and others, had a previous discussion to
> this effect here: https://lkml.org/lkml/2018/11/24/170

> > I didn't really go into it in too much detail but these are my thoughts:
> > 
> > From a developer perspective I think KTF not being in the kernel tree is
> > a huge negative. I want minimal effort to include my tests in a patch
> > series and minimal effort for other developers to be able to use them.
> > Needing to submit these tests to another project or use another project
> > to run them is too much friction.

As said, I recognize the need to upstream KTF, and we are working to do that,
that's why I bother to write this :)

> > Also I think the goal of having tests that run on any kernel version is
> > a pipe dream. 

I have fulfilled that dream, so I know it is possible (Inifinband driver,
kernels from 2.6.39 to 4.8.x or so..) I know a lot of projects would benefit
from support for such workflows, but that's not really the point here - we want
to achieve both goals!

> > You'd absolutely need a way to encode which kernel
> > versions a test is expected to pass on because the tests might not make
> > sense until a feature is finished in upstream. And this makes it even
> > harder to develop these tests because, when we write them, we might not
> > even know which kernel version the feature will be added to. Similarly,
> > if a feature is removed or substantially changed, someone will have to
> > do a patch to disable the test for subsequent kernel versions and create
> > a new test for changed features. So, IMO, tests absolutely have to be
> > part of the kernel tree so they can be changed with the respective
> > features they test.

Of course a feature that is not part of a kernel cannot easily pass for that
kernel. And yes, testing for kernel version might be necessary in some cases,
and even to write a section of extra code to handle differences, still that's 
worth the benefit.
And that's also a use case: "Can I use kernel v.X.Y.Z if I need feature w?"
Lets assume we had a set of tests covering a particular feature, and someone
needed that feature, then they could just run the latest set of tests for that
feature on an older kernel to determine if they had enough support for what they
needed. If necessary, they could then backport the feature, and run the tests to
verify that they actually implemented it correctly.

On example I recall of this from the Infiniband driver times was 
the need to have a predictable way to efficiently use huge scatterlists across
kernels. We relied upon scatterlist chaining in a particular way, and the API
descriptions did not really specify to a detailed enough level how the
guaranteed semantics were supposed to be.
I wrote a few simple KTF tests that tested the driver code for the semantics we
expected, and ran them against older and newer kernels and used them to make
sure we would have a driver that worked across a few subtle changes to
scatterlists and their use. 

> > Kunit's ability to run without having to build and run the entire kernel
> >  is also a huge plus. 

IMHO the UML kernel is still a kernel running inside a user land program,
and so is a QEMU/KVM VM, which is my favourite KTF test environment.
 
Also with UML it is more difficult/less useful to deploy user space tools such
as valgrind, which IMHO would be my main reason for getting kernel code out of
the kernel. I recognize that there's a need for 
doing just that (e.g. compiling complicated data structures entirely in user
space with mocked interfaces) but I think it would be much more useful 
to be able to do that without the additional complexity of UML (or QEMU).

> > (Assuming there's a way to get around the build
> > dependency issues). Because of this, it can be very quick to run these
> > tests which makes development a *lot* easier seeing you don't have to
> > reboot a machine every time you want to test a fix.

If your target component under test can be built as a kernel module, or set of
modules, with KTF your workflow would not involve booting at all (unless you
happened to crash the system with one of your tests, that is :) )

You would just unload your module under test and the test module, recompile the
two and insmod again. My work current work cycle on this is just a few seconds.

> I will reply to your comments directly on your original email. I don't
> want to hijack this thread, in case we want to discuss the topic of
> KUnit vs. KTF further.

Good idea!
We can at least agree upon that such an important matter as this can 
be worthy a good, detailed discussion! :)

Thanks!
Knut
