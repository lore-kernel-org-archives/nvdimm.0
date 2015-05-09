Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <554D78C4.30607@redhat.com>
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
	<CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
	<554CEB5D.90209@redhat.com>
	<CA+55aFzeCiRSbzsX_NfScqF_-1JiVWj62Qo00pRttZp_s3hCVw@mail.gmail.com>
	<554D78C4.30607@redhat.com>
Date: Fri, 8 May 2015 20:52:00 -0700
Message-ID: <CA+55aFxQivROHSsDs+Zs8ag=0cNJRyCwTzAXBzW8UTRpfXBf3w@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 8, 2015 at 8:02 PM, Rik van Riel <riel@redhat.com> wrote:
>
> The TLB performance bonus of accessing the large files with
> large pages may make it worthwhile to solve that hard problem.

Very few people can actually measure that TLB advantage on systems
with good TLB's.

It's largely a myth, fed by some truly crappy TLB fill systems
(particularly sw-filled TLB's on some early RISC CPU's, but even
"modern" CPU's sometimes have glass jaws here because they cant'
prefetch TLB entries or do concurrent page table walks etc).

There are *very* few loads that actually have the kinds of access
patterns where TLB accesses dominate - or are even noticeable -
compared to the normal memory access costs.

That is doubly true with file-backed storage. The main reason you get
TLB costs to be noticeable is with very sparse access patterns, where
you hit as many TLB entries as you hit pages. That simply doesn't
happen with file mappings.

Really. The whole thing about TLB advantages of hugepages is this
almost entirely made-up stupid myth. You almost have to make up the
benchmark for it (_that_ part is easy) to even see it.

                         Linus
