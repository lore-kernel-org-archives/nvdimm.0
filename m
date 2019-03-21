Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190321200157.29678-1-keith.busch@intel.com> <20190321200157.29678-4-keith.busch@intel.com>
In-Reply-To: <20190321200157.29678-4-keith.busch@intel.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 21 Mar 2019 16:58:16 -0700
Message-ID: <CAHbLzkqGGJ7dFiZkR-=yvGEF0AM4JbBe6pxGFbSe9tSnC7wgzQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] mm: Attempt to migrate page in lieu of discard
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 1:03 PM Keith Busch <keith.busch@intel.com> wrote:
>
> If a memory node has a preferred migration path to demote cold pages,
> attempt to move those inactive pages to that migration node before
> reclaiming. This will better utilize available memory, provide a faster
> tier than swapping or discarding, and allow such pages to be reused
> immediately without IO to retrieve the data.
>
> Some places we would like to see this used:
>
>  1. Persistent memory being as a slower, cheaper DRAM replacement
>  2. Remote memory-only "expansion" NUMA nodes
>  3. Resolving memory imbalances where one NUMA node is seeing more
>     allocation activity than another.  This helps keep more recent
>     allocations closer to the CPUs on the node doing the allocating.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  include/linux/migrate.h        |  6 ++++++
>  include/trace/events/migrate.h |  3 ++-
>  mm/debug.c                     |  1 +
>  mm/migrate.c                   | 45 ++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                    | 15 ++++++++++++++
>  5 files changed, 69 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index e13d9bf2f9a5..a004cb1b2dbb 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -25,6 +25,7 @@ enum migrate_reason {
>         MR_MEMPOLICY_MBIND,
>         MR_NUMA_MISPLACED,
>         MR_CONTIG_RANGE,
> +       MR_DEMOTION,
>         MR_TYPES
>  };
>
> @@ -79,6 +80,7 @@ extern int migrate_huge_page_move_mapping(struct address_space *mapping,
>  extern int migrate_page_move_mapping(struct address_space *mapping,
>                 struct page *newpage, struct page *page, enum migrate_mode mode,
>                 int extra_count);
> +extern bool migrate_demote_mapping(struct page *page);
>  #else
>
>  static inline void putback_movable_pages(struct list_head *l) {}
> @@ -105,6 +107,10 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
>         return -ENOSYS;
>  }
>
> +static inline bool migrate_demote_mapping(struct page *page)
> +{
> +       return false;
> +}
>  #endif /* CONFIG_MIGRATION */
>
>  #ifdef CONFIG_COMPACTION
> diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
> index 705b33d1e395..d25de0cc8714 100644
> --- a/include/trace/events/migrate.h
> +++ b/include/trace/events/migrate.h
> @@ -20,7 +20,8 @@
>         EM( MR_SYSCALL,         "syscall_or_cpuset")            \
>         EM( MR_MEMPOLICY_MBIND, "mempolicy_mbind")              \
>         EM( MR_NUMA_MISPLACED,  "numa_misplaced")               \
> -       EMe(MR_CONTIG_RANGE,    "contig_range")
> +       EM(MR_CONTIG_RANGE,     "contig_range")                 \
> +       EMe(MR_DEMOTION,        "demotion")
>
>  /*
>   * First define the enums in the above macros to be exported to userspace
> diff --git a/mm/debug.c b/mm/debug.c
> index c0b31b6c3877..53d499f65199 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -25,6 +25,7 @@ const char *migrate_reason_names[MR_TYPES] = {
>         "mempolicy_mbind",
>         "numa_misplaced",
>         "cma",
> +       "demotion",
>  };
>
>  const struct trace_print_flags pageflag_names[] = {
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 705b320d4b35..83fad87361bf 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1152,6 +1152,51 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
>         return rc;
>  }
>
> +/**
> + * migrate_demote_mapping() - Migrate this page and its mappings to its
> + *                           demotion node.
> + * @page: An isolated, non-compound page that should move to
> + *       its current node's migration path.
> + *
> + * @returns: True if migrate demotion was successful, false otherwise
> + */
> +bool migrate_demote_mapping(struct page *page)
> +{
> +       int rc, next_nid = next_migration_node(page_to_nid(page));
> +       struct page *newpage;
> +
> +       /*
> +        * The flags are set to allocate only on the desired node in the
> +        * migration path, and to fail fast if not immediately available. We
> +        * are already in the memory reclaim path, we don't want heroic
> +        * efforts to get a page.
> +        */
> +       gfp_t mask = GFP_NOWAIT | __GFP_NOWARN | __GFP_NORETRY |
> +                    __GFP_NOMEMALLOC | __GFP_THISNODE;
> +
> +       VM_BUG_ON_PAGE(PageCompound(page), page);
> +       VM_BUG_ON_PAGE(PageLRU(page), page);
> +
> +       if (next_nid < 0)
> +               return false;
> +
> +       newpage = alloc_pages_node(next_nid, mask, 0);
> +       if (!newpage)
> +               return false;
> +
> +       /*
> +        * MIGRATE_ASYNC is the most light weight and never blocks.
> +        */
> +       rc = __unmap_and_move_locked(page, newpage, MIGRATE_ASYNC);
> +       if (rc != MIGRATEPAGE_SUCCESS) {
> +               __free_pages(newpage, 0);
> +               return false;
> +       }
> +
> +       set_page_owner_migrate_reason(newpage, MR_DEMOTION);
> +       return true;
> +}
> +
>  /*
>   * gcc 4.7 and 4.8 on arm get an ICEs when inlining unmap_and_move().  Work
>   * around it.
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a5ad0b35ab8e..0a95804e946a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1261,6 +1261,21 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>                         ; /* try to reclaim the page below */
>                 }
>
> +               if (!PageCompound(page)) {
> +                       if (migrate_demote_mapping(page)) {
> +                                unlock_page(page);
> +                                if (likely(put_page_testzero(page)))
> +                                        goto free_it;
> +
> +                                /*
> +                                * Speculative reference will free this page,
> +                                * so leave it off the LRU.
> +                                */
> +                                nr_reclaimed++;
> +                                continue;
> +                        }
> +               }

It looks the reclaim path would fall through if the migration is
failed. But, it looks, with patch #4, you may end up trying reclaim an
anon page on swapless system if migration is failed?

And, actually I have the same question with Yan Zi. Why not just put
the demote candidate into a separate list, then migrate all the
candidates in bulk with migrate_pages()?

Thanks,
Yang

> +
>                 /*
>                  * Anonymous process memory has backing store?
>                  * Try to allocate it some swap space here.
> --
> 2.14.4
>
