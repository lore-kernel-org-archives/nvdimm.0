Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 10 May 2015 11:46:19 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150510094619.GA15198@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jQei27PS9Cqfv-NXTDwp9LGa2twH1tTiSsFWAAV4Vzng@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> > "Directly mapped pmem integrated into the page cache":
> > ------------------------------------------------------

> Nice, I think it makes sense as an area that gets reserved at file 
> system creation time.  You are not proposing that this gets 
> automatically reserved at the device level, right? [...]

Well, it's most practical if the device does it automatically (the 
layout is determined prior filesystem creation), and the filesystem 
does not necessarily have to be aware of it - but obviously as a user 
opt-in.

> [...] For the use cases of persistent memory in the absence of a 
> file system (in-kernel managed hierarchical storage driver, or 
> mmap() the pmem block device directly) there's still a need for 
> pfn-based DAX. [...]

Yes, but knowing that there's a sane model we can take a hard stance 
against pfn proliferation and say: 'we let pfns this far and no 
farther'.

> [...]  In other words, simple usages skip the overhead.  They assume 
> pfns only, discover those pmem pfns via ->direct_access(), and 
> arrange for exclusive block device ownership.  Everything else that 
> requires struct page in turn requires a file system to have opt-ed 
> into this reservation and provide pmem-struct-page infrastructure, 
> pmem-aware-DIO etc.

Yes.

Thanks,

	Ingo
