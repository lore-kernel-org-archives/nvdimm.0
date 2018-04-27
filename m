Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x22f.google.com (mail-pf0-x22f.google.com
 [IPv6:2607:f8b0:400e:c00::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BEB121EBD1DF
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 11:33:30 -0700 (PDT)
Received: by mail-pf0-x22f.google.com with SMTP id a14so2077747pfi.1
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 11:33:30 -0700 (PDT)
Date: Fri, 27 Apr 2018 11:33:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] dax: Change return type to vm_fault_t
In-Reply-To: <20180427121136.GB8161@bombadil.infradead.org>
Message-ID: <alpine.DEB.2.21.1804271131180.152082@chino.kir.corp.google.com>
References: <20180417132842.GA30189@jordon-HP-15-Notebook-PC>
 <CAFqt6zY9E=XSiP5Q4N6Dh+oeVRkRf+wCBJx3XcD4MDJ=NdYG4g@mail.gmail.com>
 <alpine.DEB.2.21.1804270135100.68707@chino.kir.corp.google.com>
 <20180427121136.GB8161@bombadil.infradead.org>
MIME-Version: 1.0
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Randy Dunlap <rdunlap@infradead.org>, Souptick Joarder <jrdr.linux@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 27 Apr 2018, Matthew Wilcox wrote:

> > > Hi Matthew/ Ross,
> > > 
> > > There are two changes exist in mm/huge_memory.c as part of this
> > > patch. vmf_insert_pfn_pmd() and vmf_insert_pfn_pud() functions are
> > > invoked from this patch.
> > > 
> > > Shall we put both in a single patch that it will easy to bisect in case
> > > we have any issue ?
> > > 
> > 
> > Please put them into a single patch, there's no reason to convert
> > 
> > int foo() -> vm_fault_t foo()
> > 
> > but leave
> > 
> > int bar()
> > {
> > 	return foo()
> > }
> > 
> > It would be best just to convert all callers to also return vm_fault_t as 
> > I outlined in my response.
> 
> Yes, they're all getting converted, but there are too many to do in a
> single patch.  So it's just a matter of how to split them up.  Since the
> types are compatible (for now), I advised Souptick to split them by
> maintenance area in order to minimise conflicts with other patches.
> 

All I'm saying is that it is 1000 times easier to review and audit if foo 
and bar are converted in the same patch above instead of getting feedback 
saying "oh, you converted foo() but not bar()" or vice versa and then 
referring to another patch posted on some other mailing list as was done 
here.  How big the patch isn't very important if it's more reviewable.  
And converting foo() here and not bar() does nothing but make it harder to 
review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
