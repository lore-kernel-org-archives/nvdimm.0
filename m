Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010027.outbound.protection.outlook.com [52.101.201.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6964C309F0B
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 23:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766014081; cv=fail; b=pEvUC3MgogdAB5FwSgCDWCoE/g9/SZldasmpNGwXSOLaM2zhzbSPFpIJmvZzajgjwizlkAeXxUIiRFrpSwGqC3yUqmrDNcSqGJ10qlj64dIjikZ/EZ5hooL2bLPi1uAkc9csr4wbCHMqqoYDvVeSu4uSli2wXZ9dzUvVKEmXwNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766014081; c=relaxed/simple;
	bh=ms/JKgTY11T3LkzE9a1EtBcJVKGFTxlQktQEWZ2hpUQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=EMBPyz8anbyBWWsgGgFft1rGu9O+Oh/Ta07bE8mIifJnTCd4kp6zZXaI7Koj7rQ36+fCdPNIKKQcKqkLP6J7IKNykx+9iRJt3/dycMCZi06rosGrBvL/b3xws6OALb7K/VLvOalnxRWX7OKNSt6UMpA+rtJGSGrcJtoS9jj68D4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xyIC2vjt; arc=fail smtp.client-ip=52.101.201.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xyIC2vjt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjuULv2YzAV/hV+ZgcPmj5LP3ifs2GTIH6qGYxyyfi+abJJ5OwfJTpP2edZUvIG4VT01tljbOUe1IjHr4p89qbBeYYXysSMWRU8Dmc8ebADChm2XnwhW89RVXkazWzTcvSTklICUFAJARMG8ss/UncM+XZuodctypk3ilYS5XLFJUuZltnf5PkVkeN8dWmI1IsVhCOzM4KbdcNW+oDvEEN05NO4q0Tjv1sEvDLD4plskYGC15Ox9KXHQehhrAeN1J4fB3GtXqXs8Cwdd9jfS9OROVDDSJ8+kOozZdQbDyBhb9kLlXEcF1b6ip7Cj8KfEMhyGK6uOLnBQvkWApR8cug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm52+MJwhILitSsgivAmpDz6IKBMegawLLlxwnRnHVA=;
 b=TOkVmKjBAOtfWL/MjKz3UbZ4NKZzdBPBvxlllS0tPJjZyN3fIVG6TMMRxtor0gGi/YgP0oCzJtfm0FX4fLvq3EZkVMObXZHjKku4eTO8w7HgqksYoSPJFcPZUgCDAzVo4JbzLozKlIuLIj/8NnHhG87kMJKsxWb90pPe+T+TlQTOWebI5sX28sVOZ9lwyz3hwus/jIAa7g8ZuAZPEbiJY/sD4V+lHX0V7peonbtOvx9RJm4M5rw9U75V12UXlQ2WGErxXSmwsEP8xFgepuxzdtRPCWhU1i07QSaCh0JC+gRx5649a8vlSC7m33iccKrcw9fUI25QpRgygFgr1eiGgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm52+MJwhILitSsgivAmpDz6IKBMegawLLlxwnRnHVA=;
 b=xyIC2vjtuKi9f2swXEuNgniBlZWqvZUdLpBZe/79M5GzcOWahajAXUMqQS4i7/rbbU47isp6Yo/kuUHgmUUltKQn8TdrQWi50n6svNt8nnSG+BUVP18ZTBe6WkobwQQn52Y+cuY6aJEB1OKKxCifvQNmWtYQDAek5Sr5eQTSFyc=
Received: from SA9P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::30)
 by CH1PPF12253E83C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::606) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:56:38 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:25:cafe::da) by SA9P221CA0025.outlook.office365.com
 (2603:10b6:806:25::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Wed,
 17 Dec 2025 19:56:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 19:56:36 +0000
Received: from [10.236.188.135] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Dec
 2025 13:56:36 -0600
Message-ID: <bea48658-5960-4159-bf74-f4ab806189d6@amd.com>
Date: Wed, 17 Dec 2025 13:56:35 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH v5 0/7] Add error injection support
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <aUI13O1UFv4L__yw@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aUI13O1UFv4L__yw@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|CH1PPF12253E83C:EE_
X-MS-Office365-Filtering-Correlation-Id: a7bb032d-c3e1-4782-ade1-08de3da662e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?QWpLSW5jZlZhaGV4M0Y3WkhhdEhwK1krem9vQWhxTXlVeFU1TEJRbTk4enBt?=
 =?utf-8?B?Nnd4TTROUDBLQXIzNWdEZ2FmSC93NmE2K0x2RnlqclR5OFVrSTZMVWZUWUhR?=
 =?utf-8?B?TlVGTWphNG9JNjJFRzlPK3Q4TFNNdnVlSUl0QWx6WEVKUWhGQkR5bjBzRTRI?=
 =?utf-8?B?cW14cjhwWnU3RG92RGMxaEcxRXN3U2xKTXJ6MmlHV3BYM1FBVkNkREpiYWRH?=
 =?utf-8?B?N0VHYU9NdFIzaUh2cndSUHk3WEJ3MnA2amRadEx6SURNNlIzc0piaEpET3h5?=
 =?utf-8?B?aHRoUUc5VkQyS1NUMlhEVnd2b0o0UThidm5tOHJjQjUreVI1OHhDbGRFdWVi?=
 =?utf-8?B?cE1aZi85OWM0MUZROXFHT2VuMEtBbGtGWitkZ3ZlR1F4SG5tOXAvM01VSzhK?=
 =?utf-8?B?c1BFZ0tMRjVVRnZjUjF6NzRlZ05GZnl4SEJkUmpTczZrc0NaejVSQ0U0RDA4?=
 =?utf-8?B?c3BMWEFEUmlqWjExUENlQjFYTFM2ZHg0V2xkSUZXSHQrOU9CV0t5UjYzSFdt?=
 =?utf-8?B?aWtwcEZvemVqNVhJcFJZV3BwdnV6SGtYVWIvaVJpQzR5aldSczBxdTRqSERV?=
 =?utf-8?B?ZzVNaVlUZlhJNXl3dElFc1lEQTNCQW1HSWRjSDRoaVJ5Qit1Yk1oUFpOejM2?=
 =?utf-8?B?REo5dXcya2dudFpuR21QV3ZEMllYQjZmbDJoSy9DdkVHWlBnakxnQUdYYytt?=
 =?utf-8?B?Q1RIZGQvcFFxMVp2NVN3U1lUUEFRaFQyNDBMaUdxTnR5UGRGVUorZzZRb0x5?=
 =?utf-8?B?Wm92cGYvY3doaDNEMTNKQmpFNC8vbjhrd0lnejJkOWxxMDBHSlYyQ0NkTitx?=
 =?utf-8?B?eVpMYmY3YjJpU1ZEZlBKSGpmTGlFa2hPMDF5dExOUFpwTVZ0Y1dlWXJ1WVZL?=
 =?utf-8?B?NlRhM0NMb0tpQ3pIeTZHbHVjc3Blc0JCeXBsN2FVb280MkZMSlZHdHBYVTFR?=
 =?utf-8?B?ek4ybTZxdDZFbG9tNlpUMVNzckZ1Sk1VZGMrMnQ3Ry9tZVdtSTV3OW1ZMlNJ?=
 =?utf-8?B?aFI2NUNnb2xnY0QycjlKNitvZUdFUjUyN0pZb3UwSFp0K25UVWxJT050SG1w?=
 =?utf-8?B?MFJvVHZRNSs5bmxGcFNiU0ZNVmhZaitlT2drN3pWWnM2RXprcDVEY0JSdGFo?=
 =?utf-8?B?Sk82YlVXY3dqRGtNaFVhTGx4WndYZHhUcXF5ajN5V3B0cC80b2w3VGlzeE5D?=
 =?utf-8?B?N0tIM0tXS1luNUhTYkZXcFVRUmh4T21tU3grMHNraWg0TUUxcWNodjJGYXM2?=
 =?utf-8?B?U1J0ci96UHNmdFRzdnQ2dmYzcFYzczl6YmZ6aU9taytNajhMbTdWeVNQZjNo?=
 =?utf-8?B?bGFBcGU2d1cxUjZybEdMRnJQZ014WWFTOU92NmhoZ3RmRjZ1a1RxckorS1lS?=
 =?utf-8?B?QWhrUWoxbVBnbEpDOExtTHpnR3JjWnN6VzNEM1JJYUxvbkJ5R3VrUVh5bzlH?=
 =?utf-8?B?QjJnbWloWWJ4VDlQaFEwb25pejJSLy9ESGNjWldZUHd2N2kvVjdpRUxtNUxM?=
 =?utf-8?B?eU5tMHlUWFRXSUFsTHpDY0d1clFWQzVEd3BVeTVQNCswMzRlMWQxQ0xiNHF5?=
 =?utf-8?B?U2lGWjlTV1NoT29uMkFJNkNoYkNjWnFMdWJ6NFozbGgwY2JiYThnK2pyUkRI?=
 =?utf-8?B?cHRBeFFTWFFpQ1RSUi9ySEJTTm50eVpKK0pTL1Nha2Y0RFd6ekRhUmNVZVI2?=
 =?utf-8?B?TmlXVERtYXRBY0ZIQ3FqNnIzWVNteGd2MnFKaUNJKy8xTHJBMk51dnRTWlIz?=
 =?utf-8?B?dGRBakpkSFNlV0hVN3Btb3NVQWpvMUxnNldWZTAxZTJSMXNJWkRmbVV6Qmlk?=
 =?utf-8?B?S2dVNWJnT0FxRVc3Q3A4MEFBYk5VRUgzdXFlQ3dremkySmRFVmE0Y2xobm5B?=
 =?utf-8?B?Y0dTQ3ZDbjFpOVV4a24rWUNJTmxKSWY0RlAyQ05nWjV0cCs1d1J0RUIwLzNk?=
 =?utf-8?B?YS9EZVQ0SXpCU2kwS09oSmp4TTdnWU40YWxEeXRtNEYyZDJhSjM2UGNmYVYv?=
 =?utf-8?B?NzRBWjJiYTB1NzZyU0dmSkVXRzF1cFN0aWxXbEdIUjFIL2NaMmcxT3J2bkt3?=
 =?utf-8?Q?V03ivl?=
X-Forefront-Antispam-Report:
 CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:56:36.5734
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7bb032d-c3e1-4782-ade1-08de3da662e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF12253E83C

On 12/16/2025 10:47 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:23PM -0600, Ben Cheatham wrote:
>> v5 Changes:
>> 	- Use setmntent()/getmntent() instead of open-coding getting the
>> 	  debugfs path (Dave)
>> 	- Use correct return code for sysfs_read_attr() (Dave)
>>
>> v4 Changes:
>> 	- Variable renames for clarity (Dave)
>> 	- Use errno instead of rc for access() calls (Dave)
>> 	- Check returns for snprintf() (Dave)
>> 	- Add util_cxl_dport_filter() (Dave)
>> 	- Replace printf() calls with log_info() (Dave)
>> 	- Write correct value to debugfs during protocol error injection
>> 	(BIT(error) vs. error)
>>
>> v3 Changes:
>> 	- Rebase on v83 release
>> 	- Fix whitespace errors (Alison)
>>
>> v2 Changes:
>> 	- Make the --clear option of 'inject-error' its own command (Alison)
>> 	- Debugfs is now found using the /proc/mount entry instead of
>> 	providing the path using a --debugfs option
>> 	- Man page added for 'clear-error'
>> 	- Reword commit descriptions for clarity
>>
>> This series adds support for injecting CXL protocol (CXL.cache/mem)
>> errors[1] into CXL RCH Downstream ports and VH root ports[2] and
>> poison into CXL memory devices through the CXL debugfs. Errors are
>> injected using a new 'inject-error' command, while errors are reported
>> using a new cxl-list "-N"/"--injectable-errors" option. Device poison
>> can be cleared using the 'clear-error' command.
>>
>> The 'inject-error'/'clear-error' commands and "-N" option of cxl-list all
>> require access to the CXL driver's debugfs.
>>
>> The documentation for the new cxl-inject-error command shows both usage
>> and the possible device/error types, as well as how to retrieve them
>> using cxl-list. The documentation for cxl-list has also been updated to
>> show the usage of the new injectable errors option.
>>
>> [1]: ACPI v6.5 spec, section 18.6.4
>> [2]: ACPI v6.5 spec, table 18.31
> 
> Hi Ben,
> 
> I did a patch by patch review but saved up a couple of usability things
> to chat about here:
> 
> Consider removing the -N option and simply adding the new info to the
> default memdev and bus listings. Both are only accessing debugfs files and
> don't add much to the default listing, especially the memdev one.

That makes sense, I'll do that.

> 
> For the protocol errors, the cxl list entry is always present, even when empty,
> but the poison_injectable attribute is only present when true. Should that be
> always present and true/false? Or maybe true/false/unknown, where unknown is
> the status when CONFIG_DEBUG_FS is not enabled? 
> And, maybe something similar for protocol errors?

It's probably fine to have them be always present when CONFIG_DEBUG_FS is enabled.
I think it would be cool to have them be removed when CONFIG_DEBUG_FS is disabled,
but I'm not sure how that would work. If I can do that, that's what I'll do.

Otherwise, I'll just set poison_injectable to false. That's what makes sense to me
since poison injection and error injection into non-RCH ports aren't available
unless the debugfs files are there (AFAIK). For the protocol errors, I'll either do
"None", "N/A", or leave it as an empty list.

> 
> Please add more strong 'danger' warnings to the poison inject and clear
> command man pages. See Documentation/ABI/testing/debugfs-cxl for the language
> we converged on when adding the debugfs attributes.

For sure, I'll take a look and update.

> 
> I have no test for the protocol errors. Is there anything you can
> share for that?

I don't have any at the moment. My first idea for one is to modify the CXL test module(s)
to replace /sys/kernel/debug/cxl/einj_inject with a dummy that prints a message to the dmesg
then check for that message in the test after running the command. That would somewhat match
the real use case, but doesn't test any actual error injection. If you think that would
be useful let me know and I'll put something together.

> 
> I'll send a separate reply asking if you to append an updated cxl-poison
> unit test patch to this set.

That sounds fine to me, I'll append it on v6.

Thanks,
Ben

> 
> --Alison
