From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/11] ext4: Convert ext4 DAX IO to iomap framework
Date: Wed, 2 Nov 2016 09:03:53 -0400
Message-ID: <20161102130353.nt3oqodrik4hnfk6@thunk.org>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <20161101221235.GB9920@dastard>
 <20161101224550.GA2314@linux.intel.com>
 <20161101230903.GA20418@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161101230903.GA20418@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Nov 02, 2016 at 12:09:03AM +0100, Jan Kara wrote:
> > > I plan to grab Ross's PMD series in the next couple of days and I'll
> > > push it out as a stable topic branch once I've sanity tested it.  I
> > > don't really want to take a big chunk of ext4 stuff through the XFS
> > > tree if it can be avoided....
> > 
> > Yea, we also need to figure out how to get Jan's "dax: Clear dirty bits after
> > flushing caches" set merged, which is mostly MM stuff and I think will go
> > through akpm's tree?  That set is also based on my PMD stuff.
> 
> Yeah, I've spoken to Andrew and he wants to take the MM changes through his
> tree. I'll talk to him how to make this happen given the patches the series
> depends on but the series still needs some review so "how to merge" is not
> exactly a question of the day...

I assume there isn't a convenient git tree I can pull for the purposes
of testing Jan's patch series and for the purposes of seeing how
everything fits together?  In other words, as far as I understand
things there currently isn't an unstable topic branch I can pull for
the purposes of review and testing, but hopefully Dave will make a
stable topic branch in a few days.  Is that right?

       	     	       	     	       	    - Ted
