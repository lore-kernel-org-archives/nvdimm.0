Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 108A621131DB1
 for <linux-nvdimm@lists.01.org>; Sat,  6 Oct 2018 23:03:03 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e21-v6so16605419otk.10
 for <linux-nvdimm@lists.01.org>; Sat, 06 Oct 2018 23:03:03 -0700 (PDT)
MIME-Version: 1.0
References: <153884891237.3128209.14619968108312095820.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153884891237.3128209.14619968108312095820.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 6 Oct 2018 23:02:50 -0700
Message-ID: <CAPcyv4hcF-tbv4OBZ4NAs00PmRAH6mE3nzSpe5=AwNORyHnLWw@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Fix dax_layout_busy_page() livelock
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
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, stable <stable@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Oct 6, 2018 at 11:14 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> In the presence of multi-order entries the typical
> pagevec_lookup_entries() pattern may loop forever:
>
>         while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
>                                 min(end - index, (pgoff_t)PAGEVEC_SIZE),
>                                 indices)) {
>                 ...
>                 for (i = 0; i < pagevec_count(&pvec); i++) {
>                         index = indices[i];
>                         ...
>                 }
>                 index++; /* BUG */
>         }
>
> The loop updates 'index' for each index found and then increments to the
> next possible page to continue the lookup. However, if the last entry in
> the pagevec is multi-order then the next possible page index is more
> than 1 page away. Fix this locally for the filesystem-dax case by
> checking for dax-multi-order entries. Going forward new users of
> multi-order entries need to be similarly careful, or we need a generic
> way to report the page increment in the radix iterator.
>
> Fixes: 5fac7408d828 ("mm, fs, dax: handle layout changes to pinned dax...")
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/dax.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 4becbf168b7f..c1472eede1f7 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -666,6 +666,8 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
>         while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
>                                 min(end - index, (pgoff_t)PAGEVEC_SIZE),
>                                 indices)) {
> +               pgoff_t nr_pages = 1;
> +
>                 for (i = 0; i < pagevec_count(&pvec); i++) {
>                         struct page *pvec_ent = pvec.pages[i];
>                         void *entry;
> @@ -680,8 +682,11 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
>
>                         xa_lock_irq(&mapping->i_pages);
>                         entry = get_unlocked_mapping_entry(mapping, index, NULL);
> -                       if (entry)
> +                       if (entry) {
>                                 page = dax_busy_page(entry);
> +                               /* account for multi-order entries */
> +                               nr_pages = 1UL << dax_radix_order(entry);
> +                       }

Thinking about this a bit further the next index will be at least
nr_pages away, but we don't want to accidentally skip over entries as
this patch might do. So nr_pages should only be adjusted by the entry
size if it is the last entry.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
