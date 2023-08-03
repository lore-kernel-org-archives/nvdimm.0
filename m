Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586D08BE1
	for <nvdimm@lists.linux.dev>; Thu,  3 Aug 2023 03:21:37 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQIG6h4dTWE29k0ivE/a/vTFI1TCr4i3/2qzXAQKAFNJn3BEQ6KPIpciZlO2BK+8A+z/cnluWxZ+s1b3kevPmGugLjzveLaXN/DGIBYuhqFzaf/cD4dvdEfJjJ54OMhgeY0BHCZGcBIIGx7jB3/Mz+1iLJgvJIyoTM/vSo3I4oHiucj1NI4jtMeWJ2n+G17yPDPxTZMgZb5w7ef4vfcyZp03QFtTUWfWgOQme5WSVI98hLtOwRrX+7L6gS8GRUOPYlAOzzC/cZrsCwJGJNQKZi2Ii1a8Q7Zm9xOpHfsUT4OaHMD93qn/QUSgtJLGomBIlz1MfMI9UtZLPUXS3nGMcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h76QwSFxLgw0YIOLMAe1I+GVT2XsBFFeOq3W7iaecVI=;
 b=hDOo6hzWiU0VjHDW8pToHr4iyTmB/Z22ddl835BAPkFVfEeBvDFIqOxyw2+k6NT7/JQM/KE6UGtGvfAmTEKw/kg+lDJEm9zwTaPc7B0YnlvYnzxx2sUWWCJS+3XouHlY1P4gTEkKEdJKeGW/UTz1jgsa+jLAPxPGwjbkyicTalVypAIoY21qX1yaTVeuEhnCY3fO/4mpELMZES3ulKDIKjaCqpWSVsbqMD4JrJzb302SA+YNPIg2gVIW1jjBmtaEPLALFh6DqaV52lK+r/0r4d82o2Sv9R2RK4Iys2HDDyTA91Co7gkQkmKZ2IOyD9AHyQW+krY4Z9DoeocoU/xseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h76QwSFxLgw0YIOLMAe1I+GVT2XsBFFeOq3W7iaecVI=;
 b=NwMXkiavhPG89OuMK4JfvBbv6IH3WdoAtS87F+VEsK+abovNev3DBxiq+XYOPrUe1GHti/HICJRjdCPx8+0Iqi9kk0QQfyl5RpXKoi19/UHyCsWPmiiOF6oHByajZ6vdPQLkz8WaNSMFIioL4NhgffR16Juw53KhRbnU9YFmxbBppE38wkgjY35Ia7bGOTjPD6qsMKmq2xFmx8fPuz6MugcktuzSRFrhxGRw8i6aDEUgc9Uwrfwd6pOISYBKnJHKOGIkEXQiEf5KGi+JlYtncGkc00hUItrqHk0AUaes6Yno6+b3vfSLqjrM5raKf4PV+jvhe4juN9pCEuCQSvEgBQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Thu, 3 Aug
 2023 03:21:34 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c3cf:2236:234b:b664%4]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 03:21:34 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Thread-Index:
 AQHZxADrXE+/yvq5u06qlYmjeW0Jd6/Vjqw1gAALsYCAAB0cXoAAgQeAgAC5pQCAADQSAIAAxPuA
Date: Thu, 3 Aug 2023 03:21:34 +0000
Message-ID: <6eda12c0-3e39-6a07-ba67-7c9ea1cd28d2@nvidia.com>
References: <20230731224617.8665-1-kch@nvidia.com>
 <20230731224617.8665-2-kch@nvidia.com>
 <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
 <20230801155943.GA13111@lst.de>
 <x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
 <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
 <20230802123010.GB30792@lst.de>
 <17c5d907-d276-bffc-17ca-d796156a2b78@kernel.dk>
In-Reply-To: <17c5d907-d276-bffc-17ca-d796156a2b78@kernel.dk>
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
x-ms-office365-filtering-correlation-id: 802ad4fe-21b2-42ee-71cc-08db93d0bd79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 +x8C6gPJkQdkkYBYQo9u+8eGp/yR1JSFUVf7kFHQ5wMAsI2KdXQb7W7/pL8v3ETMWiVVIWddkVXKkVvWPh6pip6ZcWPmTtG0qq0rnMg3Lwjx7iIWfVQws0aNmktFueqcpW2xtzHshE+bLXNCInTduIL3+95USldpoh1tbYsSREIJ2Brb6DImcS0SCB4VdsTfDLdrjL1zL7e4VxB0+UU+tzbStT4veYnhX7K37QxSREn3Y1F9Iu0YrThUIgq4zU3hR82Fv7o+SDFT5OaDY9+bwi+t7+2nezldqp9HuPAccKlovnOr/YS3Zd/h5X5VhtQyEegzsOdRVmpWzC2otYjVpRpwqxCHJFV9M0bYEXuqtvg9/47I52VRYEBcRHXy3Sp8lvm+f9VWuzdd5XzLsveJb8bh7H6bw1WlihsF59DFHh9o8Z9gIWVhxpk6UBUpqVx9FX1l887phHmKmB4KUzPoo7e1KnJ252pmCxSmtdqKKbsMOVao8BibiKr5RwluBlFTY39GGDQNjwV8ew2cQdbmtQUDMDQmWuKvd7IfqUAd9ZIzs/34HkS12GGir9D74c3H3tCqzhO1x6tK6qycwTWeyJYvw7F7tOuCM8Pe5DStZDXDwhm0DnwwAKvtmKfWjKH9S83DpYh971hQCgGfm5DUtZYx7SvfD9z35rHaxau2Xsl3rzeTf3L+NSw3qI8l+4p3
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(2616005)(186003)(6512007)(316002)(86362001)(478600001)(54906003)(122000001)(38100700002)(66556008)(66476007)(91956017)(66446008)(66946007)(6486002)(71200400001)(76116006)(31696002)(4326008)(6916009)(64756008)(53546011)(6506007)(36756003)(41300700001)(26005)(5660300002)(8676002)(8936002)(2906002)(66899021)(38070700005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Mk85OTNXMndzaU44Y2YvSk5WMFJPdjExUmU1NjgrcEoxK3VKTi9IYVhsNUw4?=
 =?utf-8?B?cTA4M3hIK3lNRU9RMGswUnA5dlJ3cTYyeW5zSjFHU1ZxWEZoK3pGbVAxNzA3?=
 =?utf-8?B?T044ZWN3NHIrNThFV3ZadU1raUdIMU9BVmtxWkRxdlVpZ3g5SDlKd3JFWVZs?=
 =?utf-8?B?NE5jcjRxT2tDcVB4RzVkSWU3SW03UkR5OUNmVEJsUEdOZVcxVnNBNEhIZ3dn?=
 =?utf-8?B?b0p5dFlQenIvb2Ezb0h5OTBhUTdpWXgwQnZWTVA1NU4zU2NVeTFMQU1maWRz?=
 =?utf-8?B?M1pTcjNlVk1udjM3eTVPVkFZSVBXcjhPZkJJNXkxSS9EY1BQdVBOUjM2Zi9l?=
 =?utf-8?B?MnV0bFFpNWhqRFFJL1NYdnJoNUpQSHdIOWZjWWZybDhUbXczUXRka0xsbkp6?=
 =?utf-8?B?ckYzdS9QNnJTUDBLb0dwTWZ4Snl4cWdVWVBLL1o1ekdSTDJQcDlCS1pYVjZn?=
 =?utf-8?B?TzFzbFA1eGtyNzRLdGJrOTN6R2h4eC9YYlJlRFhOb1NTSlFNMHNoNWlDUmx2?=
 =?utf-8?B?RUFHTjhoRzQ3TGdUOWsxamtpTTlneTVoVnQ5Z3crd3lBY1B0d3VITmozM09H?=
 =?utf-8?B?Z2NLNURuK1hZMHVaUEgyNEN0azYzSlVHNERiZ0Z3cGJ6OENRK0JZbktVOE5P?=
 =?utf-8?B?RDg1NlZhQjNWNnNSSFQ4TnNCaTFreFNDZzkwbUE4Z3NESzNCa201ckE1Wmwy?=
 =?utf-8?B?c3ZWVmV6L09yZnl5K1BoZURid3g5NG5aTGp1a3BjMTllOFhTdW1EL2N1cG56?=
 =?utf-8?B?VG8zbk9LaFZwdXFKLzM5dTJoem93azRkNStWYXdqOGNCSC9HZEQ4MHloUnlz?=
 =?utf-8?B?elpOT2wvRnA3ZkNmcmtPb2k5VVJIY1ZiVlp2NEFYR2pvM2JnbTdHbi9kNE9C?=
 =?utf-8?B?ZU4xaldqdzV4ZnFJUlRubmw0TCtjeUdxdFdhR0RTUWp5SjMvK0RnOWI5bW9z?=
 =?utf-8?B?clpRUzdpVEJHdlN6MnpQVDljSFE5ZmJRRUwyWmlUL0VjcFNIRnlRc3Q2Mk5R?=
 =?utf-8?B?QlhFSi82d1phazZ2SC81SG1IRm5zc1RTMTZUN0xEZDB2amx4bUZBTXV6a3J5?=
 =?utf-8?B?NzNQY0c5eVFqTVpNZExEMTRNY0FYaXVvS3JpcVc1MW9NbTR6ekV5RVNVVFhZ?=
 =?utf-8?B?aHl3WlJabmZoK01aalZ6ankxT2xYYnd1UE1Oc3c3M2lTZ1hmWTh5aW5RQjFC?=
 =?utf-8?B?ZS9XU0tMTnVCK1pvSzl2Y3hVV1RocXVPbVg2Z0REMnJ0cUt4MnVVY055M2Qx?=
 =?utf-8?B?Z2tCRURTa3lCZitDcEczem4weWJqNDIvV1czbWN2K1E5aDl0Q3NvVjNjR0Vp?=
 =?utf-8?B?VnFQdE55aDQ3ZGdwTDhRbmVyV0hycXMwa1BDZGNFek1FaUlyck40K1VmOHow?=
 =?utf-8?B?dDgybHZadzhsSHZrUHVkVFcwWXd3MzhhMnVqeERrRjFqcEFvMDZrSXZ6Y1pj?=
 =?utf-8?B?WVMyMnBHVW4zcVJRUDY2VUVxN3FYOWg4azhWbk1HeTNQVWJqR2hBbTk0NU1k?=
 =?utf-8?B?bmNFcEdEZ2h5THlXNjZ4YkZSVjVXL3l2V0RzeEJ0MlBKVGxqQTVZcE9NQW83?=
 =?utf-8?B?b2FRNUZ6UENuemtkM2VsMTFuYUhRdENESWlZcWdVQ0FZeVhrdEhKOTBoVzNY?=
 =?utf-8?B?eGU3NDM3eDhPSmFtS0ROMGZtOXZtWHZ3Q3QyWjV0dlBRbjZyb0dhN3hjZ3Zl?=
 =?utf-8?B?RFN2bFludk50eVp2UUEvcGpEdSszUDBFTnpSUEMzZTNzbGh1Zi9PYXYrWG5s?=
 =?utf-8?B?S3lXc0tjbnhWdnZ1ZjJsbml2Yk9uRkhXMC9DUkFPem9mVHhlU2RrbkI1eTZ0?=
 =?utf-8?B?emhUNUNnaDZqOEZQbFhEMkNYR3kyWVAwa3Fma3graThIbk9sZVk3VW05bUJD?=
 =?utf-8?B?Y2llb2xXL2xaeXQyK3F3cWJFY1NuT3ZTamNDZHBmaTNickhIbVNGMFdnbjRQ?=
 =?utf-8?B?WUJPTHBiMks2cVh6eW4vbkd1R1ZDaDUvWGZXOEZYVzI5NUJ0dmJaWFJCa0k2?=
 =?utf-8?B?VERrQkZlaEhuS09sTEZkL3RPOTcwcjdJR0tlQU5aYWxQVkNqTmVNQ3FOY1ds?=
 =?utf-8?B?ZTBUR1E4OVhnYmR0bnJhKzVwY2NLVkdqbklZUEM2TUpyR2Y5MmxaZDUvUzZW?=
 =?utf-8?Q?lTd/jgIN1ySQcqNYgkx0JI7Mm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B53ECA5AF2C9B845B420BD9686586173@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 802ad4fe-21b2-42ee-71cc-08db93d0bd79
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 03:21:34.3275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LTiOIzAKhuBXkZV7pPIooUjuCPQwtK/qt0E4DmUy3UQNhvp4887QeGeXSDyRhztSGwcKkuS9KIT4jAXcySLVYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903

T24gOC8yLzIzIDA4OjM2LCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBPbiA4LzIvMjMgNjozMD9BTSwg
Q2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+PiBHaXZlbiB0aGF0IHBtZW0gc2ltcGx5IGxvb3Bz
IG92ZXIgYW4gYXJiaXRyYXJpbHkgbGFyZ2UgYmlvIEkgdGhpbmsNCj4+IHdlIGFsc28gbmVlZCBh
IHRocmVzaG9sZCBmb3Igd2hpY2ggdG8gYWxsb3cgbm93YWl0IEkvTy4gIFdoaWxlIGl0DQo+PiB3
b24ndCBibG9jayBmb3IgZ2lhbnQgSS9PcywgZG9pbmcgYWxsIG9mIHRoZW0gaW4gdGhlIHN1Ym1p
dHRlcg0KPj4gY29udGV4dCBpc24ndCBleGFjdGx5IHRoZSBpZGVhIGJlaGluZCB0aGUgbm93YWl0
IEkvTy4NCj4gWW91IGNhbiBkbyBhIExPVCBvZiBsb29waW5nIG92ZXIgYSBnaWFudCBiaW8gYW5k
IHN0aWxsIGNvbWUgb3V0IHdheQ0KPiBhaGVhZCBjb21wYXJlZCB0byBuZWVkaW5nIHRvIHB1bnQg
dG8gYSBkaWZmZXJlbnQgdGhyZWFkLiBTbyBJIGRvIHRoaW5rDQo+IGl0J3MgdGhlIHJpZ2h0IGNo
b2ljZS4gQnV0IEknbSBtYWtpbmcgYXNzdW1wdGlvbnMgaGVyZSBvbiB3aGF0IGl0IGxvb2tzDQo+
IGxpa2UsIGFzIEkgaGF2ZW4ndCBzZWVuIHRoZSBwYXRjaC4uLg0KPg0KDQp3aWxsIHNlbmQgb3V0
IHRoZSBWMyBzb29uIGFuZCBDQyB5b3UgYW5kIGxpbnV4LWJsb2NrIC4uLg0KDQo+PiBCdHcsIHBs
ZWFzZSBhbHNvIGFsd2F5cyBhZGQgbGludXgtYmxvY2sgdG8gdGhlIENjIGxpc3QgZm9yIGJsb2Nr
DQo+PiBkcml2ZXIgcGF0Y2hlcyB0aGF0IGFyZSBldmVuIHRoZSBzbGlnaHRlc3QgYml0IGFib3V0
IHRoZSBibG9jaw0KPj4gbGF5ZXIgaW50ZXJmYWNlLg0KPiBJbmRlZWQuIFBhcnRpY3VsYXJseSBm
b3IgdGhlc2Ugbm93YWl0IGNoYW5nZXMsIGFzIHNvbWUgb2YgdGhlbSBoYXZlIGJlZW4NCj4gcHJl
dHR5IGJyb2tlbiBpbiB0aGUgcGFzdC4NCj4NCg0KeWVzLCBkaWRuJ3QgZm9yZ290LCBsYXRlbHkg
ZGVhbGluZyB3aXRoIGJ1bmNoIG9mIHN0dXBpZGl0eSwgSSdsbCBzZW5kDQp6cmFtIGFuZCBudWxs
X2JsayBub3dhaXQgY2hhbmdlcyBzb29uIHdpdGggeW91ciBjb21tZW50cyBmaXhlZCAuLg0KDQot
Y2sNCg0KDQo=
