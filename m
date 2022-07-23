Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BADB7E
	for <nvdimm@lists.linux.dev>; Sat, 23 Jul 2022 02:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658545020; x=1690081020;
  h=date:from:to:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=i9E7pO24PTs1xmPOgRB3x4R44lbjXOhwKbqoEOR4c/g=;
  b=JoN13JSnMScpouGWtFMg9tyr90ZI2Txe7qYcxcm9sNBD6Q+igvFPZ0rk
   CfUaMt98vARe10vTklCP8TA3bAjaOuVZa9LSYbdQgf6RwTO7+NYspHB8o
   fHCYCasyHJX2rPquHjGZx7OORk5FJFKEhSobTGZ5OAhP0YXxRKLJq45M+
   P/UHmTL+wHRNaScjkdYL0Gdyvfv1lYumaIhpO1SUFVaqVon9rX1sPiDTv
   xb8idw3MFxBjKPCbLCH//eUTZ7hJDVzfJhK9X1min4zWkAOFA4+vVSZZT
   O96GIlsJuqIToelA4yHJlURKwlPxbpdnxJCeWzM7Td8GJzMdW7BM5Nd8n
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="373745648"
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="373745648"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 19:56:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="602846484"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jul 2022 19:56:58 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 19:56:58 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 19:56:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 19:56:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Jul 2022 19:56:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fua9MS31J8TINVfTou15M9J15qFxBxk3neTzCpYLJfYe0Bu6NkYLg1+j4nHWwXuQr1gSdRW+FU/qGJJPMv7kBRafCMlMYedxpOC0qf9QeWzqmEVvpK7XOC0kwxsnPZUDbpZpAY3Z+By+8beR74n51OHZBuY755ImYocJaGTKGbSUxrUf871EEkvPjSB+nkwxIGZIBrGe9MjyLVZGCQd4eHu7tBk3hxOaQ+07/LOdKAW4F7fW+7mS9aSrohT//Kpt43d0OZWJ5xTbKcjzKIm0+XKZRPiOp151hotyEsAqDreZIiIxRN2XE/VeH6dssfj4Qsj3ksf7GQsxDJkyb6hcqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENp4BskcKvkcr6BtdBmqbce+12HS8AZmQa871VkO8o0=;
 b=NB2w8K8XNvGnha+KRbheH8VhSNyggkP1HzZtkYpfk/zM6oXHxbXglToULsC+0qFhKvw3GZTIoSt4pdLxSLXr7vghdPqDpQKdjXXzyu0qLhE8ismseurdqPLeXXCylOkp9aLEmw2/yr43Z+XzwfC5bi3vA8jnur3ANj2KOm8xBZhtADBsZC97le+T9xRVc6HcoAnSn5OPSPkqZdy75A9bdcQ8PIblNBwYXqOSCIKfubZ1cFdWt0Cqt7GysYuAwkxnFfBebHKcxG07UlsGzWPvuUihKIIiYZXbge3ZrH1th0HokyKxlAMCbXdz8z8rtFLZ1jZpwdCtkkedSLf6p4sQ8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB5422.namprd11.prod.outlook.com
 (2603:10b6:5:399::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sat, 23 Jul
 2022 02:56:55 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5458.019; Sat, 23 Jul
 2022 02:56:55 +0000
Date: Fri, 22 Jul 2022 19:56:52 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Eliot Moss <moss@cs.umass.edu>, <nvdimm@lists.linux.dev>
Subject: Re: Building on Ubuntu; and persistence_domain:cpu_cache
Message-ID: <62db637410e27_1f553629467@dwillia2-xfh.jf.intel.com.notmuch>
References: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
 <62daeef3d20b3_2363782948d@dwillia2-xfh.jf.intel.com.notmuch>
 <650016e6-496b-fa6d-f898-6983a35069a3@cs.umass.edu>
 <fa3532d7-4d0c-2730-9b75-b92f329e1c00@cs.umass.edu>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa3532d7-4d0c-2730-9b75-b92f329e1c00@cs.umass.edu>
X-ClientProxiedBy: BYAPR07CA0038.namprd07.prod.outlook.com
 (2603:10b6:a03:60::15) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8bb7f84-865b-4291-e6e9-08da6c57004b
X-MS-TrafficTypeDiagnostic: DM4PR11MB5422:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96N20HGreURXNKpOjh8/UP1cqiTM7ZDHP7pciXO+ZELT7Vngh+C12qDvRoW//LG0Yne3FVa6o/BpO1B/gbdqhbnhz67wUCd36bCnLUJKQu/vOWlq6WA5YPOngKxEpGuEpzjXsjaeFpGDs2EvNA9or9TrVrX5GQ+QUada4ILz1HPog08AG9bShcKQIcSuQnZzze6c9gKh7kiFWb6/MWEnRqT6J1Y7pPTzl1cioM8/5JkocsMpJZAlhDcWbsvi/vNFsCproKUmkpDNbRPJ8fn7/Z2TVLPfy0nPcVzM60Os9Nu+IEYwpGYvDt6oUB0AZrilXJPWOMxWG17tDuIdcM7EK3ikUahSSd522Z+q2H6mnfxiV3WXOLJNz0r6b/3eXJX/7qHkYJqlp8H0ZSuZMc7Na3F4vmg3N6jxWlNjigp669qWy94w5J63ItfTjSmmxbYquRTy3ao7S/Nvcu2d/qjN6QXt7uwNxMVTmjnlNjSp72x/62AqeKVITLnbY+SBNOTm//ukh/7rEVZ1PTJP9Eh5Ot3wCp+TYSDk04U+t25alIkI8X23/F5ksmqHMZW3oUL0JWlkCo+mePM9IoV9CvTCHNVgmNzh2LkPPQqurvl9yUH5UdpWEDs1SiN5H1j2rlpPZWSO3/5NGQyx6paszMISIm3Pl/8h/jzrFlpK9oSMi+G7nSaF/I9FJU72Gots4zPdOxS0hix1irCi+xeZJ15cRpn5bPB1fpKXgTuAEU7XpGU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39860400002)(366004)(376002)(346002)(478600001)(5660300002)(9686003)(6486002)(86362001)(8936002)(41300700001)(2906002)(26005)(6512007)(53546011)(6506007)(186003)(83380400001)(6666004)(38100700002)(66476007)(8676002)(316002)(66946007)(66556008)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?8zAK0bL7Hs/Mqn0HzDvq8jNyGJx6EcKmPsL9UJRrhqzXGiVtx9CSC2CcAf?=
 =?iso-8859-1?Q?kb4IsuxHmwNNa3+uGa6Nc+71QnNCI9ODk73lNVqnDEOr331fkOYkFmunrd?=
 =?iso-8859-1?Q?unOo7KrsbW772pwNLzBnKJ55YIzLPi1tdTtNtkQIffZNjzzVRwlLb4ZPiJ?=
 =?iso-8859-1?Q?Pk5GS7DUGl26kSohXhMB+UtdZEjjoUdUaqQoPqnBQcXe3nYaW15ehXefi0?=
 =?iso-8859-1?Q?E7kYGJSpkjYbcNJbbSKNyG9zSSh80aHBhTGynt6eEC7q3c981M7RJYr8xU?=
 =?iso-8859-1?Q?pMXAFoUtAgzeu2dcrsqLYWlCW8N63HMODTei1MvpCIUHGMdSTt+zJ70LfJ?=
 =?iso-8859-1?Q?vIeklQMTJVACjjmBnPbqM8ZSN08+2GUxLq1iqxlLuL2s5d8L2MmTsRw/IK?=
 =?iso-8859-1?Q?FZ+9ANOsoNdudHj2TnBArlCIkC/s0yI8OEhCJ7peCOFAG/yJL1v7aZfAnG?=
 =?iso-8859-1?Q?S/Iv1vALGBSqTV7kdcyoV+hRZBwGmvTBZx2dwcaMvpPwUM23/5ioxydDkH?=
 =?iso-8859-1?Q?bhI7IDOIlplMpYGFL30fq3CgcId44ybzC/eTH9vlUcPnVBjWy1sxyRv8Jq?=
 =?iso-8859-1?Q?Jl0tNVNrhRiFJouA6O0Jg4mU0xf+dDCGhr7R1hRlz3kavyppo3YNQBiLX4?=
 =?iso-8859-1?Q?P4RfSQFdA75PpIAVveqz1D2c3ocrBORyGDz8+pbExrFvCF6Ql+8Nkw39AW?=
 =?iso-8859-1?Q?WfGqAKNSOIIDSe/Jp55sFTOcz2mQFN6g8CddKOiih2pxVTedjrB5fmbRB+?=
 =?iso-8859-1?Q?kyPTdw+vWBgacDhaqcobZUAlnPUshhjKfHDXPTbU+2KtkUWZKuyOp5Iiv0?=
 =?iso-8859-1?Q?JE8AqYeBkPilrLgMQ6if1TdgQw11NKfy6hs/64TABPaSWZgXx0UjwGxhK1?=
 =?iso-8859-1?Q?ZTf96ceswTIWNBS2intvcCzAYS91VUMlru5Q5H8GyXkPn5LEQYNFEkjsb6?=
 =?iso-8859-1?Q?NyPtt8IVd40zWGAMS4BHp7VuSOpH/2+AOGKDj8muMqPmaa8t4diOs47rHQ?=
 =?iso-8859-1?Q?cCD3ZdNIvuIbuGvf9IZFKg6j/dCeXkuDes7wQr8dfBTTz4bzCRvzyiK1fh?=
 =?iso-8859-1?Q?iDBx52hTbddT1Gdlte59a0U1czj7dtT3VIuZQyG5JszZDJBIgDoCcr58h9?=
 =?iso-8859-1?Q?NJnUEbUrC4uX7msf5VX03Qprp6vwilJiO7Eq/TsBqEhZvx3RDje+LGEU0c?=
 =?iso-8859-1?Q?pfg4GR09rS+w4G9Qb4m3nk1c/bvb7yaAaUyrPo+llFZyx+NUpDw7L34bg0?=
 =?iso-8859-1?Q?VsSdz25WyBHggt0AgOvYHhmbW258mL1Xqc1WkD8ARQKm1RT2D4jiNxLBYk?=
 =?iso-8859-1?Q?MOsctUop1k9JPbLJoqv8b7Cduone/qpotErsB7KloK4Gi41yveM4VPFh3N?=
 =?iso-8859-1?Q?GHbSn41XuqruGqHQgmpLykA/XefS1zjRVd3vePD5xoTHhzULOTXze8uOcL?=
 =?iso-8859-1?Q?nLeJRkRN8QxmeJ7VhgH38f7e4a0h4db3CFaqkzdyyu63zd6AH1u+ezS6xr?=
 =?iso-8859-1?Q?cHxEkIcHS2/nRQ/D13SLkuHRG6ygGwPvSYNXGgUBrd1WidWpLqVc0N6n9w?=
 =?iso-8859-1?Q?VHffMwWNaSHzdZiKxgiKB+p03RoG3Nftf2+9gs9Usrs6Cj0yzjPfposiDg?=
 =?iso-8859-1?Q?w+bPMOZ6b3/zqNyMgAmfZHBUGSysidVtbJEZnk409eX5jrUkdmCignQg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bb7f84-865b-4291-e6e9-08da6c57004b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2022 02:56:55.2556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LjuLccPaF7B9iGfna5NdEJgI1InoE9v6NTyZ++buzDlOb/+3xizMxcPRJZZ+N6NN9WQyYkfWRR1pQrHdlZgUNOH2tzhNcwHOehxT4ytazSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5422
X-OriginatorOrg: intel.com

Eliot Moss wrote:
> On 7/22/2022 3:08 PM, Eliot Moss wrote:
> > On 7/22/2022 2:39 PM, Dan Williams wrote:
> >> Eliot Moss wrote:
> > 
> >>> What concerns me is that it shows "persistence_domain":"memory_controller"
> >>> when I think it should show the persistence domain as "cpu_cache", since this
> >>> system is supposed to support eADR.
> 
> > Thank you, Dan!  The table in question is, I believe, the NFIT (NVDIMM
> > Firmware Information Table).  I can see a dump of all 488 bytes of it,
> > though I am not certain how to pick it apart.
> 
> A quick followup: I figured out how to parse the table by hand, and sure
> enough, the relevant bit is not set.  So ndctl and friends are doing the
> right thing.  The issue is either that the platform does not have the
> capability we expected or that the NFIT is wrong and not reporting the
> capability that the hardware actually provides.

Glad you got it parsed, for future reference use iasl:

# cp /sys/firmware/acpi/tables/NFIT ./
# iasl -d NFIT

Intel ACPI Component Architecture
ASL+ Optimizing Compiler/Disassembler version 20220331
Copyright (c) 2000 - 2022 Intel Corporation

File appears to be binary: found 190 non-ASCII characters, disassembling
Binary file appears to be a valid ACPI table, disassembling
Input file NFIT, Length 0xE0 (224) bytes
ACPI: NFIT 0x0000000000000000 0000E0 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
Acpi Data Table [NFIT] decoded
Formatted output:  NFIT.dsl - 5355 bytes

# cat NFIT.dsl

/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20220331 (64-bit version)
 * Copyright (c) 2000 - 2022 Intel Corporation
 * 
 * Disassembly of NFIT, Fri Jul 22 19:54:16 2022
 *
 * ACPI Data Table [NFIT]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue (in hex)
 */

[000h 0000   4]                    Signature : "NFIT"    [NVDIMM Firmware Interface Table]
[004h 0004   4]                 Table Length : 000000E0
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : E3
[00Ah 0010   6]                       Oem ID : "BOCHS "
[010h 0016   8]                 Oem Table ID : "BXPC    "
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "BXPC"
[020h 0032   4]        Asl Compiler Revision : 00000001

[024h 0036   4]                     Reserved : 00000000

[028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
[02Ah 0042   2]                       Length : 0038

[02Ch 0044   2]                  Range Index : 0002
[02Eh 0046   2]        Flags (decoded below) : 0003
                   Add/Online Operation Only : 1
                      Proximity Domain Valid : 1
                       Location Cookie Valid : 0
[030h 0048   4]                     Reserved : 00000000
[034h 0052   4]             Proximity Domain : 00000000
[038h 0056  16]             Region Type GUID : 66F0D379-B4F3-4074-AC43-0D3318B78CDB
[048h 0072   8]           Address Range Base : 0000000480000000
[050h 0080   8]         Address Range Length : 0000001FC0000000
[058h 0088   8]         Memory Map Attribute : 0000000000008008
[060h 0096   8]              Location Cookie : 0000000100300001

...
