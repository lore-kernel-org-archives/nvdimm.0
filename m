Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 13:30:58 -0400
From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150507173057.GA5966@gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
 <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
 <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
 <20150507161807.GA1671@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150507161807.GA1671@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 07, 2015 at 06:18:07PM +0200, Christoph Hellwig wrote:
> On Wed, May 06, 2015 at 05:19:48PM -0700, Linus Torvalds wrote:
> > What is the primary thing that is driving this need? Do we have a very
> > concrete example?
> 
> FYI, I plan to to implement RAID acceleration using nvdimms, and I plan to
> ue pages for that.  The code just merge for 4.1 can easily support page
> backing, and I plan to use that for now.  This still leaves support
> for the gigantic intel nvdimms discovered over EFI out, but given that
> I don't have access to them, and I dont know of any publically available
> there's little I can do for now.  But adding on demand allocate struct
> pages for the seems like the easiest way forward.  Boaz already has
> code to allocate pages for them, although not on demand but at boot / plug in
> time.

I think here other folks might be interested, i am ccing Paul. But for GPU
we are facing similar issue of trying to present the GPU memory to the kernel
in a coherent way (coherent from the design and linux kernel concept POV).

For this dynamicaly allocated struct page might effectively be a solution that
could be share btw persistent memory and GPU folks. We can even enforce thing
like VMEMMAP and have special region carveout where we can dynamicly map/unmap
backing page for range of device pfn. This would also allow to catch people
trying to access such page, we could add a set of new helper like :
get_page_dev()/put_page_dev() ... and only the _dev version would works on
this new kind of memory, regular get_page()/put_page() would throw error.
This should allow to make sure only legitimate users are referencing such
page.

Issue might be that we can run out of kernel address space with 48bits but if
such monstruous computer ever see the light of day they might consider using
CPU with more bits.

Another issue is that we might care for the 32bits platform too, but that's
solvable at a small cost.

Cheers,
J�r�me
