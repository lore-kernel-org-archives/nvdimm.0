Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BA2A953
	for <nvdimm@lists.linux.dev>; Wed, 22 Feb 2023 22:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677106006; x=1708642006;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=cCG2DHHSGkliltAK37w0hb3GCjFoqYkC8QYy01RoyX8=;
  b=UFMfSuphquZDK3kn9yDsoQ7sBzBmuKEV2Odry93NvMYnvJglZU7ysXi1
   eMufXzJ3al5X/jEyg2n68LHmVo66VmLLHhDqihkQHpxF6Yv0fvid4Vqjj
   ma4bHg0dxP1MmneG9cgbmcYsnF11BUtgjznzMAz6EME62h4mAPxWBamOK
   KPqUWGc3+pCPIkoum4N3zeT8fAhEUSm9y1xKdkMQPYuFBo9kmXERWP1ce
   M7F64IlrWZz23p1Z0E7VTPsd01wah7lCFxLcq/XaskjjCH2R8K9DihU2i
   tLvtNmrBYVXDIFWDUdFVSgNbq9eAVDV6ayGGS3GjLUlzjmUMuEq8ZbkGD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="419283289"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="419283289"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 14:46:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="649723329"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="649723329"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2023 14:46:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 14:46:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 14:46:44 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 14:46:44 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 14:46:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnfLUg5jWWk9vD9NWOhd+kq4ilI9LXKUTJwkFt4pe0glZ3ogf5i9y+5noDQARa5pEDg3oLJznZOOhn9hUhpxYUDSrSYC6vcpwk1qcRyMFCK520s/xYFDn0zP0+VQerKnVkMRpYk/oO5AQ0M+OKocRMnLrN6OHDkoYlqEk70m8SMz4nE2+itHN/PZEcwJ0syR6ZRbbYilHLTv9WQx1E6cI2cMmPzoGbXLnU8pLgFKFCXyggncLWz2NhlXZCSRDiYRflmrI5E5+8hCZk8zpXBpk3S62P3w7zV9pIfk+FgqpRdSH5rUHskUl34K1KNOxq1nWkBrLNNVKBcRC92/QkEQJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCG2DHHSGkliltAK37w0hb3GCjFoqYkC8QYy01RoyX8=;
 b=FQAi3xUpRmH5/nEwz2plpKVMlD9JRV4jsZNjofX8RLxtrwPEVCgOZhX/ttRfQtz95wi8hCvjRK/CpPpmNr7HTG3bC4pjhIZ18DvmWog4FOj71SCP0T8LvBC0Uls3tY45B1QPRs2/4gC8mmPXCMtr4Yu9SWUbIeMBOwg1h4TLzqQNPr2hAg5yaJCsr0ASnG20hWhArBCS6E83h4bNY463YxFMAIzlXLlM+qoZ2paDOcuFEH/PdzovrYHrM9DNc3qtzrCev/GrOfR2NPYFOSMECjRw6eVV0tvfGaBTSX2pvJcujeqkqxNWS00RrlDGyMCSSR1h2+jGySIP1dIg3AC4LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SA1PR11MB7016.namprd11.prod.outlook.com (2603:10b6:806:2b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 22:46:42 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6111.019; Wed, 22 Feb 2023
 22:46:40 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v76
Thread-Topic: [ANNOUNCE] ndctl v76
Thread-Index: AQHZRw+HtLdiZnZij0ahdsiLA6AjWA==
Date: Wed, 22 Feb 2023 22:46:40 +0000
Message-ID: <04fb4f86929c557033ab3e55a0742b0dfaa87dee.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SA1PR11MB7016:EE_
x-ms-office365-filtering-correlation-id: c64d0473-fe64-46f4-531f-08db1526a9a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xgOBHXbB8q9pvSjaPQ+ONTDLL7RlzalkW6dpcXvWLOON5kMIcECO9mlcA5X6pvATfr739ewnYH2Kyd6n/2q/WpwXxe+XUEXpTRwQ3c/jm+Wtpc5n155f6ybypt1G4afIAa4yyz313CFQ6Xh7RaByooDRgVaoToqxtHdND05CzInbdWx0Mr1OY0QhhQCyssgSZnV3RaoOu2tEBqtpMVptoi4coF6qU7g8+Gshxky1/8GXOCowINiRDjCLsgECoUifDwld/RG4ALdmV9y/LQQflRSieXZ/Y4KP4VgBbUbhouX8se5Fnwwxts0FFUt19EIC128mOK7YfWWqlEX46thB+9YaXgsAzfaQ/1UzqmDi+RzOXOoY6oEConpAgZh5U+poNFgxxlP5Tf6VM0i+9Ig0Yl2qORc7m0IxU70F13c92B05leywi6hdxibBiuLK3xXn3SfMYLg/z22euQTEgjaCfe97ncm0+ZNGH6m9AXYlpnMLRPoho3KtaBjBUI3upENBlJSK6AOk8/8z1WrG/E4j4m3wZbJbsr5EWoRDjd6HCCOvLhuDEvWUpLzZSSwJ5qZgZDf2TKsJWZWCZtACM5rUlE/SQwkv+p+RuNKj+m+PP2hQyOcA1vEBzx28X36UdvjizYUJwzBzCQACjL760xvSI6NEJ+0gF7zPmJZKqzYtI2iD2WurMEW6NCD57czvBoGq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199018)(38070700005)(86362001)(36756003)(71200400001)(316002)(83380400001)(478600001)(110136005)(6512007)(6506007)(107886003)(186003)(26005)(2616005)(6486002)(966005)(2906002)(38100700002)(122000001)(82960400001)(66446008)(76116006)(4326008)(66476007)(91956017)(66556008)(8676002)(8936002)(66946007)(64756008)(5660300002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnU0N2xHVHpBTzlEcTBQNHlXYk5XekhVdFBoL3UrTm9aWlRSZFdhZFJIZjQ1?=
 =?utf-8?B?NGNkWlRGRW9mV01WSFNQUTZFZGE5dHRtVjhKZW8wdjUwRnFnU0NncVRpRy9E?=
 =?utf-8?B?SVdMZDVwM3M4NjRzUi9FQjRQelRmUkZKdTBOQU0xeUs2OXRGNVB2TWhRMEx4?=
 =?utf-8?B?SExxODdmaU5KYUZzSVJoTjhXNURKVElGbGkvVCsrWld1d2I0UHl4ZVZoeTVN?=
 =?utf-8?B?MXJRbVJKdXVZa0RFOHh0YmgyUTBJNnVOc2l6cTQwLytsL28zcytKY3VzYW4y?=
 =?utf-8?B?S3VDSjU4WlFQQ1pJejVMZVJxNkJlMkhUSzc1WUFPUEU3ZjVlalkyR0MzMVQw?=
 =?utf-8?B?Z1dHVXhlM0JXM2wzZHVNRVhTeDhsODQwcGpKcVE5OXlqWWJnY1VRV3d0N09C?=
 =?utf-8?B?K21jL2ZjMWw3cG41L2VjaUt2RUtBUVpibmx2ZVFkMm1wWkxHK2N6bjFKMjhq?=
 =?utf-8?B?WGZmMXZMMjU4VzkrSkZBMk40OERTV2huN2ZsWWlFb2NnOW9UcFNjUGVoenVk?=
 =?utf-8?B?OEFqYU5ERDV6REV1YlBQREJsa2JJMnNJUGZjd2xkWkxLUXBQMEdxckdqTith?=
 =?utf-8?B?U3RsalVQWGJKZHEwQWtYMnBYSU1UcW8vWGhhVWdZek8ybGo0Mkd5bGVJaTll?=
 =?utf-8?B?Uzd2b0VjVW4xeUNBY2dCRGoxeG0wT2hCREpsa0tJc0lPV082aTVZZVgrR3FJ?=
 =?utf-8?B?OUFlOVBkMnRRWnhqQU9wbGNaalY3LzRFZjZYQm03c2dHL3RHako1NzRUVFEx?=
 =?utf-8?B?S3I3QXBHUWp1anFZZU5IeXVpQU1zZ1FKU2xzZmJMT2dFd1pPOSs2Mk8zL0pz?=
 =?utf-8?B?SkpQb2xCTk5jTldPUzdpQUhRV3ZlRE5Xb3FGWjZoeUR4U2FncHJ0Y1JhazhE?=
 =?utf-8?B?bERrSmJ5UFV3aUh5MXEySk5Dc2lBdG1TdXZrb1dlR2grejhva3RtYU5PdW15?=
 =?utf-8?B?TXVQOWhvM3BiWlZ6Ri9JYXZJWjgzZkd5K0l3YlJBMUxid3BZRkR6aXlaT041?=
 =?utf-8?B?NzRLc3AvYTRMUnpCRUdUVFNWclVySlcrelE4YUlRNjROUkhuelRrQlBWbjFY?=
 =?utf-8?B?MElDV0pwYVk4Smc0Tks0WUdiY0Jab3M4OExzQjZKOWZUM3hpeUpYL3JkMXF1?=
 =?utf-8?B?c2puTG1QdTlOUGptTjJWMG1naWFaSW56UHhhQThjMFJNQnYyQk1TQVVUQzYy?=
 =?utf-8?B?MnZqZnZDMXhoTmZYaXF5bXArNGdyYm1YVUNuQm5LTnFEV29rM1RYOWY4dTla?=
 =?utf-8?B?akw4bWdrNUI2czU4QTBPajgxWXB4YkRWU21BMHJCcWxPVlpYeXovN3JidnRt?=
 =?utf-8?B?WTArTjVzc2Z1bkVXOEZ0eDVkV1ArZ0UvMkUzRldOcUN4OTExTGZJcnd5dlJs?=
 =?utf-8?B?S0kvOGlINjdCTnhKN05nWjB6L3laTFVrbHN4THFrTTR6S01CWlU2Q1QwYW0z?=
 =?utf-8?B?VHNlYUhuRENzMExmbEo0U3JVOXovdTFzSnhkOHVHNXU3dEJobENmcFpJc0tI?=
 =?utf-8?B?Rms5K3dUajFyNDFMVjdHUFNocnFpakNqbWVsem5IODJDVzJWV0QreXNEdWZE?=
 =?utf-8?B?R0dBMUo1Tm54b09BR0QyWmJzaEg0OFJlbzZzL2oyK1I0OG5WbVFKb3hvVTFO?=
 =?utf-8?B?aFBrQWxNUTBLbld2OHphakNIV1NPc2RMS0EyVGEzZVlPNHhpRmFQMEdqR0dv?=
 =?utf-8?B?Ky80bzUra0pZemc3RUNHb3NobjR1d0VNcGNoRDNMVnJISjY2SDNrdHdPMG51?=
 =?utf-8?B?Z25XdnkyQzFCRHIva2tjQVdkdFNZalJmeHdBMlRnWE5nbzVsQUdnYWtGdjEw?=
 =?utf-8?B?ZEJrT25VUzFUNjFtUk5NL2xKL0NLeWQxMG5RTTc3dFczSVV1MXZDNkg1NTU3?=
 =?utf-8?B?dWVNby9iRzVlUVBqVFlwTUErdTNwZkQ0Zi9HZXErSnZjZFhrdjFvWURiN1Bs?=
 =?utf-8?B?UFVJS3pJVE14NnVyYldrM1E1aEVPbDJnWHdtU0xQdkp1cEdaMXYzcUdxOTYz?=
 =?utf-8?B?MUF3T1ZqVG04RC9VQndnZmhSdUpjLzNsT0JYbHdJTlBNYlp3UGQ1U1dnYytG?=
 =?utf-8?B?SXhobWtZcFYzWXo2dGVGNkdiR1l5Y2w4VWxkV1U5T0hlVWlBVG00QktadEV2?=
 =?utf-8?B?STdTaWEvWDk3TUtJMGpTem1zR2g5VHp6NjVJSURDckJ3dWFjQ05CMUo1VDk2?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <354CAE04282B234CAA28B7A001426CAB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64d0473-fe64-46f4-531f-08db1526a9a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 22:46:40.2066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: whZ7+gRupRo9OWdCzL+k8nRF6NnFa1Y6x0v8eUCxH+tz49blel3+uL+wEX0bZzvTACwXgwjVR6uJgKa5YPYPkht0itGXHNtWKSyBf6vqw0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7016
X-OriginatorOrg: intel.com

QSBuZXcgbmRjdGwgcmVsZWFzZSBpcyBhdmFpbGFibGVbMV0uDQoNCkhpZ2hsaWdodHMgaW5jbHVk
ZSB0aGUgbmV3IGN4bC1tb25pdG9yIGNvbW1hbmQgdGhhdCB1c2VzIENYTCB0cmFjZQ0KZXZlbnRz
LCBmaXggZm9yIGEgbG9uZy1zdGFuZGluZyBvZmYtYnktb25lIGluIG1lbWJsb2NrIGVudW1lcmF0
aW9uIGluDQpsaWJkYXhjdGwsIGFub3RoZXIgZGF4Y3RsIGZpeCB0byBiZSB0b2xlcmFudCBvZiBu
ZXcgc3lzZnMgYXR0cmlidXRlcw0Kc3RhcnRpbmcgd2l0aCAnbWVtb3J5XycsIHRoYXQgYXJlIG5v
dCByZWd1bGFyIG1lbWJsb2NrcywgYW5kIGEgZmV3DQpvdGhlciBtaXNjIGNsZWFudXBzIGFuZCBm
aXhlcy4NCg0KQSBzaG9ydGxvZyBpcyBhcHBlbmRlZCBiZWxvdy4NCg0KWzFdOiBodHRwczovL2dp
dGh1Yi5jb20vcG1lbS9uZGN0bC9yZWxlYXNlcy90YWcvdjc2DQoNCg0KQWRhbSBNYW56YW5hcmVz
ICgxKToNCiAgICAgIGRheGN0bDogU2tpcCBvdmVyIG1lbW9yeSBmYWlsdXJlIG5vZGUgc3RhdHVz
DQoNCkFsZXhhbmRlciBNb3RpbiAoNCk6DQogICAgICBsaWJuZGN0bC9tc2Z0OiBSZW1vdmUgTkRO
X01TRlRfU01BUlRfKl9WQUxJRCBkZWZpbmVzLg0KICAgICAgbGlibmRjdGwvbXNmdDogUmVwbGFj
ZSBub25zZW5zZSBORE5fTVNGVF9DTURfU01BUlQgY29tbWFuZA0KICAgICAgbGlibmRjdGwvbXNm
dDogQWRkIGN1c3RvbSBjbWRfaXNfc3VwcG9ydGVkKCkgbWV0aG9kDQogICAgICBsaWJuZGN0bC9t
c2Z0OiBJbXByb3ZlIHNtYXJ0IHN0YXRlIHJlcG9ydGluZw0KDQpEYW4gV2lsbGlhbXMgKDEpOg0K
ICAgICAgZGF4Y3RsOiBGaXggbWVtYmxvY2sgZW51bWVyYXRpb24gb2ZmLWJ5LW9uZQ0KDQpEYXZl
IEppYW5nICg3KToNCiAgICAgIGN4bDogYWRkIGEgaGVscGVyIHRvIHBhcnNlIHRyYWNlIGV2ZW50
cyBpbnRvIGEganNvbiBvYmplY3QNCiAgICAgIGN4bDogYWRkIGEgaGVscGVyIHRvIGdvIHRocm91
Z2ggYWxsIGN1cnJlbnQgZXZlbnRzIGFuZCBwYXJzZSB0aGVtDQogICAgICBjeGw6IGFkZCBhIGNv
bW1vbiBmdW5jdGlvbiB0byBlbmFibGUvZGlzYWJsZSBldmVudCB0cmFjaW5nDQogICAgICBuZGN0
bC9tb25pdG9yOiBtb3ZlIGNvbW1vbiBsb2dnaW5nIGZ1bmN0aW9ucyB0byB1dGlsL2xvZy5jDQog
ICAgICBjeGwvbW9uaXRvcjogYWRkIGEgbmV3IG1vbml0b3IgY29tbWFuZCBmb3IgQ1hMIHRyYWNl
IGV2ZW50cw0KICAgICAgY3hsOiBhZGQgYSBzeXN0ZW1kIHNlcnZpY2UgZm9yIGN4bC1tb25pdG9y
DQogICAgICBjeGwvbW9uaXRvcjogYWRkIG1hbiBwYWdlIGRvY3VtZW50YXRpb24gZm9yIHRoZSBt
b25pdG9yIGNvbW1hbmQNCg0KSXJhIFdlaW55ICgxKToNCiAgICAgIG5kY3RsL2N4bDogUmVtb3Zl
IHVubmVjZXNzYXJ5IG51bGwgY2hlY2sNCg0KVmlzaGFsIFZlcm1hICg2KToNCiAgICAgIHRlc3Qv
Y3hsLXhvci1yZWdpb24uc2g6IHNraXAgaW5zdGVhZCBvZiBmYWlsIGZvciBtaXNzaW5nIGN4bF90
ZXN0DQogICAgICBtZXNvbi5idWlsZDogZml4IHZlcnNpb24gZm9yIHY3NQ0KICAgICAgY3hsL2V2
ZW50X3RyYWNlOiBmaXggYSByZXNvdXJjZSBsZWFrIGluIGN4bF9ldmVudF90b19qc29uKCkNCiAg
ICAgIGN4bC9tb25pdG9yOiByZXRhaW4gZXJyb3IgY29kZSBpbiBtb25pdG9yX2V2ZW50KCkNCiAg
ICAgIHRlc3QvY3hsLXNlY3VyaXR5LnNoOiBhdm9pZCBpbnRlcm1pdHRlbnQgZmFpbHVyZXMgZHVl
IHRvIGFzeW5jIHByb2JlDQogICAgICBuZGN0bC5zcGVjLmluOiBBZGQgYnVpbGQgZGVwZW5kZW5j
aWVzIGZvciBsaWJ0cmFjZWV2ZW50IGFuZCBsaWJ0cmFjZWZzDQoNCg==
