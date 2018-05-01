Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D6A3203B8C0B
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 13:57:14 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id c203-v6so11107140oib.7
 for <linux-nvdimm@lists.01.org>; Tue, 01 May 2018 13:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hQDetYZaQXHoD-L+KWrMJyypvHw=xzm7tb61qt9w=a3g@mail.gmail.com>
References: <20180404231943.29581-1-bsingharora@gmail.com>
 <20180404231943.29581-3-bsingharora@gmail.com>
 <20180405095755.58b3891f@roar.ozlabs.ibm.com>
 <CAPcyv4hqKsOy9GU=NcMGj38pXnuEMRhXfox6jVwQ37+mcjnvhA@mail.gmail.com>
 <20180405150405.5b902b41@roar.ozlabs.ibm.com>
 <20180405155307.49f748f3@gmail.com>
 <20180405164508.7a15a770@roar.ozlabs.ibm.com>
 <CAPcyv4hQDetYZaQXHoD-L+KWrMJyypvHw=xzm7tb61qt9w=a3g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 May 2018 13:57:13 -0700
Message-ID: <CAPcyv4hwb5ebVpYvAn+Bof_NxO6T3X1K+0B7Xbd07FrK8xZi7Q@mail.gmail.com>
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
To: Nicholas Piggin <npiggin@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-nvdimm <linux-nvdimm@lists.01.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 5, 2018 at 8:00 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Apr 4, 2018 at 11:45 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
[,,]
>> What's the problem with just counting bytes copied like usercopy --
>> why is that harder than cacheline accuracy?
>>
>>> I'd rather implement the existing interface and port/support the new interface
>>> as it becomes available
>>
>> Fair enough.
>
> I have patches already in progress to change the interface. My
> preference is to hold off on adding a new implementation that will
> need to be immediately reworked. When I say "immediate" I mean that
> should be able to post what I have for review within the next few
> days.
>
> Whether this is all too late for 4.17 is another question...

Here is the x86 version of a 'bytes remaining' memcpy_mcsafe() implemenation:

    https://lists.01.org/pipermail/linux-nvdimm/2018-May/015548.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
