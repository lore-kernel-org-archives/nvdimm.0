Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 17 Aug 2015 21:11:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 6/7] dax: update I/O path to do proper PMEM flushing
Message-ID: <20150817191103.GD6752@lst.de>
References: <1439836211-4719-1-git-send-email-ross.zwisler@linux.intel.com> <1439836211-4719-7-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1439836211-4719-7-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 17, 2015 at 12:30:10PM -0600, Ross Zwisler wrote:
> Update the DAX I/O path so that all operations that store data (I/O
> writes, zeroing blocks, punching holes, etc.) properly synchronize the
> stores to media using the PMEM API.  This ensures that the data DAX is
> writing is durable on media before the operation completes.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks fine (at least as long as the next patch also goes in to cut
down on the crazy amount of __pmem casts..)

Reviewed-by: Christoph Hellwig <hch@lst.de>
