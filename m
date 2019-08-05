Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au
 [211.29.132.246])
 by ml01.01.org (Postfix) with ESMTP id 3F023212E2583
 for <linux-nvdimm@lists.01.org>; Sun,  4 Aug 2019 17:25:58 -0700 (PDT)
Date: Mon, 5 Aug 2019 10:21:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Message-ID: <20190805002142.GV7777@dread.disaster.area>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
 <20190731203324.7vjwlejmwpghpvqi@fiona>
 <800ff77a-7cd1-5fa1-fcf7-e41264a3f189@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <800ff77a-7cd1-5fa1-fcf7-e41264a3f189@cn.fujitsu.com>
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
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc: qi.fuli@fujitsu.com, gujx@cn.fujitsu.com, darrick.wong@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 01, 2019 at 09:37:04AM +0800, Shiyang Ruan wrote:
> 
> 
> On 8/1/19 4:33 AM, Goldwyn Rodrigues wrote:
> > On 19:49 31/07, Shiyang Ruan wrote:
> > > This patchset aims to take care of this issue to make reflink and dedupe
> > > work correctly in XFS.
> > > 
> > > It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and "Btrfs
> > > iomap".  I picked up some patches related and made a few fix to make it
> > > basically works fine.
> > > 
> > > For dax framework:
> > >    1. adapt to the latest change in iomap.
> > > 
> > > For XFS:
> > >    1. report the source address and set IOMAP_COW type for those write
> > >       operations that need COW.
> > >    2. update extent list at the end.
> > >    3. add file contents comparison function based on dax framework.
> > >    4. use xfs_break_layouts() to support dax.
> > 
> > Shiyang,
> > 
> > I think you used the older patches which does not contain the iomap changes
> > which would call iomap_begin() with two iomaps. I have it in the btrfs-iomap
> 
> Oh, Sorry for my carelessness.  This patchset is built on your "Btrfs
> iomap".  I didn't point it out in cover letter.
> 
> > branch and plan to update it today. It is built on v5.3-rcX, so it should
> > contain the changes which moves the iomap code to the different directory.
> > I will build the dax patches on top of that.
> > However, we are making a big dependency chain here
> Don't worry.  It's fine for me.  I'll follow your updates.

Hi Shiyang,

I'll wait for you to update your patches on top of the latest btrfs
patches before looking at this any futher. it would be good to get
a set of iomap infrastructure patches separated from the btrfs
patchsets so could have them both built from a common patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
