Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99FF421F322D5
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 23:37:10 -0700 (PDT)
Date: Tue, 26 Sep 2017 23:40:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170927064001.GA27601@infradead.org>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard>
 <20170926093548.GB13627@quack2.suse.cz>
 <20170926110957.GR10955@dastard> <20170926143743.GB18758@lst.de>
 <20170926173057.GB20159@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170926173057.GB20159@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Dan Williams <dan.j.williams@intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 26, 2017 at 11:30:57AM -0600, Ross Zwisler wrote:
> I agree that Christoph's idea about having the system intelligently adjust to
> use DAX based on performance information it gathers about the underlying
> persistent memory (probably via the HMAT on x86_64 systems) is interesting,
> but I think we're still a ways away from that.

So what are the missing blockers for a getting started?

> FWIW, as my patches suggest and Jan observed I think that we should allow
> users to turn on DAX by treating the inode flag and the mount flag as an 'or'
> operation.  i.e. you get DAX if either the mount option is specified or if the
> inode flag is set, and you can continue to manipulate the per-inode flag as
> you want regardless of the mount option.  I think this provides maximum
> flexibility of the mechanism to select DAX without enforcing policy.

IFF we stick to the dax flag that's the only workable way.  The only
major issue I still see with that is that this allows unprivilegued
users to enable DAX on a any file they own / have write access to.
So there isn't really any way to effectively disable the DAX path
by the sysadmin.

> Does it make sense at this point to just start a "dax" man page that can
> contain info about the mount options, inode flags, kernel config options, how
> to get PMDs, etc?  Or does this documentation need to be sprinkled around more
> in existing man pages?

A dax manpage would be good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
