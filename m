Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 10 May 2015 07:56:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150509215633.GN4327@dastard>
References: <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <CA+55aFzeCiRSbzsX_NfScqF_-1JiVWj62Qo00pRttZp_s3hCVw@mail.gmail.com>
 <554D78C4.30607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554D78C4.30607@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 08, 2015 at 11:02:28PM -0400, Rik van Riel wrote:
> On 05/08/2015 09:14 PM, Linus Torvalds wrote:
> > On Fri, May 8, 2015 at 9:59 AM, Rik van Riel <riel@redhat.com> wrote:
> >>
> >> However, for persistent memory, all of the files will be "in memory".
> > 
> > Yes. However, I doubt you will find a very sane rw filesystem that
> > then also makes them contiguous and aligns them at 2MB boundaries.
> > 
> > Anything is possible, I guess, but things like that are *hard*. The
> > fragmentation issues etc cause it to a really challenging thing.
> 
> The TLB performance bonus of accessing the large files with
> large pages may make it worthwhile to solve that hard problem.

FWIW, for DAX ththe filesystem allocation side is already mostly
solved - this is just an allocation alignment hint, analogous to
RAID stripe alignment.  We don't need to reinvent the wheel here.
i.e. On XFS, use a 2MB stripe unit for the fs, a 2MB extent size
hint for files you want to use large pages on and you'll get 2MB
sized and aligned allocations from the filesystem for as long as
there are such freespace regions available.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
