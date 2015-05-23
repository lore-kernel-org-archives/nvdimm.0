Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sat, 23 May 2015 16:32:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 00/11] evacuate struct page from the block layer,
	introduce __pfn_t
Message-ID: <20150523143257.GA19676@lst.de>
References: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, j.glisse@gmail.com, mingo@kernel.org, Alasdair Kergon <agk@redhat.com>, linux-arch@vger.kernel.org, linux-nvdimm@lists.01.org, hch@lst.de, mgorman@suse.de, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, riel@redhat.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>, axboe@kernel.dk, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

I don't like this series at all, it does too much and too little at
the same time.

There's three totally different parts to it that are mixed up:

 (1) cleanups to use accessors for struct scatterlist instead of exposing
     the intricate details of chained S/G list to users
 (2) a switch of struct scatterlist to store a PFN instead of a page
 (3) switch struct bio_vec to store a struct PFN instead of a page

(1) are pretty obvious cleanups, and they should have been submited
separately long time ago.

(2) seems like a good idea, but only when done properly, that is a full
conversion to it.  Not a you need a config option, in which case maybe
some architectures and can sometimes deal with it if they driver says:
meh, okay.

Given that nature of SGLs most consumer want a physical address anyway,
and it shouldn't be a problem to convert all others that need a kernel
mapping to proper helpers.

(3) I'm not sure about in it's current form.  The bio_vec sees all kinds
of highlevel use and we need to be a lot more careful about it, due to
the way we e.g. use the in the iov_iter based read/write interfaces.

It could be that pfn_t based approach there makes sense, but only if
we ensure all consumer can always handle them.

Because of that I'd suggest you try to get (1) and (2) done properly
first, at that point we'll have how we can do (3) without causing 
a big mess.

