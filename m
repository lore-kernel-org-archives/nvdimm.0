Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7601321BBC42F
 for <linux-nvdimm@lists.01.org>; Wed, 21 Jun 2017 21:06:54 -0700 (PDT)
Received: from mail-ua0-f175.google.com (mail-ua0-f175.google.com
 [209.85.217.175])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CAFC222B62
 for <linux-nvdimm@lists.01.org>; Thu, 22 Jun 2017 04:08:18 +0000 (UTC)
Received: by mail-ua0-f175.google.com with SMTP id 70so4715960uau.0
 for <linux-nvdimm@lists.01.org>; Wed, 21 Jun 2017 21:08:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170622000235.GN17542@dastard>
References: <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
 <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
 <20170619132107.GG11993@dastard>
 <CALCETrUe0igzK0RZTSSondkCY3ApYQti89tOh00f0j_APrf_dQ@mail.gmail.com>
 <20170620004653.GI17542@dastard>
 <CALCETrVuoPDRuuhc9X8eVCYiFUzWLSTRkcjbD6jas_2J2GixNQ@mail.gmail.com>
 <20170620101145.GJ17542@dastard>
 <CALCETrVCJkm5SCxAtNMW36eONHsFw1s0dkVnDAs4vAXvEKMsPw@mail.gmail.com>
 <20170621014032.GL17542@dastard>
 <CALCETrVYmbyNS-btvsN_M-QyWPZA_Y_4JXOM893g7nhZA+WviQ@mail.gmail.com>
 <20170622000235.GN17542@dastard>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 21 Jun 2017 21:07:57 -0700
Message-ID: <CALCETrX0n0-JxJbisrVnM6QME3uToW_x26xN3Z-t0-1yDvWn4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 21, 2017 at 5:02 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> You seem to be calling the "fdatasync on every page fault" the

It's the opposite of fdatasync().  It needs to sync whatever metadata
is needed to find the data.  The data doesn't need to be synced.

> "lightweight" option. That's the brute-force-with-big-hammer
> solution - it's most definitely not lightweight as every page fault
> has extra overhead to call ->fsync(). Sure, the API is simple, but
> the runtime overhead is significant.

It's lightweight in terms of its impact on the filesystem.  It doesn't
need any persistent setup -- you can just use it.

> Even if you are considering the complexity of the APIs, it's hardly
> a "heavyweight" when it only requires a single call to fallocate()
> before mmap() to set up the immutable extents on the file...

So what would the exact semantics be?  In particular, how can it fail?
 If I do the fallocate(), is it absolutely promised that the extent
map won't get out of sync between what mmap sees and what's on disk?
Do user programs need to worry about colliding with each other when
one does fallocate() to DAXify a file and the other does fallocate()
to unDAXify a file?  Does this particular fallocate() call still keep
its effect after a reboot?

These issues are why I think it would be nicer to have an API that
makes a particular mapping or fd be unconditionally *correct* and then
to provide something else that makes it avoid latency spikes.

Is there an actual concrete proposal that's reviewable?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
