Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 13 Aug 2015 07:57:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 6/8] pmem: convert to generic memremap
Message-ID: <20150813055712.GB4767@lst.de>
References: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com> <20150813001235.17702.56586.stgit@otcpl-skl-sds-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150813001235.17702.56586.stgit@otcpl-skl-sds-2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 12, 2015 at 08:12:35PM -0400, Dan Williams wrote:
> Kill arch_memremap_pmem() and just let the architecture specify the
> flags to be passed to memremap().  Default to writethrough by default.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
