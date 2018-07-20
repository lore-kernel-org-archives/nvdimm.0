Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D1CC2097FAA6
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jul 2018 13:54:59 -0700 (PDT)
Date: Fri, 20 Jul 2018 14:54:53 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv3 1/2] libnvdimm: Use max contiguous area for namespace
 size
Message-ID: <20180720205453.GA4864@localhost.localdomain>
References: <20180712154709.16444-1-keith.busch@intel.com>
 <1532119565.10343.15.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1532119565.10343.15.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 20, 2018 at 01:46:06PM -0700, Verma, Vishal L wrote:
> 
> On Thu, 2018-07-12 at 09:47 -0600, Keith Busch wrote:
> > This patch will find the max contiguous area to determine the largest
> > pmem namespace size that can be created. If the requested size exceeds
> > the largest available, ENOSPC error will be returned.
> > 
> > This fixes the allocation underrun error and wrong error return code
> > that have otherwise been observed as the following kernel warning:
> > 
> >   WARNING: CPU: <CPU> PID: <PID> at drivers/nvdimm/namespace_devs.c:913 size_store
> > 
> > Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update nd_region_available_dpa() for multi-pmem support")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Keith Busch <keith.busch@intel.com>
> 
> Hi Keith,
> 
> I was testing these patches and I found:
> 
> When booting a VM which has both, a qemu ACPI.NFIT bus, and nfit_test
> buses, initially the nfit_test buses show correct max_available_extent.
> But the qemu ACPI.NFIT bus regions (which have an automatic full-
> capacity namespace created on them when they come up) show
> max_available_extent of the full region size, even as the
> available_size attr is zero.

The max extents only counts the free pmem that it can reserve.
We shouldn't have been able to reserve non-free pmem, so it sounds like
something must be wrong with how the resources were set up.

I'll make a similar qemu config and see why/if the resource was
considered free.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
