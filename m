Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22c.google.com (mail-io0-x22c.google.com
 [IPv6:2607:f8b0:4001:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7827021E87967
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 17:25:42 -0700 (PDT)
Received: by mail-io0-x22c.google.com with SMTP id e189so1305109ioa.4
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 17:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170913233438.GY10621@dastard>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard> <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard> <20170913144215.GA12395@linux.intel.com>
 <20170913220108.GX10621@dastard>
 <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Sep 2017 17:28:39 -0700
Message-ID: <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 13, 2017 at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Sep 13, 2017 at 03:23:39PM -0700, Dan Williams wrote:
>> On Wed, Sep 13, 2017 at 3:01 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Sep 13, 2017 at 08:42:15AM -0600, Ross Zwisler wrote:
>> >> On Wed, Sep 13, 2017 at 09:47:29AM +1000, Dave Chinner wrote:
>> >>
>> >> <>
>> >>
>> >> > I think similar concerns exist with using perf, too....
>> >>
>> >> I though that using perf addressed both concerns?
>> >>
>> >> > > > So what happens when the user is already tracing the test to
>> >> > > > find a bug and the test turns all their tracing off?
>> >>
>> >> By using perf we isolate our tracing from whatever other tracing is happening
>> >> in the system.  So, unlike the case where we were messing with a system-wide
>> >> ftrace knob, we run perf on our executable, and someone else can run perf on
>> >> their executable, and they don't collide.
>> >
>> > Yes, you've addressed the "gets inteh way of other tracing concern,
>> > but it's doesn't address the "it's an ugly way to determine a
>> > feature is active" concerns. It also creates an implicit stable
>> > tracepoint out of whatever you are looking at. i.e. that tracepoint
>> > can't go away, nor can it change functionality once a userspace app
>> > depends on it's current semantics to function correctly.
>> >
>> > And....
>> >
>> >> > > > Regardless of this screwing up developer bug triage, do we really
>> >> > > > want to add a dependency on kernel tracing into the test harness?
>> >>
>> >> Yep, you're right that this adds a dependency on perf.  But unfortunately,
>> >> without using either perf or ftrace, I don't know of a way to detect whether
>> >> or not DAX is actually being used.  Can you think of another way?
>> >
>> > ... if there isn't a programmatic interface to tell applications
>> > that DAX is in use, then perhaps we're missing a formal userspace
>> > API that we should have, yes?
>> >
>> >> I tried to do this correctly and just skip the test with _notrun
>> >> if perf isn't available on the host system.  This is the same
>> >> thing that happens if you are missing other dependencies for a
>> >> test (some other command (chacl, getfattr, setfattr) not present,
>> >> quota tools not installed, required users not present, etc).
>> >
>> > Sure, but if we have user configurable functionality, then using
>> > something like ftrace/perf to discover if it's turned is indicative
>> > of a bigger problem. i.e. that the user can't tell if the
>> > functionality they turned on/off is actually active or not.
>> >
>> > That's a bug that needs fixing, not working around with
>> > ftrace/perf in xfstests...
>> >
>>
>> Yes, we need a way to determine that DAX is enabled, but certainly not
>> a VM_DAX flag as that was NAKd by you here:
>>
>>     https://lkml.org/lkml/2016/9/16/13
>
> Yeah, the on disk flag doesn't tell you if DAX is actually in use or
> not.
>
>> I think one consideration is to just build this into MAP_SYNC.
>> MAP_SYNC can only succeed if DAX is enabled and that it is a reliable
>> way for userspace to assume DAX. There is some consensus for this
>> proposal here:
>>
>>     https://lists.01.org/pipermail/linux-nvdimm/2017-August/012086.html
>
> That'll probe that it can be used, not that it is currently being
> used.
>
> /me shrugs
>
> I just don't like the concept of using tracepoints to as a
> definitive diagnostic test for something working because it'll break
> when the kernel implementation and tracepoints change. So while we
> can probe for perf being present, we can't probe whether the
> tracepoint we need behaves as the test expects it to...

That concern makes sense.

We handle that it a crude way in the libnvdimm unit tests by hard
coding a required minimum kernel version and rolling a test forward to
depend on a new kernel when assumptions about the kernel-internals
change. The tests also inject out-of-tree kernel modules that let us
go after specific kernel internal behavior. With this approach we
don't end up creating userspace ABI since the test explicitly loads
out-of-tree modules.

Of course this is not how xfstests works and it definitely shouldn't,
but perhaps this specific test case is better suited in the libnvdimm
unit test framework where it's enabled to dig behind the standard
interfaces.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
