Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 13 Jun 2019 14:18:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190613171834.GE22901@ziepe.ca>
References: <20190612102917.GB14578@quack2.suse.cz>
 <20190612114721.GB3876@ziepe.ca>
 <20190612120907.GC14578@quack2.suse.cz>
 <20190612191421.GM3876@ziepe.ca>
 <20190612221336.GA27080@iweiny-DESK2.sc.intel.com>
 <CAPcyv4gkksnceCV-p70hkxAyEPJWFvpMezJA1rEj6TEhKAJ7qQ@mail.gmail.com>
 <20190612233324.GE14336@iweiny-DESK2.sc.intel.com>
 <CAPcyv4jf19CJbtXTp=ag7Ns=ZQtqeQd3C0XhV9FcFCwd9JCNtQ@mail.gmail.com>
 <20190613151354.GC22901@ziepe.ca>
 <CAPcyv4hZsxd+eUrVCQmm-O8Zcu16O5R1d0reTM+JBBn7oP7Uhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hZsxd+eUrVCQmm-O8Zcu16O5R1d0reTM+JBBn7oP7Uhw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 09:25:54AM -0700, Dan Williams wrote:
> On Thu, Jun 13, 2019 at 8:14 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Wed, Jun 12, 2019 at 06:14:46PM -0700, Dan Williams wrote:
> > > > Effectively, we would need a way for an admin to close a specific file
> > > > descriptor (or set of fds) which point to that file.  AFAIK there is no way to
> > > > do that at all, is there?
> > >
> > > Even if there were that gets back to my other question, does RDMA
> > > teardown happen at close(fd), or at final fput() of the 'struct
> > > file'?
> >
> > AFAIK there is no kernel side driver hook for close(fd).
> >
> > rdma uses a normal chardev so it's lifetime is linked to the file_ops
> > release, which is called on last fput. So all the mmaps, all the dups,
> > everything must go before it releases its resources.
> 
> Oh, I must have missed where this conversation started talking about
> the driver-device fd. 

In the first paragraph above where Ira is musing about 'close a
specific file', he is talking about the driver-device fd.

Ie unilaterally closing /dev/uverbs as a punishment for an application
that used leases wrong: ie that released its lease with the RDMA is
still ongoing. 

Jason
