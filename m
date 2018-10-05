Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3796211158DA
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 18:58:05 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id c18-v6so11234626otm.3
 for <linux-nvdimm@lists.01.org>; Thu, 04 Oct 2018 18:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20180927112332.3649-1-jack@suse.cz>
 <20180927132843.GA19006@bombadil.infradead.org>
 <20180927134129.GB8800@quack2.suse.cz>
 <CAPcyv4hut3P5fiNHgjpf4Qg_nBo9JKkovCdrUnzXyji=ey8zJw@mail.gmail.com>
 <20181004162748.GI28384@quack2.suse.cz>
In-Reply-To: <20181004162748.GI28384@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Oct 2018 18:57:52 -0700
Message-ID: <CAPcyv4gf5MSaBnzFFrk4XG4OEJFTOqWshk-F==3=4GGMnwNtQw@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix deadlock in dax_lock_mapping_entry()
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Barret Rhoden <brho@google.com>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 4, 2018 at 9:27 AM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 27-09-18 11:22:22, Dan Williams wrote:
> > On Thu, Sep 27, 2018 at 6:41 AM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Thu 27-09-18 06:28:43, Matthew Wilcox wrote:
> > > > On Thu, Sep 27, 2018 at 01:23:32PM +0200, Jan Kara wrote:
> > > > > When dax_lock_mapping_entry() has to sleep to obtain entry lock, it will
> > > > > fail to unlock mapping->i_pages spinlock and thus immediately deadlock
> > > > > against itself when retrying to grab the entry lock again. Fix the
> > > > > problem by unlocking mapping->i_pages before retrying.
> > > >
> > > > It seems weird that xfstests doesn't provoke this ...
> > >
> > > The function currently gets called only from mm/memory-failure.c. And yes,
> > > we are lacking DAX hwpoison error tests in fstests...
> >
> > I have an item on my backlog to port the ndctl unit test that does
> > memory_failure() injection vs ext4 over to fstests. That said I've
> > been investigating a deadlock on ext4 caused by this test. When I saw
> > this patch I hoped it was root cause, but the test is still failing
> > for me. Vishal is able to pass the test on his system, so the failure
> > mode is timing dependent. I'm running this patch on top of -rc5 and
> > still seeing the following deadlock.
>
> I went through the code but I don't see where the problem could be. How can
> I run that test? Is KVM enough or do I need hardware with AEP dimms?

KVM is enough... however, I have found a hack that makes the test pass:

diff --git a/mm/filemap.c b/mm/filemap.c
index 52517f28e6f4..d7f035b1846e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1668,6 +1668,9 @@ unsigned find_get_entries(struct address_space *mapping,
                        goto repeat;
                }
 export:
+               if (iter.index < start)
+                       continue;
+
                indices[ret] = iter.index;
                entries[ret] = page;
                if (++ret == nr_entries)

Is this a radix bug? I would never expect:

    radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start)

...to return entries with an index < start. Without that change above
we loop forever because dax_layout_busy_page() can't make forward
progress. I'll dig into the radix code tomorrow, but maybe someone
else will be me to it overnight.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
