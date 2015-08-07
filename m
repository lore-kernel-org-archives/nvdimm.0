Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1438972897.2293.2.camel@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
	<1438883000-9011-2-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jun2dE9=24Wcf4Qh_JruNyf=5qoMckqdg3u0ROUgPZ8w@mail.gmail.com>
	<1438972897.2293.2.camel@linux.intel.com>
Date: Fri, 7 Aug 2015 13:01:57 -0700
Message-ID: <CAPcyv4hoHH4BYJnUvF51e1ewzR2TBA7yndru5DqDsft65Hi-MQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] pmem: remove indirection layer arch_has_pmem_api()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 7, 2015 at 11:41 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, 2015-08-07 at 09:14 -0700, Dan Williams wrote:
>> On Thu, Aug 6, 2015 at 10:43 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > Prior to this change arch_has_wmb_pmem() was only called by
>> > arch_has_pmem_api().  Both arch_has_wmb_pmem() and arch_has_pmem_api()
>> > checked to make sure that CONFIG_ARCH_HAS_PMEM_API was enabled.
>> >
>> > Instead, remove one extra layer of indirection and the redundant
>> > CONFIG_ARCH_HAS_PMEM_API check, and just have arch_has_pmem_api()
>> > call __arch_has_wmb_pmem() directly.
>>
>> So I think this patch takes us further away from where we want to go
>> in the near term which is a finer grained pmem api.  The class of
>> systems where (has_pmem_api() && !has_wmb_pmem()) is existing energy
>> backed nvdimm platforms.  I'm assuming those platforms will want to
>> assert persistence guarantees in the absence of a pcommit-like
>> instruction, and that we want to stop gating arch_has_pmem_api() on
>> the presence of wmb_pmem() capability.  In that case
>> arch_has_wmb_pmem() will be useful to have and that was the original
>> intent for including it, that intent did not seem to comprehended in
>> the changelog.
>
> I think that we should only keep around functions that are actually used and
> useful.  I agree that there could potentially be a use for a distinction like
> the one you are talking about when we try and properly support ADR systems and
> stop lumping them in with "non-PCOMMIT" systems like we are doing now.
>
> Right now, though, arch_has_wmb_pmem() is just redundant.  If/when we add that
> new support in, we'll have to properly update this code anyway - let's not
> keep around unneeded code until then.

I don't see the pain in carrying around one unused static inline
especially if we'll have a use for it in the near term.  But, if it
needs to go then __arch_has_wmb_pmem() needs to be renamed to drop the
"__" since there is no longer a wrapper.
