Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 419922265A165
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 09:10:59 -0700 (PDT)
Date: Tue, 17 Apr 2018 09:10:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417161056.GA24257@infradead.org>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
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
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, fstests@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 10:40:59PM +0800, Xiong Zhou wrote:
> We got these in v4.17-rc1:
> 6e2608d xfs, dax: introduce xfs_dax_aops
> fb094c9 ext2, dax: introduce ext2_dax_aops
> 5f0663b ext4, dax: introduce ext4_dax_aops
> 
> And we don't have ->bmap call in these aops, which may lead
> to the ioctl call failure.
> 
> Do we have any plan of adding/supporting it ?
> 
> xfstests generic/223 covers this issue. If we are not going
> to support this call for dax, we need to fix the testcase.

Not supporting ->bmap is a good thing as it is hightly dangerous.

The t_stripetest tool used by generic/223 should really be
rewritten to suppot FIEMAP.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
