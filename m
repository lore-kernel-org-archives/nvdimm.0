From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: xfstests xfs fuzzers fail with DAX
Date: Thu, 4 Aug 2016 10:45:14 +0800
Message-ID: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi,

A few xfs fuzzers in xfstests fail with dax mount option, pass without dax.
They are xfs/086 xfs/088 xfs/089 xfs/091.

xfstests to commit 4470ad4c7e  (Jul 26)
kernel   to commit dd95069545  (Jul 24)

+ ./check xfs/091
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch

xfs/091	 104s
Ran: xfs/091
Passed all 1 tests

+ echo 'MOUNT_OPTIONS="-o dax"'
+ ./check xfs/091
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch

xfs/091 104s ...  - output mismatch (see /root/xfstests/results//xfs/091.out.bad)
    --- tests/xfs/091.out	2016-07-18 02:57:47.670000000 -0400
    +++ /root/xfstests/results//xfs/091.out.bad	2016-08-03 22:38:14.948000000 -0400
    @@ -6,6 +6,70 @@
     + corrupt image
     + mount image
     + modify files
    +pwrite64: Structure needs cleaning
    +pwrite64: Structure needs cleaning
    +pwrite64: Structure needs cleaning
    +pwrite64: Structure needs cleaning
    ...
    (Run 'diff -u tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad'  to see the entire diff)
Ran: xfs/091
Failures: xfs/091
Failed 1 of 1 tests

# diff -u xfstests/tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad
--- xfstests/tests/xfs/091.out	2016-07-18 02:57:47.670000000 -0400
+++ /root/xfstests/results//xfs/091.out.bad	2016-08-03 22:38:14.948000000 -0400
@@ -6,6 +6,70 @@
 + corrupt image
 + mount image
 + modify files
+pwrite64: Structure needs cleaning
<snip 62 more same lines>
+pwrite64: Structure needs cleaning
 + repair fs
 + mount image
 + chattr -R -i


Thanks,
Xiong
