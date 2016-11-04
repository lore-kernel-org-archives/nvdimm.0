From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/11] dax: Rip out get_block based IO support
Date: Fri, 4 Nov 2016 01:03:19 +0100
Message-ID: <20161104000319.GI24234@quack2.suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <1478034381-19037-12-git-send-email-jack@suse.cz>
 <20161102143100.GC18387@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161102143100.GC18387@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ted Tso <tytso@mit.edu>, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Wed 02-11-16 07:31:00, Christoph Hellwig wrote:
> On Tue, Nov 01, 2016 at 10:06:21PM +0100, Jan Kara wrote:
> > No one uses functions using the get_block callback anymore. Rip them
> > out.
> 
> Documentation/filesystems/dax.txt will also need some updates for this.

Right, will do.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
