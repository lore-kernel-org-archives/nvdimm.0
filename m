From: "Cheng-mean Liu (SOCCER)" <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: FAIL: dax-errors.sh failures on 4.14.0-rc4+
Date: Tue, 10 Oct 2017 03:04:38 +0000
Message-ID: <MWHPR21MB01433B4F14C4D5EA3A1215E2A6750@MWHPR21MB0143.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Hi:

I am hitting the following ndctl test failure, all code from ndctl/Linux upstream kernel.

Is this a know issue?

FAIL: dax-errors.sh
SKIP: daxdev-errors.sh

FAIL: dax-errors.sh
===================

+ DEV=
+ NDCTL=../ndctl/ndctl
+ BUS='-b nfit_test.0'
+ BUS1='-b nfit_test.1'
+ MNT=test_dax_mnt
+ FILE=image
+ json2var='s/[{}",]//g; s/:/=/g'
+ rc=77
+ check_min_kver 4.7
+ local ver=4.7
++ uname -r
+ : 4.14.0-rc4+
+ '[' -n 4.7 ']'
++ echo -e '4.7\n4.14.0-rc4+'
++ sort -V
++ head -1
+ [[ 4.7 == \4\.\7 ]]
+ set -e
+ mkdir -p test_dax_mnt
+ trap 'err $LINENO' ERR
+ modprobe nfit_test
+ ../ndctl/ndctl disable-region -b nfit_test.0 all
disabled 6 regions
+ ../ndctl/ndctl zero-labels -b nfit_test.0 all
zeroed 4 nmems
+ ../ndctl/ndctl enable-region -b nfit_test.0 all
enabled 6 regions
+ rc=1
+ dev=x
++ ../ndctl/ndctl create-namespace -b nfit_test.0 -t pmem -m raw
+ json='{
  "dev":"namespace5.0",
  "mode":"raw",
  "size":67108864,
  "uuid":"8ce610c5-f7ca-4df8-84f4-d27adcb19ceb",
  "blockdev":"pmem5",
  "badblock_count":8
}'
++ echo '{' '"dev":"namespace5.0",' '"mode":"raw",' '"size":67108864,' '"uuid":"8ce610c5-f7ca-4df8-84f4-d27adcb19ceb",' '"blockdev":"pmem5",' '"badblock_count":8' '}'
++ sed -e 's/[{}",]//g; s/:/=/g'
+ eval dev=namespace5.0 mode=raw size=67108864 uuid=8ce610c5-f7ca-4df8-84f4-d27adcb19ceb blockdev=pmem5 badblock_count=8
++ dev=namespace5.0
++ mode=raw
++ size=67108864
++ uuid=8ce610c5-f7ca-4df8-84f4-d27adcb19ceb
++ blockdev=pmem5
++ badblock_count=8
+ '[' namespace5.0 = x ']'
+ '[' raw '!=' raw ']'
+ read sector len
+ '[' 131072 -ne 131072 ']'
+ dd if=/dev/pmem5 of=/dev/null iflag=direct bs=512 skip=65536 count=8
dd: error reading '/dev/pmem5': Input/output error
0+0 records in
0+0 records out
0 bytes copied, 0.0003475 s, 0.0 kB/s
+ dd of=/dev/pmem5 if=/dev/zero oflag=direct bs=512 seek=65536 count=8
8+0 records in
8+0 records out
4096 bytes (4.1 kB, 4.0 KiB) copied, 0.0003608 s, 11.4 MB/s
+ read sector len
+ mkfs.ext4 /dev/pmem5 -b 4096
mke2fs 1.43.4 (31-Jan-2017)
Creating filesystem with 16384 4k blocks and 16384 inodes

Allocating group tables: 0/1^H^H^H   ^H^H^Hdone
Writing inode tables: 0/1^H^H^H   ^H^H^Hdone
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: 0/1^H^H^H   ^H^H^Hdone

+ mount /dev/pmem5 test_dax_mnt -o dax
mount: wrong fs type, bad option, bad superblock on /dev/pmem5,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
++ err 86
++ rc=1
++ echo 'test/dax-errors: failed at line 86'
test/dax-errors: failed at line 86
++ rm -f image
++ rm -f test_dax_mnt/image
++ '[' -n pmem5 ']'
++ umount /dev/pmem5
umount: /dev/pmem5: not mounted
FAIL dax-errors.sh (exit status: 32)


Related output from dmesg:

[ 1322.467236] Dev pmem5: unable to read RDB block 0
[ 1320.022524] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[ 1322.079206] nfit_test nfit_test.0: failed to evaluate _FIT
[ 1322.094091] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[ 1322.094097] nfit_test nfit_test.1: nmem5 flags: map_fail
[ 1322.208386] pmem4: detected capacity change from 0 to 18874368
[ 1322.253620] pmem4: detected capacity change from 0 to 18874368
[ 1322.298877] pmem4: detected capacity change from 0 to 18874368
[ 1322.395729] pmem5: detected capacity change from 0 to 20971520
[ 1322.436148] pmem5: detected capacity change from 0 to 20971520
[ 1322.467236] Dev pmem5: unable to read RDB block 0
[ 1322.469831]  pmem5: unable to read partition table
[ 1322.469838] pmem5: partition table beyond EOD, truncated
[ 1322.480841] pmem5: detected capacity change from 0 to 20971520
....
...
[ 1326.855690] pmem5: detected capacity change from 0 to 20963328
[ 1326.907101] pmem5: detected capacity change from 0 to 17526784
[ 1326.948715] pmem5: detected capacity change from 0 to 17526784
[ 1326.994880] pmem5: detected capacity change from 0 to 17526784
[ 1327.033660] pmem5: detected capacity change from 0 to 20971520
[ 1327.075453] pmem5: detected capacity change from 0 to 20971520
[ 1327.107225] Dev pmem5: unable to read RDB block 0
[ 1327.109653]  pmem5: unable to read partition table
[ 1327.109658] pmem5: partition table beyond EOD, truncated
[ 1327.118638] pmem5: detected capacity change from 0 to 20971520
[ 1331.663747] nd_pmem btt5.0: No existing arenas
[ 1331.665112] pmem5s: detected capacity change from 0 to 20648960
[ 1331.714176] pmem5s: detected capacity change from 0 to 20648960
[ 1331.761270] pmem5s: detected capacity change from 0 to 20648960
[ 1331.807113] pmem5s: detected capacity change from 0 to 165191680
[ 1331.851034] pmem5s: detected capacity change from 0 to 165191680
[ 1331.905174] pmem5s: detected capacity change from 0 to 165191680
[ 1331.955127] pmem5s: detected capacity change from 0 to 165191680
[ 1332.003757] pmem5s: detected capacity change from 0 to 20648960
[ 1332.051781] pmem5s: detected capacity change from 0 to 20648960
[ 1332.097934] pmem5: detected capacity change from 0 to 20971520
[ 1332.145687] pmem5: detected capacity change from 0 to 20971520
[ 1332.177682] Dev pmem5: unable to read RDB block 0
[ 1332.180194]  pmem5: unable to read partition table
[ 1332.180201] pmem5: partition table beyond EOD, truncated
[ 1332.187808] pmem5: detected capacity change from 0 to 20971520
...
[ 1346.538586] buffer_io_error: 10 callbacks suppressed
[ 1346.538588] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.541063] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.541752] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.542464] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.543144] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.543773] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.544432] Dev pmem5.2: unable to read RDB block 0
[ 1346.545108] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.545808] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.546512]  pmem5.2: unable to read partition table
[ 1346.546649] pmem5.2: detected capacity change from 0 to 16777216
[ 1346.548308] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.551229] Buffer I/O error on dev pmem5.2, logical block 0, async page read
[ 1346.581112] pmem5.3: detected capacity change from 0 to 16777216
[ 1346.678496] Dev pmem5.2: unable to read RDB block 0
[ 1346.678655] pmem5: detected capacity change from 0 to 16777216
[ 1346.678704] pmem5.1: detected capacity change from 0 to 16777216
[ 1346.678875] pmem5.3: detected capacity change from 0 to 16777216
[ 1346.681041]  pmem5.2: unable to read partition table
[ 1346.681144] pmem5.2: detected capacity change from 0 to 16777216
[ 1346.962570] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[ 1349.023265] nfit_test nfit_test.0: failed to evaluate _FIT
[ 1349.038594] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[ 1349.038600] nfit_test nfit_test.1: nmem5 flags: map_fail
[ 1349.159130] pmem5: detected capacity change from 0 to 67108864
[ 1350.048065] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[ 1350.048324] pmem6: detected capacity change from 0 to 33554432
[ 1350.048479] pmem7: detected capacity change from 0 to 4194304
[ 1350.098457] pmem5: detected capacity change from 0 to 63664128
[ 1350.173183] pmem5: detected capacity change from 0 to 67108864
[ 1350.216879] nd_pmem btt5.0: No existing arenas
[ 1350.218207] pmem5s: detected capacity change from 0 to 65966080
[ 1350.289157] pmem5: detected capacity change from 0 to 67108864
...
[ 1350.613929] pmem5: detected capacity change from 0 to 67108864
[ 1350.692614] pmem5: detected capacity change from 0 to 63664128
[ 1350.811519]  pfn5.1: bad offset: 0x349000 dax disabled align: 0x200000
[ 1350.814707] pmem5: detected capacity change from 0 to 67108864
[ 1351.115178] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[ 1353.183213] nfit_test nfit_test.0: failed to evaluate _FIT
[ 1353.198187] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[ 1353.198274] nfit_test nfit_test.1: nmem5 flags: map_fail
[ 1353.309005] pmem5: detected capacity change from 0 to 67108864
[ 1353.370567] EXT4-fs (pmem5): dax option not supported
[ 1354.207624] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[ 1354.208123] pmem6: detected capacity change from 0 to 33554432
[ 1354.208446] pmem7: detected capacity change from 0 to 4194304
[ 1354.423610] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[ 1356.511133] nfit_test nfit_test.0: failed to evaluate _FIT
[ 1356.526230] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[ 1356.526236] nfit_test nfit_test.1: nmem5 flags: map_fail
[ 1356.642006] nd_pmem btt5.0: No existing arenas
[ 1356.643761] pmem5s: detected capacity change from 0 to 65966080
[ 1357.536092] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[ 1357.536465] pmem6: detected capacity change from 0 to 33554432
[ 1357.536640] pmem7: detected capacity change from 0 to 4194304
[ 1357.612697] pmem5: detected capacity change from 0 to 67108864
[ 1357.683549] pmem5s: detected capacity change from 0 to 65966080
...
[ 1361.799801] pmem5s: detected capacity change from 0 to 65966080
[ 1363.021627] nd_pmem btt5.0: No existing arenas
[ 1363.022717] pmem5s: detected capacity change from 0 to 65966080
[ 1363.121288] pmem5: detected capacity change from 0 to 67108864
[ 1363.238044] pmem5s: detected capacity change from 0 to 65966080
[ 1363.337225] pmem5: detected capacity change from 0 to 67108864
[ 1363.497096] nd_pmem btt5.0: No existing arenas
[ 1363.498433] pmem5s: detected capacity change from 0 to 65966080
[ 1363.868372] pmem5: detected capacity change from 0 to 67108864
[ 1364.186618] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[ 1366.239198] nfit_test nfit_test.0: failed to evaluate _FIT
[ 1366.254362] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[ 1366.254368] nfit_test nfit_test.1: nmem5 flags: map_fail
[ 1366.372227] pmem5: detected capacity change from 0 to 63664128
[ 1366.428960] pmem4: detected capacity change from 0 to 30105600
[ 1366.478551] ndblk3.0: detected capacity change from 0 to 16777216
[ 1366.532320] ndblk2.0: detected capacity change from 0 to 16777216
[ 1367.264303] pmem7: detected capacity change from 0 to 4194304
[ 1367.264339] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[ 1367.264448] pmem6: detected capacity change from 0 to 33554432
[ 1367.490185] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[ 1369.567191] nfit_test nfit_test.0: failed to evaluate _FIT
[ 1369.582054] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[ 1369.582060] nfit_test nfit_test.1: nmem5 flags: map_fail
