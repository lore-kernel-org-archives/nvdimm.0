Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EC671
	for <nvdimm@lists.linux.dev>; Tue, 22 Jun 2021 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=++Q8EHvNJOniOHh5A5dqNXrOe0ZjsvPzI3S1iuyJd0c=; b=Txzx9gND61hysapCm7XtbdbUZr
	2YsWt1vi+k79EDFOYgoGnzuf2OFMkaj4KdG5nOGfQFdIzyZoFIs2KPpFqdlwwkwiCBjkaT/qldytF
	e+cfhJ95GNrbWmsoCA1bbRT0QqHLryJKGRhlxXE5/OK1ynxTqAByddMjYUdGY9ONd1xPqpc6Ugx/F
	o8NusjwVdkXD7UVBLokBoyfKxOv+hdUIszHpBzT7q+Hytwuq2puSXFhB2LKv8JCH5vzRA1m1+lT3P
	xe2+cqruOSRZ/fKM3F5xUI6rIQ8pYgJ3vxMLfgBbE64jUwvzZw4KjPAaV+Zd3BrGCOHtoKv6WFKJl
	A63KkXoA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1lvgEj-00AbaW-GN; Tue, 22 Jun 2021 13:14:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8B4FF30021A;
	Tue, 22 Jun 2021 15:14:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4595720C169E1; Tue, 22 Jun 2021 15:14:44 +0200 (CEST)
Date: Tue, 22 Jun 2021 15:14:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kajol Jain <kjain@linux.ibm.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	maddy@linux.vnet.ibm.com, santosh@fossix.org,
	aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
	rnsastry@linux.ibm.com
Subject: Re: [PATCH v3 0/4] Add perf interface to expose nvdimm
Message-ID: <YNHiRO11E9yYS6mv@hirez.programming.kicks-ass.net>
References: <20210617132617.99529-1-kjain@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617132617.99529-1-kjain@linux.ibm.com>

On Thu, Jun 17, 2021 at 06:56:13PM +0530, Kajol Jain wrote:
> ---
> Kajol Jain (4):
>   drivers/nvdimm: Add nvdimm pmu structure
>   drivers/nvdimm: Add perf interface to expose nvdimm performance stats
>   powerpc/papr_scm: Add perf interface support
>   powerpc/papr_scm: Document papr_scm sysfs event format entries

Don't see anything obviously wrong with this one.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
