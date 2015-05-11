Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 11 May 2015 12:38:02 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150511103802.GA18700@gmail.com>
References: <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <20150509084510.GA10587@gmail.com>
 <20150511082536.GP4327@dastard>
 <20150511091836.GA29191@gmail.com>
 <d2eje8o4h2xfg2xk74stiixd.1431336929400@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2eje8o4h2xfg2xk74stiixd.1431336929400@email.android.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Zuckerman, Boris" <borisz@hp.com>
Cc: Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Zuckerman, Boris <borisz@hp.com> wrote:

> Hi,
> 
> Data transformation (EC, encryption, etc) is commonly done by 
> storage systems today. [...]

That's a strawman argument: if you do encryption/compression in the 
storage space then you don't need complex struct page descriptors for 
the storage space: as the resulting content won't be mappable nor 
DMA-able into from high level APIs...

My proposal adds a RAM-integrated usage model for devices that are 
directly mapped in physical RAM space (such as persistent memory), 
where integration with high level Linux APIs is possible and 
desirable.

If pmem is used as a front-side cache for a larger storage system 
behind, then the disk side can still be encrypted/compressed/etc.

( Also note that if the pmem hardware itself adds an encryption pass 
  then actual stored content might still be encrypted. )

> [...] But let's think about other less common existing and PM 
> specific upcoming features like data sharing between multiple 
> consumers (computers for example), [...]

RDMA should work fine if the pmem hardware exposes it.

> [...] support for atomicity (to avoid journaling in PM space), etc.

This too should work fine, by way of the SMP coherency protocol, if 
atomic instructions are used on the relevant metadata.

Thanks,

	Ingo
