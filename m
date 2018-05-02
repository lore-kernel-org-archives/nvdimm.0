Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x244.google.com (mail-vk0-x244.google.com
 [IPv6:2607:f8b0:400c:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CB4120957AEB
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 05:36:17 -0700 (PDT)
Received: by mail-vk0-x244.google.com with SMTP id 131-v6so8848237vkf.8
 for <linux-nvdimm@lists.01.org>; Wed, 02 May 2018 05:36:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hwb5ebVpYvAn+Bof_NxO6T3X1K+0B7Xbd07FrK8xZi7Q@mail.gmail.com>
References: <20180404231943.29581-1-bsingharora@gmail.com>
 <20180404231943.29581-3-bsingharora@gmail.com>
 <20180405095755.58b3891f@roar.ozlabs.ibm.com>
 <CAPcyv4hqKsOy9GU=NcMGj38pXnuEMRhXfox6jVwQ37+mcjnvhA@mail.gmail.com>
 <20180405150405.5b902b41@roar.ozlabs.ibm.com>
 <20180405155307.49f748f3@gmail.com>
 <20180405164508.7a15a770@roar.ozlabs.ibm.com>
 <CAPcyv4hQDetYZaQXHoD-L+KWrMJyypvHw=xzm7tb61qt9w=a3g@mail.gmail.com>
 <CAPcyv4hwb5ebVpYvAn+Bof_NxO6T3X1K+0B7Xbd07FrK8xZi7Q@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Date: Wed, 2 May 2018 22:36:15 +1000
Message-ID: <CAKTCnz=w+Pc8LyEfO4H-dDVGydfMJX=03YgBwGR0=h6cVs+zZA@mail.gmail.com>
Subject: Re: [RESEND 2/3] powerpc/memcpy: Add memcpy_mcsafe for pmem
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
Cc: "Luck, Tony" <tony.luck@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-nvdimm <linux-nvdimm@lists.01.org>, Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 2, 2018 at 6:57 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Apr 5, 2018 at 8:00 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Wed, Apr 4, 2018 at 11:45 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
> [,,]
>>> What's the problem with just counting bytes copied like usercopy --
>>> why is that harder than cacheline accuracy?
>>>
>>>> I'd rather implement the existing interface and port/support the new interface
>>>> as it becomes available
>>>
>>> Fair enough.
>>
>> I have patches already in progress to change the interface. My
>> preference is to hold off on adding a new implementation that will
>> need to be immediately reworked. When I say "immediate" I mean that
>> should be able to post what I have for review within the next few
>> days.
>>
>> Whether this is all too late for 4.17 is another question...
>
> Here is the x86 version of a 'bytes remaining' memcpy_mcsafe() implemenation:
>
>     https://lists.01.org/pipermail/linux-nvdimm/2018-May/015548.html

Thanks for the heads up! I'll work on the implementation for powerpc.

Balbir Singh.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
