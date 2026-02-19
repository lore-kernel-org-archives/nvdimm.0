Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FF322083
	for <nvdimm@lists.linux.dev>; Thu, 19 Feb 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771522270; cv=fail; b=Mhw0u2jBJIElSLKWy0Zu5U7wCsEDzYk9cS0Eet/mGFniIH96D/KidQYvJ4aBsTMLI4DdvNfrZkVXs7KzMmxi/swRDhThl3Te+eKyAVdw7G8oKD0RzfQYO2y75vMGgusRHH0ZykL8nrnLZwiWDppR/UQl0KLxDXp2Mqz4JbrXE+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771522270; c=relaxed/simple;
	bh=BkCsOBSyJVFAF71dU2v35ocRVJHmggLrAwRdFqU7Kvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GSOe5cNW1YpM39r61TL8Ms62nZd49F/FV/8bt5hOdwLlP5jxnpL8lGv904M/EpBYZIX5eDp8VQcHcpzbWh/w3oDSxvuy+pBNCc/3LsKqlVCHB7oFvRxJZarLEO8r8DCnk7GBYI8cKDbhsFzgo2g730ZRYDkhr6x0uU4idEJ3jKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=alxdeFWx; arc=fail smtp.client-ip=52.101.43.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="alxdeFWx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8u+IljVzA+onNWo7JSvS5iPr1oTs793hUBXRXLCxC9jSlhfOf6NgfSNgoXcfwOIF7haZrZyAhKEonX3QQDvsv+kD5a0UuFF0wFt2H6RIG89VtemRwNJvmlWkLVzVYo+5n19OYE/4fjOjkuWZ/gZSlZjjgWmMbT8wJ3LlFXO9qtEjRy4SvLEud4GKRmeQzNLnZgXuzgDrHhr4jw2MJTE24pMnRBfRu7v4ypcKjigmXXvZi5g3NFss+ii6rO0q1K3UbKSeRMvBPT8+MstSPRW4TmCnwyQZxrOdQuykO1uglegrkp3d4xNCFwRqb9TBewKw8Riml1KDtAvr0CwhgG+LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sALx5UQX17zDDoZIKXezo3InRTtmPKEKB9ttgIjQqwo=;
 b=bj63oYSxm4FaNlfX79lgw/kebaBZ0j+oNA48NdL2X+g0sBIyXbUU1DVzTMCezu1lPmpzDAdDIEKw/un1ipW2fAvkJQEfiKYIw0Jy6feXzUv0mCHvtxeF7/8Mxv2bA2rseDvVaHLnVU3268d+7Krz6Y6aHf45YiosyVIgwWCDPjAii05sU0K5AZe4MlK2/t6XnGJ8AlTnIO9mnXVF/6w4k0VESQG6hpKz8PXd3lli0pR9kpte2F5eDEQD01kXVEvCRZBvNJIZ3+N3tj6xtPBr1ZSPKNniOzmx1HzncEW8vYOcQABtX+RA/WbEp/Y1MUmpvOl7Pb97yEXNdPqLufp6Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sALx5UQX17zDDoZIKXezo3InRTtmPKEKB9ttgIjQqwo=;
 b=alxdeFWxMOnVbqWyKSwUUeuheuLjZfGISOzGIiJ367hvN51xiS7as76O3+AlHbzd2WePDz0LOv4CMSdNMs6JP2D+sGGU0D5cY+VIHL/1qDsHtiBjxwTJFt1JD8W0bRV9gsNCAW6kii/3wIwALZ7il7+PMrIZ92Vd34Q/8KB77Xk=
Received: from BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::14)
 by PH7PR12MB7793.namprd12.prod.outlook.com (2603:10b6:510:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 19 Feb
 2026 17:31:04 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::fb) by BY1P220CA0001.outlook.office365.com
 (2603:10b6:a03:59d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.16 via Frontend Transport; Thu,
 19 Feb 2026 17:31:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 17:31:00 +0000
Received: from [10.31.194.67] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 19 Feb
 2026 11:30:59 -0600
Message-ID: <eb296e95-e121-41e2-bb49-8d91cfb9ecf6@amd.com>
Date: Thu, 19 Feb 2026 11:30:58 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3] test/cxl-poison.sh: replace sysfs usage with
 cxl-cli cmds
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <20260218191108.1471718-1-alison.schofield@intel.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <20260218191108.1471718-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|PH7PR12MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: fc498a05-57be-453b-2951-08de6fdca659
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmVZb0YwNTUvUk0ybXZJOEI1SVQ1Sk5pbUVHeTVZMFBiTWlOMXc5c2dDY083?=
 =?utf-8?B?VVJHRjM2Qlk5TFROVDZWZTZmTUlydDhUQzU5M1NrUDJRNmF1enJ4U3R4cHJS?=
 =?utf-8?B?b3hDamNJVkJtekIxTnZoREw5SnFmbmRPcEZEdnhzTytpbHc3MXdjUVV3dkJ3?=
 =?utf-8?B?d2w5cDE3Vk9KalpWOEMrWkF3UGVwQW5Va1N0M2J6MDBsM1lnTzM0TlczaG82?=
 =?utf-8?B?MmFMNXFJSFdYcmkyK1FQYWM0VmM2b3NJa2duamV5bExmS29Nbmhqai9JYWFZ?=
 =?utf-8?B?ME0vQnBuc1F5QXU0RmtHMXBjU1NnZ2xHNFZMS01UVFdWVUR2N0hMQnprcmJE?=
 =?utf-8?B?RkNOWjA5QityQ0hZUmNQRTM3M1RTOWI3TGdNM1g4V0ZaajIvUmpINGc1NFYz?=
 =?utf-8?B?VEtmSnJIcTVnN0JoNHo4ZFNLUzdRUTUrS2t0WVJZWHlUWm9kNElOUTI4V21z?=
 =?utf-8?B?ZXBYNzNma0tMNVlGSG9SVHRqOC9NaXcvb2drbmdyanZUVjNIMklXdHZETHdE?=
 =?utf-8?B?b0hmYzJMMHVuL2FITDNRZzZ1a1JDdDVRa2Z4cG9WazFmZ1hrL29qVDZlaFNv?=
 =?utf-8?B?SllqRFRKblp2dUFwRHA1d2dxMk9QNXhOd08xR21jN0FTa1kxcXllRVROOXo5?=
 =?utf-8?B?ZTJ1c3dzV1hBRjJjc2hJN1FLZTVzS0ZMcFFlNnJNbFNQc1FkM1hTVkZSbzQ1?=
 =?utf-8?B?djZQNFRzeVlueXBtUGk3c09KdnRDVEY0blMwd0hwUFNONkN1dHNwV09JUWZa?=
 =?utf-8?B?VW1SNEVwcWdxS1NtWGlacVhid0xEOTdvdzJtdk5kS0ZBK1JQcWtXRi9XaGxH?=
 =?utf-8?B?RmVISE4vK25Tb2Q1eWdYdVkwZTVDNEs4Z0l6b3YzRlJDQWlCMWs1UlN4dWVG?=
 =?utf-8?B?dk5FQ09Hd3pwc0RzVzVhMjVNWkpwNFBLbEFqR25TNFEyUVBqSG1YYWU4NFlH?=
 =?utf-8?B?T2pBcFluOFhwbk5qRG84Zk9Na3BzeUhqaW51NnNhL2RHOHNkNmtBRTlrOFYw?=
 =?utf-8?B?Vm9USVJudTJxSnJGZjNSMUYvK0lmRHB1QlpPRElJQWZKcTcwYllMTWhneklZ?=
 =?utf-8?B?aXdWZUo0Q3FjMW9qczc0TDZ1RFl0eWJRZm9SV1YzUXp5cjRiZ1N1VWx4MlFV?=
 =?utf-8?B?Y1N4V1EvUjhCMkp2bEZuWmMreERCbVhSa0UvM294c3pRMVo3S3p0RnFDSGtk?=
 =?utf-8?B?MkNRWms3aXRGcm94dGhFODJwY0oxaG0wRHpCZnZoY2JDbmZwOGdKQ2dNWHZ2?=
 =?utf-8?B?M0VvSDdtMURaVkdBbmVob3JuR0NabFoxNnlaaFFCT2locUF2SFhxRFZSamdv?=
 =?utf-8?B?TGRJUFBwdmo3cVNkZjhEQ0R0UjhuVnhROFVNTDNZeWNjcklrTVZkVHpzcTRa?=
 =?utf-8?B?THpVaHZpZTVnZndNN2YwRDdzTE9UajdZZlpFb3cvMmVRaXI2Q3k3WGZnVm44?=
 =?utf-8?B?MEJvVTZTZGo0NlpkRkhRd2s4ZmtWdGh5RE5uVWVYU2NURGJuQlo1TXFtaExL?=
 =?utf-8?B?WFlBU08vTTNJa2cydjZydGxOazdXQm13b05YYXVOVWJlRURFSmtXUTJZMGwx?=
 =?utf-8?B?Z1I0WkRFWnhUTzdZY1RDWDYyM1hQTGMvaU9VTFFlYzh3azlzS1JPbW83MndO?=
 =?utf-8?B?dzROb285YVY0NzFEWVB0aWNTQ0lHYlNmT0xkYnZJTTlYOUs4WmdXNTNRek1B?=
 =?utf-8?B?UytISmNtejVOcnQyZVlZNzBYTFVJQU5PWmRNajRGdXZ1dm9GVGo2bTNlZm44?=
 =?utf-8?B?bnNRanBsTVdyVmZUWU1ZcjMzeVVNamYrck1aSUt2a1RUbGFwL0FpMVV0d09Q?=
 =?utf-8?B?MHFyQWxNdUh3YWRDMExPM04vT3lkVHpFRFFxRE1sdVlMZ2FXeGkrMWNvUTBw?=
 =?utf-8?B?djVSa1p3NEVhM3pnTkNOL0wzaGppUW9SQ1V0UG5Kd2M1WVpYeDJFNi9xK1Zt?=
 =?utf-8?B?NERXdmtSczlCQW1IK05vZmhrV0lEa1Y5dzQ0OVhDMnBXWjFxY3FZMmpDNm1n?=
 =?utf-8?B?T2JVZitVbEM3alN5L0l5RzlncUViZVRDcTNWdEh6UUdZZ0hNbmg5bHpjU29L?=
 =?utf-8?B?ZWNHSmlFdHZxdTlmSEp2ckRSTlZVQ1RsQVcwMDBkTlZYOE9SMFkvOCtpSGlp?=
 =?utf-8?B?R0ZWNFFvOXRzbVk4MjhrSDc0NVNGZCtSbzFLTXVJbzd6ZW54M2FMWXZNM1lX?=
 =?utf-8?B?TGxnK2JrZURtTkNvaUVvTmZGOGZxeVQ3eTlnaDIrSm5XcFJrQ1NFZjlBTlpq?=
 =?utf-8?B?UmZJd0lKODJyeFF5WFF1UDFGV0t3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zRiUG6FpDQ/A503vCK0rWEiKfICGeTNWYAtRVPO3GJQv2o+hZivwKtLFgc15MgKj8bS9+50uzMyYL0ebZzPPKlN14czdqpMRzwonrqo+JboOj8O9hcUig9Ro83qelSHeWFSU8H3wVD4iMBQJoKfHjy3Q9KuJk3EbCEFd2jtPNhEvtB5bvR23Bt8Tlr3sYsgi0Ioe0fWpqlnK4GCXhMlcvyU3Sdq2bjT2mq8UzG7Fzdc+bPz+kOc6MSQGBsUReTERbVA/tlEbAzkLCIelMJnAl1OlyFmYowTYhrh3Z42DbTZvRD3ra23La0VzMxrhf8cf/G5j2wxO898am+Xe6XBTx8aV13NDwokHJFAG3qg7uM9CmyVLgUJr5OwueN4/qSSc5Bgj/lZWlJBZ1S88ufN4tfwGdb9YxnSyD0M/xhmGdmiFajTw3k8wcLhfKBEYU4N1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 17:31:00.6205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc498a05-57be-453b-2951-08de6fdca659
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7793

On 2/18/2026 1:11 PM, Alison Schofield wrote:
> cxl-cli commands were recently added for poison inject and clear
> operations by memdev. Replace the writes to sysfs with the new
> commands in the cxl-poison unit test.
> 
> All cxl-test memdevs are created as poison_injectable, so just
> confirm that the new poison_injectable field is indeed 'true'.
> 
> Continue to use the sysfs writes for inject and clear poison
> by region offset until that support arrives in cxl-cli.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

LGTM

Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>

> ---
> 
> Change in v3:
> Use new field 'poison_injectable' in memdev selection (BenC)
> Update commit log to include poison_injectable check.
> 
> Change in v2:
> Use final format of new cxl-cli cmds:
> 	inject-media-poison and clear-media-poison
> 
> 
>  test/cxl-poison.sh | 82 +++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 38 deletions(-)
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 58cf132b613b..bbd147c85a77 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -20,7 +20,8 @@ find_memdev()
>  {
>  	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
>  		jq -r ".[] | select(.pmem_size != null) |
> -		select(.ram_size != null) | .memdev")
> +		select(.ram_size != null) |
> +		select(.poison_injectable == true) | .memdev")
>  
>  	if [ ${#capable_mems[@]} == 0 ]; then
>  		echo "no memdevs found for test"
> @@ -41,32 +42,37 @@ find_auto_region()
>  	echo "$region"
>  }
>  
> -# When cxl-cli support for inject and clear arrives, replace
> -# the writes to /sys/kernel/debug with the new cxl commands.
> -
> -_do_poison_sysfs()
> +_do_poison()
>  {
>  	local action="$1" dev="$2" addr="$3"
>  	local expect_fail=${4:-false}
>  
> -	if "$expect_fail"; then
> -		if echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"; then
> -			echo "Expected ${action}_poison to fail for $addr"
> -			err "$LINENO"
> -		fi
> -	else
> -		echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"
> +	# Regions use sysfs, memdevs use cxl-cli commands
> +	if [[ "$dev" =~ ^region ]]; then
> +		local sysfs_path="/sys/kernel/debug/cxl/$dev/${action}_poison"
> +		"$expect_fail" && echo "$addr" > "$sysfs_path" && err "$LINENO"
> +		"$expect_fail" || echo "$addr" > "$sysfs_path"
> +		return
>  	fi
> +
> +	case "$action" in
> +	inject) local cmd=("$CXL" inject-media-poison "$dev" -a "$addr") ;;
> +	clear)	local cmd=("$CXL" clear-media-poison "$dev" -a "$addr") ;;
> +	*)	err "$LINENO" ;;
> +	esac
> +
> +	"$expect_fail" && "${cmd[@]}" && err "$LINENO"
> +	"$expect_fail" || "${cmd[@]}"
>  }
>  
> -inject_poison_sysfs()
> +inject_poison()
>  {
> -	_do_poison_sysfs 'inject' "$@"
> +	_do_poison 'inject' "$@"
>  }
>  
> -clear_poison_sysfs()
> +clear_poison()
>  {
> -	_do_poison_sysfs 'clear' "$@"
> +	_do_poison 'clear' "$@"
>  }
>  
>  check_trace_entry()
> @@ -121,27 +127,27 @@ validate_poison_found()
>  test_poison_by_memdev_by_dpa()
>  {
>  	find_memdev
> -	inject_poison_sysfs "$memdev" "0x40000000"
> -	inject_poison_sysfs "$memdev" "0x40001000"
> -	inject_poison_sysfs "$memdev" "0x600"
> -	inject_poison_sysfs "$memdev" "0x0"
> +	inject_poison "$memdev" "0x40000000"
> +	inject_poison "$memdev" "0x40001000"
> +	inject_poison "$memdev" "0x600"
> +	inject_poison "$memdev" "0x0"
>  	validate_poison_found "-m $memdev" 4
>  
> -	clear_poison_sysfs "$memdev" "0x40000000"
> -	clear_poison_sysfs "$memdev" "0x40001000"
> -	clear_poison_sysfs "$memdev" "0x600"
> -	clear_poison_sysfs "$memdev" "0x0"
> +	clear_poison "$memdev" "0x40000000"
> +	clear_poison "$memdev" "0x40001000"
> +	clear_poison "$memdev" "0x600"
> +	clear_poison "$memdev" "0x0"
>  	validate_poison_found "-m $memdev" 0
>  }
>  
>  test_poison_by_region_by_dpa()
>  {
> -	inject_poison_sysfs "$mem0" "0"
> -	inject_poison_sysfs "$mem1" "0"
> +	inject_poison "$mem0" "0"
> +	inject_poison "$mem1" "0"
>  	validate_poison_found "-r $region" 2
>  
> -	clear_poison_sysfs "$mem0" "0"
> -	clear_poison_sysfs "$mem1" "0"
> +	clear_poison "$mem0" "0"
> +	clear_poison "$mem1" "0"
>  	validate_poison_found "-r $region" 0
>  }
>  
> @@ -168,15 +174,15 @@ test_poison_by_region_offset()
>  	# Inject at the offset and check result using the hpa
>  	# ABI takes an offset, but recall the hpa to check trace event
>  
> -	inject_poison_sysfs "$region" "$cache_size"
> +	inject_poison "$region" "$cache_size"
>  	check_trace_entry "$region" "$hpa1"
> -	inject_poison_sysfs "$region" "$((gran + cache_size))"
> +	inject_poison "$region" "$((gran + cache_size))"
>  	check_trace_entry "$region" "$hpa2"
>  	validate_poison_found "-r $region" 2
>  
> -	clear_poison_sysfs "$region" "$cache_size"
> +	clear_poison "$region" "$cache_size"
>  	check_trace_entry "$region" "$hpa1"
> -	clear_poison_sysfs "$region" "$((gran + cache_size))"
> +	clear_poison "$region" "$((gran + cache_size))"
>  	check_trace_entry "$region" "$hpa2"
>  	validate_poison_found "-r $region" 0
>  }
> @@ -196,21 +202,21 @@ test_poison_by_region_offset_negative()
>  	if [[ $cache_size -gt 0 ]]; then
>  		cache_offset=$((cache_size - 1))
>  		echo "Testing offset within cache: $cache_offset (cache_size: $cache_size)"
> -		inject_poison_sysfs "$region" "$cache_offset" true
> -		clear_poison_sysfs "$region" "$cache_offset" true
> +		inject_poison "$region" "$cache_offset" true
> +		clear_poison "$region" "$cache_offset" true
>  	else
>  		echo "Skipping cache test - cache_size is 0"
>  	fi
>  
>  	# Offset exceeds region size
>  	exceed_offset=$((region_size))
> -	inject_poison_sysfs "$region" "$exceed_offset" true
> -	clear_poison_sysfs "$region" "$exceed_offset" true
> +	inject_poison "$region" "$exceed_offset" true
> +	clear_poison "$region" "$exceed_offset" true
>  
>  	# Offset exceeds region size by a lot
>  	large_offset=$((region_size * 2))
> -	inject_poison_sysfs "$region" "$large_offset" true
> -	clear_poison_sysfs "$region" "$large_offset" true
> +	inject_poison "$region" "$large_offset" true
> +	clear_poison "$region" "$large_offset" true
>  }
>  
>  is_unaligned() {

