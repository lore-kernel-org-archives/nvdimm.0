Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD7ED2265A172
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 09:58:14 -0700 (PDT)
Date: Tue, 17 Apr 2018 09:57:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417165756.GC24738@magnolia>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
 <20180417161056.GA24257@infradead.org>
 <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 09:53:47AM -0700, Dan Williams wrote:
> On Tue, Apr 17, 2018 at 9:10 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Tue, Apr 17, 2018 at 10:40:59PM +0800, Xiong Zhou wrote:
> >> We got these in v4.17-rc1:
> >> 6e2608d xfs, dax: introduce xfs_dax_aops
> >> fb094c9 ext2, dax: introduce ext2_dax_aops
> >> 5f0663b ext4, dax: introduce ext4_dax_aops
> >>
> >> And we don't have ->bmap call in these aops, which may lead
> >> to the ioctl call failure.
> >>
> >> Do we have any plan of adding/supporting it ?
> >>
> >> xfstests generic/223 covers this issue. If we are not going
> >> to support this call for dax, we need to fix the testcase.
> >
> > Not supporting ->bmap is a good thing as it is hightly dangerous.
> 
> I take this to mean "don't fix, it is another casualty of dax being
> experimental and it won't be coming back". I can get on board with
> that.
> 
> Otherwise, I was about to send a series adding bmap to {xfs,ext2,ext4}_dax_ops.

Frankly I'd rather see the swapfile code learn how to iomap and then we
can get rid of bmap in xfs entirely.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
