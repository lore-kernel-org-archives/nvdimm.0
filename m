Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64D6D2193FD61
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 14:02:42 -0700 (PDT)
Date: Mon, 1 May 2017 14:02:41 -0700
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: [PATCH v2] ndctl: add clear error support for ndctl
Message-ID: <20170501210241.GA11607@djiang5-desk3.ch.intel.com>
References: <149333241780.23371.243937948027874332.stgit@djiang5-desk3.ch.intel.com>
 <1493670342.30303.24.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493670342.30303.24.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 01, 2017 at 01:25:45PM -0700, Kani, Toshimitsu wrote:
> On Thu, 2017-04-27 at 15:38 -0700, Dave Jiang wrote:
> > Adding ndctl support that will allow clearing of bad blocks for a
> > device. Initial implementation will only support device dax devices.
> > The ndctl takes a device path and parameters of the starting bad
> > block, and the number of bad blocks to clear.
> >
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> Hi Dave,
> 
> I am seeing a failure to open "badblocks" on my system since its sysfs
> path with "/sys/devcies/platform/ACPI.NFIT" is not valid (not sure how
> I got "ACPI.NFIT" here - I hope I did not mess up my build with test
> cases).
> 
> As you can see below, other open paths use
> "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/" for "nbus0".  If
> you go from "/sys/devices/platform", a valid path seems to be:
> "/sys/devices/platform/ACPI0012:00/firmware_node"
> 
> # strace ndctl clear-error -f /dev/dax0.0 -s 1048576 -l 1
> execve("/usr/bin/ndctl", ["ndctl", "clear-error", "-f", "/dev/dax0.0",
> "-s", "1048576", "-l", "1"], [/* 60 vars */]) = 0
>  :
> open("/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/d
> ax0.0/resource", O_RDONLY|O_CLOEXEC) = 4
> read(4, "0x250200000\n", 1024)          = 12
> close(4)                                = 0
> open("/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/d
> ax0.0/size", O_RDONLY|O_CLOEXEC) = 4
> read(4, "16909336576\n", 1024)          = 12
> close(4)                                = 0
> getdents(3, /* 0 entries */, 32768)     = 0
> close(3)                                = 0
> open("/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/r
> esource", O_RDONLY|O_CLOEXEC) = 3
> read(3, "0x240000000\n", 1024)          = 12
> close(3)                                = 0
> open("/sys/devices/platform/ACPI.NFIT/ndbus0/region0/badblocks",
> O_RDONLY) = -1 ENOENT (No such file or directory)
> write(2, "libndctl: regions_badblocks_init"..., 34libndctl:
> regions_badblocks_init: ) = 34
> write(2, "region badblocks fopen failed\n", 30region badblocks fopen
> failed
> ) = 30
> exit_group(234)                         = ?
> +++ exited with 234 +++
> 
> Thanks,
> -Toshi

Toshi,
Can you please try this and see if that fixes the issue? Thanks!

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 7399729..44fc2f3 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1882,10 +1882,8 @@ static int regions_badblocks_init(struct ndctl_region *region)
 		region->badblocks = NULL;
 	}
 
-	if (asprintf(&bb_path, "/sys/devices/platform/%s/%s/%s/badblocks",
-				ndctl_bus_get_provider(bus),
-				ndctl_bus_get_devname(bus),
-				ndctl_region_get_devname(region)) < 0) {
+	if (asprintf(&bb_path, "%s/badblocks",
+				region->region_path) < 0) {
 		rc = -errno;
 		err(ctx, "region badblocks path allocation failure\n");
 		return rc;
-- 

Dave Jiang
Software Engineer, Data Center Group
Intel Corp.
dave.jiang@intel.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
