Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070CE7581D;
	Mon, 10 Jun 2024 11:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718020168; cv=fail; b=QIQfm4TTlFafJA3i2PH+8jBHmMDKEm6gicIzh6qyGWmp0X5DMAovhCJ6/9V8vMO4C0l+IUqXpixPggsN2wUXs57lKjZYz5nY9HPCAcPOvGChmfTtUKL0NA8u06W5wOhzKbxc65OZlSp+Bu/hfHOK9NYCTf5KktB0wzzfzS4uo54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718020168; c=relaxed/simple;
	bh=imV2J7b3y7W7Ed1LzQ5aPrmuUEdT6DRN0B7XS3HRmqQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IkialnW366J/jQ+49nJzQn7Gp8umcsbYxouRJbXsAtFDG462iWL94j66MnKWmOIXM5u6Wt4q7Izj7VMN5eLl/pwz+O2deuSf7u47qd5+fbvTqT/xrlLbMRZi62jvxVgfNAuH2ZMCkmQDFJwT74v+RHUYrOlD6gK4vE/zv0PpEck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FgQVcS5n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fi2ufbCM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FgQVcS5n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fi2ufbCM"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BOxT016238;
	Mon, 10 Jun 2024 11:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=wcLJ+mgRcsRcDj
	177c56m/mBj/DdzW5UoQbgNrQrJnY=; b=FgQVcS5nVqUDaolYx0VQjb8koC9bVm
	pC4qiKKm4cJXnG5iTHgI/OU8xhJLSoD+mFOC0Nrmpro8jZSdc/iBDaial4UfzC2e
	zVZx7M3WXtwISecdIyAWgKZWTiS97/1adKWoJjnk1DWOXIUdH61MhprJEh5n0+MF
	oY7SaYyCIkeTdLUsp9vvaYY1uaIgabtCLOb7lzP3Xa5xNtUvyR8Fd8K9ZLCGJj37
	7Jt6c9jmKgHvQgwrZSPJFeiQHialP5T9EygMBxhxvVoq5bQ+tDlmIY+1f9ZIMlSf
	r4HZ7qGRRin2ph2KcVB4Vf6whk1RrGjNig104YUtQbh45kmJcwpAFadw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhaj2bss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 11:49:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45ABSdfD020108;
	Mon, 10 Jun 2024 11:49:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync8vnd1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 11:49:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neqBNpugpMNgt36u5tknwwAvQpaaH72rLfW1q5gf1GA6y4dMqAW5f8pyAy4koKV4ykoAVrIk+NWG6vqGeQVd6q2NT1VxlX5fRI5PjcU3ZZX1aLp5urUuLmfS3v0T2XvU392Dz4E7clUPAEZW2YHBadlErO22mx44q0Y3f6l5/gMX6/hxwVGmnvuzJf6rAuMm9YGzC4SfAVOCj0nyf5KmOa1Gy6LgJpRDrFvKu0Y+M1dF9s+l95FWb21EZAGWaiczWZ83Ry1jbM9WHq6D/gwdA/6C+gEMtckYC04LcdGNJWEuKCSsPF28HdSGPr5rMWN3nKCYz3r2WgIAnYT5Tq8UIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcLJ+mgRcsRcDj177c56m/mBj/DdzW5UoQbgNrQrJnY=;
 b=UygWpTKXdwjbQhjjIQ00kK7wAwP1yq8S93IWn9iyLGWiNVx7xLChS6YnA/ZhMlOx8NcbldDhNm7yPIDaDUTqwEfBOPnXFAl8wvUO3/GmmqgkkS/T7plY56CzBSBdQHX2qggBaCsWI4Ns3wby2/wpMPVWd5Fxs8CBv0AiHLZvMtqayI2fmDT8DRb5J8Tpyozg6d7bPekPNKd3VID2k0DrC/fxMHnVAGpEs0qhpMupB9SQL04t8bDPobICTI7BYTvkAeOIlzcwKZxzOlgAAe0sEdfrBtUtlP5xAi8/0E+yJV/5iP4stVbQ9cfdaTfvyJ4NYR9C2FfM+bx8CrSn+bsBAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcLJ+mgRcsRcDj177c56m/mBj/DdzW5UoQbgNrQrJnY=;
 b=fi2ufbCM8+Ejh27UzWZfy+Cvfd88hPcmNLIkqNvRKUCY4r/TkgkV32fT/Y4yB5Zv+ivvxzXGxqvLAAwdynwaq6eyvxrpee7AVAjux5BtdVLnC8j6uZJl6cs/hA7K/kHtK+9rab66jEJa1UZwbnFbikoVQYtAyJ1fw2HPDUChzi8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV8PR10MB7918.namprd10.prod.outlook.com (2603:10b6:408:1f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 11:49:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 11:49:03 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas
 Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Yu Kuai
 <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
        Vishal
 Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira
 Weiny <ira.weiny@intel.com>,
        Keith Busch <kbusch@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 02/11] block: remove the unused BIP_{CTRL,DISK}_NOCHECK
 flags
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240607055912.3586772-3-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 7 Jun 2024 07:58:56 +0200")
Organization: Oracle Corporation
Message-ID: <yq1le3d3ua9.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-3-hch@lst.de>
Date: Mon, 10 Jun 2024 07:48:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:208:32e::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV8PR10MB7918:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ed9c1f4-98d3-420b-9dd8-08dc89434dea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?l7e7eZy5VjlvvHMuvQA91HbaLAXxmmAEfnYNFYv9/Qc8o450u+k30pP0QtIj?=
 =?us-ascii?Q?eS1rPcHxxqxfOtcr1Qhh7vIE4JO8571u7DkZs8+dBFXxe2Sz4VY6A/mCaueF?=
 =?us-ascii?Q?KLJCsy1hUrVpzYs2qmy1KX7qI17ciPKwAhFJUkzl+iwtgR87jeZpHS8nf4MN?=
 =?us-ascii?Q?WQpsg6aKrJhlni21tuEnGbW7wNSddqmvmmIpM6U2Yy3RfX+3FDnbBNJ7EtCR?=
 =?us-ascii?Q?uHLY1Af0Cz0fr2IOfoBfOTKRdfmGz5mUBmiO1tnTGv/gqz46wOvsHkyFaV9L?=
 =?us-ascii?Q?U7MEn3kijxKa2YJMlcdDMBX4ljIuVM8CMYbd9eVIQpZAwxflPkABBil4r4SB?=
 =?us-ascii?Q?5oK8BM6q6YaClwgtlXARJOfi+Vp62LEVHvPY92tBCzyFV8iaMd1g2hzfNk6B?=
 =?us-ascii?Q?Q14eleM25T1lVgB4hj0BCt+c6sGlSBICvT1jjHrgmJklBu2AVj3xBLEU5zM/?=
 =?us-ascii?Q?wlIHmTXPk9ukPinMDibkuVYEx7SnEuKM8x/y4yL8Mxr60mR6l1bUchkE+6L/?=
 =?us-ascii?Q?5w2lMx9wMJEB6y3fp4+cep4CfiS0W5H2oTDX9cj3Q0p7l//iSzv55BcDD859?=
 =?us-ascii?Q?cVvWEJ/4fvTCoVRbzAMcqBHPLyfzxFHnFwpQRzUArE9eD3tf5rsHuOmCJxR9?=
 =?us-ascii?Q?2r3kSi/EoFbutDy9xpYaKdLLnGSmiAisuxCcdbPkcq0L27S1MSVzOe8034jZ?=
 =?us-ascii?Q?vxgcskTOUw0ch6FpCcq8gKNn1sjbUXpRaS2Br/GcSb7rWll2vsuSnkP0BYKz?=
 =?us-ascii?Q?TEg8l+KJXYh7965kQpLbhrDj7o82oeEfpa5chgMcQdDx4QxzRswEasyOS2wv?=
 =?us-ascii?Q?z0ZEamddGwJJOqO3ggLqdvd7mBis625PD7WYbNdXO4uXNFMWbxxdpnGcNSGe?=
 =?us-ascii?Q?Lz4BzU/iPB0LC2fmSTfgFbpaFLuh5geTP3Elj4FQXIv59UDAKRE8M7vHLHNS?=
 =?us-ascii?Q?b5lI7G+u2B48OeUxVPCOfZrQ/xoj5oibeXe3SNRZQUevDw/mK+7AYMGDnDJD?=
 =?us-ascii?Q?G8phah1Y1a9TjeIQbi/Apco7KVzH25W+C1HMeTzpFo8FsEMT4TmSBzbBLjB6?=
 =?us-ascii?Q?UhdlMn8yxntRP1XEe9m/Y1LEI9Ri8VIJtuxPfZ5s1eMbzPY2efyKmMCNowVy?=
 =?us-ascii?Q?mzUMK8rSEe6p+Q6R/WUIF20usrs2/OwduQQo1ivVWeQHMUT30lIgBVu7bo/r?=
 =?us-ascii?Q?tMS8H30EYke5EOtCuqk/b0UxOkE6Ug8Mxw4Vta6qHXxDNYRKJ0odEhCwLZQJ?=
 =?us-ascii?Q?qM7olxx02SR3p02W3iDMsXVD9c94+usNrmBShb7W0TIKpuzW5MxG7ekML4+S?=
 =?us-ascii?Q?PHY=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?x27UO1Czx14YO68z7fJbn9aP6f7HsVOtGxfc+CExOAKXTgEbOUGoP1q02J9h?=
 =?us-ascii?Q?4Bl6CiDONfvIdbiJt48sacZS4HxbInZ1Mztu4GovSLyphGShCmjunJrFT4A3?=
 =?us-ascii?Q?aMf01/6TLduIXdfKpN8XIIZEomVNaGmHYoZU81TDishlXzv6SVZEVwYShECJ?=
 =?us-ascii?Q?evRVeHC6PXj/VrA+SveXjYUodrPOXFSqwGql/98CDNLf2WWl08OhWaNV6E2p?=
 =?us-ascii?Q?KXX3Yjv8+lsMtvCoJgw/eqVSqMyXMSkj7Wq5OjHJLlc03XT+UVNqmRDDQfG9?=
 =?us-ascii?Q?U9ZTKUq9PHc3kEkOWe9u+4Ym7IEXpKV+TqY2izGIRDYDwbpyTxrrebYgAsWz?=
 =?us-ascii?Q?QWUG4QNRWlTGEimw/mbr1yMobFTnwguCtLH5U6WPmEax22VjVwA+rQhdzQO0?=
 =?us-ascii?Q?oz5nTzVdfK5hUAZJdcAOb8aaF61KcNDK9DlRZx9LKF+kN20i/+CzAkLCi9rT?=
 =?us-ascii?Q?RcdoofWI/AZaDrbzjS6k7VRdy1raejBvyRg2sS96E9/+CRfmLS1BlhVc6McY?=
 =?us-ascii?Q?4f9msqcMSW+ugSB2MaNa3zS+6LIUokxGrLX2z/iDMDQJe3ypLs/lapzIoMim?=
 =?us-ascii?Q?Oa9n5qtP2lRwnatj6QpF2EFNh9hvqAgoXVDYTFVYKl9bXrKPwnpCjFcbFjyi?=
 =?us-ascii?Q?lpZFaZ/6C3LD0SImNmw8rmnz20AHnlXQPGpr82d6hFbQ1ujqd/a3JPd8SoLY?=
 =?us-ascii?Q?dctgUvlHMK3h94Bg3WvmuDem6c7h7mJs3prLXd15NhWBSO3BR6/9I6BG0Ouf?=
 =?us-ascii?Q?QP8XlclMACoboB4BNMdfIVm1l/iev1C/PCkuq/WQK31V62crPz2R3gu21A9w?=
 =?us-ascii?Q?4ASrsfgS0CE2LcyyX6ld2xu4kSlIBcYcWrCkFPkBBTo7lgu7nbqoKTFS+KQd?=
 =?us-ascii?Q?mHpGalV36zHQuyaUJWqStftjGIrvd2/5LmCS9ASNYohVW3kdWpqQd9RLFE9I?=
 =?us-ascii?Q?9Asnyp2QnHlTLwZ7My6eJSzTW5CLShThKL1YBbT/Wh1BjatAHzNJv82Zx/nI?=
 =?us-ascii?Q?jDvVD0Luzr0wDUARHuQGCLBpdejcyVhg7Z+XdLEkbt/e0oxRt9cjEkvcovkT?=
 =?us-ascii?Q?v+4S3msze7aLNnjMaLknxRGC+5oPecGRyzzE8MNaT63qCVcjNDZxO5xuWyys?=
 =?us-ascii?Q?JqSfRr/nkkU/Yuzqgc5ExwAQzxjLK71Oce31SPeewAEf8LOn4SR4Bz6BPhF6?=
 =?us-ascii?Q?sycD47b1pJ68lO2mpR7MoK2BWYXTu/7sWUkJBErvgnrSarRMporNUsWVy5zz?=
 =?us-ascii?Q?7OHxvIukF9VDtGFy/OsJqOB8Iv9WbRR17B2xB2KD//TL5u7mGovtk/htrQWi?=
 =?us-ascii?Q?RLsVATLLwAM2x+PDg9OXPb5ZjBYGRs0s0EbDVgx2ZfwugeeKWpj1K3cZZ43x?=
 =?us-ascii?Q?xmizQkLasWV40urHM/L4+K0TuvJcyWU3S5N63k5r3v9y9M0xwK085NwvNXTR?=
 =?us-ascii?Q?P0bZRTLed5ppUlnNrkn9wNHfLs2u6csEhBkXIIsDXjp/t2b7VC5cG738XPli?=
 =?us-ascii?Q?DzTnA9PHU0tsg46UizXmacPSQIyF1ufrDkvX4jmRv6+ZADkaKytDO81A139S?=
 =?us-ascii?Q?LDl01OdeOcn3Ben8Leet6S3qyUWxe9xYz74W4upedTdGKAoDn8elwmXiKE9f?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ReUzTJW0SXVFp/aeno8fMuzKYsIdlVTNOTKh9RoRQo6JR2gsQeO+MqOoHzZxKf/oEjRrEmlW6RNMMXIJnxybD3oGIa6zXgfAXIBIiotP6cZyPoPoizOHK60F3NL1yqOMMwhRQH11Xh1AedmL2uIUwV0TfqnZW+1zrJ2EJyD1tccdo4ocJqzzymkj5KFlDRd0+QuTNXzVx+jichrx12NjklAOvONUsmdL5/Bg44pA0wiHR8oSD6BWgHdi7z/fgs04gRT3IWlvXAO6W4KqFEulVDTVjzz6Zwl+35qVLx2aXWeztCwujMioatcmkV7YYITJpV+fEGk6ox8Mw3T6JcBc4Pp6ntVSqkAvd0SSYQqvijrwLWG9hpx5BwISijl9UG3jCUxaTJ0j1Fmi6WpXbRT0lxH5rR+CLSLF+hWUtcEG7ANS8UEKv7D0T0Nexy8K0fAxVhhoEezG4f8RBAhlZpyH9z7jTVb3chgLJ2GRhotB+KxHNG/QNnvQHGJqoVdZVm1NL87IihZ8bBQwhRAdikIe5Pb32FVrGNnT1J09T8Oknrn2tm56GhIfq6ECqredwkw7AVLmZBSanUVMycpybLU1IYTYfrS2AMPVWHVYbGHlAIM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed9c1f4-98d3-420b-9dd8-08dc89434dea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 11:48:54.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGI93EcYpb87KI5IR4IeFdw6vhZFV7HUANpdvI9FEcKs6MAInAby8YS6Qn1Rm04OGNkjJ7RszPX/MQsxp8ZfQzrAi6lb/LkQfNiVKf7gnEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7918
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100090
X-Proofpoint-GUID: 1qWwNNERss6xstuXKAYykh6IYofZxTyG
X-Proofpoint-ORIG-GUID: 1qWwNNERss6xstuXKAYykh6IYofZxTyG


Christoph,

> Both flags are only checked, but never set.

Sad to see all the DIX1.1 enablement removed when we're this close to
finally having a userland interface plumbed through. I've been working
on porting our test tooling to work on top of Kanchan's and Anuj's
series. The intent is to add the tests to blktests and fio.

Fundamentally, the biggest problem we had with the original
implementation was that the "integrity profile" was static on a per
controller+device basis. The purpose of 1.1 was to make sure that how to
handle integrity metadata was a per-I/O decision with what to check and
how to do it driven by whichever entity attached the PI. As opposed to
being inferred by controllers and targets (through INQUIRY snooping,
etc.).

We can add the flags back as part of the io_uring series but it does
seem like unnecessary churn to remove things in one release only to add
them back in the next (I'm assuming passthrough will be in 6.12).

-- 
Martin K. Petersen	Oracle Linux Engineering
