Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7BF8C08
	for <nvdimm@lists.linux.dev>; Thu,  3 Aug 2023 03:17:41 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE9tD/H3QI95q9y+++RXAWJ7pfQibnXmDE6Oc/dcJ8kQUAoCmUdlRfnWSwo9mC6tOSVVMNF4qYzbAzrwlzf0pf3rkbapg773u0OFQ/HHGBgXCqRu340Mfeo34YjIxh61xMP4ep5KqzuHGeoouzFsoUJXWnhDGztvt0tMnVWuDhOpGsLpkiDHkOFZQ8e6CfrZQpoSstDuguCkHgjrccafdZe/r2fCU80iV7dc2tfU54hduzKgqGckyQfojoAHZzid07smH9GkTajZZ/WkbsAM9fmTJiHARTktDS2e23iFbRVpEdHd93/ZFycVFtxhQ3uIgnfnqoY3ShmW7pb8XDHGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kX4H+Hrwgywg40T2B31PqUFzOdwawqFgKlc4Ec40zec=;
 b=X7PrOr+RAp/XZgcZzRMyUQH3PlRzIj6vtDoISesZVfYlfgvWa09qLDCz1JYnmah2Eac+eL6NTbG7A70A1sBPt14heLYF37iBK//TSnYf3vMvUXDdzp284kXeijElu7YHlLg+kr0b6Utd+UdKyhyMko9KZy+KbgTbKIg2rRnIf87NmkLCcqJ3YlaYHcmLLTlEbrK0o5bhdbYyceQHn4HKrM/6h+o6LPJ68kHh+UW2OPsFH42UMKJ/jf/DZE5kRV/MuwnGRcJQx205ftd0y88Ae8qc5nlZK+almVwLL6Ct9lIHrbOSqkrwJoQ0msqdMIxHqjSOJttlzWDmyqGCqxwqnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kX4H+Hrwgywg40T2B31PqUFzOdwawqFgKlc4Ec40zec=;
 b=d8wWdLF5Pbq8TLZ8SmcPKbihGaHsxObHJtm4B8XbycWNh9d/Un9dgRB6y25afIg8lu/zI8IfkqypgRVhU7IL7XERTTJjYTZwkOyrmLGb8RYngCzupcGTCeduASV+IuI+8PdsSMW5GaLOIysqHo0xCzDEoWFiN1ZA0VI7E/5fNYgsFgOpvd1xJ3cPJ8x7EB5g5bdaH72KI92h9qy9hOY92Kcgu4RfZSjThAb2cHrcMxSBXcayncCvjXC6ORwbOmU1dNonNTpW1ZLLYT6MK8+ZzJpHRply44K3LQvwkNDQzuyVPegSqkJ4zb2nMt10K64P5P94e3jzblNl1jv1JnTxZQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Thu, 3 Aug
 2023 03:17:38 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664%4]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 03:17:38 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
CC: Jeff Moyer <jmoyer@redhat.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Index:
 AQHZxADrXE+/yvq5u06qlYmjeW0Jd6/Vjqw1gAALsYCAAB0cXoAAgQeAgAC5pQCAAPf0gA==
Date: Thu, 3 Aug 2023 03:17:38 +0000
Message-ID: <a765facc-3991-41b3-6fe7-9fc5ee68e57e@nvidia.com>
References: <20230731224617.8665-1-kch@nvidia.com>
 <20230731224617.8665-2-kch@nvidia.com>
 <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
 <20230801155943.GA13111@lst.de>
 <x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
 <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
 <20230802123010.GB30792@lst.de>
In-Reply-To: <20230802123010.GB30792@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4903:EE_
x-ms-office365-filtering-correlation-id: 9455303f-9ad7-4ca8-2510-08db93d030a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 E+nq9Yx9aPq7DE6EkGRwMgt9BWaaVNIgQpY8Cs8+4LBlo4gvBGD619zrQGZCSbu2uC5xBHzL9+SN08L2Fcb3VdcHA0IacgTu/KFSjm+vzwTrvu+bh0IFfGYfJ6FXfylHC3QndFFXODvxvhk1rbkk+Yrw9fWu9kj7feiPcAvooCC4j+CrBi3v3cAHB/E6bxlsyT7lM9OmwxFgNvzQOpVz6Qq82cVQrZ/qc0GPASaRNG9SkPHMhaZTRCmzZ2apMw8weTG4ckXZBJYoBck+WqCoChH+fJx6xrmTYag9BKxvkCmEUGQ4Nc/1wTYNBbT7f0awlv1n+6r+FqQSSjtIKcK8EPNIzm5YqeFZ67tOHWdTtC7iT7eR+wA6TrTi/+kW6Le/GrMW3UjvUwajy4EIyfwcqr78SB8VUWliqpCjM/0qKfqEfjDNDlCwW43WBEljBYdNqi4Bib4rFfi0JVbhnc7oXzt4e0Eoavkhw8L/rKGUwAiyxvjddxx9HMB9MoKqVlWU0GexBggWKYDP7CEdjHLx+UEA1FowKaZ1H9bPzwuizWAMbobg+6+8FRxmqZ6fXvAjmSPCUBInnzBBj6ztO5RPcoEtitw+Ic3vXi6OUVk9IC2XY4XdrHfnqEjaFg9HcS0zmv9PuKKxSQEMbwEMflfQvqk+LnaI2sOEJvm5VstZQMWAozfxR76SYlsFXxODm9OQ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(2616005)(186003)(6512007)(316002)(86362001)(478600001)(54906003)(122000001)(38100700002)(66556008)(66476007)(91956017)(66446008)(66946007)(6486002)(71200400001)(76116006)(31696002)(4326008)(6916009)(64756008)(53546011)(6506007)(36756003)(41300700001)(26005)(5660300002)(8676002)(8936002)(4744005)(2906002)(38070700005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZXl1eGJCazV3MGRaS0ZINy9tL1ZHME9yZUF2Kzh4L1lOVHREWUZwSjg1N090?=
 =?utf-8?B?SXYxSlV3ZERDVDVqWnZEUitIbHUvY1F5VDY2TGhCczlmWjUycnlmNThDT2R5?=
 =?utf-8?B?V2M0L0tKdVZrRDdQWVMyU0h0ZlJtbzNCMndUam9KL21tQzNBU3Q1YzRPRCtz?=
 =?utf-8?B?K3dWV3V0L0xYRlhzK2t3bXEyb0F4WTRaVGpkT2dOU05VRG9yTmVSZmVTU2RW?=
 =?utf-8?B?QnhuTkNIU0hMVFNJbEQwWXZWQkVtREJSTnltZXFWU0ovRFBpcWZEdGlQNlEy?=
 =?utf-8?B?OGZUSE1oak5sUkN4WUhGRy9HejlQWlNBMktWMURXZ0ZnVVBKb09WQkJpMFNS?=
 =?utf-8?B?ajRmSjRxTDRYU1dpTGY2aGxjbFlUaUhWRGdhNGdlSFhNZ1drckQ5bzhoNnM2?=
 =?utf-8?B?OTJDUHRmcUNnT1RqOGFzeGJISCtIc3NqQWw4TloxdkhqblQrOVpwQVhsTXdM?=
 =?utf-8?B?NzJ1NXFhWkFPY1E5ZmFJVWRpUWxKbjJMMXltS2VmZklxMm1xNldJS2Y0NE9M?=
 =?utf-8?B?OUxLMEdFWGRzQmt6MGFSWEttYmI3aGFOc0V3amhvMHA4TTUvTlk1SERFd2x5?=
 =?utf-8?B?dklzdkMrN3FVYXdXUm41MzVScGxianVYU3dnbGFZbEduOG9yc1UwUU1XSVkv?=
 =?utf-8?B?S3ZDMXNBZDFTNGlvTHBzZUxlKzRWZVBOdVNSUDJVdUtYVnJMVzh5K1lwSDVw?=
 =?utf-8?B?MXR2VysraEZOcjBoczBVZkl2ZUYyTmZaUGNxTWQzMnJQdjBYaGRmdWV1VXpy?=
 =?utf-8?B?THlDcXZaVHplQXpCYWFNa3Vkd3hmRVRoK293WjNxY1JsZHl0VFl2dzlXQlFX?=
 =?utf-8?B?Y2VEcGx6M29LN3FuTmhOM3JTMjZZTndoblBJK2c2SUN3eVhZZEZUalZOMHMx?=
 =?utf-8?B?V0l5ZWJId204c1FDZERLbEdtcDhrTE5QelZoTzdkUmIxSGxGRzZYNjA2QzN5?=
 =?utf-8?B?NHNnSjFwbTdDcHZSTVR3bCtLS2ZOQTJnUWNjMnY0b25jc2oveUhOUWNOalpP?=
 =?utf-8?B?b1RGQzcxT2JldWZnVnZBaFNIRGxOWTRkNWhSN3ZmSnVjWThnMWZIQjJCZXJt?=
 =?utf-8?B?Zm1tUWNKZ2s5MVFkSUN1T3hBNkZrMlN1TC9kNG1tM2pDY25NR1VVRjdxWVdW?=
 =?utf-8?B?bzdWZkcxbnIzSE5hOUgwZ1hTWXkzcVY5TWNqYUMwYklCRm1Zb3pPd2ZVSFFh?=
 =?utf-8?B?ZjNvYUJWU3BzV21jd1Z3MGd1TDVTSHlJWm5NNUtWKzVieER5cU16eGJ4RGFJ?=
 =?utf-8?B?ekJDWXlLRjFqYlNpWEtRKzNONjVmbzBISStIbjBIRU9TZ1dKOGpaQ0JubWFX?=
 =?utf-8?B?cVN2NC8xcWRWTGJkWW1uL2kzN3JDMHU3aVloMHE5VCtOUW5LOUV4MnFMNnVu?=
 =?utf-8?B?ZkZ0OUx3dkdpWENSSUVySjJBTFFIMXNTMGwxWHpBOGFPWjQ5R2RqNU9TcThN?=
 =?utf-8?B?M1p0Z2IvTDZ0WkFLMUVhelBFVkZTSkU3N3JqNDJ2ZlIwby95MVVIaktyVVpv?=
 =?utf-8?B?SEUvU0NaV1RSTVlqKzQzRTVrVDVjZlc1L2pXY0pseHV0Yk5ZSWlHSnpRdUp6?=
 =?utf-8?B?cDlxTDNLUzc2N2VPaEQvODFlMnYxZ0FYZFJaN3lPNnRiZmN0ek40emNld01V?=
 =?utf-8?B?V2lsWGc0YjJVdWR1djRmV01zOElJL1JodWh0NlZqSXNqUmttaHlLaEJRd0Q1?=
 =?utf-8?B?aG9pcHFnSzkxTmNNNTI5b1NDK0JIaDUxbll4Smp4RmVLUmJCK1lTTVRZVjhJ?=
 =?utf-8?B?VGtWL2lndTFsZ0RpeU1xeDRKVFE3TFluNVNkSGRIUFlUNjNjL0lHV3FtSXNC?=
 =?utf-8?B?OUd4amN2QWZpSEdydFF2bXRJWE95elU2SmtZbHRiM25wYkdWdmpBTVNPQWV4?=
 =?utf-8?B?ekpUUThOYzZCMmJ2cVZrVXRYak84Qzd6amFOOEhxZ2NJd0ZTVW9FaE9qd2ls?=
 =?utf-8?B?aFFZTHJNMTZLMUIwVCtGUTdod3J0cjhuYXA1VDF5ZUVCWkN3Y0J2anQ0MXZi?=
 =?utf-8?B?Unk4a0lxS1NhU3VHOHBjRWhuVGNscEl2dXR6bkJzbElQaitRdGV3OVRsZVlG?=
 =?utf-8?B?NEpVcktYSGo3c2p5NlFlT2QwZytsbGhMOUJ1NHFDUmVHTVk1K01mTW1Lb09H?=
 =?utf-8?Q?yaRw/WNFz1E6lEC42XQQ5Rjjd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B261DDC8124A75429E435116E5C34817@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9455303f-9ad7-4ca8-2510-08db93d030a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 03:17:38.1342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZdnTCqJpAscaagQaD0GmFpPK/TJhwYhzZ4pqweQuKAt5yx6eXORzVR19EJDhlhI4o2+YS1UE4QVCL5rnchgFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903

T24gOC8yLzIzIDA1OjMwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gR2l2ZW4gdGhhdCBw
bWVtIHNpbXBseSBsb29wcyBvdmVyIGFuIGFyYml0cmFyaWx5IGxhcmdlIGJpbyBJIHRoaW5rDQo+
IHdlIGFsc28gbmVlZCBhIHRocmVzaG9sZCBmb3Igd2hpY2ggdG8gYWxsb3cgbm93YWl0IEkvTy4g
IFdoaWxlIGl0DQo+IHdvbid0IGJsb2NrIGZvciBnaWFudCBJL09zLCBkb2luZyBhbGwgb2YgdGhl
bSBpbiB0aGUgc3VibWl0dGVyDQo+IGNvbnRleHQgaXNuJ3QgZXhhY3RseSB0aGUgaWRlYSBiZWhp
bmQgdGhlIG5vd2FpdCBJL08uDQo+DQo+IEknbSBub3QgcmVhbGx5IHN1cmUgd2hhdCBhIGdvb2Qg
dGhlc2hvbGQgd291bGQgYmUsIHRob3VnaC4NCj4NCj4gQnR3LCBwbGVhc2UgYWxzbyBhbHdheXMg
YWRkIGxpbnV4LWJsb2NrIHRvIHRoZSBDYyBsaXN0IGZvciBibG9jaw0KPiBkcml2ZXIgcGF0Y2hl
cyB0aGF0IGFyZSBldmVuIHRoZSBzbGlnaHRlc3QgYml0IGFib3V0IHRoZSBibG9jaw0KPiBsYXll
ciBpbnRlcmZhY2UuDQoNCndpbGwgZG8gLi4NCg0KLWNrDQoNCg0K
