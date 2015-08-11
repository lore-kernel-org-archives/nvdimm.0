Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 11 Aug 2015 14:52:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 07/10] pmem: switch from ioremap_wt to memremap
Message-ID: <20150811125212.GC3402@lst.de>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com> <20150811033828.4987.46863.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150811033828.4987.46863.stgit@otcpl-bsw-rvp-2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 10, 2015 at 11:38:28PM -0400, Dan Williams wrote:
> In preparation for deprecating ioremap_wt() convert its usage in
> the PMEM API to memremap.

Looks fine, but the description seems a little confusing.  We're doing
this to get proper semanticss, not to deprecate ioremap_wt().

Signed-off-by: Christoph Hellwig <hch@lst.de>
