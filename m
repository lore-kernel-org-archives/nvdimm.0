Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010007.outbound.protection.outlook.com [52.101.193.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8F23B4EA1;
	Thu,  9 Jul 2026 08:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783585216; cv=fail; b=LNhC5uYaV4O6Q64f5Md1dFTS7WArDHENaiP63xe5YlFGT+SDoZc0kZgPivSN+ei3a65Jt3de6djvqWOTf0UKcVwD4KXaI07kp1nqJeZYLbMiav+7D7jMxiYGxcOnoIXub4VPsFI06ojuvhU84xXb3Wi4+WBKav+1TWYcrfQUyZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783585216; c=relaxed/simple;
	bh=VO3J/wnJDVczUsSnaVTFKW5ndpF0MC36pEDXj/1kRzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ec8djm6IL6tLYElJypfAI+F5Ndu8V1cl0RORSTnt14hJuQzAZ5C9t65d9jA/QhqAbi1m6TN72K/p+S5kmozinnp89kOFBw8z7v80/8DcvKLfim75/HTu0/HjaKieaED4O09ovJ+eBQ+g9MLfLlfmuEJF4DvjAHgCLTYKSmJbkU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oTOBkSF7; arc=fail smtp.client-ip=52.101.193.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oTOBkSF7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkH2iAsU6PCPvQugDukb4xJRaczbh5e3FHJ4p33kcaHPkXuhuSZP9Sdww/Vw90p7iMg/KU3UJDxZvajVloGa1KkCyG8q3zi/FUP2UU4vYLTcPEdahRj5TRg+g0F1+d82v30H0mKxbVqHxPMN57AuVXXLfbgC0LFytg8EhDXIEaNiHA8Df8B0pQgFVqoAMdXHxkXaIFIaL6Si7+GiUc689fzNX23BIRKHPQDA1X+UfCTUvyLRV0QUQ1SNJW4E1sorcIhZErYyD38Ky5WxXI5JYM0spJiMrGcHY8F9318PlMiNlaS3d4T77SKroZpzw2NYp9WZeHL6sQUjhgeC8J6SkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnpylDDpXFDqb4xraZl9V4l5dCAIomt6pw60LE1Hkpo=;
 b=Vdy0P2ukChrYfDJND06UrjZsFM8Xw5LF+4L4U0pG4ZjCDnG9Lt6M0J0saFA3UAMGOE3vi0aFQnzK34LA3qm+9vR0FbnKmPDEKRQkLboIAgsnWGhWWihtbfIwb51+1HP60HwBBzuYKEkaW5zDGDYbrwqXmagdp6IQ1GDyYEZmj97U5q9ykr6cBMQbttI27LXd0LRRL+E4YOsTio+OqiFjlO36Uk+wa9n9qV/hyrDiFKYatbcjAdyCknQEpf27Q/u7mpqiTP8Q+Gwc+AEomM4Vdf1EH39+hqReV7iLi4dhQVNWBPmAw+l5GMgaW0iCNhPU6ggykodGkRT5KqfWI0na3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnpylDDpXFDqb4xraZl9V4l5dCAIomt6pw60LE1Hkpo=;
 b=oTOBkSF7trkJkRHQyfYLugr75LlUN9T98UOPUzbA+x2prRnfduHg5C2N4wfEAuSjORHEYGHvr4V7Of/W4Vi39nVnJsRj1oGPqh5vVdCvI5uCUz2p2f66ZbBDDy82cHgPUIAzuIDpGVPsGu3IrR0IdtczNq2SSCvGI97x6ivrS66oj172Rl262mIXrXwDNA8ShEVpi5dlQek6UYNYiiE1LZLw3REPB55p/TL5+lD0FsS0ovaJpPw6WicWUIXtBDsBCmuarnTyEQjehdX84IHzstDdj4vaC/tyojDVZp96+ZNrAEq6FcPFJPSCC8jv3mZmwBO5LbIknnjNedZGLJ7wWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by DS0PR12MB7778.namprd12.prod.outlook.com (2603:10b6:8:151::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 08:20:06 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 08:20:06 +0000
Date: Thu, 9 Jul 2026 16:20:00 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org, osalvador@suse.de, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org, 
	iweiny@kernel.org, Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 10/10] selftests/dax: add dax/kmem hotplug sysfs
 regression test
Message-ID: <ak9Y1UTTe3Hl6rVN@MWDK4CY14F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-11-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630211842.2252800-11-gourry@gourry.net>
X-ClientProxiedBy: TP0P295CA0044.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:4::6)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|DS0PR12MB7778:EE_
X-MS-Office365-Filtering-Correlation-Id: 299f9348-af33-474f-4a46-08dedd92e1e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|56012099006|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BrsxZ8JDybGzRVmgM5z+JHZ2YbjJmO7seJZ07FlRNOkAtDWpAd5a+A2jPEGo3V2O7CbNOjGBWhjemTzwNV561r17xXfhamrEAfYWBtgRE+EysWtDHcNhN0XfUhkriXhhx1E2zat/Hv+gCtvbLa3ovXMmQbFjsJhcTnA+OAe0tHCPgpIrQDgVuczF7VAIkYqqP1F71QVZR/PpzrDUxa8mKcC0JGTO+JtpXIWAIPV//cp1fK4lkeVLfNYyU7WLtMRkVcDBSO96DEpc8wGMux9lMR1quDvMzsjNuUiXUE+6BUC3v3SKWo4ncGlo47bkn2cmMENfwSwv4uv5f/sPU1TXo9QtZZGl2lcsY4ED0tIZYZkQTHbS1XQFzDd4WyNSp2w7E7c3IcE8x3ZL5bqKXjk2ckCk4HXBhOSzZhhC0WErbyVgbCAMDBbsT7iCfwrXYQtleZnmGp7ATr5ZV86s/3yHc+TCLmZ5QysgyeNru5oxotJJoQ6UyU3P9ey1vxdaHFPDt/MDgsRCLL3f1UQuoSIJDxDPrTHeXq51wh2sDrpWbwvxaYDkiPomBS06IbkdlXoIleLj2S/t1woFU231sO/buQjdqNjBNvSkUMJJ89CuQRjXThwhW5A5mEwrF1z4T/sBSeOSYdlBbR4238Ovhe3uWqbZd7kTj/JOExVBXIxPGdA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qhJ+MdSq5uIc3lLCDrFjdkL6Kn+YzGEiYz1hMiL/MQMXZWkhJQByTE2CSDu7?=
 =?us-ascii?Q?hLNZ/K1d89LnOGgFEe+YRb2JrHQyJ4JO7ABpozCi3KJIXLKBAd46czHlXnNV?=
 =?us-ascii?Q?ceOQEiM59M6WaqhpfkV6NAFeDZVrPiLI6l4cu3tlw2QVg4+wzEO20PHsL7M9?=
 =?us-ascii?Q?dBGnvLdMuCxA2hiQncCIcjsriHY3rP2km7Fd8tBNNO2NZFNyEUDO3VuqfsqA?=
 =?us-ascii?Q?9cU6JCRykPQqzqhSgZ4edp7LimCvn3KwdM4oUh46BOdZ1zvD11G4K68uyRji?=
 =?us-ascii?Q?YHz/GAyx0auttbvSDYjKWZv/hQecty5POcwHdC0EveMnq9cWs7rQpZIqomcz?=
 =?us-ascii?Q?7BWEVs/g3UYmNN8W14gM01DSY4hvZnl0q5qE1uIMd3jKmwRK184hcs8i1mGs?=
 =?us-ascii?Q?c7P4WHfkva19ViQqdG0hjD9nY61Jb7guXUKysC9/fYZ+vhPOAlyTe626+tdE?=
 =?us-ascii?Q?g/ZV8UIp6FL0RsRRK/YMHF1Db6HsE8bh+E6YBcLqlOWxtK39cA2kBYdU+1ji?=
 =?us-ascii?Q?BpO7tR8ABXmZ8vs14LzGqN7i0Z/SwUCWPcnRsHGGmtlpuw1UHb67n5/l/tAh?=
 =?us-ascii?Q?eZ/JHe+vzaZEpHe7TLC0Xv7EqzbokloH9k3Da1y1NXbv0jmM/OzTgyOcYGRs?=
 =?us-ascii?Q?M8jHl1nDBkhr1JPQj0eIjFPTkphjilk0Ono+Z7Ci2Wh65DtRgmJNH7dPAdy7?=
 =?us-ascii?Q?2iu6KhB4yJMe+AU5EAqXbLc3XeGf2OM5PxOYD49C1avsxpkt4JR/eFXNRwSI?=
 =?us-ascii?Q?NAMNVtA9WjiCnIWZ5qv7YbU0jgVFl5NfURb+uq60a5WK5zC5jIgRk33zd7D3?=
 =?us-ascii?Q?SOeXtXAQ1qlZUDW8WuvEF37KGOb+9EVdkBPTQc2w5uh6V01eSlLLD+FiR0Ny?=
 =?us-ascii?Q?Wa/I0ZLLEERYGGo7fBW19FVvUXx7YbOjaX/jpv+6A84+YRJgHZTtnwOBU7++?=
 =?us-ascii?Q?fMP1xAMIULZ/SSLUMtE/TfaaKUaZpUNHUSHf0pKJVBvP7Q3/0T0XAjx09eNs?=
 =?us-ascii?Q?nyDeWlaifVgrIn4qCvaPfZZX+AvTzrhv4pG6vQ0nECLH+APmW57bK7xAnYbm?=
 =?us-ascii?Q?CJIZXq/Ly6KyiT6Kn08pxbiT5EI7dmbnsAb8C28fXqBzLajSA4pTEMHcOSQk?=
 =?us-ascii?Q?NGYY7DhhQR0mSuBMawZCjIqa+ZGM0mIw3Atpf6PoJ5LHPbXzT8zH0Ozk5o9E?=
 =?us-ascii?Q?f7ktzHa4y6NBWBqEmFWZfURiPIRrx9BW5b2/rU3Lp5E4qExiEXyig5uiFAqq?=
 =?us-ascii?Q?YWlzKo4WhoRdo4WUesws8rkzNqlIVh9CeWdektnPoMtg3abefAbj3+Ul4rpa?=
 =?us-ascii?Q?4ZVvRDIJ/VFI++pCdarKWiEfV8e9H+ZmJIX0dnJueQ19x53jDWbTnMHu8h8O?=
 =?us-ascii?Q?frVKhXaJZGNVPA/oedsTITrycSC9hetWevsnaaSz8XGK1SXhSjdg0zOvOhQt?=
 =?us-ascii?Q?qmY8w8JNIkTN1ms2mFMzXyiJ4Y8Ku66/wim2jcQw5ftrENy2/xnbQ+2ENU0h?=
 =?us-ascii?Q?aoyt0DgQQWqEsz4mSH+fwQGcRXmWtUdNzbq1ngE0uXnX8NgHMO1rw1BlabMN?=
 =?us-ascii?Q?+gxhZtZPU728YhJ9hxDYx3h93YIHO8nxIvzo+lEFt7ZuIn4EBf7/TUlw+uiG?=
 =?us-ascii?Q?63vMRhA/SyY3RLN8kwJryXbUtwArns3inW1sq0MF5/cYn0bnosCgMN1xYtxn?=
 =?us-ascii?Q?MXlQD9DTlitDi/WS9aGYB8kqj34fUNEDU93XxeQtCBnLRYK+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 299f9348-af33-474f-4a46-08dedd92e1e5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 08:20:06.1553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Of+FKjXXrgGFJMbQ/eAryv0p80G/dCPv9lMWvP00yC7mYeYsYsCztWZH6eG8Qdu0AruJFaJlL8a9E2JqYxURnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7778

On Tue, Jun 30, 2026 at 05:18:42PM +0800, Gregory Price wrote:
> Add a kselftest for the dax/kmem whole-device "state" sysfs attribute
> (/sys/bus/dax/devices/daxX.Y/state), which transitions a kmem-backed
> dax device between "unplugged", "online" and "online_movable".
> 
> The kselftest also includes a test to demonstrate the force-unbind
> does not deadlock - but this is a destructive test.  The dax device
> can never be rebound after doing this.
> 
> Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
> out of scope for an in-tree selftest, so the test discovers an already
> kmem-bound dax device and SKIPs when none are present or the memory
> cannot be freed to reach a known baseline.
> 
> When a device is available it validates the interface contract:
>   - online / online_movable actually add memory (MemTotal grows),
>   - online is idempotent,
>   - switching between online types without unplug is rejected,
>   - unplug removes memory and the reported state is "unplugged"
>   - invalid input is rejected.
> 
> One specific regression test:
>     online -> unplug -> online_movable -> unplug
> 
> Re-online must re-reserve per-range resources so subsequent unplug
> actually offlines and removes instead of silently reporting success
> while the memory stays online.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  tools/testing/selftests/Makefile              |   1 +
>  tools/testing/selftests/dax/Makefile          |   6 +
>  tools/testing/selftests/dax/config            |   4 +
>  .../testing/selftests/dax/dax-kmem-hotplug.sh | 190 ++++++++++++++++++
>  tools/testing/selftests/dax/settings          |   1 +
>  5 files changed, 202 insertions(+)
>  create mode 100644 tools/testing/selftests/dax/Makefile
>  create mode 100644 tools/testing/selftests/dax/config
>  create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
>  create mode 100644 tools/testing/selftests/dax/settings
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 6e59b8f63e41..8c2b4f97619c 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -14,6 +14,7 @@ TARGETS += core
>  TARGETS += cpufreq
>  TARGETS += cpu-hotplug
>  TARGETS += damon
> +TARGETS += dax
>  TARGETS += devices/error_logs
>  TARGETS += devices/probe
>  TARGETS += dmabuf-heaps
> diff --git a/tools/testing/selftests/dax/Makefile b/tools/testing/selftests/dax/Makefile
> new file mode 100644
> index 000000000000..25a4f3d73a5b
> --- /dev/null
> +++ b/tools/testing/selftests/dax/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +all:
> +
> +TEST_PROGS := dax-kmem-hotplug.sh
> +
> +include ../lib.mk
> diff --git a/tools/testing/selftests/dax/config b/tools/testing/selftests/dax/config
> new file mode 100644
> index 000000000000..4c9aaeb6ceb4
> --- /dev/null
> +++ b/tools/testing/selftests/dax/config
> @@ -0,0 +1,4 @@
> +CONFIG_DEV_DAX=m
> +CONFIG_DEV_DAX_KMEM=m
> +CONFIG_MEMORY_HOTPLUG=y
> +CONFIG_MEMORY_HOTREMOVE=y
> diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
> new file mode 100755
> index 000000000000..c8bbaf6178ed
> --- /dev/null
> +++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
> @@ -0,0 +1,190 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Exercise the dax/kmem "state" sysfs attribute:
> +#   /sys/bus/dax/devices/daxX.Y/state  ->  unplugged | online | online_kernel | online_movable
> +#
> +# The test needs a dax device already bound to the kmem driver.
> +# If no suitable device is found the tests SKIP.
> +#
> +# A dax device can be provisioned with the memmap= boot param, e.g.:
> +#   memmap=2G!4G
> +#
> +# then, in the booted system:
> +#
> +#   ndctl create-namespace -m devdax -e namespace0.0 -f
> +#   daxctl reconfigure-device -N -m system-ram dax0.0   # bind kmem
> +#   ./dax-kmem-hotplug.sh
> +
> +# shellcheck disable=SC1091
> +DIR="$(dirname "$(readlink -f "$0")")"
> +. "$DIR"/../kselftest/ktap_helpers.sh
> +
> +DAX_BASE=/sys/bus/dax/devices
> +
> +memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
> +get_state() { cat "$HP" 2>/dev/null; }
> +# set_state STATE -- write a state to the state attribute; returns the
> +# write's exit status (0 = accepted by the kernel)
> +set_state() { echo "$1" > "$HP" 2>/dev/null; }
> +
> +find_kmem_dax() {
> +	local d drv
> +	for d in "$DAX_BASE"/dax*; do
> +		[ -e "$d/state" ] || continue
> +		drv=$(readlink "$d/driver" 2>/dev/null)
> +		[ "$(basename "${drv:-}")" = kmem ] || continue
> +		basename "$d"
> +		return 0
> +	done
> +	return 1
> +}

It picks the first kmem-bound dax device and runs online/offline cycles on it.
If the selected device is a real device with production usage, offlining movable
memory will migrate all in-use pages.

Could the destructive parts be gated behind an opt-in, e.g. an environment var ?
Or find the testable backend device instead of just picking the first one?

Best regards,
Richard Cheng.

> +
> +ktap_print_header
> +
> +if [ "$UID" != 0 ]; then
> +	ktap_skip_all "must be run as root"
> +	exit "$KSFT_SKIP"
> +fi
> +
> +DAX=$(find_kmem_dax)
> +if [ -z "$DAX" ]; then
> +	ktap_skip_all "no kmem-bound dax device with a state attribute"
> +	exit "$KSFT_SKIP"
> +fi
> +HP=$DAX_BASE/$DAX/state
> +ORIG=$(get_state)
> +
> +# A failure to reach the baseline is environmental (memory in use), not an
> +# interface failure, so skip rather than fail.
> +set_state unplugged; rc=$?
> +if [ "$rc" != 0 ] || [ "$(get_state)" != unplugged ]; then
> +	ktap_skip_all "$DAX: cannot reach 'unplugged' baseline (memory in use?)"
> +	[ -n "$ORIG" ] && set_state "$ORIG"
> +	exit "$KSFT_SKIP"
> +fi
> +mt_unplugged=$(memtotal_kb)
> +
> +DRV=/sys/bus/dax/drivers/kmem
> +AOB=/sys/devices/system/memory/auto_online_blocks
> +
> +ktap_print_msg "using $DAX (initial state was: $ORIG)"
> +ktap_set_plan 8
> +
> +# A public (N_MEMORY) kmem node onlined into a kernel zone (online/online_kernel)
> +# collects unmovable allocations and can then never be offlined, which would
> +# wedge the device for the rest of this test.  So this test only ever
> +# successfully onlines online_movable, the one mode that is reliably unpluggable.
> +
> +set_state online_movable; rc=$?
> +mt_online=$(memtotal_kb)
> +if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
> +	ktap_test_pass "online_movable: state=online_movable, MemTotal $mt_unplugged -> $mt_online kB"
> +else
> +	ktap_test_fail "online_movable: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
> +fi
> +
> +set_state online_movable; rc=$?
> +if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ]; then
> +	ktap_test_pass "online_movable idempotent"
> +else
> +	ktap_test_fail "online_movable idempotent: rc=$rc state=$(get_state)"
> +fi
> +
> +# A different online type is rejected without an intervening unplug.  The write
> +# is refused before any hotplug, so this never actually onlines a kernel zone.
> +set_state online_kernel; rc=$?
> +if [ "$rc" != 0 ] && [ "$(get_state)" = online_movable ]; then
> +	ktap_test_pass "reject online_kernel without intervening unplug (no kernel-zone online)"
> +else
> +	ktap_test_fail "online_movable->online_kernel not rejected: rc=$rc state=$(get_state)"
> +fi
> +
> +set_state unplugged; rc=$?
> +mt=$(memtotal_kb)
> +if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
> +	ktap_test_pass "unplug from online_movable: MemTotal $mt_online -> $mt kB"
> +else
> +	ktap_test_fail "unplug from online_movable: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
> +fi
> +
> +before=$(get_state)
> +set_state bogus_state; rc=$?
> +if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
> +	ktap_test_pass "reject invalid state string"
> +else
> +	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
> +fi
> +
> +# The online_movable -> unplug cycle once regressed: a re-online failed to
> +# re-reserve the per-range resources, so a later unplug reported success while
> +# leaving the memory online.  Assert each iteration really adds and frees memory.
> +set_state unplugged
> +cycle_ok=1; fail_i=0; on=0; off=0
> +for i in 1 2 3; do
> +	if ! set_state online_movable; then cycle_ok=0; fail_i=$i; break; fi
> +	on=$(memtotal_kb)
> +	if ! set_state unplugged; then cycle_ok=0; fail_i=$i; break; fi
> +	off=$(memtotal_kb)
> +	if [ "$on" -le "$mt_unplugged" ] || [ "$off" -ge "$on" ]; then
> +		cycle_ok=0; fail_i=$i; break
> +	fi
> +done
> +if [ "$cycle_ok" = 1 ]; then
> +	ktap_test_pass "online_movable/unplug cycle re-acquires resources (3x: added and freed each time)"
> +else
> +	ktap_test_fail "online_movable/unplug cycle regressed at iteration $fail_i (on=$on off=$off baseline=$mt_unplugged)"
> +fi
> +
> +# change system default online policy while the device is unbound, and show
> +# the new system default policy is utilized across bindings.
> +set_state unplugged
> +if [ -w "$AOB" ] && [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
> +	orig_aob=$(cat "$AOB")
> +	echo "$DAX" > "$DRV/unbind" 2>/dev/null
> +	echo offline > "$AOB" 2>/dev/null
> +	echo "$DAX" > "$DRV/bind" 2>/dev/null
> +	sleep 1
> +	st=$(get_state)
> +	echo "$orig_aob" > "$AOB" 2>/dev/null		# restore system policy
> +	if [ "$st" = offline ]; then
> +		ktap_test_pass "online policy resolved at bind: auto_online_blocks=offline -> state=offline"
> +	else
> +		ktap_test_fail "bind-time policy not honored: state=$st (expected offline)"
> +	fi
> +	set_state unplugged 2>/dev/null
> +else
> +	ktap_test_skip "auto_online_blocks or driver bind/unbind not writable"
> +fi
> +
> +[ -n "$ORIG" ] && set_state "$ORIG"
> +
> +# DESTRUCTIVE: unbinding the driver while memory is online causes the resources
> +# to leak - but the unbind should not deadlock.  Instead the driver leaks it
> +# with a single "stuck online" warning. This leaves the memory online and the
> +# device unbound until reboot, so it runs last - and only if we can run it,
> +# leaving the restored state above untouched otherwise.  online_movable only:
> +# this test never onlines a public node into a kernel zone.
> +if [ -w "$DRV/unbind" ]; then
> +	set_state unplugged; set_state online_movable
> +fi
> +if [ "$(get_state)" = online_movable ] && [ -w "$DRV/unbind" ]; then
> +	mt_on=$(memtotal_kb)
> +	dmesg -C 2>/dev/null
> +	echo "$DAX" > "$DRV/unbind" 2>/dev/null
> +	mt_after=$(memtotal_kb)
> +	# The leaked "System RAM (kmem)" regions stay in the iomem tree; reading
> +	# their names dereferences res_name, which a buggy unbind already freed.
> +	# Walk /proc/iomem to provoke that use-after-free (caught by KASAN).
> +	cat /proc/iomem > /dev/null 2>&1
> +	splat=$(dmesg 2>/dev/null | grep -ciE "KASAN|BUG:|use-after-free|general protection|Oops|refcount_t")
> +	if [ "$splat" = 0 ] && [ "$mt_after" -ge "$mt_on" ]; then
> +		ktap_test_pass "unbind while online: memory left online, no UAF/oops (MemTotal $mt_on -> $mt_after kB)"
> +	else
> +		ktap_test_fail "unbind while online regressed: splat=$splat MemTotal $mt_on -> $mt_after kB"
> +	fi
> +else
> +	ktap_test_skip "could not online device for unbind-while-online test"
> +fi
> +
> +ktap_finished
> diff --git a/tools/testing/selftests/dax/settings b/tools/testing/selftests/dax/settings
> new file mode 100644
> index 000000000000..ba4d85f74cd6
> --- /dev/null
> +++ b/tools/testing/selftests/dax/settings
> @@ -0,0 +1 @@
> +timeout=90
> -- 
> 2.53.0-Meta
> 
> 
