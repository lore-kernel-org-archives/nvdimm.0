Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
	<CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
Date: Wed, 6 May 2015 17:19:48 -0700
Message-ID: <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 6, 2015 at 4:47 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> Conceptually better, but certainly more difficult to audit if the fake
> struct page is initialized in a subtle way that breaks when/if it
> leaks to some unwitting context.

Maybe. It could go either way, though. In particular, with the
"dynamically allocated struct page" approach, if somebody uses it past
the supposed lifetime of the use, things like poisoning the temporary
"struct page" could be fairly effective. You can't really poison the
pfn - it's just a number, and if somebody uses it later than you think
(and you have re-used that physical memory for something else), you'll
never ever know.

I'd *assume* that most users of the dynamic "struct page" allocation
have very clear lifetime rules. Those things would presumably normally
get looked-up by some extended version of "get_user_pages()", and
there's a clear use of the result, with no longer lifetime. Also, you
do need to have some higher-level locking when you  do this, to make
sure that the persistent pages don't magically get re-assigned. We're
presumably talking about having a filesystem in that persistent
memory, so we cannot be doing IO to the pages (from some other source
- whether RDMA or some special zero-copy model) while the underlying
filesystem is reassigning the storage because somebody deleted the
file.

IOW, there had better be other external rules about when - and how
long - you can use a particular persistent page. No? So the whole
"when/how to allocate the temporary 'struct page'" is just another
detail in that whole thing.

And yes, some uses may not ever actually see that. If the whole of
persistent memory is just assigned to a database or something, and the
DB just wants to do a "flush this range of persistent memory to
long-term disk storage", then there may not be much of a "lifetime"
issue for the persistent memory. But even then you're going to have IO
completion callbacks etc to let the DB know that it has hit the disk,
so..

What is the primary thing that is driving this need? Do we have a very
concrete example?

                     Linus
