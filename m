Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6794F72
	for <nvdimm@lists.linux.dev>; Wed,  9 Jun 2021 12:13:48 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159CD02A182388;
	Wed, 9 Jun 2021 08:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=z8XpUqcZQGSPat/U6GDdBwQhtEIQvqxbxlILMGrTvMI=;
 b=MfMPyGxbj0IHtWjfPjWb1jN2zYAvg/iHE+bB3eBMpZ1XjJ+5qPJj9/jyauaA+lRhe2Y7
 kNmwzVggf0poKs+VvhCRGbloL154aKhZjN328xl/3kC/JiRONfps9NtemNs6cpq89liS
 9mutiyi37GiNq+FaMXzl/MfLShAa9y7HpIx8lTomn/DSGXsL81R2f8ncPdsoL9PQA+Gq
 xErj8tYdn/pOcSN4z+/kqkduQJ9bHkWBF2/cbfE10YosmYszSM7obLEl2SYk5VvHnkbw
 oVgxKYJGn5e5kcgzLoEAjmj+IsuKSEiWBjiUEQmyi6jSjOjXQX6dMDVdBbM8mrQ7DMln qA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
	by mx0a-001b2d01.pphosted.com with ESMTP id 392qae341p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Jun 2021 08:13:10 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
	by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 159C3fY6010994;
	Wed, 9 Jun 2021 12:12:16 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by ppma04dal.us.ibm.com with ESMTP id 3900w9q3k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Jun 2021 12:12:16 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 159CCFKm36635032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Jun 2021 12:12:15 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B1EA2805A;
	Wed,  9 Jun 2021 12:12:15 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23E0D28058;
	Wed,  9 Jun 2021 12:12:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.47.213])
	by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
	Wed,  9 Jun 2021 12:12:10 +0000 (GMT)
Subject: Re: [PATCH 2/4] drivers/nvdimm: Add perf interface to expose nvdimm
 performance stats
To: Peter Zijlstra <peterz@infradead.org>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, maddy@linux.vnet.ibm.com,
        santosh@fossix.org, aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
        rnsastry@linux.ibm.com
References: <20210608115700.85933-1-kjain@linux.ibm.com>
 <20210608115700.85933-3-kjain@linux.ibm.com>
 <YL+qpL/+ReGfqXce@hirez.programming.kicks-ass.net>
From: kajoljain <kjain@linux.ibm.com>
Message-ID: <544189ad-d67a-8b56-05d8-3d62366a7ade@linux.ibm.com>
Date: Wed, 9 Jun 2021 17:42:09 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YL+qpL/+ReGfqXce@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZBlKokMhLr2dDAMDwFfN9WQn5EPi5zQ2
X-Proofpoint-ORIG-GUID: ZBlKokMhLr2dDAMDwFfN9WQn5EPi5zQ2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090059



On 6/8/21 11:06 PM, Peter Zijlstra wrote:
> On Tue, Jun 08, 2021 at 05:26:58PM +0530, Kajol Jain wrote:
>> +static int nvdimm_pmu_cpu_offline(unsigned int cpu, struct hlist_node *node)
>> +{
>> +	struct nvdimm_pmu *nd_pmu;
>> +	u32 target;
>> +	int nodeid;
>> +	const struct cpumask *cpumask;
>> +
>> +	nd_pmu = hlist_entry_safe(node, struct nvdimm_pmu, node);
>> +
>> +	/* Clear it, incase given cpu is set in nd_pmu->arch_cpumask */
>> +	cpumask_test_and_clear_cpu(cpu, &nd_pmu->arch_cpumask);
>> +
>> +	/*
>> +	 * If given cpu is not same as current designated cpu for
>> +	 * counter access, just return.
>> +	 */
>> +	if (cpu != nd_pmu->cpu)
>> +		return 0;
>> +
>> +	/* Check for any active cpu in nd_pmu->arch_cpumask */
>> +	target = cpumask_any(&nd_pmu->arch_cpumask);
>> +	nd_pmu->cpu = target;
>> +
>> +	/*
>> +	 * Incase we don't have any active cpu in nd_pmu->arch_cpumask,
>> +	 * check in given cpu's numa node list.
>> +	 */
>> +	if (target >= nr_cpu_ids) {
>> +		nodeid = cpu_to_node(cpu);
>> +		cpumask = cpumask_of_node(nodeid);
>> +		target = cpumask_any_but(cpumask, cpu);
>> +		nd_pmu->cpu = target;
>> +
>> +		if (target >= nr_cpu_ids)
>> +			return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int nvdimm_pmu_cpu_online(unsigned int cpu, struct hlist_node *node)
>> +{
>> +	struct nvdimm_pmu *nd_pmu;
>> +
>> +	nd_pmu = hlist_entry_safe(node, struct nvdimm_pmu, node);
>> +
>> +	if (nd_pmu->cpu >= nr_cpu_ids)
>> +		nd_pmu->cpu = cpu;
>> +
>> +	return 0;
>> +}
> 
>> +static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
>> +{
>> +	int nodeid, rc;
>> +	const struct cpumask *cpumask;
>> +
>> +	/*
>> +	 * Incase cpu hotplug is not handled by arch specific code
>> +	 * they can still provide required cpumask which can be used
>> +	 * to get designatd cpu for counter access.
>> +	 * Check for any active cpu in nd_pmu->arch_cpumask.
>> +	 */
>> +	if (!cpumask_empty(&nd_pmu->arch_cpumask)) {
>> +		nd_pmu->cpu = cpumask_any(&nd_pmu->arch_cpumask);
>> +	} else {
>> +		/* pick active cpu from the cpumask of device numa node. */
>> +		nodeid = dev_to_node(nd_pmu->dev);
>> +		cpumask = cpumask_of_node(nodeid);
>> +		nd_pmu->cpu = cpumask_any(cpumask);
>> +	}
>> +
>> +	rc = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "perf/nvdimm:online",
>> +				     nvdimm_pmu_cpu_online, nvdimm_pmu_cpu_offline);
>> +
> 
> Did you actually test this hotplug stuff?
> 
> That is, create a counter, unplug the CPU the counter was on, and
> continue counting? "perf stat -I" is a good option for this, concurrent
> with a hotplug.
>
> Because I don't think it's actually correct. The thing is perf core is
> strictly per-cpu, and it will place the event on a specific CPU context.
> If you then unplug that CPU, nothing will touch the events on that CPU
> anymore.
> 
> What drivers that span CPUs need to do is call
> perf_pmu_migrate_context() whenever the CPU they were assigned to goes
> away. Please have a look at arch/x86/events/rapl.c or
> arch/x86/events/amd/power.c for relatively simple drivers that have this
> property.
> 


Hi Peter,
    Primarily I tested off-lining multiple cpus and checking if cpumask file is updating as expected,
followed with perf stat commands.
But I missed the scenario where we are off-lining CPU while running perf stat. My bad, thanks
for pointing it out.
I will fix this issue and send new version of the patchset.

Thanks,
Kajol Jain
> 
