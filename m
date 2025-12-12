Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C314E246BD2
	for <nvdimm@lists.linux.dev>; Fri, 12 Dec 2025 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765555806; cv=fail; b=jEsOHvRet9GjZ6gkzOSWt7u236oeYY9hOflFjtw0sqb7XEmNUG4onqLwGhv9macDry2g3ULHK9j3dz5NwUxYvthjjnGJmswW3D/PfZgskn3RH18Sr/g0zeiYbVthDJZ0Z2RTpQXCvaVmEDDtRsVArw1ueMjjSASAs8vAgBHBpqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765555806; c=relaxed/simple;
	bh=SyB2jfaZW17IKzfCF4F5odfbNeaU9cvs29sr5Nj9qwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=guW7mNUOiE+P6Qd7zlbHt8PiRvCDG9TkIDh3I1coC5R3/1KtXqRN+Cbb6Jc68Kz5LcCKOO/2kNJhf6ozW7sPkfJJvM6lZs6VVIT5Ug2aLD/mh9Qm799/1GS5bLO9K4nyPtYIw3OdRGEDy8ulCuOQbft5qCDibkYerHGYppCrDXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lPInKYz8; arc=fail smtp.client-ip=52.101.193.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lPInKYz8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ntuDvOBJALfElHe0bo+wWQm83Neq6NmAU1OCJPnG1VGxlGub84OVAjrkr1csL7fm/AxyxAV2aufL1x4/V/A6TyoFPfRMFBHFswOGFtdK/qckGzLApY75poMw055DAyG4pEl4aNkpFJj9NO/lOwWtUmEMBhLb9sd73lyRNXjP5f++vIJcIQ+H6+mPE6F/n5t/Y804ebzaffQqeUSMOrEGC50DHxtlUIocF0c4NbvXpOQcOFj6RPy1u56WZDdisTXnfH7Wd6yFpkz93+liIom+L8NOX/+FC0BOr50d/jIgCnGBaQYfbtMxx8beEW9psuOA34kvNJMlkWjPX0N7FLIKwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eR0LMPbpLAkyNndA2vILbLMhabYL+5PLQMxExc9Rl/Q=;
 b=FZCuJCTYcdRCN8R6wqi+1JjUUEY05hhuySjESYJSCxhHmfEuE/JmUxUcI6QW5d2iGdFp2mJHA/1MKtWdHtnJkNjjs/KNuOKsF0OqeEu4N03TdrotlmqeOhNOxdBCL+uJYHbxXZ79ps8LgyI6dfSJQLx0x+Fu6b6vYpixaLMN7NZ+sojEJmcHPsBSBjzK7w9I4nkxswkggFtriVLgxFbpJErQDHwwxzYdIEKatcq+fHHjum+w9sDk0bhPMNkUYUhxrnj7fK2IRjQvAUnUjhBeYI0q2EigI+qf3wqNTKJvw7vgXx8bfRkP/jfZB5/5YNJplnosqr9a5xrC2OXT1nWANQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eR0LMPbpLAkyNndA2vILbLMhabYL+5PLQMxExc9Rl/Q=;
 b=lPInKYz8nFIKQ0sOFTqf+K97cFKKM0sgYVeZDfmUvxJEtVYRFarrT3p9L0nrVXYrxBIMvVjFheqqhidpaCi4KWl3eFEfqiy+axb/hfka5/KMiKD03RZ9tnjGUI51MogwZus+RFKjx/gBoF+G30SWAWUzQLKYxQ47OYMcloXl5js=
Received: from CH2PR05CA0004.namprd05.prod.outlook.com (2603:10b6:610::17) by
 CYYPR12MB8924.namprd12.prod.outlook.com (2603:10b6:930:bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.7; Fri, 12 Dec 2025 16:10:01 +0000
Received: from CH2PEPF0000013B.namprd02.prod.outlook.com (2603:10b6:610::4) by
 CH2PR05CA0004.outlook.office365.com (2603:10b6:610::17) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.5 via
 Frontend Transport; Fri, 12 Dec 2025 16:10:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF0000013B.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Fri, 12 Dec 2025 16:10:01 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 12 Dec
 2025 10:10:01 -0600
Received: from [10.254.59.95] (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 12 Dec
 2025 10:10:00 -0600
Message-ID: <0fcc8081-262e-4028-8920-70d12b835e37@amd.com>
Date: Fri, 12 Dec 2025 10:10:00 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] libcxl: Add CXL protocol errors
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-3-Benjamin.Cheatham@amd.com>
 <1a82d5be-3126-4b04-a5ac-da651c33a21b@intel.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <1a82d5be-3126-4b04-a5ac-da651c33a21b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb10.amd.com
 (10.181.42.219)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013B:EE_|CYYPR12MB8924:EE_
X-MS-Office365-Filtering-Correlation-Id: 60e7f9c8-db37-4cd5-bd33-08de3998e75d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZjBtV2tpRVhPVTZrU2htMjJpL3M2R3YrUFJJNVBJazhvSEtVYjB4OTJCUG9q?=
 =?utf-8?B?UU9idEtLZHBrN3JyMVRMeEdjNEJkNDY2eVFoZlZCRGNSRjlZaFFnMjBkbUVv?=
 =?utf-8?B?ajVNTnRLdGVlQVYxTWlVOWRrNWxKaUFON0NaVCtjUWk5UXFESXFJRXhOdEND?=
 =?utf-8?B?ZVdLZEczSW5nUThFNTZ4SWtybXhESklnMkRaTlZzMm9LTkFsUWVtbERUYS9D?=
 =?utf-8?B?bi9wQkliUngrdGdxakNUUEgyYnozQjkyNFFoQUtwZzRUUzVVZHFwYmp2ckRK?=
 =?utf-8?B?WG9GSFRYWTZFdlBjMHpieFR3bzhzTFZsTndKNndGeTBGdGxQUE1INURjcUt6?=
 =?utf-8?B?cVFEWXJOdVhKaDJxT1c2cGJwVEVqZytnUjEyVGo2N21BbU9kcUlpWGhLUDdW?=
 =?utf-8?B?WGFZa2djaFNNYjVmcjBLcnBpc09ZS2Q1WEYvVHdUZDBXMDVIODV2bUdjdWht?=
 =?utf-8?B?MjVPa2dxSGdDSklEbkhMSi9oR3JrRGNXSXNML2FpMTlvVW9zMzJFOHpJQndq?=
 =?utf-8?B?ZW43cDNSYm9UVlA1aWRwUnMveGtIZnhpcUEza1Jwa0U2K2NBeWVjdG5kcFFv?=
 =?utf-8?B?c2dHQUxMYUFRZFF2M1ZlZ0VTdjFTajcxQVNQMlJ5RUFUT1grODF2WUJtTytJ?=
 =?utf-8?B?aTcxcDB1VUpOVUl3eWJ3ZlMzYndwempSelQ3Z09VbUhaS2JORUpKUlBSR2Vp?=
 =?utf-8?B?T2V4bmVmRW0yUzFlODVlTW9GdmdZK2RYOThDSFhoZ1RtS1NTSDVnQjQ3blls?=
 =?utf-8?B?aUlPOVJrOXU5NTZqTm5mRGd5dHJEWnk5ZDMwZjF3YU85STAwQ2J6R3hJOFNm?=
 =?utf-8?B?dUg3UU1jRnhhZzZQcXdieEZXdVEyTm00cm5lbmJTckZnVXhEb0VKTUEwTi9v?=
 =?utf-8?B?R3ZwQ1kwMWVhYkdmdmN6aVpLK2RReUxTRGl3VG9tN0pPekx4TDM3KzZNalhE?=
 =?utf-8?B?QVJyZ21XY1ozd2VoRTNRQ1F5UHVGZ2t6WVhTOXdPOTMwd21QRVBBNDg3VzBh?=
 =?utf-8?B?ZjA1eXpZTFFOR2ZQd0h4L2MrNnViTmFhNHg0Sy9GNFRDVHQzb20zM1k3bUxZ?=
 =?utf-8?B?cWoxMVhQQWRJQXh4UEk1cGg5c09tbHdHbnpIN2NGWlZWQ2xIRkttZmp5YWxB?=
 =?utf-8?B?Y1VzTjBHaWV2ZlNDTjdmMmNZSXVyNGw2YTJ5WE9aVmVXelVpa0RqMnd0MTJV?=
 =?utf-8?B?WUNHajhTSkNVWUhtRXplamk1OHcyeDhKSmpUMklDTlNIRjVFaWgzdWxjNGxT?=
 =?utf-8?B?eUZGUkRDQlNQS2VxWlYvcEpsU0Z2bXp1dE9SNVFtbEFtZklZU1E1R2pzdmJ2?=
 =?utf-8?B?SlQ3Z3ZMUXdRbXo4dlRkN3NsTzc2M3lKc0tIb0toWkQ3bDM5M0R5Q29PdGkx?=
 =?utf-8?B?L29TQmFJWEhUcGhoYVdsUFl5RVUxcmJEUUlBbHJLVkk5ZDlUMWFaQTM4YjVx?=
 =?utf-8?B?UGtYZzd5UVVIQ045OVN4akZRckR3VjNMUGVMN29QQm1wRDZ5eHFvc3hqMFZN?=
 =?utf-8?B?dFQvckdWS0FScXVwTDVGeHR4cGtqdTRQN1FLVDdPZ0tGeWtIZ0F3emt6V0Yx?=
 =?utf-8?B?eFVva1laakYwWVpSbXRQbFNjVzdqc2tONUd0c3N0dVJjaWFLdmhFV0ZFVDAw?=
 =?utf-8?B?VmcxN1R1THpKOHNpREpsbXByYTJDVjJpL1JqaHJzVjhkVkIzVHJZMWtMYjVD?=
 =?utf-8?B?VUZVaURxSWlSMDI1UkxtNEVkdk1FMVFVbmJxc1g4TnhjTnYrSlhzN3JiU05n?=
 =?utf-8?B?YW5KQjlYanBPUWNsV0RieWp6L2YzWjEzSzZhcnZjSDFHNEpOSUtiaW5VRDE4?=
 =?utf-8?B?S1ZLamhucERRWnQxTS81QjFPbmVlcDBHUzNHRFBmV3d2NUxEbHJnTVd5V3Fv?=
 =?utf-8?B?c1RUeDVWYmFTY0RCcU9FVUlHRXhPVVpKY0duWkRZNFpCaFlUY1ZDNHBpMXU5?=
 =?utf-8?B?UTJmUnVCRDNPbWp3UnFpdjhkY3p6UXVOd3hldVlvV1Z5NEllRE5URElwS0Vx?=
 =?utf-8?B?YkdLRVc2Ymh5YzF2QU4zRytYWUtTRS9pbE5ubVFGY0dwZlR6V2QrUHo1UmNi?=
 =?utf-8?B?YmMyT0J6MU4yTnc5VTVneWxQL2tBb080cXVtd1NnZHoyS0QrR05XcmhqT1NP?=
 =?utf-8?Q?vc8c=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 16:10:01.2132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e7f9c8-db37-4cd5-bd33-08de3998e75d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8924

[snip]

>> +
>> +static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
>> +{
>> +	struct cxl_protocol_error *perror;
>> +	char buf[SYSFS_ATTR_SIZE];
>> +	char *path, *num, *save;
>> +	size_t path_len, len;
>> +	unsigned long n;
>> +	int rc = 0;
>> +
>> +	if (!ctx->debugfs)
>> +		return;
>> +
>> +	path_len = strlen(ctx->debugfs) + 100;
>> +	path = calloc(1, path_len);
>> +	if (!path)
>> +		return;
>> +
>> +	len = snprintf(path, path_len, "%s/cxl/einj_types", ctx->debugfs);
>> +	if (len >= path_len) {
>> +		err(ctx, "Buffer too small\n");
>> +		goto err;
>> +	}
>> +
>> +	rc = access(path, F_OK);
>> +	if (rc) {
>> +		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
>> +		goto err;
>> +	}
>> +
>> +	rc = sysfs_read_attr(ctx, path, buf);
>> +	if (rc) {
>> +		err(ctx, "failed to read %s: %s\n", path, strerror(errno));
> 
> sysfs_read_attr() is a local lib function and not glibc. It returns -errno and does not set errno. See util/sysfs.c.
> 

Yep, that was me being lazy and not paying attention. Will this (and the one below) for v5.

Thanks,
Ben

