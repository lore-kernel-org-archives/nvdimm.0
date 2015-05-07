Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 19:36:41 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150507173641.GA21781@gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
 <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
 <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
 <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
 <CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>
 <CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>
 <CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>
 <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> > Anyway, I did want to say that while I may not be convinced about 
> > the approach, I think the patches themselves don't look horrible. 
> > I actually like your "__pfn_t". So while I (very obviously) have 
> > some doubts about this approach, it may be that the most 
> > convincing argument is just in the code.
> 
> Ok, I'll keep thinking about this and come back when we have a 
> better story about passing mmap'd persistent memory around in 
> userspace.

So is there anything fundamentally wrong about creating struct page 
backing at mmap() time (and making sure aliased mmaps share struct 
page arrays)?

Because if that is done, then the DMA agent won't even know about the 
memory being persistent RAM. It's just a regular struct page, that 
happens to point to persistent RAM. Same goes for all the high level 
VM APIs, futexes, etc. Everything will Just Work.

It will also be relatively fast: mmap() is a relative slowpath, 
comparatively.

As far as RAID is concerned: that's a relatively easy situation, as 
there's only a single user of the devices, the RAID context that 
manages all component devices exclusively. Device to device DMA can 
use the block layer directly, i.e. most of the patches you've got here 
in this series, except:

74287   C May 06 Dan Williams    ( 232) ├─>[PATCH v2 09/10] dax: convert to __pfn_t

I think DAX mmap()s need struct page backing.

I think there's a simple rule: if a page is visible to user-space via 
the MMU then it needs struct page backing. If it's "hidden", like 
behind a RAID abstraction, it probably doesn't.

With the remaining patches a high level RAID driver ought to be able 
to send pfn-to-sector and sector-to-pfn requests to other block 
drivers, without any unnecessary struct page allocation overhead, 
right?

As long as the pfn concept remains a clever way to reuse our 
ram<->sector interfaces to implement sector<->sector IO, in the cases 
where the IO has no serialization or MMU concerns, not using struct 
page and using pfn_t looks natural.

The moment it starts reaching user space APIs, like in the DAX case, 
and especially if it becomes user-MMU visible, it's a mistake to not 
have struct page backing, I think.

(In that sense the current DAX mmap() code is already a partial 
mistake.)

Thanks,

	Ingo
