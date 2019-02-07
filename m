Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 6 Feb 2019 22:33:07 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Message-ID: <20190207053307.GB22726@ziepe.ca>
References: <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <20190206232130.GK12227@ziepe.ca>
 <CAPcyv4g2r=L3jfSDoRPt4VG7D_2CxCgv3s+JLu4FQRUSRWg+4Q@mail.gmail.com>
 <20190206234132.GB15234@ziepe.ca>
 <CAPcyv4h1=GTAqHBw+Zsp9eNYR3HFbB_qjmhntwnO-jyGun4QNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h1=GTAqHBw+Zsp9eNYR3HFbB_qjmhntwnO-jyGun4QNA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 06, 2019 at 04:22:16PM -0800, Dan Williams wrote:
> On Wed, Feb 6, 2019 at 3:41 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> [..]
> > > You're describing the current situation, i.e. Linux already implements
> > > this, it's called Device-DAX and some users of RDMA find it
> > > insufficient. The choices are to continue to tell them "no", or say
> > > "yes, but you need to submit to lease coordination".
> >
> > Device-DAX is not what I'm imagining when I say XFS--.
> >
> > I mean more like XFS with all features that require rellocation of
> > blocks disabled.
> >
> > Forbidding hold punch, reflink, cow, etc, doesn't devolve back to
> > device-dax.
> 
> True, not all the way, but the distinction loses significance as you
> lose fs features.
> 
> Filesystems mark DAX functionality experimental [1] precisely because
> it forbids otherwise typical operations that work in the nominal page
> cache case. An approach that says "lets cement the list of things a
> filesystem or a core-memory-mangement facility can't do because RDMA
> finds it awkward" is bad precedent. 

I'm not saying these rules should apply globaly.

I'm suggesting you could have a FS that supports gup_longterm by
design, and a FS that doesn't. And that is OK. They can have different
rules.

Obviously the golden case here is to use ODP (which doesn't call
gup_longterm at all) - that works for both.

Supporting non-ODP is a trade off case - users that want to run on
limited HW must accept limited functionality. Limited functionality is
better than no-funtionality.

Linux has many of these user-choose tradeoffs. This is how it supports
such a wide range of HW capabilities. Not all HW can do all
things. Some features really do need HW support. It has always been
that way.

Jason
