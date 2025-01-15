Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341CB29A5
	for <nvdimm@lists.linux.dev>; Wed, 15 Jan 2025 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736949352; cv=fail; b=RtdCJB5vTwlyh/xQslp9vMpU0VNs6bnBksT7T3e4xxgBrYAO66s7s13sXvIx2SrQkm0liNx2nFL2WkxGmSODkNEXvBX34OecjIcEz5x/h4EOZ2tb3e43tIyZDEnilK379Sx3fP7gZg/Br3k6p4V39sfD/RKx1MErpLW9QehUVyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736949352; c=relaxed/simple;
	bh=HoQ9ZfgM8u2ObBJVuTeVjzMjhDHZMcPgH4AB0/oBeUQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D8iqqJC4JU+8JrT7e0r7jlXVFXkwsClkBNLl2Dpb7diyTcVKDPXZFN/Md0vUVgs3TDGM4s1iExGGBN27P27at93WY+rhJrsUJShiMKqv2njnAbNbWj7g5dkhHg97geNhAmaRI82xr56xiRMpzTf/N69KsM1SVcJYsvPZuxyxY28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DZ18YJwh; arc=fail smtp.client-ip=40.107.237.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DZ18YJwh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pltzNG5rMAVJoJ6mXCWiyd8GmIfWNNL+6u1WKHM/x1dIEyge5wW/z9Q4H5LaIo4/taEscu9s4M/iDwIPHoSdJFz97gzUkuWR6dnlHg8L1Hr+f28mUogF0N5OJy2f05lxvitIWUzutr3XrWZkIFNO+NzxS1SlxcZDPPzFTlRjvG6ynCIDGWHGztfUbpplJ3wYqqDhpoZcED21Z6wvDfKlxW8jx6HIJ6VLATo8DUXHeSbZ168LvxjI2/cOOvmOQQ7Np3QYiX37XVxenuXjnGBPAQBD/76lDoaWz+uAsNc96xH6ngCcZQbDNhr33tsoZXhwymttTN//qEDdRX3bYz4n3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sv7BjvCOen48rjb7bUmA5T36kCIVTGcpOWVkBNB6e+o=;
 b=BUCmurFWq9SQHYakuxAx4Kt3jQy8dib0styjswgxe+zwaXnFoM0fOxX92HoIG6bgOlMTVtyYa02gCdSSp7eReNxYeXtujMKf/CoQSyhNEbzGQGTJVsa4wxquD23NweGk0HeXYo9QHcDem7kg7MlGCVc91Ry0YvyMbR/5v5FG44XQe6SBxehMeM0pn2vVKmQjp7PioKy34xJHRnq1p5b87n7TytdObk3lPcZCLczlqHrDVRX5UXAbF0a0hw0xycxtq2IypTEceYSea6KWrJNKOezHX6ng6PJt8+xn9UqtH4GlN4EgrCjAaQWO3g9pBCCe3vS9AAksQw9Xw8xsY8oO9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sv7BjvCOen48rjb7bUmA5T36kCIVTGcpOWVkBNB6e+o=;
 b=DZ18YJwhtvn3vFWSEP1BhzcwHPHS40l5m9kFsQynabQvtTjo1WGJX3TkQe7iZ+C8M6BjfmDol14O+8hir6v46oIcJ7teYylukNZZO43NlnWJ+t8FeeZ5PKP82ztqjwRh9O86RF2iGftEV3XJNXhT/h2v4cTLqGEjy9tyf3/ch5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 13:55:46 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79%7]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 13:55:46 +0000
Message-ID: <469ac491-8733-986a-aaae-768ec28ebbec@amd.com>
Date: Wed, 15 Jan 2025 13:55:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Li Ming <ming.li@zohomail.com>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0292.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::8) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c3f1690-7c30-49fc-a5fc-08dd356c4f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGRmMzNpMVkrcE5WRkdSL3V6QTk3TkxUNkJJN1RaUW9UTnZ5Z2VIaWVVN1J6?=
 =?utf-8?B?Uk5pWFpRTGd5dDYxYnFSQzlhblBERnBTZXllelllNStKSnJoanZDRU1aOHZC?=
 =?utf-8?B?M0dldWo4eXFzdENmaVIwSEp5Y2pLamR4Y3ZuTXZiMUpOVFhEVnZRb2dZSW1k?=
 =?utf-8?B?NjhTN1RTSnloclFUbjU1a3YzakhGTWVQUkpyZXhBRjJ5eWg1NGV5NDEydm9v?=
 =?utf-8?B?S0xCSFp0MHBjMytvVkFsamxpMCtxQnkxNXZzY3ZFYVVtcWV1T1RGZ3RLV2pl?=
 =?utf-8?B?QW1ld3ZZMWhkQmdzTXgwVlIvYXRsSithN0JWSUxWaHF5ZWtIUnV4aWVvQWNV?=
 =?utf-8?B?UGRTYVFlZVdkZ1N5NmQrUHd2ZWVTMENSVUk2K0s3dUNLeThCZ2doa2pIUTRO?=
 =?utf-8?B?U3hKTWVFQ1o5blRFUXFLTlk5a3JrSDZoUlRPV3lOMWxUWXE5WUorTUxLbytT?=
 =?utf-8?B?UXE4NVNEVTF5UlM3R1lvbkF3TERBVjVSaXN6Qk1DYkhiZE0yM3crRnltZ2hk?=
 =?utf-8?B?clg4WXdaaW1jdUhvY3AvQWMwcUZGVzVLRGxpM1VRZ2ovSFFTVGpLRWttRmF4?=
 =?utf-8?B?NlN1NGI2dk4zV2ppVk15cHZxcTBpTXp5K1ZDNzBUZEd5LzJ1cFZFbHRZZ1l0?=
 =?utf-8?B?dmlmTEdGeE4ySkw5OG5FYU9YK1BQN0hzRmtrVU5WTjdkSlRPd1JCVGZBaWh5?=
 =?utf-8?B?SUV3b3UwNGFZUFVmVHJNL2FKaGh5OTF4M0JvTkgvMFUyWmtiMEUwcUlkSmh3?=
 =?utf-8?B?cmJadkxFRW8vYnovQWxCVjY2SklRUkp1UStocmdwdWNtRUZlbG9YbVEyUHg3?=
 =?utf-8?B?L2tndjlwSVA1dXBESm1PbUQrTHo5UGd4cDdyK09qRG5lSjBrNko2ejlKY0xF?=
 =?utf-8?B?dUJuN3pOSVpoWnh4T01EUnNEaXpjMmRjQnNYcDZhRmx1NjBBUTB3R2ZBRjI3?=
 =?utf-8?B?aUhuVm8wbXNoZmJNdFRRWG5mNTcrZC81V3dBYll4UUtidXAxTWw0UnZIcW41?=
 =?utf-8?B?Vy9SZ3ROOU5NOUpHWCtWODJBQ0lJUythbUdybmhGRy9XaEtiMk5YMEx3bWlr?=
 =?utf-8?B?TTRpSkV0NXcycldWSnptMWk0WXp1ajNFc2NGYmRReVM1dk9EUmI5OW1PMDFo?=
 =?utf-8?B?dWRwOEl4M3VTSnl0S1I3UEo4S2JJanhZRVg1OVpjM0FIRk5QT2NQUkpJU0x3?=
 =?utf-8?B?cjA4OXdOKzM2Ny91NVhWQ2l1b3k2WEJuajNGWlkzNndlQW9mVzlKQkNYUExU?=
 =?utf-8?B?cHB1RUxsdi9XWHZKK0dpSFFWSlN2Mi9ReXQ3SU1rZC9EdHJJT3VuTkxUSVZC?=
 =?utf-8?B?Zkx0dUxGNGt2WmtOaGt4OSs5eUM0Sk54RjkvTnJGelBOazA2VERNR01xRjVh?=
 =?utf-8?B?b1dBanJzMHNnY0N4WE14UVZtUGM4aFEyak5nMURDUnZONEZleGlvQklkUTZm?=
 =?utf-8?B?NHBqWjNuR0lSd01jSk9yNmNRYWFWQ0xyRjBIdXNWV2J3U0ZVOWJaVUwvWjJK?=
 =?utf-8?B?SlcvRGtwU3lKRUlDeWlNdXlzU0htdDFrTUdxakVWNUxydXp0WXNmeDZ3UmZO?=
 =?utf-8?B?Z3NnT0hoWEtHY2pnYXJNMjV6WFA0S3B5VVdMRDJYdlc4ZzhrV2VHQjM3Z1A2?=
 =?utf-8?B?TUVZTVFpcVVQejFWQ2dJVjlIb2ZESGFRQmlCRWZwT1RrV2JnSUlEMGk5S1k1?=
 =?utf-8?B?SkFmMkhXNXhKc2tpdjF0NzRSV1l6S01meXdVS29XeWczcDQ0UWRtSkloTDVF?=
 =?utf-8?B?a0ZIVTFqOFZ2eW5FR2pmcWFVMWN2RzZQZEJyb1JnRFYyTzUrYTByNTNBQVhH?=
 =?utf-8?B?YkFER29YZENvUzNKL2JhVHBTWDY2enJEN2E5ZEo2T1FkTzZYS2FaQTF4d0t2?=
 =?utf-8?Q?78IuUCOefG+DF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlI4cDdZY1NBcWNyaGdwYUFvcDF2RzdWdERwQ0IraTNjaVJzOGhFWmcxOTZl?=
 =?utf-8?B?cFFRY1g0VWpWN3QxWEhTOTZHOUlHMWJGVnBYWmc0Q28xMVVLUmlBWTFWbGlq?=
 =?utf-8?B?RVNKY0lXQ2Q2TVRvYWVXMXNyeXQwTmpETXVOTXR1NlNRb3dDMHRqa2ZMZXNO?=
 =?utf-8?B?cDRkNjJMYlFWUThZTmFjVTZrcmFwTlVXNGIrMklpR1VDNzloUDU5ejIvRjJY?=
 =?utf-8?B?S3VOZ0xIRmhzaGpVVTZjQjhOVXA0Nm0wSFRrSDdzc0pRYm1ZbnpjNDljR3Bq?=
 =?utf-8?B?YWtwQmxnem5sRWxzZHFPclEzVm5ld0FQOWRQN25CSjZZQjUxUFlYOE9YUkpI?=
 =?utf-8?B?UlBsWVhvOFNWVlF2bXFmOXpPUTdVNmlkSjlOdVNBY0pET25rSGZWMXZSVHBv?=
 =?utf-8?B?U1d0RUlwbXNlWVV5amh4VGNPWm9ETjVDMnZCUS9XNXpSclRwUGFadFNJSncv?=
 =?utf-8?B?NEJOVXh4K0pKZzJnd25Mb1Z1bVJEN00wTlhnNzc3dDhEM1VqVnlrQnNoUVZn?=
 =?utf-8?B?NE15RnlOY1RDS283RldYaG9BdEdTSXpFemRwMTgrWTZ5SkVyNExPcExjNEY0?=
 =?utf-8?B?THRycXgvbFZpWERidTErR2pUaElOOTIvL3BaM3Q1bVJmZ3lYdlRlMGxUQmR3?=
 =?utf-8?B?enczWHB0MlZESmVObVRSYytaZXE5ZnhYR1lydTNhQ1MyOEgzT0JaSmVyVGI5?=
 =?utf-8?B?dklDWFJKTEx0Rm1Kc09HQ2FockZmREtWaGNtd0ZFZWp4cXBHd3RvVDd4ZWhz?=
 =?utf-8?B?bHRJOGhQVmJCRkJqR0tkQUZyZmZRUXFqUUw3SUo0T3F6MWU3TTFHa0xkYTNk?=
 =?utf-8?B?SFh0SlNtT3AzZkVTZytzV3VQREV6MHZTcXRuWUxwc0ltd0ZDYlFodll3Y2Fs?=
 =?utf-8?B?ZmdEaWUyTktmT3lBMXdtdkF5THE2Y0VwcThmemRSbVNiMkJyNnFjamZob2hz?=
 =?utf-8?B?WVVSTkJ3MytVOTdiZm9pOVR1bmh3ZUcycG5VWmVubUY5SlFyTitPWnltUUJr?=
 =?utf-8?B?M1JFdFlhdGxxOU1MZE1JUzcxTXoxVGthTEtpdG5qbnAyMmRXUDNpVExpWDZ5?=
 =?utf-8?B?UFZURk04ZVp5RGVJckdVUHBUSXpBcFRvT056T3Q3d1h6bUpuUjJRRFRvUW5T?=
 =?utf-8?B?R1l3UmVCWUN5Sm81VzlBSlFKYkVyKytiVElZWVQvWFdjQWVscWFwQktoZHlZ?=
 =?utf-8?B?Y3JrbjJjSkdnb1RTMkZUM1c2Y05yRkxJcy8yNm9qR2JvNVZEcHV0bTRVd0tj?=
 =?utf-8?B?ZnJVbk0yZnZ1WStXR2ExRmZWNXlHVElUaFREYUc4UnNpYVNSYjZtWHEvS3NL?=
 =?utf-8?B?Wm8xUzNPRUtJYU5xeG9tRngvWmt0Rm5mbVhVdTJYMkNIMEJzVXcrak05QTNo?=
 =?utf-8?B?cHRtVkpkNHhoN2pRVEFGem1kdmcrbFR5RWFMVjE1MStMWXVlWW5pa0pxblBp?=
 =?utf-8?B?R3B4UHg0UnlUSjFWSnNKL1lJYjQwTDN3RVZsbmZGdXFSRVN6d1BaVDJzUjBi?=
 =?utf-8?B?UCs1K3BFUGhXUzR5bWhPODNITkxCVmtPaE5PNm1XRVp1R2w5T1NvVVp5bHpD?=
 =?utf-8?B?TlJNd0tFc3JyVTVrTHZSNTdFVEdSY0lSQjdNZ2NFbWZsWU1wcDhGb2hUTlUx?=
 =?utf-8?B?ajFFZ3NuL1NoRFJaeXNMbjJrWVpUNG1DY21hblNTUGZMZ3c4eXFNNjRySFhQ?=
 =?utf-8?B?RmFyZGN0cVJpOWpIN3hSVHdEMlFsS0JyM0dYd1ZhenN6VURIaElRaGNDdHBw?=
 =?utf-8?B?Mm1pbUFoSFZDeHd6TG54NHhtenI5OTdoQzl3bWJaYWxPVklWaUFaYmd0Tk12?=
 =?utf-8?B?SkZEWEJjOW9GcXEydDhZQUtPcmdYd0pCUEhBc0xXRlU3b0R3Tk9ZRjJSc3NO?=
 =?utf-8?B?Z01udkhNUVB3REptY1E1RTVUZE1YZzl3VzhmS0VteDUwRmo5bmswR0JyZGtV?=
 =?utf-8?B?WS8xOGpiWHk5LzE4R0xuM080dHJnU0d3Q0lXaGpoVjVEdTR6L2d1VUs3a093?=
 =?utf-8?B?MGNmYzdOZDlPa0diVVpDN1EzdmNJcklpL29LT0VrdEZPRHdWc0JqUTREdzM1?=
 =?utf-8?B?VS8vU2gxNFpYd3JVVHc1R1RyczIzZ3AzYVJCVEZFeDBwQUl4Vm5PaHBlcmdz?=
 =?utf-8?Q?dcNGM/0bS00Zug1Beg+hY9gxE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3f1690-7c30-49fc-a5fc-08dd356c4f5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 13:55:46.5120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ts7AxwzLKOOeaCVxXyK/2WUO/fL3AjkwGvvfb05x5DLPxKK5aat4h5LNl1FGmh8d5wiEw5nSJjFnwt/WkUC6Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631


On 1/15/25 02:35, Dan Williams wrote:
> Ira Weiny wrote:
>> Devices which optionally support Dynamic Capacity (DC) are configured
>> via mailbox commands.  CXL 3.1 requires the host to issue the Get DC
>> Configuration command in order to properly configure DCDs.  Without the
>> Get DC Configuration command DCD can't be supported.
>>
>> Implement the DC mailbox commands as specified in CXL 3.1 section
>> 8.2.9.9.9 (opcodes 48XXh) to read and store the DCD configuration
>> information.  Disable DCD if DCD is not supported.  Leverage the Get DC
>> Configuration command supported bit to indicate if DCD is supported.
>>
>> Linux has no use for the trailing fields of the Get Dynamic Capacity
>> Configuration Output Payload (Total number of supported extents, number
>> of available extents, total number of supported tags, and number of
>> available tags).  Avoid defining those fields to use the more useful
>> dynamic C array.
>>
>> Based on an original patch by Navneet Singh.
>>
>> Cc: Li Ming <ming.li@zohomail.com>
>> Cc: Kees Cook <kees@kernel.org>
>> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
>> Cc: linux-hardening@vger.kernel.org
>> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>>
>> ---
>> Changes:
>> [iweiny: fix EXPORT_SYMBOL_NS_GPL(cxl_dev_dynamic_capacity_identify)]
>> [iweiny: limit variable scope in cxl_dev_dynamic_capacity_identify]
>> ---
>>   drivers/cxl/core/mbox.c | 166 +++++++++++++++++++++++++++++++++++++++++++++++-
>>   drivers/cxl/cxlmem.h    |  64 ++++++++++++++++++-
>>   drivers/cxl/pci.c       |   4 ++
>>   3 files changed, 232 insertions(+), 2 deletions(-)
>>
> [snipping the C code to do a data structure review first]
>
>> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
>> index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
>> --- a/drivers/cxl/cxlmem.h
>> +++ b/drivers/cxl/cxlmem.h
>> @@ -403,6 +403,7 @@ enum cxl_devtype {
>>   	CXL_DEVTYPE_CLASSMEM,
>>   };
>>   
>> +#define CXL_MAX_DC_REGION 8
> Please no, lets not sign up to have the "which cxl 'region' concept are
> you referring to?" debate in perpetuity. "DPA partition", "DPA
> resource", "DPA capacity" anything but "region".
>
>

This next comment is not my main point to discuss in this email 
(resources initialization is), but I seize it for giving my view in this 
one.

Dan, you say later we (Linux) are not obligated to use "questionable 
naming decisions of specifications", but we should not confuse people 
either.

Maybe CXL_MAX_DC_HW_REGION would help here, for differentiating it from 
the kernel software cxl region construct. I think we will need a CXL 
kernel dictionary sooner or later ...

>>   /**
>>    * struct cxl_dpa_perf - DPA performance property entry
>>    * @dpa_range: range for DPA address
>> @@ -434,6 +435,8 @@ struct cxl_dpa_perf {
>>    * @dpa_res: Overall DPA resource tree for the device
>>    * @pmem_res: Active Persistent memory capacity configuration
>>    * @ram_res: Active Volatile memory capacity configuration
>> + * @dc_res: Active Dynamic Capacity memory configuration for each possible
>> + *          region
>>    * @serial: PCIe Device Serial Number
>>    * @type: Generic Memory Class device or Vendor Specific Memory device
>>    * @cxl_mbox: CXL mailbox context
>> @@ -449,11 +452,23 @@ struct cxl_dev_state {
>>   	struct resource dpa_res;
>>   	struct resource pmem_res;
>>   	struct resource ram_res;
>> +	struct resource dc_res[CXL_MAX_DC_REGION];
> This is throwing off cargo-cult alarms. The named pmem_res and ram_res
> served us well up until the point where DPA partitions grew past 2 types
> at well defined locations. I like the array of resources idea, but that
> begs the question why not put all partition information into an array?
>
> This would also head off complications later on in this series where the
> DPA capacity reservation and allocation flows have "dc" sidecars bolted
> on rather than general semantics like "allocating from partition index N
> means that all partitions indices less than N need to be skipped and
> marked reserved".


I guess this is likely how you want to change the type2 resource 
initialization issue and where I'm afraid these two patchsets are going 
to collide at.

If that is the case, both are going to miss the next kernel cycle since 
it means major changes, but let's discuss it without further delays for 
the sake of implementing the accepted changes as soon as possible, and I 
guess with a close sync between Ira and I.

BTW, in the case of the Type2, there are more things to discuss which I 
do there.

Thank you


>>   	u64 serial;
>>   	enum cxl_devtype type;
>>   	struct cxl_mailbox cxl_mbox;
>>   };
>>   
>> +#define CXL_DC_REGION_STRLEN 8
>> +struct cxl_dc_region_info {
>> +	u64 base;
>> +	u64 decode_len;
>> +	u64 len;
> Duplicating partition information in multiple places, like
> mds->dc_region[X].base and cxlds->dc_res[X].start, feels like an
> RFC-quality decision for expediency that needs to reconciled on the way
> to upstream.
>
>> +	u64 blk_size;
>> +	u32 dsmad_handle;
>> +	u8 flags;
>> +	u8 name[CXL_DC_REGION_STRLEN];
> No, lets not entertain:
>
>      printk("%s\n", mds->dc_region[index].name);
>
> ...when:
>
>      printk("dc%d\n", index);
>
> ...will do.
>
>> +};
>> +
>>   static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>>   {
>>   	return dev_get_drvdata(cxl_mbox->host);
>> @@ -473,7 +488,9 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>>    * @dcd_cmds: List of DCD commands implemented by memory device
>>    * @enabled_cmds: Hardware commands found enabled in CEL.
>>    * @exclusive_cmds: Commands that are kernel-internal only
>> - * @total_bytes: sum of all possible capacities
>> + * @total_bytes: length of all possible capacities
>> + * @static_bytes: length of possible static RAM and PMEM partitions
>> + * @dynamic_bytes: length of possible DC partitions (DC Regions)
>>    * @volatile_only_bytes: hard volatile capacity
>>    * @persistent_only_bytes: hard persistent capacity
> I have regrets that cxl_memdev_state permanently carries runtime storage
> for init time variables, lets not continue down that path with DCD
> enabling.
>
>>    * @partition_align_bytes: alignment size for partition-able capacity
>> @@ -483,6 +500,8 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>>    * @next_persistent_bytes: persistent capacity change pending device reset
>>    * @ram_perf: performance data entry matched to RAM partition
>>    * @pmem_perf: performance data entry matched to PMEM partition
>> + * @nr_dc_region: number of DC regions implemented in the memory device
>> + * @dc_region: array containing info about the DC regions
>>    * @event: event log driver state
>>    * @poison: poison driver state info
>>    * @security: security driver state info
>> @@ -499,6 +518,8 @@ struct cxl_memdev_state {
>>   	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
>>   	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
>>   	u64 total_bytes;
>> +	u64 static_bytes;
>> +	u64 dynamic_bytes;
>>   	u64 volatile_only_bytes;
>>   	u64 persistent_only_bytes;
>>   	u64 partition_align_bytes;
>> @@ -510,6 +531,9 @@ struct cxl_memdev_state {
>>   	struct cxl_dpa_perf ram_perf;
>>   	struct cxl_dpa_perf pmem_perf;
>>   
>> +	u8 nr_dc_region;
>> +	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
> DPA capacity is a generic CXL.mem concern and partition information is
> contained cxl_dev_state. Lets find a way to not need partially redundant
> data structures across in cxl_memdev_state and cxl_dev_state.
>
> DCD introduces the concept of "decode size vs usable capacity" into the
> partition information, but I see no reason to conceptually tie that to
> only DCD.  Fabio's memory hole patches show that there is already a
> memory-hole concept in the CXL arena. DCD is just saying "be prepared for
> the concept of DPA partitions with memory holes at the end".
>
>> +
>>   	struct cxl_event_state event;
>>   	struct cxl_poison_state poison;
>>   	struct cxl_security_state security;
>> @@ -708,6 +732,32 @@ struct cxl_mbox_set_partition_info {
>>   
>>   #define  CXL_SET_PARTITION_IMMEDIATE_FLAG	BIT(0)
>>   
>> +/* See CXL 3.1 Table 8-163 get dynamic capacity config Input Payload */
>> +struct cxl_mbox_get_dc_config_in {
>> +	u8 region_count;
>> +	u8 start_region_index;
>> +} __packed;
>> +
>> +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
>> +struct cxl_mbox_get_dc_config_out {
>> +	u8 avail_region_count;
>> +	u8 regions_returned;
>> +	u8 rsvd[6];
>> +	/* See CXL 3.1 Table 8-165 */
>> +	struct cxl_dc_region_config {
>> +		__le64 region_base;
>> +		__le64 region_decode_length;
>> +		__le64 region_length;
>> +		__le64 region_block_size;
>> +		__le32 region_dsmad_handle;
>> +		u8 flags;
>> +		u8 rsvd[3];
>> +	} __packed region[] __counted_by(regions_returned);
> Yes, the spec unfortunately uses "region" for this partition info
> payload. This would be a good place to say "CXL spec calls this 'region'
> but Linux calls it 'partition' not to be confused with the Linux 'struct
> cxl_region' or all the other usages of 'region' in the specification".
>
> Linux is not obligated to follow the questionable naming decisions of
> specifications.
>
>> +	/* Trailing fields unused */
>> +} __packed;
>> +#define CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG BIT(0)
>> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
>> +
>>   /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>>   struct cxl_mbox_set_timestamp_in {
>>   	__le64 timestamp;
>> @@ -831,6 +881,7 @@ enum {
>>   int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>>   			  struct cxl_mbox_cmd *cmd);
>>   int cxl_dev_state_identify(struct cxl_memdev_state *mds);
>> +int cxl_dev_dynamic_capacity_identify(struct cxl_memdev_state *mds);
>>   int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>>   int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>>   int cxl_mem_create_range_info(struct cxl_memdev_state *mds);
>> @@ -844,6 +895,17 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
>>   			    enum cxl_event_log_type type,
>>   			    enum cxl_event_type event_type,
>>   			    const uuid_t *uuid, union cxl_event *evt);
>> +
>> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
>> +{
>> +	return test_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
>> +}
>> +
>> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
>> +{
>> +	clear_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
>> +}
> This hunk is out of place, and per the last patch, I think it can just be
> a flag that does not need a helper.
>
