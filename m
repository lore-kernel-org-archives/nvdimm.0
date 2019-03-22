Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 92E4D211E82F7
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 09:33:40 -0700 (PDT)
Date: Fri, 22 Mar 2019 10:34:41 -0600
From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 3/5] mm: Attempt to migrate page in lieu of discard
Message-ID: <20190322163440.GB31194@localhost.localdomain>
References: <20190321200157.29678-1-keith.busch@intel.com>
 <20190321200157.29678-4-keith.busch@intel.com>
 <CAHbLzkqGGJ7dFiZkR-=yvGEF0AM4JbBe6pxGFbSe9tSnC7wgzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHbLzkqGGJ7dFiZkR-=yvGEF0AM4JbBe6pxGFbSe9tSnC7wgzQ@mail.gmail.com>
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
To: Yang Shi <shy828301@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-nvdimm@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 04:58:16PM -0700, Yang Shi wrote:
> On Thu, Mar 21, 2019 at 1:03 PM Keith Busch <keith.busch@intel.com> wrote:
> > +               if (!PageCompound(page)) {
> > +                       if (migrate_demote_mapping(page)) {
> > +                                unlock_page(page);
> > +                                if (likely(put_page_testzero(page)))
> > +                                        goto free_it;
> > +
> > +                                /*
> > +                                * Speculative reference will free this page,
> > +                                * so leave it off the LRU.
> > +                                */
> > +                                nr_reclaimed++;
> > +                                continue;
> > +                        }
> > +               }
> 
> It looks the reclaim path would fall through if the migration is
> failed. But, it looks, with patch #4, you may end up trying reclaim an
> anon page on swapless system if migration is failed?

Right, and add_to_swap() will fail and the page jumps to activate_locked
label, placing it back where it was before.

> And, actually I have the same question with Yan Zi. Why not just put
> the demote candidate into a separate list, then migrate all the
> candidates in bulk with migrate_pages()?

The page is already locked at the point we know we want to migrate it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
