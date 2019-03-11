Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B06E5211CCD56
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 12:06:35 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id b3so200139otp.4
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 12:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190301191241.27842-1-willy@infradead.org>
 <20190311090557.GB11553@quack2.suse.cz>
In-Reply-To: <20190311090557.GB11553@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Mar 2019 12:06:24 -0700
Message-ID: <CAPcyv4gUkZNkRftWwO15kj+6jd1nqB0D+LzM=0dk38xnhdA-zg@mail.gmail.com>
Subject: Re: [PATCH] dax: Flush partial PMDs correctly
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Piotr Balcer <piotr.balcer@intel.com>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 11, 2019 at 2:06 AM Jan Kara <jack@suse.cz> wrote:
>
> On Fri 01-03-19 11:12:41, Matthew Wilcox wrote:
> > The radix tree would rewind the index in an iterator to the lowest index
> > of a multi-slot entry.  The XArray iterators instead leave the index
> > unchanged, but I overlooked that when converting DAX from the radix tree
> > to the XArray.  Adjust the index that we use for flushing to the start
> > of the PMD range.
> >
> > Fixes: c1901cd33cf4 "page cache: Convert find_get_entries_tag to XArray"
> > Reported-by: Piotr Balcer <piotr.balcer@intel.com>
> > Tested-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Matthew Wilcox <willy@infradead.org>
> > ---
> ...
> > @@ -917,8 +917,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
> >       xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
> >       dax_wake_entry(xas, entry, false);
> >
> > -     trace_dax_writeback_one(mapping->host, xas->xa_index,
> > -                     size >> PAGE_SHIFT);
> > +     trace_dax_writeback_one(mapping->host, xas->xa_index, count);
>
> I think here should be 'index' as well, shouldn't it? Otherwise the tracing
> data will be somewhat misleading... Besides this the patch looks good to me
> now so feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>

I agree on the 'index' change, I'll fix that up.

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
