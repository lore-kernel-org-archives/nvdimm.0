From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [Qemu-devel] security implications of caching with virtio pmem
 (was Re: [PATCH v3 0/5] kvm "virtio pmem" device)
Date: Mon, 11 Feb 2019 18:07:02 -0500
Message-ID: <20190211180449-mutt-send-email-mst@kernel.org>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190204170515-mutt-send-email-mst@kernel.org>
 <888328358.132676.1549870186945.JavaMail.zimbra@redhat.com>
 <20190211222907.GR14116@dastard>
 <b2be7796-9dee-b9fd-87e5-1ae570aa7db6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b2be7796-9dee-b9fd-87e5-1ae570aa7db6@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Hildenbrand <david@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Pankaj Gupta <pagupta@redhat.com>, dchinner@redhat.com, jack@suse.cz, kvm@vger.kernel.org, linux-nvdimm@ml01.01.org, jasowang@redhat.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, Andrea Arcangeli <aarcange@redhat.com>, dave jiang <dave.jiang@intel.com>, darrick wong <darrick.wong@oracle.com>, vishal l verma <vishal.l.verma@intel.com>, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, imammedo@redhat.com, dan j williams <dan.j.williams@intel.com>, lcapitulino@redhat.com, kwolf@redhat.com, linux-ext4@vger.kernel.org, tytso@mit.edu, xiaoguangrong
List-Id: linux-nvdimm@lists.01.org

On Mon, Feb 11, 2019 at 11:58:15PM +0100, David Hildenbrand wrote:
> On 11.02.19 23:29, Dave Chinner wrote:
> > On Mon, Feb 11, 2019 at 02:29:46AM -0500, Pankaj Gupta wrote:
> >> Hello Dave,
> >> Are we okay with this?
> > 
> > Sure.
> > 
> > I'm not sure I agree with all the analysis presented, but, well, I
> > haven't looked any deeper because I'm tired of being shouted at and
> > being called argumentative for daring to ask hard questions about
> > this topic....
> 
> I think if you have concerns, they should definitely be discussed.
> Making people frustrated that review code is not what we want. Not at all.
> 
> I suggest that Pankaj properly documents what we found out so far about
> security concerns and properly describes intended use cases and answers
> other questions you had in the cover letter / documentation of the
> follow up series.
> 
> Thanks Dave!

Right. Also, there's an open question that you posed:
	Also other storage devices have caches like that (well, the caches size
	depends on the device) - thinking especially about storage systems -
	which would in my opinion, also allow similar leaks. How are such
	security concerns handled there? Are they different (besides eventually
	access speed)?
and that needs some looking into, and reporting on.


> > 
> > Cheers,
> > 
> > Dave.
> > 
> 
> 
> -- 
> 
> Thanks,
> 
> David / dhildenb
