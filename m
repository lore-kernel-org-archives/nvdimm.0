Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF2D421EA15A6
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 08:28:43 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id p1so6490895qtg.2
 for <linux-nvdimm@lists.01.org>; Mon, 09 Oct 2017 08:32:11 -0700 (PDT)
Received: from mail-qt0-f174.google.com (mail-qt0-f174.google.com.
 [209.85.216.174])
 by smtp.gmail.com with ESMTPSA id b37sm5149254qkb.19.2017.10.09.08.32.08
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 09 Oct 2017 08:32:08 -0700 (PDT)
Received: by mail-qt0-f174.google.com with SMTP id f8so8828807qta.5
 for <linux-nvdimm@lists.01.org>; Mon, 09 Oct 2017 08:32:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150174646416.104003.14042713459553361884.stgit@hn>
References: <150174646416.104003.14042713459553361884.stgit@hn>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 9 Oct 2017 17:32:07 +0200
Message-ID: <CAELBmZAs6iAMx_0wxTnC7qrbMiQDDVG3dUtAhjeOKJ6ig2k6tQ@mail.gmail.com>
Subject: Re: [RFC 00/16] NOVA: a new file system for persistent memory
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
To: Steven Swanson <swanson@eng.ucsd.edu>
Cc: Steven Swanson <steven.swanson@gmail.com>, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 3, 2017 at 9:48 AM, Steven Swanson <swanson@eng.ucsd.edu> wrote:
> This is an RFC patch series that impements NOVA (NOn-Volatile memory
> Accelerated file system), a new file system built for PMEM.

Hi,

Thanks for posting.

I read the paper and the design looks nice.  Then I  looked at the
patches, but could not find a place to start, nor something I could
actually try out.  So let me suggest some ways to make this more
reviewer/tester friendly:

1) try starting with something very simple yet working and supporting
the final layout
   - no optimizations (one big lock, no per-cpu data, rcu, numa, etc support)
   - no support for optional features (checksumming, NFS export, etc)
   - missing mandatory features (e.g. just readdir and getattr support)
   - try and get it down to <5k lines, preferably 2-3k

2) pointer to sources and instructions for trying it out without
special hardware

3) build on this minimal working version by
   - adding mandatory features
   - then adding optimizations

4) each patch should leave the tree in a compiling and working state
but should be small and easily reviewed

5) leave optional features and unimportant optimizations for a later
submission; try to make the patchset as small as you meaningfully can
(i.e. it should be fully working and demonstrate the capabilities and
performance, but nothing more).

Thanks,
Miklos
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
