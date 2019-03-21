From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 21 Mar 2019 21:14:40 +0100
Message-ID: <356e2b5f8d18b7789a38d0e6e3fe7a48784ba56b.camel@oracle.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <6d9b3b21-1179-3a45-7545-30aa15306cb4@deltatee.com>
 <01b2a950f661e8ebd6acbc45c2f89c8f10063daf.camel@oracle.com>
 <ce355f5c-189c-816c-cde4-fb4e816d44e7@deltatee.com>
 <CAFd5g45LKU+SZAFzn3RNCoxhzum0NAr9t+UJ80SJDMc_FeKgBQ@mail.gmail.com>
 <73b62e929f631038a9d8d21d261aa22ac3c18949.camel@oracle.com>
 <961494a3-d08c-2720-c59d-7d7008edb288@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <961494a3-d08c-2720-c59d-7d7008edb288-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Bird,
 Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TZUIDd8j+nm9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, 2019-03-21 at 13:29 -0600, Logan Gunthorpe wrote:
> 
> On 2019-03-21 1:13 p.m., Knut Omang wrote:
> > > Nevertheless, I don't really see KTF as a real unit testing framework
> > > for a number of different reasons; you pointed out some below, but I
> > > think the main one being that it requires booting a real kernel on
> > > actual hardware; 
> > 
> > That depends on what you want to test. If you need hardware (or simulated or
> > emulated hardware) for the test, of course you would need to have that
> > hardware,
> > but if, lets say, you just wanted to run tests like the skbuff example tests
> > (see link above) you wouldn't need anything more than what you need to run
> > KUnit
> > tests.
> 
> I'm starting to get the same impression: KTF isn't unit testing. When we
> are saying "unit tests" we are specifying exactly what we want to test:
> small sections of code in isolation. So by definition you should not
> need hardware for this.

In my world hardware is just that: a piece of code. It can be in many forms, but
it is still code to be tested, and code that can be changed (but sometimes at a
slightly higher cost than a recompile ;-)

But that's not the point here: KTF can be used for your narrower definition of
unit tests, and it can be used for small, precise tests, for particular bugs for
instance, that you would not characterize as a unit test, still it serves the
same purpose, and I believe in a pragmatic approach to this. We want to maximize
the value of our time. I believe there's a sweet point wrt return on investment
on the scale from purist unit testing to just writing code and test with
existing applications. We're targeting that ;-)

> > I have fulfilled that dream, so I know it is possible (Inifinband driver,
> > kernels from 2.6.39 to 4.8.x or so..) I know a lot of projects would benefit
> > from support for such workflows, but that's not really the point here - we
> > want
> > to achieve both goals!
> 
> This is what makes me think we are not talking about testing the same
> things. We are not talking about end to end testing of entire drivers
> but smaller sections of code.

No! I am talking about testing units within a driver, or within any kernel
component. I am sure you agree that what constitutes a unit depend on what 
level of abstraction you are looking at.

>  A unit test is far more granular and
> despite an infinband driver existing for 2.6.39 through 4.8, the
> internal implementation could be drastically different. But unit tests
> would be testing internal details which could be very different version
> to version and has to evolve with the implementation.

> > If your target component under test can be built as a kernel module, or set
> > of
> > modules, with KTF your workflow would not involve booting at all (unless you
> > happened to crash the system with one of your tests, that is :) )
> > You would just unload your module under test and the test module, recompile
> > the
> > two and insmod again. My work current work cycle on this is just a few
> > seconds.
> 
> Yes, I'm sure we've all done that many a time but it's really beside the
> point. Kunit offers a much nicer method for running a lot of unit tests
> on existing code.

Again, use cases and examples are the key here,..

Knut
