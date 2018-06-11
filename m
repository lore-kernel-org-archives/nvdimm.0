Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A303211C3713
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 16:35:23 -0700 (PDT)
Received: by mail-ot0-x244.google.com with SMTP id 92-v6so25895400otw.9
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 16:35:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180611145809.c05f215b9b2e7dab9e808304@linux-foundation.org>
References: <152669369110.34337.14271778212195820353.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152669370864.34337.13815113039455146564.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180611145809.c05f215b9b2e7dab9e808304@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Jun 2018 16:35:22 -0700
Message-ID: <CAPcyv4gziGh7Xih_W2-5nxpHRLnUwi1nDtwsC7bbQousuibsQg@mail.gmail.com>
Subject: Re: [PATCH v11 3/7] mm: fix __gup_device_huge vs unmap
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 11, 2018 at 2:58 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 18 May 2018 18:35:08 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
>
>> get_user_pages_fast() for device pages is missing the typical validation
>> that all page references have been taken while the mapping was valid.
>> Without this validation truncate operations can not reliably coordinate
>> against new page reference events like O_DIRECT.
>>
>> Cc: <stable@vger.kernel.org>
>
> I'm not seeing anything in the changelog which justifies a -stable
> backport.  ie: a description of the end-user-visible effects of the
> bug?
>

Without this change get_user_pages_fast() could race truncate. The
ordering of page_cache_add_speculative() before re-validating the
mapping allows truncate and page freeing to synchronize against
get_user_pages_fast().

Specifically, a get_user_pages_fast() thread could continue allowing a
page to be mapped and accessed via the kernel mapping after it was
meant to be torn down. This could cause unexpected data corruption or
access to the physical page after it has been invalidated from process
page tables.

Ideally I think we would go further than this patch and backport the
full fix for the filesystem-dax-vs-truncate problem. I was planning to
spin up a 4.14 backport with the full set of the pieces that went into
4.17 and 4.18.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
