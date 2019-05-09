From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 09 May 2019 13:52:15 +0200
Message-ID: <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <54940124-50df-16ec-1a32-ad794ee05da7@gmail.com>
 <20190507080119.GB28121@kroah.com>
 <a09a7e0e-9894-8c1a-34eb-fc482b1759d0@gmail.com>
 <20190509015856.GB7031@mit.edu>
 <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190509032017.GA29703-3s7WtUTddSA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: pmladek-IBi9RG/b67k@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, 2019-05-08 at 23:20 -0400, Theodore Ts'o wrote:
> On Wed, May 08, 2019 at 07:13:59PM -0700, Frank Rowand wrote:
> > > If you want to use vice grips as a hammer, screwdriver, monkey wrench,
> > > etc.  there's nothing stopping you from doing that.  But it's not fair
> > > to object to other people who might want to use better tools.
> > > 
> > > The reality is that we have a lot of testing tools.  It's not just
> > > kselftests.  There is xfstests for file system code, blktests for
> > > block layer tests, etc.   We use the right tool for the right job.
> > 
> > More specious arguments.
> 
> Well, *I* don't think they are specious; so I think we're going to
> have to agree to disagree.

Looking at both Frank's and Ted's arguments here, I don't think you 
really disagree, I just think you are having different classes of tests in mind.

In my view it's useful to think in terms of two main categories of 
interesting unit tests for kernel code (using the term "unit test" pragmatically):

1) Tests that exercises typically algorithmic or intricate, complex
   code with relatively few outside dependencies, or where the dependencies 
   are considered worth mocking, such as the basics of container data 
   structures or page table code. If I get you right, Ted, the tests 
   you refer to in this thread are such tests. I believe covering this space 
   is the goal Brendan has in mind for KUnit.

2) Tests that exercises interaction between a module under test and other 
   parts of the kernel, such as testing intricacies of the interaction of 
   a driver or file system with the rest of the kernel, and with hardware, 
   whether that is real hardware or a model/emulation. 
   Using your testing needs as example again, Ted, from my shallow understanding,
   you have such needs within the context of xfstests (https://github.com/tytso/xfstests)

To 1) I agree with Frank in that the problem with using UML is that you still have to
relate to the complexity of a kernel run time system, while what you really want for these
types of tests is just to compile a couple of kernel source files in a normal user land
context, to allow the use of Valgrind and other user space tools on the code. The
challenge is to get the code compiled in such an environment as it usually relies on
subtle kernel macros and definitions, which is why UML seems like such an attractive
solution. Like Frank I really see no big difference from a testing and debugging 
perspective of UML versus running inside a Qemu/KVM process, and I think I have an idea 
for a better solution: 

In the early phases of the SIF project which mention below, I did a lot of experimentation around this. My biggest challenge then was to test the driver
implementation of the pages table handling of an Intel page table compatible on-device 
MMU, using a mix of page sizes, but with a few subtle limitations in the hardware. With some efforts of code generation and heavy automated use of
compiler feedback, I was able 
to do that to great satisfaction, as it probably saved the project a lot of time in 
debugging, and myself a lot of pain :)

To 2) most of the current xfstests (if not all?) are user space tests that do not use 
extra test specific kernel code, or test specific changes to the modules under test (am I 
right, Ted?) and I believe that's just as it should be: if something can be exercised well enough from user space, then that's the easier approach. 

However sometimes the test cannot be made easily without interacting directly 
with internal kernel interfaces, or having such interaction would greatly simplify or
increase the precision of the test. This need was the initial motivation for us to make 
KTF (https://github.com/oracle/ktf, http://heim.ifi.uio.no/~knuto/ktf/index.html) which we are working on to adapt to fit naturally and in the right way
as a kernel patch set.

We developed the SIF infiniband HCA driver
(https://github.com/oracle/linux-uek/tree/uek4/qu7/drivers/infiniband/hw/sif)
and associated user level libraries in what I like to call a "pragmatically test driven" 
way. At the end of the project we had quite a few unit tests, but only a small fraction of them were KTF tests, most of the testing needs were covered
by user land unit tests, 
and higher level application testing.

To you Frank, and your concern about having to learn yet another tool with it's own set of syntax, I completely agree with you. We definitely would want
to minimize the need to 
learn new ways, which is why I think it is important to see the whole complex of unit
testing together, and at least make sure it works in a unified and efficient way from a
syntax and operational way. 

With KTF we focus on trying to make kernel testing as similar and integrated with user
space tests as possible, using similar test macros, and also to not reinvent more wheels than necessary by basing reporting and test execution on
existing user land tools.
KTF integrates with Googletest for this functionality. This also makes the reporting format discussion here irrelevant for KTF, as KTF supports whatever
reporting format the user land tool supports - Googletest for instance naturally supports pluggable reporting implementations, and there already seems
to be a TAP reporting extension out there (I haven't tried it yet though)

Using and relating to an existing user land framework allows us to have a set of 
tests that works the same way from a user/developer perspective, 
but some of them are kernel only tests, some are ordinary user land 
tests, exercising system call boundaries and other kernel
interfaces, and some are what we call "hybrid", where parts of 
the test run in user mode and parts in kernel mode.

I hope we can discuss this complex in more detail, for instance at the testing 
and fuzzing workshop at LPC later this year, where I have proposed a topic for it.

Thanks,
Knut
