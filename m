Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5918455E
	for <nvdimm@lists.linux.dev>; Fri, 23 Aug 2024 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724414964; cv=fail; b=SbNFDT93c416NScfeH7pLH58Nea7uaIPnuIStdlrSxCR6nr4E3DYuPM0kbPYDtUPi4NFiOYdOCxhs261D5E4Uw/aSsS6s7bJoIwP8jFV8TJxrJohLMi9807neI42rOklkXQ+QMD9xw8GFyg6wmIHMLMmgTWEMEOla9g042M/BEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724414964; c=relaxed/simple;
	bh=JfYcUGL7TAitZ6P1esJANRlnZKinTUbYzQZ/ZR3SAZs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hewGWUClFAfcwzf7HaC+CrlMpGbISReIqOeNFjx5++ulj3qXCCEYkwrOWU8FqEDup3RYJiMxw84JQinFo6HUreQOA1jK9cfQ7RrUMKnz+nloF2tnC9B86qZR98EELRNIFEcnp/CyYhjExmo/X3J9xuyOBge3f4olr0lqCmYx+zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=St+4Fi+y; arc=fail smtp.client-ip=40.107.101.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="St+4Fi+y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Di5HCg6CyQKPKZOxhyQuskJ1/re5kQbZdcjn4V+QMixkLtX9ED5g02mAJTW2iES4gl0OJW/f3pYbCOuT6C0TPgcGkawUaoDq9gnFTVT2Fd7eCCyZeoivVupVl+ar/o8qmclu62VQpgg5iRBWcmfm22QcN5ApX8q+bBnrjqAEu8NyKIMPpg5v5LwY6Qm6u5Ia38vv7LHi7lmkAdcdXFyTXCZJTek8frtE0YomCidDxmnXbXLf5CEc4OnyNTtKus63jWSBZpmwz6DPxJpeUV85W2PnviDSbGCBiBsCsq+xkw5cYeC9P0QY6usg8HhihOZTyI2D64z3Cf3qPFgc3GVONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lBFTxHXqNGmWnP6KLFwEo63L/t1H4Um4N9zuiV3MRA=;
 b=EZfF/BKEqf8xB3Wj0+GLP4D3TGb+rUmQiCqrUL+R0ELr3DKsy/5sGTkuxjhskT03nmZXadz5re/b5yhthdzZToIKQ/e/wNzmOefQQpMvgYVaPwNWdB4hwtEiPBuyzKuVtSjfaaYGl29NpU7gmBMUsYy9kmYoWJNeHNlMmrcAMcyE4DL/6LP4htvd6SpyETOYSBHLJSVPODtey9oknqMJ9Hl/K6Z02afIvjD+RRlhoGuFPFFmSr6xSGKKkT2SvdM3Da2JaYRRnd6Cb0mt6nJWUY+Je+wrHf9aFrys027ga5DWh1CiMxD8poAb6AxiVRhM66dzTVWg0fHif1wMAzksYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lBFTxHXqNGmWnP6KLFwEo63L/t1H4Um4N9zuiV3MRA=;
 b=St+4Fi+yukAOLQyJ8avwgQntGl+ecrJ3THGqVNEEcKTWopbEbY/hVtWv/pyWtAixqy04s79eamxR2q2iO4kMCjt6GzKRymHft47LzRuuHB8zjG0/NaEp+i/Fa0ZlwI8G8nbTzFWwZvGV/u88o0vcbde9c5U6JqwT39I2E349eQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by CY8PR12MB7657.namprd12.prod.outlook.com (2603:10b6:930:9d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Fri, 23 Aug
 2024 12:09:16 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.7875.019; Fri, 23 Aug 2024
 12:09:16 +0000
Message-ID: <0bae453d-b4a8-3132-9fd0-bca0eece6a74@amd.com>
Date: Fri, 23 Aug 2024 14:09:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] device-dax: map dax memory as decrypted in CoCo guests
To: Kevin Loughlin <kevinloughlin@google.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: changyuanl@google.com, pgonda@google.com, sidtelang@google.com,
 tytso@mit.edu, pasha.tatashin@soleen.com, thomas.lendacky@amd.com
References: <20240814205303.2619373-1-kevinloughlin@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240814205303.2619373-1-kevinloughlin@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::17) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|CY8PR12MB7657:EE_
X-MS-Office365-Filtering-Correlation-Id: 263e40e4-ea1a-407b-bd96-08dcc36c68a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWFYLytkcEZZZi9WZi9kUjVhUnR2bi9aWFpOdDhwQ2JuR3oxVVltL05LeitV?=
 =?utf-8?B?UTFvc0l3dzRyVXhnSlptczhEQ1ZPSWt5Z2lYczZxQ1QxZXB1LzFGdFcrYU9l?=
 =?utf-8?B?V2hEM1RVaWF3TzJUc1dyaVduN21NQlQrRXNTbWtKTTZQb1YxZWVUQXJvUXEy?=
 =?utf-8?B?UGt5N0VrNGJYNkRZTVJlb2F3QWZRQkNNVTg5Q1g2bHc2N2VBdzlyU1pVM1NZ?=
 =?utf-8?B?M0hpM0JkRVM1NWZ1WWxDQWMvR2xqS1RXQ0h4RENOMVRCaDRsMlhHd2kxa21X?=
 =?utf-8?B?alVzVE1SVFBoZnI4MEJlaGhuU3Z5KzdHYnEwYXg0a1dIZHpaczR6SFR3ZFlt?=
 =?utf-8?B?YU1rY3E5bDI5UlNUaStud0huYmN5UStTQUFhS3JXbXRTVG5GOEV6TlhSd0lS?=
 =?utf-8?B?UUZaMld6MHZBaGE2YXkvekZmeVF1aWwyOGFKOFk0YTN5dDAwbjhRd0ZLSTNU?=
 =?utf-8?B?aGxNZUVrcGlLNGtycHZQZVFMVTBmeFprQzV6VFZiSisxV0gwYmFPUmdCdFVx?=
 =?utf-8?B?Um9ZSVNoNUw3Q3BabnBpQUxlUGRObjZPenExSUdrY0hJbTJ5T0VCbjRMdjZP?=
 =?utf-8?B?dzNNVkFoVzJkeXZyU2JnNFZDRzJQRlF1dVhhYXdJWTI2Tk4xYXJsTjVCMGo0?=
 =?utf-8?B?NGtCYStpY3pycHpYNTFpZ1lUbmQ2MnB1OUZsaVJ6WTFRL2V5dHQ1OHJNNlFH?=
 =?utf-8?B?MHhuc2pPK3ZPUDU4S1F1aDVlSzExZzNWOStYVHZjc2h0R1pCd0xMeE1VTnVR?=
 =?utf-8?B?Umxqb1ZzZWpJZXl1dWpJK3p2aFhQMDhOMlBjT2FxdGhrb1FvUWZpUEIrcVV4?=
 =?utf-8?B?VnB1dnpxUEVlQTdKakVtUlB4M2dHOXkva2Q0V0M3Yjl3MmdYZGtRdjBCRm1q?=
 =?utf-8?B?MWtQTDJlcWxGeHVURFhYMFRmbkFyWUJXNCt4WVVLZHlOL0J2SXF1UTlJOUxO?=
 =?utf-8?B?ek9NNDFqSCswTzVuTURUcjA2WEFQQ0NQMGFCdkpwUVh0TURYUC9pMCtNZXBx?=
 =?utf-8?B?MDhWTEZFQ2hUellCcmN0dnpMYi9DaXByd1RzRjZ2T1l1b0YvNG5XU1pVRHYz?=
 =?utf-8?B?S2xwbXI0c0lVdzdaTFZzeDlIdHc0anZ1MEpWVjVhSnVnSGl2ZzRDb08yU0dV?=
 =?utf-8?B?Z2J1Z2pqRXU5Vnp1ZnpxTEw5WDZ6ZnFBVEVpcmdjejRpQmNhRzFFTVF4R21u?=
 =?utf-8?B?WW9vSWJZbHBxNjNWRlphcHJ0RVV6Zll3TnZ1U01GVG5WeXFIeW9EQ2k3QzB3?=
 =?utf-8?B?RTZrN1ZRbE1VbGtvWTVYV1hBQ1BrNGRGajI2bHBRMkpvalRBV0lQNDNIdWdO?=
 =?utf-8?B?T3BVZ0Q0NzRYV2VtSlEzeU5oVnJyREVpOGpsMzNBcFNNYWRIbTBrd1RuWnRm?=
 =?utf-8?B?WHhUOCtIeHZvdnZsWWxzUXJ3UXpCMFVlZEJUMy9zb2EvUnN4dW12M0hIa3Fh?=
 =?utf-8?B?Ny9xNkR0OGMxTXo5K0dlSlhickFrcFFiaFVzcEh1VTVBWVRlMzZwMTBRQnNy?=
 =?utf-8?B?TmdxVms2QWF4MlZ0L0h1K0RZRm5pczV6R0hUL2V6WUVRdWNCaTg5S3R0TDBt?=
 =?utf-8?B?OFVmbkxGaktXdFFpNEdDRE4rb09sLzRXTUNPQXlwN3FoU3h3ZXVvS3FpSGZ3?=
 =?utf-8?B?Z1RCeFQyTXRnbHFxYkI2WFJ5eTA1VW5sMFdKb2tNQ0JDcm12SFNpU2dKV2E5?=
 =?utf-8?B?SkdxNVY0TmMzTzI1OVhKZDFVcVVrNExWT3RqSlUyTUllNXJFWlJMMFl2U3J5?=
 =?utf-8?B?RHQ0M29tVUc0czh0T0JNUW0yVnRpdnhGcGJydWtYSmpCY2FIblZiNUIzWnNY?=
 =?utf-8?B?dllPbVk0bXM2aTRPUnVDZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXZMZ2cyRDcvbWNuLzJPeHFlU1ZVSDRRTDV2R3hEMXg4MExnRDNQYUpWOEZu?=
 =?utf-8?B?MTdKODlCOEVhRjRNZlBnNXZ3L1F3aDFocE1BeHdwZ3Nxc3gxRWp2RzZ0RFFn?=
 =?utf-8?B?UzlkL3hGdURYQzFOaDd2ZDRvMkVhSUxSOGVWbkJxdWs2RThYczJWSnZGTWx2?=
 =?utf-8?B?bHJQbEROWWZ1U2s5QWphR3ZaV1dYRFA4c3R2cFJTNm1qMmgrMzE4Y0d6aUJV?=
 =?utf-8?B?UUVQa1dDTkZwVjFmMXRQcG1zSWdEWXVwcGRMSHhnKzIyRDY1dC94dUgyRlRo?=
 =?utf-8?B?NDMvVnpsU29RVlpvajFXT3l4aXhybTVGSVo1bkVFQXQyVHFaclBJNzRBUDNV?=
 =?utf-8?B?NTJsY3FBMEJrK2RiRHhocHA0ZUlZSWZWM1RiQkZudWZZZ0NoelluZTM2a3BF?=
 =?utf-8?B?by9MbXlnNWludXEyVXZEcUlJU2xPa0Flb3NyRVJRUlNoaWliNC9oZExHUnpH?=
 =?utf-8?B?dVhOb1dvOHVCVzRTSUExYnM5L1RRYXhJVzJtbW42c0J3anVhaHZnNHdlT09O?=
 =?utf-8?B?eVUwRFVqNzlZMnN5dG5pRnVvamJrSXIzMlBmM0d3ZjVXQmtHZTZQeVREaENS?=
 =?utf-8?B?YWVjNWhFZlIrZDNvMWJkdE1OKytLRlpIT1NPbS9PaFdhT0NEY0VBMDduWW1i?=
 =?utf-8?B?WXNrenRNVjlYcllUL0xsa0hZSDRoZHpzQ21xc1Y2R250MjN3eE1iU2hzUG5w?=
 =?utf-8?B?U3ZFbHBLa1NLNjE1YlgrQy9YczJqTDY2SXNWbHg2R01RT21YTHN2OWw3am5L?=
 =?utf-8?B?WlJyWlY4ZTZQQndQc0FLSnM1MlgwaHVCa0ZLamFSRVg0M04yS1dvakh0S2JT?=
 =?utf-8?B?SG5lVFlOUmJWb2hiVjBFQ2EzYlptaU1za0liZmREOXE0VkVtVDBQNWZlUndI?=
 =?utf-8?B?OGdnUC9CVWl4dHJOY0RNcGZQc1VtY1dhT0JBVXFHTWN1Y2VXOTdFTm1lTUI0?=
 =?utf-8?B?VnlMdWZHVk9mNnVmYnZoRTMvRHplak0vOGxiV0tmMnoxVG1DZnJCeU9oTXNQ?=
 =?utf-8?B?YWRhK3ppWmRSUjRqcmNYRERvb1pmRm80WGRTS3p2MkZJTGRjQ29lMG50UVNV?=
 =?utf-8?B?QzJFRFpzQzFlSEJIV0hkeFlrMjd4a2hBOHdwVzBvR1pOSXZ0ZTNiR3l0aE9Z?=
 =?utf-8?B?Nzlqem9qSDh2TWNLM3ppUlA2UERhZnNOdXptbzVGWUQvVnRmcmUvazByR3J4?=
 =?utf-8?B?cG9YRG56MnRueDlCS1pvZlhnK1hvcm9JSXlHU3htaEZVMDZZUm1IK0l5R2E0?=
 =?utf-8?B?YXVVd2FwYVVoNExyT0tia21FN1lIeHBHRm1GUG1pMU1zZUZNZXdoMFNaSm5k?=
 =?utf-8?B?YlFyQVBzeTZqTi9ORW1VbXY0U1dJRUdrTWlzcTF5cEVIeXNjYXo5WHdVTHdS?=
 =?utf-8?B?MSt1a2xaVmJsdzJCOGdnbE5DVDB3MjNETzB1V2RaSnFBamxlUlJMcTdrM0F0?=
 =?utf-8?B?N2E4anVKS0xZcmhWdG5BZDFOWTVCMlVsZCttdXF2cEVaY0VtQjBURHR1QkV3?=
 =?utf-8?B?RnFvZDVrTHRndDdMbEZJL1I1TjYwUFAzMHN2ZWQrcnR0MzBUWDhqdldDMkJD?=
 =?utf-8?B?QytRV1dJKys2ejZhRXcrQnBFOFFUaW5ycWV3TmIzWUpoWXp0cEJ0b0dqT0dP?=
 =?utf-8?B?WGs0Y0FIVlB4VGNyck9JdXJUWTdTaVpFYy9ZWmNMYTlNQllvVmlxK1VveE9Q?=
 =?utf-8?B?OUNyTGZRV1FkczhGZUFsSXQ5cloyV1lOVzJuZmRpZjIrU1dwSzJjWVNBa292?=
 =?utf-8?B?OGErSHErVkY3Wll3UDUrMjRUdHJveHRVaGNmbzQrbGZIN2tuL2FxYktXWGhT?=
 =?utf-8?B?cHFJSUpFQUh1LzZEb2tGL254L3d1dG1GTWRlbmo2cm9jUG9ET2htKy95QzQx?=
 =?utf-8?B?c0ZkRmtlRVc4SFJtYnBCREdqMlpjOFRVZG15eDZ3KzNWQ3FDa3lwV1NrSGY5?=
 =?utf-8?B?UEVKWDZ6cHNJaWNnZFEvUDRYQnI2a2p3TUwyRkUrWWlJVTdRZEVDeFVkejN6?=
 =?utf-8?B?OHprblBNRWhoVXVvcEYraC9XYlF4aVlMejZ5NEJWelJ2SzkzNG5TZDFmc0V4?=
 =?utf-8?B?UDZzNDNJUCtGajBxK041bSt2RVRnYjhWdGVuYmNNUmlNcTc3TFh0Qzk2M3hj?=
 =?utf-8?Q?/7uWwh2R789MXJZ4wosWH+FUp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263e40e4-ea1a-407b-bd96-08dcc36c68a9
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 12:09:16.2350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZ8PH7e3huwSRVdOdVlu4AOYkd6fmNxDFlvv0iGJSCnAJUJRe4uFIcy8qaLAWyGS7NWz9oFeyMkOA50Mn4V12Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7657

> Confidential Computing (CoCo) guests encrypt private memory by default.
> DAX memory regions allow a guest to bypass its own (private) page cache
> and instead use host memory, which is not private to the guest.
> 
> Commit 867400af90f1 ("mm/memremap.c: map FS_DAX device memory as
> decrypted") only ensures that FS_DAX memory is appropriately marked as
> decrypted. As such, also mark device-dax memory as decrypted.

Overall patch seems OK to me.

How can I test this? Can I test it with virtio-pmem device?

Thanks,
Pankaj
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.co > ---
>   drivers/dax/device.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 2051e4f73c8a..a284442d7ecc 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -11,6 +11,7 @@
>   #include <linux/fs.h>
>   #include <linux/mm.h>
>   #include <linux/mman.h>
> +#include <linux/cc_platform.h>
>   #include "dax-private.h"
>   #include "bus.h"
>   
> @@ -303,6 +304,8 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
>   
>   	vma->vm_ops = &dax_vm_ops;
>   	vm_flags_set(vma, VM_HUGEPAGE);
> +	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
> +		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>   	return 0;
>   }
>   

