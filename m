Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F3FD210EB4F7
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 13:33:59 -0700 (PDT)
Date: Fri, 10 Aug 2018 16:33:49 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180810203349.GH627@thunk.org>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
 <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
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
To: sandeen@redhat.com
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 10, 2018 at 02:52:53PM -0500, Eric Sandeen wrote:
> 
> Hi Ted, hadn't seem feedback from you on this by the time it gathered reviews,
> is this something you plan to merge for realz?  (I see it's on your dev
> branch now, just not sure of its permanence at this point.)

Yes, the dev branch is pretty much locked down since I assume the
merge window is openning over the weekend.

The reason why I've been silent is because I haven't had a chance to
do was a test run with DAX, because up until recently I wasn't able to
run a DAX regression test run.  (That's because of the CONFIG_KASAN
incompatibility with CONFIG_ZONE_DEVICE that caused the kernel to
instantly blow up on boot if I tried to enable emulated /dev/pmem
devices.)

I just kicked off a DAX test ("gce-xfstests -c dax -g auto") with
CONFIG_KASAN disabled, and I expect it shouldn't show up anything
concerning.  So assuming nothing surprising pops up, yes it should be
merged at the next merge window.

	     		    	     	  - Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
