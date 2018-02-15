Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0957D223230C7
 for <linux-nvdimm@lists.01.org>; Thu, 15 Feb 2018 14:42:51 -0800 (PST)
Date: Thu, 15 Feb 2018 14:48:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
Message-ID: <20180215224839.GA16073@infradead.org>
References: <151873070632.53899.3320294279108510082.stgit@djiang5-desk3.ch.intel.com>
 <151873085471.53899.4916392112937742603.stgit@djiang5-desk3.ch.intel.com>
 <20180215214708.GA10446@infradead.org>
 <7657c80b-412b-e280-f126-a7d735a0a730@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7657c80b-412b-e280-f126-a7d735a0a730@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 15, 2018 at 03:44:48PM -0700, Dave Jiang wrote:
> > 
> > Except for that the whole series looks fine to me.
> > 
> 
> Can I add your reviewed-by? Thanks for reviewing.

Yes:

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
