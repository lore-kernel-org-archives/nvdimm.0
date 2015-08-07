Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1438883000-9011-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
	<1438883000-9011-2-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 7 Aug 2015 09:14:42 -0700
Message-ID: <CAPcyv4jun2dE9=24Wcf4Qh_JruNyf=5qoMckqdg3u0ROUgPZ8w@mail.gmail.com>
Subject: Re: [PATCH 1/6] pmem: remove indirection layer arch_has_pmem_api()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 6, 2015 at 10:43 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Prior to this change arch_has_wmb_pmem() was only called by
> arch_has_pmem_api().  Both arch_has_wmb_pmem() and arch_has_pmem_api()
> checked to make sure that CONFIG_ARCH_HAS_PMEM_API was enabled.
>
> Instead, remove one extra layer of indirection and the redundant
> CONFIG_ARCH_HAS_PMEM_API check, and just have arch_has_pmem_api()
> call __arch_has_wmb_pmem() directly.

So I think this patch takes us further away from where we want to go
in the near term which is a finer grained pmem api.  The class of
systems where (has_pmem_api() && !has_wmb_pmem()) is existing energy
backed nvdimm platforms.  I'm assuming those platforms will want to
assert persistence guarantees in the absence of a pcommit-like
instruction, and that we want to stop gating arch_has_pmem_api() on
the presence of wmb_pmem() capability.  In that case
arch_has_wmb_pmem() will be useful to have and that was the original
intent for including it, that intent did not seem to comprehended in
the changelog.
