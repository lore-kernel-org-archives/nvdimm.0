From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 21 Mar 2019 06:23:59 +0100
Message-ID: <01b2a950f661e8ebd6acbc45c2f89c8f10063daf.camel@oracle.com>
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
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi Logan,

On Wed, 2019-03-20 at 19:07 -0600, Logan Gunthorpe wrote:
> Hi,
> 
> On 2019-02-14 2:37 p.m., Brendan Higgins wrote:
> > This patch set proposes KUnit, a lightweight unit testing and mocking
> > framework for the Linux kernel.
> 
> I haven't followed the entire conversation but I saw the KUnit write-up
> on LWN and ended up, as an exercise, giving it a try.
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
> 
> In the end I got it to work acceptably, but I get the impression that
> KUnit will not be usable for wide swaths of kernel code that can't be
> compiled in UML. Has there been any discussion or ideas on how to work
> around this so it can be more generally useful? Or will this feature be
> restricted roughly to non-drivers and functions in headers that don't
> have #ifdefs around them?

Testing drivers, hardware and firmware within production kernels was the use
case that inspired KTF (Kernel Test Framework). Currently KTF is available as a
standalone git repository. That's been the most efficient form for us so far, 
as we typically want tests to be developed once but deployed on many different
kernel versions simultaneously, as part of continuous integration.

But we're also working towards a suitable proposal for how it can be 
smoothly integrated into the kernel, but while still keeping the benefits 
and tools to allow cross-kernel development of tests. As part of this,
I have a master student who has been looking at converting some of 
the existing kernel test suites to KTF, and we have more examples coming 
from our internal usage, as we get more mileage and more users.
See for instance this recent blog entry testing skbuff as an example,
on the Oracle kernel development blog:

https://blogs.oracle.com/linux/writing-kernel-tests-with-the-new-kernel-test-framework-ktf

Other relevant links:

Git repo: https://github.com/oracle/ktf
Formatted docs: http://heim.ifi.uio.no/~knuto/ktf/
LWN mention from my presentation at LPC'17: https://lwn.net/Articles/735034/
Earlier Oracle blog post: https://blogs.oracle.com/linux/oracles-new-kernel-test-framework-for-linux-v2
OSS'18 presentation slides: https://events.linuxfoundation.org/wp-content/uploads/2017/12/Test-Driven-Kernel-Development-Knut-Omang-Oracle.pdf

> If you're interested in seeing the unit tests I ended up writing you can
> find the commits here[1].

It would certainly be interesting to see how the use cases you struggled with
would work with KTF ;-)

Thanks,
Knut

>
> Thanks,
> 
> Logan
> 
> [1] https://github.com/sbates130272/linux-p2pmem/ ntb_kunit
