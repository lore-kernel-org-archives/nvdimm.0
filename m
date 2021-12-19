Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10C168
	for <nvdimm@lists.linux.dev>; Sun, 19 Dec 2021 04:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639886789; x=1671422789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iL3BubzuIiNLkwwi9hs2s39mGQAW98DBaDKp2QioYC4=;
  b=kzsRuyTK7Y0hFx0xDpz9LxtAA5VAZDj4pQmUIdsoTpVQhi6jfV1F1+cH
   XptPbks1ArpoP7ctp8IwGLdhe7hwDjjQJJJoiv2okzxutEWZevelLNon2
   3sjx/85gXfOyQXasIT25V9QyMwrXAAe0YLwNwBULagrz1kSIqUdglV2kc
   uoG0PIOy2Ag7djAuXqzMSgWoVcYiPZG97kotzqDJUPOeL6i96BVryogfZ
   b7jotCMJEgzOWFq3KGxY0H+E/WiEx3IN++zg/FdLW+Ui+Bk95Zb0fqx8v
   0o1L1Z7N1vTbZ59cj8vURkhZ2wCrctM8XbVL6DYodrIvjSl17Is91MWj/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10202"; a="303350435"
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="303350435"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2021 20:06:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="683847222"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 18 Dec 2021 20:06:28 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 18 Dec 2021 20:06:28 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 18 Dec 2021 20:06:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 18 Dec 2021 20:06:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 18 Dec 2021 20:06:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5mhb9oe0EWBMacY5fOkKYXkGHHbO/cCw0bGUYi++F1UJ2gre8jmCtklVEOKgjPjYvTKaQunxoLYGWu+VSl2eyNVpar8CAA7VAEddbrOvHJ94DxMbX58LglnqfhSBOkOFxnGh7k6hvv5guiZTOjOc3DZIkeo9QIm7+qFNd/VEuJlnGm60fLBNIS1BUXCBS4SqWBbIVegyb83H4ewEc2c+VxWONroKFzh2HgtVX/JB+W+uihxR3HfEz6iRW1IKGu9DGY7g6OqaHgSDJEPxroHcCzCWQD/Bgn9SCPR60V0Ce8NFO+pzbAx9tI+Oszi6L1sERexFT+nq9GXQuYoToiWtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iL3BubzuIiNLkwwi9hs2s39mGQAW98DBaDKp2QioYC4=;
 b=ZcrcjVUg4ydzykU1T99RLKqwgzUUeb5JR3Xj0p0hj08h6IJrSf9jOc97HP+QRYisb3lnAyHOD/KD+rA5vTp07PVSlAM6BxXea9JdaWiOuangBrm0SU66kMgM5lTkG6+cGqBiYyXcGPD19+wnwmjkUHzzb3F+9NzAnw8hP8H9RNXNXziofpcTHYeD0LOvTpjMN7x4pjdH6URZPBYLaMwJ1SVtMTpD0S/urJjrOSHeA+HZQN+BEtDgttrhuwgs5xv11Y/JIc5TqehsCmjEVqGJ4kG44eOi6vdgvmT0jYee9ShtIItor6FIZPJWtRGTmgnrROmwU7cTBjd/+MDK9827+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3583.namprd11.prod.outlook.com (2603:10b6:208:ea::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.18; Sun, 19 Dec
 2021 04:06:25 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 04:06:25 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "vaibhav@linux.ibm.com"
	<vaibhav@linux.ibm.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [REPOST PATCH v2 0/2] papr: Implement initial support for
 injecting smart errors
Thread-Topic: [REPOST PATCH v2 0/2] papr: Implement initial support for
 injecting smart errors
Thread-Index: AQHXx1UUMwB7w08rqUK8hXzQvMVwY6w5jOgA
Date: Sun, 19 Dec 2021 04:06:25 +0000
Message-ID: <50754446644ea7f94b60451cc0d7351cc35431d9.camel@intel.com>
References: <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0777fa6-3b87-4f5c-2305-08d9c2a4ecca
x-ms-traffictypediagnostic: MN2PR11MB3583:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB358388251FE8FB8B74C4727AC77A9@MN2PR11MB3583.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTNNZLwccQmPW1vOPewiUAYTAJP3NHgyG1I+7WQcsJJUaMxpisGtj26EU7fs9c68A2EZrD7hrjMpuLfxz70fdmjkmDCiMclZznHuKVVL+L7UlqFH93Ei9UsUCFJijmGXQCn7NZN3DhwqMVwsa3WuuvsEUVQPNImy6CyE1oUfc9YvDDtLtDV05xFSWfWXXcqQq+wl/YTNpVPkVgd88B+eRsISTQob8lFsD5Sen2d6kzWGLdhYcT9JTHn+COSMAEwkVEH249SSKPo2vDHhM2z7YG4re4k+ca5ZQbPOhTgwuJZgCdB9D6qcZuGoamNy1VUA0SkeQfhct+P7i11JM/c+VSixvx2b92WXwCZIySe7NxcaeNP4PzTPcKm6ZFUh0tvISfXEHSzJiQTihOI5Q04/TaVM28tLOIDAQh2QicqXos7ZaJF4CIJduuHcGMyrjZaS6e82MT87PZp3fwa+7JluMfp4e7fuaM/K100RAV3UiJGZt923UYidsQE+dXS6DUkWLBBsKtlTvBpFIAVWJDBkvrROnX1uT00CMfHZYcVPx80h4sG0f2jUJBBKNxJ/7zQsRsfXOI7Vwx0O3zhrKdUljv9VuTLJte0OBdPnQYyyBblN9hw6gW0vf8nFEqI6RaIs0vCDK4q1WaPro+DhZvqrCBF8eTRB/cd9vaVmc1jjNPJGmq7XErXSsOQKZQu08lj2tAhsWovGUqA5hzf8SGTq3dNndzDEE7PqjhV/xpU5v40iCL3i5bKibvFQa2WaLI4ErzXYKXyhCCMw5InoFvFyyisHNHfET/q0UdfP44wf9HZ/zq0OoC+jrT5SyiSie+MQ0NC0FQKRTq/x1wK1mWHMyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(508600001)(38070700005)(26005)(6506007)(36756003)(4326008)(2616005)(316002)(186003)(2906002)(54906003)(110136005)(6512007)(71200400001)(38100700002)(122000001)(8676002)(83380400001)(66556008)(6486002)(82960400001)(91956017)(64756008)(66946007)(76116006)(86362001)(66446008)(66476007)(8936002)(5660300002)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VENHSUh1Z1daUXdTc1hXU3FOVURnSmREVlpVcnk3ZWF5T0h4UXZlZlJuTnZ6?=
 =?utf-8?B?Z1NFL3BIVVc4THVoVjJIRkdwM1JmOGFOZmtCVDVqek1uYmp1RU9qblJoVk94?=
 =?utf-8?B?RjFWRUovcEIvVjVvMjZZUTFxQUMzcVQ4Z1YxYVI0M1NKVjRHU2RyQkVlYXdR?=
 =?utf-8?B?aUY4Tlp3cnpITHpySkY3ZHpGdTJPYnlQbVFDL1lMcW13R09IRERhT1ptUFQv?=
 =?utf-8?B?WnN2QUpybTViRkhaNzBsL053MUEzVUx3T2pNNmNsbU51ZDhxbFphU0RKUWpD?=
 =?utf-8?B?TXBSUG5TWjFVL2oxZGxDVDIzd25TRFFvcjg3amlCeENKeTlhcEk3bW1oOExW?=
 =?utf-8?B?bWl1OGdBSnhwbUxGeFdRbnRrTlpIY3RRcU1lSFlTVStqWmhYZElDQ2djc2tE?=
 =?utf-8?B?ajg3VWJLV3Uwa3JFb2l2NzgxT1R4L2RZcitqZjZYZW9zcEFJbzBSYll1aFNy?=
 =?utf-8?B?ZWt6eDFFa3BUdXB0aFpwZ21lb1pQK1FyTzFZQld6L2ZUbjQ1OUpPa21OY0tp?=
 =?utf-8?B?UVM4YVRIVVpOSnJFcy9IekFUejhYZ3ZQNEJ3Yi9Fc0pPblF5dHBkZEFyS0Nm?=
 =?utf-8?B?L09YYVF3TDY4QU00SGJWVUFRNFVnenJUaHdLbERoeFNjLzV0aUx3OUUzdGVE?=
 =?utf-8?B?R3ROdzlDejl3WTE2UEdVMHB2UnJQbDRpanpRSjlia3BzWE80TmIxU2xuVitZ?=
 =?utf-8?B?VVhQWGtOeWZDM04raWxwSENHeXB1YXVsbXp6YkdOVHJGbFB3VnorTlc1cG0z?=
 =?utf-8?B?aG01WUFuaytpdzdwano0VkkzTDJSdVBoeWE3WEllUmdEUS9ESm5sMCtwV05C?=
 =?utf-8?B?ZmVCTHI1d3B1TDhuYmRoblNvMnV5WHhDR3F2UGJIRzNvM041MEFlc01yclNF?=
 =?utf-8?B?TU1UY1lRak1Tc1kwWWVBZUwwSk5oNEJ1R0FPWENCWVZxZWUxdDVHL1MzZkZa?=
 =?utf-8?B?SzNHSEFhc3JzL3VNR1AvWlV3amJGck92UWFiRWRJM2UzUXpRZG4zWDdSb3d6?=
 =?utf-8?B?RkZDMlR0aG5zZFZDaENvai9tVGQzcGJ2V3hPWS92OGNKMlUrUUZCR0FlTS9S?=
 =?utf-8?B?ajV1QVFzMFF2VnJ2ZEdZMi9EODNtbC9lVGxtTDlXRjQyYlpMSDN4VmJOS1VM?=
 =?utf-8?B?ZHEvdUZRR0JnUjY5S3VwTk80aU9zb1FuUzByVGxCZ21MMFU4NkQ5YW1FRlhl?=
 =?utf-8?B?L2J6SUJDMndvM0hzeHdiVFNndnVyOUE2YVJEMXMvSE11MGdwZ3Q0QTdzUkVn?=
 =?utf-8?B?Snd0QS9vR2xWUXFTQzJSYVRJU0lWTUlldUNrUTdLU0NOWmRIQjhLcHpKdWFF?=
 =?utf-8?B?T0ZrL2RPY2lRQlpJVkhQTEp3Q3lRSjZWZVU3RzQ2MzVTTU9tNzdtZWpiV2dk?=
 =?utf-8?B?S21HS3cySTBncmREZkE4NFFwNytubDdpRGtRckVIRVdqSDhMbGpRcE91VDh2?=
 =?utf-8?B?a1lVR1c3QlB0amc0K1J5b2NsZC9jdjNQQnhPY3FvS3FSOHRyUGxoTE9lOTlH?=
 =?utf-8?B?MS9NU1lvY2RxZHQ3QUVXMmYwSUZzcm5saVlzTGpCNk1oYzB1Mm1zSmFPNEJk?=
 =?utf-8?B?bVR2U01nOEg4TTFEZXp2QUxUajNDZzBhbWdLMkVDL1VuNXlIRDk0WVhvLzV4?=
 =?utf-8?B?eGlzOXZWcmQxd0VwOTBrWG1ubHVocW9QM2VjYTBlS3NmRzZWWFpzbHVDb3lB?=
 =?utf-8?B?YzJjWnFYamprV3RmUUNkMk8rc2V1bFJmd0hHa0Ewdnp3SDlHRGdmbUxpZzNp?=
 =?utf-8?B?alJmb3c5dHFkdVV6eXg4dE5yVW1waEk0VFVQZ253ZXkxVk5KQ0N2ZDBUaGZr?=
 =?utf-8?B?R0RMK1dlMHJBZTI4VEVPditCT1ptZThmSzlnb3hud1N5K25NSnJBUkViNVdG?=
 =?utf-8?B?TTZGR2p0SzMvbUxrb1lqRnpCT2t4V3cxQ0gyVi9IbUI0K1hFRjVUSGd5VG0v?=
 =?utf-8?B?TXVXdUY5a1ZvQmp3cFU0VGxJSHhFZWN6T0FhZ2ptUHY4blkzbHN2ekZ4WkRO?=
 =?utf-8?B?bzJwLzNwaitBQSszdjNtcUlaVmN3L1BNbkVsMTl4OWpGZ05KZjV5c05PbHI0?=
 =?utf-8?B?Zk5WVlhnU3hNSWltRUdZWWJoZUVzRWNRMi9KZjc2ejY1clJNcnJORkNSQVZa?=
 =?utf-8?B?RXZIOUtPRkxqRlZPaEo4N3Avb0VKdTAvb3BnYmI0MjBrM0tiVEZTWFpkbklQ?=
 =?utf-8?B?U1NocDZjekJhaDJDOGxHYW41OEdFVUd6c1ZtOTZROTc1ZGQ2MnpwVW42cWNH?=
 =?utf-8?Q?H8D3Wdy+Q51g+PB3nfKQvvqLvwzUdkKw+SVmrqw+Kw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61B7766638304B459531E9FF97773A15@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0777fa6-3b87-4f5c-2305-08d9c2a4ecca
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 04:06:25.1851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGffrpxVzW3yvjQnLFN6XNPAbbJNT+Ksi5WhG87BzymbdRs7tQI1v9Gp49548ZbCTvrFmN8p8RIfMc19onozrwIn55oiujG33MnSVXHD6AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3583
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIxLTEwLTIyIGF0IDA5OjU2IC0wNTAwLCBTaGl2YXByYXNhZCBHIEJoYXQgd3Jv
dGU6DQo+IEZyb206IFZhaWJoYXYgSmFpbiA8dmFpYmhhdkBsaW51eC5pYm0uY29tPg0KPiANCj4g
Q2hhbmdlcyBzaW5jZSB2MToNCj4gTGluazogaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9w
cm9qZWN0L2xpbnV4LW52ZGltbS9jb3Zlci8yMDIxMDcxMjE3MzEzMi4xMjA1MTkyLTEtdmFpYmhh
dkBsaW51eC5pYm0uY29tLw0KPiAqIE1pbm9yIHVwZGF0ZSB0byBwYXRjaCBkZXNjcmlwdGlvbg0K
PiAqIFRoZSBjaGFuZ2VzIGFyZSBiYXNlZCBvbiB0aGUgbmV3IGtlcm5lbCBwYXRjaCBbMV0NCj4g
DQo+IFRoZSBwYXRjaCBzZXJpZXMgaW1wbGVtZW50cyBsaW1pdGVkIHN1cHBvcnQgZm9yIGluamVj
dGluZyBzbWFydCBlcnJvcnMgZm9yIFBBUFINCj4gTlZESU1NcyB2aWEgbmRjdGwtaW5qZWN0LXNt
YXJ0KDEpIGNvbW1hbmQuIFNNQVJUIGVycm9ycyBhcmUgZW11bGF0aW5nIGluDQo+IHBhcHJfc2Nt
IG1vZHVsZSBhcyBwcmVzZW50bHkgUEFQUiBkb2Vzbid0IHN1cHBvcnQgaW5qZWN0aW5nIHNtYXJ0
IGVycm9ycyBvbiBhbg0KPiBOVkRJTU0uIEN1cnJlbnRseSBzdXBwb3J0IGZvciBpbmplY3Rpbmcg
J2ZhdGFsJyBoZWFsdGggc3RhdGUgYW5kICdkaXJ0eScNCj4gc2h1dGRvd24gc3RhdGUgaXMgaW1w
bGVtZW50ZWQuIFdpdGggdGhlIHByb3Bvc2VkIG5kY3RsIHBhdGNoZWQgYW5kIHdpdGgNCj4gY29y
cmVzcG9uZGluZyBrZXJuZWwgcGF0Y2ggWzFdIGZvbGxvd2luZyBjb21tYW5kIGZsb3cgaXMgZXhw
ZWN0ZWQ6DQo+IA0KPiAkIHN1ZG8gbmRjdGwgbGlzdCAtREggLWQgbm1lbTANCj4gLi4uDQo+ICAg
ICAgICJoZWFsdGhfc3RhdGUiOiJvayIsDQo+ICAgICAgICJzaHV0ZG93bl9zdGF0ZSI6ImNsZWFu
IiwNCj4gLi4uDQo+ICAjIGluamVjdCB1bnNhZmUgc2h1dGRvd24gYW5kIGZhdGFsIGhlYWx0aCBl
cnJvcg0KPiAkIHN1ZG8gbmRjdGwgaW5qZWN0LXNtYXJ0IG5tZW0wIC1VZg0KPiAuLi4NCj4gICAg
ICAgImhlYWx0aF9zdGF0ZSI6ImZhdGFsIiwNCj4gICAgICAgInNodXRkb3duX3N0YXRlIjoiZGly
dHkiLA0KPiAuLi4NCj4gICMgdW5pbmplY3QgYWxsIGVycm9ycw0KPiAkIHN1ZG8gbmRjdGwgaW5q
ZWN0LXNtYXJ0IG5tZW0wIC1ODQo+IC4uLg0KPiAgICAgICAiaGVhbHRoX3N0YXRlIjoib2siLA0K
PiAgICAgICAic2h1dGRvd25fc3RhdGUiOiJjbGVhbiIsDQo+IC4uLg0KPiANCj4gU3RydWN0dXJl
IG9mIHRoZSBwYXRjaCBzZXJpZXMNCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4g
DQo+ICogRmlyc3QgcGF0Y2ggdXBkYXRlcyAnaW5qZWN0LXNtYXJ0JyBjb2RlIHRvIG5vdCBhbHdh
eXMgYXNzdW1lIHN1cHBvcnQgZm9yDQo+ICAgaW5qZWN0aW5nIGFsbCBzbWFydC1lcnJvcnMuIEl0
IGFsc28gdXBkYXRlcyAnaW50ZWwuYycgdG8gZXhwbGljaXRseSBpbmRpY2F0ZQ0KPiAgIHRoZSB0
eXBlIG9mIHNtYXJ0LWluamVjdCBlcnJvcnMgc3VwcG9ydGVkLg0KPiANCj4gKiBVcGRhdGUgJ3Bh
cHIuYycgdG8gYWRkIHN1cHBvcnQgZm9yIGluamVjdGluZyBzbWFydCAnZmF0YWwnIGhlYWx0aCBh
bmQNCj4gICAnZGlydHktc2h1dGRvd24nIGVycm9ycy4NCj4gDQo+IFsxXSA6IGh0dHBzOi8vcGF0
Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC1udmRpbW0vcGF0Y2gvMTYzMDkxOTE3MDMx
LjMzNC4xNjIxMjE1ODI0MzMwODM2MTgzNC5zdGdpdEA4MjMxM2NmOWY2MDIvDQo+IC0tLQ0KPiAN
Cj4gVmFpYmhhdiBKYWluICgyKToNCj4gICAgICAgbGlibmRjdGwsIGludGVsOiBJbmRpY2F0ZSBz
dXBwb3J0ZWQgc21hcnQtaW5qZWN0IHR5cGVzDQo+ICAgICAgIGxpYm5kY3RsL3BhcHI6IEFkZCBs
aW1pdGVkIHN1cHBvcnQgZm9yIGluamVjdC1zbWFydA0KDQpTaXZhcHJhc2FkL1ZhaWJoYXYsDQoN
ClRoYW5rcyBmb3IgdGhlIHJlc2VuZCAtIEkgdHJpZWQgYXBwbHlpbmcgdGhlc2UgYnV0IGhpdCBj
b25mbGljdHMgd2l0aA0KcGF0Y2ggMi4gQW0gSSBtaXNzaW5nIHNvbWUgcHJlcmVxdWlzaXRlIHNl
cmllcz8gV291bGQgeW91IG1pbmQgcmViYXNpbmcNCnRoaXMgYW5kIGFueXRoaW5nIGVsc2UgdGhh
dCB0aGlzIHJlcXVpcmVzIHRvIHY3MiBhbmQgcmVzZW5kaW5nPw0KDQpUaGFua3MsDQotVmlzaGFs
DQoNCj4gDQo+IA0KPiAgbmRjdGwvaW5qZWN0LXNtYXJ0LmMgIHwgMzMgKysrKysrKysrKysrKysr
KysrLS0tLS0NCj4gIG5kY3RsL2xpYi9pbnRlbC5jICAgICB8ICA3ICsrKystDQo+ICBuZGN0bC9s
aWIvcGFwci5jICAgICAgfCA2MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICBuZGN0bC9saWIvcGFwcl9wZHNtLmggfCAxNyArKysrKysrKysrKysNCj4gIG5k
Y3RsL2xpYm5kY3RsLmggICAgICB8ICA4ICsrKysrKw0KPiAgNSBmaWxlcyBjaGFuZ2VkLCAxMTgg
aW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IC0tDQo+IFNpZ25hdHVyZQ0KPiAN
Cj4gDQoNCg==
