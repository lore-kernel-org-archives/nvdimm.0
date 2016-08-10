Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 7BFEF1A1E2B
 for <linux-nvdimm@lists.01.org>; Wed, 10 Aug 2016 07:52:07 -0700 (PDT)
Date: Wed, 10 Aug 2016 08:52:06 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/3] radix-tree: 'slot' can be NULL in
 radix_tree_next_slot()
Message-ID: <20160810145206.GA17734@linux.intel.com>
References: <20160808185747.21028-1-ross.zwisler@linux.intel.com>
 <CALYGNiMUsThwy3q_kdon3oszg8vpqaenWxx=h=ubcT9B_ZAbhw@mail.gmail.com>
 <20160809152707.GA14291@linux.intel.com>
 <CALYGNiNwTXY2qQtx2nU9LjTiEYWwoHR63SnrkwUJpwgOLJPKSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALYGNiNwTXY2qQtx2nU9LjTiEYWwoHR63SnrkwUJpwgOLJPKSQ@mail.gmail.com>
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
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-nvdimm@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 10, 2016 at 09:29:23AM +0300, Konstantin Khlebnikov wrote:
> On Tue, Aug 9, 2016 at 6:27 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Mon, Aug 08, 2016 at 10:21:39PM +0300, Konstantin Khlebnikov wrote:
> > <>
> >> NAK. This is fast path and it's already bloated.
> >> I want to revert most changes here and rework "multiorder" entries.
> >>
> >> Here you can find almost ready patchset for that
> >> https://github.com/koct9i/linux/commits/radix-tree
> >
> > Okay...are you okay with the second 2 patches in the series?  They stand
> > alone, and I believe are both good to have.
> 
> They looks good.

Cool, can I interpret that as an Acked-by for my v2? :)

> If you're worried about complicated paths - I'll add comment for
> *_next_slot() about that.

Yea, if we can document the exact ways in which we're protected from not
dereferencing a NULL 'slot', that would be great.  I think it essentially
boils down to:

1) For tagged iteration, if 'slot' is NULL then iter->tags must be cleared
2) For non-tagged iteration, it 'slot' is NULL then
   radix_tree_chunk_size(iter) must return 1 or less.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
