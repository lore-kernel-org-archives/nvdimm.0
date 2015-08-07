Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1438972897.2293.2.camel@linux.intel.com>
Subject: Re: [PATCH 1/6] pmem: remove indirection layer arch_has_pmem_api()
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Fri, 07 Aug 2015 12:41:37 -0600
In-Reply-To: <CAPcyv4jun2dE9=24Wcf4Qh_JruNyf=5qoMckqdg3u0ROUgPZ8w@mail.gmail.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1438883000-9011-2-git-send-email-ross.zwisler@linux.intel.com>
	 <CAPcyv4jun2dE9=24Wcf4Qh_JruNyf=5qoMckqdg3u0ROUgPZ8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-08-07 at 09:14 -0700, Dan Williams wrote:
> On Thu, Aug 6, 2015 at 10:43 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > Prior to this change arch_has_wmb_pmem() was only called by
> > arch_has_pmem_api().  Both arch_has_wmb_pmem() and arch_has_pmem_api()
> > checked to make sure that CONFIG_ARCH_HAS_PMEM_API was enabled.
> >
> > Instead, remove one extra layer of indirection and the redundant
> > CONFIG_ARCH_HAS_PMEM_API check, and just have arch_has_pmem_api()
> > call __arch_has_wmb_pmem() directly.
> 
> So I think this patch takes us further away from where we want to go
> in the near term which is a finer grained pmem api.  The class of
> systems where (has_pmem_api() && !has_wmb_pmem()) is existing energy
> backed nvdimm platforms.  I'm assuming those platforms will want to
> assert persistence guarantees in the absence of a pcommit-like
> instruction, and that we want to stop gating arch_has_pmem_api() on
> the presence of wmb_pmem() capability.  In that case
> arch_has_wmb_pmem() will be useful to have and that was the original
> intent for including it, that intent did not seem to comprehended in
> the changelog.

I think that we should only keep around functions that are actually used and
useful.  I agree that there could potentially be a use for a distinction like
the one you are talking about when we try and properly support ADR systems and
stop lumping them in with "non-PCOMMIT" systems like we are doing now.

Right now, though, arch_has_wmb_pmem() is just redundant.  If/when we add that
new support in, we'll have to properly update this code anyway - let's not
keep around unneeded code until then.


