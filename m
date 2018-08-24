Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC73C210F4BB5
 for <linux-nvdimm@lists.01.org>; Fri, 24 Aug 2018 08:44:46 -0700 (PDT)
Date: Fri, 24 Aug 2018 17:44:43 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180824154443.GA26549@quack2.suse.cz>
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
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: sandeen@redhat.com, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 13-08-18 12:12:52, Jan Kara wrote:
> On Fri 10-08-18 22:10:53, Theodore Y. Ts'o wrote:
> > The generic/344 failure seems to be caused by a WARNING triggered in
> > the nvdimm code:
> 
> OK, apparently this is nothing new for you as generic/344 fails for you
> even with 3.17. But it should not :). I'll try to see if I can reproduce
> this in my test setup during more test runs (I don't remember seeing it
> during occasional runs I do) and debug it further.

I could reproduce this relatively easily but it took me quite a while to
figure out how to best fix this. I'll send the fix shortly (mm: Fix warning
in insert_pfn()).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
