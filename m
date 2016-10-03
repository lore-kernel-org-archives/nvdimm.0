From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/20] mm: Join struct fault_env and vm_fault
Date: Mon, 3 Oct 2016 09:43:51 +0200
Message-ID: <20161003074351.GF6457@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-3-git-send-email-jack@suse.cz>
 <20160930091014.GB24352@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160930091014.GB24352@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Fri 30-09-16 02:10:14, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 06:08:06PM +0200, Jan Kara wrote:
> > Currently we have two different structures for passing fault information
> > around - struct vm_fault and struct fault_env. DAX will need more
> > information in struct vm_fault to handle its faults so the content of
> > that structure would become event closer to fault_env. Furthermore it
> > would need to generate struct fault_env to be able to call some of the
> > generic functions. So at this point I don't think there's much use in
> > keeping these two structures separate. Just embed into struct vm_fault
> > all that is needed to use it for both purposes.
> 
> Looks sensible, and I wonder why it's not been like that from
> the start.  But given that you touched all users of the virtual_address
> member earlier:  any reason not to move everyone to the unmasked variant
> there and avoid having to pass the address twice?

Hum, right, probably makes sense. I'll do that for the next version.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
