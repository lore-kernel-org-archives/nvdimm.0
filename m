Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140BC524B4
	for <nvdimm@lists.linux.dev>; Tue, 10 Sep 2024 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725973220; cv=fail; b=UhgIoxP41H3QchFG8WBt7xA/2NGHXqqsDmk1mZ+ouAxXRiiLy+4y/h8+RAGmEaFNH/36cYD4CQfIMjYSmRW0FkfJhkgfmWWJ6vpe8a008UJHa3zD2XuEqM/UrPCRo98PDXQi8xA+EBabvYoWb1ryxNl1pFtE4GNiDkVna38jDc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725973220; c=relaxed/simple;
	bh=Km3QeX+7AT9Fiz4r69+OsBlsFqjFlRJvowZdqF7t88M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BMtTwyaP7HiRE0cYrZK5QEc42pvSsguv0/XBDPUqh55EwAi2whL3Z5FFXrh891BUmi9899lQlne94+ZqYPiEsdb1kTFpqNWjRgwBtRpwAPo3okOrmyov+chLgMDvKn2oXY7URfLDizLS1gNnFofRC5r7nFahFm7WT5HsTpB+j6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NRH5XGIW; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NRH5XGIW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvpgCtyeZ+69j6Tn/7ULtU9kiTVuyBKrikO7NQLtTTLW++l35bCvOfLw2XZuKlTm/s/sPfS0CGcC9NFBvwuY5vlJFQ02zyOYMR8HGTCUGCiof8uWa1sL8vUgdblm8wGd1L2ReModgxm8/rOKwojuOTEcnGGvq8hUze49rRizta5J3rY9GQBR1NRiwOo3IKrWsCHs8K4TMTDFDB/pZ25g5Nsq7RiDqHQd+U8VxL5cfRin7vKpIDI/00uV3E2r2jI1MRgkhfM7GTWeCrZQsEWM52GBf4UY2xO1hxsRUoVsb+YSMx1QvOZA0g4iJmiALz5vMlTRtpz3XrpmWhcWMCCgOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIktH0jYC2TzfuFvTN7iT6R1oTCWql/vaF+m70DwAns=;
 b=VQTQ3yS7djqp9AemDXcmYomcY7dD0kUIDqFqVmJi6DZb75/ckY6DyxZjpueulfdBMLhQCcG7/QT9GeA4h8gE0zxTKJ+dghTZBS5Y4I7KymHKtP3f9OBI0tWBYar/2ZxcFr/bP/OSfNv60QdOvFzJV1KVJhDRqaVqSlMCa832S8HnD9bRZFvmZTK+vRja4/S4nWaETlRCdLo07wfsqIWZFeh1oCsibKK3eFO8lMk3KYJTNxBX7vAzTT+eftHJg9fMAEUtzUq+wFs7LEyzP3xldXxotiFGKWLLtasuHANTsq8pZinFyk5tPUpiwX8BzhAkXabbJ44j40TMpOkBsyVwJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIktH0jYC2TzfuFvTN7iT6R1oTCWql/vaF+m70DwAns=;
 b=NRH5XGIWu951x/4LeyRNSVUWC3jhb9jWYre8tYUfURn1WpKqIOWWHf/NCFjSPEnw4liCjmsy78TgHcekPv6GxC5bPq9u/XlF4QCuCJkxXWz1mCH4ZI2xHGoTQBXNmH4/DBhmvv638itTEG9q+eLnYsZipbaK+EgBdaOd3QPgvms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Tue, 10 Sep
 2024 13:00:15 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 13:00:14 +0000
Message-ID: <78cbbaca-5413-c006-6609-ee23e2c757f0@amd.com>
Date: Tue, 10 Sep 2024 15:00:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] device-dax: map dax memory as decrypted in CoCo guests
Content-Language: en-US
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, changyuanl@google.com, pgonda@google.com,
 sidtelang@google.com, tytso@mit.edu, pasha.tatashin@soleen.com,
 thomas.lendacky@amd.com
References: <20240814205303.2619373-1-kevinloughlin@google.com>
 <0bae453d-b4a8-3132-9fd0-bca0eece6a74@amd.com>
 <CAGdbjmLVFZJq7OJv2OwM3knmwfb-j8nZP7G_ownFA3kd3fYbVA@mail.gmail.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <CAGdbjmLVFZJq7OJv2OwM3knmwfb-j8nZP7G_ownFA3kd3fYbVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0303.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::16) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: 34414a36-5755-4747-f650-08dcd198832e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVpEak9xNGRXWk9hdjVBWUFRZDlmYnhycGtva05MN0VGRzMvaDVQSXdkejdM?=
 =?utf-8?B?Z2hLa25rUUMyV3ArbEVRK25SblJ1RG5PMHB0NW54eWRrREFIaFk4MjEwY2Fp?=
 =?utf-8?B?RUZEeERhQ0JZbUl6RUNOSTlZVmJlSjN6VG13V054d0k5bDJKdTYwZ0pCbERr?=
 =?utf-8?B?WFFqSUJhRk1kUTZya2pXclhwSmhIR2JHMzNUWGhTeGN4a2hFZG9kcU1pbGlI?=
 =?utf-8?B?KzdmMmtVY3duaGxWbitKVk1kSFMxVDc4eWRLN2VocDl6MVduWk1EV3llS1cz?=
 =?utf-8?B?L3ZhblNCVTBjU0tpTEI4MHZiZkFqVEViWC9DZVdlZFpZRXFuZVZ5SHJqQXZY?=
 =?utf-8?B?QVMrWkxkb3FWUFUrYmZSWDIrUmwxR1RMSzJ6UitjVXdNRGhVd2JUbUJYMnBo?=
 =?utf-8?B?WDRWSndtbGpYNkR6cUlLem9ib0FPTnhZN0NuRWlkTEh6UmltQndMUVZTdnF6?=
 =?utf-8?B?dlNhSzM5SVZFQnZEVjJ6WlNTc1BwYTE4R3BoTTEzUXVlemNSRTRwQmRRZS9L?=
 =?utf-8?B?clBBRWVreU93RWhYemtXYUhDbVBCRWxSZVZta3JmYUs4b2FRcGlBakRNeFVC?=
 =?utf-8?B?cE96Skw5MFRRL1hLWStPTTA5SW42N3hlbktHL2Y2anJkOG9sTkRGenpkU0k5?=
 =?utf-8?B?T0o4RUw5Y3FUTi94cWNCMERUa1RZQlVJSXJyejQ5SG1LdE5nQnZLTm9mUUlE?=
 =?utf-8?B?cFZjRlhVd3R0R2k3dm5hNU1FeHBydnBCNnk2ZWtRUzQ4ZW82Z3d4WmVBekZt?=
 =?utf-8?B?ZlM4ckF5b3ZmNzZlYTlBYVAwdXRaWGg5ZzV0ZDUxZkFZcENlWEZDUC9aLzgw?=
 =?utf-8?B?bU9GWTJLTjJVWkk1YmpzempQVFR4NVZpckQ1aDg2dDVJL2pXaVV1NkVMTDAr?=
 =?utf-8?B?Q3haTUpEUnAwclh5R1BJNmRjNEx3YzYvUlV6R3hZUFIxNjgzc2Fna2M5YmJl?=
 =?utf-8?B?YjhyZjhJcW4wTW9qNDdCa3lXclJvMlJCdzltRGtDRTJGK2FZa2ppRUJNdU9J?=
 =?utf-8?B?cTYrbTRyT2tqWGUxVDJuM1pTdHZyMlBzOEs1VTlONHB6NkxWVS9kc0dGTTBS?=
 =?utf-8?B?cjhXMkwyMjBXaGdUUTRzNk9nM0s3ZjNKSFFTdlhRQXVPMnBISjNTTGdUSUJy?=
 =?utf-8?B?S0dOckZ4eGwyMEZpYThFUTAzNVlJVkpCeGx1Rjl2bDhaMm9OSHRONGwwVnBD?=
 =?utf-8?B?dVl3UlJUOXgxS1JES2pkMXF6THFwblBVeDhvc1oxVEh6OEpPZ3BOQVo3aTNO?=
 =?utf-8?B?dytac1k3MGhZUExnQ0RVWktSUkFJTmM2Um1rSVU0dDhTQVdpY3NUalpMVDk5?=
 =?utf-8?B?ZVkwR0drL1g3ZDJxMW5xQ09obm5jY1cxemZ1MkU4K3g3R0NmbHFwMTNsZVg0?=
 =?utf-8?B?UzNBZzZtKy9uWUZwR1c4MEJXRGtsUGxyUW1xZHVQTEdCdmUwZWREVmc0Q1pR?=
 =?utf-8?B?dS9DUlRxRjNGelp0Y3JIdHNqSGN2K083YTRmaGhGRGo5ak9RaEFhTkJHeW5M?=
 =?utf-8?B?ZTQrOFZsRDBJUHo1U3BYMUJ0SVp2QkUvOUJSQWZTR3RmUTVselBERHFUU3Z0?=
 =?utf-8?B?QTR3S2hYZDJYS3ZGK0lybGdFNFF0L1lXV2ZreHBWMldVb2hmVDZ6Y1Y5NW1w?=
 =?utf-8?B?MHdjbm1adVhHclo3YXhiUDcwN3FDa1A1VjlSQXpscWVXNEhjQk43V1M1QlA5?=
 =?utf-8?B?RGRMdGlHNGJVLzQydng4aU4xcHpkZ3lJeGFYcThQNEtFeHM0eG5TOG10eUdN?=
 =?utf-8?B?ajFURXhHcU1HZVIrRFU1cjBaMllxWkl3cno4Rk1uM0RBZUxDUFVEdWZDbWVq?=
 =?utf-8?B?QTVOT2h0VHZXNzFjN3RYUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUJGZGpJOVdjSVB2WDRVd2NBV2ExUTQ2YllINWdJQ0x1aXd3QkJSblk5aW9M?=
 =?utf-8?B?WVlwZlZyMUNicDdnRkI0dXYyUk9ld0gvRTdsYlk4SForQXNTQ1JqR0dDaWVJ?=
 =?utf-8?B?ZmRvRTFyemtYa1JMMmQvQ0p4OHdwU3djT2l3SXFvRDJidnJjYXJuVkVwLzB5?=
 =?utf-8?B?UXNpYThHTEN3dXVlVk9VNkdNcW1aSTBjZUR1bXF0ZldseUdtamJ3SjJxV0lE?=
 =?utf-8?B?UE9rVkg1aVB6bXFCNlRsay9VeVZCSVRzMG11QmtCZlArMGFPeW1ydi81OWNH?=
 =?utf-8?B?NzFIc3pjMWczN2M0UUtnekhXbVV6ZnBjTURJdEJMYXJzVGpRRlRqRXUwMVQz?=
 =?utf-8?B?RGNyRDE4Y3M5ZTFuVlhYNGRHOEVUdkcxdGVxTDlOVDBHd2REbGlsejl3a3ZY?=
 =?utf-8?B?cHU0d05DZS9sQmk0UUM0bnVNeTB6RzNUc2JrbjF5elgrVVFnSWpKRURxait2?=
 =?utf-8?B?YTF1dlZYYzQ4c2lnejlITmpVdTd2MTVscEZ0ZGgwWHBPV1Jiby9LbVk0NVBp?=
 =?utf-8?B?RlNRbXMxWWdqRFliRzFyc3pMMERrbnFqaDgvMEV6WmVyYldGNFI1ZnhBeitt?=
 =?utf-8?B?TGxLVWd0aG5LWXRtRjlLYjVqSHFVYmFLbGRNM2tpVGMwMmxYUkVvSG4vVkVY?=
 =?utf-8?B?NnUrWHlnM0lpTjFKRmliU2VIb1JhWFN4OXBqTVNmakVnVVh0VCs2TVNFSWx4?=
 =?utf-8?B?SCtpeEo2eUhveENoWEEwV09UQlJNa3IzY3VSSVBHa2tOU0doWG9IWmVsb2U2?=
 =?utf-8?B?TWt1ZDhPRXkrT3JWVXVQM1hDREc1RHc5ZGlWYytSYTZWUytBYXgzWEc4VDg1?=
 =?utf-8?B?UDlJRGYrWXlSWnY5eWJReVBwQWd3V3NOalJOV0VSSWNycnlTRHpEa2VnNS9Z?=
 =?utf-8?B?V3BVeDJTUjZrL2dnbWNLNGZseU9VOEVrMlUyVWV5U0hwTWg0OG5KWkZ2OU5Q?=
 =?utf-8?B?VW5sVHRCMWZTTTlza3JXMUp5OE54RjJTWWZEejdSZXcyWU9QaVk1OGpDd0JU?=
 =?utf-8?B?SWhUNy9nV0dUQTl0dnMzc0haMXM3YTBKYzZBZm5SWUoyV0VmT2NVaWRiM0VO?=
 =?utf-8?B?c1R2MjNWZ254WHVUdEo3QjJsWTRaUHl0VVZIUkMwbnJyTVk0YWlSUUx1Z0Vq?=
 =?utf-8?B?KzE2Q1JFSnNOUDdjZWFlcC9zcDllWmRLTVVmV1NiZVdIcS9nTWZmOHRXMC9k?=
 =?utf-8?B?eSswOHJzUnh4K0tlNmI4YTVQNFJjNEg3MmpUbm5XTkNhWkI1ZDVrY2xLYm42?=
 =?utf-8?B?VmIyOXJUUUxTWDBwTW16OU9FZW1BVlhudDBkbUgyZUVWK3pJSFY4eTV1K2l5?=
 =?utf-8?B?Y3VqKzN4Z3JZaE5kZkFTcDZqUWF5ZlRBTXR2M0pmMmNVNFRiU3dORkJiMU5C?=
 =?utf-8?B?TWliNk1DSlpjOU9MYVNDWk02cnNZN0FmVGI3cDZDMzFiM1o0YlB1L016K1NZ?=
 =?utf-8?B?Q25Qa0dqV1JyaTRaMkIrUXp6ME1STmYySGlHdTdmT2w2WEtzSzFEZ3hkbkJv?=
 =?utf-8?B?SHFIRS9INHRIVWsyeHZ0eDNoZ0lrTFFEQjk3cEhFRk5qL09FV2JOaGNmc3VL?=
 =?utf-8?B?UHVEZmRWR0hHMnRQMG04WC8wa0E1ajVUa3llMmNiRzlTcG10eWk0bzBzd2xC?=
 =?utf-8?B?bU5xbERlclRSK1hSaHZ3RDRXN1FEa0RiZGIzNEhjMzNpMHlqeDRvdExQV01s?=
 =?utf-8?B?QmxzOTJGdzZRWmllVU9nM1RzYVhtcWVsOElIZFRIMk12N09ZaVMyMFd0NXlF?=
 =?utf-8?B?L3E3YVJwN2FOMkxUTk1wZHRBV3ZWNk1xcGgvbG0rRFJHYnhiVUo0YW9MbEJ6?=
 =?utf-8?B?MFlzWUs3bnR0MWxUbmNsTC90aDYyRlpleDc3SWoyUm5rUms0aVpqbWFxRit2?=
 =?utf-8?B?QjlzYkkxamhMcldyekFmQ3J1V2ovWHI0blNGdjJvN2tmdDc4LzIrVlVDZmFu?=
 =?utf-8?B?d0ZZSDZvM0pPV3VoeXFISWdIV3FKTExKS2VFTmdMb0pXemZoenlIL1Vjb0ln?=
 =?utf-8?B?LzN2OTZwajVudGpsUWJiREMyRG1rTnk4REtiL2hvaDBRakRJZU9sRUZKUkx6?=
 =?utf-8?B?bEZTSlVLekIxZlYwK0s5VmhaNkdLMHM4aUJsMUVRUFRvajdQaDBMbTNFeG9G?=
 =?utf-8?Q?NP5wCiP3yNNEwhV5/l95oVspQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34414a36-5755-4747-f650-08dcd198832e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 13:00:14.8003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyOcOIWhPENWUYOPkR9uAPAS0gp2lgh0EyuDxU61+poRzPliUJhx9wE2o1Y2e18JMJtFQHNa3rcoFVaihNfSFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

On 8/26/2024 11:35 PM, Kevin Loughlin wrote:
>> How can I test this? Can I test it with virtio-pmem device?
> 
> Correct. Assuming the CoCo guest accesses some virtio-pmem device in
> devdax mode, mmapping() this virtio-pmem device's memory region
> results in the guest and host reading the same (plaintext) values from
> the region.

I tried to test the daxdev with virtio-pmem but getting the below error 
(just tried without this patch)

root@ubuntu:/home/amd# ndctl list -N
{
   "dev":"namespace0.0",
   "mode":"devdax",
   "map":"dev",
   "size":1054867456,
   "uuid":"c8b15ce6-0c8f-4a1a-ada6-b19a90bdf1bb",
   "numa_node":0
}

root@ubuntu:cat /dev/zero | daxio --output=/dev/namespace0.0
daxio: neither input or output is device dax

Could you please share the instructions (to test with virtio-pmem or 
Qemu). If not, still okay.

Thanks,
Pankaj
Best regards,
Pankaj
