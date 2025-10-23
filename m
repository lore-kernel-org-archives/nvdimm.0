Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14CC21C16E
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 03:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761191459; cv=fail; b=l2H5n9naNB5pfhEHivK8sKElG54rT2tvBl7G+1ypt916FujJZONeVYSwSh3YEnabpSV9upxxSrfbZF0bvcLV6yQooAsjVQwbQRCsuXsXZW+NL6bPBHahtu8u++1MELj4aA5NE39zvu3Jko4A04MmZKdgxgv4j2WxtoX/hE0IQlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761191459; c=relaxed/simple;
	bh=xQe6Srq9awM7jyDlHNx+FMwGQyd6CuZDSvBonaDYuKM=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=Ba8TpGq5JpHV3OXW/UBiMn/lM289FtL1tChAr2kdRW78Qb16mXYTnob5uO1R714B8q1OrMjIvVkr6h+cOSyBDrLIjMmAfrpBo0DP6nHiFspAamdoh2MZMJOyeF2XDwMRzqh7MpvIDmEmMePcW91dAmoSDXXzeeY/0ytwTLfJbNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNnZTyVK; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNnZTyVK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761191459; x=1792727459;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=xQe6Srq9awM7jyDlHNx+FMwGQyd6CuZDSvBonaDYuKM=;
  b=UNnZTyVKsl+gVUN47vVWrYznR35Du6t86DUMIhJFoV6M6w/gFSGi+AIH
   siXe2nE1fRUVuyvI6b+zW5GenOzyDNt5wiFkCWfNoz0juqY3qJ3gYc9Ys
   6/Y+JrWZ2ODY40/kF9VgVbxvGPgb/tGEmu2agBgmdpKwy0BENfxJyyYl5
   6YmckOnosMe2GEQu1TkjF3l+c3xa9aXK9DxC4DmIvw77dNKZ/qOD18XG2
   EbNpSkniOGIdlphAxFkPymglJYUiRUaYvazS1pK9BrEETZcbbYi7/fSF8
   Z1BjDiMYq5HbuH/BP6Y7AXQFyoDsipagR7euWpvhJgfcDCbx0Bqp5hLkQ
   w==;
X-CSE-ConnectionGUID: gzoEitXVSXikjLT6TZ232A==
X-CSE-MsgGUID: kavI5np+S2mFrx1jqgql0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73640784"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="73640784"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 20:50:58 -0700
X-CSE-ConnectionGUID: vXNedRsEQaW9EcJl7dd3BA==
X-CSE-MsgGUID: M9m2FNZgRsaIYLtL+qQKdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="184819684"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 20:50:57 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 20:50:56 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 20:50:56 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.9) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 20:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zj/9f/JU+sjLvzYOcUulGGliLWlg+tnv5LveDAAPyhHexBm1fohu4GqHInbeMdo7W34NomngHr7soi82k3ZMD4Nc8wnDv32FCQJjBafkf4It0DYd5/kIeYt5bCPVQh7OTw6BYoFORmSt5MW87oIkZ8asOneGjWuTujdlyWdwM1WwOPHA7jVDRKaVxp0QVnBCMRROM9rXxD28PS592XXS5sCbMMSrH4YQy+WXK5x5aIDO/0t2z5gDOzx9StI5smVmoKNhWS+W7ysZf1t8lb+1W7UdzkyRA11Aty5Zz8JpgWrBjju5izEB7RrZzI+8oKzH8JRJn0ZQsIJhYer3DmMWtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQe6Srq9awM7jyDlHNx+FMwGQyd6CuZDSvBonaDYuKM=;
 b=fEtC/jiELjc9eNzOHC/oBoihK9cN+zeBy1BoBGvBLbOTP6s0o20dxlV/2c39VziCird3To/RbgpSLuT24oiiRYKy69Y5WrC5ool7dDgiMCnGtby4OeHlY0GNBQYrEGt6Q7jVXPGUjm48IsLo9CpkqSyN7k0+R0FhLnwo5aLIULBh0FiTdDMQObLcI405Y1n+HwDxGvxsFQV6GgsYiaO2TDOXtaQk5U6L02dmDl2r4Yke3paxSBJ6dqkbPv0bir/VMdeGh7lt48LYBX8tbZ/esdoAcFwho5ylhxJkYEhT2YImKqAbya2dUXVVfMY7zhDzkeUKwurdgM7974LoYeBpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV3PR11MB8601.namprd11.prod.outlook.com (2603:10b6:408:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 03:50:54 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 03:50:54 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 22 Oct 2025 20:50:52 -0700
To: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	<dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<linux-kernel@vger.kernel.org>
Message-ID: <68f9a61ccc6b1_10e9100e5@dwillia2-mobl4.notmuch>
In-Reply-To: <CAAi7L5eY898mdBLsW113c1VNdm9n+1rydT8WLLNJX86n8Q+zHQ@mail.gmail.com>
References: <20251002131900.3252980-1-mclapinski@google.com>
 <68f96adc63d_10e9100fc@dwillia2-mobl4.notmuch>
 <CAAi7L5eY898mdBLsW113c1VNdm9n+1rydT8WLLNJX86n8Q+zHQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR16CA0009.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV3PR11MB8601:EE_
X-MS-Office365-Filtering-Correlation-Id: 50fb8d5f-7c99-44ab-4017-08de11e75de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S2JCcHJ6RCtBcjZCRFpjL0dxVmhrOE13aGZJQzZCa2tLRmJKYTdpc3Mwdzha?=
 =?utf-8?B?ang1RG4rMlRkL1VNSG9pVm51ZEUxNm9IbWRLSzV5QVR0ZXZ5M0lzbnhISUIx?=
 =?utf-8?B?OFNFcDBvSm51Q053d0FzQmxyWDJvU1lCMk1IdC9mS3U0Y2V3OEpuUGJRK2JX?=
 =?utf-8?B?bWQzN2hDemVIK01KWVVSOHdjMGU5aEZneTJycTMwekF3Q1ZESXBwWHJrK2ZZ?=
 =?utf-8?B?UDFWa3lHVkZXU2tVYUFkdkNjRnZ3UFBlVlNscTNwQ0FDa3BQZ3IzU002aDFu?=
 =?utf-8?B?dXlGRmhsaDZacmhPbUxVdHhSSUtOL2pMWWZ6S29iMlZZaXdMV2lYd3lTcm8y?=
 =?utf-8?B?cDZpYVIwL3BiS2M1K3NiLzNLbmhoaERkWW5lWThrT0hFbWN1b0E3eFVvU2Ew?=
 =?utf-8?B?UVB6TTFxTkFZRHFaYUQ4aEEzckFNTFE5OU53bmZhK2R3VW5jMXI4TUUwR1JM?=
 =?utf-8?B?UGRZZ3hJYTN3bmZjZHZzY1lIbEJGUGVnS0I2VHpmSXhnZytWTEtIcHczWlJS?=
 =?utf-8?B?SmVNa21haGkreC8vMHJ1MEdyTGs5REIwZU11bTQvbzFCVHlFazNLMGJYMFQ5?=
 =?utf-8?B?bXVMZG1oNDFhRGh3YXR0UUY4ZHlITC8wOGcvU0llUlh6OGM3MHVSeS9KNm9j?=
 =?utf-8?B?VUVKa0dOM1FleXFQUTRIeFBrZXlkeVo3MEYrTVZpSmtRNGhjSHdabXNqS25v?=
 =?utf-8?B?OUhtbDdTamJVZG5vd2pBeTdSWStaTmNPek1qSTNtYVZEcWkxazdNUGM3akxI?=
 =?utf-8?B?UXMvVitUV0VJOWY3alFJc3NCbDFDTldnY2hsczNFZDBaZXRKMVdRRlJVdHNT?=
 =?utf-8?B?b1BtRmdydEtOdUMyK0Y3bkc3M3RVb1BEQXJPbzQzWGZxMGJHQjJQbncrc1pE?=
 =?utf-8?B?N0svVUZUMkN5RXgveTlkNTY4UkZSTG04VVdkSTZnRXVHNFpVVUlrUHc5cno5?=
 =?utf-8?B?TitWY0Q1S0ZLczFiT3lkcWVaaWU0ZWI3bFpvUHJhSnpSTXZpYW1IOHRqNmJi?=
 =?utf-8?B?emJka0JWTG52SmFVODlzMzVzSjY3U1ovNTA5V1ptTUt2ZlBPMVNHVmNCeTlQ?=
 =?utf-8?B?NTB4RTNCMmJKMHNHUjJENHhtSHlZdGhJRFRldHhHL1B4ajJlUnA4R2QzV3JG?=
 =?utf-8?B?Uk5wSVM2SmhIOWIzSmpxVjM2NHdzRTdmY1B3TGdtNkxkbk4wRC8wZGMxdk5Q?=
 =?utf-8?B?L0tpdnZoQ3BFUGVkQVVEZDUwQTdCcFFtYUZ0L2tUamI0WVB0Nm10UkxNQVg5?=
 =?utf-8?B?SDNKTGFBTnQ0VHpvRUxhaGw1UUhHOWJnWDdzYkdJSWV1SW5SNi9GTXZldVRj?=
 =?utf-8?B?RmJvRU5GWHZlWGg4Si83dDIzclJ1TGRnNDYvNFJIcUZFVEQyVTdHdHREL1NJ?=
 =?utf-8?B?TkpQci9ZUWI0bzQ4b3ZRUDdsbHZsSXFkMTROWkRoS3I0VUp5MnpaSzFmTnlO?=
 =?utf-8?B?clVUb0h2ZGJPTUlJTGdhYWErTmhZRm02TDJzWVBhOVlSUFlsc2xyZFIrTDdN?=
 =?utf-8?B?UnBtdDc4dHU4dnNhYjRhWkp1WkFPWWFneFBXcW1tajlBbitiYVZ4ZGFvekRj?=
 =?utf-8?B?NzFFM3Jmdnp1QTRrSExXUGlvcFZROEtpQStMd0c0TGNvUFQ3UHVOREkvZHdE?=
 =?utf-8?B?MXZRelU3alhqVHVtaEFLV3dJOTJVbmlyU1hXeVluZzV1cUZGMWp6WTByUHJh?=
 =?utf-8?B?VTROY0pYODQ5NktnMmVEeEpnUGN0QmtvN2FhYmxLQ0p0VUNsM3JqYUZMeTF1?=
 =?utf-8?B?SXJPUzQ5R3E4VWI3Ry9WNFkzMmlsYkFDbGpEekZicFZmNGVZS3B1S2RFWUxz?=
 =?utf-8?B?SXJwK2Y5R0dPbVdaK0cwN2lPSFBMRWFWdUhWT1QzQ0FZWHd4S1paQ1BtTlNX?=
 =?utf-8?B?MTNsUW5md3Ava1ZwMUR6dEpwNTdzV2FReFFPZTVMZDlqSHpIZURVQnZGN0FP?=
 =?utf-8?Q?gOKe+g2dHfWBhRNL2J90F+1eP764NhLd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akpoUmJMR1hZN1ByYlVQQzdJc1JQWnc5SmlEZ2FML1p4amZncVB2RUYxdzh3?=
 =?utf-8?B?d1dnLzF3VU93eXhnK3UyOFdvSW9SeEpvako4S2VlTU9ueXNjck1CbWlLQ0Ju?=
 =?utf-8?B?T0VhNzVGdTJDSERMelBDejF1MktOMm5tTWFhZGg5RWhWZVFnM3pDMXNkNU50?=
 =?utf-8?B?aVU1bE81TGZmay8zdElSeVMwZDZaSmFZR0RwNHBmTkJSSS96VVFOSTViUjR2?=
 =?utf-8?B?ZE1sbUZIQnVQNDNpclN4TFVMZkpMQzdGNTBOVk4rTFlieU9QazdhQitXOE1Y?=
 =?utf-8?B?cEtkc2l6RHNWUFFVYVlsRnlxN1UwT1dMb3VFWlVUQm5ZTGxhLzIyMHppc0Fy?=
 =?utf-8?B?bW83UG94VkNRTGtpWFFDb3FwSmJUZWhzaEUrbUh0VWcyN0xidzlSUTVIc3Ra?=
 =?utf-8?B?QVlJc2lraEtmTS9OYUQ0Uk1aUzRtMG4xa2RyMXh4eDFXRG5rRExjWm5NTDZI?=
 =?utf-8?B?YlZnbUN4UFJtYmFJN3hkSmhRM3JrQkdUWURHZWphRTFKQWh4TjdPVDhjUVp6?=
 =?utf-8?B?TVVVaUVVTkp6azhqYWhLMTBOb2wvTXMzbEFmZmErUkVWRkJtUGJHVjRpZXM3?=
 =?utf-8?B?Rm5ENWtsZGN5eGlTY0JMMGZuZ2d4VXdVK2tkeUZkRnRTQUd2Y3JJd1pVODNZ?=
 =?utf-8?B?ZDFCT0t6WnBVdDlSMCtvYUpWVlgxUTNpS3Z2MXJoZEdOQVc3UXJrcDJ0Uk1i?=
 =?utf-8?B?a0dHRG44Tlp4SFZPcGVWcTBoOTRYbHVnMzRmbmZPRW5wZnZrR2JzLzEwL09o?=
 =?utf-8?B?Q2Y0UTdaMjJvZUFLejB2ek9KdGM5cU0yYytnOXFWZ3Y0SHFkS3hDL3JhWWRi?=
 =?utf-8?B?djhDcDZkM2Y2cmtqTHNkMkQwc0FuQUtDRUtnVC9SVU1acTU4VGFOTGNjMzdh?=
 =?utf-8?B?cmpEakxCbjVRbTZWeFdpUmtLTnAxb3Y5VjBlTnlaNXNoeXptRjJWL0RDVFdP?=
 =?utf-8?B?c3pRaXN1VHJZU2tvQ1RnTnBIMnVLVUdJUHhmck5VTEFpTjBsT055bmZMNkdP?=
 =?utf-8?B?SG1YRk5XL2N4U0ZkTmV2YjlvTHhLdjlwakZSRlZMWTg4RlBOMHRKQ3JtSXFO?=
 =?utf-8?B?ditPaXVISXVsUjBlOUhhaUgwdXY1T3owb0ZoR3BoUzFvT2NmeTI3MTZPSUZh?=
 =?utf-8?B?VkJ4NFlQRHpVZGtKWVRMNEJiR0hsWndZWEEybWtrNUFOaytsci9rVUY0K1Jk?=
 =?utf-8?B?endTdXducXdaZi8ybHc2V0FqVmpsM00rTHJoeFdoQzgrTXpxbHMrbzcwZnpT?=
 =?utf-8?B?bVlmRkdXZUR6VHRvMDRCUGVzWUJ4TDdTbU9xMC9ISEZoZGFpalJGWXZaakZT?=
 =?utf-8?B?TzJ1VFVSekRZYXFjYkwzSVFBYk16aS9Ob1JGbDh4ZC9hLzNTNlErWE0rODc3?=
 =?utf-8?B?SEFYbHBhaHJoTFErOXdYSXFtd3R2dTZ6YjNyTnp2aWVWV2JIdWR1aUNFZEI1?=
 =?utf-8?B?QXEzaEVHWHBmUHBiaks2eEtFODNhTllMdklBQTY3ZkxCTy90WFFMckpWMndl?=
 =?utf-8?B?OEdsTTRIcU5mSTAzeWc1Vjg4Tk9wcjMxaWgzWE4yRTZ1cHBJNGVjc0twUW1i?=
 =?utf-8?B?Y2FCanJnU1h2ZkRBSS9qdFRFZ2FnaGJxR25KMmpadW9KU3FwUTVtMnZNdXRW?=
 =?utf-8?B?a2QyYzdJRTRCajdkUTRick1LKzZmZlc2ZFoybGNqSEJvUXJ2R1o3RUVocFN5?=
 =?utf-8?B?SzkvMmM4NzN5V3pVdjdKYlh1bEwyWW41WWtPSUEzS1U1dlp6MkZGMTYrOVRl?=
 =?utf-8?B?UTJUanBFQ1dLYW5HejdoVTFzSkhxdERUVEZoaXJ6ekNDRFpUdk9qclB0N0dk?=
 =?utf-8?B?eWp4Z05jeENhbm9SazYweTErL1JDZy9FS1F1ZlNKRTFQdGs0UDdTbkw5a21V?=
 =?utf-8?B?Zm9JYWhiUWVDYXJlQ29YMGtEazdMcDgreit2MnBvUmlwSmk5TkpOOS9FQlp5?=
 =?utf-8?B?MFRpYnhHdmU1K1Rzb3czK3hnclp6SE5YY0ZJRklmWEMvaU0rQjY1OFBhdnFv?=
 =?utf-8?B?OWc4ZWxGb3JEckQzQVgveXV0TEg2TVhOYXpxZXZDaW9XYkJlSTNEa2llMUJU?=
 =?utf-8?B?VFdrNWNIM3ZvcE1OdkJ2U0FNRzNjdmlQTVZRb3VTUkJNWHlWVG5VTThOMmhh?=
 =?utf-8?B?SmZTWFJnVVZGaFFpbEtQUllpNllIRFNLK1A3Q3Y5d3diamVIYXoxd0J3T1pF?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fb8d5f-7c99-44ab-4017-08de11e75de9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 03:50:54.5696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TzZNJDcSbkteAuqp4A8Z2qjKIB5W3KZ5B8OO0liQVLzYOshUULC7i0Gs+QVqjjbkaopR7TpALQ0PvyD86e+bBbFVWxAawP7GQIk/crBdwbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8601
X-OriginatorOrg: intel.com

Micha=C5=82 C=C5=82api=C5=84ski wrote:
[..]
> > However, I believe that falls back to synchronous probing if the driver
> > is loaded after the device has already arrived. Is that the case you ar=
e
> > hitting?
>=20
> Yes. I use all pmem/devdax modules built into the kernel so loading
> them is in the critical path for kernel boot.
> I use memmap=3D with devdax. So first, the pmem device is created
> asynchronously, which means loading the nd_e820 module is always fast.
> But then, the dax_pmem driver is loaded. If the dax device has not yet
> been created by the async code, then loading this module is also fast.
> But if the dax device has already been created, then attaching it to
> the dax_pmem driver will be synchronous and on the critical boot path.
>=20
> For thousands of dax devices, this increases the boot time by more
> than a second. With the patch it takes ~10ms.
>=20
> > I am ok with this in concept, but if we do this it should be done for
> > all dax drivers, not just dax_pmem.
>=20
> Will do in v2.

Sounds good, include that detail above and I'll ack / poke Ira to pick
it up.=
