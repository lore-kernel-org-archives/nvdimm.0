Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D0C6FA1
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 17:14:19 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hs9+vEfhk1XmHu7rnCc4YJe4HveofIy+D7kdBepJV7HchUKTgvV7pgAVgMidcEy0gXZ5R+NEBZby7LEjceQ/UOUKASYMkVnHkQflfIkjz5Hnh1I+Y9mWXm4VgRUx454vgODfaPIImvpnE0ELbpEA8rjRyz8lsTgpv1/teuzCFMXhQRDmoejVK3Dtw5Rw5oprRHOv0vWVMRuKa2z95YDy50GU1lcc1Pv6iYdI/Z2+Oz7axysU3ODEQ52+oA+NQeWVxhaoj7pLMoihvjFb5oWFdA0reR39QeKiUcRXmCR6VpfB+2Kgq1xNLZGcJC/dgUgX3eRL6XXT8kDh+5xxCTAv6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vo9j/EINUusLsjF8bjMuOffFDa/kyZK4ZmS9oYchY7k=;
 b=Vq3KUkNEGjDnJZpL4iPdFpDPoIehe6NTNEVP/KUwJGPYwgiL5Ruuf+RM3hBMQbVwd2dW4vKNfJfawkufF7ib9GMMafc2/ei2775PSOSLlGjm7lPfyVM0CUqOfVJLbX3jtujUhuNW1OugX8L/+CLBF0CMtOe++FCnUdf3kb1ms2iheH9x4hbwZM941UIef7nPfZ1lkXS5o+nF8acX04qa6iYT9paOlTgD4Ovidt8T2A8eWKwLw37Fn0KyFrxUqfXu9duHcx0FVXUiyBM7v1s5dlgmO1ClKRULS6pJ7F31ndgAoBUHJc31dnR2QnEzMrj9Pp9i8EP+zGqCNmScjz/5Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vo9j/EINUusLsjF8bjMuOffFDa/kyZK4ZmS9oYchY7k=;
 b=SbA3sOGXx2Z93kMLNn3Ho8g4y1TxFg1KtHd+4Hl3Ay/fnLHNUMU52kVNJf/f5iJOa+oROZ3TzUnpoj+h0RN3xLfO66tZJUkJCFR0DVRGze1iUvV/umiYoFkHb9i/vbEhY199E+ovgZ5JXc3ZfWZhP0gsC+Eq+2B2AeNNGSqQjl4=
Received: from DM6PR13CA0009.namprd13.prod.outlook.com (2603:10b6:5:bc::22) by
 SA1PR12MB7128.namprd12.prod.outlook.com (2603:10b6:806:29c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Wed, 30 Nov 2022 17:14:17 +0000
Received: from DS1PEPF0000E643.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::d9) by DM6PR13CA0009.outlook.office365.com
 (2603:10b6:5:bc::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 17:14:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E643.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.17 via Frontend Transport; Wed, 30 Nov 2022 17:14:16 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 11:14:14 -0600
Date: Wed, 30 Nov 2022 18:14:12 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Rafael
 J. Wysocki" <rafael.j.wysocki@intel.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 00/12] cxl: Add support for Restricted CXL hosts (RCD
 mode)
Message-ID: <Y4ePZD776yXv2rG3@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E643:EE_|SA1PR12MB7128:EE_
X-MS-Office365-Filtering-Correlation-Id: cc766f79-eb54-44ef-fcf8-08dad2f64fde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0LloN85eLsGMuTxiF/l4smD/fvXrX0I7WknICLEvcypHWO/RMKRX/fhRpR3FGqvKXJU53q2CV9XSUn8s+V0EJiTJ6YQt/hqJKwD2RohUQ30R+Bk7jCs/IMEILS9wSnYAHXkWT2LjcTQ6DOeokMtG3PUeEVZDAixIQIdjPxActZRdtAOTetHIDWX+JP77bftpQgERYp5jbymwC5B6boNl47qc5hYu/lfM5COlE9sMdDuNpKUg/LPp0RR0OK0ejDVw/Wz3VYU2Ol5fi0Jto5XpGBbx8JS1IY65WaDrZA72V319OPQlp/DjyTgVBOgWSitbr79KNXO/xHhFn9oLC/BUdJPogPea39eqwykQS2bj5WHm0oV3dIkJEXtKx9IwxirGYQdruVVaTJIKHbfqTb5NCAGqWYZY+aS+4WKn8xHg3LEQgCSf7LwU1UNsSR095kK4kNNkWx0htKdSgezAMJN/DvPaRklD7jwK2gXxZPBFPfUwPe9jeE1T9EUnbhHmWzcMcm11pxDfQM5a5NeX2jUNZRWS72gI5h3VoVFP1vsqvk+JFdbgCZ+LDYeXLiCbPbFBZ33y22NknbRZnqUdRkJn0n7Ub1I/osTZZg5NFS7rJTdklvPB8ajSbVjN/MH4oepgYvC5p1W5iQwjCJYQAWmw1rEAuiTqbw8gd98Z3VeIszDbs5t4jXjy83YW1ujwgpAQRso6uRvUp5hnrM0HoON4hQr77XtSgEbbWELB4ERVIhMmB+1Y5/VGgCRJDNxLDM9fKAlTdqA1mpQ82U9C0jO5mA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(36860700001)(2906002)(83380400001)(26005)(82740400003)(81166007)(41300700001)(70586007)(40460700003)(70206006)(8676002)(356005)(53546011)(9686003)(40480700001)(82310400005)(7696005)(966005)(478600001)(336012)(186003)(5660300002)(8936002)(426003)(47076005)(16526019)(4326008)(316002)(54906003)(55016003)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 17:14:16.9366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc766f79-eb54-44ef-fcf8-08dad2f64fde
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0000E643.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7128

On 24.11.22 10:34:35, Dan Williams wrote:
> Changes since v3 [1]:
> - Rework / simplify CXL to LIBNVDIMM coordination to remove a
>   flush_work() locking dependency from underneath the root device lock.
> - Move the root device rescan to a workqueue
> - Connect RCDs directly as endpoints reachable through a CXL host bridge
>   as a dport, i.e. drop the extra dport indirection from v3
> - Add unit test infrastructure for an RCD configuration
> 
> [1]: http://lore.kernel.org/r/20221109104059.766720-1-rrichter@amd.com/
> 
> ---
> 
> >From [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration

> ---
> 
> Dan Williams (9):
>       cxl/acpi: Simplify cxl_nvdimm_bridge probing
>       cxl/region: Drop redundant pmem region release handling
>       cxl/pmem: Refactor nvdimm device registration, delete the workqueue
>       cxl/pmem: Remove the cxl_pmem_wq and related infrastructure
>       cxl/acpi: Move rescan to the workqueue
>       tools/testing/cxl: Make mock CEDT parsing more robust
>       cxl/mem: Move devm_cxl_add_endpoint() from cxl_core to cxl_mem
>       cxl/port: Add RCD endpoint port enumeration
>       tools/testing/cxl: Add an RCH topology
> 
> Robert Richter (2):
>       cxl/ACPI: Register CXL host ports by bridge device
>       cxl/acpi: Extract component registers of restricted hosts from RCRB
> 
> Terry Bowman (1):
>       cxl/acpi: Set ACPI's CXL _OSC to indicate CXL1.1 support
> 
> 
>  drivers/acpi/pci_root.c       |    1 
>  drivers/cxl/acpi.c            |  105 +++++++++---
>  drivers/cxl/core/core.h       |    8 -
>  drivers/cxl/core/pmem.c       |   94 +++++++----
>  drivers/cxl/core/port.c       |  111 +++++++------
>  drivers/cxl/core/region.c     |   54 ++++++
>  drivers/cxl/core/regs.c       |   56 +++++++
>  drivers/cxl/cxl.h             |   46 +++--
>  drivers/cxl/cxlmem.h          |   15 ++
>  drivers/cxl/mem.c             |   72 ++++++++
>  drivers/cxl/pci.c             |   13 +-
>  drivers/cxl/pmem.c            |  351 +++++------------------------------------
>  tools/testing/cxl/Kbuild      |    1 
>  tools/testing/cxl/test/cxl.c  |  241 ++++++++++++++++++++++------
>  tools/testing/cxl/test/mem.c  |   40 ++++-
>  tools/testing/cxl/test/mock.c |   19 ++
>  tools/testing/cxl/test/mock.h |    3 
>  17 files changed, 712 insertions(+), 518 deletions(-)

I have tested this series and the enumeration is as expected (see
sysfs dump below). I see an HDM failure which I am investigating, but
that seems unrelated to this series.

You can add to this series my:

Tested-by: Robert Richter <rrichter@amd.com>

The drawback of this topology decision is that the endpoint's port is
a child of root0, which is the ACPI0017's device (not the CXL host
bridge):

 /sys/bus/cxl/devices/root0/endpoint1

I understand this is the CXL's RCD view on the pcie hierarchy here.
Logically there would be a cxl host port in between, like this:

 /sys/bus/cxl/devices/root0/port1/endpoint2

Esp. if there are multiple hosts in the system the port relations will
be lost and can only be determined using the pci dev's parent bridge.

port1 could then also hold the uport's component regs with the
upstream port capabilities to access e.g. status regs for RAS.

Anyway, let's see how this approach flies.

Thanks for looing into this.

-Robert

---

# find /sys/bus/cxl/devices/ -ls
   265293      0 drwxr-xr-x   2 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/
   265493      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/root0 -> ../../../devices/platform/ACPI0017:00/root0
   265664      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/endpoint1 -> ../../../devices/platform/ACPI0017:00/root0/endpoint1
   265584      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/mem0 -> ../../../devices/pci0000:7f/0000:7f:00.0/mem0
# find /sys/bus/cxl/devices/*/ -ls 
   265660      0 drwxr-xr-x   2 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/endpoint1/
   265661      0 -rw-r--r--   1 root     root         4096 Nov 30 14:18 /sys/bus/cxl/devices/endpoint1/uevent
   265667      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/endpoint1/driver -> ../../../../../bus/cxl/drivers/cxl_port
   265669      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/endpoint1/uport -> ../../../../pci0000:7f/0000:7f:00.0/mem0
   265668      0 -r--------   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/endpoint1/CDAT
   265665      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/endpoint1/subsystem -> ../../../../../bus/cxl
   265662      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/endpoint1/devtype
   265663      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/endpoint1/modalias
   265573      0 drwxr-xr-x   4 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/mem0/
   265574      0 -rw-r--r--   1 root     root         4096 Nov 30 14:18 /sys/bus/cxl/devices/mem0/uevent
   265578      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/label_storage_size
   265582      0 drwxr-xr-x   2 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/mem0/pmem
   265583      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/pmem/size
   265576      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/firmware_version
   265579      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/numa_node
   265586      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/dev
   265659      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/mem0/driver -> ../../../../bus/cxl/drivers/cxl_mem
   265580      0 drwxr-xr-x   2 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/mem0/ram
   265581      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/ram/size
   265585      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/mem0/subsystem -> ../../../../bus/cxl
   265575      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/serial
   265577      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/mem0/payload_max
   265489      0 drwxr-xr-x   3 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/root0/
   265490      0 -rw-r--r--   1 root     root         4096 Nov 30 14:18 /sys/bus/cxl/devices/root0/uevent
   265660      0 drwxr-xr-x   2 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/root0/endpoint1
   265661      0 -rw-r--r--   1 root     root         4096 Nov 30 14:18 /sys/bus/cxl/devices/root0/endpoint1/uevent
   265667      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/root0/endpoint1/driver -> ../../../../../bus/cxl/drivers/cxl_port
   265669      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/root0/endpoint1/uport -> ../../../../pci0000:7f/0000:7f:00.0/mem0
   265668      0 -r--------   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/root0/endpoint1/CDAT
   265665      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/root0/endpoint1/subsystem -> ../../../../../bus/cxl
   265662      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/root0/endpoint1/devtype
   265663      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/root0/endpoint1/modalias
   265495      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/root0/uport -> ../../ACPI0017:00
   265496      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:21 /sys/bus/cxl/devices/root0/dport4 -> ../../../pci0000:7f
   265494      0 lrwxrwxrwx   1 root     root            0 Nov 30 14:18 /sys/bus/cxl/devices/root0/subsystem -> ../../../../bus/cxl
   265491      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/root0/devtype
   265492      0 -r--r--r--   1 root     root         4096 Nov 30 14:21 /sys/bus/cxl/devices/root0/modalias
