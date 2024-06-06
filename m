Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05906139D;
	Thu,  6 Jun 2024 00:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717632855; cv=fail; b=d+El4WKBEjuWLknwh7wYmUUzKl+OUyXaMoPjFV/f3B9KpzXgioHVWEysjzwl+gki7szI5LnR+ILTVtWzvrWi1RCDK7SWCMuNX6s/QU8rDBtY/taxj9dhH9/NXzlJe2OXFZ8hNrQ8nN6UYvgBS3b6O6OitY6W4MP0MP54EG+TiSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717632855; c=relaxed/simple;
	bh=uA+dCFMaN9qG6a4EM9q0JzwvXTyKxmmKvNQsAcBf8EY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qID9zmrPooiRyFJRtiLQtgmnUFccABVqdgWJOaEyf33MZNVdMRyNS/2CImVtsaa//pZx1SeTRImbH2crUMnPk3xEDrhpGi7TXVJNUXDU22MCdmgvorfWMFt/btWpgkilcmTZ3J/56nIhAe9jKVS1q90eoyPlug0kMR5O/g1yyVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mCWXo6PC; arc=fail smtp.client-ip=40.107.220.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mCWXo6PC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2VYSvXP1bRjELkZs0wqR1LXCRQC7l0q6bTUkQuc0VWXORjcLeSsGaGD+9pVLqd2ZXm5qj5enDxhFNTpGSav6Z3AfRe9AaC+M4w4myEYHMyPv59oIg9yTHcM00eMmmF3AycD44UN1HRvE6bY7DS01OFUXlCn2CSXp2lo6MQ4Hoeh55a00HuItD67qbvImGW53ATDQBjUTDZ6utesmilVutLUPLcSe+wWNVyfkFcMy//aW1D+FnqmZOMvD3bm8Jy/qBbECvOGi1E/xPGnCgjyOHFTYzSTVyf75znlJTBwtpmBDto6HGuDnTVjOuRqqjAvlXH5OD3rnfPlbmHX1t45Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uA+dCFMaN9qG6a4EM9q0JzwvXTyKxmmKvNQsAcBf8EY=;
 b=mtXVtEm5O4Tko/Cnd8qdaiimFttXPV5aD6gBlmjn1lyf7aki8vs5Su7mLAkguWZ/XJSSShYhqQPLAt9mdN4Hfsldd1xNPcVZz+W/O9ElpS3Bv5xppjeTk/bU3JXeEBCG4Mq8BqFsc4uPGnmqqU5JNk+eWWZin0vjtOrO+Z4p2OHloDgDq9czD55gMDSzViaIirc6StfL553+POTbLlVy+qL6TGGZcftBYPDgl0UJQqMCULNQFaGNNIJWdIYyhIfxwxtg4QYDroC9IrP8QVyBGl5ZnSfemzCCC6081xLWguaB6UonR2A6KpSt8savbm1sJIe+LCBV44PngZwMdySqHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uA+dCFMaN9qG6a4EM9q0JzwvXTyKxmmKvNQsAcBf8EY=;
 b=mCWXo6PCn1A1atlRYGA7R/KzKvZUZ2TZB2rzkH088hB+4uNjPCLoIef6x/4PZ/GGEO8p2656dSJabawcevImDPU/hnOZ62OWkICDR4BkqWeBVOuiNic7blGQI1UUPaqeyDzJ0cJFpzFNBujlOp7XcSmJIh84QsfdT9OYhQdaktZxNM3IeBhHIA3Ar7RcQ7Fpt3JhzkeW1WOUCKdjorZMcZRw+INUVvNKgx21UPOvR9UcZMDXG5PEx31H3+z09twtNYL6SfTl2Cv//sNO67zhQdLkRYrRIBc7DS/PwkCUmWAnR4/JhybOqQhqjsjtqp6e692LxK7vRKYFy+4btIOa9A==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH3PR12MB8511.namprd12.prod.outlook.com (2603:10b6:610:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Thu, 6 Jun
 2024 00:14:10 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 00:14:08 +0000
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
Subject: Re: [PATCH 03/12] block: remove the BIP_IP_CHECKSUM flag
Thread-Topic: [PATCH 03/12] block: remove the BIP_IP_CHECKSUM flag
Thread-Index: AQHatxHqUg2q4YuL20meHXDqtO7CVrG53sEA
Date: Thu, 6 Jun 2024 00:14:08 +0000
Message-ID: <d512fa5b-250d-4adc-afa9-dab026aed1e8@nvidia.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-4-hch@lst.de>
In-Reply-To: <20240605063031.3286655-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH3PR12MB8511:EE_
x-ms-office365-filtering-correlation-id: 4d1bc978-e671-44d4-c814-08dc85bd9595
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?UmgzYmM3NzQ4L0tIbkczQzRTWDc1TVI2QlZJRkRLSjZ6bklBa3JDOE5nNCtt?=
 =?utf-8?B?a1dOaUdXQU1kOW16cTQ4M0VuOUtVclhQYTlTRGRScXVuZDJPVDU2amU5NTNu?=
 =?utf-8?B?bnFNK0l2WkZseUlWdk9EaHlPMGRzdXVjUktOZVhkbk9SM3ZoQkVRUWcvaHd3?=
 =?utf-8?B?NGEzbHhuZmJyWEV4OFBwOGgzeFhrZ3ZqdUEwa2xKaGhqNnpWUGZjUDZZd0ZH?=
 =?utf-8?B?blZCeEdGeGNoZ0M2M1N6RVVFSkZCbENnT3dDdlcvMTBZbzlmOVY5ZUtMNFVM?=
 =?utf-8?B?SDA4alp6V1J0bXYySENkeTRuNjZiU3RGWG0xTDN6cC9tMmk3ODA2RTZYSE1Z?=
 =?utf-8?B?djlkTnd2TW5ZVDEvb0l2RUZSZFZWdGg0a082R0NjMFpIalRkTWVxS1VIV1ls?=
 =?utf-8?B?aUp2UHZWVzltZnd4OE45KzNpdm41aWd1QUl2b0s5MTFkNWlNQnY2bnd5S1FF?=
 =?utf-8?B?R2o2VGhYY2E5U1YzaGtyNE13QTRIZGhINW52SjVRR1JLWE1wUFV3V1d3Sy9R?=
 =?utf-8?B?ak1SbmRaaVJPVDZuUXVxNGJmVmZPaTNzY2FTSm1sWnErK0VUUWxKbGhKVnVh?=
 =?utf-8?B?cUtuc0xqazUycnRYQ010UXR4VUpsMUdqaG9PeG53U2RreVlVL2NOdXdnUm9l?=
 =?utf-8?B?WVZLY1Z0OFJSQWJCN2JQQUZ5QWl4SGFFaFc3SG0xVHh4VjBhN1ZzYVY1MTBB?=
 =?utf-8?B?akxPcmNBMWUyN2FYQm10UjJYMEZwVWhXbmZrRS84Qllic2VPdHhMYVRLckFH?=
 =?utf-8?B?emk4ZHhReEFDSFFWTjQ5bmo5MmZYSU1NRzBIbmRGZVFFM0ZoakF1TVBSNWc3?=
 =?utf-8?B?TGdJR0dNa1dKM3lkd3Y0eXllTlBQNjhLYXpnTitjaWJTejNFU1hjeGpYYUY1?=
 =?utf-8?B?d3VETkg3UStUQko2ZHNMTnk2QmM3dUpVMngrYVorV3VOTjFKc0FIT1dSTm5w?=
 =?utf-8?B?R3k5KzZxUVJTVmplNE8zK3NGd3dHTGk4cFgrMDJhRVR3VmJQai90VzlpaUtV?=
 =?utf-8?B?TlJrQ3NDeThheXhlNmRyWXhUNlFSUG9FeFJjbG8wSDNYaVV4c3B2SGpTaEZ4?=
 =?utf-8?B?UThlWlZXNldBQnFndU83enYwdTRwZUp4K0NiQTBrN3hYakFQQlFzdXdzb2tB?=
 =?utf-8?B?M21hMWxKa2t5RTQ5V0sxbXhId1VYY2VmbjFLZDl5VlF1cE92SVZLbEFJbTlV?=
 =?utf-8?B?b1VCUEFrb0xKVDZmT0xsN0N2VndkczAvRVdwS3FYTnkydExSSHI2SDV6ZFgx?=
 =?utf-8?B?RDFZY3JFZGlQSEpxWCt1emlrOUt5NUpJM2VOL0VTUDBvQ2tNTmJXUExzWHFn?=
 =?utf-8?B?MUlveFRmUE1FQjNTTFFTaXNoZDFPNUNSVHpZOGphSDZudlRaOU1KSlpoeDd4?=
 =?utf-8?B?MEkvaFhqMjJDc3NmM2FCSndIMnFLSHhoUlNJTEZiUHRoem1sRnFZZ2JYSVB6?=
 =?utf-8?B?L2FPZmxFVGtlMGJvbFVJTGh0UHRZNDM2ZndZaGg2NzF5NW1LZHJVbGJRV1ht?=
 =?utf-8?B?WVhEWCtYdWNwVG01NTZqckN3dnUvYWRzaEdVZUFKTVFSM0JQa2JYRnF2MW4w?=
 =?utf-8?B?dFJjRDdna3QrTWc4RDh5U3RGNHZ1UFJUZDR0NTlXK0NqckhLTHg5T2k1UkNx?=
 =?utf-8?B?bkkyOFpoOFhjdkpYMER2V0c4L1dzaHFuUkxHNDBjdmtpY2tRdmdOUkNWYWFQ?=
 =?utf-8?B?Wno0MG1TbVdUczNGd2poRXBCRWJOYjNMK1A2cGZDbXBaTFMvQTI5b3BaeUhJ?=
 =?utf-8?B?d0VYbm1QZVhnTmI2c1hNSkVtWWp0NC9kVWlXbWUxaHZoT1pHcmd5eXh1M1pK?=
 =?utf-8?Q?c8aWqLtjD9JiNq6E+4pRY7sajVBmPRAnRdJTc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MHhhTHJlRC9TNHZnYVV3MnNpTzFqekNzZlNUa2VXcnVjUFVXci9GeXZvN0Na?=
 =?utf-8?B?YkYrMWxTcUIvVnh0YUkybEIrdllad0NVd0VjN1dtdzlrYmk5VWkvbzZtTnNB?=
 =?utf-8?B?S2xkaDJHNjZyUXZMRmZTMUpXK3RTQ2FwZnppZkZSaDB5ekkxdzBlS1M3YzZp?=
 =?utf-8?B?ekpqb1lVdk1zK2ZmVVdGbit2YldlelhYam5RcTFTYWFGUGRINEQxRnF1L0RB?=
 =?utf-8?B?cHloYlFUSldaVXZqcWMxTER0bVZ6RG1FSHBNaktHdERMZWZYY3ZiQml0WHZz?=
 =?utf-8?B?YjVzd1RHS0s4aDVqVi9NaVQwRHU4bXJrZFluVG5jalBJUXMvSno4TWpJbjhv?=
 =?utf-8?B?L3FYWjBERy9LYlhuTVFyNjV5V0xtc2tWc2VZeGx0djZrVjBEVXNkZGpDdmtv?=
 =?utf-8?B?RnNtTk1RMFZibHhoNlB5N20xc25ZZVljaW1yN3V4QUExTExzMFQxSkVnU2dj?=
 =?utf-8?B?SXZTNHBJNVlPL0hJVFd6K2t5Tk5zUkc4bUdwTUJ1aWttQzJQbEE1T0tDSnlm?=
 =?utf-8?B?USswUmxOV2RpTFRldDJjbi9vUUZsSmx6a3o5bitZTEtMcmpTMGlOWU52b2tN?=
 =?utf-8?B?bUxCRFpVcGxzbElyVVp3ZENYSXFkS0doclVQZ29PajNENFl0QXFDK2ZqWnBH?=
 =?utf-8?B?ci96NTlleEMvZG1YaHJEVzZFbC8xOUFieENRYnd2VUZiU2hYdVFHQnZlS3dR?=
 =?utf-8?B?REludHd1MmdhNEdnOEovbC8yeDFnTWRNOXJWeHZDOVAxMlVqY2Y4QjgvNmpM?=
 =?utf-8?B?bUMvTFp2b0VXaXlVVU5WRkxVTHpyQzVaVUk2eGJjb2g0R21pUXFtNjN6SEZv?=
 =?utf-8?B?SU1wcmQ3L2lPR3l4NkpDUGRPK2VxTXlvY0dPNjZiSGo5NENML1ZBZ3BpUm1L?=
 =?utf-8?B?b0NEbFB6TzFXazFzZmxhSXJPYXhhM3ZidWhoLzVwY01KamdnWmM4ak5Dcm42?=
 =?utf-8?B?ck1ZOVlUTUNxcktGelhRVTdxUmJCRGdzaGRnUHhTRFRtQUQ0T2lBYXdIUXRz?=
 =?utf-8?B?R1hyKy9SZTBOaEkxdjY1ZlQ4dFBOYkNEeGxseTR2U3FEYU53TUVFZnNIdW5I?=
 =?utf-8?B?V0xYVnRJQkNYZ0J5RGtGeEhIZi9KNUFPc0xFMVM1ZzQ1ZFN3emY3NHNFaXVr?=
 =?utf-8?B?ZDlDdUJMRnpha3ZGekNhTm1xTVJ2OWNETUk3em9meGRheDljL09nMTVNelJM?=
 =?utf-8?B?TU5oV0dXczMrMXIvdjh3RFNzR0hKcEllYVNpTlJxQ0xlUWZuODJ1R2d5ODUx?=
 =?utf-8?B?YUlySlk1RDZNK0tacFdPNThGYUpmMHFKM3oveisrMXlnc0ZLRWRGVExGNEc0?=
 =?utf-8?B?T3pSYWNvd2dPT1owRzkyQVZRTkVmSjkyMzFnRzkySzM3NFJXeGJBWkM2WVMx?=
 =?utf-8?B?bnNlaSsyR2xBQlc1T0F1VEJYM2ZuaEZYYXBHQWtwc2F2VWRMMmVKYms5Wmdo?=
 =?utf-8?B?TXVDWUl0N2FMRTJNVzBzSlpTZVRDVkFQc0sySW1SMHpuSGhEZHJuL0U1M0Fq?=
 =?utf-8?B?aU90amVvUjR3YzVCeWNNejhkK3dLVzdBVVdreDZQK3AvVjQvNi9MQlQ4ZlJJ?=
 =?utf-8?B?bEZoeDJiNWdoY252ZDNEeng0SmVSY005eEVjdmVZaU0ra0tJSjRCQmd5M3Bh?=
 =?utf-8?B?V3NmdTJoNVk2STQ1UGcveG9GbHRra1VQV1dZbjJ6RnpwZUlDREV6am85RW1u?=
 =?utf-8?B?MEdjTXVjQVpncVdTQzdwRnVuMmZUK2ZlUkEvZnR2YVhzSkxKdVpXU0FhTnMx?=
 =?utf-8?B?cC9RTWdEbXBNdjdCU1dSemEzcG9yeUlhMy9aNnZaeDlQWSt1ancyT3hyWm1h?=
 =?utf-8?B?VmcxQnRuZ216YStJSXdEQ3VMYlhGd1lhMU1Ha1luNGp3azRhYTdpQ1czbElD?=
 =?utf-8?B?Q2pMNWFMcEl4U202Q1FlQ2VmcXZ3T0FvYjRMNG9MYkJrVlJ2dHN1dHZnbTBy?=
 =?utf-8?B?a2xoYVdaenFGanNOaUJLZHRMb3ZZYjQrVEgvN1NuNStOUDZRc050b1JwcGtW?=
 =?utf-8?B?Vjdva1paWnIzcWlKS3pOcW1SZUMyK21INS8xS29mQWllUU1JZnV5WUlPWUo0?=
 =?utf-8?B?eEhUaGZTNlRRdWxTTHBOVUplYWJLNmE2ZHpnaDBCeDJxR1JtRzBJbmRDeHhR?=
 =?utf-8?B?ZGJSdkRZY0JMSXdqRFo2UDVMSzJOWk9aYjFUNklIU2x0cW04Z0phMnIzMVR0?=
 =?utf-8?Q?B7Kj/uNULN5VC0fTmtaSgqkMV+2/HPRvF24EPPCdq87f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77F511A0B37D8F47B5000B674A894F5F@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1bc978-e671-44d4-c814-08dc85bd9595
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 00:14:08.4202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1i3QevndhXup/5ACOhEoRg3SwOEiRII+QumfG4pp6Af8rOjBlMOg9qux9Pt2r31IuyUyq0C4VwPfxBrwYWpJVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8511

T24gNi80LzIwMjQgMTE6MjggUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBSZW1vdmUg
dGhlIEJJUF9JUF9DSEVDS1NVTSBhcyBzZCBjYW4ganVzdCBsb29rIGF0IHRoZSBwZXItZGlzaw0K
PiBjaGVja3N1bSB0eXBlIGluc3RlYWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZzxoY2hAbHN0LmRlPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRh
bnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
