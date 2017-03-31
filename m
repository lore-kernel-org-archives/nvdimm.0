Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 642AF21DFA7A8
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 08:50:24 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id r203so64973817oib.3
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 08:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170330080921.GG22845@eguan.usersys.redhat.com>
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
 <x49r31fsunx.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jsJZih6t_hQ2Y3T8n0cGh79Kjf98WHfK0xoTVuifrTUQ@mail.gmail.com>
 <x49k277reoy.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4ia9hkL+DH5xrbmWPwoEsKWyEYBaQwbQoEfbSFZc4Xegg@mail.gmail.com>
 <x49efxfre00.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jNcBz=zvBHrNTA5jRQpdSZ1rgCmT-7NA+ti_Kw9_E7GQ@mail.gmail.com>
 <20170330061600.rmzagx2wcukw6no6@XZHOUW.usersys.redhat.com>
 <20170330080921.GG22845@eguan.usersys.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 31 Mar 2017 08:50:22 -0700
Message-ID: <CAPcyv4ipmHkXHRtkQUH6Rt8WQ3p0jx9GAud7_XH6SFcyHL1+TQ@mail.gmail.com>
Subject: Re: [PATCH] test: add fio test for device-dax
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
To: Eryu Guan <eguan@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 30, 2017 at 1:09 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, Mar 30, 2017 at 02:16:00PM +0800, Xiong Zhou wrote:
>> Ccing Eryu
>>
>> On Wed, Mar 29, 2017 at 02:12:25PM -0700, Dan Williams wrote:
>> > On Wed, Mar 29, 2017 at 2:04 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> > > Dan Williams <dan.j.williams@intel.com> writes:
>> > >
>> > >>>>>>> Can we stop with this kernel version checking, please?  Test to see if
>> > >>>>>>> you can create a device dax instance.  If not, skip the test.  If so,
>> > >>>>>>> and if you have a kernel that isn't fixed, so be it, you'll get
>> > >>>>>>> failures.
>> > >>>>>>
>> > >>>>>> I'd rather not. It helps me keep track of what went in where. If you
>> > >>>>>> want to run all the tests on a random kernel just do:
>> > >>>>>>
>> > >>>>>>     KVER="4.11.0" make check
>> > >>>>>
>> > >>>>> This, of course, breaks completely with distro kernels.
>> > >>>>
>> > >>>> Why does this break distro kernels? The KVER variable overrides "uname -r"
>> > >>>
>> > >>> Because some features may not exist in the distro kernels.  It's the
>> > >>> same problem you outline with xfstests, below.
>> > >>>
>> > >>
>> > >> Right, but you started off with suggesting that just running the test
>> > >> and failing was ok, and that's the behavior you get with KVER=.
>> > >
>> > > Well, the goal was to be somewhat smart about it, by not even trying to
>> > > test things that aren't implemented or configured into the current
>> > > kernel (such as device dax, for example).  Upon thinking about it
>> > > further, I don't think that gets us very far.  However, that does raise
>> > > a use case that is not distro-specific.  If you don't enable device dax,
>> > > your test suite will still try to run those tests.  ;-)
>> >
>> > The other part of the equation is that I'm lazy and don't want to do
>> > the extra work of validating the environment for each test. So just do
>> > a quick version check and if the test fails you get to figure out what
>> > configuration you failed to enable. The most common case being that
>> > you failed to install the nfit_test modules in which case we do have a
>> > capability check for that.
>> >
>> > >>>>> You don't see this kind of checking in xfstests, for example.  git
>> > >>>>> helps you keep track of what changes went in where (see git describe
>> > >>>>> --contains).  It's weird to track that via your test harness.  So, I
>> > >>>>> would definitely prefer to move to a model where we check for
>> > >>>>> features instead of kernel versions.
>> > >>>>
>> > >>>> I see this as a deficiency of xfstests. We have had to go through and
>> > >>>> qualify and track each xfstest and why it may fail with random
>> > >>>> combinations of kernel, xfsprogs, or e2fsprogs versions. I'd much
>> > >>>> prefer that upstream xfstests track the minimum versions of components
>> > >>>> to make a given test pass so we can stop doing it out of tree.
>> > >>>
>> > >>> Yes, that's a good point.  I can't think of a good compromise, either.
>> > >>
>> > >> Maybe we can at least get our annotated blacklist upstream so other
>> > >> people can start contributing to it?
>> > >
>> > > Are you referring to xfstests?  Yeah, that's a good idea.  Right now I
>> > > just add tests to the dangerous group as I encounter known issues.  ;-)
>> > > So, my list probably isn't very helpful in its current form.
>> >
>> > Yes, xfstests. We have entries in our blacklist like this:
>>
>> Just a thought.
>>
>> How about:
>>   0, Adding infrastructure to teach xfstests querying know issues
>> before reporting pass or fail.
>>   1, Formatted known issue files. xfstests may maintain some in tree,
>> while people can have theire own in hand.
>
> I've posted similar RFC patch to fstests before.
>
> [RFC PATCH] fstests: add known issue support
> https://www.spinics.net/lists/fstests/msg02344.html
>
> And Dave rejected it:
> https://www.spinics.net/lists/fstests/msg02345.html
>
> So the short answer is: xfstests should only control whether a test
> should be run or not, the known issues information should be maintained
> outside the test harness.
>
> And I tend to agree with Dave now :)

I read that thread as agreeing with me :). We should maintain a custom
expunge list per the environment. How about a Fedora xfstests package
that keeps an expunge list up to date relative to the latest available
versions of the kernel+utilities in the distribution?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
