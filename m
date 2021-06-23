Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7075F70
	for <nvdimm@lists.linux.dev>; Wed, 23 Jun 2021 08:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=16jxg++O1mxsCUO4HYCxFH729seFeNe19fGHRxVgw+U=; b=WgK4pEnmYC2eHSWXSChThGWZOf
	9/dHHL8laLKzptMdLlg2Al9t/6lEkpK9mZUWZe5mzsNzps7qvmpi2W55rjQaqketvLPrObTfNixZQ
	e12amrEyMBk3lGBHrvJqAA+0Mivp0njGzfzavq2Sjmo3arVv0sWsy9qBHv1o5JWuaPbkn/9Z1RyM2
	WBe0IAkpdFDszyQ5PrDpIWLNqQfJQWZofZ+askRlLZoYWhLgA04+jlWodfr1oRrLHfzpcSDf35pGT
	vYw3PGmSXzFoN9ULz+o3Ux8k+JaOFqVJtJqSup0qw1CITNbfLdozAcerP/OnJFN9u6Bko0Lxmf4Uf
	qFsBHEeQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1lvyHs-00FDIM-Kd; Wed, 23 Jun 2021 08:31:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 81023300204;
	Wed, 23 Jun 2021 10:31:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8C1D020412F7D; Wed, 23 Jun 2021 10:31:03 +0200 (CEST)
Date: Wed, 23 Jun 2021 10:31:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kajoljain <kjain@linux.ibm.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	maddy@linux.vnet.ibm.com, santosh@fossix.org,
	aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
	rnsastry@linux.ibm.com
Subject: Re: [PATCH v3 0/4] Add perf interface to expose nvdimm
Message-ID: <YNLxRz1w9IeatIKW@hirez.programming.kicks-ass.net>
References: <20210617132617.99529-1-kjain@linux.ibm.com>
 <YNHiRO11E9yYS6mv@hirez.programming.kicks-ass.net>
 <cea827fe-62d4-95fe-b81f-5c7bebe4a6f0@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cea827fe-62d4-95fe-b81f-5c7bebe4a6f0@linux.ibm.com>

On Wed, Jun 23, 2021 at 01:40:38PM +0530, kajoljain wrote:
> 
> 
> On 6/22/21 6:44 PM, Peter Zijlstra wrote:
> > On Thu, Jun 17, 2021 at 06:56:13PM +0530, Kajol Jain wrote:
> >> ---
> >> Kajol Jain (4):
> >>   drivers/nvdimm: Add nvdimm pmu structure
> >>   drivers/nvdimm: Add perf interface to expose nvdimm performance stats
> >>   powerpc/papr_scm: Add perf interface support
> >>   powerpc/papr_scm: Document papr_scm sysfs event format entries
> > 
> > Don't see anything obviously wrong with this one.
> > 
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > 
> 
> Hi Peter,
>     Thanks for reviewing the patch. Can you help me on how to take 
> these patches to linus tree or can you take it?

I would expect either the NVDIMM or PPC maintainers to take this. Dan,
Michael ?
