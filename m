From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 0/11] ext4: Convert ext4 DAX IO to iomap framework
Date: Fri, 4 Nov 2016 01:55:02 +0100
Message-ID: <20161104005502.GJ24234@quack2.suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <20161101221235.GB9920@dastard>
 <20161101224550.GA2314@linux.intel.com>
 <20161101230903.GA20418@quack2.suse.cz>
 <20161102130353.nt3oqodrik4hnfk6@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161102130353.nt3oqodrik4hnfk6-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed 02-11-16 09:03:53, Ted Tso wrote:
> On Wed, Nov 02, 2016 at 12:09:03AM +0100, Jan Kara wrote:
> > > > I plan to grab Ross's PMD series in the next couple of days and I'll
> > > > push it out as a stable topic branch once I've sanity tested it.  I
> > > > don't really want to take a big chunk of ext4 stuff through the XFS
> > > > tree if it can be avoided....
> > > 
> > > Yea, we also need to figure out how to get Jan's "dax: Clear dirty bits after
> > > flushing caches" set merged, which is mostly MM stuff and I think will go
> > > through akpm's tree?  That set is also based on my PMD stuff.
> > 
> > Yeah, I've spoken to Andrew and he wants to take the MM changes through his
> > tree. I'll talk to him how to make this happen given the patches the series
> > depends on but the series still needs some review so "how to merge" is not
> > exactly a question of the day...
> 
> I assume there isn't a convenient git tree I can pull for the purposes
> of testing Jan's patch series and for the purposes of seeing how
> everything fits together?  In other words, as far as I understand
> things there currently isn't an unstable topic branch I can pull for
> the purposes of review and testing, but hopefully Dave will make a
> stable topic branch in a few days.  Is that right?

So just for getting idea what the changes are about and to run some tests
you can use my unstable branch which Dave mentioned:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dax

As Christoph had some review comments, I'll be updating that probably
tomorrow when I have tested updated series. I'll also add some other iomap
related patches that were sitting later in my branch after DAX mmap changes
but which, as I realized, don't really depend on them.

WRT the merging the plan is Dave will take all patches that are
prerequisite for this series and push them out in a stable branch which you
can then pull into your tree to merge ext4 iomap changes.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
