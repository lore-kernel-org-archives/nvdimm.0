Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7C6B211E745D
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 07:40:20 -0700 (PDT)
Date: Fri, 22 Mar 2019 08:41:21 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 0/5] Page demotion for memory reclaim
Message-ID: <20190322144120.GB29817@localhost.localdomain>
References: <20190321200157.29678-1-keith.busch@intel.com>
 <5B5EFBC2-2979-4B9F-A43A-1A14F16ACCE1@nvidia.com>
 <20190321223706.GA29817@localhost.localdomain>
 <F33CDC43-745B-4555-B8E0-D50D8024C727@nvidia.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F33CDC43-745B-4555-B8E0-D50D8024C727@nvidia.com>
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
To: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@intel.com>, David Nellans <dnellans@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Kirill A. Shutemov" <kirill@shutemov.name>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 05:12:33PM -0700, Zi Yan wrote:
> > Yes, we may not want to migrate everything in the shrink_page_list()
> > pages. We might want to keep a page, so we have to do those checks first. At
> > the point we know we want to attempt migration, the page is already
> > locked and not in a list, so it is just easier to directly invoke the
> > new __unmap_and_move_locked() that migrate_pages() eventually also calls.
> 
> Right, I understand that you want to only migrate small pages to begin with. My question is
> why not using the existing migrate_pages() in your patch 3. Like:
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a5ad0b35ab8e..0a0753af357f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1261,6 +1261,20 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>                         ; /* try to reclaim the page below */
>                 }
> 
> +               if (!PageCompound(page)) {
> +                       int next_nid = next_migration_node(page);
> +                       int err;
> +
> +                       if (next_nid != TERMINAL_NODE) {
> +                               LIST_HEAD(migrate_list);
> +                               list_add(&migrate_list, &page->lru);
> +                               err = migrate_pages(&migrate_list, alloc_new_node_page, NULL,
> +                                       next_nid, MIGRATE_ASYNC, MR_DEMOTION);
> +                               if (err)
> +                                       putback_movable_pages(&migrate_list);
> +                       }
> +               }
> +
>                 /*
>                  * Anonymous process memory has backing store?
>                  * Try to allocate it some swap space here.
> 
> Because your new migrate_demote_mapping() basically does the same thing as the code above.
> If you are not OK with the gfp flags in alloc_new_node_page(), you can just write your own
> alloc_new_node_page(). :)

The page is already locked, you can't call migrate_pages()
with locked pages. You'd have to surround migrate_pages with
unlock_page/try_lock_page, and I thought that looked odd. Further,
it changes the flow if the subsequent try lock fails, and I'm trying to
be careful about not introducing different behavior if migration fails.

Patch 2/5 is included here so we can reuse the necessary code from a
locked page context.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
