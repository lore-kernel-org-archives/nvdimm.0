Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 576902050AB1B
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 14:04:33 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] test: add fio test for device-dax
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
 <x49r31fsunx.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jsJZih6t_hQ2Y3T8n0cGh79Kjf98WHfK0xoTVuifrTUQ@mail.gmail.com>
 <x49k277reoy.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4ia9hkL+DH5xrbmWPwoEsKWyEYBaQwbQoEfbSFZc4Xegg@mail.gmail.com>
Date: Wed, 29 Mar 2017 17:04:31 -0400
In-Reply-To: <CAPcyv4ia9hkL+DH5xrbmWPwoEsKWyEYBaQwbQoEfbSFZc4Xegg@mail.gmail.com>
 (Dan Williams's message of "Wed, 29 Mar 2017 13:56:59 -0700")
Message-ID: <x49efxfre00.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

>>>>>> Can we stop with this kernel version checking, please?  Test to see if
>>>>>> you can create a device dax instance.  If not, skip the test.  If so,
>>>>>> and if you have a kernel that isn't fixed, so be it, you'll get
>>>>>> failures.
>>>>>
>>>>> I'd rather not. It helps me keep track of what went in where. If you
>>>>> want to run all the tests on a random kernel just do:
>>>>>
>>>>>     KVER="4.11.0" make check
>>>>
>>>> This, of course, breaks completely with distro kernels.
>>>
>>> Why does this break distro kernels? The KVER variable overrides "uname -r"
>>
>> Because some features may not exist in the distro kernels.  It's the
>> same problem you outline with xfstests, below.
>>
>
> Right, but you started off with suggesting that just running the test
> and failing was ok, and that's the behavior you get with KVER=.

Well, the goal was to be somewhat smart about it, by not even trying to
test things that aren't implemented or configured into the current
kernel (such as device dax, for example).  Upon thinking about it
further, I don't think that gets us very far.  However, that does raise
a use case that is not distro-specific.  If you don't enable device dax,
your test suite will still try to run those tests.  ;-)

>>>> You don't see this kind of checking in xfstests, for example.  git
>>>> helps you keep track of what changes went in where (see git describe
>>>> --contains).  It's weird to track that via your test harness.  So, I
>>>> would definitely prefer to move to a model where we check for
>>>> features instead of kernel versions.
>>>
>>> I see this as a deficiency of xfstests. We have had to go through and
>>> qualify and track each xfstest and why it may fail with random
>>> combinations of kernel, xfsprogs, or e2fsprogs versions. I'd much
>>> prefer that upstream xfstests track the minimum versions of components
>>> to make a given test pass so we can stop doing it out of tree.
>>
>> Yes, that's a good point.  I can't think of a good compromise, either.
>
> Maybe we can at least get our annotated blacklist upstream so other
> people can start contributing to it?

Are you referring to xfstests?  Yeah, that's a good idea.  Right now I
just add tests to the dangerous group as I encounter known issues.  ;-)
So, my list probably isn't very helpful in its current form.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
