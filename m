Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 18 Apr 2017 14:35:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/9] mm/huge_memory: Use zap_deposited_table() more
In-Reply-To: <20170411174233.21902-2-oohall@gmail.com>
Message-ID: <alpine.DEB.2.10.1704181434520.112481@chino.kir.corp.google.com>
References: <20170411174233.21902-1-oohall@gmail.com> <20170411174233.21902-2-oohall@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: owner-linux-mm@kvack.org
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, linux-nvdimm@lists.01.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 12 Apr 2017, Oliver O'Halloran wrote:

> Depending flags of the PMD being zapped there may or may not be a
> deposited pgtable to be freed. In two of the three cases this is open
> coded while the third uses the zap_deposited_table() helper. This patch
> converts the others to use the helper to clean things up a bit.
> 
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: linux-mm@kvack.org
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
