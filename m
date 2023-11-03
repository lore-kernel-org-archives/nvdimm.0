Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530BE14F86
	for <nvdimm@lists.linux.dev>; Fri,  3 Nov 2023 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="138286755"
X-IronPort-AV: E=Sophos;i="6.03,273,1694703600"; 
   d="scan'208";a="138286755"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 20:11:26 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9A99AD7AE6
	for <nvdimm@lists.linux.dev>; Fri,  3 Nov 2023 20:11:23 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id D8C24BF4CE
	for <nvdimm@lists.linux.dev>; Fri,  3 Nov 2023 20:11:22 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 7721120050190
	for <nvdimm@lists.linux.dev>; Fri,  3 Nov 2023 20:11:22 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id F092D1A006F;
	Fri,  3 Nov 2023 19:11:21 +0800 (CST)
Message-ID: <0137fb34-7291-b88b-34aa-78471d57921b@fujitsu.com>
Date: Fri, 3 Nov 2023 19:11:21 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
Subject: [ISSUE] `cxl destory-region region0` causes kernel panic when cxl
 memory is occupied
To: Dave Jiang <dave.jiang@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27974.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27974.007
X-TMASE-Result: 10--16.218700-10.000000
X-TMASE-MatchedRID: L+num7NHV/KGYAKJjm5IPTzXNFWi6yZNr+LsAsPJG4vkMnUVL5d0E8sl
	jkE3iNz5A9H5R5f2ce0nLmQ5uRWv6HKFDlScjj98194/5X9VfCw1kR+05VC1hkkfDRUtgtwsxON
	QYeoRenG87N7vzPSpUuP8oij9M8LyzroGAhCVDDUdahq+rGDn/7JEo6RFXaMB592Swrd60UkoLR
	/490Gk8UsEkE0uT6IPMJlmIOucvXQln6i9lj9cEa+/qoWUv5IZfrTt+hmA5bLWfdTIhX4P8zSJ2
	POnb5leSm+rcI1Om2ncCgww7x2eJ9U8BKnplvExDDTnhTOAGjVJ0h0KLwFrgDVjvc93O9dkpdTJ
	bVI6pWCc4ocq3YBa9I0+3TlTJMyF+5MHyYkXwcr5vLCFTd9mpn0tCKdnhB58vqq8s2MNhPCb4iD
	lO9ygjpREFUJLkadAC24oEZ6SpSk+Mqg+CyrtwA==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Hi guys,

I am writing to report an issue that I have encountered while executing 
'cxl destroy-region region0', causing a kernel panic when the cxl memory 
is occupied. I have provided a detailed description of the problem along 
with relevant test for reference.

Problem Description:

After 'create-region', if cxl memory is occupied using a script, then 
'disable-region' without `daxctl offline-memory` firstly, it will result 
in a kernel panic.

I made a few investigation on this, the panic was caused during the 
process of resetting the region decode in preparation for removal within 
the "destroy_region()" function in cxl/region.c. When the value of 
"/sys/bus/cxl/devices/root0/decoder0.0/region0/commit" is changed from 1 
to 0, it will invoke the driver code to reset the region decode, which 
in turn leads to a kernel panic:

[  397.898809] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  397.908416] systemd[1]: segfault at 0 ip 0000000000000000 sp 
00007ffcdc242520 error 14 in systemd[55555aef50)
[  397.910578] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  397.920233] systemd[1]: segfault at 0 ip 0000000000000000 sp 
00007ffcdc2416a0 error 14 in systemd[55555aef50)
[  397.922309] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  397.933175] systemd[1]: segfault at 0 ip 0000000000000000 sp 
00007ffcdc240820 error 14 in systemd[55555aef50)
[  397.935553] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  397.945611] systemd[1]: segfault at 0 ip 0000000000000000 sp 
00007ffcdc23f9a0 error 14 in systemd[55555aef50)
[  397.947751] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  400.474068] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b
[  400.474583] CPU: 2 PID: 1 Comm: systemd Tainted: G           O     N 
6.6.0-rc6+ #1
[  400.474583] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.16.2-0-gea1b7a073390-prebuilt.qem4
[  400.474583] Call Trace:
[  400.474583]  <TASK>
[  400.474583]  dump_stack_lvl+0x43/0x60
[  400.474583]  panic+0x32a/0x340
[  400.474583]  ? _raw_spin_unlock+0x15/0x30
[  400.474583]  do_exit+0x9a1/0xb30
[  400.474583]  do_group_exit+0x2d/0x80
[  400.474583]  get_signal+0x9c7/0xa00
[  400.474583]  arch_do_signal_or_restart+0x3a/0x280
[  400.474583]  exit_to_user_mode_prepare+0x192/0x1f0
[  400.474583]  irqentry_exit_to_user_mode+0x5/0x30
[  400.474583]  asm_exc_page_fault+0x22/0x30
[  400.474583] RIP: 0033:0x0
[  400.474583] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  400.474583] RSP: 002b:00007ffcdc1579a0 EFLAGS: 00000207
[  400.474583] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 
00007fb10db2796d
[  400.474583] RDX: 00007fb10db2796d RSI: 00000000ffffffff RDI: 
00007ffcdc157c70
[  400.474583] RBP: 000000000000000b R08: 0000000000000000 R09: 
0000000000000000
[  400.474583] R10: 0000000000000000 R11: 0000000000000246 R12: 
00007ffcdc94dce8
[  400.474583] R13: 00007ffcdc94dce0 R14: 00000000000004bb R15: 
000000000000005d
[  400.474583]  </TASK>
[  400.474583] Kernel Offset: 0x20000000 from 0xffffffff81000000 
(relocation range: 0xffffffff80000000-0xffffff)
[  400.474583] ---[ end Kernel panic - not syncing: Attempted to kill 
init! exitcode=0x0000000b ]---

According to the panic message, the systemd process in the system 
encountered a segmentation fault (segfault), resulting in a kernel panic.

Test Example:

1.echo online_movable > /sys/devices/system/memory/auto_online_blocks
2.cxl create-region -t ram -d decoder0.0 -m mem0
3.python consumemem.py         <------execute script
4.cxl disable-region region0
5.cxl destory-region region0   <------kernel panic !!!

Thank you very much for taking the time to look on this issue. Looking 
forward to your response.

Best regards,
Quanquan Cao
caoqq@fujitsu.com
