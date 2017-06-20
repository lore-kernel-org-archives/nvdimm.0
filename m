Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E6BCA21AE2639
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 01:48:03 -0700 (PDT)
Date: Tue, 20 Jun 2017 10:49:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Message-ID: <20170620084924.GA9752@lst.de>
References: <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
 <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
 <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
 <20170619132107.GG11993@dastard>
 <CALCETrUe0igzK0RZTSSondkCY3ApYQti89tOh00f0j_APrf_dQ@mail.gmail.com>
 <20170620004653.GI17542@dastard>
 <CALCETrVuoPDRuuhc9X8eVCYiFUzWLSTRkcjbD6jas_2J2GixNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrVuoPDRuuhc9X8eVCYiFUzWLSTRkcjbD6jas_2J2GixNQ@mail.gmail.com>
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
To: Andy Lutomirski <luto@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

[stripped giant fullquotes]

On Mon, Jun 19, 2017 at 10:53:12PM -0700, Andy Lutomirski wrote:
> But that's my whole point.  The kernel doesn't really need to prevent
> all these background maintenance operations -- it just needs to block
> .page_mkwrite until they are synced.  I think that whatever new
> mechanism we add for this should be sticky, but I see no reason why
> the filesystem should have to block reflink on a DAX file entirely.

Agreed - IFF we want to support write through semantics this is the
only somewhat feasible way.  It still has massive downsides of forcing
the full sync machinery to run from the page fauly handler, which
I'm rather scared off, but that's still better than creating a magic
special case that isn't managable at all.

> If, instead, we had a nice unprivileged per-vma or per-fd mechanism to
> tell the filesystem that I want DAX durability, I could just use it
> without any fuss.  If it worked on ext4 before it worked on xfs, then
> I'd use ext4.  If it ended up being heavier weight on XFS than it was
> on ext4 because XFS needed to lock down the extent map for the inode
> whereas ext4 could manage it through .page_mkwrite(), then I'd
> benchmark it and see which fs would win.  (For my particular use case,
> I doubt it would matter, since I aggressively offload fs metadata
> operations to a thread whose performance I don't really care about.)

ext4 and XFS have the same fundamental issue:  both have a file system
wide log of modified data that needs to be flushed to stable storage
to ensure everything is safe.  So if you solve the issue for one of
them you've solved it for the other one as well modulo implementation
details.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
