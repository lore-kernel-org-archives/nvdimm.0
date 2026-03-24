Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012055.outbound.protection.outlook.com [40.107.200.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28A338F929
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 21:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774389073; cv=fail; b=CyJGyW0Dewam9np2qEikHs/7zfS1M9ptaLDD5Fgq5PM8SxzGXIr91mDQTI4gkpSA94cKvSWAIX06OqSw/C84Oyb1nGREAoHiX56g/l1T6Q/J/MDObcmd4rIAFZRHXvv+Ifpk6Ra1iy7Nd/UDUFCzkD6Oj/pwlsEul7vx4xLeuy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774389073; c=relaxed/simple;
	bh=wHCqoDXhd9TlCRN0ij0wNFaM3zGnlsoYbuSXLOqduhM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uY7q86wiqxOe/X0Et3dTslXiy+4nDF9Hz5sdTit4fORpukZXCpHXqPgpLmxo+r5tBdSzd091h1WaHxv52K/kZeNuqN+ykrccdNfzxHtYT8ofItA4S+b6q0OySkD6M+qdFgRPsv7TGOAWqKuqhkOybpFu6dVRBdBcwCJB7uKSTb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K74NzOs/; arc=fail smtp.client-ip=40.107.200.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K74NzOs/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k/knbT4NKyaGxbVVManmiiJ0jh8k8Bl8EHwnmDibFo7MlniD2w9vdTa356Xyc8SOhj3ezsq2Q2aQ9PUgHoqYB15LToK5AOwQy1Zp4uPeduEr5Qc9OejpaKS9sK5qfGzZ+GT4A5JuBr4qvg3aQcVvlTKrXGdSc17AkWga80ZRPs0eNhr5BbvqH8ow1hqtmTfvTrcCS9wHncWYEswsgU4GQwTQyqF6RR9fTOwjO72yNd4QaXnwqOHJp5/u6GOTeCweAvJ7f7ki6P82dTwlFf+f6bMN0jFklXSyhSbiY+lwM0kvrN+cNK1tITIOvIvJ2cew/awV8XayzhpKCFUfLydT5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pg/bCABMVz/xOXKZH9j+En/ebHpD67B18o9quL5me8Y=;
 b=vCgOKYyJSRWONFgQKfPmtxX2kvoWuGLbNVwJ5xFFBuyd/xsu3fUxosc5qqi+Cued9kagqwcT9O7ZFe5pUIynLCfepClr9QFi3Ol2DL+J4Dl7Lu2aYMjAmQ2K2D4xDqp7JpjJeCXSEKPru0AP/g23fyqDIQIOL/0QOaMJ5q2WNfOrSkWMl0ccWm7OEZMeCMiYzhjN45MaRfMb59DU4fjyt8E33mYgnsAUxd0UaGqxfubnaQgWE614sXkJ543D4DT+5FUGv18rCoHWIHaIHMbBxA/SgO2eSpODmJp7bqFukPw/BOjZNWolcvFuMaFn2g5TLXCLg+6QPydse1FZMBplsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pg/bCABMVz/xOXKZH9j+En/ebHpD67B18o9quL5me8Y=;
 b=K74NzOs/8FXXIUrtWb/HCREhMM/7lhbCr7ygN+6ayaQFVv2aOAE8Xl4BKdIRzUsGGClWfK738zv8xF/qp1PpcPHx05VOV95mU1IGlx7LNSKJ9iy6q/c1vrVNNaO4c0Ox4nnTJ3l6NvIQqd+ZUWlifji+uhKyrQWXuffyzl1VbgI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by DS0PR12MB7802.namprd12.prod.outlook.com (2603:10b6:8:145::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 21:51:06 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 21:51:05 +0000
Message-ID: <403241c1-36f7-4fd6-bc99-d7dbf30e58f4@amd.com>
Date: Tue, 24 Mar 2026 14:50:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/9] dax/hmem, cxl: Defer and resolve Soft Reserved
 ownership
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@kernel.org>,
 Li Ming <ming.li@zohomail.com>, Jeff Johnson
 <jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
 <20260323181331.000018f2@huawei.com>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <20260323181331.000018f2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::19) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|DS0PR12MB7802:EE_
X-MS-Office365-Filtering-Correlation-Id: ffb035ca-c9e1-455c-e22d-08de89ef7336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	pByobCqgWuWDUxtWmElTxcvD+Wq960UrBqk5ofdIEXN0NBx41TFOR1G9SlPwHGhoztoUKFO9rEw58sMF4O0b8qKmt/zZND47Udkk4qwNDZxKmUAZQLMorZkv/1/nMwIZU2jZTPvsS2FT7zRbzrvUIrmuDZZagtecJRa659U5EFlL7jeVBiBsaEG6tCcmzozlMnpJ2ZEfM4nftN5msDOSBYM15J6bhH27Az576Fj0cWL/wXY2EU51STd/BVPiGzRhamf6i1WasI+ysZg3y0j5PJZzy1THNwOuSmjY0Ix8KQ4LH4o0f5TcFj/p4/VC0lz6QT5ra6RVtLMjPHrtNgOqg/KG4QJgVCpSwQ+Bvmg0EZLvYI/+7VxfxyylI/lOlfQCm5nXHnLt5gj+cTJuQ9YuTyv5/O8L15Oal+J4DzYdFYmNqWcbpN1cWUSqTNtVOUvh8ffl4PWpjaT2tEWkMjkfg7ZHSkyCEepDtAZ5QWwHSUblV+c4uxeOn73hjaf/FhrRWoNZpphGCFsaDeRILoDQ4ByLYjFZZusAm1A1bf1IYZwjmM0nr92iEG+djXtXPvlLJrNm/a07YkMBlPo4Y47qCSM3whojlCL0AQ9GI+ByI6XNCE3J2CrNv47jy+fvQZ8pRS/BwYiQmViN2RWlvBhezow37ap7QTTclvj9KCc6uow=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXgzSFpOeHpYNHZjNUxuVEI1dHR0WEtlYmF3bitkOGYwVTEvdkFYeHE3WTIy?=
 =?utf-8?B?ZGc5ZHZDZzQ1MkMyUXVTSzNrMTE4NjQrMTNLTlBURm42WkR1K3p2TTJUU2N5?=
 =?utf-8?B?ZU82L090NEluMlZ5bU1NSVVJa0ZSdDYwdXhqR2tQQVhBMTVjbXA2MTVUZjRM?=
 =?utf-8?B?Vlpja3dka0lxSlMzcmNVV1NTRHRSVmREamNub3NoRk1UMGlWYUE5OWVrNUt5?=
 =?utf-8?B?T3Z5ajNwRTZ5NjI4NDBxSXYzR0I0SVJXbWZwNjdFRncyUXdaZzVUb3EvM2l3?=
 =?utf-8?B?bXBVeG41b3NnZStiWWdiSFd3SEZIdlhzMldYZDFJaHBlUXpFRCtBelVhYzJL?=
 =?utf-8?B?MW1EN3JiZTA5QW9iWmpuY3habDdVc0JRcm52cTNmMmkyRTZUWWtFaE5VUWs3?=
 =?utf-8?B?WEVpRmhKY1E4ZHEyTFBabjI5ZFhJZFNibXZtdy85NjBDZkc1VWxubG9HL0JD?=
 =?utf-8?B?TkhNYmtDUVplVnZGR3Ryd2xReVJjQ1c5TXY4STM0MTliY1JtYVIzWUlPRDBB?=
 =?utf-8?B?ZXlBY2FIL2M1dVBtUzVHOFUvMDMwTUhrMm1CQXJud0RKU21OMGRieitnUFFt?=
 =?utf-8?B?ZFdhLzZKeDNkczBmVzQ3MlNZWEp3V2prSWxuRTFRNmJaRHJ2d09pVTVSZEIy?=
 =?utf-8?B?MnBqVllDYTZ2TkVoaGVMSEhhUTl1K0pMM1VKM04xOXg0NGRuVlJVWWVtcTUy?=
 =?utf-8?B?OUMzYVVDaEIwSzdCMDdwNjBRQ0tCdzc2QkluVVhQYTlJM3hUejFXM3FDQklM?=
 =?utf-8?B?VFh3QVQ1VFBVOXY5UjZmSk9UZVhhOTFCKzNlQnFXRUNSREYrajJIZVQxWWpL?=
 =?utf-8?B?TXA2RDVqdzRMNW04VDdITlNQbUxWajBUSk0rWTV5b3E1bENMVHJDcENmNElp?=
 =?utf-8?B?NTdvelI4OHVHREVBWmZmSUVCQXRPallUbklFZ0NDcDZOazgrNGRCMzQ5Z2gz?=
 =?utf-8?B?anVlUVdiQjdsM05oV29hUzlBMmRqdEtGbjFWV1QvRzZUd2RpL0UvczI4NmM4?=
 =?utf-8?B?a3piSTYzSmMyOW5hVVRtMXFnMzkxRzdwdkFnZWNtUUxjbmNpVG5yckM0WDVG?=
 =?utf-8?B?aW9jbVBldm02dXFlTm9ObDBiS1c5UkxsS3dhbm02RGVDRjZCTEptdjNzMG1s?=
 =?utf-8?B?Ty94YUp2NFI2Zk4wVjBNVFB2Q3BkQnJid043TWJtdVZuUC9CczhlZlBTQlFG?=
 =?utf-8?B?dGYya09iRWp6K0FYVkpLbklTY2Q0b1JyUm1ELzFSMnB4Nk1SSnBDaWlMRkFt?=
 =?utf-8?B?Y2tMMXllN1puUnh5Zi80c0tCdlRkaHhpOUgxaGlteGFyRk9YbmxCdVlRSWxt?=
 =?utf-8?B?cVBobWJRYkIraWVNWnc4Sno1V1Z3MUt2ZlJEemxxWlFCanVUZWg5Yytzb0tn?=
 =?utf-8?B?R0VVTDJPdTRHM3A3cWl6NCs4Q2dMNzlJWHk0TE94RjlqMUZibzJNazBRQlk1?=
 =?utf-8?B?WnhQQ2hsckxZQXg0dzhXeGtlOUU1Q0Q0cXZTUWtDSGUxcnlWSUM3NDVDSHB5?=
 =?utf-8?B?RHNuTlJzS0poNWV5cEpZVG90WmUzUERmSG00WDU0aHJ6ZWoyeE9ZK0gyVnBj?=
 =?utf-8?B?dXpTVVB6QURCOHd4clM3dDcrV1V3ZjFSWTJQU2ZTL3Y4U251RWZZQUxZN2Zk?=
 =?utf-8?B?RFlFYlRXSGpPcENoMCtXREloZFgvUktQVnptdGZneUxaUTV0SUkrWldGSWlG?=
 =?utf-8?B?TldLZDVicS85R3I0cmUxSkxrY05CM3VOdE1TTUZUbHhHTG9WYW1PeHJJUnpy?=
 =?utf-8?B?VlA5dkRJVlg1QlBDR3lYTkFGUEF1eDJSWW81YUx2K3NtUmF2dlI0dEwzQVNJ?=
 =?utf-8?B?ZkxwNVBhZ1M1Vm5aNllvL0VHTWVoQVB6TlBzREo1OHl0TTY4VisvTTJvK0tw?=
 =?utf-8?B?eHBRRVNyTkQwc2hPRDZ0YkZQNU1hYkt5dkJBa1BoWndDTGMxZElpWDNicjdk?=
 =?utf-8?B?c0p6N0NXd1RvK3NWbkZzRDJyN3A2b0JyNTZhU240WUdZTDNpQk5HdDUyMkNU?=
 =?utf-8?B?aTBuRlFTV0dWbHdUbGRPMW9JRzVCUk1rcU10Tk5Cb2JYdFRBM0xjZTQ2QUdw?=
 =?utf-8?B?S0ZsdlZVdi9jdkQ2U0pSU3dOTVdKNzJKNldwamZyajVmZFBGNERpT1hIaWt3?=
 =?utf-8?B?NDU4SWRVeWgraGxIcEFrMWI0RFJ3dmxNdVNVYVBFUldpbndzekJWQ2RrMnAx?=
 =?utf-8?B?eHhtS0k2cHdLeS9xQS84b1dONmozS1MramduZDZ3RHBJbDhHeU1uNDRjWWx0?=
 =?utf-8?B?UGl0S0VlMWNraTNCVVdMSVJWTzlXSk9hb1NycHdlRUoyWjN6RFlKbG5GTWVt?=
 =?utf-8?B?dnhTdkpVcWdHQXd1UlRUeU9ITUVaOC9YZ0c1RXYzUHc4Rys2cjhIdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb035ca-c9e1-455c-e22d-08de89ef7336
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 21:51:05.8352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPmfKHO+nQ3UnQQYfzi3sRwAOtJyiCKVMxdzgZCani9sGhiDbALa7cM4ZIjl4T+aJ5aJOy1TQnNJMBNnh1XpUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7802

Hi Jonathan,

On 3/23/2026 11:13 AM, Jonathan Cameron wrote:
> On Sun, 22 Mar 2026 19:53:41 +0000
> Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:
> 
>> The current probe time ownership check for Soft Reserved memory based
>> solely on CXL window intersection is insufficient. dax_hmem probing is not
>> always guaranteed to run after CXL enumeration and region assembly, which
>> can lead to incorrect ownership decisions before the CXL stack has
>> finished publishing windows and assembling committed regions.
>>
>> Introduce deferred ownership handling for Soft Reserved ranges that
>> intersect CXL windows. When such a range is encountered during the
>> initial dax_hmem probe, schedule deferred work to wait for the CXL stack
>> to complete enumeration and region assembly before deciding ownership.
>>
>> Once the deferred work runs, evaluate each Soft Reserved range
>> individually: if a CXL region fully contains the range, skip it and let
>> dax_cxl bind. Otherwise, register it with dax_hmem. This per-range
>> ownership model avoids the need for CXL region teardown and
>> alloc_dax_region() resource exclusion prevents double claiming.
>>
>> Introduce a boolean flag dax_hmem_initial_probe to live inside device.c
>> so it survives module reload. Ensure dax_cxl defers driver registration
>> until dax_hmem has completed ownership resolution. dax_cxl calls
>> dax_hmem_flush_work() before cxl_driver_register(), which both waits for
>> the deferred work to complete and creates a module symbol dependency that
>> forces dax_hmem.ko to load before dax_cxl.
>>
>> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> 
> https://sashiko.dev/#/patchset/20260322195343.206900-1-Smita.KoralahalliChannabasappa%40amd.com
> Might be worth a look.  I think the last comment is potentially correct
> though unlikely a platform_driver_register() actually fails.
> 
> I've not looked too closely at the others. Given this was doing something
> unusual I thought I'd see what it found. Looks like some interesting
> questions if nothing else.

Thanks for pointing this out. I went through the findings:

The init error path one is valid I think, if 
platform_driver_register(&dax_hmem_driver) fails after 
dax_hmem_platform_driver has already probed and queued work, the error 
path doesn't flush the work or release the pdev reference.

I was thinking something like below for v9:

@@ -258,8 +262,13 @@ static __init int dax_hmem_init(void)
		return rc;

	rc = platform_driver_register(&dax_hmem_driver);
-	if (rc)
+	if (rc) {
+		if (dax_hmem_work.pdev) {
+			flush_work(&dax_hmem_work.work);
+			put_device(&dax_hmem_work.pdev->dev);
+		}
		platform_driver_unregister(&dax_hmem_platform_driver);
+	}

	return rc;
  }


Worth adding considering the unlikeliness?

The others I looked at the IS_ENABLED vs IS_REACHABLE question is 
something I'm discussing with Dan in 3/9 (there's a Kconfig dependency 
and CXL_BUS dependency fix needed I guess), the module reload behavior 
is intentional and others are mostly false positives I think..

Thanks,
Smita

> 
>> ---
>>   drivers/dax/bus.h         |  7 ++++
>>   drivers/dax/cxl.c         |  1 +
>>   drivers/dax/hmem/device.c |  3 ++
>>   drivers/dax/hmem/hmem.c   | 74 +++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 85 insertions(+)
>>
>> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
>> index cbbf64443098..ebbfe2d6da14 100644
>> --- a/drivers/dax/bus.h
>> +++ b/drivers/dax/bus.h
>> @@ -49,6 +49,13 @@ void dax_driver_unregister(struct dax_device_driver *dax_drv);
>>   void kill_dev_dax(struct dev_dax *dev_dax);
>>   bool static_dev_dax(struct dev_dax *dev_dax);
>>   
>> +#if IS_ENABLED(CONFIG_DEV_DAX_HMEM)
>> +extern bool dax_hmem_initial_probe;
>> +void dax_hmem_flush_work(void);
>> +#else
>> +static inline void dax_hmem_flush_work(void) { }
>> +#endif
>> +
>>   #define MODULE_ALIAS_DAX_DEVICE(type) \
>>   	MODULE_ALIAS("dax:t" __stringify(type) "*")
>>   #define DAX_DEVICE_MODALIAS_FMT "dax:t%d"
>> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
>> index a2136adfa186..3ab39b77843d 100644
>> --- a/drivers/dax/cxl.c
>> +++ b/drivers/dax/cxl.c
>> @@ -44,6 +44,7 @@ static struct cxl_driver cxl_dax_region_driver = {
>>   
>>   static void cxl_dax_region_driver_register(struct work_struct *work)
>>   {
>> +	dax_hmem_flush_work();
>>   	cxl_driver_register(&cxl_dax_region_driver);
>>   }
>>   
>> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
>> index 56e3cbd181b5..991a4bf7d969 100644
>> --- a/drivers/dax/hmem/device.c
>> +++ b/drivers/dax/hmem/device.c
>> @@ -8,6 +8,9 @@
>>   static bool nohmem;
>>   module_param_named(disable, nohmem, bool, 0444);
>>   
>> +bool dax_hmem_initial_probe;
>> +EXPORT_SYMBOL_GPL(dax_hmem_initial_probe);
>> +
>>   static bool platform_initialized;
>>   static DEFINE_MUTEX(hmem_resource_lock);
>>   static struct resource hmem_active = {
>> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
>> index ca752db03201..9ceda6b5cadf 100644
>> --- a/drivers/dax/hmem/hmem.c
>> +++ b/drivers/dax/hmem/hmem.c
>> @@ -3,6 +3,7 @@
>>   #include <linux/memregion.h>
>>   #include <linux/module.h>
>>   #include <linux/dax.h>
>> +#include <cxl/cxl.h>
>>   #include "../bus.h"
>>   
>>   static bool region_idle;
>> @@ -58,6 +59,23 @@ static void release_hmem(void *pdev)
>>   	platform_device_unregister(pdev);
>>   }
>>   
>> +struct dax_defer_work {
>> +	struct platform_device *pdev;
>> +	struct work_struct work;
>> +};
>> +
>> +static void process_defer_work(struct work_struct *w);
>> +
>> +static struct dax_defer_work dax_hmem_work = {
>> +	.work = __WORK_INITIALIZER(dax_hmem_work.work, process_defer_work),
>> +};
>> +
>> +void dax_hmem_flush_work(void)
>> +{
>> +	flush_work(&dax_hmem_work.work);
>> +}
>> +EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
>> +
>>   static int __hmem_register_device(struct device *host, int target_nid,
>>   				  const struct resource *res)
>>   {
>> @@ -122,6 +140,11 @@ static int hmem_register_device(struct device *host, int target_nid,
>>   	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
>>   	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>>   			      IORES_DESC_CXL) != REGION_DISJOINT) {
>> +		if (!dax_hmem_initial_probe) {
>> +			dev_dbg(host, "await CXL initial probe: %pr\n", res);
>> +			queue_work(system_long_wq, &dax_hmem_work.work);
>> +			return 0;
>> +		}
>>   		dev_dbg(host, "deferring range to CXL: %pr\n", res);
>>   		return 0;
>>   	}
>> @@ -129,8 +152,54 @@ static int hmem_register_device(struct device *host, int target_nid,
>>   	return __hmem_register_device(host, target_nid, res);
>>   }
>>   
>> +static int hmem_register_cxl_device(struct device *host, int target_nid,
>> +				    const struct resource *res)
>> +{
>> +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>> +			      IORES_DESC_CXL) == REGION_DISJOINT)
>> +		return 0;
>> +
>> +	if (cxl_region_contains_resource((struct resource *)res)) {
>> +		dev_dbg(host, "CXL claims resource, dropping: %pr\n", res);
>> +		return 0;
>> +	}
>> +
>> +	dev_dbg(host, "CXL did not claim resource, registering: %pr\n", res);
>> +	return __hmem_register_device(host, target_nid, res);
>> +}
>> +
>> +static void process_defer_work(struct work_struct *w)
>> +{
>> +	struct dax_defer_work *work = container_of(w, typeof(*work), work);
>> +	struct platform_device *pdev;
>> +
>> +	if (!work->pdev)
>> +		return;
>> +
>> +	pdev = work->pdev;
>> +
>> +	/* Relies on cxl_acpi and cxl_pci having had a chance to load */
>> +	wait_for_device_probe();
>> +
>> +	guard(device)(&pdev->dev);
>> +	if (!pdev->dev.driver)
>> +		return;
>> +
>> +	if (!dax_hmem_initial_probe) {
>> +		dax_hmem_initial_probe = true;
>> +		walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
>> +	}
>> +}
>> +
>>   static int dax_hmem_platform_probe(struct platform_device *pdev)
>>   {
>> +	if (work_pending(&dax_hmem_work.work))
>> +		return -EBUSY;
>> +
>> +	if (!dax_hmem_work.pdev)
>> +		dax_hmem_work.pdev =
>> +			to_platform_device(get_device(&pdev->dev));
>> +
>>   	return walk_hmem_resources(&pdev->dev, hmem_register_device);
>>   }
>>   
>> @@ -168,6 +237,11 @@ static __init int dax_hmem_init(void)
>>   
>>   static __exit void dax_hmem_exit(void)
>>   {
>> +	if (dax_hmem_work.pdev) {
>> +		flush_work(&dax_hmem_work.work);
>> +		put_device(&dax_hmem_work.pdev->dev);
>> +	}
>> +
>>   	platform_driver_unregister(&dax_hmem_driver);
>>   	platform_driver_unregister(&dax_hmem_platform_driver);
>>   }
> 

