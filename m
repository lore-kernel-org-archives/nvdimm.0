Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13601C2B7
	for <nvdimm@lists.linux.dev>; Fri,  3 Nov 2023 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hh+swSqY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699025839; x=1730561839;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c/lEUe7l97BrECTbKN/dzB/xk2kZqDQgs9UpmXvWO7U=;
  b=Hh+swSqYyavu/fJmTa+wpWfr//uUG+m7zy4HFT+icns61LAOSX5RHT1L
   bt5utRceoe0xzjJQoGWnTy0TsheVAyFUAhCIIayCeCuHwfbBl4gLGOjvl
   j1J7kZwbPyk9k5d+wna8aDIprEe94zhD+c6nMkoF0N3ybgJNo/GPKoYZj
   2cany/8lCJ4yXfC7KZyUebYyL+ns8nS5m8I9JGUI1DgHQ3SS6Mn9XTpDQ
   3dCLVbUfYydvZPwPEcZdcYMd9hSnLh+ADTWoFPyFO2LA8k/JTuwaZgnnC
   WqvgrxVVSQIftWeMrZPyIOEC7uyTxGddjEGkQdwlk3UWHi8/qkAMnWz+p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10883"; a="420078229"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="420078229"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 08:37:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10883"; a="905380731"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="905380731"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Nov 2023 08:37:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 3 Nov 2023 08:37:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 3 Nov 2023 08:37:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 3 Nov 2023 08:37:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEPYTgPjQbuAM3yTPpZW8FI3JEkC4X/k8ChI4/ViZlKRVL9croQwHsejR2zHRRdPCgx+p6soXM3fdolE7M4HOlO46WnvoBUW/iATfTng7FUhQDMEKXKuV+A4Z7XPHDAX+elYRlGFOxWz+Q1p4tJ5/DSEci1HVfkhRmnqUdem8TjoNL3XcNT7ZM90X7udo3djUklu5B0bhI+5GqoWf81FqVNsN12zcmUrCQNplBa23vAPw/oz6kWBwgq+tVNgiluNwgAts56PWQUrfmSVSg3KPsn5AVywaOy4azRXmborOXK5NJVjGZUS7sp+/KGU9/gu+L5S824P7YcWUwZngcfcLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64WcTtloUHT67jnzPRNEJUuShsUiXh9cbCUSVJskE2g=;
 b=JFlHXWkFWdPLGTqUmalwXsiCnKqJOGRMyWodmhlUbNpOOVECOl6YsNyxksTXvv90ZK9ffB1lGjioR/PTgU8quR2fwhcL90UuU6tAmoeemsVmNqm9jCUvB0AXE6jqp8Nl/yGaYPaEBx2OBOLr/I0zftin8phvJari0DRkjeiVUsmQQHWJ/h81YuxIJU556vCJ8p5oV+tkOE4bdSQigv6WbiZDEQrH/US6rTvIpFlqaTJqlrGLfLJgURer0UW/Zdsf9OKfLpeEVsws69OxED6lKyRQqW6BKzJjRZkBAUHRHZoIO5wi30jH9mO2mM7g52EadUKDnhD6Wn985+bvFimqyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH0PR11MB5878.namprd11.prod.outlook.com (2603:10b6:510:14c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Fri, 3 Nov
 2023 15:37:09 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e%6]) with mapi id 15.20.6954.021; Fri, 3 Nov 2023
 15:37:09 +0000
Message-ID: <91ba034f-6fc5-47eb-a4a6-1ad34b4cef3f@intel.com>
Date: Fri, 3 Nov 2023 08:37:06 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [ISSUE] `cxl destory-region region0` causes kernel panic when cxl
 memory is occupied
To: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>,
	<vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
References: <0137fb34-7291-b88b-34aa-78471d57921b@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0137fb34-7291-b88b-34aa-78471d57921b@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0206.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::31) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH0PR11MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: c9af2370-730f-4a9e-ccd5-08dbdc82bdeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z+wDSKEt5aE0BAsW5WI2nc9kfOHDH9T23z34jcMMGItf/yQdm5olRkbU55LOhZS39rwFvbpNxAY5UIkxnObcftPUWw2ozu2VKynfaMYJVHs/yHmZ9cz+6tsOr+MRV7HequkX6y+QzVQ6UT0FcXjgoMrlox7AESSlCJoOIr5Egbdt1tddlTumpiCb/8TkYKdGDaQKzzLoPTjC580cYIy4Cv4ksxx6P1J+8qIqemok8JOQedktwF5Ktjv8xzd/HNY0jmMLo4PYX5gADAmTitlJK2kUdrw2MaOUznGP6qMSTgIB9qZkLe/RlQ8EUHGTS24FkQJ3dSbstP4eJuV50frshqkSJxlDx/emYlnt3BIrQXNYWY/nARa+kj4/QVvZGhn9IZoyTD6w1QohCm7OY8DKqM9w6VInEhrr35sIwcvR57NGL2B7wUzQHNufbL2en+O1E8ZsbAfLGJ/G2Ad0HDr0cGuZ1t9n6WKaycYdKSLW3ChDug/PZhhBrzXuCwTf5vex/XQL0AuC8KFw/Phu0Ua4h7oxck37gwjmQ9g4YbmF+iyo+DWHEFUQBn/MPmdG7YstPm8Jf9E5T0ZCPGsrkAyNW48gjv+WHepVuQ232bb0pcNWb5kkx/AidFTEbfGVf+Z/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(136003)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(44832011)(36756003)(66899024)(5660300002)(82960400001)(38100700002)(41300700001)(2906002)(86362001)(66476007)(31696002)(2616005)(966005)(6486002)(26005)(6512007)(316002)(6636002)(66556008)(66946007)(53546011)(6666004)(6506007)(31686004)(478600001)(8936002)(8676002)(4326008)(83380400001)(81973001)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXZ1Njc5eVFoT2RMa1BaaFFSMVN1MTdKQkdzYjVEN3FQUEg4MFo3a0x3YVZY?=
 =?utf-8?B?dVdvdVZrL1psS2FFSnVJU1Vmc1RRdDNYZ0ZVZnJJVmhCaUxaanpHRXJaSTFL?=
 =?utf-8?B?WWIvYVM0SWZMTTUxY0RtSTRiZi91TzJmYnRYaUpzMWdScDBFeHBiaE9HS2tM?=
 =?utf-8?B?cUZ4Y0hPSTYyNnpyK1h4aVo0clpNS3lwYXVRc2xFc1YyV1RsMmgzWUcwSkZM?=
 =?utf-8?B?SW5hY2pEZXBtZWxNRHhzSlBlaUNOeWRwNDM3aUszQTBDV3FZMTBHMGJuK3Y4?=
 =?utf-8?B?QkRZMGpNMTNkNkNKeDBpVzFiYXFoem5rQit1L2dUa2wzeGNiWGN3eUJsWE5Z?=
 =?utf-8?B?TDN4N2VhQjgxSXFOYVp6UWJxSlFiYlhIbW16K2ppTTVSRVBHbkk1YllTRmJN?=
 =?utf-8?B?cmcwbUg1YmJvMjRteXlNNEh5REtCYkJEZTBESFVKWTZhbmV4ZnhUQzJ3NGNO?=
 =?utf-8?B?Q2MzYUVYdDJuRW5Ud1lSWnFKN2hWZ25BNTdMRVQvWTdINkhaNnBrNDJMMU84?=
 =?utf-8?B?OWZDcUlpTzJ0TG5ldGhHbVJ1OHdqSmlZaXNRM3Fsb0VRUit5aG1nOEloNUsw?=
 =?utf-8?B?VmRpdjArRXBKQ1FaNmM2elBiQzlaWXVFamdGLzh4bDZRTytHdXBwbkgvTWQ1?=
 =?utf-8?B?ejhrblIxYVMwZ09Gd2dKTzgwSmhrL2RDcVNlOEZWMW1zc2QxZ2hwSVpaK2hG?=
 =?utf-8?B?eDdkbExqSC9PRG4zaW5QQWhGK2dJUnNEalc1YUgxemVBRVIxMk84MFg3TDNk?=
 =?utf-8?B?VVJ5OXpqYUlCakI0NFRHbTNGUEIxVXo5dlR0K3IrTy9PdkRJQnBlbzhEeVdi?=
 =?utf-8?B?Wk1kSU1CQW1KbWF4QTNZK283V2VHWHVvUFB5UDZ3NGROYXZBVlo4ckFmZzR1?=
 =?utf-8?B?aEJjYXRVZXZ3TEhac0krWEdhOENDMC96eTMvYjlvYkNpc3FNQ1NqeVNVSG1M?=
 =?utf-8?B?em40RjBSYnNYSXZudUZMTy9hcFBBcVpUcVhHbFVhTmY0YXFTSm1XK0pXUG1V?=
 =?utf-8?B?TDlDang2M3NocTZQaUNYT08yTkF4TFI3bDJScURwT1p1cnNiNEpsTHo4RmRG?=
 =?utf-8?B?WGVabVdzWkpoN2oxVnh0YzFpWGd6UldGb0dmd3JzYUt1dmYvRzRGQlFkYUxw?=
 =?utf-8?B?N2l0VG1RZmJvYlEzbEo2VVVqTHFIMTdrbWNSSzJkUzliWEJoRVY4R1hwS3NY?=
 =?utf-8?B?bGZ6MStIWEF1UU13eXE3U2xpeHNSbXY0TWY5Q2g2azBubXZQck5yMktmN05J?=
 =?utf-8?B?VVVrSEtwcWd4MWF6dnJicXJaelBudExINWdtNTJncktHSGQvSE9tRHdnN0Z2?=
 =?utf-8?B?Q1BzZUlWSHlzcXpXZUlPd3BzQ0JENTZYTjkrNGFQbDljaUc4dUsrVnJ0bnVv?=
 =?utf-8?B?YzQveko5WWJEQmsvUXB5QlZqbDJuUitDSGN1R0NtVUFRRzRmSHlHUlBkdlU5?=
 =?utf-8?B?cUoza2xidWNocVVlcHdySnM0SkpxZGR6NzU1VmhKTEFhUW8xZTVkT0pVelNJ?=
 =?utf-8?B?L1dVbnJ2QXhkaWY2Njk3Ylp5b0xMbkNYTll2dUxoWDRKTVYzQ21wV3lPU0dm?=
 =?utf-8?B?WXVkeTBOc2pIZk1QVCsxdlhJNVdLdHNuOURuQnQzcllNNVpTeEdYT1lmK1VG?=
 =?utf-8?B?R2RnQnBJcytSRFY4QS9sYXZHTmdCTGtVbkJTZW5MbmR2SXgxWWtCT1d0TWNS?=
 =?utf-8?B?Q3lrTHBiY2c4TTZaVTB0c1F6bE9EcDJqdE55YlJ3WnhlYVFHTFZFc0ZmMXA4?=
 =?utf-8?B?QmJlV1ZZQW52MmZkL2cxZERjKys5MHF5UHFGaWF5TUVTU2puaFdhQktFSmht?=
 =?utf-8?B?eURzK1d3Mjc4NEVUU25zejkrSWRDZjdYKzF2eTUzTzBHV0lDQWkxd3M5RDQ1?=
 =?utf-8?B?cTQ4Q3dMNVBaK2RRMjhXUWkzMTNKZTBjM0l4bGpjR2tINkw3MGNQRk55ckNR?=
 =?utf-8?B?TEcyM1piR1crMkwxdERuc2o2NEw5TmVwejUwT2VxYm5aZDRUcWNJbjd1UGF0?=
 =?utf-8?B?Ri9vZXo5WDZKSFd0SXZiZm50bmlMMFI0NTVFaFZSVVh1VmxPQmRLYWNod1Yv?=
 =?utf-8?B?WkRsOGlaUnkyVHU1L3hDczUyelBBaVBtUUJkMlZKYWlJSnJtUDdtVnp1TWg1?=
 =?utf-8?Q?Vt9YUiGIUXVEeBusIxAN9ANzF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9af2370-730f-4a9e-ccd5-08dbdc82bdeb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2023 15:37:09.5283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ML7orC9YABG2R2LW7gzileLROIhrfY1LOW5/CknecJhZ58Rg7DqrohibFi3jJTeyLoQ/YG1P/SCQrglPWyov6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5878
X-OriginatorOrg: intel.com



On 11/3/23 04:11, Cao, Quanquan/曹 全全 wrote:
> Hi guys,
> 
> I am writing to report an issue that I have encountered while executing 'cxl destroy-region region0', causing a kernel panic when the cxl memory is occupied. I have provided a detailed description of the problem along with relevant test for reference.
> 
> Problem Description:
> 
> After 'create-region', if cxl memory is occupied using a script, then 'disable-region' without `daxctl offline-memory` firstly, it will result in a kernel panic.

Hi Quanquan,
This NDCTL change is suppose to prevent you from doing that:
https://lore.kernel.org/linux-cxl/169878724592.82931.11180459815481606425.stgit@djiang5-mobl3/

Otherwise this behavior is expected. If you don't offline the memory and force rip away the regions, you get to deal with the consequences.

> 
> I made a few investigation on this, the panic was caused during the process of resetting the region decode in preparation for removal within the "destroy_region()" function in cxl/region.c. When the value of "/sys/bus/cxl/devices/root0/decoder0.0/region0/commit" is changed from 1 to 0, it will invoke the driver code to reset the region decode, which in turn leads to a kernel panic:
> 
> [  397.898809] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [  397.908416] systemd[1]: segfault at 0 ip 0000000000000000 sp 00007ffcdc242520 error 14 in systemd[55555aef50)
> [  397.910578] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [  397.920233] systemd[1]: segfault at 0 ip 0000000000000000 sp 00007ffcdc2416a0 error 14 in systemd[55555aef50)
> [  397.922309] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [  397.933175] systemd[1]: segfault at 0 ip 0000000000000000 sp 00007ffcdc240820 error 14 in systemd[55555aef50)
> [  397.935553] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [  397.945611] systemd[1]: segfault at 0 ip 0000000000000000 sp 00007ffcdc23f9a0 error 14 in systemd[55555aef50)
> [  397.947751] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [  400.474068] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [  400.474583] CPU: 2 PID: 1 Comm: systemd Tainted: G           O     N 6.6.0-rc6+ #1
> [  400.474583] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qem4
> [  400.474583] Call Trace:
> [  400.474583]  <TASK>
> [  400.474583]  dump_stack_lvl+0x43/0x60
> [  400.474583]  panic+0x32a/0x340
> [  400.474583]  ? _raw_spin_unlock+0x15/0x30
> [  400.474583]  do_exit+0x9a1/0xb30
> [  400.474583]  do_group_exit+0x2d/0x80
> [  400.474583]  get_signal+0x9c7/0xa00
> [  400.474583]  arch_do_signal_or_restart+0x3a/0x280
> [  400.474583]  exit_to_user_mode_prepare+0x192/0x1f0
> [  400.474583]  irqentry_exit_to_user_mode+0x5/0x30
> [  400.474583]  asm_exc_page_fault+0x22/0x30
> [  400.474583] RIP: 0033:0x0
> [  400.474583] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [  400.474583] RSP: 002b:00007ffcdc1579a0 EFLAGS: 00000207
> [  400.474583] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00007fb10db2796d
> [  400.474583] RDX: 00007fb10db2796d RSI: 00000000ffffffff RDI: 00007ffcdc157c70
> [  400.474583] RBP: 000000000000000b R08: 0000000000000000 R09: 0000000000000000
> [  400.474583] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcdc94dce8
> [  400.474583] R13: 00007ffcdc94dce0 R14: 00000000000004bb R15: 000000000000005d
> [  400.474583]  </TASK>
> [  400.474583] Kernel Offset: 0x20000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffff)
> [  400.474583] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---
> 
> According to the panic message, the systemd process in the system encountered a segmentation fault (segfault), resulting in a kernel panic.
> 
> Test Example:
> 
> 1.echo online_movable > /sys/devices/system/memory/auto_online_blocks
> 2.cxl create-region -t ram -d decoder0.0 -m mem0
> 3.python consumemem.py         <------execute script
> 4.cxl disable-region region0
> 5.cxl destory-region region0   <------kernel panic !!!
> 
> Thank you very much for taking the time to look on this issue. Looking forward to your response.
> 
> Best regards,
> Quanquan Cao
> caoqq@fujitsu.com
