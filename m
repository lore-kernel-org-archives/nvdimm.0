Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011008.outbound.protection.outlook.com [40.107.208.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE976472789
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781201408; cv=fail; b=i1qeoPwF6TKHDX3UxUzQW2LvIXYsXHpOwiRGml93CG8CqzHvi7XS30fFoWFpHj3yJnAjeXU5vkJ/5T8Fq+2tETulffNuM3vmzR43UGppTrL7805UhDzeCNlwMXhu9GKVh/WRoEPq2GgmBTkCu51tLxa+WrwZ616EtHNmzKCbZE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781201408; c=relaxed/simple;
	bh=vXSw4vN74Pz9K2JX04EN68s19cXgDmsr1ioDIAnIK7U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sbpkW21/9pjLD/OYwGDLM16Ln8j3xgGUR/SMtc2dBQfiw9zQQxzWFfKAHpi2gD2zaorIAcs/TTptwsOxd3FruLzB1ECg9Lx9yZS3AXuqPREfMcYV7IiVGCXv3kwa1ad0aliwXjl2AXqKpV/n9hfehHhHxc3BZVePmKInZPq0fK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=is6iLTwp; arc=fail smtp.client-ip=40.107.208.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="is6iLTwp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fctoiqi1TJPjWKnW4P2dLF0FyUXJFvmbWuXAYC4pBR35JbEKfH4ChyqhkX+qdQIeH373ds+/Dz/4kM9gzSnUCK/aN/DkpoHiz+c+PyMhvPH4gq3zM2PBVoxVAb4hqkTwz6pteM7x2OC8m56cmt7zFI5hSSEd9IG7CPZBgLoDO0J7wlFnUua0snxCraSqIN0dnD73tBcz1FBNrnQV7qI5kvz8xtO0LdSXmxJwPlfFPyiloA6r4uQ/qjr7+ST0+n49YgGO6iOKCaubzxB+IQY4saw+QhwcQyn844Dqj8hY4x5NgNTz+EJlf/xwBibWbDfxHioxWRqwzBdLVWxf+9sVWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzgwYZ7PA1b2QYIF0PBowaSOi0awopq+xcNQM9IpjEg=;
 b=lXzeRHb7FBeYUJJWj9zxXCzgbvgnbkycTjF7riwV7S7JpYU4FMbzl23g/XIlA1WwAmUusqldurIWU9X07+t93iZ3YPw/nW+GIvgnOiNz5v/ghZdgmh+vLhGTT1h4itQ4ct59oqRpr/WsS6Wbtp9fG71Tv5Y98CQWpHdHYLCHOaWJgvEdwPB9Qk8gAc/w2lDkzD/3E5k4kdzgf+/y6qClHpaM8j7Q0q9KxrGSx6SErhG7yMRn+yO9kEP/J3WBdRKIuMPL0lW3QHwJmjus0UUu7bjQKLyFLPmiX9cQ6+wGJBdLBmv03Ft9kNwoCgdtzqVfaTGnyiLg3Ny6vz3mPVFoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzgwYZ7PA1b2QYIF0PBowaSOi0awopq+xcNQM9IpjEg=;
 b=is6iLTwp2hDBJmBjj8JSCpNOrieDb5p/lafbTDwwxhxDGP6UQt/DWphoBN4DX7bQ3Sm5nYvjzF7DaON/iVl5GXEKeqtWse+PahSLj1ViBLiEokkvERgp6Rbk/uO71ryLYR4Jwjr5yEdYy466KRRA/DWIVjwFvFgH2FguVCHX5iA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 18:10:02 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0092.017; Thu, 11 Jun 2026
 18:10:02 +0000
Message-ID: <56fbc3f1-2b26-4d8c-9a1a-42a80f2b6bdf@amd.com>
Date: Thu, 11 Jun 2026 20:09:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 6/9] dax/fsdev: fail probe on invalid pgmap offset
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173225.66002-1-john@jagalactic.com>
 <0100019eb7be3bc2-972d848b-bc38-4b24-9ee1-f0dd5610355f-000000@email.amazonses.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <0100019eb7be3bc2-972d848b-bc38-4b24-9ee1-f0dd5610355f-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0036.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::7) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: 011d1019-2cd7-4e10-732b-08dec7e4a81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	AblhFgLvk6BrW+ARjLAAqPmk6RVYVhiNTeUE/LCl0IH8gI/Vw8sk7T7LfmWsdCBo2VjpOyWZfu1hLGVOaQx58C4UsaLfMQIxFx7LG4b+1GrMhCCFnrNC836U7UKNcSTs6WQsLELCi5iI/+Vn6OTpzfJ2mC3OzooQpvRq/l1vrABaGSveWu9ER+GzIvjJqDauymNGrr1g9BrEtGPmFnv1riOiXTCTn6XZ/Q3XLPiUlwVyLdNNJVvfJx0XNL8m2MB11DdI8KNtIqSMz7qiJ6SMZH5MZ/PokTWUuYYpz2uAlYOV5OMoym2ZRmd1lxCMifXrgZp0EUP36JlRcekysDHPpUWcX4VQubETMckLlfNtO4BRJsxripBZqKuQgj9DWZVBlHQMKA8zV7keAghHDjqfU2GAqL1+wsUtAo/2yonCIKnj5JBcZ7rChiANYK2GlnCdY/HhmLwlH0wRkYO3xhI66O66sz87vRcZjvEi9wZA437sS6KsCBatc+eeSP9IXyOBTux/1cmfp3Of0u2QMHozZ9ENMsflcLAbcxFx/7HfKbiz0MlkcWXm+C8r68UhJdflXZ+MUQhNgckhk80kVg3IEIPPuP+jIrdL5i/k4L8Ll3RsqHvfMlJ6NBMiT4cmmndIIUVshHnS0MAkixd2t6423BrpsyoyiiaoQjhb0Bz/J/r1+5uElUrIO/APkNU/hT1B
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2Fqa2dwbEV2a1RoVUVuTHdPblpQRGVvR0JzbVg0bk9zYytaNUtpTEkrcjE2?=
 =?utf-8?B?N0JNbmw4U3p3S05HK01NM0tPR1lKS3UyQWRUdEczd0pqeUJjbjBLQzhNL2V0?=
 =?utf-8?B?RUxwU2NyUjJZa1p0ZGl4Z1RFUDFPeElGOVlNUUhoOWZZSktnRXcycXRJOHVn?=
 =?utf-8?B?YUpEeVg0REhMQll6Z1VINmVFanRqazZLZ2hURCsvRlZvdWFaUmNXMTR2YXZh?=
 =?utf-8?B?SjNpMHFDemZpb3d2M0NIRDBOQWV2QWZrZDBRTDBnSjdvRWVlVXJDNzVnMENB?=
 =?utf-8?B?T08vekxaM0RoT2ZzWnpOUEtEaStUSG5McHR5STlQN0ZvZzlneXkwV0h2Yy9h?=
 =?utf-8?B?MTFBMnNjUFVxckpvOEVvaGU2OFpQOWRoTXJhVGRtSHBlZnFZcmVTRk9pSmdo?=
 =?utf-8?B?LzVOZUJDYm4rK2t4aVhKV0FUajNNTXkwRy9uZlNDVENRcDRoNHB1enlrTll4?=
 =?utf-8?B?WWprTUNHUEdrdXdmdzZtUVNFNWJ6S0F5ZHUyaldUSmxxdTdtOFQrdGdFUEdX?=
 =?utf-8?B?cWlMakF5UkdPcG14cW5EYTRUNmoyZlhiUFZadGRnWU5jajNGS0R4TjZKTFF5?=
 =?utf-8?B?Vy9XM3FhcmpkVHpIOUtkS0d2clE1UjNtd0VUcENISTloYUhmVXpzd0hBNXYr?=
 =?utf-8?B?bU5sWDhGK1I0QWpta0pRMmQ3Z0hvVWRMd2g2Mm1oSFBISHgvTStzdDYveW93?=
 =?utf-8?B?QjI3Nm84eFYyaEpuVE5nTGYxMHNKbUt2by9GWVRWbFZtczBwWnplRExqZTU3?=
 =?utf-8?B?R2pIL2pIQ2hDbjloNCtldzVzMGpLbXhYeVd6aUQ4cEFzdUVOTVJNT2xON3ZJ?=
 =?utf-8?B?WUs0dUttcjVxczlWSGF6aWl6dzFuZUV4N0ZNTnRiNnlaVFR1Lzl0UjNDVGFh?=
 =?utf-8?B?TmRZbEovQ2hqZXg5QTExZ005cDhBUnlaTGJOdmNONXJmRFliTnEvQUk0TitZ?=
 =?utf-8?B?SlVoQWVNdmZLdEgyQ0JSczk4ZkZBYkREZVFad0xuMjlRSWJiNFF4SG9WdlB3?=
 =?utf-8?B?VWh1eFhtTjFIZnQ4T3o4dENYbGtZd29DTGtCeDAwa0FkSlA3ZVBhdjRac29q?=
 =?utf-8?B?RlNJOGNnN0h6eXo5VmdQTHF3NUFqRmJ2ZVZPeWNuK2MxK2V1ellya01GTmlv?=
 =?utf-8?B?dzFhRVk2eEl6Qm9Wd0VBVVk4UXJhS2xBdFBaaWk2anN2am1hZUlEYTdnWDcy?=
 =?utf-8?B?N2NFOGNaUGdZVkhIb04vL0M3eHM3YnJXc0ZSZ3crTGJ5N3d3c2J5OUdLMzNt?=
 =?utf-8?B?eEZpVEtUZkV3UGllM1lEa2phZTNGeTFvUzlIVThvRlNXU3QvY1VRa2tCNTA4?=
 =?utf-8?B?QUxVaXNKLzA0OWMza2xVb2RtRzF0aitWeEN0eG9XZ1B0d3lWSXFRdzdocGtX?=
 =?utf-8?B?cWRETmVDTzVTdVlBMXlTeS9UVlBmK0ZrNlFGcnNKL290dDBCODJHRXZRSmRM?=
 =?utf-8?B?L3duK3p3bmVHaE9JQi9jTXZBOFo1ODI4VEEwSDlNdkY1NElDZ2JkeWZOUDNL?=
 =?utf-8?B?SjUzd1orS242TlR1UUtqYXhUR2JLN3o0enZySGlGR3Q4cVozR3F2OFQyMVJx?=
 =?utf-8?B?QWxWcm0wSTBpYmRwd2MrNzhPVzh3ZnhMVGkvcmdvbjcrUU1sT3NsNDBseUVF?=
 =?utf-8?B?RWlhN1Q5ZU9sakdOdEkxQXlaeGNZNzMrcHFzUW9idlB0ZnNLa29CZVF2WUlI?=
 =?utf-8?B?OGttd1ZQaWY2QUdMTVlKS3FQblBWNzJSZUNSYXZ4Zk9PNXdheDBSODdKeC9u?=
 =?utf-8?B?ZDNJYk5KZVRPZVcrL2JyK01yU2tObUVGeGFWUEpUWGFOenBLKzRGN1B0SWxD?=
 =?utf-8?B?Mm5zeFd5M1FReTU2akh3WkpPTmlkOHZtMTVjRm41QnNRaTNvZy9jaE1yY1ow?=
 =?utf-8?B?VnZJQ3E3c1ljMytLNHBQRTVaVEFsMkFzazdBUU12NDZZZ0Y4bXI1MW9vSUpO?=
 =?utf-8?B?RHNqcXhLcUhjWHZlSGZEeUlxWjMwd1d4NllhaFdHcENwMlJnVDliajM3Yis4?=
 =?utf-8?B?djRkNVNHRW9rMXg0T1M4bU9oUk5JWDJUajRDK2pqS0JBUzJkaXhPeElSTVla?=
 =?utf-8?B?NU1yTWxWL0Y3UGphQzBsZlVlcDJmN2tKbVVsVjNTeWhMOW9DUUxablBvV3VR?=
 =?utf-8?B?Ym4wT0M2NlAyMDltaDBhRHM4YktDYy9XT2Rta0paQ3hsc21iY3RWbTlsMW54?=
 =?utf-8?B?YkpnL1JIY1Z3ZDNMSHV6MVhTMmZqano0ajQ1d2krV0F1VVg1L2NIK2NEaHIy?=
 =?utf-8?B?YUJCT0l4dno0VWJBcnhaUjZqNGhrQ3hyYWlTUjNVeVpzdEVaMHZVZERjMy85?=
 =?utf-8?B?RHNKeFQ4dlhvMVJ2cnVySWU3MXFYTm9vNVlSNllMZ3JXdzRqK29zdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011d1019-2cd7-4e10-732b-08dec7e4a81d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 18:10:02.2667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fgwo2f1dqFxstDsOKkVrsZPcv5C5HJBiX0rEj5n12Vujsx/hB/seb8V4ttmExL8QOBe77qBiT+UJhxoA+saL1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010


> From: John Groves <John@Groves.net>
>
> Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
> condition means the remapped region starts after the device's data
> region, which is an impossible state. Previously the probe continued
> with data_offset=0, leaving virt_addr silently misaligned. Now probe
> returns -EINVAL with a diagnostic message.
>
> Fixes: 759455848df0b ("dax: Save the kva from memremap")
>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   drivers/dax/fsdev.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 07de6bfbbf673..71d2bee1e2805 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -320,8 +320,12 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>   		u64 phys = dev_dax->ranges[0].range.start;
>   		u64 pgmap_phys = pgmap[0].range.start;
>   
> -		if (!WARN_ON(pgmap_phys > phys))
> -			data_offset = phys - pgmap_phys;
> +		if (pgmap_phys > phys) {
> +			dev_err(dev, "pgmap start %#llx exceeds data start %#llx\n",
> +				pgmap_phys, phys);
> +			return -EINVAL;
> +		}
> +		data_offset = phys - pgmap_phys;
>   
>   		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
>   		       __func__, phys, pgmap_phys, data_offset);
