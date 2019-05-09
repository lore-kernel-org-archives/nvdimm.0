From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 09 May 2019 16:48:51 +0200
Message-ID: <3ce70d58c41be8c907c21ec7d3450b269ede8287.camel@oracle.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <54940124-50df-16ec-1a32-ad794ee05da7@gmail.com>
 <20190507080119.GB28121@kroah.com>
 <a09a7e0e-9894-8c1a-34eb-fc482b1759d0@gmail.com>
 <20190509015856.GB7031@mit.edu>
 <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
 <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
 <20190509133551.GD29703@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190509133551.GD29703-3s7WtUTddSA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: pmladek-IBi9RG/b67k@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Thu, 2019-05-09 at 09:35 -0400, Theodore Ts'o wrote:
> On Thu, May 09, 2019 at 01:52:15PM +0200, Knut Omang wrote:
> > 1) Tests that exercises typically algorithmic or intricate, complex
> >    code with relatively few outside dependencies, or where the dependencies 
> >    are considered worth mocking, such as the basics of container data 
> >    structures or page table code. If I get you right, Ted, the tests 
> >    you refer to in this thread are such tests. I believe covering this space 
> >    is the goal Brendan has in mind for KUnit.
> 
> Yes, that's correct.  I'd also add that one of the key differences is
> that it sounds like Frank and you are coming from the perspective of
> testing *device drivers* where in general there aren't a lot of
> complex code which is hardware independent.  After all, the vast
> majority of device drivers are primarily interface code to hardware,
> with as much as possible abstracted away to common code.  (Take, for
> example, the model of the SCSI layer; or all of the kobject code.)
>
> > 2) Tests that exercises interaction between a module under test and other 
> >    parts of the kernel, such as testing intricacies of the interaction of 
> >    a driver or file system with the rest of the kernel, and with hardware, 
> >    whether that is real hardware or a model/emulation. 
> >    Using your testing needs as example again, Ted, from my shallow understanding,
> >    you have such needs within the context of xfstests (
> https://github.com/tytso/xfstests)
> 
> Well, upstream is for xfstests is git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

Thanks for the correction!

> The test framework where I can run 20 hours worth of xfstests
> (multiple file system features enabled, multiple mount options, etc.)
> in 3 hours of wall clock time using multiple cloud VM is something
> called gce-xfstests.
> 
> I also have kvm-xfstests, which optimizes low test latency, where I
> want to run a one or a small number of tests with a minimum of
> overhead --- gce startup and shutdown is around 2 minutes, where as
> kvm startup and shutdown is about 7 seconds.  As far as I'm concerned,
> 7 seconds is still too slow, but that's the best I've been able to do
> given all of the other things I want a test framework to do, including
> archiving test results, parsing the test results so it's easy to
> interpret, etc.  Both kvm-xfstests and gce-xfstests are located at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> So if Frank's primary argument is "too many frameworks", it's already
> too late.  The block layer has blktests has a seprate framework,
> called blktests --- and yeah, it's a bit painful to launch or learn
> how to set things up.

I agree at that level - and the good thing is that there are a lot to learn 
from looking at other people's ways - but working towards unification rather than even
more similar, but subtly different ways I think is a good thing anyway!

> That's why I added support to run blktests using gce-xfstests and
> kvm-xfstests, so that "gce-xfstests --blktests" or "kvm-xfstests
> --xfstests" will pluck a kernel from your build tree, and launch at
> test appliance VM using that kernel and run the block layer tests.
> 
> The point is we *already* have multiple test frameworks, which are
> optimized for testing different parts of the kernel.  And if you plan
> to do a lot of work in these parts of the kernel, you're going to have
> to learn how to use some other test framework other than kselftest.
> Sorry, that's just the way it goes.
> 
> Of course, I'll accept trivial patches that haven't been tested using
> xfstests --- but that's because I can trivially run the smoke test for
> you.  Of course, if I get a lot of patches from a contributor which
> cause test regressions, I'll treat them much like someone who
> contribute patches which fail to build.  I'll apply pressure to the
> contributor to actually build test, or run a ten minute kvm-xfstests
> smoke test.  Part of the reason why I feel comfortable to do this is
> it's really easy to run the smoke test.  There are pre-compiled test
> appliances, and a lot of documentation:
> 
> https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
> 
> This is why I have close to zero sympathy to Frank's complaint that
> extra test frameworks are a bad thing.  To me, that's whining.  I've
> done a huge amount of work to meet contributors more than half-way.
> The insistence that "There Must Be One", ala the Highlander movie, is
> IMHO so wrong that it's not even close.  Is it really that hard to do
> a "git pull", download a test appliance, set up a config file to tell
> kvm-xfstests where to find your build tree, and then run "kvm-xfstests
> --smoke" or "gce-xfstests --smoke"?  Cry me a river.
> 
> There are already multiple test frameworks, and if you expect to do a
> lot of work in a particular subsystem, you'll be expected to use the
> Maintainer's choice of tests.  Deal with it.  We do this so we can
> scale to the number of contributors we have in our subsystem.
> 
> > To 1) I agree with Frank in that the problem with using UML is that you still have to
> > relate to the complexity of a kernel run time system, while what you really want for
> these
> > types of tests is just to compile a couple of kernel source files in a normal user
> land
> > context, to allow the use of Valgrind and other user space tools on the code.
> 
> "Just compiling a couple of kernel source files in a normal user land"
> is much harder than you think.  It requires writing vast numbers of
> mocking functions --- for a file system I would have to simulate the
> block device layer, large portions of the VFS layer, the scheduler and
> the locking layer if I want to test locking bugs, etc., etc.  In
> practice, UML itself is serving as mocking layer, by its mere
> existence.  

I might not see the full picture here wrt file system testing, 
but I do know exactly how difficult it is to do it for that ~29,000 
lines of code Infiniband driver I was working on, since actually I did it
with several versions of the kernel. Anyway that's probably more of a 
topic for a talk than an email thread :-)

> So when Frank says that KUnit doesn't provide any mocking
> functions, I don't at all agree.  Using KUnit and UML makes testing
> internal interfaces *far* simpler, especially if the comparison is
> "just compile some kernel source files as part of a userspace test
> program".
> 
> Perhaps your and Frank's experience is different --- perhaps that can
> be explained by your past experience and interest in testing device
> drivers as opposed to file systems.
> 
> The other thing I'd add is that at least for me, a really important
> consideration is how quickly we can run tests.  I consider
> minimization of developer friction (e.g., all you need to do is
> running "make ; kvm-xfstests --smoke" to run tests), and maximizing
> developer velocity to be high priority goals.  Developer velocity is
> how quickly can you run the tests; ideally, less than 5-10 seconds.

I completely agree on that one. I think a fundamental feature of any 
framework at this level is that it should be usable as developer tests as part
of an efficient work cycle.

> And that's the other reason why I consider unit tests to be a
> complement to integration tests.  "gce-xfstests --smoke" takes 10-15
> minutes.  If I can have unit tests which takes 5-15 seconds for a
> smoke test of the specific part of ext4 that I am modifying (and often
> with much better coverage than integration tests from userspace),
> that's at really big deal.  I can do this for e2fsprogs; but if I have
> to launch a VM, the VM overhead pretty much eats all or most of that
> time budget right there.

This is exactly the way we work with KTF as well: 
Change the kernel module under test, and/or the test code, 
compile, unload/load modules and run the tests again, all within seconds.
The overhead of rebooting one or more VMs (network tests sometimes 
require more than one node) or even a physical system, 
if the issue cannot be reproduced without running non-virtualized, 
would only be necessary if the test causes an oops or other crash 
that prevents the unload/load path.

> From looking at your documentation of KTF, you are targetting the use
> case of continuous testing.  That's a different testing scenario than
> what I'm describing; with continuous testing, overhead measured in
> minutes or even tens of minutes is not a big deal.  But if you are
> trying to do real-time testing as part of your development process ---
> *real* Test Driven Development, then test latency is a really big
> deal.

My experience is that unless one can enforce tests to be run on 
everyone else's changes as well, one often ends up having to pursue the bugs 
introduced by others but caught by the tests, so I believe automation and 
unit/low level testing really should go hand in hand. This is the reason for 
the emphasis on automation in the KTF docs, but the primary driver for me has 
always been as a developer toolkit.

> I'll grant that for people who are working on device drivers where
> architecture dependencies are a big deal, building for an architecture
> where you can run in a virtual environment or using test hardware is
> going to be a better way to go.  And Brendan has said he's willing to
> look at adapting KUnit so it can be built for use in a virtual
> environment to accomodate your requirements.
> 
> As far as I'm concerned, however, I would *not* be interested in KTF
> unless you could demonstrate to me that launching at test VM, somehow
> getting the kernel modules copied into the VM, and running the tests
> as kernel modules, has zero overhead compared to using UML.

As you alluded to above, the development cycle time is really the crucial 
thing here - if what you get has more value to you, then you'd be willing 
to wait just a few more seconds for it. And IMHO the real interesting notion of 
time is the time from saving the changes until you can verify that 
the test either passes, or even more important: Why it failed..

> Ultimately, I'm a pragmatist.  If KTF serves your needs best, good for
> you.  If other approaches are better for other parts of the kernel,
> let's not try to impose a strict "There Must Be Only One" religion.
> That's already not true today, and for good reason.  There are many
> different kinds of kernel code, and many different types of test
> philosophies.  Trying to force all kernel testing into a single
> Procrustean Bed is simply not productive.

I definitely pragmatically prefer evolution over revolution myself, 
no doubt about that, and I definitely appreciate this detailed view seen from the 
filesystem side,

Thanks!
Knut

> 
> Regards,
> 
> 						- Ted
