Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010044.outbound.protection.outlook.com [52.101.201.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561C283686
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 19:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766001394; cv=fail; b=AM6a2+bLWedSvWRD85mrQUg/jKx+NAj02MgIg19m62AbqhRFEPXWN8qx92aKcGsFzW9JDot42n+AA3szTm5SxINuGPXCvUhKgM9CHl+gL2x1lj1J968/cCM543svCVhTUlPZ/pjA0va+rPQEa2wNxc/i+NxYcZ8vR/ML6y97Yj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766001394; c=relaxed/simple;
	bh=1an9nzTN5Ef9+MtiuV5a4xBhrXHRsy/P9z6bjl3Ot0Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=rD/mTTqtv4kcfsPinX9nV4GO3vEpRjdGVf6L+687p6SMVS9nLA65A0bJsBgNQWG4l/6JsM2rET4Vm0BsCNX8PoF6NNmKPWUf9/jB+7UjJWHNI9v4sz9+T+Pmk/H6YHk1zlvLosMDJzSdKzfSv8CPjYQPBYxCzYevOs/VK/R5ZWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nrvyVRgb; arc=fail smtp.client-ip=52.101.201.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nrvyVRgb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qj8k0IXNvYaCdiwG8pjOR085v0UgxDMUzaT9N1STiRK5ebPdiI+CHnJKkhp/6hmmtBL0gzR3Y5F13QTIgijeG/GbksRSJvV42nX++SNHEt+Xl6f+GZkwJc0phAer5ZtuxeKXRqLisxBU57CmKLbyoe+JxusNEWWIHGqUUXzdOznxJ2W4vVCgeVo4EDz+ybGzrBmSDZvfHzO55uWXEWmGamP3gx0cfD/2GnQsEzlrQqnT3dUJVzkN04Ym1K1Wb09x+8WMzNpHlVDJqN+0fFgRDYedFWnDvjuzoCqGBl+DbufxCrdqiegThI3c8a8eLEe3UFu05xeb8n2tbc6qQdalKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7UUyOKOncPObTgcFz1/6M370jMBbJLCAc0SY9Gi0vI=;
 b=i76iauBPv55M3cfZBOy4HENCWj1FdfmL5diyCK7zuQAe93t5/L2syHXD8HB1j2OPkO+HQSKVAYDeO1hd1VRqt+PQ3xeN9zT1dzL6YD63bSSjM7kBTZSHL5CL4FMPlDFjwGsmBVBxa9HAge95dYJteMnz+9sHm5BvOR+/oGAePI7aTaDfm6gz9kjbEzfXGJ8WhWTnyLnSy0yAGP5b/t9Y36EFoRjzX60l6yM2rvmp87xdpRXFsdO7iS7d7Unjg/n6+EtTedw8jHkQc0pQhaMJVPtRqNI4d4rN/y+eIpve75aJZejksCagHLBB3G2iX3Kn2MUytQH+TqODzPhjwp3I8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7UUyOKOncPObTgcFz1/6M370jMBbJLCAc0SY9Gi0vI=;
 b=nrvyVRgb2Dwolp9oB/nUl+BtiaRUFPu8UixUiy1hLw8mH1OgoAks+8Fv4JKtmQP1lcXEQYQ3Y/Whsj8CGOcVHyvhRVmqK/zrLcgAjsDqf+0i8mRSC91NKD3xQ/rq0hVyJ38WZy5pKRjpbnidSMJQFSIpttGNtDc3wJheXHzk/cM=
Received: from PH8P220CA0031.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:348::14)
 by SA1PR12MB7271.namprd12.prod.outlook.com (2603:10b6:806:2b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:56:26 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:510:348:cafe::98) by PH8P220CA0031.outlook.office365.com
 (2603:10b6:510:348::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Wed,
 17 Dec 2025 19:56:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 19:56:26 +0000
Received: from [10.236.188.135] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Dec
 2025 13:56:20 -0600
Message-ID: <15ea3666-6257-4765-8b73-3a572442671c@amd.com>
Date: Wed, 17 Dec 2025 13:56:20 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v5 7/7] Documentation: Add docs for inject/clear-error
 commands
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
 <aUI0qhTRx5s63ixW@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aUI0qhTRx5s63ixW@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|SA1PR12MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: 07eba57f-50f4-4c54-272d-08de3da65cdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NklwaDhLc3lYbmhGU1FldmFRZExTbFR5S09GVDBUdDczM3dLZ0VoU3E4dEdi?=
 =?utf-8?B?Yjd5ajdsVk1uR1lZYkpPdG1UYmZ6MDZ5Yms4bVVObi9ZZGNRREZ3VTRzN3BC?=
 =?utf-8?B?TXo4b1FDV0djMWZjQU5rZm5LWDdDRHUxTXJUL3g3Myt1eHdMOWVXVXJscHdC?=
 =?utf-8?B?NVhRT3dhSXdvUWZWYk5zcG1jdEJCcU1vUXRPcXA0eVJhRHFUcjZaZytEMXlL?=
 =?utf-8?B?NCtYdVE2MEo1cG1VanlyNFppV1lLNHNWbGxmVEU0T25Ienp0TzUrSjAwVEo5?=
 =?utf-8?B?Qm44dWluUkNzRi9Td29pb2xpeWFEbDRRN3RyNzdndmpXazV5cTlTelJrRkR6?=
 =?utf-8?B?THJyenlpa2dESlVGTGpKeDUveUFrenpSNEdPNDFuWjlIckNLSVovSlJSMU1L?=
 =?utf-8?B?cTZGcjVabG9HM010SDlNYktFb0cxeC9URCtZR2JmK2tES0VTVFZoN1hGT01R?=
 =?utf-8?B?UEZxUmJsdEkwRWJiaktoVjluM0dQMklBTWNvVWpyaGlrMnVVVm5VUWo1emcy?=
 =?utf-8?B?MG9qYmFNK2RQWmRPTERIenJaZ24zVCtrems0TmRib0U4WGRUaVpWMjNiK2tZ?=
 =?utf-8?B?K0ZDbU51YXhwWlh5UU0veXRRVTc3MlIxUEpOa1R0NTI2NU82ZDZOUHV5UE1E?=
 =?utf-8?B?anRNWUxPWEhiQURHQXk5dXZsbDQraWF0ZXdJMUx1VERDVnhodDdUbFJBK0tB?=
 =?utf-8?B?L1FtVDJiK1QrUHZTTTVPZlliTGtVb2RZTGptbmNCbHNCcXp1bUJscFp0REd6?=
 =?utf-8?B?bDBkcld1UTE5UUwvVFA0Rmg2WXNUSFRnanZEYWtXOEN1djNSTlAybk1pUTB5?=
 =?utf-8?B?QmI3RzhWclBVeE1wVFdJZkN3UC8rL0ROTmk4Q2Nia0hvcURqZWl1U3BlMTR0?=
 =?utf-8?B?RzlVSzFIa1ArZ3RPTFJ3TmoveEY1TGtISzNqck9pVjNyZjVXbVBhbVVwejl6?=
 =?utf-8?B?MzAxTEFvVWtZNmZxL2pqM2NlQzAwYm1Ramt1MVpyczRkZWh0NjIyWnFvdThY?=
 =?utf-8?B?b2MvMFE3amFyRkhTTWE5dGdBMkpYSGZ4TVo1NDB1RkU1RXJWRUVPS0liTFhO?=
 =?utf-8?B?eFprRi96OUZ0TzhuTnhSL3hYRDEyQU9TakUvMzVGSkZWeUY4bUE1Z1RYazhl?=
 =?utf-8?B?dEFjWUhXSXMvc3VqU0RxRWs5UnUzY1Z3dmMycW9aY3hCV3dQajAvbitmUllM?=
 =?utf-8?B?U2hEZTlTWG5HSkpvVTlRTVV1TGQ5bW1YbUhKYWljMit5aHhKUDd3anVoMlJk?=
 =?utf-8?B?Zzd1ekdEZDAzQ2ZOVHFnbnAxSGJHWjgwVWhLR2phaXRHL3V4K1lubFRaV2VT?=
 =?utf-8?B?alpVZU5WR3lRcjdoVVlUY3MvM2QxcnNCRUczNStiaGxmOXRuYkI0bFhEQ2wy?=
 =?utf-8?B?bGJsMW02TzdrMktlNmg4S21DWXNmZUMwSUEvSnZLRCtIYkMrbHJVVTg1THhi?=
 =?utf-8?B?cktmbDRWSmphaEFMTUcrUzFNS0N2bzJQaDlVUjZTMzV6Y3RFY2lsdmg3VEZx?=
 =?utf-8?B?U2xpRmErRlV6WmtVUGZNTXl3Q3hjY3VlbCtqNFBQNFhkbmdZMVdNRmZKZEw4?=
 =?utf-8?B?MWxva0pXUmhNTTNhRk5DUk5ER08waGIzVFBWZ1A3MXlGK2s2TEszdGZsdmox?=
 =?utf-8?B?ajZUL1dmYUJwL0pLKzFpSXRSVHVkNCtIQUtnZEZ3TFlTUDk1LzE4aW5xZlJJ?=
 =?utf-8?B?RXhhWk5qdHlzcU1aZGkvTzFvMHg4UStwc29aYm9XM24zN0lrR0J4eXFTd2lk?=
 =?utf-8?B?R3dLY2gwanlMTTRBUVZjZjc2RDZvMG9JSWlUSklYajJzQy9WVld1R2RkM0Rp?=
 =?utf-8?B?czFWbkRPNUFyTitwbXN2ckFwZExsQ0dLeXhERE5VckVZbDFDOFFjZ2ZlWFll?=
 =?utf-8?B?NVFqcWRHeW42SE5kb3lHVWwyR2VLS3JPTmUrcFFmMURlQmd3V1NzVEgwZHY2?=
 =?utf-8?B?UHhGcHFpUFJldVZSRUthdVl4dFZkd1J5bTMwbzBvZ2ljQS9uNm9mM21CazJE?=
 =?utf-8?B?bVczR2hsUVdwV0FOeUdNQVV6RGZIQkJLc2FMN3FLZEFxN1ZWelRNMHdBbmZX?=
 =?utf-8?B?SVZoU3VoWXljME01YVpEUDRQUmNPOG1ueDhUa2oyS2dKNHZORXd6YjRjUlhV?=
 =?utf-8?Q?S5LU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:56:26.4294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07eba57f-50f4-4c54-272d-08de3da65cdb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7271



On 12/16/2025 10:42 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:30PM -0600, Ben Cheatham wrote:
> 
> snip
> 
>> +# cxl list -m mem0 -L -u
>> +{
>> +  "memdev":"mem0",
>> +  "ram_size":"1024.00 MiB (1073.74 MB)",
>> +  "ram_qos_class":42,
>> +  "serial":"0x0",
>> +  "numa_node:1,
> 
> missing closing quote, should be:
> "numa_node":1,

Sure.

> 
> snip
> 
>> +cxl-inject-error(1)
>> +===================
> 
> snip
> 
>> +Device poison can only by used with CXL memory devices. A device physical address
> 
> s/by/be

Will fix.

> 
> snip

