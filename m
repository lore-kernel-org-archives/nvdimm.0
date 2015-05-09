Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <554D78C4.30607@redhat.com>
Date: Fri, 08 May 2015 23:02:28 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer, introduce
 __pfn_t
References: <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>	<CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>	<CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>	<CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>	<CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>	<20150507173641.GA21781@gmail.com>	<CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>	<554BA748.9030804@linux.intel.com>	<20150507191107.GB22952@gmail.com>	<554CBE17.4070904@redhat.com>	<20150508140556.GA2185@gmail.com>	<21836.51957.715473.780762@quad.stoffel.home>	<CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>	<554CEB5D.90209@redhat.com> <CA+55aFzeCiRSbzsX_NfScqF_-1JiVWj62Qo00pRttZp_s3hCVw@mail.gmail.com>
In-Reply-To: <CA+55aFzeCiRSbzsX_NfScqF_-1JiVWj62Qo00pRttZp_s3hCVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stoffel <john@stoffel.org>, Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/2015 09:14 PM, Linus Torvalds wrote:
> On Fri, May 8, 2015 at 9:59 AM, Rik van Riel <riel@redhat.com> wrote:
>>
>> However, for persistent memory, all of the files will be "in memory".
> 
> Yes. However, I doubt you will find a very sane rw filesystem that
> then also makes them contiguous and aligns them at 2MB boundaries.
> 
> Anything is possible, I guess, but things like that are *hard*. The
> fragmentation issues etc cause it to a really challenging thing.

The TLB performance bonus of accessing the large files with
large pages may make it worthwhile to solve that hard problem.

> And if they aren't aligned big contiguous allocations, then they
> aren't relevant from any largepage cases. You'll still have to map
> them 4k at a time etc.

Absolutely, but we only need the 4k struct pages when the
files are mapped. I suspect a lot of the files will just
sit around idle, without being used.

I am not convinced that the idea I wrote down earlier in
this thread is worthwhile now, but it may turn out to be
at some point in the future. It all depends on how much
data people store on DAX filesystems, and how many files
they have open at once.

-- 
All rights reversed
