Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 27 Jun 2019 14:19:53 +0000
From: Won-Kyo Choe <heysid@ajou.ac.kr>
Subject: A write error on converting dax0.0 to kmem
Message-ID: <20190627141953.GC3624@swarm07>
Reply-To: heysid@ajou.ac.kr
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
To: dave.hansen@intel.com
Cc: jsahn@ajou.ac.kr, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dave. I hope this message is sent appropriately in this time.

We've recently got a new machine which contains Optane DC memory and 
tried to use your patch set[1] in a recent kernel version(5.1.15). 
Unfortunately, we've failed on the last step[2] that describes 
converting device-dax driver as kmem. The main error is "echo: write error: No such device". 
We are certain that there must be a device and it should be recognized 
since we can see it in a path "/dev/dax0.0", however, somehow it keeps saying that error.

We've followed all your steps in the first patch[1] except a step about qemu configuration 
since we already have a persistent memory. We even checked that there is a region 
mapped with persistent memory from a command, `dmesg | grep e820` described in below.

BIOS-e820: [mem 0x0000000880000000-0x00000027ffffffff] persistent (type 7)

As the address is shown above, the thing is that in the qemu, the region is set as 
persistent (type 12) but in the native machine, it says persistent (type 7). 
We've still tried to find what type means and we simply guess that this is one 
of the reasons why we are not able to set the device as kmem.

We'd like to know why this error comes up and how can we handle this problem. 
We would really appreciate it if you are able to little bit help us.

Regards,

Won-Kyo

1. https://patchwork.kernel.org/cover/10829019/
2. https://patchwork.kernel.org/patch/10829041/
