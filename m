Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0152F80
	for <nvdimm@lists.linux.dev>; Tue,  8 Jun 2021 17:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gtYgNf1MMJu3408XeDLJzRxVXgNres0dscNvmSwjebA=; b=E/68k0xfCirgm0okM86kOWTy5n
	koZf2UVhOUTgD0SnkOnbhncTMRa5FWzW9XLyVfCjB1bDN+Qeh+cmLZM8zYPFbrHjh+E+1W+bjQ7ht
	QunrXmYGUyepZs0Z0U20eZOcUUeVOKQ0td6bp5ivBwX0VTU3yL+unMZv8TN9KvAQ+AlRATI03isY2
	k+JH0MFpFSgr29GMAaflEY2T5fIbO2K8fKp/+ghOm7STw2xdHavvmTBI4If7AF6zswD1zSKO8Up4w
	jef4ADh3v2xi/lmGByM99g0PSsDm3m0JUAhlqGvkVaX53aQY574hCWX5AUVTRdwM9sQUQsmroJsZ8
	mD8D4RtA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1lqfeb-00HDKO-Eo; Tue, 08 Jun 2021 17:36:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8139430018A;
	Tue,  8 Jun 2021 19:36:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 008B72D754400; Tue,  8 Jun 2021 19:36:36 +0200 (CEST)
Date: Tue, 8 Jun 2021 19:36:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kajol Jain <kjain@linux.ibm.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	maddy@linux.vnet.ibm.com, santosh@fossix.org,
	aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
	rnsastry@linux.ibm.com
Subject: Re: [PATCH 2/4] drivers/nvdimm: Add perf interface to expose nvdimm
 performance stats
Message-ID: <YL+qpL/+ReGfqXce@hirez.programming.kicks-ass.net>
References: <20210608115700.85933-1-kjain@linux.ibm.com>
 <20210608115700.85933-3-kjain@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608115700.85933-3-kjain@linux.ibm.com>

On Tue, Jun 08, 2021 at 05:26:58PM +0530, Kajol Jain wrote:
> +static int nvdimm_pmu_cpu_offline(unsigned int cpu, struct hlist_node *node)
> +{
> +	struct nvdimm_pmu *nd_pmu;
> +	u32 target;
> +	int nodeid;
> +	const struct cpumask *cpumask;
> +
> +	nd_pmu = hlist_entry_safe(node, struct nvdimm_pmu, node);
> +
> +	/* Clear it, incase given cpu is set in nd_pmu->arch_cpumask */
> +	cpumask_test_and_clear_cpu(cpu, &nd_pmu->arch_cpumask);
> +
> +	/*
> +	 * If given cpu is not same as current designated cpu for
> +	 * counter access, just return.
> +	 */
> +	if (cpu != nd_pmu->cpu)
> +		return 0;
> +
> +	/* Check for any active cpu in nd_pmu->arch_cpumask */
> +	target = cpumask_any(&nd_pmu->arch_cpumask);
> +	nd_pmu->cpu = target;
> +
> +	/*
> +	 * Incase we don't have any active cpu in nd_pmu->arch_cpumask,
> +	 * check in given cpu's numa node list.
> +	 */
> +	if (target >= nr_cpu_ids) {
> +		nodeid = cpu_to_node(cpu);
> +		cpumask = cpumask_of_node(nodeid);
> +		target = cpumask_any_but(cpumask, cpu);
> +		nd_pmu->cpu = target;
> +
> +		if (target >= nr_cpu_ids)
> +			return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nvdimm_pmu_cpu_online(unsigned int cpu, struct hlist_node *node)
> +{
> +	struct nvdimm_pmu *nd_pmu;
> +
> +	nd_pmu = hlist_entry_safe(node, struct nvdimm_pmu, node);
> +
> +	if (nd_pmu->cpu >= nr_cpu_ids)
> +		nd_pmu->cpu = cpu;
> +
> +	return 0;
> +}

> +static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
> +{
> +	int nodeid, rc;
> +	const struct cpumask *cpumask;
> +
> +	/*
> +	 * Incase cpu hotplug is not handled by arch specific code
> +	 * they can still provide required cpumask which can be used
> +	 * to get designatd cpu for counter access.
> +	 * Check for any active cpu in nd_pmu->arch_cpumask.
> +	 */
> +	if (!cpumask_empty(&nd_pmu->arch_cpumask)) {
> +		nd_pmu->cpu = cpumask_any(&nd_pmu->arch_cpumask);
> +	} else {
> +		/* pick active cpu from the cpumask of device numa node. */
> +		nodeid = dev_to_node(nd_pmu->dev);
> +		cpumask = cpumask_of_node(nodeid);
> +		nd_pmu->cpu = cpumask_any(cpumask);
> +	}
> +
> +	rc = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "perf/nvdimm:online",
> +				     nvdimm_pmu_cpu_online, nvdimm_pmu_cpu_offline);
> +

Did you actually test this hotplug stuff?

That is, create a counter, unplug the CPU the counter was on, and
continue counting? "perf stat -I" is a good option for this, concurrent
with a hotplug.

Because I don't think it's actually correct. The thing is perf core is
strictly per-cpu, and it will place the event on a specific CPU context.
If you then unplug that CPU, nothing will touch the events on that CPU
anymore.

What drivers that span CPUs need to do is call
perf_pmu_migrate_context() whenever the CPU they were assigned to goes
away. Please have a look at arch/x86/events/rapl.c or
arch/x86/events/amd/power.c for relatively simple drivers that have this
property.


