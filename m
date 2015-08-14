Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1439582628.16263.4.camel@linux.intel.com>
Subject: Re: [PATCH v5 6/8] pmem: convert to generic memremap
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Fri, 14 Aug 2015 14:03:48 -0600
In-Reply-To: <20150813001235.17702.56586.stgit@otcpl-skl-sds-2.jf.intel.com>
References: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com>
	 <20150813001235.17702.56586.stgit@otcpl-skl-sds-2.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-08-12 at 20:12 -0400, Dan Williams wrote:
> Kill arch_memremap_pmem() and just let the architecture specify the
> flags to be passed to memremap().  Default to writethrough by default.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>


