Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <554CCE17.9000800@redhat.com>
Date: Fri, 08 May 2015 10:54:15 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer, introduce
 __pfn_t
References: <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com> <CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com> <CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com> <CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com> <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com> <20150507173641.GA21781@gmail.com> <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com> <554BA748.9030804@linux.intel.com> <20150507191107.GB22952@gmail.com> <554CBE17.4070904@redhat.com> <20150508140556.GA2185@gmail.com>
In-Reply-To: <20150508140556.GA2185@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/2015 10:05 AM, Ingo Molnar wrote:
> * Rik van Riel <riel@redhat.com> wrote:

>> Memory trends point in one direction, file size trends in another.
>>
>> For persistent memory, we would not need 4kB page struct pages 
>> unless memory from a particular area was in small files AND those 
>> files were being actively accessed. [...]
> 
> Average file size on my system's /usr is 12.5K:
> 
> triton:/usr> ( echo -n $(echo $(find . -type f -printf "%s\n") | sed 's/ /+/g' | bc); echo -n "/"; find . -type f -printf "%s\n" | wc -l; ) | bc
> 12502
> 
>> [...] Large files (mapped in 2MB chunks) or inactive small files 
>> would not need the 4kB page structs around.
> 
> ... they are the utter uncommon case. 4K is here to stay, and for a 
> very long time - until humans use computers I suspect.

There's a bit of an 80/20 thing going on, though.

The average file size may be small, but most data is used by
large files.

Additionally, a 2MB pmem area that has no small files on it that
are currently open will also not need 4kB page structs.

A system with 2TB of pmem might still only have a few thousand
small files open at any point in time. The rest of the memory
is either in large files, or in small files that have not been
opened recently. We can reclaim the struct pages of 4kB pages
that are not currently in use.

-- 
All rights reversed
