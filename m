Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010035.outbound.protection.outlook.com [52.101.46.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE23219C54E;
	Fri, 24 Jul 2026 06:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874578; cv=fail; b=ZpnSzVSMw5kCaACySUxG5xudS6Y7FF0+5Wx5Wph0JNLVlWrGLEwxbDxR2yOUgn4Lfl8M6hnNfxT4J8gOb51DNUCKIprZY5qlgywJXSKaWgKopglppWzZVoUYEZG/pjmgXW1eSYDy35J49kewsecA0AFeIfSa4Y+3I6WApoCybkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874578; c=relaxed/simple;
	bh=a+ACLbixapC/zjoKK3eYxjnIbrfU98SSf3nRmQNSEL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oryhduBuCTZKlYw/MrVzOK2pIsQoKmJvjJKuDpOtzTFR2ODeJnraFG7FlPl1RUgGF4HvMXoV3wzG90uERc8dCBK8Eqr8cYYHXo0yigGmEjhMYWQqIT3kgbjJuS6FSvp4YpIKBVjoX89Sxuv1zDHN6wzl7AzbKNFwpSmgnC9tLhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BbnuJlKx; arc=fail smtp.client-ip=52.101.46.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BbnuJlKx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZdARlGKTLH0ACuwiwK4wpiw1vx3zON9eQiTwYZAXqeSO48yqRNX9Nxiuc/VvQ1cpWsUULpdHU6uJfXHMtY2Dpfd/3zRzwK13VDoUSPFgWLfSqfBRl08LCWdcqJZxRnkLmpg3r8iKVpXhpdMnG1t6o3uWQrFL8k1tgnv6ZlsgTVVG5bYv02TXEb6sfUceUDbbFjkB/RQkFpPvbOZI8uWar3vO34KtyosBxNflCuhyqg2ynHy5l7LsweSwGNlx5Qz6iOtggPlSGEPo0MVurpTzTveWOq92pmRxwkEXZ59B7RMPPr6olEBntQPORn+6BlY1m3XW1KQvvLuE6occX2x/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i8eOhJ3/JC/GfQ3HizjJjoOnsvAYLcBkgkjs33XBs4=;
 b=uiq7UWazwj+JmF5iHi6haMBJMX5mQquQxqHoMMPDOXizrXLG+8Q0v5o5u76DB2mg7bTvTKa5E2L69JJHzTYxUCftYYyGkhaGtEBQkKl9C1hjgIZokw/5AUxcUi+qiSRw2FgAQnxIGLLNz9L31zBsPGOzgNZgBE7CpAmyOtCT6eolTKzdiSwcOegqKVrBjC28yvlAUJ2S/PGIdX582ZZJ4vdCHfSPrZrQTDfeVGoJi+ItzQjsf3qIC2tj3M4zsVWxLY2cxep7/AulprIMaslX1YqwcjPgu24bUxnQdxweJIHeAUMwGy+5oEKu3qwtiO++k6rCz8nxdzP51Y1+GnlzDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i8eOhJ3/JC/GfQ3HizjJjoOnsvAYLcBkgkjs33XBs4=;
 b=BbnuJlKxyyJC4qqrgeTVHym7vtbBTO/BJxxmjm/BqGAPaK7A9LSpeGBo64RhPmrYTEvqxS7EbA5sWbo2rjkxurpd0J+I0MXh2bRIsi+xTwJr5NKyvGjmgi5T38cMNMpixqsdQy349hG8DXlssSMxingB/1ma9fdoky6pRQgR5Y73r+qYVwTY4pnRNxsQYtyTyCDRz7aHaMo1/o9rrJqZWR7c3VN/EH+E6hb2FAU2GzbaM/8PhThrKWe+acBLLM10Ni/RR3d9ZVapISjmQXX5ItLxiJTlt3UpMtfKWrAgQ34tvuocr25Dc/5DflQqXCJMZFHhhGgSJcdK7iUzmjFUYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by IA0PR12MB7676.namprd12.prod.outlook.com (2603:10b6:208:432::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 06:29:29 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 06:29:29 +0000
Date: Fri, 24 Jul 2026 14:29:22 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amMEai0Fo9dL63lP@MWDK4CY14F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <amDL80BSEP6u9XfE@MWDK4CY14F>
 <amDVQopyvolxfX8K@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDVQopyvolxfX8K@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: KL1P15301CA0053.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::15) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|IA0PR12MB7676:EE_
X-MS-Office365-Filtering-Correlation-Id: 918eef5c-2365-41b1-d53f-08dee94cea6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|7416014|1800799024|6133799003|56012099006|10067099003|4143699003|11063799006|5023799004|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	vEDmYT1VI4A6AhBLfy9fkzQ6ar6Im01hIe2HWPpRa3tJgVKFFI1vxEtY6HV+12WDOtgypI2sSTffMhr3WxX3h+oMDpaihMLAJ3b29JOn9R7g/OipTCp9E/KkQCc6yXQIcKLonhAw7vzKeTToxO8M2t5N9/MShK27UyeJjUtl/T3dTP1lS0nw8RocQ12qLQ80Lp4EQInv2eY643gZF+zMlz1XprAfigp9Cliy2lMqzyJzsnU+ROeTT38eLK0sopcgw4etzuzsS3V9GiORUsTzapPstD+9T+K807++Cj+tycez0PtR3OSV2Oe2zrbi6gieSMnI5mT8pGYliAglQUHNxS3UBXiMknA9Udn3xGJ67ZanGVe/QP6o3AeORwxGiDN1bmgJ/+2rIP7sq1+DNm11g1edTiuLQXT+V9ZQZ3guVqqau3l+geYgBkK8u3VRvr8IrulGJRe5acxzsAd5ppCQ0yVcE2z61UtIHanwdSq+sGVdDD3csSctX1Hjiwbz1s4FkcOCGMBEGRHWczUi1BYGSorgcA2/h+yPEhjxBUPYMok77L8vc/N6b24cc/JPEi+quHxQ3uoQudZ0Asm+aFa8UKwXkoyxqOM+1FIIZ87t3su30OaEbGo2ZjhdnFuk9at72t+EpPEZWguLLDzcySqrZ1oTdo7TmRIZ1ZlGc6HoPJ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(7416014)(1800799024)(6133799003)(56012099006)(10067099003)(4143699003)(11063799006)(5023799004)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L30NxugFTWN7x58WxFBGJv27aQ1arWC+2oRHTJMpWZ/AKxX6Gw/VTisL2czl?=
 =?us-ascii?Q?RO2U6y/NHTx+4JEO4lB2rkRbTCMrZ6SFmv9KcpSfkLKxIl+o5A98gEJY4+cI?=
 =?us-ascii?Q?3gDMSjcZRh2tj7WOos2ux990Bqk+TnLqH6s6y4+g5eF5B84oSEjgm1rtvPuj?=
 =?us-ascii?Q?o7G5TNcWt14C12O2H+9knC4Poxf+4vVgHFbBaw7ynrbBUWCbPDqed0pM4ZFN?=
 =?us-ascii?Q?agnc+4FnccRLn0v50bbGbbokI8O06Q8MMlAdmjs7XTss+66cLdeuPrSB6U7n?=
 =?us-ascii?Q?jDRMP+KpBNv4cz8KiyPwg8iCXQy20SCqexHv0FH43dWCjaTgXt33lLP9iup4?=
 =?us-ascii?Q?7/HLFh6FEVYNqCU8SEXqMnQpWPKL1kRrcg+yCKyaLYM1YFqWbzN9ItxSbZ4T?=
 =?us-ascii?Q?C5ujaPF88X+06gMU80hP9rHOoSyJC/Ms+9CVzSGZki4kC6cJKeAZrOJYt6dL?=
 =?us-ascii?Q?arSdqiG4noxeu/WscgPId8ny+oADBKyDsn8K1c0CXsS3MObqByakAisP/lGL?=
 =?us-ascii?Q?8ULNT0bdUjpVNrb83Upaae3NMea2aGOTTH2e9bOTt9qnxkfflgKY7zgJqRPY?=
 =?us-ascii?Q?J0OVTm9pEweqXllwQNC+w+38O7wPFYr+ukmF2KpLkrCVU5Mp94MbmVI/XT5U?=
 =?us-ascii?Q?5VLNoWHSzC1N1eDmjumE2mdSwzeDSha0xZMMQEJZyrhRmBCAxs9wZYfsTSQt?=
 =?us-ascii?Q?QFJucdgGdf2LVqxPBtVPRaHeLoL7cDRATNOiuVqmAbgUHlIOXkHJjGopA8Og?=
 =?us-ascii?Q?sYFghfYniyc6gArHviEm4kzw7/6zGRucObtcsBwkm/B6AApyOE29VpaY/kZx?=
 =?us-ascii?Q?XBnINaeMFCzwVISP/8+M+UoiZbjZYXRKS2WXK1tXergb7jKOjN1R5oCvSKco?=
 =?us-ascii?Q?cAzjybUgnDanE4p3Uv1ws7cDeEQ7M+Rm8KO9lj1e0sM2Jsaqb5ZNGqlG94VV?=
 =?us-ascii?Q?7acDVAEseR+BaK9ChvFJ9dpeFJFcvFdypYRc9jt58NPxMTIOhLLtZQ5LV7Nf?=
 =?us-ascii?Q?wc5GfKGxy1Eq+R6/MIRnQzk3IaHSGRrWgkn2jj1ih1IHCUZoQce1B8NAdvWH?=
 =?us-ascii?Q?uEcBBa+Fha62ZtIWnbY83ifFc+TYtvNCCYrB2AqLDtV9MilSU5vkDx/hmEUU?=
 =?us-ascii?Q?CsoT7UBoEpMSuqyXkaVy0LH7wLFeXMgt79T52wmYb7jrhONMVLs53KinWD50?=
 =?us-ascii?Q?Ce0El/HQ3JFFhfzhtNWSPiMS65F8N+F3DNdw3SRfMBSlwtxyeJjYmjAcSd7/?=
 =?us-ascii?Q?wl/LlEpJHjyG6+0iRSc83Bn98fKkP2JgmGTNUDgC+2Zlf8RpaEvD8C41sTDS?=
 =?us-ascii?Q?GwnXg9mv8sRn1YYY0Ldcl75pZ59ovi5h7vc7qDmH1Jd4nBvdg/EMU2oPvaYW?=
 =?us-ascii?Q?Qd6dy4FWi3DzkilzTy0pufs5QhYqgP11qx8KMudgnQsA4l7N7XCzL4JYiPtn?=
 =?us-ascii?Q?OYR70JPRjPmleOTGaOukLjFgoO6xtcXIHSgZ2dQTmbJ/V3FROIUZd7bnXLs2?=
 =?us-ascii?Q?OlOtJOp073MU4Ooz72FILTWqjstOr3KEr9jYjFVieW+rJE7S4r356KTzU1Xl?=
 =?us-ascii?Q?ZG8EcBKk4UPoOkLJNmW05A7t5L5By0spcqVMPpCTZTy1x1iOMPnQ4RZ6EI3i?=
 =?us-ascii?Q?UmbFkkSgqdGq7MEY7L5dHBO99AGCG/1ebLJWBU7K8jlDFN+NpJXSLqRXcT3y?=
 =?us-ascii?Q?xcv/ut6sWftZxMZ325qk5rsYiylrbWurXqPXUKeYTY+Ab/1p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 918eef5c-2365-41b1-d53f-08dee94cea6f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 06:29:29.6113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBQPvhpbfZj/xc94d305n/Zn9DY7juNf1aOm/Z/FEJjBN+4J5lfeYAxomWhKZr5jTissVLBywL2hU4gSUISLrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7676

On Wed, Jul 22, 2026 at 11:40:06AM +0800, Gregory Price wrote:
> On Wed, Jul 22, 2026 at 10:20:00PM +0800, Richard Cheng wrote:
> > On Mon, Jul 20, 2026 at 03:33:54PM +0800, Gregory Price wrote:
> > Hi Gregory,
> > 
> > I applied your series on mm-next and give a quick review,
> > not thoroughly, still I have some questions below regarding the design.
> >  
> 
> Hi Richard,
> 
> Thank you for the read.
> 
> Just a heads up, this was based on mm-new because of some recent work
> on Brendan's page_alloc.h cleanup, but if you managed to get it applied
> then maybe that's made its way forward already.
> 
> > > The goal here is to flip that dynamic, isolate by default and then
> > > opt-in to specific services that the device says is safe.
> > > 
> > > Isolation at the NUMA/Zonelist layer provides a powerful mechanism for
> > > memory hosted on accelerators - re-use of the kernel mm/ code.
> > > 
> > >  - Accelerators (GPUs) can use demotion, numactl, and reclaim.
> > >  - Special memory devices (Compressed RAM) with special access controls
> > >    (promote-on-write) can have generic services written for them.
> > >  - Network devices with large memory regions intended for ring buffers
> > >    can use the buddy and standard networking stack.
> > >  - Slow, disaggregated memory pools which aren't suitable as general
> > >    purpose memory get cleaner interfaces (no need to re-write the buddy
> > >    in userland, can use migration interface, etc).
> > >  - Per-workload dedicated memory nodes (disaggregated VM memory)
> > > 
> > 
> > For accelerator part, take CXL Type-2 as example, it has its own protocol
> > CXL.cache, CXL.mem which is the rule they need to obey during memory transaction,
> > Adding more rules for them since they are NUMA node confused me, I wonder the reason ?
> > 
> 
> CXL protocols simply state how to do the memory transaction at a
> physical / transport level.  It does not make any statement on how the
> operating systems are to make sense of these devices or what constructs
> / abstractions to build to actually manage the devices themselves.
>

Ahhh thanks this clears my question.
Then this abstraction makes sense.

> This series is not necessarily attached to CXL in particular, you could
> just as easily carve out memory from the general pool onto a private
> node to ensure it only gets used for a particular use.
> 
> In fact, that is how I have been testing this with dax/kmem:
> https://github.com/gourryinverse/linux/commit/f279e741d9c3643597525bfab916b29b95cb635b
> 
> > Because NUMA node, at least for me, representing topology/locality rather than
> > something with ownership or capability or rules.
> > 
> 
> The NUMA abstraction representing topology/locality is a construct we
> (the OS developers) have decided on historically - but there's nothing
> that dictates we can never create new useful abstractions with it.
> 
> Consider:
>     N_NORMAL_MEMORY,        /* The node has regular memory */
>     N_HIGH_MEMORY,          /* The node has regular or high memory */
> 
> These have nothing to do with topology or locality, they are node states
> that only have meaning in the context of linux mm/.
> 

Ok, I see.

> 
> To make something clear - there is no *requirement* for any particular
> device to use this abstraction.  It simply enables a cleaner way for
> devices carrying memory to re-utilize mm/ services while ensuring their
> memory does not silently get used under system pressure (or some vagrant
> in userspace doing `numactl --interleave all`).
> 
> Ignoring all the CAP bits entirely, if you just took the base series
> your driver could re-use the buddy allocator without any special logic
> AND have confidence that your driver is the only possible user of that
> memory (barring some truly obscene bug).
> 
> > >  - isolation via a dedicated zonelist:
> > >      - private nodes are omitted from FALLBACK/NOFALLBACK
> > >      - added ZONELIST_PRIVATE(_NOFALLBACK)
> > 
> > I saw the reply in patch 5, so in fact there's not only one
> > dedicate zonelist, but numerous ?
> > I raise the question because zonelist was supposed to be a
> > global, unbypasssable thing in MM design, but now what you
> > are trying to do is to seperate the whole global list into several
> > parts ?
> > 
> > Can you explain why in current design you don't consider to support
> > something like ZONELIST_PRIVATE[n]={0, .. ,n-1} ? that's my imagination
> > of what a global zonelist should look like, no matter private or non.
> > 
> 
> First let me say that there's nothing that prevents us from doing this,
> and we *could* make this the default case - but this decision was
> intentional by me.
> 
> Having them all present in each-other's zonelists by default creates a
> number of implicit opt-ins that are unclear:
> 
>   - any direct zonelist iterator now iterates all zones on all private
>     nodes, even those nodes do not opt into the same services
> 
>     e.g. zonelist iteration in reclaim that targets Private Node A would
>     attempt to reclaim Private Node B as well.  That would require and
>     extra explicit filter.
> 
>     I ask: Why do this? Just isolate in the zonelist, and if there is
>            a desire for intersections - make it explicit, not implicit.
> 

Fair enough, thanks for the headup.

>   - fallback allocations can now occur across private nodes, even
>     if those nodes are intended for different purposes.
> 
>     Obviously you can use nodemask to tighten the allocation target, but
>     I use `numactl --interleave --all` as an example of a clear case
>     where intersected nodelists may not give you the behavior you want.
> 
> 
> So for consistency - everything including zonelists have full isolation.
> This way all interactions with a private node must be explicit - always.
> 

Good choice I think, avoiding those implicit opt-in assumption will make
future developers more aware of things and do not just stumble into them.

> 
> This is actually one of the problems with ZONE_DEVICE - and you can see
> it in this patch set.  Some of the hooks in mm/ for zone_device only
> apply to PTE cases, and are absent from PMD cases - only because PMD
> mappings in ZONE_DEVICE aren't supported.
> 
> That kind of implicit behavior is quite bad.
> 
> That said, future improvements could include something like:
> 
> for_reclaimable_zone(ZONELIST_PRIVATE) {}
> 
> where we loosen this isolation, and formalize a filter, but I would
> like to see the usecase for it first.  Loosening the isolation defeats
> the entire purpose of the series, so there should be a strong reason to
> do so.

Totally agree.

> 
> > > Allocation Isolation
> > > ====================
> > > page_alloc presently controls whether a node's memory can be allocated
> > > on a given call by 4 things (in order of authority)
> > > 
> > >   1) ZONELIST membership
> > >      If a node is not in the walked zonelist, it's unreachable.
> > >
> > 
> > So a device gets hotplugged in the system will get a dedicated zonelist here ?
> 
> Yes.
> 
> > And make sure it obeys the device's own protocol if it has one ?
> > 
> 
> I'm not sure i follow this question, can you help me understand?
> 

Nevermind, you just answer this part above, thanks alot.

> If by protocol you mean the CAP bits (opting into reclaim, demotion,
> etc), then yes.  If you mean something else (CXL) then I think that's
> orthogonal and unrelated.
> 
> > > Private nodes:
> > >   1) Never appear in any ZONELIST_FALLBACK
> > >   2) Have an empty ZONELIST_NOFALLBACK
> > >   3) Only appear in their own ZONELIST_PRIVATE(_NOFALLBACK)
> > > 
> > > 1 & 2 mean all existing in-tree callers to page_alloc can NEVER
> > > accidentally allocate from a private node.
> > > 
> > > An allocation must explicitly ask via a zonelist and a nodemask.
> > > 
> > >   alloc_flags |= ALLOC_ZONELIST_PRIVATE; /* use ZONELIST_PRIVATE */
> > >   __alloc_pages(..., nodemask);     /* with the private node set */
> > > 
> > 
> > As I stated above, NUMA concept was quite naive at first glance for my
> > limited knowledge.
> > 
> > This is quite alot to add for NUMA node concept, I'll want to see
> > more explanation in v6 and learn from it, thanks.
> > 
> 
> Sure, I can expand on it.  I think it's not as much to add as you think
> though - it's simply adding the concept of isolation to a NUMA node.
> 
> Some more explanation below, but if you think there is something i
> should explicit spell out in v6 cover, please let me know.
> 
> ---
> 
> I agree that NUMA as a concept was best-effort for, comically enough,
> somewhat *Uniform* memory access - instead of *Non*-Uniform memory access.
> 
> The current abstraction quite nicely handles the case where all memory
> on the system is roughly of the same calibre (DDR4, DDR5, etc) and
> roughly for the same purpose (general system memory).
> 
> But it is quite incapable of handling truly heterogeneous memory systems
> (precious HBM attached to the CPU, GPU's with HBM over a coherent link,
> hardware-compressed memory expansion, network devices w/ memory, etc).
> 
> If you look at the history of ZONE_DEVICE, what it fundamentally does is
> slaps an isolation mechanism on top of NUMA nodes because the NUMA
> abstraction doesn't provide one. 
> 
> The problem with that approach is now you have to reason about a node
> having both fungible and non-fungible memory.  It creates the need for
> something like migrate_device.c when a properly isolated NUMA node could
> just use migrate.c directly (with a coherent link).
> 
> 
> One example of what isolation on the node enables:
> 
> A Private Node can hotplug memory in ZONE_NORMAL - which means it
> can be GUP pinned.  That means driver support for GPU direct storage
> is simply `alloc_pages_node() + pin()`. The driver doesn't have to
> worry about something like SLAB accidentally using that same memory.
> 
> All without having to rewrite a bunch of mm/ in a driver, and with
> having to do some kind of heroics with ZONE_DEVICE that causes even
> more special mm/ interactions.
> 
> That only comes from adding an isolation primitive to a NUMA node.
> 
> 
> > > Isolating private node folios from kernel services
> > > ==================================================
> > > We implement filter points in mm/ to prevent operations on
> > > private node memory.  Where possible, we even re-use existing
> > > filter points from ZONE_DEVICE.
> > > 
> > > Most filter points are one or two lines of code:
> > > 
> > > Combining ZONE_DEVICE and N_MEMORY_PRIVATE opt-out spots:
> > >   -     if (folio_is_zone_device(folio))
> > >   +     if (unlikely(folio_is_private_managed(folio)))
> > > 
> > > Disabling a service:
> > >   +  if (!node_is_private(nid)) {
> > >   +      kswapd_run(nid);
> > >   +      kcompactd_run(nid);
> > >   +  }
> > > 
> > > Disallowing a uapi interaction:
> > >   +  if (node_state(nid, N_MEMORY_PRIVATE))
> > >   +      return -EINVAL;
> > > 
> > 
> > I'm not sure of why do we re-implement more filter and basically
> > doing the same thing ? Any unavoidable scenario ?
> > 
> > re-using the exisintg filter would be nice if that's possible.
> > 
> 
> We re-use (combine) existing filters where possible.
> 
> We add new ones where ZONE_DEVICE did not implement filters due to some
> *implicit* filter already existing.
> 
> Two clear examples:
>    - reclaim does not target ZONE_DEVICE
>    - ZONE_DEVICE does not support PMD
> 
> Both cases result in private-node filters that otherwise would have to
> exist for ZONE_DEVICE (and if ZONE_DEVICE ever grows PMD support, those
> filters will have to be added).
> 
> > > Bonus Configuration: HBM device memory tiering
> > > ==============================================
> > > echo 1 > dax0.0/private       # make the node private
> > > echo 0 > dax0.0/adistance     # highest tier
> > > echo 1 > dax0.0/reclaim       # reclaim active
> > > echo 1 > dax0.0/demotion      # may demote from the node
> > > echo 1 > dax0.0/user_numa     # mbind()
> > > echo online_movable > dax0.0/state
> > > echo 1 > numa/demotion_enabled
> > > 
> > > This is an HBM device which is treated as the top-tier in the
> > > system but for which memory can only enter via explicit mbind().
> > > 
> > > It can be overcommitted because it can be reclaimed (demotions
> > > go to CPU DRAM, and reclaim can swap from it).
> > > 
> > > If the HBM is managed by an accelerator (GPU), the mmu_notifier
> > > allows it to know when reclaim is moving memory out to do
> > > device-mmu invalidation prior to migration.
> > > 
> > > Prereqs, base commit, references
> > > ================================
> > > akpm/mm-new - for Brendan Jackman's mm/page_alloc.h work[3]
> > > 
> > 
> > Still thanks for the work, I learn alot from your work as well, thanks.
> > 
> 
> Of course, and thank you for reading.
> 
> If nothing else I hope this series helps folks understand the page
> allocator better (it certainly has helped me).  If there is anything
> you think I can improve or better explain, I am happy to discuss.
> 
> I am planning a larger publication of all my research sometime in the
> future, but I think code is more impactful and useful - so I am
> prioritizing that for now :].
> 
> ~Gregory

That would be helpful for me, thanks alot for all the explanation again !

--Richard

