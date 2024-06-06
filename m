Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D1C646;
	Thu,  6 Jun 2024 00:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717632793; cv=fail; b=RkOvXkj0YnuZVrfNGApLzD9Jxrurx9ZX9PTWbPg00Tb3OzwxZN3JmnAYDsneVZ7lpgGKhQYjaDKRZqHg+pgZQr1jEsDs45W0+VK1+FpWZFNzYhF3/SDOR4f9PImUpFBQ3SoOYhGMYB1LHk436hYblR3uvkgZGRb5H93+Fn96Eno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717632793; c=relaxed/simple;
	bh=TO4sEU+G2shSytztFWQUnZvTfmnjkJBqCRkGP/eUGSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=guyFdFZl96MWSMZjyND5WVfKK1Ar9QiHDpcgHBj6M5r+iYQ9mU2aPiwMQRHIVno2dekAN08TIAEGNMCV+hifJ8oS57qlhmsk7LNpK6bvd8dXOsPJnNQDIF03rjIDAZgBTPt+Mf9p7SLW+616RRTCkgRS9l73weWdGfkCplOG4co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M5gzIYo4; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M5gzIYo4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkhPdRpdkZfu35f6cUWzjtUO79o7UOSgz7DsH9vquJC6QL/88uoU/022j00YzTEt9yPnGrQYE+ckI7y3Ga85LcqZ4jFl8H2bhUuvGa33R00/id+paK5padkVtk5pCPCubGj0LCZpYUJYV3bBVeMdgzpmi7TS5RHaofYWfBWDyy6V+uLsus+hlYTfw4f83mlidKxYljm8d/5TaJh+Ayb1p5zx29hLNqYh+WZhymPmtbD6sQBNaEAlcdTOg4JqcztJk0pyMN+/n2goeMhDD+3p/tNMRHANgCL2cUl7rCyXbEEKwCc8kuvAcLzKv4U/M4ZFYWE9qbIBZUewNGy6fkz6Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TO4sEU+G2shSytztFWQUnZvTfmnjkJBqCRkGP/eUGSQ=;
 b=iW1UrapWQhpVeRAiGivSETh9A8gIfwvtTXo05gVVARfXWnWKCWeSa/xbOLuUCwdRs7WcezTh9KMdxcw/lt9/5RRLrJrQUlLRf29JuDTxSwLBgyEumZCnBqBVJCYgHwWLyOzao+zoFfze7v7r6+m9IY1xk83HqPj6ymgn7RAVrKb6OazGak6vI7Qy1djquQoNB6BNPzopINBiK+y01vdZFE0nYP9jDtH4CA2xCoZjVAbmrR4LjJxOFD3V22huwY1t6TPGnF0bFqO6fgp3IjBqO+MpayyrAxXP8rQZifK4SRjqe4Bq5uWSAZcVzR7urhNohaYPktYhX4ZMbLpPKuj9Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TO4sEU+G2shSytztFWQUnZvTfmnjkJBqCRkGP/eUGSQ=;
 b=M5gzIYo4HyGPC2nujjxtiURY7PZn7bL0JGWKT4f1zzR+pRxfGB3kWsmqziTyb4PKBaDBW3POYhypqS1Wl+HnGP+paOljBki7N8Bwd5GX8PEbh925nqbpmL9umSerRJKFDtuZckV5BrhIZjkz/PT1Xbn0ZnUUNoq2LOt4b7tN3N8vY4NqT2LKSF5PKWYZ3IP1yhcMcccTKi/lyAgTP7jyOva2wXLFuNkT5wUn/tANNPBVHGblf+8qqJqi5gBwKVSeHfrV4GvQacQ7Jf2jZqY6sY9khIq5u2DVfWzrcaYk2aikrgkUFWHUE5p4rW+6+bva040hV4J9gZmdRVQNdmoJYQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH3PR12MB8511.namprd12.prod.outlook.com (2603:10b6:610:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Thu, 6 Jun
 2024 00:13:07 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 00:13:07 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 02/12] block: remove the unused BIP_{CTRL,DISK}_NOCHECK
 flags
Thread-Topic: [PATCH 02/12] block: remove the unused BIP_{CTRL,DISK}_NOCHECK
 flags
Thread-Index: AQHatxHnWta0jYZBdEeGpjA/lqdERrG53nmA
Date: Thu, 6 Jun 2024 00:13:07 +0000
Message-ID: <1f8780c2-3527-4dc5-ab6f-aaf64009de1d@nvidia.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-3-hch@lst.de>
In-Reply-To: <20240605063031.3286655-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH3PR12MB8511:EE_
x-ms-office365-filtering-correlation-id: 28f8cc38-aa62-492c-8216-08dc85bd716a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?dmN2bmFyeVNGNjNpZittUWI1NzBSTGY3Z3NtRUljeXVkMnl0TFRXLzJ0V2dN?=
 =?utf-8?B?QmxXaS9WSHVuZ1JMN1p5ZGUzN3Q4Y0ZUZHZkeVVsZkFjZCs3SzNjcWxUY01q?=
 =?utf-8?B?S1lPdlVWU2s5VldScUNWaVRyb0NTKzRVS2Jwa2cxQ2kvYkJLTGZYcjEzamhp?=
 =?utf-8?B?S3BsMjcrbi9VdElFSjdGeDk5RjVZRTVyK1h0MTlLQk1RNEJJbkJ5ZU9CdWRX?=
 =?utf-8?B?L3FFRTFJT1JMT3VudUlmN2NEbnl5RnNPSlFpSStLdUxqSkVaQVdPOVRSNHBK?=
 =?utf-8?B?dXlZVUFZUEZYOGV5bnBmWUR4RytOSklNVWI5a0ZyU0dGS1RsaUwxOC9SVXdq?=
 =?utf-8?B?Rzl2VmFCc2c5Sk9nRjljSmRvMU5XMW1qQ2VOZ2o2VnpMNzBHYTcyRllsakVT?=
 =?utf-8?B?U1Y3RDlWTUl4Y0FjTG5haytlRkcyQWRjUlNjdmxzSldlUktLNkdUbjVnU0pJ?=
 =?utf-8?B?MDVoaWVPMEQyOVZwVjVjdXpHRFhFU2FqVmR3UHJPQVN1QVpSRjRhelZ5Yjlq?=
 =?utf-8?B?M3pSSjRZVjFaK080ajZIbEkxWlBualNSRE9yNmNWQ2RDT0lsbVZsTnNqYWZG?=
 =?utf-8?B?THFNblFudDFnbW0rSDZPSUlJbUJWa1ZaSU54K0FaVUFzZWVoSVVWNzJSdmRK?=
 =?utf-8?B?cnlCOHRUS2hJRGxtZlhDMDBNNXlBL2FpKzhaTmY3YmlKRkF3VEpCRE9kRUlG?=
 =?utf-8?B?Q2twL21MMUhoanNPM2VQMW5Ray8rcTI1RzdLVDhJV0tiUHVTSVRkTkp0aFZ6?=
 =?utf-8?B?M0pEUFJVL1Ura2xiSm1jZFF6dUFvdTVKTll3OGZrMGtpWlZzcyswZVdUNVcx?=
 =?utf-8?B?MDB3ci8xaDZSbGM2dDBxcy9tVkozVnlaV0lqZmJZWGk4b1JZa2xpeFVPNURG?=
 =?utf-8?B?N3FNL1cvK1VQVW12bHROTDRsS3VMK1cwRmVpRkhPQW1oc2tpSkdCU1ZVZzRa?=
 =?utf-8?B?V0FFL2pQRk8wVWtpaW40N3JLQmJXMlNEUS9rSVF1V1IzNG1IcGFBK1dYRDhD?=
 =?utf-8?B?SUZKRWcvUG90VDBCT21mSTd6bWVRQnpHUzM1ZkNmSXBvM0xpWEI4dy9NR2U1?=
 =?utf-8?B?SHNadGdBTjMxUjJWdnAvbjZ5UEJudTJEWkxJb3R2WVBOeFhnWmtJa2lRcXZw?=
 =?utf-8?B?NlJpNmFjQnh2RjhGSWN1S1Q3K2hPSGZ0LzdydlR3TFBwcWhsZWF1OVQ4bG0w?=
 =?utf-8?B?S0x3TVJCWEFUelUxNXpvVVNRS0VyZlRhbXF6YmczMGVPK2RzWEU2bktuU29p?=
 =?utf-8?B?STFiYXNQOVlwRFltQkVhYXhOa3V5OHlNbnpzYjY2N3NSdUtHTTB2dTRmNmUz?=
 =?utf-8?B?di9RUlBadyt1Mlo5anlRY0lCVWZWTUdGUGNlNy83SEllVW04a3QwT2Q1dEs1?=
 =?utf-8?B?T1dkclBCRWtJVGVhdnhLaWkwYWFTU1JiRzJLWjJLVFl0dXZ3bWFjbk10dlh3?=
 =?utf-8?B?RTRaK0tFTEJrQk56cXM3VXhKNUF1TmxTRFAyTnRvN0dxMHpTRGkxQXI1ekFv?=
 =?utf-8?B?VmxSVSs4UWkxZ1ZpMElNejVvUWRmSjhLYnJsRUhMZ2pqU1pBNHNpNUtaaFNK?=
 =?utf-8?B?Z21CazRoM085bk1LUjBJZ2JIR3kxS0Q4T2h2TCtVbDdZMlM4eDN5L2FEYStY?=
 =?utf-8?B?cCtoM21wZVgrTE1xVXNiWHA5Y1lSRE9sbGF2T2VIV2hVR0tKeDlaUDNlYUFj?=
 =?utf-8?B?dnd0TWsrZldrOXNZc0RRVzZDcXEwdHZCTm16bDdQWVY0RzMxMlJLVmFqbG5V?=
 =?utf-8?B?MHZZVkpHSGpJYWZyY2dSdGt4b3ZuQWRrVjhIWXZIYTN5U1RudXZXMEp4V0JP?=
 =?utf-8?Q?iDcyeov4SvuH64u31BPcZAqW0/NB2quL6766I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aThpSHB2Smw4TmNnNnl3V2ZPRmM2SHFsc0VMV3VTV0YwWXBldGFCdndoOWM0?=
 =?utf-8?B?bi9uMnJUS3dVVUtXRExqYkhqVU51eG10RnBrbEFQT3ZjaDJvbWRvMzEyYVRu?=
 =?utf-8?B?QS9YTFdNQ0pqWG56S1E3UnJaQ1FNMDIyd0EyQmhZMFVaWDZyc2pXQktxcDBu?=
 =?utf-8?B?K2N0bkNzeUNSWDNvRmpDdXN1dDVQMTAxVXI1LzQyMjFETmJqdHpxR1R6eGZn?=
 =?utf-8?B?Vm4yTzdzWUFsdm1ZaVFQOXhYR3FzeU5sSVJ5U2c5OXBldVRrT0ZIUzJYTEw2?=
 =?utf-8?B?SVREbWx4UW5EMmdmNzFIdW9IaVc5U0hEVXJNTjhVRngxb0tYdGl2MDVTVUZl?=
 =?utf-8?B?aTAwcDBSUERmeWhtbkNuODJUVTNyNm9YRk4rQjFMK0pwODl3S3NHNVREN1hH?=
 =?utf-8?B?N0hOZUZEZEZIQm4wMHhaTXRjVjA2cnpBcVVUQkVHb2JKSmZCRS93OW1EWDIx?=
 =?utf-8?B?b0x0VzQ2SGNTdUI0d0g5RGFmclZ2aEgvQVlyTU1MMDlteE1GYjVkT3d6b2ZO?=
 =?utf-8?B?RFJPd2d0YzZhVzIrM2VwNHRKa2wwT3BXY2N6TWJYbmt5alZlR0hZNnB4SFdN?=
 =?utf-8?B?RFdBNFNrdjl2S0hIVGUyL08vR0h3TmJGcW10MkRkU3A2WGFsakN1YXdnTnJH?=
 =?utf-8?B?SEVzbUx4QSsxbnFIcC9UeVpDaXdJR05qdkRVQ2tiZU9wQU90UmZnV3ptdS9X?=
 =?utf-8?B?VlZxVHpjOUtBZ3dXMjN1RkN5MVdvNnhPQytOQ29UMjd4RHAwVzJTajlZTkxB?=
 =?utf-8?B?dk5aU2VNb3NjQk5kSDlscU56Tk5MUE0vRGhpUXRQNHZoekdqWkk5clEvcmc4?=
 =?utf-8?B?TVRGQllraWZya2lyZ252SFBHdWZhQ0ExTXAzT0VCa3IrMTJPWktmelArdHNU?=
 =?utf-8?B?d0I1Q09WekxrbjJQUFFJMVRpNGxYU01OWGp5ZWNTYitiUDdsMnMzUzNNakR2?=
 =?utf-8?B?U0pWeUt4Skd4ZmNQcThDL0U5M3NBRTIxOEZsSTZOT05GaXplTHBMWHQrNjh0?=
 =?utf-8?B?WkFraUk1dStvRlZqdi9RcnZyTTNwRTBSN3UydDhQZ3QyajdoOWxPWXp2YU55?=
 =?utf-8?B?cVQvQUZvTjdMbnVNSHFxMVlacTFrb1hjbXF3Q01zUzg2SE1lRml1QTZBNFVw?=
 =?utf-8?B?Mm0vTXNjeTFlbFFZNnVEYjNHbThVVlFPNXpkUHNiM0VlNEdzbUdMQnBrVzZk?=
 =?utf-8?B?KytJdDVqbU1OOHBoTWFmcjNCZmoyVSs2bisxdHh6RWd4Z2tZdTAzSEdKeStJ?=
 =?utf-8?B?WHpYRFRQSisxZHMycjdaY0ZUVTdOZXFmVE9HQlVJUUxxNnNocm5CbXlDaWVl?=
 =?utf-8?B?UjllNDNSMmNRMy9qWXQ1d0t1UHl2N3N0Y28rZ01OcUNZaGZ4RHl1ZW5qRnh1?=
 =?utf-8?B?cHp5WUV1S1hwSFJpUUZMK0FDMEpmSVJqZ0FJNHhtaEpjamhSUXBzNzRZTE5r?=
 =?utf-8?B?OENnOSsrTmphaENLVFZYNjBkU28rNFRCMWF1em10enhwUmNFeU4yS0tXeHhk?=
 =?utf-8?B?QjJ5S2ZrRldNNmJrSXNSR29RT0Z1RGlMNmlFNDFwQllEajhvTEVVTVFES0Y5?=
 =?utf-8?B?V3pQWGFZWmJvTXAweHFJMElyVVBPSHAwMEpCcEljZXNpRTREVDk2dEFIdyth?=
 =?utf-8?B?cGxrcERpUnIycFYyeCtiTmZ6NWF3cmRFNDY2aG1yRGZOOTIzNkpibUtLMy83?=
 =?utf-8?B?amc0ZWdmM215VU9vbUhGOXFUOFp5VEMzdEcxTGZxY0xSUndUMk4yTW90T3ky?=
 =?utf-8?B?K0syVk9tckRJYzRLcHdiUFcvNjFPOWE4eHA2NEt5cS83cVhHRVg3N3MwMmlG?=
 =?utf-8?B?czhpQ3diVjd4OWlKOWs1L0s0bEV1MXRsQi9xOS9sVENoQjZjWlo5a2krZEZ0?=
 =?utf-8?B?dmZFTWZGR0E1alREN2ZUQTUrOXpmZVI2SVpjZkxGaWlhalJoWHkrOURDT281?=
 =?utf-8?B?b3JtK1RLSEJQeHFBbkFwVGZyK3FHR3ZJTzVDR09mTW1IbU1PYkk2d1daNEN3?=
 =?utf-8?B?UnZNNjVjS0hTbjFQTnVKY3k0elQ2eFp0QVZNSllodjdKTlhxdlRSQTNsK3FU?=
 =?utf-8?B?ZjZ3bWlSSXhsRkE5QzA3ZGRkaEJDQnR0UVI3UFViY1JXS0x4Wk1vcWJiUDBH?=
 =?utf-8?B?L1pvNFpBcTg4bW43bzJ6aUpYaEVLTUpzMmlQclZDRVZmZlM5QjY1NDFGM1F5?=
 =?utf-8?Q?JLqSAV7Xos7HcgrFgfuKYcaR/eqxnF8ERVsrMQnidZ0W?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C07C1BC39B93064EAD12FE156B9C8D86@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f8cc38-aa62-492c-8216-08dc85bd716a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 00:13:07.6562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wzQlt8TOut3DqUw9GCNtOq1V+ltYdSyIXdKRK0FkGh/wDyFmPiHWTcpwoP5Ytym18Jn0RAXkeCkx6JjlwtNC8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8511

T24gNi80LzIwMjQgMTE6MjggUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBCb3RoIGZs
YWdzIGFyZSBvbmx5IGNoZWNrZWQsIGJ1dCBuZXZlciBzZXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RvcGggSGVsbHdpZzxoY2hAbHN0LmRlPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdl
ZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
