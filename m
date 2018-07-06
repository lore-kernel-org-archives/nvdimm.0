Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C8CD202E547B
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 14:32:27 -0700 (PDT)
Date: Fri, 6 Jul 2018 14:32:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/sparse.c: fix error path in sparse_add_one_section
Message-Id: <20180706143225.1cf9569f240dccf91bdc3788@linux-foundation.org>
In-Reply-To: <20180706190658.6873-1-ross.zwisler@linux.intel.com>
References: <CAOxpaSVkLh23jN_=0GpZ77EhKdAYaiWKkppnxWwf_MRa5FvopA@mail.gmail.com>
 <20180706190658.6873-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: osalvador@techadventures.net, bhe@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, pasha.tatashin@oracle.com, Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, osalvador@suse.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri,  6 Jul 2018 13:06:58 -0600 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> commit 054620849110 ("mm/sparse.c: make sparse_init_one_section void and
> remove check")
> 
> changed how the error handling in sparse_add_one_section() works.
> 
> Previously sparse_index_init() could return -EEXIST, and the function would
> continue on happily.  'ret' would get unconditionally overwritten by the
> result from sparse_init_one_section() and the error code after the 'out:'
> label wouldn't be triggered.
> 
> With the above referenced commit, though, an -EEXIST error return from
> sparse_index_init() now takes us through the function and into the error
> case after 'out:'.  This eventually causes a kernel BUG, probably because
> we've just freed a memory section that we successfully set up and marked as
> present:

Thanks.

And gee it would be nice if some of this code was commented.  I
*assume* what's happening with that -EEXIST is that
sparse_add_one_section() is discovering that the root mem_section was
already initialized so things are OK.  Maybe.  My mind-reading skills
aren't so good on Fridays.

And sparse_index_init() sure looks like it needs locking to avoid races
around mem_section[root].  Or perhaps we're known to be single-threaded
here.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
