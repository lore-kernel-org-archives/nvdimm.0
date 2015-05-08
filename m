Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <554CEB5D.90209@redhat.com>
Date: Fri, 08 May 2015 12:59:09 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer, introduce
 __pfn_t
References: <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>	<CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>	<CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>	<CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>	<CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>	<20150507173641.GA21781@gmail.com>	<CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>	<554BA748.9030804@linux.intel.com>	<20150507191107.GB22952@gmail.com>	<554CBE17.4070904@redhat.com>	<20150508140556.GA2185@gmail.com>	<21836.51957.715473.780762@quad.stoffel.home> <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
In-Reply-To: <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/2015 11:54 AM, Linus Torvalds wrote:
> On Fri, May 8, 2015 at 7:40 AM, John Stoffel <john@stoffel.org> wrote:
>>
>> Now go and look at your /home or /data/ or /work areas, where the
>> endusers are actually keeping their day to day work.  Photos, mp3,
>> design files, source code, object code littered around, etc.
> 
> However, the big files in that list are almost immaterial from a
> caching standpoint.

> The big files in your home directory? Let me make an educated guess.
> Very few to *none* of them are actually in your page cache right now.
> And you'd never even care if they ever made it into your page cache
> *at*all*. Much less whether you could ever cache them using large
> pages using some very fancy cache.

However, for persistent memory, all of the files will be "in memory".

Not instantiating the 4kB struct pages for 2MB areas that are not
currently being accessed with small files may make a difference.
For dynamically allocated 4kB page structs, we need some way to
discover where they are. It may make sense, from a simplicity point
of view, to have one mechanism that works both for pmem and for
normal system memory.

I agree that 4kB granularity needs to continue to work pretty much
forever, though. As long as people continue creating text files,
they will just not be very large.

-- 
All rights reversed
