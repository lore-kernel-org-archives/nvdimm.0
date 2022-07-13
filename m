Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0611C4681
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657727642; x=1689263642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZUTfELGZlQEf7DUse1lYIZtZPY7X5JCwSjhKQA0Iobg=;
  b=RkgMAnJFeQqPMomeOGAqRCOZuyWedJRR9GX0VoBFaak343cfXIk6VqqO
   oonCdoEcwUse5BkGwOtw4W24cZDclYkNLp9W2CRoEJVLrph9pCMN2/g0F
   mNUhrt21hQCG92WRi+tIhfQTVbh9Ca00ne9McUjW88PctIFFN42n1Vz4E
   w3NNOUe4VrK4j0MIKRVm+4E6HnNuD5YBhjC34zuTM4XDQY80p75XLaKR8
   dmeP1C3ZvM6IkBpKdM/zjmAojZ44YWQipRZQYsrpY5LdTMIkg8Oab2tpb
   YcqxUdLi6Sy5+/IFZ6ieMWeL0A1037NQ8bFczfmKkr1WubJ+hye4Eq54y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="268296452"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="268296452"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP; 13 Jul 2022 08:45:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="722395709"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 13 Jul 2022 08:45:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 08:45:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 08:45:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 08:44:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gf8jco0KyjkVEYQursW92l2G/pY0XgOFPoUDknqhA+giq5lMp//pLEa/tlXfbrs/qLSSrCryW5Z9TSt6wVmH9SJGKBUwdhaArsu6GB8AxDjuFCFcJ3g/Ll/muuDUd9Lkx8oM8Lta9XJTS8zIg/zV0ssu9xKXO2tCwWH99v2hQOq6SwsfCqWSvwri0F3LHicokYsQuF3Cx9sbUcrwhPOopadTkK6LlpEWcRhua/YkE8pF6RERSPvWz7YyHb8wwMJ04L+QbXOw/jQwuwrTv238EgZWUwRH4Ybj43Klcqm5YNkn9oMS/gHXMt30lRkN4/piMK9r5A59unHD8PGgHgT6uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZUTfELGZlQEf7DUse1lYIZtZPY7X5JCwSjhKQA0Iobg=;
 b=iXYgq8AfjOx/3HsClBNFHLo2WZOXTpUIcWlKydb1ZoHLbHGL6xDvo2kbGBMjMdK1XMz6LCDELFDXRqk9XH0Z+buQCBZ3HPi25bsfjkkFhZsB9U6baH1lrpXy3t89LBKi49S86U8BbqX5FINJ7SHkgK/Cop4cbrHCSdH3Lwk1cEzlZolMk5Zn4FZ5cPsprqy+hwvObZkeaY0hoJOPnVM0y2kzyxel20bZXiP4cDzl+OpuEBUkIN0CyQC7t6L4TIhX0yh6A/uQHFYOEkQFxO71t5ckvhkJ4zC5Vaaqy9zPHzzto5tclUyhY1dAR3EnmFwA2tDPk75LnAXUhX4SvSgIqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Wed, 13 Jul
 2022 15:44:36 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 15:44:36 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 09/11] cxl/memdev: Add {reserve,free}-dpa commands
Thread-Topic: [ndctl PATCH 09/11] cxl/memdev: Add {reserve,free}-dpa commands
Thread-Index: AQHYliLC6TspiwknFkmS7FZM5+geRa178jUAgAB6JACAAAZHAA==
Date: Wed, 13 Jul 2022 15:44:35 +0000
Message-ID: <e0e83c8e3a45b432ed1747b0b8442a7a11db8579.camel@intel.com>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
	 <165765289554.435671.7351049564074120659.stgit@dwillia2-xfh>
	 <cac1d3a7a7e6515b2db0ce7ee73db812686d3407.camel@intel.com>
	 <62cee31e25d52_156c65294f1@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <62cee31e25d52_156c65294f1@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee65ad93-9b72-4973-4e0b-08da64e696b0
x-ms-traffictypediagnostic: MWHPR11MB1645:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sjBCvKXwQ70YlwmdCsd6wFkeM2V2htKeyDrgRR1ksIvlDzfIQ3te5eWRZMa30kBSET/5xaLxoph50X0Sbgh+PFMMXU7tSDPcpd87KCCa2MmzxK1Vej13pcTbrxgFFIVDfUwJhWPF2pNEkH66Occh33zi6IxWS8w2fWhUNd0Xhh1od/OfSlbjAAodqfSiiHzy+VIAqsBu/J6AOS9LJ1a4kLka2cFKK44l+4xT9dSmzztF8KgClZgr8tJXdU1eTyYPWWuW7GFmj/jX4QVzaTWJ8IEBiATto6N8bzEJk3429OCIGq1DxrcFKmHGZKyp+hkwZ5Wjydf1bNLAmQZY+TjM48F2GHZTsy15Vjl6v3jB3Vqw7mEOls8wYbf/KiSwJ2wMlRTiaFEBX2DqKPN8kAn4a948iFNkvx/rTCaOW+xrilFKuG0w8aVeA2nCLdkkfyW90Zda/9zIxWCpR2OE6ADMC8w2thWeYY4e0oM/SN8ygNuQaUmgkr5E/VY79zm4FGDEqI18fnJRRtodoRLwlD8814KLWD7ICTbYwyH5h2OsHRvjx4sUmmiRsYXBF4dO5f6VSk4RXVKi/SAW7ugMwbtVITe4vzHrXMXLEosYxZRJX0Jp1ykL47C98pNKlzAITshAD2oZs/GpsXNgEs5pLxAI11Cjzh6jAlZ4AojVWR5ryexlF60ON/biTQnHZKBSbVJxmJ2f0jjHbH9d/dgPGDhzcH+awMAyLqXre0HVeSwWrAj2eWDhghPZlIpqjE01EjTyB36bdTfiFmeqthBVriloGzTb1Dd4QtkhOWFFCzewPyecsppMumSWz/ERKseW+OEw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39860400002)(346002)(396003)(376002)(66476007)(54906003)(26005)(6636002)(64756008)(66446008)(8676002)(37006003)(6512007)(76116006)(66556008)(66946007)(91956017)(4326008)(316002)(122000001)(6506007)(2906002)(82960400001)(36756003)(86362001)(5660300002)(6862004)(2616005)(71200400001)(41300700001)(6486002)(83380400001)(38100700002)(38070700005)(8936002)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEZyWStSSHdlSFdRSWFqMDRpZGRPbUVmQlhnZGtFZEh3WGxPMXRXS1hZa096?=
 =?utf-8?B?QjZpS2tXZTNlNDRINjN4aXBtQkxXaEhSM0JvTENicXVEUmdHYkpIZWUyQnds?=
 =?utf-8?B?cWhKdFdmbTFReUNiTkx6RFo2V0FmQ0Y3eXVvS3U0eXEwb1pNVFZqLzV1dlZh?=
 =?utf-8?B?b1V1UUFTaWU3MzBla3NvaVU3QlJvdUQ2OUlLc3hZMG5XUTl3S2ErejcyK3l2?=
 =?utf-8?B?Q0JhZTlUTW0yYk5JZE9BRS85TjYwKytBZEJheVd5N1E5dW1WNXNGK01Mc2NE?=
 =?utf-8?B?Kzh3M2k4aXE0N1JZUXVkZVFVT1dSeklqcFdPNllzV01HN2k2ZTN0cGpySDF2?=
 =?utf-8?B?UDVBdXFGMTBVVmNVVnpRSmZqNUlCeS8vZnBPMGMzUytDNE5DNTY3MFZKcmd6?=
 =?utf-8?B?dERmMkxsc21OUUFOQ1hrbkZMNjd3UytiUDNaNGhaajBlU3NQVUx3YVAxODVi?=
 =?utf-8?B?OVNiSHFTK2Y1NHJ2UldJbUhUWm4rQUpuWnEycHNyN3RNb2pKTFczQjI3WGdz?=
 =?utf-8?B?ZzBMdFNsYkZiYXliVkNwOGVHQmZreXV4dXMxb1pLQ0hQRGlpZWxZcGgzOHY3?=
 =?utf-8?B?SWliU3E2c2RDVHJmUDNyZmtwY1d1bmZKOUdwZ1FjWVlYVXBGTjZmVUZxRkQ3?=
 =?utf-8?B?RkFEQ1ZydXNJMFhCblgvTTJXN0I3YTV1bTRuUk5mMmdBUmRrZm9qYlFzUnlp?=
 =?utf-8?B?TEVwaEVaUE0zV1BhTHBvOS9NZzI3RGxuazZLT1hSTlFhcE5sN2oranhwN0M3?=
 =?utf-8?B?YUEvcWhuTmxVRFVScHVZODlOMDZESGxKWGJHYzFzZDZvS3Z3QXNldUNUdzRh?=
 =?utf-8?B?cnFiNEQyWjNYa2F0L1k5TUtuUS92cm0vOWdXd1I1K2I5RFBDTTZKdnE3amFn?=
 =?utf-8?B?bUZVYUtXdTNKWWNyd0JXZ1IwZHJORUdPTkw5bUgwTUdYK0xvOHZpRE4xMjVv?=
 =?utf-8?B?c09TWjRjRnhIaGx4SmVVaTdsVXF5cUVEemJ6UlJhZXRocStHdEZMcmJHYkxH?=
 =?utf-8?B?QXh5SmIvZ3pMTVlhcFFNeDdzR3NsOWNGQXo5aUFnUFpncTB0MHZzdEwvcFNF?=
 =?utf-8?B?T2NzeWlUM2ZhcUZQZHplNnJQRkdHamIvbGViL1YzVzVtUVlXQ3VERTE5M2tv?=
 =?utf-8?B?YUE3blJCdEtoeTdZVmFvMG4rTkE0YjBxSUF4aHFiOXVUYkd0MGI4aHd0UVlN?=
 =?utf-8?B?YjExa1A2RDlOcC91NlArNkgzTHpXSTl3TzJLd2dCV2hIVjVReENScC9HWFNu?=
 =?utf-8?B?aVlMdkZDaWpwaTAyNHdpQlYwUkRjWXVuMWFuVHMzeVRMMXVRcDBpWUJ5K0RJ?=
 =?utf-8?B?Wlh1TW8yT3NBV0plWEsyb0g0Um5CckpHMnBoS1dFdyt5elgremNkU2YzUjcx?=
 =?utf-8?B?N3QwMFZVV3M2L0hHZXNkeFYwRVZmZm9JYjB2bkd0VzZYeWkzbmZlSmQvaXJ4?=
 =?utf-8?B?eUdrYWVmUFVodmxaM0F2NXIyMVJQL1pud2pHaE93NVdvc2FDNHpsNjI0alBK?=
 =?utf-8?B?NnIwcjdhczFCZTQ3NCtDWkdQYVRiMFpEWGdpZEwvU2NXd1hyVE03aHJUREl1?=
 =?utf-8?B?dFJzc2JxdHc1QklSNGJDcGVyeTFORU1nRWpSVGUzNUdHMHdXZ0wwdUR2bTJY?=
 =?utf-8?B?eGNUY1VoL0krbkJ4N0NtREZtRDBZbkd0UFlYUkd2M1h4Z0JTRkZQQlp6anRt?=
 =?utf-8?B?YWlnRFEyNlJpUkQ4cEtpeEFGZjZCUFZtTUNBcXlPKy9oVkVBVjA2WUQ0MHZ1?=
 =?utf-8?B?SnA0T29lcmxweXdoWWpSUDVmT2ZmdG5sMEwxNzM0SjRKcWR1S1hOQndSSExP?=
 =?utf-8?B?RDYwZFdyUEdUZnlic2hnUHhvZVJaS0p6STNXZkYyYWFoZTQrb2dSRlljYWND?=
 =?utf-8?B?bFlBNXNVTVFPY1hWbHZoWFpsZytwd28rWVVUUkJFNzdwOUhscWx2VDdCNHdr?=
 =?utf-8?B?dHFhMlVNbTBLOWVvekRFc1JlTjBobkY4YW8xUW1Ob2RlWWpVQngrSnFXNGpU?=
 =?utf-8?B?R2FiVWlkNHNWTHFhUythanFHdlN3SUxSRlg2Vk1waXpMOG1wMUtGbkN4amo1?=
 =?utf-8?B?QWVMQXEvVkxVZWlDalZBd2oyQkJ6Y0xUbU9FWHY3UVBRUEZFeWlDZmN5a0lK?=
 =?utf-8?B?cVhkYmJXVGZNZTQvUUVmYzFiRnhPVkp4S3A5NWR5YXdVVk5jcFNYY3N6dlZC?=
 =?utf-8?B?Ymc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E63BFE5F25F0D54F9706F14718791804@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee65ad93-9b72-4973-4e0b-08da64e696b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 15:44:35.9113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yJam1zcV+Ga2WgZSC0/p9fy+4ZkucvSXUFmtEkSwx71j2ycHKXfwJ/dznaQ+obiIahSKCbiARFoMGSsz/cPLTfgRLveCimkhFgHTrR77dAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1645
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA3LTEzIGF0IDA4OjIyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
VmVybWEsIFZpc2hhbCBMIHdyb3RlOgo+ID4gT24gVHVlLCAyMDIyLTA3LTEyIGF0IDEyOjA4IC0w
NzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4gPiAKPiA+ID4gCj4gPiA+ICsKPiA+ID4gK8KgwqDC
oMKgwqDCoMKgaWYgKGN4bF9kZWNvZGVyX2dldF9tb2RlKHRhcmdldCkgIT0gbW9kZSkgewo+ID4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSBjeGxfZGVjb2Rlcl9zZXRfZHBh
X3NpemUodGFyZ2V0LCAwKTsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlm
IChyYykgewo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGxvZ19lcnIoJm1sLAo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAiJXM6ICVzOiBmYWlsZWQgdG8gY2xlYXIgYWxs
b2NhdGlvbiB0byBzZXQgbW9kZVxuIiwKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2bmFtZSwgY3hsX2RlY29kZXJf
Z2V0X2Rldm5hbWUodGFyZ2V0KSk7Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgfQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSBjeGxf
ZGVjb2Rlcl9zZXRfbW9kZSh0YXJnZXQsIG1vZGUpOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaWYgKHJjKSB7Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgbG9nX2VycigmbWwsICIlczogJXM6IGZhaWxlZCB0byBzZXQgJXMg
bW9kZVxuIiwgZGV2bmFtZSwKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3hsX2RlY29kZXJfZ2V0X2Rldm5hbWUodGFy
Z2V0KSwKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgbW9kZSA9PSBDWExfREVDT0RFUl9NT0RFX1BNRU0gPyAicG1lbSIg
OiAicmFtIik7Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuIHJjOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+
ID4gPiArwqDCoMKgwqDCoMKgwqB9Cj4gPiA+ICsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgcmMgPSBj
eGxfZGVjb2Rlcl9zZXRfZHBhX3NpemUodGFyZ2V0LCBzaXplKTsKPiA+ID4gK8KgwqDCoMKgwqDC
oMKgaWYgKHJjKQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9nX2Vycigm
bWwsICIlczogJXM6IGZhaWxlZCB0byBzZXQgZHBhIGFsbG9jYXRpb25cbiIsIGRldm5hbWUsCj4g
PiAKPiA+IFRoaXMgcGF0Y2ggYWRkcyBzb21lID44MCBjb2wgbGluZXMsIHdoaWNoIGlzIGZpbmUg
YnkgbWUgLSBtYXliZSB3ZQo+ID4gc2hvdWxkIHVwZGF0ZSAuY2xhbmctZm9ybWF0IHRvIDEwMCB0
byBtYWtlIGl0IG9mZmljaWFsPwo+IAo+IC5jbGFuZ19mb3JtYXQgZG9lcyBub3QgYnJlYWsgdXAg
cHJpbnQgZm9ybWF0IHN0cmluZ3MgdGhhdCBzcGFuIDgwCj4gY29sdW1ucy4gU2FtZSBhcyB0aGUg
a2VybmVsLiBTbyB0aG9zZSBhcmUgcHJvcGVybHkgZm9ybWF0dGVkIGFzIHRoZQo+IG5vbi1mb3Jt
YXQgc3RyaW5nIHBvcnRpb25zIG9mIHRob3NlIHByaW50IHN0YXRlbWVudHMgc3RheSA8PSA4MC4K
Ck9oIHN1cmUgLSB0aG91Z2ggSSB0aG91Z2h0IGl0IHdvdWxkIGF0IGxlYXN0IGRyb3AgdGhlICIg
ZGV2bmFtZSIgdG8gdGhlCm5leHQgbGluZS4gKEp1c3QgY2hlY2tlZCwgbG9va2VkIGxpa2UgaXQg
ZG9lcykuCgpUaGVyZSB3ZXJlIHNvbWUgb3RoZXIgbm9uLXN0cmluZyBsb25nIGxpbmVzIGFzIHdl
bGwsIGUuZy46Cgorc3RhdGljIGludCBhY3Rpb25fcmVzZXJ2ZV9kcGEoc3RydWN0IGN4bF9tZW1k
ZXYgKm1lbWRldiwgc3RydWN0IGFjdGlvbl9jb250ZXh0ICphY3R4KQoKCg==
