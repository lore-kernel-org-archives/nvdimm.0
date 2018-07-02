Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F4EF20968908
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 11:51:29 -0700 (PDT)
Subject: Re: [ndctl PATCH] ndctl, test: Disable poison tests for now
References: <152902248546.9927.13473307820258257919.stgit@dwillia2-desk3.amr.corp.intel.com>
 <89b98efe-1eb7-87ed-99e4-7d87315318d0@oracle.com>
 <CAPcyv4h=T5wg=NKoCcSTDrC96EQ2xg3eEHK3Hj52qEBin2285w@mail.gmail.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <ebbff8c1-dde9-465e-bac6-a0b28375ff6d@oracle.com>
Date: Mon, 2 Jul 2018 11:51:24 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h=T5wg=NKoCcSTDrC96EQ2xg3eEHK3Hj52qEBin2285w@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 6/28/2018 1:37 PM, Dan Williams wrote:

> On Thu, Jun 28, 2018 at 12:28 PM,  <jane.chu@oracle.com> wrote:
>> Hi, Dan,
>>
>> I'm concerned about this check
>>
>> +       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 19, 0)))
>>
>> I read it as: this ndctl test only works for upstream kernel 4.19 and above.
>>
>> For Linux distributors, such as us, we pick a major upstream release as the
>> base OS, then painstakingly backport desired upstream patches etc.
>> Our latest OS version string will be 4.14.x.y.z for a long while,
>> that means the ndctl test won't work even if we backport the 4.19 nvdimm
>> patches over.
> You can run:
>
>     make KVER=4.19.0 check
>
> ...and it will override the kernel version detection.
>
>> Is it possible to come up with a more accommodating method?
> We're trying to scale back our usage of kernel version gates, but if
> it crashes the system we want to protect unsuspecting users.
>
>> One way might be is to 'dd' a block of 0s to the injected block
>> immediately after a successful injection?  For now, doing so leaves the
>> 'badblocks' and the poison bit in place.
> I'll notte that this is one of the tests marked in the
> "ENABLE_DESTRUCTIVE" section of test/Makefile.am in the ndctl source.
> Those tests may destroy data or otherwise adversely affect the system.
> They are only meant for developer workstations and you must pass
> "--enable-destructive" to 'configure' when building ndctl. The intent
> is "don't enabled these tests unless you know what you are doing".

Sounds great, thanks!

-jane
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
