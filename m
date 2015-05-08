Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <21836.51957.715473.780762@quad.stoffel.home>
References: <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
	<CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>
	<CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>
	<CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>
	<CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
	<20150507173641.GA21781@gmail.com>
	<CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
	<554BA748.9030804@linux.intel.com>
	<20150507191107.GB22952@gmail.com>
	<554CBE17.4070904@redhat.com>
	<20150508140556.GA2185@gmail.com>
	<21836.51957.715473.780762@quad.stoffel.home>
Date: Fri, 8 May 2015 08:54:06 -0700
Message-ID: <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 8, 2015 at 7:40 AM, John Stoffel <john@stoffel.org> wrote:
>
> Now go and look at your /home or /data/ or /work areas, where the
> endusers are actually keeping their day to day work.  Photos, mp3,
> design files, source code, object code littered around, etc.

However, the big files in that list are almost immaterial from a
caching standpoint.

Caching source code is a big deal - just try not doing it and you'll
figure it out. And the kernel C source files used to have a median
size around 4k.

The big files in your home directory? Let me make an educated guess.
Very few to *none* of them are actually in your page cache right now.
And you'd never even care if they ever made it into your page cache
*at*all*. Much less whether you could ever cache them using large
pages using some very fancy cache.

There are big files that care about caches, but they tend to be
binaries, and for other reasons (things like randomization) you would
never want to use largepages for those anyway.

So from a page cache standpoint, I think the 4kB size still matters. A
*lot*. largepages are a complete red herring, and will continue to be
so pretty much forever (anonymous largepages perhaps less so).

                Linus
