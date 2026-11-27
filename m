Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795766975;
	b=UcxftScbotLICB9XjRojCkdQBH4AE0HurXyQprwUNl/FtRfzNFs03bWYqfXJiptPIFMp
	 FaGwUvr8jcBCN1rfWjRyW285jLl2jHlCRQ+kKhtYryMP0vlyuHbPQTiowCh0k6c7TzykD
	 g812COyFWiVOubibVmfb4tEfHc5iqgcx6XALM48TvlhVuNXGPuN99RwdFoXn+jOOIqq3t
	 GqEwfoIVHxqyozsGl60OqxAogykffayIX/bmfUNd9O6m/hwqI5J5KBXYGvON2iPaaq3Nx
	 /HcxhzUCepOSZM089K0Fg0ersTKr8PxhvHubLDiu2fcA0gp5dmpbTObdIrwBBIosmKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795766975;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=fl9OTnQ0HUwo/Hu/H6RpFvjTqpBEuQGjyomK+35wjN8=;
	b=x5f/DIaFk5TwUXlKYk93Kxfr55BT7b3csxtTMDw6GK4/SxZM7akdYXc5RWhpknYveadU
	 YHWRuRe1iph9MbrciEirz15+0B0a1vrQeDW+gDZD1M8hikB7C7ZVifxxouEGZd4oNM5RQ
	 kroPDG8uIdqnx8PTeJLmVqS9eevAqdre+Ii13DFogNDvNIqkKMchRGY+90WxmY+To0b+G
	 ydwKmyHIUbbW046mhuZaiYgwgQbr3qvTaFNOZEvOrm3bGPH3VPMQWFxx0pgjPYirdawd2
	 Ta6BqhLqy8OSNAezVg/A0EVEO7p4ck+B4BafMvy4PkJGunncMn68Ak/Wg6E3FCmz22A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VFpGs6LJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.21
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C41606A31C;
	Fri, 27 Nov 2026 08:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42C41606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VFpGs6LJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B6at2kTNIjEye7CpN4DO/0xk0ps+JyKqfPczqODa3BdeGq2FIPoK+4kdRf5eSaJpb4QJ6g/762s5oUg85QHn7gKAtg+9hsXWee0WTnWN568XzFd1bQfr5OrIsK/lmftC+MsBAFJYX0mgEYTR03mwVx4uWMLkut7ZAX4ZgC9mEivz9akl63f5ELRHEFianZdyqOiD46wVEAA3mQMg3C4cJQj3nF1eS6gKbMq2oIYmzW/O8/YntzK2WEkdx+p7YZz2muUPV0znepf7b7zKTCQqfoZAUNUqmilsrunUrZOXgpDV0PkG+EwXPgNjeQWn++UUT574KOJzycmb1vwob0X6HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fl9OTnQ0HUwo/Hu/H6RpFvjTqpBEuQGjyomK+35wjN8=;
 b=cKHsJak6kWY7Psem7ikmpt+IUiQ/8JzZcqodeew0ztfozkry7JgCNsrSfoGv7w2yZLzuYEi/MF7Q0Xtz8XOGrmM/AmPDPSeaHaw2yxEZEti6nt8xFJBs2cKLBY212/X2A4+5g5GFuWDDXCqhu1Cczfy94AbjbO4H2ZlAZPDcijtf6BLKinFrOKQM5oPDNVHFNIVGfcLMpPZ9tXdnyGoM7p4e7l+cz/78g5RZABBe0aCJO/ODVfQnphIDllqTIUFbAlrWTxBCijlg/M9ZpKfCG69+5FUGGTfVP8KXuDPxgezmBK0VEjB3lNPqvfgKT42+noij/mLJfHPgtnCuz7wtpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fl9OTnQ0HUwo/Hu/H6RpFvjTqpBEuQGjyomK+35wjN8=;
 b=VFpGs6LJ2Y8FXB/m9o3BZ7By22Qk8F0Zmxdj2bsCm9NMgNqsNlMK/7cIcuz6kd60iDCjpHeUPQBoTV+fxTq6qnxj17P7E2lkwoh5S1gBat/Z802pfo6xmzGwY4SRCIn072TlFw7k8rJw2Lp6uQmSpYK/YwB0T552bXIW1n1V4F6SV5wgxqsbhlJlWvEjg+UI2w7yRACvGPEg8R27xpGqZEAQt7IjDx0z28JrC3O+8pzNBIf33o6Xp9Pna0umLaPuJH3cfMAFx7nBejApreE4RxSTQ7/G6Hy1Quy+KPzJ7gS/nB+CWk85YxVPsUc3Or8gpkz7KpwLfkk3fEKOrO9wqg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA3PR12MB899783.namprd12.prod.outlook.com
 (2603:10b6:208:621::11) by PH0PR12MB8152.namprd12.prod.outlook.com
 (2603:10b6:510:292::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Fri, 27 Nov
 2026 08:09:19 +0000
Received: from IA3PR12MB899783.namprd12.prod.outlook.com
 ([fe80::63e7:e9f3:6663:c1b0]) by IA3PR12MB899783.namprd12.prod.outlook.com
 ([fe80::63e7:e9f3:6663:c1b0%5]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 08:09:19 +0000
Date: Fri, 27 Nov 2026 16:09:11 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Chanwoo Choi <cw00.choi@samsung.com>, 
	MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, 
	Heiko Stuebner <heiko@sntech.de>, Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>, 
	Moritz Fischer <mdf@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Mike Leach <mike.leach@arm.com>, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Sizhe Liu <liusizhe5@huawei.com>, 
	Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, Haren Myneni <haren@linux.ibm.com>, 
	Rick Lindsley <ricklind@linux.ibm.com>, Nick Child <nnac123@linux.ibm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Marcin Wojtas <marcin.s.wojtas@gmail.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Cameron <jic23@kernel.org>, 
	Jing Zhang <renyu.zj@linux.alibaba.com>, Frank Li <Frank.li@nxp.com>, Xu Yang <xu.yang_2@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, Yushan Wang <wangyushan12@huawei.com>, 
	Jijie Shao <shaojijie@huawei.com>, Gowthami Thiagarajan <gthiagarajan@marvell.com>, 
	Geetha sowjanya <gakula@marvell.com>, Justin Tee <justin.tee@broadcom.com>, 
	Paul Ely <paul.ely@broadcom.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-fpga@vger.kernel.org, coresight@lists.linaro.org, 
	iommu@lists.linux.dev, linux-raid@vger.kernel.org, netdev@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-cxl@vger.kernel.org, imx@lists.linux.dev, 
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: Re: [PATCH] cpu/hotplug: Rename cpuhp_remove_multi_state to be
 symmetric with setup
Message-ID: <awk6TGp9riwDD55i@MWDK4CY14F>
References: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
X-ClientProxiedBy: SI2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:195::20) To IA3PR12MB899783.namprd12.prod.outlook.com
 (2603:10b6:208:621::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA3PR12MB899783:EE_|PH0PR12MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: 224fbf9d-2a7e-4e25-00ad-08df4c5dbc7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|5023799004|11063799006|6133799003|261009221227099003|261009223027099003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261021135927099003|261021123027099003|261022115727099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	AxMTX+rLOJfJPhsiWc+BT3/bn6XNgASHPOl+w0CUTYyr7ztXS+/hiObvphHyaCinp7aGbXYtbF7DUBn1qFUWh5t3jbaOnAgxqD8U/utHcxkwOQcOZosFIczKYPhB2LxSnFS8igbAaYSEFF1PYgPVW3naeiAHSIlEUEK5Qd9v1FC/ggHQLekOZ8cfIv45bQBeNeTb6GJFpX0+8Q7Jrt2kQ0paGjHCbuSz5vcvIGFrSm5zDLFg2Ok0wk9T9k9WfTuxsyKgqfUDG134B8R2Bl7EHOoBvmYfnrHIjLjcym7LqmnRn/2hWcZA6fSiB3kxe3vBzg6J/Wm1ii3YN4dSeEH8eL6tfKYBln9zkDuq3cC5If3begfXVpfbFHRV3r0HsHwF+eOofRRWR/1lxCECDFB+l6/mQw7+n4tO1vphyFUJE3rbPMcxyG83xk2Cbp/LmTrBbPhcjXuKwzh6Gsa+Du4Hecb/KxtR9gFyvYMIrD3I88jPcc/RiLVcbK2ww87h4C3t2gTsDhU5IyAmPtQEDZ9FDmNsMkRBwI9ysh7I43yRhik/thsXgCFT1Jn3ASHY19W/2noBFfzhNGKlXVIxmGK9Z8JcxzeSHC8aU4RQHBVOcX1EvYBhv3EQREuiXLZMnQBlYlvNP6Q0c8YeMbMyolj3/XujhN0F4CXzaDZ5/m0HyIU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR12MB899783.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(5023799004)(11063799006)(6133799003)(261009221227099003)(261009223027099003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261021135927099003)(261021123027099003)(261022115727099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M9IzqqFKSFoYadXOpEWhEA2W4GIjOQoFG16/xk70fr1VUq2Wx0BfqauciwaO?=
 =?us-ascii?Q?1UEhWuTEQglUJI4nvZkKh7ta6rYkudCYEWMvGCnOHuEOYcHcKziJ3TqbMce/?=
 =?us-ascii?Q?53KG29rHeD3SuJQV54fc1SqseV9ibq8y8ZJoQuDVszyn32lkPeUttOg6yOXE?=
 =?us-ascii?Q?+4mRhNZjfjtUw9UVfPmnuMSrABw2lxomWFAfwFFVmXGrGhF8XtcNJbIkctfZ?=
 =?us-ascii?Q?E6WR8IvbQgZBc11w0IUaTMC9t4V7Rn7epW0JXLLXGttvD9ftccAd/jg0tSup?=
 =?us-ascii?Q?fzlV5SucLlYiEedGJMcxwmGvCINlYgRtxoLPdhzdUI57tlHl+b7PQUb7EcpY?=
 =?us-ascii?Q?lSvF3/R8yH8O1aAd8GUWmCq1V98lf+Bt/bxbXm9hGc5zQBGRt4LHykQua9ww?=
 =?us-ascii?Q?08GALNna+3JDOesp9VkH4izWykY/edK++rFzS4UWFJ9+bF0l9Ljvf2LmwdpS?=
 =?us-ascii?Q?wmSsVynC5cQn63Wi6TqvG+HIk4udNrqglr3dq34FVf9LNpuSD+ipgEWKwG58?=
 =?us-ascii?Q?PjVHntk/r65plH5aCLh1mD8+23g5rKzVF5t2gMJYZT8VA8hW4VvyEr9Y/T9a?=
 =?us-ascii?Q?drYekoHMGC5FC7LdORrpG0cNK+lZLjsmWIYjko7qqnx1u7lnMIbZo+Jnuk6h?=
 =?us-ascii?Q?4a6MNz2PF4s/evA2a68Ak9KusByOXH6efWAJ0vjR3Hw+CUjOE6b6mFay5BbN?=
 =?us-ascii?Q?cb+ZCeH0tc34qVzYdHbPrT0ObgQC/2k0luQtt6/0w0Krj5NNhJrnA++0LPbC?=
 =?us-ascii?Q?2lmev0ZA7pZfhKsfH8I4PCxeudIRHfV67KoVCEijelIo94uMYOG27af9Mg4l?=
 =?us-ascii?Q?FlJjY9n1vc5NYqWozmBpccaAfSiR+tuZBPH2a4iBKpaDj4ePcCaM715GdYsA?=
 =?us-ascii?Q?X4Y8lagfN87qstfm/ZeTQbZef2A/7bNWjPMIhh3E0SS9Kaps7gI2rJY9x9ww?=
 =?us-ascii?Q?V+eew3xncUDloxcPnEKRgMYuqUI1xRcdzmPj4SC+liBonpoxTEeWRIioLwL3?=
 =?us-ascii?Q?b/CRNxZsJI+liMtrsfyL5tFloQ1Rbc4w5k5/iMxeNRET/wv9ERT6U1G+kpO7?=
 =?us-ascii?Q?Y7Cbz1LtWRFgvEbKhCzEZQyPonubr2RbqtyjBDoWC3Cay4xUP485JVqLQYnl?=
 =?us-ascii?Q?cmCUv/rcIGuMpnYgUclj/UKaijeLnwN+Vz5qTDs7acF4d/MQO6KYJVOPC0P3?=
 =?us-ascii?Q?/nbS2CJKz1PK7lMRB+S8T/I5SJ00+YaDsdSGZ1epwy1vgHaYYOp/VCikpCof?=
 =?us-ascii?Q?5aEkuxCWIvMYBdCYQo9K5Ufid+YphCHb9xeb621kIaFnM2kGOrOeuaTr/Vbp?=
 =?us-ascii?Q?WaLpjjAvBUR4ObwpJgqSrGLGSpW6j2rXTdkCONjy9k/nURFOiA1nu6iqeOqN?=
 =?us-ascii?Q?nvuQBDuXURwHVbx/gLU9yXxS8FNczttqsIWywnjd9cc9OmTRHnS4hO2c4Nkd?=
 =?us-ascii?Q?ZR62gBgw4EN574mskrTH0LUo0XVTzTCgm3JjZ8uL0kyHzXChygAgUB9E3Wi0?=
 =?us-ascii?Q?sjDDCnmbUP3JuBkY5pOENE26eo43Z8U/gkBgu7Ns2h5xObmMMqOGmUcbXBp+?=
 =?us-ascii?Q?2b1oFf9JUfTRzdNkaXHRmDdCcEym2aTFjkTThexb73Oy+TLT3VUcvMOYSQHy?=
 =?us-ascii?Q?fyWbEj0Sem96+L82E/Nof1YmXm6FyosfZe/dXVjtOpiP53Brxm0sPD7/Ylk6?=
 =?us-ascii?Q?jcxILYNSsEK9LugtBuqtuVfbAlCeRYaOWG0LxK/2+ajsIFue6nbuXFgLK5Zm?=
 =?us-ascii?Q?y1GqvbVDCQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 224fbf9d-2a7e-4e25-00ad-08df4c5dbc7c
X-MS-Exchange-CrossTenant-AuthSource: IA3PR12MB899783.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 08:09:19.0750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +AWSsqNl0zVmSWUvGlqI0VHjBTqTC5mdDt9axt088mK5P8X/SbaefspEpTGH0ee2VN6sF5avadOH1W4B1E+SNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8152

On Fri, Nov 27, 2026 at 01:07:40PM +0800, Srivatsa S. Bhat (Microsoft) wrote:
> The multi-instance CPU hotplug state setup API is named as
> cpuhp_setup_state_multi(), whereas the corresponding remove API is
> currently named as cpuhp_remove_multi_state(). Rename the latter as
> cpuhp_remove_state_multi() to fix the asymmetry. This also helps
> maintain consistency in the API names by letting them share a common
> prefix, i.e., cpuhp_setup/remove_state_*() across all the variants
> [none|nocalls|nocalls_cpuslocked].
> 
> Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>

Hi Srivatsa,

Not sure whether this is really needed, it doesn't harm anything,
but IMHO it doesn't really brings us benefit.

Best regards,
Richard Cheng.

> ---
> Performing the API rename in
> Documentation/translations/zh_CN/core-api/cpu_hotplug.rst is left as a
> to-do, as I don't know how to edit that file correctly, and didn't want
> to mess up the translation in the process. If someone can help do the
> rename in that file safely, that would be much appreciated!
> ---
>  Documentation/core-api/cpu_hotplug.rst       | 6 +++---
>  drivers/block/zram/zram_drv.c                | 6 +++---
>  drivers/devfreq/event/rockchip-dfi.c         | 2 +-
>  drivers/fpga/dfl-fme-perf.c                  | 4 ++--
>  drivers/hwtracing/coresight/coresight-trbe.c | 4 ++--
>  drivers/hwtracing/ptt/hisi_ptt.c             | 4 ++--
>  drivers/iommu/iova.c                         | 2 +-
>  drivers/md/raid5.c                           | 4 ++--
>  drivers/net/ethernet/ibm/ibmvnic.c           | 8 ++++----
>  drivers/net/ethernet/marvell/mvneta.c        | 8 ++++----
>  drivers/net/virtio_net.c                     | 8 ++++----
>  drivers/nvdimm/nd_perf.c                     | 6 +++---
>  drivers/perf/alibaba_uncore_drw_pmu.c        | 4 ++--
>  drivers/perf/arm-ccn.c                       | 4 ++--
>  drivers/perf/arm-cmn.c                       | 4 ++--
>  drivers/perf/arm-ni.c                        | 4 ++--
>  drivers/perf/arm_cspmu/arm_cspmu.c           | 2 +-
>  drivers/perf/arm_dmc620_pmu.c                | 4 ++--
>  drivers/perf/arm_dsu_pmu.c                   | 4 ++--
>  drivers/perf/arm_smmuv3_pmu.c                | 4 ++--
>  drivers/perf/arm_spe_pmu.c                   | 4 ++--
>  drivers/perf/cxl_pmu.c                       | 4 ++--
>  drivers/perf/dwc_pcie_pmu.c                  | 4 ++--
>  drivers/perf/fsl_imx8_ddr_perf.c             | 4 ++--
>  drivers/perf/fsl_imx9_ddr_perf.c             | 4 ++--
>  drivers/perf/fujitsu_uncore_pmu.c            | 4 ++--
>  drivers/perf/hisilicon/hisi_pcie_pmu.c       | 4 ++--
>  drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c | 4 ++--
>  drivers/perf/hisilicon/hisi_uncore_pmu.c     | 2 +-
>  drivers/perf/hisilicon/hns3_pmu.c            | 4 ++--
>  drivers/perf/marvell_cn10k_ddr_pmu.c         | 4 ++--
>  drivers/perf/marvell_cn10k_tad_pmu.c         | 4 ++--
>  drivers/perf/marvell_pem_pmu.c               | 4 ++--
>  drivers/perf/nvidia_t410_c2c_pmu.c           | 2 +-
>  drivers/perf/nvidia_t410_cmem_latency_pmu.c  | 2 +-
>  drivers/perf/thunderx2_pmu.c                 | 4 ++--
>  drivers/scsi/lpfc/lpfc_init.c                | 4 ++--
>  include/linux/cpuhotplug.h                   | 4 ++--
>  kernel/padata.c                              | 2 +-
>  kernel/trace/trace.c                         | 2 +-
>  mm/zswap.c                                   | 2 +-
>  41 files changed, 82 insertions(+), 82 deletions(-)
> 
> diff --git a/Documentation/core-api/cpu_hotplug.rst b/Documentation/core-api/cpu_hotplug.rst
> index f8b3f59a3d5f..a387ccb08eef 100644
> --- a/Documentation/core-api/cpu_hotplug.rst
> +++ b/Documentation/core-api/cpu_hotplug.rst
> @@ -471,7 +471,7 @@ To remove a previously set up state, the following functions are provided:
>  * cpuhp_remove_state(state)
>  * cpuhp_remove_state_nocalls(state)
>  * cpuhp_remove_state_nocalls_cpuslocked(state)
> -* cpuhp_remove_multi_state(state)
> +* cpuhp_remove_state_multi(state)
>  
>  The @state argument is either a statically allocated state or the state
>  number which was allocated in the dynamic range by cpuhp_setup_state*(). If
> @@ -481,7 +481,7 @@ available for dynamic allocation again.
>  The functions differ in the way how the installed callbacks are treated:
>  
>    * cpuhp_remove_state_nocalls(), cpuhp_remove_state_nocalls_cpuslocked()
> -    and cpuhp_remove_multi_state() only remove the callbacks.
> +    and cpuhp_remove_state_multi() only remove the callbacks.
>  
>    * cpuhp_remove_state() removes the callbacks and invokes the teardown
>      callback (if not NULL) for all online CPUs which have currently a state
> @@ -611,7 +611,7 @@ ONLINE section for notifications on online and offline operation::
>     ....
>     cpuhp_state_remove_instance(state, &inst2->node);
>     ....
> -   cpuhp_remove_multi_state(state);
> +   cpuhp_remove_state_multi(state);
>  
>  
>  Testing of hotplug states
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index ab064c84b092..d152c356bd6a 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -3270,7 +3270,7 @@ static void destroy_devices(void)
>  	zram_debugfs_destroy();
>  	idr_destroy(&zram_index_idr);
>  	unregister_blkdev(zram_major, "zram");
> -	cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
> +	cpuhp_remove_state_multi(CPUHP_ZCOMP_PREPARE);
>  }
>  
>  static int __init zram_init(void)
> @@ -3288,7 +3288,7 @@ static int __init zram_init(void)
>  	ret = class_register(&zram_control_class);
>  	if (ret) {
>  		pr_err("Unable to register zram-control class\n");
> -		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
> +		cpuhp_remove_state_multi(CPUHP_ZCOMP_PREPARE);
>  		return ret;
>  	}
>  
> @@ -3297,7 +3297,7 @@ static int __init zram_init(void)
>  	if (zram_major <= 0) {
>  		pr_err("Unable to get major number\n");
>  		class_unregister(&zram_control_class);
> -		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
> +		cpuhp_remove_state_multi(CPUHP_ZCOMP_PREPARE);
>  		return -EBUSY;
>  	}
>  
> diff --git a/drivers/devfreq/event/rockchip-dfi.c b/drivers/devfreq/event/rockchip-dfi.c
> index 16b25779d2f8..137adb1b7d27 100644
> --- a/drivers/devfreq/event/rockchip-dfi.c
> +++ b/drivers/devfreq/event/rockchip-dfi.c
> @@ -614,7 +614,7 @@ static void rockchip_ddr_cpuhp_remove_state(void *data)
>  {
>  	struct rockchip_dfi *dfi = data;
>  
> -	cpuhp_remove_multi_state(dfi->cpuhp_state);
> +	cpuhp_remove_state_multi(dfi->cpuhp_state);
>  
>  	rockchip_dfi_disable(dfi);
>  }
> diff --git a/drivers/fpga/dfl-fme-perf.c b/drivers/fpga/dfl-fme-perf.c
> index a0e3abc64c9e..9cd5327ceab4 100644
> --- a/drivers/fpga/dfl-fme-perf.c
> +++ b/drivers/fpga/dfl-fme-perf.c
> @@ -998,7 +998,7 @@ static int fme_perf_init(struct platform_device *pdev,
>  pmu_register_err:
>  	cpuhp_state_remove_instance_nocalls(priv->cpuhp_state, &priv->node);
>  cpuhp_instance_err:
> -	cpuhp_remove_multi_state(priv->cpuhp_state);
> +	cpuhp_remove_state_multi(priv->cpuhp_state);
>  	return ret;
>  }
>  
> @@ -1009,7 +1009,7 @@ static void fme_perf_uinit(struct platform_device *pdev,
>  
>  	fme_perf_pmu_unregister(priv);
>  	cpuhp_state_remove_instance_nocalls(priv->cpuhp_state, &priv->node);
> -	cpuhp_remove_multi_state(priv->cpuhp_state);
> +	cpuhp_remove_state_multi(priv->cpuhp_state);
>  }
>  
>  const struct dfl_feature_id fme_perf_id_table[] = {
> diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
> index 3fa663c7f026..06d2c5b93f63 100644
> --- a/drivers/hwtracing/coresight/coresight-trbe.c
> +++ b/drivers/hwtracing/coresight/coresight-trbe.c
> @@ -1524,7 +1524,7 @@ static int arm_trbe_probe_cpuhp(struct trbe_drvdata *drvdata)
>  
>  	ret = cpuhp_state_add_instance(trbe_online, &drvdata->hotplug_node);
>  	if (ret) {
> -		cpuhp_remove_multi_state(trbe_online);
> +		cpuhp_remove_state_multi(trbe_online);
>  		return ret;
>  	}
>  	drvdata->trbe_online = trbe_online;
> @@ -1534,7 +1534,7 @@ static int arm_trbe_probe_cpuhp(struct trbe_drvdata *drvdata)
>  static void arm_trbe_remove_cpuhp(struct trbe_drvdata *drvdata)
>  {
>  	cpuhp_state_remove_instance(drvdata->trbe_online, &drvdata->hotplug_node);
> -	cpuhp_remove_multi_state(drvdata->trbe_online);
> +	cpuhp_remove_state_multi(drvdata->trbe_online);
>  }
>  
>  static int arm_trbe_probe_irq(struct platform_device *pdev,
> diff --git a/drivers/hwtracing/ptt/hisi_ptt.c b/drivers/hwtracing/ptt/hisi_ptt.c
> index 6ed65b44a4af..7d7dbc0916c1 100644
> --- a/drivers/hwtracing/ptt/hisi_ptt.c
> +++ b/drivers/hwtracing/ptt/hisi_ptt.c
> @@ -1425,7 +1425,7 @@ static int __init hisi_ptt_init(void)
>  
>  	ret = pci_register_driver(&hisi_ptt_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(hisi_ptt_pmu_online);
> +		cpuhp_remove_state_multi(hisi_ptt_pmu_online);
>  
>  	return ret;
>  }
> @@ -1434,7 +1434,7 @@ module_init(hisi_ptt_init);
>  static void __exit hisi_ptt_exit(void)
>  {
>  	pci_unregister_driver(&hisi_ptt_driver);
> -	cpuhp_remove_multi_state(hisi_ptt_pmu_online);
> +	cpuhp_remove_state_multi(hisi_ptt_pmu_online);
>  }
>  module_exit(hisi_ptt_exit);
>  
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b710e5ad37e2..266d9ce3a712 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -998,7 +998,7 @@ void iova_cache_put(void)
>  	}
>  	iova_cache_users--;
>  	if (!iova_cache_users) {
> -		cpuhp_remove_multi_state(CPUHP_IOMMU_IOVA_DEAD);
> +		cpuhp_remove_state_multi(CPUHP_IOMMU_IOVA_DEAD);
>  		kmem_cache_destroy(iova_cache);
>  		kmem_cache_destroy(iova_magazine_cache);
>  	}
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d52adf81065a..5ffa3583fc11 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -9402,7 +9402,7 @@ static int __init raid5_init(void)
>  err_unregister_raid6:
>  	unregister_md_submodule(&raid6_personality.head);
>  err_cpuhp_remove:
> -	cpuhp_remove_multi_state(CPUHP_MD_RAID5_PREPARE);
> +	cpuhp_remove_state_multi(CPUHP_MD_RAID5_PREPARE);
>  err_destroy_wq:
>  	destroy_workqueue(raid5_wq);
>  	return ret;
> @@ -9413,7 +9413,7 @@ static void __exit raid5_exit(void)
>  	unregister_md_submodule(&raid6_personality.head);
>  	unregister_md_submodule(&raid5_personality.head);
>  	unregister_md_submodule(&raid4_personality.head);
> -	cpuhp_remove_multi_state(CPUHP_MD_RAID5_PREPARE);
> +	cpuhp_remove_state_multi(CPUHP_MD_RAID5_PREPARE);
>  	destroy_workqueue(raid5_wq);
>  }
>  
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 5a510eed335e..73b3fb306333 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -6779,9 +6779,9 @@ static int __init ibmvnic_module_init(void)
>  
>  	return 0;
>  err_vio_register:
> -	cpuhp_remove_multi_state(CPUHP_IBMVNIC_DEAD);
> +	cpuhp_remove_state_multi(CPUHP_IBMVNIC_DEAD);
>  err_dead:
> -	cpuhp_remove_multi_state(ibmvnic_online);
> +	cpuhp_remove_state_multi(ibmvnic_online);
>  out:
>  	return ret;
>  }
> @@ -6789,8 +6789,8 @@ static int __init ibmvnic_module_init(void)
>  static void __exit ibmvnic_module_exit(void)
>  {
>  	vio_unregister_driver(&ibmvnic_driver);
> -	cpuhp_remove_multi_state(CPUHP_IBMVNIC_DEAD);
> -	cpuhp_remove_multi_state(ibmvnic_online);
> +	cpuhp_remove_state_multi(CPUHP_IBMVNIC_DEAD);
> +	cpuhp_remove_state_multi(ibmvnic_online);
>  }
>  
>  module_init(ibmvnic_module_init);
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 915c4c35364a..7f7a090e78b6 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -5967,9 +5967,9 @@ static int __init mvneta_driver_init(void)
>  	return 0;
>  
>  err:
> -	cpuhp_remove_multi_state(CPUHP_NET_MVNETA_DEAD);
> +	cpuhp_remove_state_multi(CPUHP_NET_MVNETA_DEAD);
>  err_dead:
> -	cpuhp_remove_multi_state(online_hpstate);
> +	cpuhp_remove_state_multi(online_hpstate);
>  out:
>  	return ret;
>  }
> @@ -5978,8 +5978,8 @@ module_init(mvneta_driver_init);
>  static void __exit mvneta_driver_exit(void)
>  {
>  	platform_driver_unregister(&mvneta_driver);
> -	cpuhp_remove_multi_state(CPUHP_NET_MVNETA_DEAD);
> -	cpuhp_remove_multi_state(online_hpstate);
> +	cpuhp_remove_state_multi(CPUHP_NET_MVNETA_DEAD);
> +	cpuhp_remove_state_multi(online_hpstate);
>  }
>  module_exit(mvneta_driver_exit);
>  
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 1cd64f9e12e7..b11f2180de47 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -7354,9 +7354,9 @@ static __init int virtio_net_driver_init(void)
>  		goto err_virtio;
>  	return 0;
>  err_virtio:
> -	cpuhp_remove_multi_state(CPUHP_VIRT_NET_DEAD);
> +	cpuhp_remove_state_multi(CPUHP_VIRT_NET_DEAD);
>  err_dead:
> -	cpuhp_remove_multi_state(virtionet_online);
> +	cpuhp_remove_state_multi(virtionet_online);
>  out:
>  	return ret;
>  }
> @@ -7365,8 +7365,8 @@ module_init(virtio_net_driver_init);
>  static __exit void virtio_net_driver_exit(void)
>  {
>  	unregister_virtio_driver(&virtio_net_driver);
> -	cpuhp_remove_multi_state(CPUHP_VIRT_NET_DEAD);
> -	cpuhp_remove_multi_state(virtionet_online);
> +	cpuhp_remove_state_multi(CPUHP_VIRT_NET_DEAD);
> +	cpuhp_remove_state_multi(virtionet_online);
>  }
>  module_exit(virtio_net_driver_exit);
>  
> diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
> index 9e497cae65b3..aec1f3d71fc4 100644
> --- a/drivers/nvdimm/nd_perf.c
> +++ b/drivers/nvdimm/nd_perf.c
> @@ -245,7 +245,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
>  	/* Register the pmu instance for cpu hotplug */
>  	rc = cpuhp_state_add_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
>  	if (rc) {
> -		cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
> +		cpuhp_remove_state_multi(nd_pmu->cpuhp_state);
>  		return rc;
>  	}
>  
> @@ -253,7 +253,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
>  	rc = create_cpumask_attr_group(nd_pmu);
>  	if (rc) {
>  		cpuhp_state_remove_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
> -		cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
> +		cpuhp_remove_state_multi(nd_pmu->cpuhp_state);
>  		return rc;
>  	}
>  
> @@ -263,7 +263,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
>  static void nvdimm_pmu_free_hotplug_memory(struct nvdimm_pmu *nd_pmu)
>  {
>  	cpuhp_state_remove_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
> -	cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
> +	cpuhp_remove_state_multi(nd_pmu->cpuhp_state);
>  
>  	if (nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR])
>  		kfree(nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]->attrs);
> diff --git a/drivers/perf/alibaba_uncore_drw_pmu.c b/drivers/perf/alibaba_uncore_drw_pmu.c
> index c47c6ac170b2..e114330d6ea8 100644
> --- a/drivers/perf/alibaba_uncore_drw_pmu.c
> +++ b/drivers/perf/alibaba_uncore_drw_pmu.c
> @@ -799,7 +799,7 @@ static int __init ali_drw_pmu_init(void)
>  
>  	ret = platform_driver_register(&ali_drw_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(ali_drw_cpuhp_state_num);
> +		cpuhp_remove_state_multi(ali_drw_cpuhp_state_num);
>  
>  	return ret;
>  }
> @@ -807,7 +807,7 @@ static int __init ali_drw_pmu_init(void)
>  static void __exit ali_drw_pmu_exit(void)
>  {
>  	platform_driver_unregister(&ali_drw_pmu_driver);
> -	cpuhp_remove_multi_state(ali_drw_cpuhp_state_num);
> +	cpuhp_remove_state_multi(ali_drw_cpuhp_state_num);
>  }
>  
>  module_init(ali_drw_pmu_init);
> diff --git a/drivers/perf/arm-ccn.c b/drivers/perf/arm-ccn.c
> index 0c69165e0041..86d6edd18c84 100644
> --- a/drivers/perf/arm-ccn.c
> +++ b/drivers/perf/arm-ccn.c
> @@ -1543,14 +1543,14 @@ static int __init arm_ccn_init(void)
>  
>  	ret = platform_driver_register(&arm_ccn_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CCN_ONLINE);
> +		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CCN_ONLINE);
>  	return ret;
>  }
>  
>  static void __exit arm_ccn_exit(void)
>  {
>  	platform_driver_unregister(&arm_ccn_driver);
> -	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CCN_ONLINE);
> +	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CCN_ONLINE);
>  }
>  
>  module_init(arm_ccn_init);
> diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
> index 68a096c1fe6b..787de602b60c 100644
> --- a/drivers/perf/arm-cmn.c
> +++ b/drivers/perf/arm-cmn.c
> @@ -2969,7 +2969,7 @@ static int __init arm_cmn_init(void)
>  
>  	ret = platform_driver_register(&arm_cmn_driver);
>  	if (ret) {
> -		cpuhp_remove_multi_state(arm_cmn_hp_state);
> +		cpuhp_remove_state_multi(arm_cmn_hp_state);
>  		debugfs_remove(arm_cmn_debugfs);
>  	}
>  	return ret;
> @@ -2978,7 +2978,7 @@ static int __init arm_cmn_init(void)
>  static void __exit arm_cmn_exit(void)
>  {
>  	platform_driver_unregister(&arm_cmn_driver);
> -	cpuhp_remove_multi_state(arm_cmn_hp_state);
> +	cpuhp_remove_state_multi(arm_cmn_hp_state);
>  	debugfs_remove(arm_cmn_debugfs);
>  }
>  
> diff --git a/drivers/perf/arm-ni.c b/drivers/perf/arm-ni.c
> index 1f8eecf8ca11..6d3e63ba8ca8 100644
> --- a/drivers/perf/arm-ni.c
> +++ b/drivers/perf/arm-ni.c
> @@ -844,14 +844,14 @@ static int __init arm_ni_init(void)
>  
>  	ret = platform_driver_register(&arm_ni_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(arm_ni_hp_state);
> +		cpuhp_remove_state_multi(arm_ni_hp_state);
>  	return ret;
>  }
>  
>  static void __exit arm_ni_exit(void)
>  {
>  	platform_driver_unregister(&arm_ni_driver);
> -	cpuhp_remove_multi_state(arm_ni_hp_state);
> +	cpuhp_remove_state_multi(arm_ni_hp_state);
>  }
>  
>  module_init(arm_ni_init);
> diff --git a/drivers/perf/arm_cspmu/arm_cspmu.c b/drivers/perf/arm_cspmu/arm_cspmu.c
> index d0b29213f451..6a43a21f2953 100644
> --- a/drivers/perf/arm_cspmu/arm_cspmu.c
> +++ b/drivers/perf/arm_cspmu/arm_cspmu.c
> @@ -1449,7 +1449,7 @@ static int __init arm_cspmu_init(void)
>  static void __exit arm_cspmu_exit(void)
>  {
>  	platform_driver_unregister(&arm_cspmu_driver);
> -	cpuhp_remove_multi_state(arm_cspmu_cpuhp_state);
> +	cpuhp_remove_state_multi(arm_cspmu_cpuhp_state);
>  }
>  
>  int arm_cspmu_impl_register(const struct arm_cspmu_impl_match *impl_match)
> diff --git a/drivers/perf/arm_dmc620_pmu.c b/drivers/perf/arm_dmc620_pmu.c
> index 9a7b05b48da0..7c33f09bf236 100644
> --- a/drivers/perf/arm_dmc620_pmu.c
> +++ b/drivers/perf/arm_dmc620_pmu.c
> @@ -765,7 +765,7 @@ static int __init dmc620_pmu_init(void)
>  
>  	ret = platform_driver_register(&dmc620_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(cpuhp_state_num);
> +		cpuhp_remove_state_multi(cpuhp_state_num);
>  
>  	return ret;
>  }
> @@ -773,7 +773,7 @@ static int __init dmc620_pmu_init(void)
>  static void __exit dmc620_pmu_exit(void)
>  {
>  	platform_driver_unregister(&dmc620_pmu_driver);
> -	cpuhp_remove_multi_state(cpuhp_state_num);
> +	cpuhp_remove_state_multi(cpuhp_state_num);
>  }
>  
>  module_init(dmc620_pmu_init);
> diff --git a/drivers/perf/arm_dsu_pmu.c b/drivers/perf/arm_dsu_pmu.c
> index 751bfed944a9..c737e492175a 100644
> --- a/drivers/perf/arm_dsu_pmu.c
> +++ b/drivers/perf/arm_dsu_pmu.c
> @@ -852,7 +852,7 @@ static int __init dsu_pmu_init(void)
>  	dsu_pmu_cpuhp_state = ret;
>  	ret = platform_driver_register(&dsu_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(dsu_pmu_cpuhp_state);
> +		cpuhp_remove_state_multi(dsu_pmu_cpuhp_state);
>  
>  	return ret;
>  }
> @@ -860,7 +860,7 @@ static int __init dsu_pmu_init(void)
>  static void __exit dsu_pmu_exit(void)
>  {
>  	platform_driver_unregister(&dsu_pmu_driver);
> -	cpuhp_remove_multi_state(dsu_pmu_cpuhp_state);
> +	cpuhp_remove_state_multi(dsu_pmu_cpuhp_state);
>  }
>  
>  module_init(dsu_pmu_init);
> diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
> index 97440b6233c6..c328238c215a 100644
> --- a/drivers/perf/arm_smmuv3_pmu.c
> +++ b/drivers/perf/arm_smmuv3_pmu.c
> @@ -1016,7 +1016,7 @@ static int __init arm_smmu_pmu_init(void)
>  
>  	ret = platform_driver_register(&smmu_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(cpuhp_state_num);
> +		cpuhp_remove_state_multi(cpuhp_state_num);
>  
>  	return ret;
>  }
> @@ -1025,7 +1025,7 @@ module_init(arm_smmu_pmu_init);
>  static void __exit arm_smmu_pmu_exit(void)
>  {
>  	platform_driver_unregister(&smmu_pmu_driver);
> -	cpuhp_remove_multi_state(cpuhp_state_num);
> +	cpuhp_remove_state_multi(cpuhp_state_num);
>  }
>  
>  module_exit(arm_smmu_pmu_exit);
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index 707778c67dab..30a946fccb94 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -1442,7 +1442,7 @@ static int __init arm_spe_pmu_init(void)
>  
>  	ret = platform_driver_register(&arm_spe_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(arm_spe_pmu_online);
> +		cpuhp_remove_state_multi(arm_spe_pmu_online);
>  
>  	return ret;
>  }
> @@ -1450,7 +1450,7 @@ static int __init arm_spe_pmu_init(void)
>  static void __exit arm_spe_pmu_exit(void)
>  {
>  	platform_driver_unregister(&arm_spe_pmu_driver);
> -	cpuhp_remove_multi_state(arm_spe_pmu_online);
> +	cpuhp_remove_state_multi(arm_spe_pmu_online);
>  }
>  
>  module_init(arm_spe_pmu_init);
> diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
> index ce4097c4f64e..7b354c190d55 100644
> --- a/drivers/perf/cxl_pmu.c
> +++ b/drivers/perf/cxl_pmu.c
> @@ -1138,7 +1138,7 @@ static __init int cxl_pmu_init(void)
>  
>  	rc = cxl_driver_register(&cxl_pmu_driver);
>  	if (rc)
> -		cpuhp_remove_multi_state(cxl_pmu_cpuhp_state_num);
> +		cpuhp_remove_state_multi(cxl_pmu_cpuhp_state_num);
>  
>  	return rc;
>  }
> @@ -1146,7 +1146,7 @@ static __init int cxl_pmu_init(void)
>  static __exit void cxl_pmu_exit(void)
>  {
>  	cxl_driver_unregister(&cxl_pmu_driver);
> -	cpuhp_remove_multi_state(cxl_pmu_cpuhp_state_num);
> +	cpuhp_remove_state_multi(cxl_pmu_cpuhp_state_num);
>  }
>  
>  MODULE_DESCRIPTION("CXL Performance Monitor Driver");
> diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
> index 039730a3b80d..3b715294e2f5 100644
> --- a/drivers/perf/dwc_pcie_pmu.c
> +++ b/drivers/perf/dwc_pcie_pmu.c
> @@ -928,7 +928,7 @@ static int __init dwc_pcie_pmu_init(void)
>  err_unregister_driver:
>  	platform_driver_unregister(&dwc_pcie_pmu_driver);
>  err_remove_cpuhp:
> -	cpuhp_remove_multi_state(dwc_pcie_pmu_hp_state);
> +	cpuhp_remove_state_multi(dwc_pcie_pmu_hp_state);
>  err_cleanup:
>  	dwc_pcie_cleanup_devices();
>  	return ret;
> @@ -940,7 +940,7 @@ static void __exit dwc_pcie_pmu_exit(void)
>  		bus_unregister_notifier(&pci_bus_type, &dwc_pcie_pmu_nb);
>  	dwc_pcie_cleanup_devices();
>  	platform_driver_unregister(&dwc_pcie_pmu_driver);
> -	cpuhp_remove_multi_state(dwc_pcie_pmu_hp_state);
> +	cpuhp_remove_state_multi(dwc_pcie_pmu_hp_state);
>  }
>  
>  module_init(dwc_pcie_pmu_init);
> diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
> index 39b25d70942d..af9319ef2f5c 100644
> --- a/drivers/perf/fsl_imx8_ddr_perf.c
> +++ b/drivers/perf/fsl_imx8_ddr_perf.c
> @@ -877,7 +877,7 @@ static int ddr_perf_probe(struct platform_device *pdev)
>  ddr_perf_err:
>  	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
>  cpuhp_instance_err:
> -	cpuhp_remove_multi_state(pmu->cpuhp_state);
> +	cpuhp_remove_state_multi(pmu->cpuhp_state);
>  idr_free:
>  	ida_free(ida, pmu->id);
>  	dev_warn(&pdev->dev, "i.MX8 DDR Perf PMU failed (%d), disabled\n", ret);
> @@ -889,7 +889,7 @@ static void ddr_perf_remove(struct platform_device *pdev)
>  	struct ddr_pmu *pmu = platform_get_drvdata(pdev);
>  
>  	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
> -	cpuhp_remove_multi_state(pmu->cpuhp_state);
> +	cpuhp_remove_state_multi(pmu->cpuhp_state);
>  
>  	perf_pmu_unregister(&pmu->pmu);
>  
> diff --git a/drivers/perf/fsl_imx9_ddr_perf.c b/drivers/perf/fsl_imx9_ddr_perf.c
> index 739c6567cd68..c09eeb9b6a21 100644
> --- a/drivers/perf/fsl_imx9_ddr_perf.c
> +++ b/drivers/perf/fsl_imx9_ddr_perf.c
> @@ -849,7 +849,7 @@ static int ddr_perf_probe(struct platform_device *pdev)
>  ddr_perf_err:
>  	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
>  cpuhp_instance_err:
> -	cpuhp_remove_multi_state(pmu->cpuhp_state);
> +	cpuhp_remove_state_multi(pmu->cpuhp_state);
>  cpuhp_state_err:
>  format_string_err:
>  	ida_free(&ddr_ida, pmu->id);
> @@ -862,7 +862,7 @@ static void ddr_perf_remove(struct platform_device *pdev)
>  	struct ddr_pmu *pmu = platform_get_drvdata(pdev);
>  
>  	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
> -	cpuhp_remove_multi_state(pmu->cpuhp_state);
> +	cpuhp_remove_state_multi(pmu->cpuhp_state);
>  
>  	perf_pmu_unregister(&pmu->pmu);
>  
> diff --git a/drivers/perf/fujitsu_uncore_pmu.c b/drivers/perf/fujitsu_uncore_pmu.c
> index f6165eb44c07..91ee608a5fd5 100644
> --- a/drivers/perf/fujitsu_uncore_pmu.c
> +++ b/drivers/perf/fujitsu_uncore_pmu.c
> @@ -593,7 +593,7 @@ static int __init fujitsu_uncore_pmu_init(void)
>  
>  	ret = platform_driver_register(&fujitsu_uncore_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(uncore_pmu_cpuhp_state);
> +		cpuhp_remove_state_multi(uncore_pmu_cpuhp_state);
>  
>  	return ret;
>  }
> @@ -601,7 +601,7 @@ static int __init fujitsu_uncore_pmu_init(void)
>  static void __exit fujitsu_uncore_pmu_exit(void)
>  {
>  	platform_driver_unregister(&fujitsu_uncore_pmu_driver);
> -	cpuhp_remove_multi_state(uncore_pmu_cpuhp_state);
> +	cpuhp_remove_state_multi(uncore_pmu_cpuhp_state);
>  }
>  
>  module_init(fujitsu_uncore_pmu_init);
> diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
> index 2414f222afcd..0c083a45fdd3 100644
> --- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
> +++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
> @@ -989,7 +989,7 @@ static int __init hisi_pcie_module_init(void)
>  
>  	ret = pci_register_driver(&hisi_pcie_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
> +		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
>  
>  	return ret;
>  }
> @@ -998,7 +998,7 @@ module_init(hisi_pcie_module_init);
>  static void __exit hisi_pcie_module_exit(void)
>  {
>  	pci_unregister_driver(&hisi_pcie_pmu_driver);
> -	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
> +	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
>  }
>  module_exit(hisi_pcie_module_exit);
>  
> diff --git a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
> index 167e369cf74c..78fb005907a2 100644
> --- a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
> +++ b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
> @@ -952,7 +952,7 @@ static int __init hisi_l3c_pmu_module_init(void)
>  
>  	ret = platform_driver_register(&hisi_l3c_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(hisi_l3c_pmu_cpuhp_state);
> +		cpuhp_remove_state_multi(hisi_l3c_pmu_cpuhp_state);
>  
>  	return ret;
>  }
> @@ -961,7 +961,7 @@ module_init(hisi_l3c_pmu_module_init);
>  static void __exit hisi_l3c_pmu_module_exit(void)
>  {
>  	platform_driver_unregister(&hisi_l3c_pmu_driver);
> -	cpuhp_remove_multi_state(hisi_l3c_pmu_cpuhp_state);
> +	cpuhp_remove_state_multi(hisi_l3c_pmu_cpuhp_state);
>  }
>  module_exit(hisi_l3c_pmu_module_exit);
>  
> diff --git a/drivers/perf/hisilicon/hisi_uncore_pmu.c b/drivers/perf/hisilicon/hisi_uncore_pmu.c
> index 346c87594614..9b7e39404510 100644
> --- a/drivers/perf/hisilicon/hisi_uncore_pmu.c
> +++ b/drivers/perf/hisilicon/hisi_uncore_pmu.c
> @@ -639,7 +639,7 @@ module_init(hisi_uncore_pmu_init);
>  
>  static void __exit hisi_uncore_pmu_exit(void)
>  {
> -	cpuhp_remove_multi_state(hisi_uncore_pmu_cpuhp_state);
> +	cpuhp_remove_state_multi(hisi_uncore_pmu_cpuhp_state);
>  }
>  module_exit(hisi_uncore_pmu_exit);
>  
> diff --git a/drivers/perf/hisilicon/hns3_pmu.c b/drivers/perf/hisilicon/hns3_pmu.c
> index 3069257ca79f..70eeae0b07e5 100644
> --- a/drivers/perf/hisilicon/hns3_pmu.c
> +++ b/drivers/perf/hisilicon/hns3_pmu.c
> @@ -1656,7 +1656,7 @@ static int __init hns3_pmu_module_init(void)
>  	ret = pci_register_driver(&hns3_pmu_driver);
>  	if (ret) {
>  		pr_err("failed to register pci driver, ret = %d.\n", ret);
> -		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
> +		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
>  	}
>  
>  	return ret;
> @@ -1666,7 +1666,7 @@ module_init(hns3_pmu_module_init);
>  static void __exit hns3_pmu_module_exit(void)
>  {
>  	pci_unregister_driver(&hns3_pmu_driver);
> -	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
> +	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
>  }
>  module_exit(hns3_pmu_module_exit);
>  
> diff --git a/drivers/perf/marvell_cn10k_ddr_pmu.c b/drivers/perf/marvell_cn10k_ddr_pmu.c
> index c699a4545935..5e1187ade225 100644
> --- a/drivers/perf/marvell_cn10k_ddr_pmu.c
> +++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
> @@ -1345,7 +1345,7 @@ static int __init cn10k_ddr_pmu_init(void)
>  
>  	ret = platform_driver_register(&cn10k_ddr_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(
> +		cpuhp_remove_state_multi(
>  				CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE);
>  	return ret;
>  }
> @@ -1353,7 +1353,7 @@ static int __init cn10k_ddr_pmu_init(void)
>  static void __exit cn10k_ddr_pmu_exit(void)
>  {
>  	platform_driver_unregister(&cn10k_ddr_pmu_driver);
> -	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE);
> +	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE);
>  }
>  
>  module_init(cn10k_ddr_pmu_init);
> diff --git a/drivers/perf/marvell_cn10k_tad_pmu.c b/drivers/perf/marvell_cn10k_tad_pmu.c
> index 2d64a3351433..46f3cecf46d8 100644
> --- a/drivers/perf/marvell_cn10k_tad_pmu.c
> +++ b/drivers/perf/marvell_cn10k_tad_pmu.c
> @@ -477,7 +477,7 @@ static int __init tad_pmu_init(void)
>  	tad_pmu_cpuhp_state = ret;
>  	ret = platform_driver_register(&tad_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(tad_pmu_cpuhp_state);
> +		cpuhp_remove_state_multi(tad_pmu_cpuhp_state);
>  
>  	return ret;
>  }
> @@ -485,7 +485,7 @@ static int __init tad_pmu_init(void)
>  static void __exit tad_pmu_exit(void)
>  {
>  	platform_driver_unregister(&tad_pmu_driver);
> -	cpuhp_remove_multi_state(tad_pmu_cpuhp_state);
> +	cpuhp_remove_state_multi(tad_pmu_cpuhp_state);
>  }
>  
>  module_init(tad_pmu_init);
> diff --git a/drivers/perf/marvell_pem_pmu.c b/drivers/perf/marvell_pem_pmu.c
> index f72837fa02f9..9b8a34220351 100644
> --- a/drivers/perf/marvell_pem_pmu.c
> +++ b/drivers/perf/marvell_pem_pmu.c
> @@ -407,14 +407,14 @@ static int __init pem_pmu_init(void)
>  
>  	ret = platform_driver_register(&pem_pmu_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
> +		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
>  	return ret;
>  }
>  
>  static void __exit pem_pmu_exit(void)
>  {
>  	platform_driver_unregister(&pem_pmu_driver);
> -	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
> +	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
>  }
>  
>  module_init(pem_pmu_init);
> diff --git a/drivers/perf/nvidia_t410_c2c_pmu.c b/drivers/perf/nvidia_t410_c2c_pmu.c
> index 1fc2adeb7195..209e90f76f3c 100644
> --- a/drivers/perf/nvidia_t410_c2c_pmu.c
> +++ b/drivers/perf/nvidia_t410_c2c_pmu.c
> @@ -1040,7 +1040,7 @@ static int __init nv_c2c_pmu_init(void)
>  static void __exit nv_c2c_pmu_exit(void)
>  {
>  	platform_driver_unregister(&nv_c2c_pmu_driver);
> -	cpuhp_remove_multi_state(nv_c2c_pmu_cpuhp_state);
> +	cpuhp_remove_state_multi(nv_c2c_pmu_cpuhp_state);
>  }
>  
>  module_init(nv_c2c_pmu_init);
> diff --git a/drivers/perf/nvidia_t410_cmem_latency_pmu.c b/drivers/perf/nvidia_t410_cmem_latency_pmu.c
> index f1eff644b0ba..d8c04f47e41b 100644
> --- a/drivers/perf/nvidia_t410_cmem_latency_pmu.c
> +++ b/drivers/perf/nvidia_t410_cmem_latency_pmu.c
> @@ -725,7 +725,7 @@ static int __init cmem_lat_pmu_init(void)
>  static void __exit cmem_lat_pmu_exit(void)
>  {
>  	platform_driver_unregister(&cmem_lat_pmu_driver);
> -	cpuhp_remove_multi_state(cmem_lat_pmu_cpuhp_state);
> +	cpuhp_remove_state_multi(cmem_lat_pmu_cpuhp_state);
>  }
>  
>  module_init(cmem_lat_pmu_init);
> diff --git a/drivers/perf/thunderx2_pmu.c b/drivers/perf/thunderx2_pmu.c
> index 3cf079c7ff41..08c370bd5fa4 100644
> --- a/drivers/perf/thunderx2_pmu.c
> +++ b/drivers/perf/thunderx2_pmu.c
> @@ -1026,7 +1026,7 @@ static int __init tx2_uncore_driver_init(void)
>  	}
>  	ret = platform_driver_register(&tx2_uncore_driver);
>  	if (ret)
> -		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
> +		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
>  
>  	return ret;
>  }
> @@ -1035,7 +1035,7 @@ module_init(tx2_uncore_driver_init);
>  static void __exit tx2_uncore_driver_exit(void)
>  {
>  	platform_driver_unregister(&tx2_uncore_driver);
> -	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
> +	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
>  }
>  module_exit(tx2_uncore_driver_exit);
>  
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 6df5f4e7c5d6..39da93377e03 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -15715,7 +15715,7 @@ lpfc_init(void)
>  	return error;
>  
>  unwind:
> -	cpuhp_remove_multi_state(lpfc_cpuhp_state);
> +	cpuhp_remove_state_multi(lpfc_cpuhp_state);
>  cpuhp_failure:
>  	fc_release_transport(lpfc_transport_template);
>  	fc_release_transport(lpfc_vport_transport_template);
> @@ -15816,7 +15816,7 @@ lpfc_exit(void)
>  {
>  	misc_deregister(&lpfc_mgmt_dev);
>  	pci_unregister_driver(&lpfc_driver);
> -	cpuhp_remove_multi_state(lpfc_cpuhp_state);
> +	cpuhp_remove_state_multi(lpfc_cpuhp_state);
>  	fc_release_transport(lpfc_transport_template);
>  	fc_release_transport(lpfc_vport_transport_template);
>  	idr_destroy(&lpfc_hba_index);
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 1b6dba159bb2..c9563bb15e0a 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -450,14 +450,14 @@ static inline void cpuhp_remove_state_nocalls_cpuslocked(enum cpuhp_state state)
>  }
>  
>  /**
> - * cpuhp_remove_multi_state - Remove hotplug multi state callback
> + * cpuhp_remove_state_multi - Remove hotplug multi state callback
>   * @state:	The state for which the calls are removed
>   *
>   * Removes the callback functions from a multi state. This is the reverse of
>   * cpuhp_setup_state_multi(). All instances should have been removed before
>   * invoking this function.
>   */
> -static inline void cpuhp_remove_multi_state(enum cpuhp_state state)
> +static inline void cpuhp_remove_state_multi(enum cpuhp_state state)
>  {
>  	__cpuhp_remove_state(state, false);
>  }
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 5a113c667d4c..551c432b506f 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -1111,7 +1111,7 @@ void __init padata_init(void)
>  
>  remove_online_state:
>  #ifdef CONFIG_HOTPLUG_CPU
> -	cpuhp_remove_multi_state(hp_online);
> +	cpuhp_remove_state_multi(hp_online);
>  err:
>  #endif
>  	pr_warn("padata: initialization failed\n");
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 65b9d67647e5..8fd2de42efc4 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -10073,7 +10073,7 @@ __init static int tracer_alloc_buffers(void)
>  out_free_temp_buffer:
>  	ring_buffer_free(temp_buffer);
>  out_rm_hp_state:
> -	cpuhp_remove_multi_state(CPUHP_TRACE_RB_PREPARE);
> +	cpuhp_remove_state_multi(CPUHP_TRACE_RB_PREPARE);
>  out_free_cpumask:
>  	free_cpumask_var(global_trace.tracing_cpumask);
>  out_free_buffer_mask:
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ae19e301fced..18eddeb2d69c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1880,7 +1880,7 @@ static int zswap_setup(void)
>  shrinker_fail:
>  	destroy_workqueue(shrink_wq);
>  shrink_wq_fail:
> -	cpuhp_remove_multi_state(CPUHP_MM_ZSWP_POOL_PREPARE);
> +	cpuhp_remove_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE);
>  hp_fail:
>  	kmem_cache_destroy(zswap_entry_cache);
>  cache_fail:
> 
> ---
> base-commit: 9437ee8b6cf607e883b36e44bd755968daaebd48
> change-id: 20261127-fix-rename_cpuhp_remove_multi_state-b79dac11744e
> 
> Regards,
> Srivatsa
> 
> 
