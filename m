Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0FD107BA
	for <nvdimm@lists.linux.dev>; Wed,  9 Nov 2022 22:06:14 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 12939404008C;
	Wed,  9 Nov 2022 16:59:55 -0500 (EST)
Message-ID: <8635b40a-6e87-b5da-e63d-476309bbc80b@cs.umass.edu>
Date: Wed, 9 Nov 2022 16:59:54 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Reply-To: moss@cs.umass.edu
Content-Language: en-US
From: Eliot Moss <moss@cs.umass.edu>
To: nvdimm@lists.linux.dev
Subject: Detecting whether hug pages are working with fsdax
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear nvdimmers -

I tried following Darrick Wong's advice from this page:

https://nvdimm.wiki.kernel.org/2mib_fs_dax

In particular, these instructions:
================================================================================
The way that I normally do this is by looking at the filesystem DAX tracepoints:

# cd /sys/kernel/debug/tracing
# echo 1 > events/fs_dax/dax_pmd_fault_done/enable
<run test which faults in filesystem DAX mappings>
We can then look at the dax_pmd_fault_done events in

/sys/kernel/debug/tracing/trace
and see whether they were successful. An event that successfully faulted in a filesystem DAX PMD
looks like this:

big-1434  [008] ....  1502.341229: dax_pmd_fault_done: dev 259:0 ino 0xc shared
WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start 0x10200000 vm_end
0x10700000 pgoff 0x305 max_pgoff 0x1400 NOPAGE
The first thing to look at is the NOPAGE return value at the end of the line. This means that the
fault succeeded and didn't return a page cache page, which is expected for DAX. A 2 MiB fault that
failed and fell back to 4 KiB DAX faults will instead look like this:

small-1431  [008] ....  1499.402672: dax_pmd_fault_done: dev 259:0 ino 0xc shared
WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10420000 vm_start 0x10200000 vm_end
0x10500000 pgoff 0x220 max_pgoff 0x3ffff FALLBACK
You can see that this fault resulted in a fallback to 4 KiB faults via the FALLBACK return code at
the end of the line. The rest of the data in this line can help you determine why the fallback
happened. In this case it was because I intentionally created an mmap() area that was smaller than 2
MiB.
================================================================================

I get no trace output whatsoever, whether I am using 2Mb huge pages or 1Gb
huge pages.  My mmap calls are successful but I get no trace output at all,
only this:

================================================================================
# tracer: nop
#
# entries-in-buffer/entries-written: 0/0   #P:63
#
#                                _-----=> irqs-off
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq
#                              || / _--=> preempt-depth
#                              ||| / _-=> migrate-disable
#                              |||| /     delay
#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
================================================================================

Any suggestions about what may be different in my system?  It is clear that we
are mapping files created in an fdax file system, and that the contents of the
files are changing.

Regards - Eliot Moss
