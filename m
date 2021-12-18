Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B62CA8
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 05:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639804509; x=1671340509;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=BFL7flyDbziuoAcTlyWIdkLXOI4mGoJHqLdnDCtXZ7Y=;
  b=B26D0f2itTMNshCpjjXGlpmwvT+BT5C3k9tJQTQDBvYsSp3qpWKYNHhd
   nIcY5QPWMgOnKBS2cXIJXiWVAv35CeXxnEy/9p45Y2dBZ6Cy2XIFhxUxr
   3UxAOsF0zEb7GGsMAWZQYA4ZV0aeILmIGGZ1FE8TgFK2/TB7B/lz3PQge
   kRvFL/q3rvTJ0UtEBDmTt3sYxvf+X+z/vAFDfvevLeoHqjxSUAh+aSIvd
   PEeJcMpAv4YY2IXiSf25oQw6ibJH55fvhbRtcmEvyGjYnrcaKUnxzvqno
   PNNsjCy6QtBOq/AGL9se2IiO5IQnthyYmv0itmDxuoW8Jk9cewEKtGLWU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="240111767"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="asc'?scan'208";a="240111767"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 21:15:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="asc'?scan'208";a="606104717"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Dec 2021 21:15:08 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 21:15:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 21:15:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 21:15:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUoisEXAI8evN/741/b5DJerpVpY+v2nZq0oCsTFLhua98zDAETs4RswiYxf4TCJYW+wrntclhwA0xvqdMkXWkYm+XWlQLLJmiAxqfr8TddM5X9647izdwNPoiptBYbrWVMjCfcD9V/tBsndqVkj+hG4tE+MeSM/+uXQ08yJiRRlM6GVayGYXj4Qq9zG2+7qFnRvXphnS8VmNFu0O2sRjce/ivAQOk+mkXMfO1OYIA5IOOiWjDdNy8/f72zG6OZeuCwF5pWeykZHWQ35W9+zyBeYpf4E+UuhXUETYMd6gP4/Hi6OJX4VHwEytzQCUVSnQO5lw1RDFoUglvrJBxueqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXMhKc9J9Ykc4ET1exZKBPHefS+M/DqMfPV5nIEZ8ts=;
 b=d1b/p5Svx51mBorhw2iFKASDWEVN2Z47hnv/VzMZ/Kmn91IRdB8gjG1/BTuahTv/jiUW+/j9NGRAdGyBqQfE2dAIos7oaVMHs2n5f/38AEwPITHd9569DN1XsVsOODWh1FIcm3fu0CApQ5nZvMkxsIgbSpOvBTq1j1SSS2zW8rzZggOoPL5gq0vxpzDN1WtO0no8lcVdDvTarOl+/TLqXe+uhQZ9eDztAq2dL4lbyWCZxKt3+v2Vsw0chEPO3RB0avQ83j7nUYLbIvf3nVCBCBY+QOlj+snPYgsA19mafXqp210kOv9SYLx3EBdn8ySwKnpGDCj4tHaqlk0icQ15Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3776.namprd11.prod.outlook.com (2603:10b6:208:ee::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Sat, 18 Dec
 2021 05:15:05 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 05:15:05 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v72
Thread-Topic: [ANNOUNCE] ndctl v72
Thread-Index: AQHX8843LA4xrafDJ0SFQLzVA3gisg==
Date: Sat, 18 Dec 2021 05:15:05 +0000
Message-ID: <287fb6eb401bcd07db3bcadd14404e227816533d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87d5ce0a-90ee-4c34-ca11-08d9c1e55a19
x-ms-traffictypediagnostic: MN2PR11MB3776:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB3776F13BF7F2256AEABECD22C7799@MN2PR11MB3776.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 09Xx0rqQNbyhusfghVxErYxh2gQPINwUWzsU8nb70PodGvcXvUjhqqkReyYMspI0hPVQ/ux9k8w0bdrJ9UMrwgx5u8rjAqQwRLjm2vPYdlBfM3R0DsOvKljbBHNqkaIH8gKeCS3x+Mx3Q4z1kzHheHcOpo+2vcj3LgCqnBfqYEVkRC15ijsgZweEO8SRHfL4tpRW3tsrNMKsx/Mq8vmIj5p8BoqCq5Wu4wbAMVE+rT7tYTteCgSrX7g4mPva0CTLwSdlkSGD7yzAcNLBVAvxxwcDVCZftZuG9eaS7RcYaab75jcLQDJ05JJUmkOt4ITF4hQlmCn8BwrO7XGelOXwQ0GzywZ2G9fxgFWg47QOIufhUt9ma2oxYV/oONUQAIMyzzjvlc+EvMl0l0dwpvBCQFQDordnHN1onte2WMCJbD0M1wT4ks3XqPMZsa31WFS7pYaXT26wspEAVfXW/yw+2frxNzwNVK7QmL3TVukl/6uKmd9t+EoQcD3XaSTRD6jZgRVjznSqpvdY12P7xbjPqy+duv+Ma3MldAkLCfvHYzlwbgfKP2z/JBjLFGXoMGS/u0zEVNlSBYRYpQjrLX/E388ZvzQcONXfgH6Q8I3nrBlJiUqTMFp9TFD5Y5JGCRfnUE0JEE0Vv/ArwD9V9zyQ8ub4Plm2+LqUUh1BcV6MkZ2I359J4Z09p0oFFb8ftS42aD6fJw41ifORJyQTTOrqnjjkbDOi4b046VhxdZ67y+hculHDCmNOXhveBpAOGVcjK2wDryEqgm8IUTGleEIbyyxWl0fRRrLmWy6yLf+M4go=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(66556008)(64756008)(91956017)(66446008)(5660300002)(316002)(71200400001)(2906002)(66476007)(86362001)(66946007)(6512007)(38100700002)(122000001)(6506007)(38070700005)(6916009)(26005)(966005)(6486002)(2616005)(36756003)(8676002)(99936003)(4326008)(82960400001)(508600001)(8936002)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SE13VzlZVUJ3Mk5OaWdBbCt4UFQrZU5CMXpPdkdkRERCZUppNGRSaWVGc0Zm?=
 =?utf-8?B?bzNmb2R4Mm9qTjJJRkM1NG43NXh6YnV4amxyendnMDhlNEM5Z05qMms3WjRD?=
 =?utf-8?B?akNXYXQ2SjdFcTYwdWk3aGt2ZlByUjdVdUUreUQvSmYvbDB4SnMzRDYvUDlC?=
 =?utf-8?B?ZlNDTmV0NmZSTU50bWVnTG96UXcwOENjUVpEb3lUbnFEQzE5ZVFOVFZjem84?=
 =?utf-8?B?WGVFK0dQd01Namwremtab2o0WE5tUEVZdVd5QzcrNlBVOGhlYmxBNEdobmtB?=
 =?utf-8?B?eEhwZGExZW0wYUh4MjFuVnIvZHVkcUJIYTRzUmxHMFdqVExwVTZmam44eG9n?=
 =?utf-8?B?NzdHTVJNZGYycHcrWWVWbDB5VytlZHpYaUs5NWsxMGxCWUVmakZWVWZpSDEz?=
 =?utf-8?B?aHdSYVowamt2NS91Y2xRZEthNEJ0ODg3N3ZHYnNmMktka0dxWm10a1U0aUdF?=
 =?utf-8?B?S2JNZ1czaFJsM3NST25SbVBEY09jWmVSQ3dzYktpTHFjcTVyc20xc3MzWUFn?=
 =?utf-8?B?NHc1M3cyaWduNnpxbXRkcGlZaXBTSlZVYkw3SUlRTUNQYjFZT1MxcSs5RDRp?=
 =?utf-8?B?Qzlyc3djWHZJTzExYXUzY1VQa21JY3pIN0hYSmpmeG1CZHR6MHRwS21PMGVO?=
 =?utf-8?B?QVZweXBJYVRFQnlqUG54R0Y0MU1udm9ieVozNnFGSzkwNWdIaFV0T0l4Qisz?=
 =?utf-8?B?UFo4Y2JGaXNNOTdzODR0NzRtcXBqMnU4bEN2ck5rUWw3Uk14TWlpQ2Z4OUV1?=
 =?utf-8?B?K3BnNUtLeG9VbGJVdEQ1UDA4QnJMSUVpcHd1OHlUdHFtaU5LZmdOaXEwR0ly?=
 =?utf-8?B?cm5CQzE4Rk0rdFF2eFNQOEdIcTN4REQrRU1sdEFKWTJrOXZFUCt5NUFuMkpG?=
 =?utf-8?B?Y3p3alZGMTFWN0w2eHQrNzZEaGpkSCtJQ1FQZWZ3NVJVMExjbnRaK1FkVElm?=
 =?utf-8?B?TjVIMUFFNW5kTWNQMG5jM3dQVDRnM29YY2ZwblpSR3F4aitzR1ZCTjZpTzhK?=
 =?utf-8?B?MzhTMzlpZ2xsSFk0WEpPbmI0ZUNzaHI0Qzk1NWFxdk1YQmZHTktueWNkWS9h?=
 =?utf-8?B?aDBOcDd2ZTRYTkkrenRQMFhRNjVROWxyV0FBajZJL1JrYnEyZk5LTzBzNTJN?=
 =?utf-8?B?M1ZYck5Ec1JhYVJDTi9iRXdRUGovWDVsRW5UZVQvRFEyM3Q4S2Q5dVM0UlNY?=
 =?utf-8?B?KzNsRlNCMUtkZERQZmZCR1hTRGxIY3JwdjYxS1RQcDhSZ1RnWGtQRTQrVkp5?=
 =?utf-8?B?TjdGbzVsOGZUcThtZFNDSEhKbGgyak1nK3VjT0MvUHc0bE9ZbVkyMjRsZXZM?=
 =?utf-8?B?QzA2QjR5dzZDZlVZbGVwQnRTaFRyRVNUNGFSWGVqUWZQNlNiQm0valNaczBk?=
 =?utf-8?B?eWhsUUpBbitmYWxTSDI5ZjYzZUV4S1hmenN6RnIrM0ZlNUZUYUk0bHFnTmx6?=
 =?utf-8?B?VWwrb2dKOWpxVGE3UjdmcWR0OHdoaVkvdS9oTXhwZ0k2NDd2Q0ZQVEZWbWox?=
 =?utf-8?B?ZHQzd1NDUnI2cC9GK0RXMENLeERGTE5LOVhXSmE0ZlpqaVo0Ty96c0N3L0dL?=
 =?utf-8?B?TGZyYXpIajgzK3ZmRDRxY2JaWW1IdW8xK1Qrc1JHTE9wUjRjWFRsaTFHZFJj?=
 =?utf-8?B?T1BtZ2ZxdGxsU2ZZa1BVMDZIRFB1aVVhZDNIclRpb2pnVFBZdmNKNEdUSCs0?=
 =?utf-8?B?THArY05YbTFhN3J1RnlCdlVaLzdmTGFtT0pGeFhKbVZFZ2tzSlhINlVOOGpD?=
 =?utf-8?B?bHVRNHZ4dmlIQU4zSFRMcUpOV1ZqRHROS05pWEc1Q1A3cjdkUXg2a1dsNE0w?=
 =?utf-8?B?b2EydExPY29uZStXV3g0VFlrNVBCWktkdUZ4ek9aQ25qaE1hck96NHNDUjcy?=
 =?utf-8?B?Y0pnM25VTGxpYUZ0bWNkQUpiU2tCMWh1STZRdmVxMTN4d2J6TUV6SVJRYXlK?=
 =?utf-8?B?VEVvVlVDWlkvOERqeWtYSzFEMitHcVdFZURIamVmVlU1MEkxeERsUjV0bDhu?=
 =?utf-8?B?dS9pdFM0NEpzbHAvaWp2MW04TVdka1EzTjFxMUcxSnROUHArNzNBWk5sejV0?=
 =?utf-8?B?NHVMVmp3bDhxWThyN0xGNm1NV05TQi9lcGdDWVNZb1VNSDhDQU1VODhPTUtl?=
 =?utf-8?B?MWR2WmVDcDR5M3Y1Uy9veERIWVVzMFNuUXp4TUs4V0Ezc09BRzJMR2Z4RnBE?=
 =?utf-8?B?dWhRL3d2a2wweFN6dFIzZVNwUkVTZnR6dXpKeDlaYkw0Z04zTVNZUVRxWHdk?=
 =?utf-8?Q?tqBiwyWKgTTaal1FeR+V5PtcH1g8aZR0W6voqG8vbM=3D?=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-nFjWZEAtQeJmZhxARp1r"
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d5ce0a-90ee-4c34-ca11-08d9c1e55a19
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2021 05:15:05.1377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GDzxzv6ViyWcIRzPNI4bPZrsx1IvupFfKxEMBmTrc7GwbQJic8vBww2UrfOX9TFer+BsV9xRk/Vk5ZFb5Q2d+eh7McbEQKzAYri3sA2QgIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3776
X-OriginatorOrg: intel.com

--=-nFjWZEAtQeJmZhxARp1r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A new ndctl release is available[1] after a short hiatus. Expect a more
normal release cadence to resume after this.

This release incorporates functionality up to the 5.16 kernel.

Highlights include a new utility and library for interfacing with the
'CXL' drivers and devices, a policy based configuration mechanism for
ndctl and daxctl, fixes, test updates, and general additions for the
PAPR family of NVDIMMs, more seed device accounting fixes, misc unit
test and documentation updates, and fixes to NVDIMM bus scrubbing.

A shortlog is appended below.

[1]: https://github.com/pmem/ndctl/releases/tag/v72


Dan Williams (9):
      ndctl/dimm: Attempt an abort upon firmware-update-busy status
      ndctl/test: Fix btt expect table compile warning
      ndctl/test: Cleanup unnecessary out label
      ndctl/test: Fix device-dax mremap() test
      ndctl/test: Exercise soft_offline_page() corner cases
      test/libndctl: Use ndctl_region_set_ro() to change disk read-only sta=
te
      ndctl/scrub: Stop translating return values
      ndctl/scrub: Reread scrub-engine status at start
      daxctl: Add "Soft Reservation" theory of operation

Ira Weiny (1):
      ndctl: Add CXL packages to the RPM spec

Jane Chu (1):
      ndctl/dimm: Fix submit_abort_firmware()

Jeff Moyer (1):
      zero_info_block: skip seed devices

Jingqi Liu (1):
      ndctl/dimm: Fix label index block calculations

Michal Suchanek (2):
      ndctl/namespace: Skip seed namespaces when processing all namespaces.
      ndctl/namespace: Suppress -ENXIO when processing all namespaces.

QI Fuli (6):
      ndctl: update .gitignore
      ndctl/test: add checking the presence of jq command ahead
      ndctl, util: add parse-configs helper
      ndctl: make ndctl support configuration files
      ndctl, config: add the default ndctl configuration file
      ndctl, monitor: refator monitor for supporting multiple config files

Redhairer Li (2):
      msft: Add xlat_firmware_status for JEDEC Byte Addressable Energy Back=
ed DSM
      ndctl/namespace: Fix disable-namespace accounting relative to seed de=
vices

Santosh Sivaraj (6):
      libndctl: Unify adding dimms for papr and nfit families
      test: Don't skip tests if nfit modules are missing
      papr: Add support to parse save_fail flag for dimm
      Use page size as alignment value
      libndctl: Remove redundant checks and assignments
      namespace-action: Drop zero namespace checks.

Tsaur, Erwin (1):
      Expose ndctl_bus_nfit_translate_spa as a public function.

Vaibhav Jain (1):
      libndctl/papr: Fix probe for papr-scm compatible nvdimms

Vishal Verma (31):
      daxctl: fail reconfigure-device based on kernel onlining policy
      libdaxctl: add an API to check if a device is active
      libndctl: check for active system-ram before disabling daxctl devices
      daxctl: emit counts of total and online memblocks
      ndctl: Update nvdimm mailing list address
      ndctl: add .clang-format
      cxl: add a cxl utility and libcxl library
      cxl: add a local copy of the cxl_mem UAPI header
      util: add the struct_size() helper from the kernel
      libcxl: add support for command query and submission
      libcxl: add support for the 'Identify Device' command
      libcxl: add GET_HEALTH_INFO mailbox command and accessors
      libcxl: add support for the 'GET_LSA' command
      libcxl: add label_size to cxl_memdev, and an API to retrieve it
      libcxl: add representation for an nvdimm bridge object
      libcxl: add interfaces for label operations
      cxl: add commands to read, write, and zero labels
      Documentation/cxl: add library API documentation
      cxl-cli: add bash completion
      cxl: add health information to cxl-list
      ndctl: install bash-completion symlinks
      scripts: Add a man page template generator
      ndctl: Update ndctl.spec.in for 'ndctl.conf'
      daxctl: Documentation updates for persistent reconfiguration
      daxctl: add basic config parsing support
      util/parse-configs: add a key/value search helper
      daxctl/device.c: add an option for getting params from a config file
      daxctl: add systemd service and udev rule for automatic reconfigurati=
on
      daxctl: add and install an example config file
      libcxl: fix potential NULL dereference in cxl_memdev_nvdimm_bridge_ac=
tive()
      util/parse-configs: Fix a resource leak in search_section_kv()

--=-nFjWZEAtQeJmZhxARp1r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQT9vPEBxh63bwxRYEEPzq5USduLdgUCYb1uVwAKCRAPzq5USduL
dnqMAP0WB6vIgJe60q8Osj2H4LD8aRg9hhmCKyamj3sdLa3vuQD+PRM6eHhYwm3e
9aqttBlkLhxpAC0B54cgV6F9XCo51Qw=
=KC4I
-----END PGP SIGNATURE-----

--=-nFjWZEAtQeJmZhxARp1r--
