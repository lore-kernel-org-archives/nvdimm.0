Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 18:18:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
	introduce __pfn_t
Message-ID: <20150507161807.GA1671@lst.de>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com> <CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com> <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com> <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 06, 2015 at 05:19:48PM -0700, Linus Torvalds wrote:
> What is the primary thing that is driving this need? Do we have a very
> concrete example?

FYI, I plan to to implement RAID acceleration using nvdimms, and I plan to
ue pages for that.  The code just merge for 4.1 can easily support page
backing, and I plan to use that for now.  This still leaves support
for the gigantic intel nvdimms discovered over EFI out, but given that
I don't have access to them, and I dont know of any publically available
there's little I can do for now.  But adding on demand allocate struct
pages for the seems like the easiest way forward.  Boaz already has
code to allocate pages for them, although not on demand but at boot / plug in
time.
