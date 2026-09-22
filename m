Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B869050128E;
	Tue, 22 Sep 2026 10:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071208; cv=none; b=dK4qhRi2LOE//a942Qy1BEKLyiU5sYsrfQSsYTcNBJzja23cjCMEX2jhgJy5RECm6vxtUejYVz6H/iiMH0bMenrjxw4WilALXbMTo56vM2Zc1SNZeP141Ib/Bh3npWsh76GOahXGrv1FPjyS9FCwoF+Vw1m96QO/fH83qcHKPy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071208; c=relaxed/simple;
	bh=J+vuW5tVyiBOoCchCR3MdzKhXLQZqP5b31JpZNZs294=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=NXT5ZaqtcoG2YArPSS6xhY0zBY04+7Y7urxYNQZv+srY4IOQ5UMWd9zYV8TgaKOCXrCNv2J135trLFjIsoslFYFI0bB5ZrC3vAjs/9RFNIp4Mucdvyn7K0JoqHZ66uJ1ngMEtM95F5WZraTHxjhe1KxftZWXHqylMWKLh9XSuS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oEKF8mZA; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oEKF8mZA"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260922100003epoutp0447de542da89fdb6e9f1b824595af0596~XnEZoUiMH0073500735epoutp04M;
	Tue, 22 Sep 2026 10:00:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260922100003epoutp0447de542da89fdb6e9f1b824595af0596~XnEZoUiMH0073500735epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790071203;
	bh=TfqgPVHMvKI+JVX/r7p1frHija+Q4mdlQxJzwLXyf0o=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=oEKF8mZA+AiptLsn5+41xNejcT6W/6iLif022a6DAcOdvs8m3mcR2u+VQgiKZJq0l
	 2nvEyFnPIqGitGsPSrElnJcyZLTJKcXrTPrM07AdcB4wOruKIxybXgDRb0ONQsD5x5
	 W8/9+7fdE42DYQf0W4REBBWPCidxcHQ1QbXabjH8=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260922100002epcas5p19cd8fb60b09ebfb214577f67397d4208~XnEZPV6ad3117031170epcas5p19;
	Tue, 22 Sep 2026 10:00:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hpwZB4YQlz6B9m9; Tue, 22 Sep
	2026 10:00:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260922095756epcas5p30808d249139dabc3c8a4b04f4cfedc57~XnCjkdyUG1358313583epcas5p3q;
	Tue, 22 Sep 2026 09:57:56 +0000 (GMT)
Received: from [107.122.10.65] (unknown [107.122.10.65]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260922095745epsmtip2daf29206bb39d723744c942a481f75a7~XnCZgn2QF2365323653epsmtip23;
	Tue, 22 Sep 2026 09:57:45 +0000 (GMT)
Message-ID: <360067785.01790071202608.JavaMail.epsvc@epcpadp1new>
Date: Tue, 22 Sep 2026 15:27:44 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, balbirs@nvidia.com,
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com,
	alucerop@amd.com, matthew.brost@intel.com, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com,
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev,
	tj@kernel.org, mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca,
	jhubbard@nvidia.com, peterx@redhat.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org,
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, hokyoon.lee@samsung.com, wj28.lee@samsung.com,
	gost.dev@samsung.com, vikash.k5@samsung.com, d.bueso@samsung.com
Content-Language: en-US
From: Arun George/Arun George <arun.george@samsung.com>
In-Reply-To: <amJGUuBZ2857QjDB@gourry-fedora-PF4VCD3F>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260922095756epcas5p30808d249139dabc3c8a4b04f4cfedc57
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f
References: <CGME20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f@epcas5p1.samsung.com>
	<20260720193431.3841992-1-gourry@gourry.net>
	<963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
	<amJGUuBZ2857QjDB@gourry-fedora-PF4VCD3F>

Hi Gregory,

Thanks for sharing the working branch.

Some of us at Samsung are testing the series (both v4 & v5) on a 
compression capable CXL expander and are observing encouraging results.

Good things first! We feel that the isolation using private nodes and 
the capability selection using NODE_PRIVATE_CAP_* work functionally well 
for the compressed memory use cases.

On improvement points, we observed much higher 'page_faults', 
'allocation_stalls' etc. which contributed to the higher tail latencies 
in some tests. I hope these are already part of the optimization plans. 
The higher latencies might have resulted from the write_protection 
applied to the private node, I believe.

On the tools side, we used MLC and Taobench for the tests.

Note that our intention for this phase of experiments was to test only 
the 'private node' layer based isolation, and not the cram and below 
layers for the compressed memory. Therefore we did not enable/utilize 
the compression capability in the hardware for these set of experiments 
(enabling compression would require the cram level ballooning/memory 
shrinking and cxl level interfacing driver to the compression device). 
That would be different set of experiments where we would be testing the 
cram balloon shrinkers and our alternate algorithms (upstream targeted). 
So cram and below layers were used only for enumeration of private node 
regions for these tests and not for the run-time memory shrinkers.

======= Test Methodology ==============

We explored these 3 cases:

    1) (Baseline – existing CXL infra):  DRAM 16GB + CXL 32GB. Here we 
used the existing CXL driver infra to enable the device. No private node 
is involved. And compression is disabled on device.

    2) (private node in default write protected path): DRAM 16GB + CXL 
Private Node 32GB. Here private node infra is used to enable the device. 
And compression is disabled on device.

    3) (private node with no write protection): DRAM 16GB + CXL Private 
Node 32GB. Here private node infra is used to enable the device without 
the write protection/fencing enabled. Compression is disabled on device. 
We could not complete these runs as they resulted in kernel panics. 
Guess the code path is not stable yet for this (We had hoped that case 1 
and case 3 results would be similar). We also observed some unmovable 
page warnings logs in 'dmesg' before crash (might be related to the 
panic). Adding the log snippets at the end.

========= Results summary ===================

- TaoBench: ‘private node’ showed much higher latencies. We believe this 
could be due to the migration back into the DRAM for overwrites (due to 
write-protection) based on the kernel VM stats.

- MLC:  For lower inject delay, the private node shows better latency; 
but when inject delay goes high, the baseline is better.

Overall kernel VM stats suggested much higher ‘page faults, ‘allocation 
stalls’ etc. in ‘private node’ case which is corroborated with the results.

========== Setup ======================

CPU: 144 Cores (single socket), DRAM: 16GB, CXL: 32GB,
Kernel: 7.2.0-rc2+ (Private Node), 6.18.32 (Baseline)

Private node opt CAPs:
#define CRAM_NP_CAPS    (NODE_PRIVATE_CAP_RECLAIM |
                         NODE_PRIVATE_CAP_HOTUNPLUG | \
                         NODE_PRIVATE_CAP_DEMOTION |
                         NODE_PRIVATE_CAP_USER_NUMA | \
                         NODE_PRIVATE_CAP_NUMA_BALANCING |
                         NODE_PRIVATE_POLICY_WRITE_FENCE)

Enabled 'numa balancing' and 'demotion'.
   $ echo 1 > /proc/sys/kernel/numa_balancing
   $ echo true > /sys/kernel/mm/numa/demotion_enabled

========== TaoBench Experiments ====================

CMD:
$ python3 benchpress_cli.py run tao_bench_standalone -i '{"bind_mem": 0, 
"bind_cpu": 0, "memsize": 32, "test_time": 300, "warmup_time": 0, 
"clients_per_thread": 100, "set_get_ratio": "1:9"}'

1. (baseline) DRAM 16GB + CXL 32GB   ==>

$ grep -A8 "^ALL STATS" benchmark_metrics_27cfff0e/client_0.log

===================================================
Type  Avg. Latency    p50        p95        p99
----------------------------------------------------
Sets   2.75215     2.73500      4.57500     5.79100
Gets   2.84236     2.81500      4.76700     5.95100

  2. (private node in default write protected path)
      DRAM 16GB + CXL Private Node(uncompressed) 32GB   ===>

$ grep -A8 "^ALL STATS" benchmark_metrics_5181fda5/client_0.log

===================================================
Type  Avg. Latency    p50        p95        p99
----------------------------------------------------
Sets   5.58395     4.73500      12.35100     21.75900
Gets   4.83344     4.19100      10.43100     17.91900

Vmstat metrics comparison of both cases for Taobench
($cat /proc/vmstat):

-------------------------------------------------------------------
Metric           |  Baseline    |   CXL Private Node |   Ratio
-------------------------------------------------------------------
pgfault            37,121,808       171,512,616          4.6x
pgactivate          5,360,928       161,947,594         30.2x
pgreuse             4,346,396           407,397         10.7x less
pgrefill           88,775,854       436,486,518          4.9x
pgdemote_kswapd     5,933,439       129,586,750         21.8x
pgdemote_direct        24,837        35,505,114       1429x
allocstall_normal         469           153,600        327x
kswapd_low_wmark_hit_quickly 671         27,821         41.5x
pageoutrun              1,333            29,217         21.9x
numa_pte_updates   24,508,077                 0          na
numa_hint_faults   21,152,264                 0          na
numa_pages_migrated 3,330,897                 0          na
numa_hit           46,667,202       353,812,703          7.6x

---------- Takeaways -----

Private (CRAM) node performance is lower compared to a normal CXL memory 
allocation path. VM stats shows more page_faults and allocation_stalls 
on the private node case. Could it be the allocator waits for migration 
path to demote pages to private node? Or the actual hot pages in dram 
got demoted to private node to make space during overwrites? We will try 
further analysis on this.

========== MLC Experiments ====================

CMD:
   $./mlc --loaded_latency -j0 -c0 -b1g -k1-15 -W5 -r

Experiment Results:

1. (Baseline) DRAM 16GB + CXL 32GB

Inject  Latency Bandwidth
Delay   (ns)    MB/sec
================
  00000  686.18   40137.5
  00002  686.69   40124.0
  00008  709.74   40362.7
  00015  711.75   40350.0
  00050  710.72   40357.4
  00100  712.22   40316.0
  00200  695.29   40026.5
  00300  602.91   38845.3
  00400  482.28   36240.4
  00500  410.03   33606.6
  00700  275.13   26352.5
  01000  241.82   18851.7
  01300  230.91   14695.8
  01700  215.27   11403.2
  02500  217.76    7900.9
  03500  194.42    5787.0
  05000  192.17    4166.4
  09000  190.36    2475.0
  20000  188.09    1312.1

2. (private node in default write protected path)
     DRAM 16GB + CXL Private Node(Uncompressed) 32GB

Inject  Latency Bandwidth
Delay   (ns)    MB/sec
================
  00000  320.09   12186.2
  00002  543.42   22726.1
  00008  482.11   28385.2
  00015  488.26   26304.6
  00050  485.19   26898.4
  00100  477.65   24668.9
  00200  483.68   21273.8
  00300  486.44   17655.9
  00400  480.41   16470.0
  00500  481.30   13589.9
  00700  493.84    9960.8
  01000  488.66    8267.7
  01300  491.31    6433.6
  01700  476.97    6211.2
  02500  472.97    5037.0
  03500  466.05    3533.8
  05000  446.44    2783.1
  09000  417.03    1877.5
  20000  387.22    1035.3

Vmstat metrics comparison of both cases for MLC
($cat /proc/vmstat):

-------------------------------------------------------------------
Metric           |  Baseline    |   CXL Private Node |   Ratio
-------------------------------------------------------------------
pgfault           10,287,329         46540,782           4.6x
pgactivate           1141468        65,098,272          57x
pgrefill             260,699        47,592,751         182.5x
pgdemote_kswapd    1,085,783        26,063,754          24x
pgdemote_direct    4,562,539        15,809,485           3.5x
pgmigrate_fail        41,929         2,763,725          65.9x
allocstall_normal        161               425           2.6x
kswapd_low_wmark_hit_quickly  47           763          16.2x
pageoutrun                55               936          17x

Takeaway: Our MLC tests show a trade-off between the two configurations. 
During low inject delay, the private Node is faster. But when inject 
delay goes high, the baseline shows better latency. Could it be the TLB 
cache effects?

--------------------------------------------------------------------
Case 3 dmesg log snippet:

[   82.525741] page: refcount:1 mapcount:0 mapping:0000000000000000 
index:0x0 pfn:0x5f5800
[   82.525753] flags: 
0x17ffffc0002000(reserved|node=0|zone=2|lastcpupid=0x1fffff)
[   82.525762] raw: 0017ffffc0002000 ffefc85717d60008 ffefc85717d60008 
0000000000000000
[   82.525764] raw: 0000000000000000 0000000000000000 00000001ffffffff 
0000000000000000
[   82.525766] page dumped because: unmovable page
..............

We will update on the compression enabled experiments further.

~ Arun

On 23-07-2026 10:23 pm, Gregory Price wrote:
> On Thu, Jul 23, 2026 at 02:08:31PM +0530, Arun George/Arun George wrote:
>> On 21-07-2026 01:03 am, Gregory Price wrote:
>> We intend to test this series on a compression capable CXL expander
>> hardware. Since compressed ram example (cram) is not part of this
>> series, how do you suggest to do that? Do you have a version of cram
>> module compatible with this series?
>>
>> ~Arun
> 
> Hi Arun,
> > I plan to RFC the new setup for compressed ram this a bit later, but I
> will share my working branch with you for testing.
> 
> ~Gregory


