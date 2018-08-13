Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 549DD210ED790
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 05:46:10 -0700 (PDT)
Date: Mon, 13 Aug 2018 08:46:02 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180813124602.GA26513@thunk.org>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
 <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
 <20180810203349.GH627@thunk.org> <20180811021053.GB14368@thunk.org>
 <20180813101252.GC8927@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180813101252.GC8927@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: sandeen@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 13, 2018 at 12:12:52PM +0200, Jan Kara wrote:
> > The generic/081 regression appears to be a device-mapper issue...
> 
> I'll see if this reproduces for me. Doesn't seem to be related to the DAX
> patches you caary though.

It does seem to be a DAX-specific failure though.

> > The generic/344 failure seems to be caused by a WARNING triggered in
> > the nvdimm code:
> 
> OK, apparently this is nothing new for you as generic/344 fails for you
> even with 3.17. But it should not :). I'll try to see if I can reproduce
> this in my test setup during more test runs (I don't remember seeing it
> during occasional runs I do) and debug it further.

Thanks!

In case it wasn't clear, I wasn't planning on letting these failures
prevent the patches from going upstream.  As you say, the generic/081
failure looks unrelated to ext4, and the generic/344 isn't a
regression.

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
