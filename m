Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAB302034C5C8
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 12:16:26 -0800 (PST)
Received: by mail-oi0-x242.google.com with SMTP id 184so34004699oii.2
 for <linux-nvdimm@lists.01.org>; Tue, 02 Jan 2018 12:21:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171227052910.GE24828@bombadil.infradead.org>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171227052910.GE24828@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jan 2018 12:21:28 -0800
Message-ID: <CAPcyv4ibKYi_zE=V2W_aLghtr3LiC30A2ffFq-aPQCrikwgy2w@mail.gmail.com>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 26, 2017 at 9:29 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Sat, Dec 23, 2017 at 04:56:59PM -0800, Dan Williams wrote:
>> +int dax_set_page_dirty(struct page *page)
>> +{
>> +     /*
>> +      * Unlike __set_page_dirty_no_writeback, dax does all dirty
>> +      * tracking in the radix in response to mkwrite faults.
>
> Please stop saying "in the radix".  I think you mean "in the page cache".

Ok, I'll be more precise and mention the PAGECACHE_TAG_DIRTY vs
PageDirty distinction.

>
>> +EXPORT_SYMBOL(dax_set_page_dirty);
>> +EXPORT_SYMBOL(dax_direct_IO);
>> +EXPORT_SYMBOL(dax_writepage);
>> +EXPORT_SYMBOL(dax_readpage);
>> +EXPORT_SYMBOL(dax_readpages);
>> +EXPORT_SYMBOL(dax_write_begin);
>> +EXPORT_SYMBOL(dax_write_end);
>> +EXPORT_SYMBOL(dax_invalidatepage);
>
> Exporting all these symbols to modules isn't exactly free.  Are you sure it
> doesn't make more sense to put tests for dax in the existing aops?
>

I'd rather have just one global fs_dax_aops instance that all
filesystems could reference, but ->writepages() is fundamentally an
address_space_operation. Until we can rework that I'd prefer the
overhead of the extra exports than sprinkling more IS_DAX checks
around.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
