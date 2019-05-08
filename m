From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Wed, 8 May 2019 12:17:59 -0700
Message-ID: <CAFd5g47vQQeSHLX_cvWSVzva9YgsXz9DNqPv8Z=nw=-kAcmr3Q@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <54940124-50df-16ec-1a32-ad794ee05da7@gmail.com> <20190507080119.GB28121@kroah.com>
 <20190507172256.GB5900@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190507172256.GB5900@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>, Frank Rowand <frowand.list@gmail.com>, Brendan Higgins <brendanhiggins@google.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah <shuah@kernel.org>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-nvd
List-Id: linux-nvdimm@lists.01.org

> On Tue, May 07, 2019 at 10:01:19AM +0200, Greg KH wrote:
> > > My understanding is that the intent of KUnit is to avoid booting a kernel on
> > > real hardware or in a virtual machine.  That seems to be a matter of semantics
> > > to me because isn't invoking a UML Linux just running the Linux kernel in
> > > a different form of virtualization?
> > >
> > > So I do not understand why KUnit is an improvement over kselftest.
> > >
> > > It seems to me that KUnit is just another piece of infrastructure that I
> > > am going to have to be familiar with as a kernel developer.  More overhead,
> > > more information to stuff into my tiny little brain.
> > >
> > > I would guess that some developers will focus on just one of the two test
> > > environments (and some will focus on both), splitting the development
> > > resources instead of pooling them on a common infrastructure.
> > >
> > > What am I missing?
> >
> > kselftest provides no in-kernel framework for testing kernel code
> > specifically.  That should be what kunit provides, an "easy" way to
> > write in-kernel tests for things.
> >
> > Brendan, did I get it right?
>
> Yes, that's basically right.  You don't *have* to use KUnit.  It's
> supposed to be a simple way to run a large number of small tests that
> for specific small components in a system.
>
> For example, I currently use xfstests using KVM and GCE to test all of
> ext4.  These tests require using multiple 5 GB and 20GB virtual disks,
> and it works by mounting ext4 file systems and exercising ext4 through
> the system call interfaces, using userspace tools such as fsstress,
> fsx, fio, etc.  It requires time overhead to start the VM, create and
> allocate virtual disks, etc.  For example, to run a single 3 seconds
> xfstest (generic/001), it requires full 10 seconds to run it via
> kvm-xfstests.
>
> KUnit is something else; it's specifically intended to allow you to
> create lightweight tests quickly and easily, and by reducing the
> effort needed to write and run unit tests, hopefully we'll have a lot
> more of them and thus improve kernel quality.
>
> As an example, I have a volunteer working on developing KUinit tests
> for ext4.  We're going to start by testing the ext4 extent status
> tree.  The source code is at fs/ext4/extent_status.c; it's
> approximately 1800 LOC.  The Kunit tests for the extent status tree
> will exercise all of the corner cases for the various extent status
> tree functions --- e.g., ext4_es_insert_delayed_block(),
> ext4_es_remove_extent(), ext4_es_cache_extent(), etc.  And it will do
> this in isolation without our needing to create a test file system or
> using a test block device.
>
> Next we'll test the ext4 block allocator, again in isolation.  To test
> the block allocator we will have to write "mock functions" which
> simulate reading allocation bitmaps from disk.  Again, this will allow
> the test writer to explicitly construct corner cases and validate that
> the block allocator works as expected without having to reverese
> engineer file system data structures which will force a particular
> code path to be executed.
>
> So this is why it's largely irrelevant to me that KUinit uses UML.  In
> fact, it's a feature.  We're not testing device drivers, or the
> scheduler, or anything else architecture-specific.  UML is not about
> virtualization.  What it's about in this context is allowing us to
> start running test code as quickly as possible.  Booting KVM takes
> about 3-4 seconds, and this includes initializing virtio_scsi and
> other device drivers.  If by using UML we can hold the amount of
> unnecessary kernel subsystem initialization down to the absolute
> minimum, and if it means that we can communicating to the test
> framework via a userspace "printf" from UML/KUnit code, as opposed to
> via a virtual serial port to KVM's virtual console, it all makes for
> lighter weight testing.
>
> Why did I go looking for a volunteer to write KUnit tests for ext4?
> Well, I have a plan to make some changes in restructing how ext4's
> write path works, in order to support things like copy-on-write, a
> more efficient delayed allocation system, etc.  This will require
> making changes to the extent status tree, and by having unit tests for
> the extent status tree, we'll be able to detect any bugs that we might
> accidentally introduce in the es tree far more quickly than if we
> didn't have those tests available.  Google has long found that having
> these sorts of unit tests is a real win for developer velocity for any
> non-trivial code module (or C++ class), even when you take into
> account the time it takes to create the unit tests.
>
>                                         - Ted
>
> P.S.  Many thanks to Brendan for finding such a volunteer for me; the
> person in question is a SRE from Switzerland who is interested in
> getting involved with kernel testing, and this is going to be their
> 20% project.  :-)

Thanks Ted, I really appreciate it!

Since Ted provided such an awesome detailed response, I don't think I
really need to go into any detail; nevertheless, I think that Greg and
Shuah have the right idea; in particular, Shuah provides a good
summary.

Thanks everyone!
