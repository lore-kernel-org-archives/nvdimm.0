Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.119
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793982370;
	b=kMya+QYftx6pNhakgD5KAteyFmelfG8+P3TE9X9UQ1kGHrqDZ6D8nebuy+56tBYjNMeB
	 2HbOjfUAuwCG6a44A+exNL3RP9R8jUrOSJuBhvTNfCRCMx6HdBkgAI9TLFM1pFEZs/opm
	 Mg1UCCmUPJGhTyDocRbhvaTBIAcAukW5g+khstSzV8kqpDzj+QE6G8PLZMO0baqtM3C2p
	 SC5qdjw2eWaEEkqjrHsh2hWL25AqKLLtEWUa8/0AUtJvXTUpdRdNEv+COSnY9m66dSLGU
	 mdk0LrFyZvHvkkvFXDdw987BoTMFOU/Kc61PTocXt9K5iN0mHXDIOUbI9pEDL3I4CMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982370;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=YG+E9zcYaVo1vKTClzcJJd5o/JitJK2VEzRg8TkV54g=;
	b=YjRUuxPhp1d3OmXZ70dd5ZHcvFUkKld5oJjIRs37+XLPHrlpVQVNTz6mlbZbQWEH5eYy
	 AqqdFT8FurZ787PgNlcLtecMZw6x4xJ1UuVemCqHtnfLQgALcc3DOBH34pUDVpqupfk4M
	 amIhUdByJxBZIBvwre0Lwu1s5z32XN7rk0tSGKLGCsA3IGxmzbZuLkF0GO/WJXZiytTLh
	 /fFZQpkDxPLmhMmFQHYnigvXsh+1+uAP3z9YIW8i6Wt6Hj5iYtmE4iH53CVhiBGc7MJlV
	 Ecw9t60ipRVQGjvQSeH/VwSAojTeZopjjwpDgqoerhIAe6LsTh0wOwYn7gYE+p5W2rQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b="F/nxZ6PO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.119
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020119.outbound.protection.outlook.com [52.101.84.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60FA606A326
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 16:26:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D60FA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=F/nxZ6PO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eGIZhj3Ir3+GIqA3jYrh+WUyUjV/0OwKvffgQjP1cek7XvO/5a6Udgdt9k3/g6pEgv60PoDimQHai3EOaGenthpFTUpm9LNYfQaTK1XvB4qABsWwP4fwXmSFivxpavS29hEuw1vhXLHETuuLH7XQzMCEVOezTqTwKzkMA8ARSu2UKKA1drpN+fNr+/X7H0PYwkTiF3/GBwha5ugYGUavjO54zyTGFV/h94EMSRuWS5fv6ZFO0s8pJoYoEehqQEfR7wNIUPKNJft2wGVPJm17v3cuslB1MToSD464OGB7ZLLuB/C60f1g0ztu61rLHuvWmgesaZEyw4lbJIs4zl9w8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YG+E9zcYaVo1vKTClzcJJd5o/JitJK2VEzRg8TkV54g=;
 b=GLaP5njc8+t+LfhSmY/fIBh2vUWjXIAs2RzSHk/VsHzKrOG3IDic/bkF0qKFP1PiaY+kV9szmvNS5TNaqpIUylR4WxdQ64l/nM+IJ9hoR0su7lrm45FwggUTSKgzmGrnXdKQgunGjQ5YgMyhQVWIeyvUkWmToMJLANSh5g6KSI4v9LPzBgEtvHUZprnB/2+waDD4OFxpI5KZhUf2jgcpSQXhou32lgWO6Z8F9HBlPis8IjAG4wILEGqOTGqVwmWUII2DYaQ3iWl9LOYp8dvNIskhSoNkM3hm9EqhGjeax1/Gnuj1E6jLb8cKivGWAthUoIU1klWQeNeuWQ6/2oqWWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YG+E9zcYaVo1vKTClzcJJd5o/JitJK2VEzRg8TkV54g=;
 b=F/nxZ6POAR91y6NWO7NZfJvIfVTYNACnnNl1lWUIc6PprJZuXjjSdEAG38OrJdqcSsZG6dmzgnnYqBV3pMcLXZAZKipLqUTPfiNwueP/AZCEaFtCqKiE98jwH8hwumGITedbDxwg3ZhpGetB4u46vBEGYqsRi+8loyaC/lzJ0apvUAHc5gze5LTzpq6OF9JUYgtBWdvf4muxCiYV91hcEiG5TjTqfj9IFCIMaCEif40ZNw4sbbKNAT1JDmX3YeZe9R+IhMLYJpzksOpXm5T76igrkyN8F0c5qycd+1XeldPe7mg6s4x+xlhKPp6jGwdU76HeuFeOYvbOLZkCRZoKmw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9)
 by DB9PR08MB11427.eurprd08.prod.outlook.com (2603:10a6:10:60b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 16:26:06 +0000
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8]) by AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8%4]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 16:26:06 +0000
Message-ID: <18d49173-60f8-48b8-af1a-2ac435aecc79@virtuozzo.com>
Date: Fri, 6 Nov 2026 17:26:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: test fork of a device DAX PUD
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
 <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-2-2828fe5a51ed@virtuozzo.com>
 <eb5e8a1c-a654-4d68-92b1-db0128fa8752@kernel.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <eb5e8a1c-a654-4d68-92b1-db0128fa8752@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VIVP296CA0017.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:354::10) To AS2PR08MB9075.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::9)
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
X-MS-TrafficTypeDiagnostic: AS2PR08MB9075:EE_|DB9PR08MB11427:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ba033a0-71e6-47f5-177c-08df3c22a894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|18002099003|22082099003|3023799007|6133799003|10067099003|56012099006|5023799004|4143699003|261026121527099003|261026140227099003|261102123227099003|261028144727099003|261021121427099003|261022105027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	TpWn/Ab45CVwcA6IW9ups3/iSUQDJf90tGZeD7EmS6zDkL9gFP6x1tnc1PGhGugWlgy/CsFDe+Fya0NNXyI7Gqi00VFKAThAMbtRzkLFAV1ybj6zdouXiXurkYGzvfcF9mB46vOGv4gBuEKfjJ9LZBr4cYslDsz/cT7TAcBMjapCXdPuorxg/oT9ZNG1DjoODOCI1swfvs3IIw1ZjV6CxwgbkXiz1pGpGs1pUatEJ7AFEL9C9YOtCX+MyGDRdpZy+rRS44LTSkUCn12hHUf+Ei+vtilIKC15rgyYuxJLb9hYHkg5MoxAwDO/H3pRC6sQ0tUZfXZa4p4G74jkDxub9bzSHE7g9jm5pquUJJaBwQMteFn5Ie9Tf8PEgA07+btnTCRVp0riziYuriAzLkgqjmmDiSkBJJ+BPFtAhJuK6AJVg/3H8tUhnD6EQrc+35YqKRj/SfTAhGVUrcDfz35PeoCAcSU0nl5pkrEi5UTCo8P15Zmb++HiyruJsg9iSnyFPEW34Oech7ykY8lkPfnIj6qvNeD00sbTtpjNH86xPOcZp5/FHVMz5Eik/QwYLe88h9iZQ7FMQ5/GAqOsiFIpcwGarmzeCWgPBokaa4ysYjQln6eHOCL2DZgG20vPmfz4SVZ92UdOqFEkehIUJTRywpRgqBxUZPNXxrBGCKTSBUU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9075.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(18002099003)(22082099003)(3023799007)(6133799003)(10067099003)(56012099006)(5023799004)(4143699003)(261026121527099003)(261026140227099003)(261102123227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1hweXdsNStHbjBON1I0dTU0Q2p5d0s4VnpkRCtaVXM1VUZLdzZXNTZESXFM?=
 =?utf-8?B?cnNyR1puS2NZU1hYNThPNmwrb0M4RVJJRmI1YStFcUZXRFN5bEIrUGVzdElZ?=
 =?utf-8?B?OVprVitUSTFiTWlBdVp2SkQ1OG1UNUNQNUV1SXA0R2VEUUQ4bHNjWmtKak1u?=
 =?utf-8?B?RFBoSFppMGRlcngwN3FHc1M1SC9rQVQya2R1NmYxOTJyV0lUZ1JLUjNwWUo0?=
 =?utf-8?B?amkyT0VBeUpTdDQxYTY1VGV3WG93QWhZdlhnZHE4NVVScTlvTUtnZFk3TUUr?=
 =?utf-8?B?eFhVRUZYOXl5WFhtUlBpZnk1dlJ5NEw3akt4TjFOeE1MMTNJTmRLV21sUW5t?=
 =?utf-8?B?VWxKTlBQR0ZpQUduSmZCU2ZDU1VDcXU3WEkvZFZyRjlCZEsxY2J4ZHJ0N3gx?=
 =?utf-8?B?Q2pJTWJQZzVXRDNSSDFvVmxUTUdJd1p0NEQwZmFVcXcwNUhOU2J3U1VoVDhR?=
 =?utf-8?B?SVd5R0Ziak16QTVxSVVvZEFYaExrRlhtU0J6S1d1dlR5cHZwQng4M05sZHZU?=
 =?utf-8?B?aVJyRVhQa2dOb2k0dmpyUDZHeDJLWTEyNFdmZ29CVVpYUmw5eHJCMHFpUU5X?=
 =?utf-8?B?VEhsLzJIeG1XN2pBM3J4UERteDB6N0dWRDFQZ2dZL2ZLd1hQbHNQZ05oUnpi?=
 =?utf-8?B?T0JMNHpqMXZlM2p5MWMwWldpVkpKTDFtV0U0WS9CVDdjdGUyMG55cGVWTDBu?=
 =?utf-8?B?dlc3cm9iN0I1WlM2YW85R05ydWYzNzVRUmV5UTFYNTJ4a21xb2tqZ1dyajMw?=
 =?utf-8?B?amxzTWdsZTl3RmlJZkQrNnpkRlM5d0Zjc25EQTVFVUxnQllOWCtmK1dRUVJ3?=
 =?utf-8?B?cXA1VStQWldWbXdJVUg5UTdFTFhqUWd2Wkp4dCt1NnB4b0h0TVNTZ0pWeWMr?=
 =?utf-8?B?emk3blh5Q0piVUIyZ3Zxd2ZIK3NYbXk3ZktzUEdDZXc4T2ZTVmRyb0hwU01m?=
 =?utf-8?B?a3FZY29RVzF5aUY1S0dWWVRHeE9LWFNOZVBhMFlEYkcrb2FGdnlnUFdGYksr?=
 =?utf-8?B?dXBRTko4M2dZTml2bjZUc3lFMVBEdXZISVV1RVhMQllHMXpma2ZCM2pLeVEr?=
 =?utf-8?B?SVcrRjhyVC94UG1MZGxqMjVWbTZRTkdXZ2NPNkhmUGpTeFYrUk50K0NtOWNE?=
 =?utf-8?B?OEZ4azBjdmxMT200TFVTNjBkMG53Ri9Bbi9kdExocEIybnVaclgzYVRKWFBJ?=
 =?utf-8?B?c0xhTGxJT2taT1lqMjNOWGxKb2tlc25xMncxOC9CVnpGb1Z4MVRuR1poQ0tT?=
 =?utf-8?B?Um9rR1VZNXk5cVh3WUk1L2pvUG1VSWJSNnNHZ0pEUnBnT285UUVyczFUTW5W?=
 =?utf-8?B?dWhNWFBmQnJUdDJkVHN6dlRJZXl4TG5IbHFYSXRVd2tld043VjNYMHlTS2R6?=
 =?utf-8?B?bU1BRGRTM1QyMUhMa0hYMldWRlZNSFVJbkJhT214TFNydFRVWXVTVWlBRFdv?=
 =?utf-8?B?RndTQjdvVEdPb2NsZzkyZTFjd3VCdTNDazdjSjdhZy9ienlHdlpOc1hGMCtK?=
 =?utf-8?B?Tkxub3ZzZEFmZU1rY01PRkpGRy9NWVVITzJBSisyV0M2SFNRd2x6N0tmMGdn?=
 =?utf-8?B?TERFRTY1U1c3UXRVRHBDMGl3R0ViMkVGNDJqU3drRXdrSjBDTGFMRnE0OFVW?=
 =?utf-8?B?TzFWZEFZb0l4bHIwZWJHYmlwSWJncFQ3aERWWkJxdE1raGdVblB4REhETytW?=
 =?utf-8?B?V2JSRUhkZHZwY1U2czdLVi9CSkZVcTBPSjk2VVo2V0ZmTDErbVB5OUlMcTkr?=
 =?utf-8?B?RFBaQWRXdjRmZlVoZkhrV0VEYk1ZZWJWck5RWHozbnFhd3R4ZWZhRmRyRVox?=
 =?utf-8?B?RHlyV1pjTVJRRXozc2Vld2l0aXNpWlJWdmVHWWI1cnhIZ1pZUXJ2ZGhaYkNB?=
 =?utf-8?B?N2NPZ0t3N2NaZmRaVHU2bDMrZ1NJSnBjM2JMbENvN29TUDlVcXRYcXVkWGQr?=
 =?utf-8?B?d0ZRV3E4UkRIUDhGU29kTE43U2R2V1l1WUx1UWh0azZFV1BtT0ZNbWV0VDJC?=
 =?utf-8?B?eVR3RVRKOXFCTGpZdHdVRndQbFBxWER5SlNVZTNXYlphTzFxS09ZMnhUdW1r?=
 =?utf-8?B?M0JWdWdNSU1EeXVyb1pBNUdvS2Zla09Qem9xbld1UERKRDUyQnVaSXEvRnow?=
 =?utf-8?B?cGZITXRRMkN1RCtiRGZLNWVOQ094SklHbWtQaXIvVDlrYlhrYnZsamVYV2dU?=
 =?utf-8?B?aTI1ZktETEcxeW5kNGpqZDE4RG9Ta1JOa1Z3OURqalExNmF0TnZnRkQrZUxT?=
 =?utf-8?B?cmNhc2VGS1l0Si80YTY0N0VBRFYxNm9lckx1VzloUHE4ZzhnRE13bHpQNitV?=
 =?utf-8?B?RU9EUHdRREpzd1FCY0FiOHg1TmRDRXdvcGd6enhtc2ZnTG5nWHNuUT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba033a0-71e6-47f5-177c-08df3c22a894
X-MS-Exchange-CrossTenant-AuthSource: AS2PR08MB9075.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 16:26:06.6030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSbBHOaZ98fzBsTnRLWLJHRPSDXKuW36kxYayswTzsWWCMrFo31YVMoSY5Mf4ug+HF8hp9HMi/cqi94ptYprmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11427

On 11/5/26 20:30, David Hildenbrand (Arm) wrote:
> On 11/5/26 18:00, Konstantin Khorenko wrote:
>> Fork a process that maps a device DAX instance with a PUD, in a VMA
>> whose page tables fork copies because it has a guard region. The child
>> must account the copied PUD in its RssFile, which a new rss_file() in
>> vm_util reads as rss_anon() reads RssAnon.
>>
>> Without a reference, an rmap and a counter for the copied PUD, the
>> child's RssFile misses the PUD, and its exit leaves the child's file
>> counter negative: "Bad rss-counter state".
>>
>> It runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE: on
>> a kernel without the fix it leaves the device folio's mapcount below
>> zero.
>>
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>> ---
>>  MAINTAINERS                               |   1 +
>>  tools/testing/selftests/mm/Makefile       |   1 +
>>  tools/testing/selftests/mm/fork_dax_pud.c | 114 ++++++++++++++++++++++++++++++
>>  tools/testing/selftests/mm/run_vmtests.sh |   1 +
>>  tools/testing/selftests/mm/vm_util.c      |  21 ++++++
>>  tools/testing/selftests/mm/vm_util.h      |   1 +
>>  6 files changed, 139 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index d63d8b2152773..247e16f3276f4 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17931,6 +17931,7 @@ F:	mm/huge_memory.c
>>  F:	mm/khugepaged.c
>>  F:	mm/mm_slot.h
>>  F:	tools/mm/thpmaps
>> +F:	tools/testing/selftests/mm/fork_dax_pud.c
>>  F:	tools/testing/selftests/mm/khugepaged.c
>>  F:	tools/testing/selftests/mm/split_huge_page_test.c
>>  F:	tools/testing/selftests/mm/transhuge-stress.c
>> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
>> index 0ea72e9979347..130500f5f6e0a 100644
>> --- a/tools/testing/selftests/mm/Makefile
>> +++ b/tools/testing/selftests/mm/Makefile
>> @@ -108,6 +108,7 @@ TEST_GEN_FILES += folio_split_race_test
>>  TEST_GEN_FILES += folio_order_check
>>  TEST_GEN_FILES += khugepaged_sync_check
>>  TEST_GEN_FILES += khugepaged_race
>> +TEST_GEN_FILES += fork_dax_pud
>>  TEST_GEN_FILES += soft-dirty
>>  
>>  ifeq ($(ARCH),x86_64)
>> diff --git a/tools/testing/selftests/mm/fork_dax_pud.c b/tools/testing/selftests/mm/fork_dax_pud.c
>> new file mode 100644
>> index 0000000000000..0d19c30b1dc6f
>> --- /dev/null
>> +++ b/tools/testing/selftests/mm/fork_dax_pud.c
>> @@ -0,0 +1,114 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * fork() of a process that maps a device DAX instance with a PUD, in a VMA
>> + * whose page tables fork copies because it has a guard region. The child
>> + * must account the copied PUD in its RssFile.
>> + *
>> + * Runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE that
>> + * nothing else maps, with 1 GiB alignment and at least 2 GiB. To make one
>> + * on pmem emulated in RAM, with CONFIG_X86_PMEM_LEGACY and
>> + * CONFIG_DEV_DAX_PMEM:
>> + *
>> + *	boot with memmap=3G!4G
>> + *	ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
>> + *	FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud
>> + */
>> +#define _GNU_SOURCE
>> +#include <asm-generic/mman.h> /* Force the import of the tools version. */
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <limits.h>
>> +#include <setjmp.h>
>> +#include <signal.h>
>> +#include <stdbool.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <sys/mman.h>
>> +#include <sys/wait.h>
>> +
>> +#include "kselftest.h"
>> +#include "vm_util.h"
>> +
>> +#define SZ_1G		(1UL << 30)
>> +#define DAX_SYSFS	"/sys/bus/dax/devices"
>> +
>> +static sigjmp_buf sigbus_jmp;
>> +
>> +static void sigbus_handler(int sig)
>> +{
>> +	siglongjmp(sigbus_jmp, 1);
>> +}
>> +
>> +static bool dax_attr(const char *dev, const char *attr, unsigned long *val)
>> +{
>> +	char path[PATH_MAX];
>> +
>> +	snprintf(path, sizeof(path), DAX_SYSFS "/%s/%s", dev, attr);
>> +	return !read_sysfs(path, val);
>> +}
>> +
>> +static bool dax_dev_ok(const char *path)
>> +{
>> +	const char *name = strrchr(path, '/');
>> +	unsigned long align, size;
>> +
>> +	name = name ? name + 1 : path;
>> +	return dax_attr(name, "align", &align) && align == SZ_1G &&
>> +	       dax_attr(name, "size", &size) && size >= 2 * SZ_1G;
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	const char *path = argc > 1 ? argv[1] : getenv("FORK_DAX_PUD_DEVICE");
>> +	char *area, *mem;
>> +	int fd, status;
>> +	pid_t pid;
>> +
>> +	ksft_print_header();
>> +	if (!path)
>> +		ksft_exit_skip("no devdax device given\n");
>> +	if (!dax_dev_ok(path))
>> +		ksft_exit_skip("%s: needs 1 GiB alignment and 2 GiB\n", path);
>> +
>> +	fd = open(path, O_RDONLY);
>> +	if (fd < 0)
>> +		ksft_exit_skip("%s: %s\n", path, strerror(errno));
>> +	area = mmap(NULL, 3 * SZ_1G, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>> +	if (area == MAP_FAILED)
>> +		ksft_exit_fail_perror("mmap");
>> +	mem = (char *)(((unsigned long)area + SZ_1G - 1) & ~(SZ_1G - 1));
>> +	mem = mmap(mem, 2 * SZ_1G, PROT_READ, MAP_SHARED | MAP_FIXED, fd, 0);
>> +	if (mem == MAP_FAILED)
>> +		ksft_exit_skip("mmap %s: %s\n", path, strerror(errno));
>> +
>> +	/* A PUD in the first GiB, a guard page at the end of the second. */
>> +	signal(SIGBUS, sigbus_handler);
>> +	if (sigsetjmp(sigbus_jmp, 1))
>> +		ksft_exit_skip("%s cannot be mapped with a PUD\n", path);
>> +	FORCE_READ(mem[0]);
>> +	signal(SIGBUS, SIG_DFL);
>> +	if (madvise(mem + 2 * SZ_1G - getpagesize(), getpagesize(),
>> +		    MADV_GUARD_INSTALL))
>> +		ksft_exit_skip("MADV_GUARD_INSTALL: %s\n", strerror(errno));
>> +
>> +	ksft_set_plan(1);
>> +	fflush(stdout);
>> +	pid = fork();
>> +	if (pid < 0)
>> +		ksft_exit_fail_perror("fork");
>> +	if (!pid)
>> +		_exit(rss_file() < (SZ_1G >> 10) ? 10 : 0);
>> +	if (waitpid(pid, &status, 0) != pid)
>> +		ksft_exit_fail_perror("waitpid");
>> +
>> +	if (!WIFEXITED(status) || WEXITSTATUS(status))
>> +		ksft_test_result_fail("child does not account the copied PUD\n");
>> +	else
>> +		ksft_test_result_pass("devdax PUD copied by fork\n");
>> +
>> +	munmap(area, 3 * SZ_1G);
>> +	close(fd);
>> +	ksft_finished();
>> +}
> 
> I prefer to not merge this. It requires an actual dax device, so it's not very
> applicable on CI systems, and we don't want selftests to take parameters in one
> form or the other.

Sure, i will drop the test in v3 and just put a link to this test in the
cover letter and that's it.

-- 
Cheers,
Konstantin

