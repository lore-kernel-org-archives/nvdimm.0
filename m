Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id EF708201B0458
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 15:11:44 -0800 (PST)
Date: Sat, 23 Feb 2019 10:11:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] pmem: advertise page alignment for pmem devices
 supporting fsdax
Message-ID: <20190222231136.GC23020@dastard>
References: <20190222182008.GT6503@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190222182008.GT6503@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-nvdimm@lists.01.org, xfs <linux-xfs@vger.kernel.org>, zwisler@kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 22, 2019 at 10:20:08AM -0800, Darrick J. Wong wrote:
> Hi all!
> 
> Uh, we have an internal customer <cough> who's been trying out MAP_SYNC
> on pmem, and they've observed that one has to do a fair amount of
> legwork (in the form of mkfs.xfs parameters) to get the kernel to set up
> 2M PMD mappings.  They (of course) want to mmap hundreds of GB of pmem,
> so the PMD mappings are much more efficient.
> 
> I started poking around w.r.t. what mkfs.xfs was doing and realized that
> if the fsdax pmem device advertised iomin/ioopt of 2MB, then mkfs will
> set up all the parameters automatically.  Below is my ham-handed attempt
> to teach the kernel to do this.

What's the before and after mkfs output?

(need to see the context that this "fixes" before I comment)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
