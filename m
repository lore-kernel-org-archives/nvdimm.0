Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3476C1DA21
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 05:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709012019; cv=none; b=LVdX39YsxPSLY9gkfGFA6tz1bSxpgJuzxQ5oZbZZPdzHLIhnQLKvCph7++eYOD0HUE6PkIUzOd5aeymXbeOvu/qgBsQjU9uZGp0aCHsItilT4SCUsAyZU6XvZCSLZmlB7tL5IRTEBj91BT2eZvo0Iq/cwx9l80jS/c0/eGYvUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709012019; c=relaxed/simple;
	bh=LmpaNhqfF0T0bD7e5/n/WMIN6zkdt6FvQ+Jo10gMSmo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=UYrNgWGdsKpCR6aNmjxvsKXz6OPNSWmDS+ZzLIeb1fDoN5HvRvBRF5asp5bxVTF9IXqtzk4lu4syB+tQsffA7hEqx+L3n4NR+TpWCzHipzEHRfk54Ox5eKTnPC0AGwh03ar1B2MmErlMjWGls72iq8C5MWvFJIhUUWdw+0xS8ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=sm6dqkQi; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="sm6dqkQi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709012018; x=1740548018;
  h=message-id:date:mime-version:from:subject:to:cc:
   content-transfer-encoding;
  bh=LmpaNhqfF0T0bD7e5/n/WMIN6zkdt6FvQ+Jo10gMSmo=;
  b=sm6dqkQieFdAMj3aoUlzWxEQvOMJfLztxu8fiidlCldu3ixG0PrJPT1R
   nSL8oe8eS8Ank5lKhLlctiMLDncsPYZOId+YH+ZSouEMHFLBqcdGwii94
   3WARDQb6uD3bhiKz3sgVjsUWDv72INK8XGQNs6neu5Dp7FgMgp70oMTjC
   LaW/FmsWrha19GGADCw67ZkTLTiZJoRbeCXdihEAhQbmHbxy50xarT0iZ
   wFdmqFMpgmxHYrenAgLvk8/UbPggR7QZEf6cGgj8lbDW3q41li8MvIDPR
   AhhwfSMfEe1oA1TWCVhck0Uf1WbMjA9SMXobyrNaj64xD1uIbu/pti58M
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="150535036"
X-IronPort-AV: E=Sophos;i="6.06,187,1705330800"; 
   d="scan'208";a="150535036"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 14:32:26 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1ECD71A7804
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 14:32:23 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 53ADED7B6E
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 14:32:22 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id D22496BE7A
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 14:32:21 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 48B761A006A;
	Tue, 27 Feb 2024 13:32:21 +0800 (CST)
Message-ID: <3788c116-50aa-ae97-adca-af6559f5c59a@fujitsu.com>
Date: Tue, 27 Feb 2024 13:32:20 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
Subject: Question about forcing 'disable-memdev'
To: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28216.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28216.005
X-TMASE-Result: 10--2.856700-10.000000
X-TMASE-MatchedRID: T3hsd5K8wICGYAKJjm5IPTo39wOA02LhTSz0JdEAJbTuR6RKcHGClhDJ
	pQ8DtMBd6XmVAUde0xrK+QFXYp+GteVaI0j/eUAPQ0Xm0pWWLkoXjfR3d0weRjYt7BCMaN4sMqe
	v799PSV3myE8VIo655CEIEnlWgL3p7Xu8W3B9FWktXoug6eNZmQO3/A5KGHP/VgkL9epqBvExyi
	dJf6wfobum2UTXMRXanagtny7ZPcS/WXZS/HqJ2g9ejiC/BQPdDZX99HwFDsIqtq5d3cxkNe2VN
	uufHW17JH7NJp1cF9VlDjBseu8wPdAq6ZdUxJE1hl9IqZ3Rc3bqxvqml38y30levMI+7RuCgAeH
	YP3tYM3Nlw8MLhLs7+96/enegQdRIE2CnS8XsZEfNZSYb0kT7CWqVVINSOGKOFbuWMgEXbM=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Hi, Dave

On the basis of this patch, I conducted some tests and encountered 
unexpected errors. I would like to inquire whether the design here is 
reasonable? Below are the steps of my testing:

Link: 
https://lore.kernel.org/linux-cxl/170138109724.2882696.123294980050048623.stgit@djiang5-mobl3/


Problem description: after creating a region, directly forcing 
'disable-memdev' and then consuming memory leads to a kernel panic.


Test environment:
KERNEL	6.8.0-rc1
QEMU	8.2.0-rc4

Test steps：
       step1: set memory auto_online to movable zones.
            echo online_movable > 
/sys/devices/system/memory/auto_online_blocks
       step2: create region
            cxl create-region -t ram -d decoder0.0 -m mem0
       step3: disable memdev
            cxl disable-memdev mem0 -f
       step4: consum CXL memory
            ./consumemem   <------kernel panic

numactl node status:
       step1: numactl -H

	available: 2 nodes (0-1)
	node 0 cpus: 0 1
	node 0 size: 968 MB
	node 0 free: 664 MB
	node 1 cpus: 2 3
	node 1 size: 683 MB
	node 1 free: 333 MB
	node distances:
	node   0   1
	  0:  10  20

     step2: numactl -H

	available: 3 nodes (0-2)
	node 0 cpus: 0 1
	node 0 size: 968 MB
	node 0 free: 677 MB
	node 1 cpus: 2 3
	node 1 size: 683 MB
	node 1 free: 333 MB
	node 2 cpus:
	node 2 size: 256 MB
	node 2 free: 256 MB
	node distances:
	node   0   1   2
	  0:  10  20  20
	  1:  20  10  20
	  2:  20  20  10

     step3: numactl -H

	available: 3 nodes (0-2)
	node 0 cpus: 0 1
	node 0 size: 968 MB
	node 0 free: 686 MB
	node 1 cpus: 2 3
	node 1 size: 683 MB
	node 1 free: 336 MB
	node 2 cpus:
	node 2 size: 256 MB
	node 2 free: 256 MB
	node distances:
	node   0   1   2
	  0:  10  20  20
	  1:  20  10  20
	  2:  20  20  10
