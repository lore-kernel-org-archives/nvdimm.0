Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 92FC02050AB04
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 13:19:16 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] test: add fio test for device-dax
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
Date: Wed, 29 Mar 2017 16:19:14 -0400
In-Reply-To: <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
 (Dan Williams's message of "Wed, 29 Mar 2017 13:07:23 -0700")
Message-ID: <x49r31fsunx.fsf@segfault.boston.devel.redhat.com>
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

> On Wed, Mar 29, 2017 at 1:02 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>> +check_min_kver()
>>> +{
>>> +     local ver="$1"
>>> +     : "${KVER:=$(uname -r)}"
>>> +
>>> +     [ -n "$ver" ] || return 1
>>> +     [[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
>>> +}
>>> +
>>> +check_min_kver "4.11" || { echo "kernel $KVER may lack latest device-dax fixes"; exit $rc; }
>>
>> Can we stop with this kernel version checking, please?  Test to see if
>> you can create a device dax instance.  If not, skip the test.  If so,
>> and if you have a kernel that isn't fixed, so be it, you'll get
>> failures.
>
> I'd rather not. It helps me keep track of what went in where. If you
> want to run all the tests on a random kernel just do:
>
>     KVER="4.11.0" make check

This, of course, breaks completely with distro kernels.  You don't see
this kind of checking in xfstests, for example.  git helps you keep
track of what changes went in where (see git describe --contains).  It's
weird to track that via your test harness.  So, I would definitely
prefer to move to a model where we check for features instead of kernel
versions.

>>> +
>>> +set -e
>>> +trap 'err $LINENO' ERR
>>> +
>>> +if ! fio --enghelp | grep -q "dev-dax"; then
>>> +     echo "fio lacks dev-dax engine"
>>> +     exit 77
>>> +fi
>>> +
>>> +dev=$(./dax-dev)
>>> +for align in 4k 2m 1g
>>> +do
>>> +     json=$($NDCTL create-namespace -m dax -a $align -f -e $dev)
>>> +     chardev=$(echo $json | jq -r ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
>>> +     if [ align = "1g" ]; then
>>> +             bs="1g"
>>> +     else
>>> +             bs="2m"
>>> +     fi
>>
>> I'm not sure the blocksize even matters.
>>
>
> iirc it affects the alignment of the mmap() request. So for example
> bs=4k should fail when the alignment is larger.

I think iomem_align is a better hint for that, no?

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
