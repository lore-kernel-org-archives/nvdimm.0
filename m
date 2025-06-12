Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7681D90C8
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 21:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749762777; cv=fail; b=Vbo5U737Rr1Xf1QZQMquUmSabMY4m2NG5EIbb9Ha4yR4bR/fA5mSxaVH9QC92agZuScF1rnqRlBj3Z+0THMrBidExHgHex007cEhm9Af5G9RYZIOHhM7u+xL2CYocYJtyjFsAj1IWTtz9vOxBl8ve8C0TAxZueb7UHiwAPy4heQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749762777; c=relaxed/simple;
	bh=mt26W3OJMI/9HNUfDFt6b1y36iYDgcNcSAjuoEcrOHw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O7v1jTN2kUF5DwibFW7bOCa2wjGaniVC7cINEuR7pqNo9KC4N5z+3rQfmv91L6XEpU0FZMV/P9FkC/U6O5qEv/xfWZiH3Mq0xrsgK/t6NeHAMj5GW2GZzCLm2Vz5C8Hp3mx4uYzs/W+WY7XYYGVLI9DylAGByT72B1Mn+1/0BZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DLYCrMvZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zuIOJxQM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DLYCrMvZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zuIOJxQM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CJhpXB011851;
	Thu, 12 Jun 2025 21:12:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jF74CRPOxLuqvkMKC1hiasr9357DvI06RYftKXh+RF0=; b=
	DLYCrMvZVVP/E9AJUl4+pjbOBKYcu1FKaDT8A15t4N/6A2Tvc8LVkMylGt93ysLN
	5lwHYrdiAw57RdiqnTVAGfHjetwL0q/ZH810Vq2/OoDSy8GnBNPmeNZsTP/IlzgA
	mTtV+K+oy9iLPBfeeqwgrC30PzKIvxEB4GU/A+JelAMsOgJQEHzlM3ZdLhtnVTod
	xfmaI/gRMK3Ne3svKV1qMj2NfuUdB2dHixLpCwwF/OhduUIqyHAteeIb0e5Y7vVX
	qDSRwCUxUuDczYVDFA09/OP4kO59f1OmWTyQ9JIgDPwR+lZr9DkQJTZWZDvjCrjY
	PhRTrQ2E++becJ/NjB+D5w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xk21bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 21:12:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CKx0bT016815;
	Thu, 12 Jun 2025 21:12:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvc4g48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 21:12:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bxPN2gv/6slmE9+A+4WCUf6OMkPkBfwfcNqSZoPAJe5XEaqPggjJP3chpyLzuGdvupSCeATDuJf3nKTRoJVJ2ffFXbwnQoXZS+h1/WgT9HWQ3TJgsG4VWXb5Chi5OFhcyR7IfWgUQacDaqz2kKEip/9Dak8BJOPuJW2ZB8HQID9wwo/K1H0vZ+4xYbO/dvwLXDHXQa6ZEaL+MzddEcVu84/HHIZ7iVyPQeQS1YszWLUI8uoJeBj+VKOEeijHyFIHq/Lfh0I0H0t5/JFTTXx/mqKChg12L+kWzzp5WtK8WYXURrPvyet00ZaA8+b2YX3Ggnz4LE2eKaAQt/CaWeah+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jF74CRPOxLuqvkMKC1hiasr9357DvI06RYftKXh+RF0=;
 b=FyS83N1bYBtUt1KE5DLqvwMGeEqEjVw4dCnG9rUCsyhFahqkm/1mCPypDboajibcABpfMpvX0QZSbbXrszvYuRVQjznxbjf1wd5E8iQFtwB2A0p3Pn9hAzDWrbcD78KCuKiBVo/myuctD2UrPbPQYKMUAXCSMbrucf7vY14oLD3NwJOo6IwQVRENR3YRIXJt4KRpStDSWNAvN7dJHcUcVzXm5l9AVpLEx0QlgczUcdaL5jcRQUEo+DAvbEwraEO0yu2SlyKjtTn6OrOmzYaWQJ5NhsFJUSvdthhYi7YbWnGoHTjP0YYp16axiYug1Yr7v4RG7gkiJHfUlBME+ijv3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jF74CRPOxLuqvkMKC1hiasr9357DvI06RYftKXh+RF0=;
 b=zuIOJxQM514qKQMfqGaljvsma4itLazL+YtZ7oDTESiR20nPzVmU51+sMwwU1vliesqoEswhzEELktWGaZ/lZIrqNoc4UFtlLVjt0qmIxjoaRSWJXdo6IcK1MGcPxPU5TWhNUEoKi4xAv2guWmbWp+ews8rAwVHLNN6fVVNMog8=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA0PR10MB7274.namprd10.prod.outlook.com (2603:10b6:208:40f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.18; Thu, 12 Jun 2025 21:12:45 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 21:12:45 +0000
Message-ID: <9d75cf8a-42ae-4e61-90e9-6ddd937ddb01@oracle.com>
Date: Thu, 12 Jun 2025 14:12:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM
 DIMM devices
To: Mike Rapoport <rppt@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Tyler Hicks
 <code@tyhicks.com>, linux-kernel@vger.kernel.org,
        nvdimm@lists.linux.dev
References: <20250612083153.48624-1-rppt@kernel.org>
 <20250612083153.48624-2-rppt@kernel.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250612083153.48624-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::21) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA0PR10MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: f99cbd7b-e42b-4cb1-a511-08dda9f5e08e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVQ2ajY2eURIblJmS1U2OUNsL0lTWjZ5R0pqbHkvd1htNEhlOXFaS2xRT3Zs?=
 =?utf-8?B?QXVBOW12MC91SEdYeUErMy9pZW9IcWhiNURldEdXZG82QklhOW1GT1B0T2lw?=
 =?utf-8?B?cEpDL0c2cy9RamR3bXBxcS9aenVGV256Y0syVGZZd0lwQVJKZHhjNThaLzNQ?=
 =?utf-8?B?V1IxVHVNYjJSeTR6R2c5Ui9QSHNjNTBVSzJuNjJ6WFN0ZkhBUU5NY212Mmha?=
 =?utf-8?B?VkZxMjI4MlRxMStKUGZvTkdhRWpSQXNnSmFJSlVzeUp5eW9tRDNNdU45UW0x?=
 =?utf-8?B?Ujh2ZzQ4VjJvb2lyRk9CZjNLOUNGZTFZRXNJL2NDbjlWNEJLeTE0OGFwOUpQ?=
 =?utf-8?B?Wi90aWtYQkJ4LzczU0poL2NrTGdMUDczcEgwRmxOQW4xcEFRMlNzOWVTcVhV?=
 =?utf-8?B?TFpObkJPS3N0dXRjcXVMZ0JwU0N0K2dQRElCYnk2eVVLL3NmRU5Pdno3a3lX?=
 =?utf-8?B?dGkxZXBwN2JLYVBwM0VHdmRBUWpTNkVaUHVLU0ZnazJzZldjekV0VXRMSDVr?=
 =?utf-8?B?T3VhZUtWbkVaa3FRZUtETmk3Z1h1d2Z1K3E4T0dKQTYxbHFzU2kvVGFkQXJn?=
 =?utf-8?B?a0swY2orQ296QTNhUmpJbHIwZ25SRUcyN2pkeU5OV0FpQW1scGx3a2FiZ0dt?=
 =?utf-8?B?cnQ1eXN6T0IyVmRtZy9RWU5SOWtNdjBjNEVWS1ZHeHp6dTJDSzM5d21MNDlx?=
 =?utf-8?B?cmp4cFBvNlRBLy9iU2U4OU5jMGNsRmZBaHdWVkNmYTJ5c0ZmNVRhSnV0dUxO?=
 =?utf-8?B?TUk3RkkzTlB3MHk2Q1JlUisxL0hSMDN3ZitDSVhrMyt0OUhSY1JDaXY1aXlu?=
 =?utf-8?B?WkJLcUR3ZkdWd0M0NXNNN003azV5Z3dLZ2lCQVNPZzFkRVUxTmVCTFE0TllX?=
 =?utf-8?B?cXUrdW1OZ0IzOEdOTmhlTHVFSkJSdmxReHNJMExCWjBMMXFnODRmdlp6Sksr?=
 =?utf-8?B?akY4SXNsenF3Rk5jZk1oaHNGR3FtRkNUTzVlU0tMb1ZLVWdpQlgxZzVibUJj?=
 =?utf-8?B?YzRhQnQ4bFFNN1M0dW1MUWRhdCt0WnFBbTdTMjFCajdrT2pKcFlaUUVFNHo1?=
 =?utf-8?B?cU4wNGtWVkFsVHBmK0RGU1h0SVlZcWVlWFFTUDdQK09jVU1BeWVjbW5adElJ?=
 =?utf-8?B?UXdsVk9qNWJETHJWaEJuNWd3T1ZFNFpKMFhvT01SL2lwL2VhSmVLcjg0OUxG?=
 =?utf-8?B?ZGFPKzJLWUtGT21GWkpoNzYxRXM1ZDl5N25sMXA0OVhnc2lyam1hYjBoK0I4?=
 =?utf-8?B?R2hVaHFtSHl4YnJiUDl2UzVrOUVIVk4xdnBsZEVjUWZoTml6OUg4RGp6cFdJ?=
 =?utf-8?B?alB2dFhKYlBrWE5HQ1FLbHNSOTU4WTZhbWhRMlU0cVduNkhpV0gyZGZCU0tB?=
 =?utf-8?B?bE1kcWZjOTBLVjJ5RVRiMGt2cFlCcFFXM2lSVTZIWCtYV04reU1PRjBtdkJo?=
 =?utf-8?B?cnprQmRkSU5PUE5MK1BBb3piVWV1YWhMRTh2MUp3ZllSTHZ5SnYxT2dTRlp3?=
 =?utf-8?B?akhDYm1pNFZkaXdYUksvZ2E0WlZsYUU0V3JmeWtXdmY2SDNlQnAySkdraU4z?=
 =?utf-8?B?UTlIOFU4WXowYW5aSGwxbkJSRUJHM2dUTzdSK3RZd2RQMWNJZWFubVZxUmtN?=
 =?utf-8?B?M3ZaL2FuTlJ3RU5INWhWdW1tRUZPaTR6dnZJZ3BBM0xvcWhKWFVQMmp6cDNx?=
 =?utf-8?B?d2FxVzJLRjhGUXkrbFpqcjR0bUU4bkdwY1A0SWJMdlllNWdCN3dtRDBzSFJr?=
 =?utf-8?B?eDMycGZjck5La1pFcGRhZ1NXNjlwY0pHdktSbkJ6SFZUb2FXcFFLcmhtcElP?=
 =?utf-8?B?Y21vdU42aGxCT0NYVVdoejY1eUdhR25WY3R6QUQrb1hrdGY2UDFwY2xTNkxn?=
 =?utf-8?B?b2lVdXpzYmdYYldVZlM1TUd5NzViWWx4dlpjdVVvMVRkRFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFA1dEdqZ25lNjRwajFPQlVBRVlnOERBV1lMVFYvaFN1M1BDSE1RZ29PVGc1?=
 =?utf-8?B?ZlU1c0RIK3RleDJRYzIwUUVuM2tRNTF2TVZuY0lCc1dwOHhIVlhzWWhzYzUy?=
 =?utf-8?B?N29ka0RBcUpPalkxZ0RkdXhFVWdQTmtFOG9NWXhtM3QvZkRKWW9vZDN1UEJm?=
 =?utf-8?B?K1hRQVhOSFp6Tm9JR0hxdTVMaHpOL21NOUpwU3Z0N051Q3QxQjlGaEVPUTMz?=
 =?utf-8?B?RDRMQ0VlMk56S3pXem1KMkRvNWdZaDRKTTVsSlMzMzVJc1g3Y2lYc2N2VWo4?=
 =?utf-8?B?SS9oNjVXYldrZndNbnZxK3hRaERLYzlwd0xOSHJyUlRCOWFvTXh6ZlEwRHhn?=
 =?utf-8?B?UEVUcmNVMU5ZRytla3RZQUlqRkJ5UStYZFk4eFNFMkRBb1VVa0VPd2N2MDNU?=
 =?utf-8?B?azQzbndvdk5yWEh4d1gzOXdpWGJFMU9sMXR5R1FhNDMwM1R4Rk5nZXFkUjZH?=
 =?utf-8?B?SFQwVFg5eEhxVTBSdmlRVjdMYmlCSmN6OTJQaFkxSUs2dERjQUhjbkFtM3pk?=
 =?utf-8?B?Qm8xNCtlY1FVNzJpUE5LUzU2eHZmeDg3T2hYL0hPNTdSYmRzdUhvOHU0UDJx?=
 =?utf-8?B?OEkzN1dOYTJjY0dTK01oWStwSktMTk51cDlvZ1VvVzZsVXFrbzlsYnVTcUxS?=
 =?utf-8?B?bGQxVFY1TGdpajBQYkhMZTFwb01SZytSb21QaXA2QWhyUktON3F5S05qL0t5?=
 =?utf-8?B?cktqOWhvbzZ0aStSUGpTMHk0ZUtDQ3V4QXZCaUtQQ3ZRVDBnM0Y3NEEwd0VI?=
 =?utf-8?B?Wk9ZU2ZHbllaN0tlY1NZZXM5SGZRQlhWVHZsbXBWczg5SFlWeTdTY3FDM1Yv?=
 =?utf-8?B?OFNnUUJBbE9ITzdBZzBsY3NVWlk4VlVsM3BrNUpuTnBNaC9mc1pMMWZIRWFQ?=
 =?utf-8?B?N3oyeEYvRmNoM3N2akh5cWRINERrak1NbFRGK0oxWkYyY1FIRmtrR044cHJE?=
 =?utf-8?B?TTFGMTh6YWlobmRwa1ladE5yS2lZSFNFK3ZobE9nb3J6c0I1VHQwRTNIQXJZ?=
 =?utf-8?B?Y1krZ1lsUmxSTmEvMENpMk9LTEx2dFdMQmdwNWtwWmFnS3I0dWlXOWZKRGVl?=
 =?utf-8?B?MnJxbURmWFRWdWsvMDNKMWNLMVJvS3oyNkM0YUg3ZzNPdGs1UEU0NW55RDNl?=
 =?utf-8?B?aUlib2o0dHdrOWRiWE84TU5Lc3ZXblVudE03MXl5dHVMYm5JaktvaVR3L1lT?=
 =?utf-8?B?TFVPK3J5SkZBRVowZS9EZEJkMWZ0VVFrbm5NZHpZQUF6LzlFNlE0QjZnekxI?=
 =?utf-8?B?TEJObkJRL1VEd3hFR2gra2lwekhua1oyUVdEWExXa1ZlNFl0bCtDWk1VNldJ?=
 =?utf-8?B?UmJrakFRY2ZZN25QbEFQbEZsR1d3MEp4VHFwYmhTQjhJbHRTSE9VWFh4YjlJ?=
 =?utf-8?B?cHBjeXF4TG03dWhxcjljdml0NTJHaThiM2dpa3ZiM1hrNkdOSzNaSmlETlo3?=
 =?utf-8?B?SzVQTlQzbzMxOFlLZStmMm1lbFdCUm5xb1dMYnVZZ1g2UEZoeGNJRFhkWkJK?=
 =?utf-8?B?RDAzS25Gby9XQ1Y5MVdSOWl0dVVMUUNhV0Q2TkJvV2grQmVqdzZwWlcxZEty?=
 =?utf-8?B?ektOcWp1ckFycTRIQnVpRllKeVQreTIzN3NhOHluaTB3MVNac2hVTHg4QUUx?=
 =?utf-8?B?Q1lwaVZyTlRmaUMvOFZMT1BYQmlhWmlkbWtlbktlc3QwbWkxTWhwQ0V5V3BH?=
 =?utf-8?B?SFZLbDNRZU1jWGtHNUw2RWJKODBuZzVjNHNxMkRPVyswdS9UR0t4RXRWbFZu?=
 =?utf-8?B?NUtsT3IxL1o0bTREUTBIcnVmQ2R0YzJ0OFpmWEMxQk5BeXkxQnhxVTdmdmVl?=
 =?utf-8?B?bjVNMDNRYlZaRHh6azJvbi9PaEtqV2hGNDBISDZWTnM5U2U4dGFTYWZJWlVE?=
 =?utf-8?B?UkNTYmJRdm5TMHdRQ3F5MGhnNlU2em9xUExYdUpLTVIrWVQwQytxY2U2Mity?=
 =?utf-8?B?TlByYjdoZzB5UE1qZjFPTm1rMXFOdldFbDBHVUErdUhoTkt2dFZwOU5QNXgx?=
 =?utf-8?B?bG01ZmZrZlB3SE1kWkZzWm5CY09DUmNldnBuem9tNDArWDVZSXpOYXM1L1JE?=
 =?utf-8?B?ZzA2bVlicXRSTmJyY0luNGtIa0Uwa2N1cEdCUEExbnFoSktoV1o3VkdzV3NW?=
 =?utf-8?Q?+vv2HGIkPbkGH+alFcI85mgyP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lRsyBxdBrnnoxyJgZ+gJWyQqlmE+krjUOdQanMEk6COfMnVBcO8/pfL+0aODWOm4SQMTUiqjfsk1SupMt2f+4v2/NFX1PRRFzueOjwkP3AsXUpK47negyRBUoxabZyUblc/ey2rPC0d3ei59fTjTpzb0uqotSSfi+Lnc6BWYoLoZyA8gtSAd2lKmGkVcBdIYkQH4Rdd0Q+zM1WeIeLE2v7lsOptSr2MXPiNJlEvQqLL6pVZuaFkcj7g+wdmewrawaNM8xze5gIPmbI8H0f9Hjt/NqYh/2JeSfHM+fpBjtXzfuVIqOt9UIWg8BJ51fEH2nO2PL3UOb++hizK0jseC9L65LYEBZFq4PY0RzPoeCy3O8I5h6lLAVQezqq0M7yooK7uILj5KAnziMoUcDxcUvTjZ7GzwjkLcAFoeQGiYOtZqZw3jyyJ29QlCvW1lUubb4bY6U1WuhKFSj+9FLjQDvTgR6n4ZeMJ+mwB9nEwea1SIfgUm0gi1BnuC5ZbFljt0zJWzGPbbmRAsQPfm2O2DDdTUkWhXLIZPXNHa7JelthaJJQGy6iv6I1cCB7hmscCmjq5RosNMZt14PJAU9J8+eDAuFsKsKeGIg2O1LMO7ftw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99cbd7b-e42b-4cb1-a511-08dda9f5e08e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 21:12:45.8195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4MKsKo3upy6ovpKu0S6RO+y2cs9Hg77VOrB4Oa7hJDTasYyuwE516l70CK5zWkn6AzbpH28XFSXEuPPgKIRWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_10,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120163
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=684b42d0 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=-JVOVGl3qZ3DxRqVHJgA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDE2MyBTYWx0ZWRfXz435ETwZBnRy u4AeZz7CdRkF6BQg0kEuhH3S4obYX1hD7nfgwLhtz07Wish7/vX13hCgWKc6Q4wmz9S5c6GtG8R DMaaTdNhUN7Dmmo9XmmUD6k+qb5vafiNeIMOBx+sjO4834igsx27Un+B1FfBl9pG+j3zNyZSpw4
 m8o4kXwAu76XaKoowYIPW7i1wQ2Jl/IjgGZjc+edyYwum3dwBo/AN2uc9ISIqm09Si/XC8EkBfj F6nM1aqsbx9108nsS+RntIPKM85GgzpU+eHJSmFIJBJgtRqT9p2T7qc++fKZ1Qmqn66bU583oIr QOJO4WApVJj1TIe0zq2NifpIoEP7Hb2yWQnM+fQnzijlj4K5cuKeY/kCeAojzuAyBFGlqC6Xc8G
 kg6gd0hFMuqSYY1skTpbhCejroRLAOeE9p8XpjOWbaM2ShTHnD2fXJ3e8dhRvoPj8FJHAFZU
X-Proofpoint-ORIG-GUID: jCOIvMebYao4ROyTus4w5JmEHWggAHUu
X-Proofpoint-GUID: jCOIvMebYao4ROyTus4w5JmEHWggAHUu


On 6/12/2025 1:31 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> There are use cases, for example virtual machine hosts, that create
> "persistent" memory regions using memmap= option on x86 or dummy
> pmem-region device tree nodes on DT based systems.
> 
> Both these options are inflexible because they create static regions and
> the layout of the "persistent" memory cannot be adjusted without reboot.
> 
> Add a ramdax driver that allows creation of DIMM devices on top of
> E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> 
> The DIMMs support label space management on the "device" and provide a
> flexible way to access RAM using fsdax and devdax.

Just curious, how does the new driver work with Michal Clapinski's 
recent patch that adds 
"nd_e820.pmem=ss[KMG],nn[KMG][,mode=fsdax/devdax,align=aa[KMG]]" kernel 
parameter ?

thanks,
-jane

> 
> Signed-off-by: Mike Rapoport (Mircosoft) <rppt@kernel.org>
> ---
>   drivers/nvdimm/Kconfig  |  15 +++
>   drivers/nvdimm/Makefile |   1 +
>   drivers/nvdimm/ramdax.c | 279 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 295 insertions(+)
>   create mode 100644 drivers/nvdimm/ramdax.c
> 
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index fde3e17c836c..7aae74a29f10 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -97,6 +97,21 @@ config OF_PMEM
>   
>   	  Select Y if unsure.
>   
> +config RAMDAX
> +	tristate "Support persistent memory interfaces on RAM carveouts"
> +	depends on OF || (X86 && X86_PMEM_LEGACY=n)
> +	select X86_PMEM_LEGACY_DEVICE
> +	default LIBNVDIMM
> +	help
> +	  Allows creation of DAX devices on RAM carveouts.
> +
> +	  Memory ranges that are manually specified by the
> +	  'memmap=nn[KMG]!ss[KMG]' kernel command line or defined by dummy
> +	  pmem-region device tree nodes would be managed by this driver as DIMM
> +	  devices with support for dynamic layout of namespaces.
> +
> +	  Select N if unsure.
> +
>   config NVDIMM_KEYS
>   	def_bool y
>   	depends on ENCRYPTED_KEYS
> diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
> index ba0296dca9db..8c268814936c 100644
> --- a/drivers/nvdimm/Makefile
> +++ b/drivers/nvdimm/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_ND_BTT) += nd_btt.o
>   obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
>   obj-$(CONFIG_OF_PMEM) += of_pmem.o
>   obj-$(CONFIG_VIRTIO_PMEM) += virtio_pmem.o nd_virtio.o
> +obj-$(CONFIG_RAMDAX) += ramdax.o
>   
>   nd_pmem-y := pmem.o
>   
> diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
> new file mode 100644
> index 000000000000..67b0a240c0ae
> --- /dev/null
> +++ b/drivers/nvdimm/ramdax.c
> @@ -0,0 +1,279 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2015, Mike Rapoport, Microsoft
> + *
> + * Based on e820 pmem driver:
> + * Copyright (c) 2015, Christoph Hellwig.
> + * Copyright (c) 2015, Intel Corporation.
> + */
> +#include <linux/platform_device.h>
> +#include <linux/memory_hotplug.h>
> +#include <linux/libnvdimm.h>
> +#include <linux/module.h>
> +#include <linux/numa.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +
> +#include <uapi/linux/ndctl.h>
> +
> +#define LABEL_AREA_SIZE	SZ_128K
> +
> +struct ramdax_dimm {
> +	struct nvdimm *nvdimm;
> +	void *label_area;
> +};
> +
> +static void ramdax_remove(struct platform_device *pdev)
> +{
> +	struct nvdimm_bus *nvdimm_bus = platform_get_drvdata(pdev);
> +
> +	/* FIXME: cleanup dimm and region devices */
> +
> +	nvdimm_bus_unregister(nvdimm_bus);
> +}
> +
> +static int ramdax_register_region(struct resource *res,
> +				    struct nvdimm *nvdimm,
> +				    struct nvdimm_bus *nvdimm_bus)
> +{
> +	struct nd_mapping_desc mapping;
> +	struct nd_region_desc ndr_desc;
> +	struct nd_interleave_set *nd_set;
> +	int nid = phys_to_target_node(res->start);
> +
> +	nd_set = kzalloc(sizeof(*nd_set), GFP_KERNEL);
> +	if (!nd_set)
> +		return -ENOMEM;
> +
> +	nd_set->cookie1 = get_random_u64();
> +	nd_set->cookie2 = nd_set->cookie1;
> +
> +	memset(&mapping, 0, sizeof(mapping));
> +	mapping.nvdimm = nvdimm;
> +	mapping.start = 0;
> +	mapping.size = resource_size(res) - LABEL_AREA_SIZE;
> +
> +	memset(&ndr_desc, 0, sizeof(ndr_desc));
> +	ndr_desc.res = res;
> +	ndr_desc.numa_node = numa_map_to_online_node(nid);
> +	ndr_desc.target_node = nid;
> +	ndr_desc.num_mappings = 1;
> +	ndr_desc.mapping = &mapping;
> +	ndr_desc.nd_set = nd_set;
> +
> +	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
> +		goto err_free_nd_set;
> +
> +	return 0;
> +
> +err_free_nd_set:
> +	kfree(nd_set);
> +	return -ENXIO;
> +}
> +
> +static int ramdax_register_dimm(struct resource *res, void *data)
> +{
> +	resource_size_t start = res->start;
> +	resource_size_t size = resource_size(res);
> +	unsigned long flags = 0, cmd_mask = 0;
> +	struct nvdimm_bus *nvdimm_bus = data;
> +	struct ramdax_dimm *dimm;
> +	int err;
> +
> +	dimm = kzalloc(sizeof(*dimm), GFP_KERNEL);
> +	if (!dimm)
> +		return -ENOMEM;
> +
> +	dimm->label_area = memremap(start + size - LABEL_AREA_SIZE,
> +				    LABEL_AREA_SIZE, MEMREMAP_WB);
> +	if (!dimm->label_area)
> +		goto err_free_dimm;
> +
> +	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_REGISTER_SYNC, &flags);
> +	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
> +	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> +	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> +	dimm->nvdimm = nvdimm_create(nvdimm_bus, dimm,
> +				     /* dimm_attribute_groups */ NULL,
> +				     flags, cmd_mask, 0, NULL);
> +	if (!dimm->nvdimm) {
> +		err = -ENOMEM;
> +		goto err_unmap_label;
> +	}
> +
> +	err = ramdax_register_region(res, dimm->nvdimm, nvdimm_bus);
> +	if (err)
> +		goto err_remove_nvdimm;
> +
> +	return 0;
> +
> +err_remove_nvdimm:
> +	nvdimm_delete(dimm->nvdimm);
> +err_unmap_label:
> +	memunmap(dimm->label_area);
> +err_free_dimm:
> +	kfree(dimm);
> +	return err;
> +}
> +
> +static int ramdax_get_config_size(struct nvdimm *nvdimm, int buf_len,
> +				    struct nd_cmd_get_config_size *cmd)
> +{
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +
> +	*cmd = (struct nd_cmd_get_config_size){
> +		.status = 0,
> +		.config_size = LABEL_AREA_SIZE,
> +		.max_xfer = 8,
> +	};
> +
> +	return 0;
> +}
> +
> +static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
> +				    struct nd_cmd_get_config_data_hdr *cmd)
> +{
> +	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
> +
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
> +		return -EINVAL;
> +	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> +		return -EINVAL;
> +
> +	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, buf_len);
> +
> +	return 0;
> +}
> +
> +static int ramdax_set_config_data(struct nvdimm *nvdimm, int buf_len,
> +				    struct nd_cmd_set_config_hdr *cmd)
> +{
> +	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
> +
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +	if (struct_size(cmd, in_buf, cmd->in_length) > buf_len)
> +		return -EINVAL;
> +	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> +		return -EINVAL;
> +
> +	memcpy(dimm->label_area + cmd->in_offset, cmd->in_buf, buf_len);
> +
> +	return 0;
> +}
> +
> +static int ramdax_nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd,
> +			       void *buf, unsigned int buf_len)
> +{
> +	unsigned long cmd_mask = nvdimm_cmd_mask(nvdimm);
> +
> +	if (!test_bit(cmd, &cmd_mask))
> +		return -ENOTTY;
> +
> +	switch (cmd) {
> +	case ND_CMD_GET_CONFIG_SIZE:
> +		return ramdax_get_config_size(nvdimm, buf_len, buf);
> +	case ND_CMD_GET_CONFIG_DATA:
> +		return ramdax_get_config_data(nvdimm, buf_len, buf);
> +	case ND_CMD_SET_CONFIG_DATA:
> +		return ramdax_set_config_data(nvdimm, buf_len, buf);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
> +static int ramdax_ctl(struct nvdimm_bus_descriptor *nd_desc,
> +			 struct nvdimm *nvdimm, unsigned int cmd, void *buf,
> +			 unsigned int buf_len, int *cmd_rc)
> +{
> +	/*
> +	 * No firmware response to translate, let the transport error
> +	 * code take precedence.
> +	 */
> +	*cmd_rc = 0;
> +
> +	if (!nvdimm)
> +		return -ENOTTY;
> +	return ramdax_nvdimm_ctl(nvdimm, cmd, buf, buf_len);
> +}
> +
> +static int ramdax_probe_of(struct platform_device *pdev,
> +			     struct nvdimm_bus *bus, struct device_node *np)
> +{
> +	int err;
> +
> +	for (int i = 0; i < pdev->num_resources; i++) {
> +		err = ramdax_register_dimm(&pdev->resource[i], bus);
> +		if (err)
> +			goto err_unregister;
> +	}
> +
> +	return 0;
> +
> +err_unregister:
> +	/*
> +	 * FIXME: should we unregister the dimms that were registered
> +	 * successfully
> +	 */
> +	return err;
> +}
> +
> +static int ramdax_probe(struct platform_device *pdev)
> +{
> +	static struct nvdimm_bus_descriptor nd_desc;
> +	struct device *dev = &pdev->dev;
> +	struct nvdimm_bus *nvdimm_bus;
> +	struct device_node *np;
> +	int rc = -ENXIO;
> +
> +	nd_desc.provider_name = "ramdax";
> +	nd_desc.module = THIS_MODULE;
> +	nd_desc.ndctl = ramdax_ctl;
> +	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
> +	if (!nvdimm_bus)
> +		goto err;
> +
> +	np = dev_of_node(&pdev->dev);
> +	if (np)
> +		rc = ramdax_probe_of(pdev, nvdimm_bus, np);
> +	else
> +		rc = walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY_LEGACY,
> +					 IORESOURCE_MEM, 0, -1, nvdimm_bus,
> +					 ramdax_register_dimm);
> +	if (rc)
> +		goto err;
> +
> +	platform_set_drvdata(pdev, nvdimm_bus);
> +
> +	return 0;
> +err:
> +	nvdimm_bus_unregister(nvdimm_bus);
> +	return rc;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id ramdax_of_matches[] = {
> +	{ .compatible = "pmem-region", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ramdax_of_matches);
> +#endif
> +
> +static struct platform_driver ramdax_driver = {
> +	.probe = ramdax_probe,
> +	.remove = ramdax_remove,
> +	.driver = {
> +		.name = "e820_pmem",
> +		.of_match_table = of_match_ptr(ramdax_of_matches),
> +	},
> +};
> +
> +module_platform_driver(ramdax_driver);
> +
> +MODULE_DESCRIPTION("NVDIMM support for e820 type-12 memory and OF pmem-region");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Microsoft Corporation");

