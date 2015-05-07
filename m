Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <554BA748.9030804@linux.intel.com>
Date: Thu, 07 May 2015 10:56:24 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer, introduce
 __pfn_t
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>	<CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>	<CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>	<CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>	<CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>	<CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>	<CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>	<CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>	<CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>	<20150507173641.GA21781@gmail.com> <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
In-Reply-To: <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/07/2015 10:42 AM, Dan Williams wrote:
> On Thu, May 7, 2015 at 10:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> * Dan Williams <dan.j.williams@intel.com> wrote:
>> So is there anything fundamentally wrong about creating struct page
>> backing at mmap() time (and making sure aliased mmaps share struct
>> page arrays)?
> 
> Something like "get_user_pages() triggers memory hotplug for
> persistent memory", so they are actual real struct pages?  Can we do
> memory hotplug at that granularity?

We've traditionally limited them to SECTION_SIZE granularity, which is
128MB IIRC.  There are also assumptions in places that you can do page++
within a MAX_ORDER block if !CONFIG_HOLES_IN_ZONE.

But, in all practicality, a lot of those places are in code like the
buddy allocator.  If your PTEs all have _PAGE_SPECIAL set and we're not
ever expecting these fake 'struct page's to hit these code paths, it
probably doesn't matter.

You can probably get away with just allocating PAGE_SIZE worth of
'struct page' (which is 64) and mapping it in to vmemmap[].  The worst
case is that you'll eat 1 page of space for each outstanding page of
I/O.  That's a lot better than 2MB of temporary 'struct page' space per
page of I/O that it would take with a traditional hotplug operation.
