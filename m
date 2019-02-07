Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com
 [IPv6:2607:f8b0:4864:20::32c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBB2A2194D387
 for <linux-nvdimm@lists.01.org>; Wed,  6 Feb 2019 16:22:29 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id w25so15273802otm.13
 for <linux-nvdimm@lists.01.org>; Wed, 06 Feb 2019 16:22:29 -0800 (PST)
MIME-Version: 1.0
References: <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <20190206232130.GK12227@ziepe.ca>
 <CAPcyv4g2r=L3jfSDoRPt4VG7D_2CxCgv3s+JLu4FQRUSRWg+4Q@mail.gmail.com>
 <20190206234132.GB15234@ziepe.ca>
In-Reply-To: <20190206234132.GB15234@ziepe.ca>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Feb 2019 16:22:16 -0800
Message-ID: <CAPcyv4h1=GTAqHBw+Zsp9eNYR3HFbB_qjmhntwnO-jyGun4QNA@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
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
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 6, 2019 at 3:41 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
[..]
> > You're describing the current situation, i.e. Linux already implements
> > this, it's called Device-DAX and some users of RDMA find it
> > insufficient. The choices are to continue to tell them "no", or say
> > "yes, but you need to submit to lease coordination".
>
> Device-DAX is not what I'm imagining when I say XFS--.
>
> I mean more like XFS with all features that require rellocation of
> blocks disabled.
>
> Forbidding hold punch, reflink, cow, etc, doesn't devolve back to
> device-dax.

True, not all the way, but the distinction loses significance as you
lose fs features.

Filesystems mark DAX functionality experimental [1] precisely because
it forbids otherwise typical operations that work in the nominal page
cache case. An approach that says "lets cement the list of things a
filesystem or a core-memory-mangement facility can't do because RDMA
finds it awkward" is bad precedent. It's bad precedent because it
abdicates core kernel functionality to userspace and weakens the api
contract in surprising ways.

EBUSY is a horrible status code especially if an administrator is
presented with an emergency situation that a filesystem needs to free
up storage capacity and get established memory registrations out of
the way. The motivation for the current status quo of failing memory
registration for DAX mappings is to help ensure the system does not
get into this situation where forward progress cannot be guaranteed.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2019-February/019884.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
