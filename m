Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 8 May 2015 16:05:56 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150508140556.GA2185@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554CBE17.4070904@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Rik van Riel <riel@redhat.com> wrote:

> The disadvantage is pretty obvious too: 4kB pages would no longer be 
> the fast case, with an indirection. I do not know how much of an 
> issue that would be, or whether it even makes sense for 4kB pages to 
> continue being the fast case going forward.

I strongly disagree that 4kB does not matter as much: it is _the_ 
bread and butter of 99% of Linux usecases. 4kB isn't going away 
anytime soon - THP might look nice in benchmarks, but it does not 
matter nearly as much in practice and for filesystems and IO it's 
absolutely crazy to think about 2MB granularity.

Having said that, I don't think a single jump of indirection is a big 
issue - except for the present case where all the pmem IO space is 
mapped non-cacheable. Write-through caching patches are in the works 
though, and that should make it plenty fast.

> Memory trends point in one direction, file size trends in another.
> 
> For persistent memory, we would not need 4kB page struct pages 
> unless memory from a particular area was in small files AND those 
> files were being actively accessed. [...]

Average file size on my system's /usr is 12.5K:

triton:/usr> ( echo -n $(echo $(find . -type f -printf "%s\n") | sed 's/ /+/g' | bc); echo -n "/"; find . -type f -printf "%s\n" | wc -l; ) | bc
12502

> [...] Large files (mapped in 2MB chunks) or inactive small files 
> would not need the 4kB page structs around.

... they are the utter uncommon case. 4K is here to stay, and for a 
very long time - until humans use computers I suspect.

But I don't think the 2MB metadata chunking is wrong per se.

Thanks,

	Ingo
