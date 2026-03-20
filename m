Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010059.outbound.protection.outlook.com [52.101.46.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A903CAE8A
	for <nvdimm@lists.linux.dev>; Fri, 20 Mar 2026 17:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774026022; cv=fail; b=duLeX/lWwP8iFWOaHlg0w2xgniA2/9Z1Enm7cC9c7MSuF8vrBHQ9H31GNMfzqLqP0kwPPOQNSPS9JBWgZSJiE+iba1pEMddlZVfoOv0kKofa+Al0/OH6XYe2HZeVGXoAWpUxvrMo6aTGyrn1hiCoKUq9vL2lEg0NGufs/zv5uy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774026022; c=relaxed/simple;
	bh=N2DlWoST5Gi8+O9bxnp2ia2uOQrmsrY5eYQ9LRuTnOg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B4/Wc7xC7s18AS5sxZ3iICZMz0t+K2NVZVTLpPhV4FvURFatCNrwdimg8wsPuztDkYeaD/NPUDAXrrs634fry6F5ZYmucY+m4j6M3jZI5Om3JZisK21QuMhMRfHpjHrDFlQJhLA844PCLng1OW4NSM5rymaaLsZM4I4yo/TFIdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NCi8SGA1; arc=fail smtp.client-ip=52.101.46.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NCi8SGA1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/ZOMJ2+RCC6GEx8jecVeSLEfZa8AyatSmetai+36tiBf0z+lyF9A43unIlUtQKaPKR0YR/M4yeHIWTz9ZmXhDdSQz8/MOdJ/9NyrIoYLKulK5FkTjmTqhUuKSmgDIhhv3adM6e0CPNTu3jd+1uaXpYFwo7RCTazKsH8U+LR1aOs/hkgxj+4S4FQ9pYpF126Dh54zpAPhQegx7ffvGalATZOaHBwrH1JyiH9WJ929Ap0+IEIWyEfWck/Lhqi0/nAlOit93ykjtI2Z/L8pWsQsYNC+St26PQDW/fWO/oIzo6u0zeAdGtZ/ohTqX9wVJgVtf3f/8ooQHUngBZhKJMBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QzJ24PzgD37qwaRec9Vm+iiaQB/3HzagW/mmR7MKBx0=;
 b=R/JeNJkT0DMcUvBoC3SCa4tde20hhXZp4ylCFiwmA/+JHc8OQ90OMKrPktZ8X2lYUBRbNlmP/qrY8gyfpJ36WVfTSJXahla1lKpBB50b+QsFyxI/4Zao+mNstDuykZsx+rN6vFxwn2JZtIUawML+TwHDgO4aO0BlEul1IqiOTScn5sZFdOzox1izKvKx455tzzG11pVxJmOPQPUmV6dy12M6h6BzFRf1+r4H3MFxvmNSH6qv6Crr05Ak7KnsBYUPCR3qvKoqNKiHL1URwYcB+9OeKiImNFwA65fS8xXT0Uz08qXcxGMcm7BUUE9KJsEmpOgjiSBnZDf6GenhkIQ4LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzJ24PzgD37qwaRec9Vm+iiaQB/3HzagW/mmR7MKBx0=;
 b=NCi8SGA1aK5XS7Gvx8PUjdorpO7dNUeTRjoUizf5Hf4YVVMyW3dszCpIMrIDfEDWRykuFREqpYneMnWHI76emKalHOtw+79Sb3Cx7+H1HwW5fXpkRApkr0ULgTXBpMrFo2esfRlxWUS1D4S5cPlL++Oyv7OzpVJCB+jlvot9fJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5)
 by DS0PR12MB999079.namprd12.prod.outlook.com (2603:10b6:8:302::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 17:00:18 +0000
Received: from LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6]) by LV8PR12MB9714.namprd12.prod.outlook.com
 ([fe80::8c9f:3a5b:974b:99c6%6]) with mapi id 15.20.9745.012; Fri, 20 Mar 2026
 17:00:18 +0000
Message-ID: <cbc1b824-d029-43f0-85d8-5ffba1620ddd@amd.com>
Date: Fri, 20 Mar 2026 10:00:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] dax/hmem: Reintroduce Soft Reserved ranges back
 into the iomem tree
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
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260319011500.241426-8-Smita.KoralahalliChannabasappa@amd.com>
 <20260319143549.00005394@huawei.com>
Content-Language: en-US
From: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>
In-Reply-To: <20260319143549.00005394@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0142.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::27) To LV8PR12MB9714.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9714:EE_|DS0PR12MB999079:EE_
X-MS-Office365-Filtering-Correlation-Id: efdf687d-e7ef-4b4c-7784-08de86a229f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8ddoH5XLokNTD2HZozwnM1ole53OmSuMSPWui1A92q6eeYCYB6LEaePVRiWZc0fvqUmHrFpU98t4p5AN6wWDMm/6JPUX6LkuFXAFpapl7M7yQ/i9GH0lHbtHMwM9bjfEbE6mTCF8VrZVYlFROVIWRbbRzw9vUaFKiocnxA2MVZGp3LmtkNqJH1a0MZqfBM+PFxpLIbxTK3Qt54wgI/1ipoP0NrmGp6ijL18WH2Zctet7KOBCwMruYAzqXDMIu5xGVoJcshaBcG5VQsttr0vSCUeU74FRrDRQfp8BrcR8g5CtynCNccwtzSe8zqUvmzE1Kd+1G1vrzEqpEBKVW1JDCPELyut0g+cT0hDRJtzXEdM2dZQ0FQsTjx8x0FFiL8c5iErj3kUsvgoSFz+6F7GRYhGCD3T+9ET002N/qO5mjtC5uAzo2b/SnGi7Rp+/yzql2dZO2SzCnwJo6OPsPP5PpYtDb5CMTEyanw9mgM0bl76sYhEcD6k0qusSqM4by3LPanIgodf/fWXJ+13Bft7zqth96giF69B9M5NBOls4/4fkWjq0G022Gnqy1Esho+H1F+H11Qak4fJllMfWRJS0VgZvKmOu+jUXKfQ7IyS9WWmI2vKeWwVqvMHx4ZfadOUREz/EBdApeMNzPbvILoaBxZMaBfsP9YqkX1BQiXFCxPUobDale/I+AZ2ilmmKb618VucD2KrmnYo0lms/EURAZOccLy7d1oqi7RrXBB/yO8mEudqTCgCJOPSwMHw6+lDu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9714.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1IvMzBJWE1kZHZRclI4QXFvVUJ0MlRUTVZnQmxqbkpRdmNJbmxLN0xxOXVj?=
 =?utf-8?B?NlFGM0hVTlBHeUdRY2FTbjNFNUNYSUlLWWEyYmJmeWdpdTdhd1R0WnlhRjdu?=
 =?utf-8?B?MWloZ2lyK0VOVW5NY0xjWVc5UkxraU9lUVBnVThER1habVZCSmVwRWw1VUZH?=
 =?utf-8?B?eDdCenRHcDNFc2ZXNzhteElnVC93bUgrUS82SG1aNWthbHR5eWJDQk0zMWc4?=
 =?utf-8?B?aTVjTGdkd1RKQlZ2dmlzU09iSTk5Ukw1RGhnV1FhbFM1Tld2RUtGYWxuUjdC?=
 =?utf-8?B?RWdSaTFMZytKWkVPVG5ZQXhOZjFseFI4ZG90YW5jdWhId2UrK05YeE02aFp1?=
 =?utf-8?B?S1RwZzVDTVlwOWo4MFNYTHk4OXF4aXZXTUJXRGJjbzJPU2V0QVpmK1hMUlBM?=
 =?utf-8?B?djRJcVZidXJVcWxCS3NoaENRM2labUZDR1R4VDVpVEpURjZrOTZyTFF2RkpL?=
 =?utf-8?B?VENHNEZtUG1OYks2elpCUFJUMFFDYUJTdHUxNmowVzFGZy9VaU9renNXNEpo?=
 =?utf-8?B?N2hjdnpLdk5WQ2lnaDZ6Q2I1T29CTm8zanhOcGc5d3FIbG1meXNiejF5Q3Uv?=
 =?utf-8?B?YXZiUnc2eHZ6eFRrVmQ5SUkvV3NVRzRPNDliSWkyN1ZRcHQvN0RTZGdEY21r?=
 =?utf-8?B?bGZjUGhsbkFkQ3dmcVVUMTJXNDI0dGZzaXB1OG5hZE0veFAyYVVhTmNCQVY5?=
 =?utf-8?B?VzBMQmJ0WWV3eTkyYkFIREc2SHR4TXNmOU5XY3d6cWhVSUJKYjIvWk00WGh1?=
 =?utf-8?B?eGIzQnJQSmpzOU51WjgxNzU1UFFjcDZoM2xHV0xneDhRaEE2KzNJVmV6VUM1?=
 =?utf-8?B?RW9KUXFXRXkxaFhvTXlldkxabHRUbVMyM015cVJHWHpETUJOVlpLaTkxWVNo?=
 =?utf-8?B?Y2NNZFR3bE54ZnJNcFU0MnVMcU1sWGVoR3NhR05OeXNKdUx4QzBMTVVKUEZa?=
 =?utf-8?B?bTUrWHdOSWZGUkZXQnErZjdSV09JZnp6VVRPMm4zY05NbVBJY1FvSmF3WHdx?=
 =?utf-8?B?M0g1WnpPVWJsMXNXbStsMEd0Y2cwLzVibElOc011NFR3YUJkUi9xNnZURklL?=
 =?utf-8?B?MXZtWkFYV3BXbVhWMWh2Rk1QWWhqOE42akFGRjRJSmJaYU9CbEw5eW5NOVlJ?=
 =?utf-8?B?VnZORTdBdFhaYzJzMXZTTXljVXJrUHArWFZUdFlOM1NYVzcyR2dPczExQjRv?=
 =?utf-8?B?WkU0QVZCUlBxSEdiQm9iWklWNjc5dzdKNDNhL1lyNjJnRVJZSitiSkZLZklG?=
 =?utf-8?B?YWpOd0xxMXdRWk84YUJrc1RmUXV0Y0djYUNXSHN2dVRZczV3bmlYMkVNOW1j?=
 =?utf-8?B?Sk1sRVc5L0oxWlI4dXpGbm9aVnUzbzB0NmJ1bm16bXh1QmlDTnlHWTM1blRi?=
 =?utf-8?B?cmVXNkVsME9Zc1JaRmpYZ0FtQU5jcFpSK3FFZEw5ay82dDNxaVg0MGdycnpq?=
 =?utf-8?B?S3pJUW5STWJRdFhUTndsWS9Pd2h3NGxDbXJMcnpDdy8yM2FhZHZieW9YelBp?=
 =?utf-8?B?Qlk2a3NtV0JSSkRxL2Z1WWE2NVBXWVh0cm01eU4zYXhJUEJWWllGM2J3UERt?=
 =?utf-8?B?aW5OeDZDWmlWU1k3WnJjdjg0TDF1dUJDZ1Rra0g4Y0Y2RlloQk5ZUm5TRmh5?=
 =?utf-8?B?MGN4S1FkVndsQ29nQnpmQnpYb0REMUJ3U0FRRWVPeElzdTNKUEdrMTNWSjNm?=
 =?utf-8?B?aCt1QitUaGVxZ1BuWURtRFQ3RFdldjltTnRFWHpNQVIzRzdSZ3p1d2Z3OEt0?=
 =?utf-8?B?L3RrU29sc0tGU0ZsTUVNYjhidmdja1pIUmZDOFNoV3I1MkdSRlM2aW5VNSs3?=
 =?utf-8?B?dm9YdHRrQ2V5UHdhVk8rWGk5cm1nUnFBZE16MnQ3MzJxQk1nSm5jcTJzSkN1?=
 =?utf-8?B?Qm1INkVuSkFkZ2Z2RmNkMTVDWmx5TDRBSWVibXVmUTNub2JQekExTTFRMWJZ?=
 =?utf-8?B?S0V3VHdhUkVDQXZCZmlJa00xZ1JnK2tTUVRsMjhzZW9UMWZpN0I0R01kcTYx?=
 =?utf-8?B?N2VlazdZNkFLcWxMMkF4eGU1cWQyQTMvQ3k3ZDVicVh1Z3VIamlIbTJOZ3lT?=
 =?utf-8?B?SVpndWphMjBoM2tqWmRlazJIQldXL0ZoK3hhTEpCTjNlbkFidWlEc2FwNkZa?=
 =?utf-8?B?NHY3aHQyajh4L2NObldCa1RnSmg5WVNReDFzVWVFMTMybWlTSXZ0YTJNNkZ1?=
 =?utf-8?B?RHlFNGR4ai91UmsvY3Rid2x4Mkl1SlJndXRLcHBDSFgrbzN5VnllenZRVlpx?=
 =?utf-8?B?ejlYQkF2NWxNdGpXOHpOMXphbUF5RW1PemR2bTNwWmxvNUdvR3V1TkNObjYz?=
 =?utf-8?B?dFJTTlFQZjZyaHRXVm5mZ3JkbFV0WFNwbzI0NzB1ZXlXTzNkYnN3Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdf687d-e7ef-4b4c-7784-08de86a229f7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9714.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 17:00:18.1336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tiwe7Z37obC3bmVA1pnwav9ZNLpoYxVh//nohk7Rvzo6EGLd3mQ1mF0NpC+6BnoA4Qv0XWFArB1iyabwK0V/Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999079

On 3/19/2026 7:35 AM, Jonathan Cameron wrote:
> On Thu, 19 Mar 2026 01:15:00 +0000
> Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:
> 
>> Reworked from a patch by Alison Schofield <alison.schofield@intel.com>
>>
>> Reintroduce Soft Reserved range into the iomem_resource tree for HMEM
>> to consume.
>>
>> This restores visibility in /proc/iomem for ranges actively in use, while
>> avoiding the early-boot conflicts that occurred when Soft Reserved was
>> published into iomem before CXL window and region discovery.
>>
>> Link: https://lore.kernel.org/linux-cxl/29312c0765224ae76862d59a17748c8188fb95f1.1692638817.git.alison.schofield@intel.com/
>> Co-developed-by: Alison Schofield <alison.schofield@intel.com>
>> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
>> Co-developed-by: Zhijian Li <lizhijian@fujitsu.com>
>> Signed-off-by: Zhijian Li <lizhijian@fujitsu.com>
>> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> One minor update needed as kmalloc_obj() has shown up in meantime.
> 
> Thanks
> 
> Jonathan
>> ---
>>   drivers/dax/hmem/hmem.c | 32 +++++++++++++++++++++++++++++++-
>>   1 file changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
>> index 8c574123bd3b..15e462589b92 100644
>> --- a/drivers/dax/hmem/hmem.c
>> +++ b/drivers/dax/hmem/hmem.c
>> @@ -72,6 +72,34 @@ void dax_hmem_flush_work(void)
>>   }
>>   EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
>>   
>> +static void remove_soft_reserved(void *r)
>> +{
>> +	remove_resource(r);
>> +	kfree(r);
>> +}
>> +
>> +static int add_soft_reserve_into_iomem(struct device *host,
>> +				       const struct resource *res)
>> +{
>> +	int rc;
>> +
>> +	struct resource *soft __free(kfree) =
>> +		kmalloc(sizeof(*res), GFP_KERNEL);
> 
> Update to
> 
> 	struct resource *soft __free(kfree) = kmalloc_obj(*soft);
> 
> Got added in 7.0 with lots of call sites updated via scripting.
> 
> Not sure why this had sizeof(*res) rather than sizeof(*soft).
> Same type but should have been soft!  If nothing else that would
> probably have broken the scripts looking for where we should
> be using kmalloc_obj().

Okay I will update it. sizeof(*res) was a typo from my end. Sorry.
Will change to kmalloc_obj().

Thanks
Smita
> 
> 
> 	
>> +	if (!soft)
>> +		return -ENOMEM;
>> +
>> +	*soft = DEFINE_RES_NAMED_DESC(res->start, (res->end - res->start + 1),
>> +				      "Soft Reserved", IORESOURCE_MEM,
>> +				      IORES_DESC_SOFT_RESERVED);
>> +
>> +	rc = insert_resource(&iomem_resource, soft);
>> +	if (rc)
>> +		return rc;
>> +
>> +	return devm_add_action_or_reset(host, remove_soft_reserved,
>> +					no_free_ptr(soft));
>> +}
>> +
>>   static int hmem_register_device(struct device *host, int target_nid,
>>   				const struct resource *res)
>>   {
>> @@ -94,7 +122,9 @@ static int hmem_register_device(struct device *host, int target_nid,
>>   	if (rc != REGION_INTERSECTS)
>>   		return 0;
>>   
>> -	/* TODO: Add Soft-Reserved memory back to iomem */
>> +	rc = add_soft_reserve_into_iomem(host, res);
>> +	if (rc)
>> +		return rc;
>>   
>>   	id = memregion_alloc(GFP_KERNEL);
>>   	if (id < 0) {
> 

