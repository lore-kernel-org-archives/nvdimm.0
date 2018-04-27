Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E6F4203B8C80
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 05:11:38 -0700 (PDT)
Date: Fri, 27 Apr 2018 05:11:36 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3] dax: Change return type to vm_fault_t
Message-ID: <20180427121136.GB8161@bombadil.infradead.org>
References: <20180417132842.GA30189@jordon-HP-15-Notebook-PC>
 <CAFqt6zY9E=XSiP5Q4N6Dh+oeVRkRf+wCBJx3XcD4MDJ=NdYG4g@mail.gmail.com>
 <alpine.DEB.2.21.1804270135100.68707@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1804270135100.68707@chino.kir.corp.google.com>
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
To: David Rientjes <rientjes@google.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Randy Dunlap <rdunlap@infradead.org>, Souptick Joarder <jrdr.linux@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 27, 2018 at 01:37:02AM -0700, David Rientjes wrote:
> On Fri, 27 Apr 2018, Souptick Joarder wrote:
> 
> > Hi Matthew/ Ross,
> > 
> > There are two changes exist in mm/huge_memory.c as part of this
> > patch. vmf_insert_pfn_pmd() and vmf_insert_pfn_pud() functions are
> > invoked from this patch.
> > 
> > Shall we put both in a single patch that it will easy to bisect in case
> > we have any issue ?
> > 
> 
> Please put them into a single patch, there's no reason to convert
> 
> int foo() -> vm_fault_t foo()
> 
> but leave
> 
> int bar()
> {
> 	return foo()
> }
> 
> It would be best just to convert all callers to also return vm_fault_t as 
> I outlined in my response.

Yes, they're all getting converted, but there are too many to do in a
single patch.  So it's just a matter of how to split them up.  Since the
types are compatible (for now), I advised Souptick to split them by
maintenance area in order to minimise conflicts with other patches.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
