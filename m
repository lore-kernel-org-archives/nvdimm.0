Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E841226FAA6B
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 13:40:28 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RESEND 2/3] powerpc/memcpy: Add memcpy_mcsafe for pmem
References: <20180404231943.29581-1-bsingharora@gmail.com>
 <20180404231943.29581-3-bsingharora@gmail.com>
 <20180405095755.58b3891f@roar.ozlabs.ibm.com>
 <CAPcyv4hqKsOy9GU=NcMGj38pXnuEMRhXfox6jVwQ37+mcjnvhA@mail.gmail.com>
 <20180405150405.5b902b41@roar.ozlabs.ibm.com>
 <20180405155307.49f748f3@gmail.com>
 <20180405164508.7a15a770@roar.ozlabs.ibm.com>
Date: Thu, 05 Apr 2018 16:40:26 -0400
In-Reply-To: <20180405164508.7a15a770@roar.ozlabs.ibm.com> (Nicholas Piggin's
 message of "Thu, 5 Apr 2018 16:45:08 +1000")
Message-ID: <x496055gzet.fsf@segfault.boston.devel.redhat.com>
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
To: Nicholas Piggin <npiggin@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Matthew Wilcox <mawilcox@microsoft.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Nicholas Piggin <npiggin@gmail.com> writes:

> On Thu, 5 Apr 2018 15:53:07 +1000
> Balbir Singh <bsingharora@gmail.com> wrote:
>> I'm thinking about it, I wonder what "bytes remaining" mean in pmem context
>> in the context of a machine check exception. Also, do we want to be byte
>> accurate or cache-line accurate for the bytes remaining? The former is much
>> easier than the latter :)
>
> The ideal would be a linear measure of how much of your copy reached
> (or can reach) non-volatile storage with nothing further copied. You
> may have to allow for some relaxing of the semantics depending on
> what the architecture can support.

I think you've got that backwards.  memcpy_mcsafe is used to copy *from*
persistent memory.  The idea is to catch errors when reading pmem, not
writing to it.

> What's the problem with just counting bytes copied like usercopy --
> why is that harder than cacheline accuracy?

He said the former (i.e. bytes) is easier.  So, I think you're on the
same page.  :)

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
