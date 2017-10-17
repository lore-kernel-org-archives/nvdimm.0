Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCF0D202E5CDD
 for <linux-nvdimm@lists.01.org>; Mon, 16 Oct 2017 23:43:13 -0700 (PDT)
Date: Tue, 17 Oct 2017 08:46:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Message-ID: <20171017064647.GA15437@lst.de>
References: <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
 <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
 <20171013173145.GA18702@obsidianresearch.com> <20171016072644.GB28270@lst.de>
 <CAPcyv4itbYQqVrHBZ=+BRLH39WwDZ_RGg6sSaodVZ93LRYigNA@mail.gmail.com>
 <CAPcyv4gtnZu7obG7UwaBq1-fwRZj06HCa=mjBfDKKgfp97nYaw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gtnZu7obG7UwaBq1-fwRZj06HCa=mjBfDKKgfp97nYaw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 16, 2017 at 12:44:31PM -0700, Dan Williams wrote:
> > While I agree with the need for a per-MR notification mechanism, one
> > thing we lose by walking away from MAP_DIRECT is a way for a
> > hypervisor to coordinate pass through of a DAX mapping to an RDMA
> > device in a guest. That will remain a case where we will still need to
> > use device-dax. I'm fine if that's the answer, but just want to be
> > clear about all the places we need to protect a DAX mapping against
> > RDMA from a non-ODP device.
> 
> For this specific issue perhaps we promote FL_LAYOUT as a lease-type
> that can be set by fcntl().

I don't think it is a good userspace interface, mostly because it
is about things that don't matter for userspace (block mappings).

It makes sense as a kernel interface for callers that want to pin
down a memory long-term, but for userspace the fact that the block
mapping changes doesn't matter - it matters that their long term
pin is broken by something.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
