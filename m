Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3FED21CF1CE5
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 11:16:14 -0800 (PST)
Date: Tue, 13 Feb 2018 12:22:04 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] loop: Fix lost writes caused by missing flag
Message-ID: <20180213192204.GA13682@linux.intel.com>
References: <20180212230558.5546-1-ross.zwisler@linux.intel.com>
 <20180213145404.GB14657@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180213145404.GB14657@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 13, 2018 at 03:54:04PM +0100, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can you wire up your test cases for blktests?

Is blktests really the right place for this test?  This failure is highly
dependent on the configuration of the filesystem that is holding the file that
we are using for the loopback device.  It doesn't seem like blktests has
support for mount options (dax), etc?

Because of the interaction with the underlying filesystem this seems like a
better fit with xfstests to me, but I don't know if we need to add tests there
because we already have pretty good coverage of loopback device failures.
That's how we found this - this bug causes all these tests to fail:
xfs/074 xfs/078 xfs/216 xfs/217 xfs/250
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
