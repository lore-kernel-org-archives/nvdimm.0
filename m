Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6231E51EE
	for <nvdimm@lists.linux.dev>; Mon, 16 Jun 2025 20:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750104570; cv=fail; b=p+vPXK1EaXc97Y8snVsmghtjQ5Z8+d19IXQ3u0eD0+fW4oTTpcGTTWh36j2t27Y+2O9qQrQpe+9Azs6uP3sZQEdtNtrOIv1rYVY0sb6K4ykcZw3Lw/L45N1exb5MLK6RbJqwDqgOF2Nhp7RsJR57VkbnoZSKyR+WqGzJ8f1Gpe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750104570; c=relaxed/simple;
	bh=hK/jZRh1cCt+Iy+oAMlBuyisJVnMR6vDGq+t2WShdAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZIwOfZc3Jvzxnpm8gzpMQRrsrRBkatwph1A7NRYd7Swq3ppJqlFBmlDYHEBcq/I104sMVK945QBLQEXMz9PiQSJGa3ozoA6gi1rCuierVBpY3ugvi1nzNeVLgqMsIgk6tb/BR9O+r+tJDEf4bd3Nvzu+RzIekoKZ51mJlV9sIxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m9FRbIUA; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m9FRbIUA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqPCv7xnGEy1pSfTBspu/1XxbCyhkeh3tCA/ML0cYrtjF2oQLk4MBFhY0W7KzubyER4+355W5WBmv+XgIBbkZi43WXIsKSeD2IZ+sQUEVtyQmJ03e27MR8BVHU+dpNcmXVv0bgAtOI96zSf+85KNUZ41h7SoSnPCeaVoaqMzkCU6gW+Py+kFCnPvoDQXjKk3KtvjcZoNjWYasxIsWcl6aVpuIdZECbJmI2fSauE/TwoOm4L7Cy1cm3mMaQIA2cHgErauJZwNNbhXUaHniKvTv26V+hb6AkX7KuatA5Knvhx4wVRM4WlDDJV1yCmVlzbO3IAdq1DEJEDl3t8onoDffw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QppaooB7C33avOM8o9tTuIYdNlhGm68kwejMtYh/emA=;
 b=lgA9bt831jq8flHRAIqmBAHUAexnZDWSteQukutvkQKr9dhfJ/vwm39GMhiN4LruMqan8JXXWCQ4EPbfm2zrI1ncjDhnzcA1s+nt0A1PM6kFAz8wtBFmnoGEn+K8TJTEaNbfrCt0nkX27nDdvZgmc25OSLzcFKky2LFQ4XlkEa9jM8dC5a0YsRUkn0o4WxI6T1ClTLvGcjw7cFiTWiK/2vmue7wghS7uA8MY6m5XhaPorH28Uis344/KTRlPbD+jxQgKlWrgCum+H4cM6Uu+2z4xQq2MYstR/xq6cLZU6VvP7meA7I1eR/6663556KblWgmspmDk+jU+nhBN5+F7GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QppaooB7C33avOM8o9tTuIYdNlhGm68kwejMtYh/emA=;
 b=m9FRbIUAslfdmYQORP74zaOo5HVIWtV1t2DhAIOlBxSXwo4beO6XYxH346YAWJRTWodLkzzyEWbavcDVyb5JKfUVLsP9MKrxw13xsXgwQGKPnHursRhAN9SmENBA2v0q9jo9BsvJilWoJ/OE0kPHfCJjY8f2Jd0C4Yek9e8BvI0=
Received: from MN0PR03CA0022.namprd03.prod.outlook.com (2603:10b6:208:52f::21)
 by SA1PR12MB8600.namprd12.prod.outlook.com (2603:10b6:806:257::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Mon, 16 Jun
 2025 20:09:21 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:52f:cafe::f3) by MN0PR03CA0022.outlook.office365.com
 (2603:10b6:208:52f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Mon,
 16 Jun 2025 20:09:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 16 Jun 2025 20:09:21 +0000
Received: from [10.254.50.197] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Jun
 2025 15:09:20 -0500
Message-ID: <4126d1cd-e91d-4c12-b255-1c4c5a0e86e1@amd.com>
Date: Mon, 16 Jun 2025 15:09:19 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 0/7] Add error injection support
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<junhyeok.im@samsung.com>
References: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
 <aEpJon2W2m1IpgGx@aschofie-mobl2.lan>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aEpJon2W2m1IpgGx@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|SA1PR12MB8600:EE_
X-MS-Office365-Filtering-Correlation-Id: 9566a5df-d469-4b34-4742-08ddad11aef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anp3Zy83bTN3R0pHNU5PUFEyL0lkU00yZ3NPZm43cTJBSEE3VDBTZE56TlpS?=
 =?utf-8?B?V1FIOTEvM1B1NkJpTjZoRTFuemJaRlZYRlVzWSs5VkhDbGEzVVJDODFzSXdI?=
 =?utf-8?B?Mzh1WmtxS2RXaElPZTJFQXp5VzN6VVVZeFhXSmNJMWFJalRyUmNrVHRUM1FX?=
 =?utf-8?B?UGx0cWlzYXNFR1pIYU1CYW5UYkg3VUNvYWtTQm5VTkNML3pxVDJWemwvTGtU?=
 =?utf-8?B?bnJqbFY0MEN6QnVZZ0IzM0VrMDR1SU8vWGtkS29Temk0THdndmRIdWNFNEpt?=
 =?utf-8?B?ZnoxcjN3QlhIYXgvWEh1bk1pQ1hMak5nUGFqMnJsUHRNdjBkeHUzWGNVOEN0?=
 =?utf-8?B?K3NGOCtLa3dFM1N3UzVVVDBXMTRVV1BFc09vQnFCV002L3RDVVFqZ2JiczVE?=
 =?utf-8?B?Szdzd3pPYjdVc21XQnVrSmpGVW1iQ014ZXdDTy9jSFJwUlBaREhVWGZtN3pm?=
 =?utf-8?B?L2s5ZGxxT1pObGxGNERVS0VURCtzcThiVnRhZTZqbkNSa1QyTGNodXFRYVdv?=
 =?utf-8?B?bEh5YnpheWNwM05keFprZWkvbTNaS3grUWpBR3kvQk5rV3RJYmw3TGZKd2J6?=
 =?utf-8?B?STdwcktBbkFOTmkyM28wdEVXNUVTMnJSNGxjYUhEK2dKMWlKNENMeVJlMjFZ?=
 =?utf-8?B?aXRrdWFpSzh4RWdlaFE3akl3UE8xMTFnTWpObVc3RXpZQnp3eG1BN29QVWJa?=
 =?utf-8?B?UFRCMkZWQUdUOS9HWGo2NHRKQVVhb1poN0drTytnMWVZaVJJNEUzMUtvVS9B?=
 =?utf-8?B?VGhzL1FJbTFMdG1mcDZRNk1yaHEzWmw1L1k3NkZkMm4yV1R5UnVtNm1pMDV1?=
 =?utf-8?B?ZVpwNmM0MEdaY1N6Y3FBTXJERkdRZ0Jvejc2TWo0SjZuRy9mM05RQWQ0ckY5?=
 =?utf-8?B?NTdtcmdkTnZhdlpPRTVvQ1ZSWUdpV0p0QnJLdGtjMUl6SVczbldueUwweEs4?=
 =?utf-8?B?VTF2eWVLS09RRzZkRE9zUEpkNWRQRk1tMk5ZWTNzNC9hQjRIUEQ5SG04cFZs?=
 =?utf-8?B?WWhYcTJpbEtaM0VMdDQyaVdKQ3UvK1NlM1ZFVVZ4VnRlQ1ZpRW9Ob2J1R3F6?=
 =?utf-8?B?VWNMUFVwRm5mZ2lhcmw1NTZ5emxyRTZwVkMrQ1Fzd3N3Z1d4ZVdkMm1lSzMx?=
 =?utf-8?B?Mm56NTVEem1CTnRGWm9PRVZXSVlVazFzbzdJb2pUZDB1N2xPaFMyTEZ2VzJ2?=
 =?utf-8?B?WmFmdi9sNjhiMXJRN2hwL0hnSmZ2UHBKWloyaVVmOGg3M3JFYmF4Q0lqSWZG?=
 =?utf-8?B?SngxTE1ZaEI3eVJPZ3pqUmJqMWJ0b1orbGRsTTZGYnlXZE5UM3drR1hsT21m?=
 =?utf-8?B?Y3dXdVM5ZW15bmJTTzZWMWY5Y1RRVE4zTnR3VmJQV2tXdkhGbG5uZTFzdHZn?=
 =?utf-8?B?ODJIT2RLNTVQQ29sY2xCMzdoWDBMcU93UWVvQnBQUGdhRkRINU14bC9JYXVD?=
 =?utf-8?B?cFRSSzd3VTZxNVZxdzNrNWgrcVZTZy96TiswdVFtZjNKVnh2UU40Yjd2Q2Fx?=
 =?utf-8?B?RHhnbkovMzlDeDljeG9SU01qQ2lrUGtTRzVkNVdCWUQzVkhtUXRZaTFtNExD?=
 =?utf-8?B?THZ0NWR5cEdsWUU3MmwrVnZqNWNqR1ArYkxSeEY0MmphNCs3bEN3ZnF6M3FO?=
 =?utf-8?B?VXhvWEJIMitQWWdlWmdrMjFyVEJUZG1rVzBNUUZDUWlPdkZNYjNhYkZJRm1S?=
 =?utf-8?B?SitqOWIvMGpBM0lKSTlpQUpQRGd4TkQrL3laVi9LVGZXczJvREZ5MFBURlVa?=
 =?utf-8?B?RHhnbDlVN0FnYVFDa1A0ekVrRVpBM2NKaDZZOWpTQmhwaFJ6WitLNmQ3eGJ2?=
 =?utf-8?B?SFk0ZnNPSFdEbE1PaHhzaUNLTHJWbWJBT2VXWkVlSHlwT3ZnQy95aUtUclds?=
 =?utf-8?B?RVRMT0xVUy9MRWR3ck5RdTUxYk13OE0vNzRQK0pHV2FpVzhla2ZMQ3RhWU1x?=
 =?utf-8?B?Wi9DRU9Xd0x3NktpZC9zNFp6OXRiY1FjUjljZCtlbVdMU3JGaDlwbEI0UGcr?=
 =?utf-8?B?KzJEallFM1hReUtnYUZRc3lVZGZyZEJ6YnovUzNRdlVSQkZjRXFxOHJSbGo4?=
 =?utf-8?Q?DHBvxW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 20:09:21.7286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9566a5df-d469-4b34-4742-08ddad11aef4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8600

[snip]

> I applied this to v82 (needs a sync up in libcxl.sym) and ran cxl-poison unit
> test using your new cxl-cli cmds instead of writing to debugfs directly.[1]
> Works for me. Just thought I'd share that as proof of life until I review it
> completely.

Thanks for testing!

> 
> Adding more test cases to cxl-poison.sh makes sense for the device poison.
> Wondering about the protocol errors. How do we test those?

So protocol errors are provided by the platform through EINJ (section 18.6 of ACPI v6.5 spec).
The best way to test would be with real hardware (what I've been doing), but that obviously doesn't
work for everyone. I'm not aware of a way to mock/emulate an actual injection (QEMU doesn't support EINJ),
so I'm not sure software-only testing is viable.

I do have any idea for testing the interface though. It would probably look like writing to mock
error_types/einj_inject attributes (that replace the ones in debugfs) and having a phony error
come up in the dmesg. Something like:

# echo 0x8000 > <debugfs>/<cxl dport>/einj_inject
# dmesg
...
[CXL Error print]

Of course I'm not sure how useful that is since it's basically a roundabout way of testing the debugfs
files exist :/.

> 
> [1] diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 6ed890bc666c..41ab670b1094 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -68,7 +68,8 @@ inject_poison_sysfs()
>         memdev="$1"
>         addr="$2"
>  
> -       echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
> +#      echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
> +       $CXL inject-error "$memdev" -t poison -a "$addr"
>  }
>  
>  clear_poison_sysfs()
> @@ -76,7 +77,8 @@ clear_poison_sysfs()
>         memdev="$1"
>         addr="$2"
>  
> -       echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
> +#      echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
> +       $CXL clear-error "$memdev" -a "$addr"
>  }
> 
> 
> While applying this: Documentation: Add docs for inject/clear-error commands
> Got these whitespace complaints:
> 234: new blank line at EOF
> 158: space before tab in indent.
>         "offset":"0x1000",
> 159: space before tab in indent.
>         "length":64,
> 160: space before tab in indent.
>         "source":"Injected"
> 

I'll fix these for v3.

Thanks,
Ben
