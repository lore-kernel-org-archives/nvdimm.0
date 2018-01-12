Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0396721D2BEFE
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jan 2018 11:35:13 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: DAX 2MB mappings for XFS
Date: Fri, 12 Jan 2018 19:40:25 +0000
Message-ID: <1515788779.16384.29.camel@hpe.com>
Content-Language: en-US
Content-ID: <AB462F6B29279C478ADF183213DC931C@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

I noticed that DAX 2MB mmap no longer works on XFS.  I used the
following steps on a 4.15-rc7 kernel.  Am I missing something, or is
there a problem in XFS?

# mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
# mount -o dax /dev/pmem0 /mnt/pmem0
# xfs_io -c "extsize 2m" /mnt/pmem0

fio with libpmem engine (which uses mmap) is slow since it gets
serialized by 4KB page faults.

# numactl --cpunodebind=0 --membind=0 fio --filename=/mnt/pmem0/testfile 
--rw=read --ioengine=libpmem --iodepth=1 --numjobs=16 --runtime=60 --
group_reporting --name=perf_test --thread=1 --size=6g --bs=128k --
direct=1
  :
Run status group 0 (all jobs):
   READ: bw=4357MiB/s (4569MB/s), 4357MiB/s-4357MiB/s (4569MB/s-
4569MB/s), io=96.0GiB (103GB), run=22560-22560msec

Resulted file blocks in "testfile" are not aligned by 2MB.

# filefrag -v /mnt/pmem0/testfile
Filesystem type is: 58465342
File size of testfile is 6442450944 (1572864 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
flags:
   0:        0..  261111:        520..    261631: 261112:
   1:   261112..  261348:         12..       248:    237:     261632:
   2:   261349..  522705:     261644..    523000: 261357:        249:
   3:   522706..  784062:     523276..    784632: 261357:     523001:
   4:   784063.. 1045419:     784908..   1046264: 261357:     784633:
   5:  1045420.. 1304216:    1049100..   1307896: 258797:    1046265:
   6:  1304217.. 1565573:    1308172..   1569528: 261357:    1307897:
   7:  1565574.. 1572863:    1570304..   1577593:   7290:    1569529: 
last,eof
testfile: 8 extents found

A file created by fallocate also shows that physical offset starts from
520, which is not aligned by 2MB. 

# fallocate --length 1G /mnt/pmem0/data
# filefrag -v /mnt/pmem0/data
Filesystem type is: 58465342
File size of /mnt/pmem0/data is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
flags:
   0:        0..  260607:        520..    261127:
260608:             unwritten
   1:   260608..  262143:     262144..    263679:   1536:     261128:
last,unwritten,eof
/mnt/pmem0/data: 2 extents found

ext4 does not have the issue in the same steps.

# mkfs.ext4 -b 4096 -E stride=512 -F /dev/pmem1
# mount -o dax /dev/pmem1 /mnt/pmem1
# numactl --cpunodebind=0 --membind=0 fio --filename=/mnt/pmem1/testfile 
--rw=read --ioengine=libpmem --iodepth=1 --numjobs=16 --runtime=60 --
group_reporting --name=perf_test --thread=1 --size=6g --bs=128k --
direct=1      
  :
Run status group 0 (all jobs):
   READ: bw=44.4GiB/s (47.7GB/s), 44.4GiB/s-44.4GiB/s (47.7GB/s-
47.7GB/s), io=96.0GiB (103GB), run=2160-2160msec

All blocks are aligned by 2MB.

# filefrag -v /ment/pmem1/testfile
Filesystem type is: ef53
File size of testfile is 6442450944 (1572864 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
flags:
   0:        0..   32767:      34816..     67583:  32768:
   1:    32768..   63487:      67584..     98303:  30720:
   2:    63488..   96255:     100352..    133119:  32768:      98304:
   3:    96256..  126975:     133120..    163839:  30720:
    :

# fallocate --length 1G /mnt/pmem1/data
# filefrag -v /mnt/pmem1/data
Filesystem type is: ef53
File size of /mnt/pmem1/data is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
flags:
   0:        0..   30719:      34816..     65535:  30720:   unwritten
   1:    30720..   61439:      65536..     96255:  30720:   unwritten
   2:    61440..   63487:      96256..     98303:   2048:   unwritten
   :

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
