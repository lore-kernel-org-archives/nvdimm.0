Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150510094619.GA15198@gmail.com>
References: <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
	<554BA748.9030804@linux.intel.com>
	<20150507191107.GB22952@gmail.com>
	<554CBE17.4070904@redhat.com>
	<20150508140556.GA2185@gmail.com>
	<21836.51957.715473.780762@quad.stoffel.home>
	<CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
	<554CEB5D.90209@redhat.com>
	<20150509084510.GA10587@gmail.com>
	<CAPcyv4jQei27PS9Cqfv-NXTDwp9LGa2twH1tTiSsFWAAV4Vzng@mail.gmail.com>
	<20150510094619.GA15198@gmail.com>
Date: Sun, 10 May 2015 10:29:01 -0700
Message-ID: <CAPcyv4gNV2W0XR8QNcyt1f4oOODNJKo6K7soBF2uCOWbKJEX=Q@mail.gmail.com>
Subject: Re: "Directly mapped persistent memory page cache"
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, May 10, 2015 at 2:46 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> > "Directly mapped pmem integrated into the page cache":
>> > ------------------------------------------------------
>
>> Nice, I think it makes sense as an area that gets reserved at file
>> system creation time.  You are not proposing that this gets
>> automatically reserved at the device level, right? [...]
>
> Well, it's most practical if the device does it automatically (the
> layout is determined prior filesystem creation), and the filesystem
> does not necessarily have to be aware of it - but obviously as a user
> opt-in.
>

Hmm, my only hesitation is that the raw size of a pmem device is
visible outside of Linux (UEFI/BIOS other OSes, etc).  What about a
simple layered block-device that fronts a raw pmem device?  It can
store a small superblock signature and then reserve / init the struct
page space.  This is where we can use the __pfn_t flags that Linus
suggested.  Whereas the raw device ->direct_access() returns __pfn_t
values with a 'PFN_DEV' flag indicating originating from
device-memory, a ->direct_access() on this struct-page-provider-device
yields __pfn_t's with 'PFN_DEV | PFN_MAPPED' indicating that
__pfn_t_to_page() can attempt to lookup the page in a device-specific
manner (similar to how kmap_atomic_pfn_t is implemented in the
'evacuate struct page from the block layer' patch set).
