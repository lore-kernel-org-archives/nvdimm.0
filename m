Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 27 Oct 2015 11:31:12 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 1/5] pmem, dax: clean up clear_pmem()
Message-ID: <20151027173112.GA16605@linux.intel.com>
References: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022171021.38343.65959.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151022171021.38343.65959.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, jack@suse.cz, akpm@linux-foundation.org, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 22, 2015 at 01:10:21PM -0400, Dan Williams wrote:
> Both, __dax_pmd_fault, and clear_pmem() were taking special steps to
> clear memory a page at a time to take advantage of non-temporal
> clear_page() implementations.  However, x86_64 does not use
> non-temporal instructions for clear_page(), and arch_clear_pmem() was
> always incurring the cost of __arch_wb_cache_pmem().
> 
> Clean up the assumption that doing clear_pmem() a page at a time is more
> performant.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
