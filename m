Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 960A12050AAE2
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 13:57:00 -0700 (PDT)
Received: by mail-ot0-x22d.google.com with SMTP id y88so18865530ota.2
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 13:57:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49k277reoy.fsf@segfault.boston.devel.redhat.com>
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
 <x49r31fsunx.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jsJZih6t_hQ2Y3T8n0cGh79Kjf98WHfK0xoTVuifrTUQ@mail.gmail.com>
 <x49k277reoy.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Mar 2017 13:56:59 -0700
Message-ID: <CAPcyv4ia9hkL+DH5xrbmWPwoEsKWyEYBaQwbQoEfbSFZc4Xegg@mail.gmail.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 29, 2017 at 1:49 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Wed, Mar 29, 2017 at 1:19 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>
>>>> On Wed, Mar 29, 2017 at 1:02 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>>>
>>>>>> +check_min_kver()
>>>>>> +{
>>>>>> +     local ver="$1"
>>>>>> +     : "${KVER:=$(uname -r)}"
>>>>>> +
>>>>>> +     [ -n "$ver" ] || return 1
>>>>>> +     [[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
>>>>>> +}
>>>>>> +
>>>>>> +check_min_kver "4.11" || { echo "kernel $KVER may lack latest device-dax fixes"; exit $rc; }
>>>>>
>>>>> Can we stop with this kernel version checking, please?  Test to see if
>>>>> you can create a device dax instance.  If not, skip the test.  If so,
>>>>> and if you have a kernel that isn't fixed, so be it, you'll get
>>>>> failures.
>>>>
>>>> I'd rather not. It helps me keep track of what went in where. If you
>>>> want to run all the tests on a random kernel just do:
>>>>
>>>>     KVER="4.11.0" make check
>>>
>>> This, of course, breaks completely with distro kernels.
>>
>> Why does this break distro kernels? The KVER variable overrides "uname -r"
>
> Because some features may not exist in the distro kernels.  It's the
> same problem you outline with xfstests, below.
>

Right, but you started off with suggesting that just running the test
and failing was ok, and that's the behavior you get with KVER=.

>>> You don't see this kind of checking in xfstests, for example.  git
>>> helps you keep track of what changes went in where (see git describe
>>> --contains).  It's weird to track that via your test harness.  So, I
>>> would definitely prefer to move to a model where we check for
>>> features instead of kernel versions.
>>
>> I see this as a deficiency of xfstests. We have had to go through and
>> qualify and track each xfstest and why it may fail with random
>> combinations of kernel, xfsprogs, or e2fsprogs versions. I'd much
>> prefer that upstream xfstests track the minimum versions of components
>> to make a given test pass so we can stop doing it out of tree.
>
> Yes, that's a good point.  I can't think of a good compromise, either.

Maybe we can at least get our annotated blacklist upstream so other
people can start contributing to it?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
