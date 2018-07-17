Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4703621BADAB2
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 07:47:19 -0700 (PDT)
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
 by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6HEiKsI094339
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 14:47:18 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
 by aserp2130.oracle.com with ESMTP id 2k7a3t12c6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 14:47:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
 by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6HElGoC032360
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 14:47:16 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
 by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6HElGfF005483
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 14:47:16 GMT
Received: by mail-oi0-f41.google.com with SMTP id l10-v6so2532966oii.0
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 07:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAGM2rea9AwQGaf1JiV_SDDKTKyP_n+dG9Z20gtTZEkuZPFnXFQ@mail.gmail.com>
 <CAPcyv4jo91jKjwn-M7cOhG=6vJ3c-QCyp0W+T+CtmiKGyZP1ng@mail.gmail.com>
In-Reply-To: <CAPcyv4jo91jKjwn-M7cOhG=6vJ3c-QCyp0W+T+CtmiKGyZP1ng@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Date: Tue, 17 Jul 2018 10:46:39 -0400
Message-ID: <CAGM2reacO1HF91yH8OR5w5AdZwPgwfSFfjDNBsHbP66v1rEg=g@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] mm: Asynchronous + multithreaded memmap init for
 ZONE_DEVICE
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
To: dan.j.williams@intel.com
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, benh@kernel.crashing.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Memory Management List <linux-mm@kvack.org>, dalias@libc.org, paulus@samba.org, hpa@zytor.com, hch@lst.de, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-nvdimm@lists.01.org, x86@kernel.org, willy@infradead.org, Daniel Jordan <daniel.m.jordan@oracle.com>, mingo@redhat.com, fenghua.yu@intel.com, jglisse@redhat.com, tglx@linutronix.de, tony.luck@intel.com, LKML <linux-kernel@vger.kernel.org>, mpe@ellerman.id.au, schwidefsky@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

> > Hi Dan,
> >
> > I am worried that this work adds another way to multi-thread struct
> > page initialization without re-use of already existing method. The
> > code is already a mess, and leads to bugs [1] because of the number of
> > different memory layouts, architecture specific quirks, and different
> > struct page initialization methods.
>
> Yes, the lamentations about the complexity of the memory hotplug code
> are known. I didn't think this set made it irretrievably worse, but
> I'm biased and otherwise certainly want to build consensus with other
> mem-hotplug folks.
>
> >
> > So, when DEFERRED_STRUCT_PAGE_INIT is used we initialize struct pages
> > on demand until page_alloc_init_late() is called, and at that time we
> > initialize all the rest of struct pages by calling:
> >
> > page_alloc_init_late()
> >   deferred_init_memmap() (a thread per node)
> >     deferred_init_pages()
> >        __init_single_page()
> >
> > This is because memmap_init_zone() is not multi-threaded. However,
> > this work makes memmap_init_zone() multi-threaded. So, I think we
> > should really be either be using deferred_init_memmap() here, or teach
> > DEFERRED_STRUCT_PAGE_INIT to use new multi-threaded memmap_init_zone()
> > but not both.
>
> I agree it would be good to look at unifying the 2 async
> initialization approaches, however they have distinct constraints. All
> of the ZONE_DEVICE memmap initialization work happens as a hotplug
> event where the deferred_init_memmap() threads have already been torn
> down. For the memory capacities where it takes minutes to initialize
> the memmap it is painful to incur a global flush of all initialization
> work. So, I think that a move to rework deferred_init_memmap() in
> terms of memmap_init_async() is warranted because memmap_init_async()
> avoids a global sync and supports the hotplug case.
>
> Unfortunately, the work to unite these 2 mechanisms is going to be
> 4.20 material, at least for me, since I'm taking an extended leave,
> and there is little time for me to get this in shape for 4.19. I
> wouldn't be opposed to someone judiciously stealing from this set and
> taking a shot at the integration, I likely will not get back to this
> until September.

Hi Dan,

I do not want to hold your work, so if Michal or Andrew are OK with
the general approach of teaching    memmap_init_zone() to be async
without re-using deferred_init_memmap() or without changing
deferred_init_memmap() to use the new memmap_init_async() I will
review your patches.

Thank you,
Pavel

>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
