Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C3518EFD4
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584742; cv=fail; b=B+H8JxjM3phy0cRjFku7RXEHBXovY+zpkwodTs3YNYDufXOr5xk7QtARJ1a4RcRzgtsPG7oIZHKUyJ0a5fTFTWKyUx+Wiqke6tfyu9XtweP10Vsf5o3v54ywvSe+4XWyNac6Yx1ZdqSFFIzPMnROeyJbN517u0IxVf6qLZl+G1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584742; c=relaxed/simple;
	bh=I3WlmoctCRsRu608KNgUHS/YZw7T8Cy+O3uuocH4P6Q=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=NnqQuJ7ydOisBTGU1qKl68ZPb8JsFJMn0w7wnjplyf9DaxIiJUhxRNfZRqln1yjnFVXcDH7kb5GGOVfZA7Q5hUl+cghA99dJRgrsAa4wIXAf1kmQGzZixcjaOfoGaTPqFrUlIPCOX/1CQrw+4xjbZFMGp/m4WVgkkRXmQDDi80o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mJwfMipa; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mJwfMipa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584740; x=1776120740;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=I3WlmoctCRsRu608KNgUHS/YZw7T8Cy+O3uuocH4P6Q=;
  b=mJwfMipa3q7jw13GcS53teSkrfjrMzG1PLBEmWJiexMlcvwsPtSXIS4J
   eRGDZYOv9VkmWV899WikAyP5cEqH/gJUWJSPddflPDQ4J1xNuvVkekXUa
   yChvGwjuTzx8JXITaj+56XsJlgfETq/9Y6FLeUaQN96VHXuFOmOZULwVu
   eQsArnFrP/djPP9MPyU5j9OciGXPFrVYyOHw/1mUV2NKKGEOZQJE0zmPS
   AhwbYCPQwKxvdhyXRih/GHd0CrU5cO5ppcM0MJvp5yaIYgkxFOB314wKF
   6WTdnuoQp6L4lxsb9KQBLA3UTuIaOG71BHLev2iFSDo+VD1wbsg0ScBNz
   A==;
X-CSE-ConnectionGUID: HNaoJMSyQ0OjufisRobgdg==
X-CSE-MsgGUID: O5cGHQPYTtOnarSPN7EYHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431128"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431128"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:19 -0700
X-CSE-ConnectionGUID: cJFQ5mnFREyj02i9NpsGVQ==
X-CSE-MsgGUID: AGMRhiOMTUe88Ic8DWwUOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405567"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpxlzGU5IcG9PLvzOTvNoBqP1EJwYuxViYM5NXhZ2xvTKM+Kujfp5DOoP2Wt/vvIdSYjWSemoBM1xvkU3y5oAsTgxaikjanDp7UQkq2wjNoZauGNgK0xh8jr4royjaHBcaUPCj7aZUjlfOPFyKeTOvIFiZcGbVhpiU156VPLH58tjvi9jVST6i8uwLP4sJKKNeeI2zmBnMjjJ9ACaEt6FHf2mj4qNC+SwMdn9rfLUwLq9kJXfJSwjcRR2vUANnvX9DvM60Rz6F8ItM+iXsn9vB1SG901312qUX+a6b+D3hlULQfi2ryrqgSQzy/fEuw65Ud/xfsNX4h1jr1/TAHJ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jyAR64KNiC3ycVI/tr64P83Q9uWSXaiB1fBj4L9rC4k=;
 b=rfxKIEBQeDGGtNpslYzRX8FEuC1Ukp8QvG1wsYyzRidfqn6SBImBGvc2zMdzeDg6wcXxMLrvpcZV+Nf7EYXcXweoh7EAaeGqjd7TbDczey/cdaL30020JZgdysj7dcwhbbIDoR1DxkYC2pVgDP/AqMfedhRU/BiT67kdZ3d6rRU2zcgCGuTCTlniVSZzbgkXk8ch3YcdB05I1of04xw2avXSYsON3o2m632wDh/GgmcnmtmSKCJVW/wIBo1X3l2bRL168wKcnWagHuwK2eXt3+g+J1OLmJH7Hh+M8s8TzhzzZ4T2d/m04yyfEd1sreXH10ndQuOGpO8oYLlRs1BOEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:05 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:05 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:22 -0500
Subject: [PATCH v9 14/19] dax/bus: Factor out dev dax resize logic
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-14-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=8758;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=I3WlmoctCRsRu608KNgUHS/YZw7T8Cy+O3uuocH4P6Q=;
 b=SZlCPR6IP2f3V11QT1z1FurtF22u7DLngSx2eSok0vdhz6XAvsfvGjBYrZJyn92y5KcIVMN9C
 nOQz0m2c+e8CivFJGOP3HPXBytKHHFfFZFUrKgMA+bdddXtBILVoFNJ
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: b7297b40-7696-4093-ef03-08dd7addd014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VDc2amRVNG16Yk00bUw5Ynp0MGhWdTFCbDFpR1h6ZitKQzVoMUlydTE2U2xH?=
 =?utf-8?B?ZE9qa0NXM1dxN1hCV3UrclJUYVBia2NHRXhyMFpGWXB6Z0RNSUljcGtxL2Na?=
 =?utf-8?B?ak5oUGMzQVVwenVwT1I0MWVIdXN3aFZheWZpQXlyc0FTTENHQytFWFFDbWsv?=
 =?utf-8?B?cEI5S3JnVkE1SEZRRWhVTUZoNk9iMnJqRlMvQUNhOGEvMHJzeVptaVJ5WXJB?=
 =?utf-8?B?eFByUzF5MXhQR2tLRlhiWTlFT3cvclJmeXRTQnpkdklmVVEwOVlEYUUyeGRQ?=
 =?utf-8?B?SlYyaGdDVnZvcHZWdXBxeGgzYzNZQytRZTJNa1dXdjRTSjdwc2RvTVBjRE0y?=
 =?utf-8?B?bnIzVmE2SUFaMmdhWExCREZlQXlxWXY4MjE1SHNjdEEwbmtCQkpBTFY0UTdo?=
 =?utf-8?B?dTNmdHRSSnFOVjI3emN3Mmx6S1NhQXNQTHk1MEdaMDNFemxjQ2RVZDdvZlpH?=
 =?utf-8?B?YjBNSVNlVVRHenBnOVlLTUVHRkhBU3duZjZ4NEFQelVhSVR0MXZQS3lTYjc1?=
 =?utf-8?B?WnczcnA3RUdoN0ExNzFhUy9OVW51U3FHbWdldmJRWkZXOWozK2lTMHlxb0N5?=
 =?utf-8?B?YjdpbTFWT1diSlFYOVBobVlkNkdiMjVBSkdqNDFVd2FkR3BtSXRwUjhvRnZk?=
 =?utf-8?B?MmRVNzMrblAzTStsdFhGNXA1Nm1YQ0YvNGJqRlRFZnhzR0xEcG40SmVkdGl5?=
 =?utf-8?B?RnB4WHlTRHd6UnN4MkU0dGdpUlhnUHNyYlNwRXNiT3VVemFtVUhDZnJWNHlv?=
 =?utf-8?B?R3AybUoyZUpZNldYM3VKRVpjQVRtRWJxRDkzVzZDQmNOZnVZMzBYZmFkanlt?=
 =?utf-8?B?UGtzaVR1RUtXRDlwQ2FWQi9Ia3JHU0QreDFiWGhTbS9aeUt0a0tub2lqRTdr?=
 =?utf-8?B?WDcvcTB1YnVwdk9yNzFkZTY5dW9xb3VYcXd6VEdiRHg1amdmSERiYUJBUk5l?=
 =?utf-8?B?N3NJZWI1RDZYeU5TZ3BHMFFOckJsVkpPWlFEQk9tSjFRdDRFOGhlQXNqb1V6?=
 =?utf-8?B?b3VyeVlnZFJPckM0azRqODRmSktsM3k4Zk5Ub25nVUpDZ3p3T2ZwNE9SNjVt?=
 =?utf-8?B?Qi9OVnFRbU9SS1dXa3pIMll2RUJGeG5JRWtGZkUzUDZzT2JFUVJMOTU3L243?=
 =?utf-8?B?MkI5ZjlKZGh1bnd4RzFEZUhDZG5BbWU2NFZheGM5N0lGYTF1aGh3RXV4RlZ5?=
 =?utf-8?B?cWRNVGRlWnpJaUYzb2JjVjlVTlhQMlNmQ2tjcGdDSFRTeXNCc2drb1NWeTNr?=
 =?utf-8?B?L3dKUCtOUTFZWC85d09TaXUzQXE3a3UzakFLdXo1Nk0vSTRnVnFjZndURXVZ?=
 =?utf-8?B?S1I1alB1NkgzNzVBL010c0p0SGhFZ1Nod24wWjErRDRTNkZRcDREcjB5Y25P?=
 =?utf-8?B?UXpJNmY1RDZOV0JBanBoNTJ2VGFxamNhVjN1bVFHbkVta1JNa3NkU0NUNGxx?=
 =?utf-8?B?TnExMWxDQWRyTVZWYWRhUkZHa3p3R1JvQ1huMTFqR2tVTDZWVlZWV2pMWStZ?=
 =?utf-8?B?K1lTekdvZzE2bWIvcW1FL0N3YVluRUpSTnU2WXhTZGljR2tLUnZJUTgzeHVq?=
 =?utf-8?B?SFJFc3pZeHdycmUyWXo1d0NxbTF5QU5CcUtnVFBxMW9QVmdTMnQzelhJd3Mv?=
 =?utf-8?B?TUVPKzFHd1dNcGo3NjZYWWx0Y09CbHlvazJUOFJJTnk3Ty9HQ0syWnVHeUc3?=
 =?utf-8?B?bUpqT0JESElYbTUzaDNPZ1pCVFA2Q0IwNm9ZbW90VVJYZHlWNmVoRUxmZG1M?=
 =?utf-8?B?UWZ3MUNMdVJSbVdyS2hEOTllMDBlT05RcmlyWXkreDFVb2NLU0JVTkl6ei9G?=
 =?utf-8?B?bUVXb2NOc0hrdzV2U0NyWkxsZUxCN25Qc1lTbFZHKzh0NUUvbkdTTENkVUlN?=
 =?utf-8?B?YlVqSTNKOEIxeFM3bDJLS2JvNEZNRlVnSFBmZmdwS2tYOGx0ZGZ1bXJ6eXpZ?=
 =?utf-8?Q?wYWXY1moiiY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVRWb3FJbUw0R1Awa3d2SG5VLzcrcU0rMWplc1FOTkUrWldXamxVUFlUQSsr?=
 =?utf-8?B?TjdiVXdNUlpaQ1grZlpFTzlDVGxRRVV1WnR2YkFnT1VUSlpUMisyVHQ5Znls?=
 =?utf-8?B?TUJaZWRZTHoxcmNJZExTM3NoTjhCTE00bTRSMUxkUXVpTlNHYllsaERGQ2ps?=
 =?utf-8?B?b3h2cjFKSmdaZnU1amxPVjZZWDRFTzRjS3dGdjZUUnl0TEt6ZmRKS0w1TVFu?=
 =?utf-8?B?dzJ5dUFvWkNmQ2VhOCtrVEdhc3hYSC8vK0cyc0xMRnZWa0NkendkT3dDcjhN?=
 =?utf-8?B?K3haRWUzQ3Q1TWVQZXpyUjV2K1NOcUkyOWloenBFRWxkZUxDR2Vmck9ESk5J?=
 =?utf-8?B?N1ArNS92MzV6SlkzYzNOVzNqZ0xrenhZYTBJeDIzRzRmL1RabXdCNGRJNVh0?=
 =?utf-8?B?WXR0RmVuODYzQm1HSC94OTg0RUl3b2VWaGNUMjRNNkE3OExiK3BJOWxCWWlD?=
 =?utf-8?B?NFE5MFVvNWhHVGVBYktDYU9YMFZqSXBZb3N6MmVtSUNtNEo2NWt2MkZGYWFH?=
 =?utf-8?B?OW5OaU5YTVB6TS9BaVVXNkdsWnJWcnBDcEFPZFZSTmx4aVNIdDVGQVJObDBO?=
 =?utf-8?B?RXkwQ01iQ1ZRT3NoVHkvQi9JL2MvVll4Z05vc2NTcGhTa2o0RGFScndJSml4?=
 =?utf-8?B?SEhMV0ZLc1lvVzgxQkdXYXdJUnlSQ2hzb2M5cVVwZ2w0K1FwYW5ISzc1cmE1?=
 =?utf-8?B?UWtYa2hvSHFVT0xSM3o0T2N1VXM4Vlc0YXc2c0U0MisreGRPc05JVmxURUUx?=
 =?utf-8?B?cTdGVUVEL0VNNEhUTXZCdU5IUm9FTnMxazZKMVZKWVFSME5DYlBUQUdYWVBN?=
 =?utf-8?B?dStoSFRvdjdLYlZwa2dWb1N5NWZBbkRNcmY1ZDJnTmx2UUwyYTlYRXhRalhR?=
 =?utf-8?B?Zm5yZERNTEVDNXhaTkhSKzlkN0U4OFBIT2tFRVBoWllhNm9hMDd6dEU2RHpO?=
 =?utf-8?B?WUxVZzBCc0NCenl5OG5zaXNmRXdsSzBONTl3WldLTnNlQzRKbWlGZ3p1cUxw?=
 =?utf-8?B?QytGdDZtdzlrSHZFaVRTZXFiUk9TcjZvQkpDdnduY3NBcFBwYTZ1SjcrblYv?=
 =?utf-8?B?TzNpTEE2cjFUeUJNdmxYaEtyMFRQMVNUdzRWU2tvM1ZHOC9QRjVUS0RZZUEr?=
 =?utf-8?B?RTVtNnZ6SWVDQ09aRFUyYUJEbXVHUkFwZC90Q2R3eVF3Tm16L0oyeU8vYnV2?=
 =?utf-8?B?MEJGZS94UnZLQktzeG1vNWsrTXA2dEp0SHRaOWNDaE14NDNxYXB6cWVVbGZu?=
 =?utf-8?B?YktnaTFkSmd2R0d3ZUhwM1pOUHd4Ty9iQVJ3dGkrbm9wVVlrTzRCa0tmQlFV?=
 =?utf-8?B?cG1mbWdNYlVyWG4xWFZMMXM5dXVEcUh5ZlQ3MHJRUXlWS045Y3FCUjRuQzF3?=
 =?utf-8?B?M2FVTmZmSUx6SDVOc1oxRWFPd0Qrc1NURnF0cVRqMGJIdG5RUEZRTWpzNXYv?=
 =?utf-8?B?ay83Q3lUM2FxOHZzdFBrM0ZNcnBTM0FLYjZZWjN4NHlrTjRJQ0lqY0MrakJF?=
 =?utf-8?B?ZEs3bW96ZXg4N1E3TUhPeGxaaTU5QTdEazhNS2RWVDJxUkkyR1FqSzlycUhT?=
 =?utf-8?B?WWVpbCtBZVRtRnRrZDFlaVhQOVNhbzZHdHpnVTVYZ0drNWR4TGFhY3NxZXhU?=
 =?utf-8?B?WkRKMjc3NFdYdzBscFFWdGhtYlFqajg4NGNiNHlhTVhKSWlLZU9XK0RLU2NG?=
 =?utf-8?B?cHFFTTZEQmFWbGFFZ2VRaEp5YlQrMXJSa2pBcjY4UEdSNVA0eXlEMVVkTnJ6?=
 =?utf-8?B?Y04rWno3Z3R5NzFjNFQ4U2VBR1dHbzg2a21NYUlwWlh5RzlCWHFUWVRXWlRr?=
 =?utf-8?B?SXNIL0x6dHJTMVMySWlZQkFMWkozK0N3bHZJUFRBSDZrakUyTXp0NlNGWnRH?=
 =?utf-8?B?eGQyUFZ2ZmZsUkJweWRUcmFpSGgwTTJ1R3h6WVlQa2dhZGNyb0NQRnV1MU9C?=
 =?utf-8?B?N1E2bS9lNXc1ZDVMSDZLSWNQUFd4clNiSitVVVBpY1BKbFlDTmp0TW5hLzlO?=
 =?utf-8?B?OFJmdS9wMTVjbHdpd2h2MWdPMkhuMG5TNTh2WG4zc1Q5Vk9sYlUxeVJpS3pH?=
 =?utf-8?B?UkRLaThvUGpTSFZpTVk0NjZqdUdwOEk0bWdaZWVLcURxTW9EWEtLaWxJcVdz?=
 =?utf-8?Q?/Tic0GqFiH7bPrC9ZbPbeKT2X?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7297b40-7696-4093-ef03-08dd7addd014
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:05.6382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0L1WF7ygDjoN7/gEPVm5cu6/8fIlUS5s8umbZDKjdGk/SLNbMjaYuHtMIviomwCEnSR59SKuTI3IhGTIHJeog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

Dynamic Capacity regions must limit dev dax resources to those areas
which have extents backing real memory.  Such DAX regions are dubbed
'sparse' regions.  In order to manage where memory is available four
alternatives were considered:

1) Create a single region resource child on region creation which
   reserves the entire region.  Then as extents are added punch holes in
   this reservation.  This requires new resource manipulation to punch
   the holes and still requires an additional iteration over the extent
   areas which may already have existing dev dax resources used.

2) Maintain an ordered xarray of extents which can be queried while
   processing the resize logic.  The issue is that existing region->res
   children may artificially limit the allocation size sent to
   alloc_dev_dax_range().  IE the resource children can't be directly
   used in the resize logic to find where space in the region is.  This
   also poses a problem of managing the available size in 2 places.

3) Maintain a separate resource tree with extents.  This option is the
   same as 2) but with the different data structure.  Most ideally there
   should be a unified representation of the resource tree not two places
   to look for space.

4) Create region resource children for each extent.  Manage the dax dev
   resize logic in the same way as before but use a region child
   (extent) resource as the parents to find space within each extent.

Option 4 can leverage the existing resize algorithm to find space within
the extents.  It manages the available space in a singular resource tree
which is less complicated for finding space.

In preparation for this change, factor out the dev_dax_resize logic.
For static regions use dax_region->res as the parent to find space for
the dax ranges.  Future patches will use the same algorithm with
individual extent resources as the parent.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/dax/bus.c | 130 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 80 insertions(+), 50 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index d8cb5195a227..c25942a3d125 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -844,11 +844,9 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	return 0;
 }
 
-static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
-		resource_size_t size)
+static int alloc_dev_dax_range(struct resource *parent, struct dev_dax *dev_dax,
+			       u64 start, resource_size_t size)
 {
-	struct dax_region *dax_region = dev_dax->region;
-	struct resource *res = &dax_region->res;
 	struct device *dev = &dev_dax->dev;
 	struct dev_dax_range *ranges;
 	unsigned long pgoff = 0;
@@ -866,14 +864,14 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 		return 0;
 	}
 
-	alloc = __request_region(res, start, size, dev_name(dev), 0);
+	alloc = __request_region(parent, start, size, dev_name(dev), 0);
 	if (!alloc)
 		return -ENOMEM;
 
 	ranges = krealloc(dev_dax->ranges, sizeof(*ranges)
 			* (dev_dax->nr_range + 1), GFP_KERNEL);
 	if (!ranges) {
-		__release_region(res, alloc->start, resource_size(alloc));
+		__release_region(parent, alloc->start, resource_size(alloc));
 		return -ENOMEM;
 	}
 
@@ -1026,50 +1024,45 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
 	return true;
 }
 
-static ssize_t dev_dax_resize(struct dax_region *dax_region,
-		struct dev_dax *dev_dax, resource_size_t size)
+/**
+ * dev_dax_resize_static - Expand the device into the unused portion of the
+ * region. This may involve adjusting the end of an existing resource, or
+ * allocating a new resource.
+ *
+ * @parent: parent resource to allocate this range in
+ * @dev_dax: DAX device to be expanded
+ * @to_alloc: amount of space to alloc; must be <= space available in @parent
+ *
+ * Return the amount of space allocated or -ERRNO on failure
+ */
+static ssize_t dev_dax_resize_static(struct resource *parent,
+				     struct dev_dax *dev_dax,
+				     resource_size_t to_alloc)
 {
-	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
-	resource_size_t dev_size = dev_dax_size(dev_dax);
-	struct resource *region_res = &dax_region->res;
-	struct device *dev = &dev_dax->dev;
 	struct resource *res, *first;
-	resource_size_t alloc = 0;
 	int rc;
 
-	if (dev->driver)
-		return -EBUSY;
-	if (size == dev_size)
-		return 0;
-	if (size > dev_size && size - dev_size > avail)
-		return -ENOSPC;
-	if (size < dev_size)
-		return dev_dax_shrink(dev_dax, size);
-
-	to_alloc = size - dev_size;
-	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
-			"resize of %pa misaligned\n", &to_alloc))
-		return -ENXIO;
-
-	/*
-	 * Expand the device into the unused portion of the region. This
-	 * may involve adjusting the end of an existing resource, or
-	 * allocating a new resource.
-	 */
-retry:
-	first = region_res->child;
-	if (!first)
-		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+	first = parent->child;
+	if (!first) {
+		rc = alloc_dev_dax_range(parent, dev_dax,
+					   parent->start, to_alloc);
+		if (rc)
+			return rc;
+		return to_alloc;
+	}
 
-	rc = -ENOSPC;
 	for (res = first; res; res = res->sibling) {
 		struct resource *next = res->sibling;
+		resource_size_t alloc;
 
 		/* space at the beginning of the region */
-		if (res == first && res->start > dax_region->res.start) {
-			alloc = min(res->start - dax_region->res.start, to_alloc);
-			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
-			break;
+		if (res == first && res->start > parent->start) {
+			alloc = min(res->start - parent->start, to_alloc);
+			rc = alloc_dev_dax_range(parent, dev_dax,
+						 parent->start, alloc);
+			if (rc)
+				return rc;
+			return alloc;
 		}
 
 		alloc = 0;
@@ -1078,21 +1071,56 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 			alloc = min(next->start - (res->end + 1), to_alloc);
 
 		/* space at the end of the region */
-		if (!alloc && !next && res->end < region_res->end)
-			alloc = min(region_res->end - res->end, to_alloc);
+		if (!alloc && !next && res->end < parent->end)
+			alloc = min(parent->end - res->end, to_alloc);
 
 		if (!alloc)
 			continue;
 
 		if (adjust_ok(dev_dax, res)) {
 			rc = adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
-			break;
+			if (rc)
+				return rc;
+			return alloc;
 		}
-		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc);
-		break;
+		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc);
+		if (rc)
+			return rc;
+		return alloc;
 	}
-	if (rc)
-		return rc;
+
+	/* available was already calculated and should never be an issue */
+	dev_WARN_ONCE(&dev_dax->dev, 1, "space not found?");
+	return 0;
+}
+
+static ssize_t dev_dax_resize(struct dax_region *dax_region,
+		struct dev_dax *dev_dax, resource_size_t size)
+{
+	resource_size_t avail = dax_region_avail_size(dax_region);
+	resource_size_t dev_size = dev_dax_size(dev_dax);
+	struct device *dev = &dev_dax->dev;
+	resource_size_t to_alloc;
+	resource_size_t alloc;
+
+	if (dev->driver)
+		return -EBUSY;
+	if (size == dev_size)
+		return 0;
+	if (size > dev_size && size - dev_size > avail)
+		return -ENOSPC;
+	if (size < dev_size)
+		return dev_dax_shrink(dev_dax, size);
+
+	to_alloc = size - dev_size;
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
+			"resize of %pa misaligned\n", &to_alloc))
+		return -ENXIO;
+
+retry:
+	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
+	if (alloc <= 0)
+		return alloc;
 	to_alloc -= alloc;
 	if (to_alloc)
 		goto retry;
@@ -1198,7 +1226,8 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 
 	to_alloc = range_len(&r);
 	if (alloc_is_aligned(dev_dax, to_alloc))
-		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+		rc = alloc_dev_dax_range(&dax_region->res, dev_dax, r.start,
+					 to_alloc);
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
@@ -1466,7 +1495,8 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
-	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
+	rc = alloc_dev_dax_range(&dax_region->res, dev_dax, dax_region->res.start,
+				 data->size);
 	if (rc)
 		goto err_range;
 

-- 
2.49.0

