Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C0038FD
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646693410; x=1678229410;
  h=from:to:subject:date:message-id:mime-version;
  bh=KBH953ovLu8NKPZKlA6aucArDn5aTsmIziQlUHzX5fM=;
  b=hg/MPLVwX1Q2fIdChWf0vHlvg92X9ME7nbaCeV7Rd+7V96YcGif1unod
   uI+78gmJSf23VFd0oyUbR9y7FC7dp1XciD0MayexNCPWM8o8MhwZrJgWs
   F0gqF1Wjz6pR7ctSZ4B3cfT6qxo7lGexD3ZRfpnvyQQFGqK173F/JNlt8
   wryQXpFNBQcfeeRnaw0YT6hUBoL5nx/AQDD5xKng3SEHD3K1ciPj9XXrs
   P4Vi2VMQu1jyjZoZ9RlPvzcjkK5Qx7aHwoOb7PY+MurFIaTfCiZnb4TFn
   Au9A+gV0dkhbXynTdPkM5F8uL/YAr3Uknp83ChBTFE2vGZih0p0VCuA6U
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="252100944"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="asc'?scan'208";a="252100944"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 14:50:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="asc'?scan'208";a="509876853"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 07 Mar 2022 14:50:08 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 14:50:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 14:50:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 7 Mar 2022 14:50:08 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 7 Mar 2022 14:50:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSrSJ6MmLXErRN8Hhh3ap3kAKcE6YW9yaQkBKzjKgsjzHrTqaD8J0hHurTRLx652NEOQCVf6ffwtgZ7dyyo/X4TKHTt8oJlLYKIaf34YsAtCtu598dQgx3+AwXCqTM6860gUISwsHMVu3+YVIg/N+/H0Clee6Dj6bfm7LCzi44+yaK67Viz0+9rGkfgrsXawzKi3z12rc66T3sb+2Cs9V8lZjrVWwsUs8wLRthanZ3n0+Vamn44jqwSq0rrX4COEYSQZRa5IPOthLcTMtZDf1Wb41Y+bsGXXi6FMD7upVCGH8kJ7VTrcAWqb4G7cGvcZW6r0xW0F6Nb0qwnf5EaMMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUGlI8pCGydMwIJAGAne5NakpCQfbcQBitZVIzp9oaI=;
 b=V6g0Jy/msVc0HgoSy1c7dZ9kJm066KJ8NEnrBNbINn1wXlgLQAL3XgHTfw88mh8D6W+HO2CQfdSqzHsxslEto0wSVXtZKqTgVbtZPZz8YhXR+28Bqz8ohKK4c12/ro2kyZEBxTH+gTPiVjSJjrRINqBRneTNrhGVcDUMwuSQyTWIIIzuZaVWk9CdnjY7VYrC+IpFjMESusH40GmUka2b9dZXMHeb2Rp26b/4gvWTjqVLhr193/UikV3idIb3Fr40N6CbP032XlpF9r3EvYsFN2gDEXecdu8nVxH4t2qs23sVnMvhQ9CkFK+vUB6wj3IdWF6OLK9Pj06Gf2OVFL2eNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BYAPR11MB2744.namprd11.prod.outlook.com (2603:10b6:a02:c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Mon, 7 Mar
 2022 22:50:00 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1%6]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 22:50:00 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: [ANNOUNCE] ndctl v73
Thread-Topic: [ANNOUNCE] ndctl v73
Thread-Index: AQHYMnWsq8bv32b5L0CkeNwqeBzLpQ==
Date: Mon, 7 Mar 2022 22:49:59 +0000
Message-ID: <463edbb8e97b4df27ed61e580e5d1b84e0a0970b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf4e7b21-9c59-41a1-bfa8-08da008ccf88
x-ms-traffictypediagnostic: BYAPR11MB2744:EE_
x-microsoft-antispam-prvs: <BYAPR11MB27443AFB21197BA457229248C7089@BYAPR11MB2744.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NHAiaPFkjEBCEz214hkOZjIEwjnEXzuu+biiosbvJga4eizP7iVHXvZCmhAh5PzBU43EmUah2ZNyj+GrxHLno7T62XNFM1ZFKsszX+s1eooeTO4QwmB2W9d+2x4lOijShCUUp43SsGztYbkGwLV5O7FUi1yP+nlfjnjkHh3en5YCoH57duItFiopiEkBSWxMpX4VfwhYR0RO5d6iPDEmsXYMPZohRf0AkBL1ika8uTQeBQ6Qn+4l9XNv46Ti0gpL+FhBWUkdK+mzVeCf1nf/uDRNlj7Hn0rIWV3H+5fmkSsm+I7rz7hTO9d8bIuUEQ/aQDMv8V3ZblxY1PNiLMVU5disUKuH8B3uUEXELOditKmOD2ocFKBgWUm3g+L7AH3sLsjH7yigQJkxXXbMqnIxoixxE5wrFNVxbLWok2VLirrhwjX2QbYavtDU+Z3RmtXwo7hStvKmQvN41bn17TBb2uysIAoZZS7TtwJn64lgZaiugEbvevPg55V9OiLWFekRQ4Y99qIrB+Q/MlMrw/Alko9/dbxR3XN8E7qkSfCDrFI9fHLjHsmBTZsg1lPmND7HHWeT6HYW/+tKZuElDPnvORkeYV+vFyW9am2lQo8wk2EV4gCBXKMRkpQDqvnR/69/keWqcaUjxBcidhKE4a0dz8+Ns9PpP3AjA5m+mpvuDCtAOYclgFqCuTXCtLTkHrxoDNccqAI0CDWsFVUbR9x2YA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(82960400001)(38070700005)(2616005)(186003)(6512007)(26005)(2906002)(5660300002)(8676002)(64756008)(66446008)(66476007)(66556008)(86362001)(83380400001)(66946007)(76116006)(91956017)(6506007)(110136005)(316002)(8936002)(36756003)(6486002)(508600001)(122000001)(99936003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFdWeVBub0t0Tzh0R3o3cVkxRHMzSDI4UWdKUHhoalhsZ2Q4dlZhazlaQXZ0?=
 =?utf-8?B?cGZCMzAzQWxVemN4Q2kweE5XZG1naGFYU2hCSngrdDB5UHU0VDNybDdtR3Vo?=
 =?utf-8?B?b2pURzljamNrRkp0anJUaUlVRHNVc1ZFSithclRqRnIvK0NWWThWcGpIWkky?=
 =?utf-8?B?RGMzbHF1cEVzZnFMOVVaK08yYnhFOE8weitSd1QzT1FEbTV4ODRoN1lRNExm?=
 =?utf-8?B?NDlSOU5XOGQ0dDlkd2N0V0Zna3oyaXo1Z0RqZlh4ZG1qV1B1TVBFNENsaUo0?=
 =?utf-8?B?bUZHalE3RTM4NU9tZFlBUmh1aWdLNytvbHFZbUhCTjJ0NDJlblRvYUwwbmlQ?=
 =?utf-8?B?MDZWUVpqV3F1akJpR0J2Y2Z2aVZNNWRrWEVFaTYrbWpISU94QkpPT0EvejVO?=
 =?utf-8?B?Q0V3S3YwZlp2MW5IdWJoYUtERlM3N05TQTloeWJmdnV4cDVHSTZYUGlpVjA3?=
 =?utf-8?B?eTdsUXM5Q2pLdW9yS0ZHbm80YlA4VG0yVEU5V3ZLQm83RzdpV1VEUnJra1Zk?=
 =?utf-8?B?SEJIWHlCUHkxKzVTeCt5TlRjSDV3VmdZU3VadU1VNXFFWUxZUEpGbDYwcFc2?=
 =?utf-8?B?eW9qMWgzVGRiMFp5QXU4ODRZTUtQNGRyV2NrNzRYSm80dnJYaUtmY0lzNUFk?=
 =?utf-8?B?eDQvYTZEWkczSFBWNlgwQnRQRXJUSE50OHUrTkJPNXlRWlg5cEhkT2Mvc2pP?=
 =?utf-8?B?bWtZTFNDWmp1MUFqU29RdjIwQUhzQmNLYzV4bkRVTkQ4QS9WQWVZZmpJQ1pE?=
 =?utf-8?B?VDhTOCtnd0Y0cS9MNUtrQjAzSEtnbm43ZUZReU01KzJqY2ZmMlBNdnB2Zmxv?=
 =?utf-8?B?M2xzWEZ4VW1kVFhsV0lvRFVBUVRJL0ZJUS9GTVFDcmRUYVNxR0Z6K214dGlo?=
 =?utf-8?B?Q1p4Rmw1QmN1czZCd3J3ZGt0SlgxVktxTEl5UlVLSEw2MWRnQmJLR2JSYzBY?=
 =?utf-8?B?dkdLRHh1dzd2U2RyRHhYTFppaGxvWS9kYmdvWTBKczRHUkp5NVVvelh6RTF5?=
 =?utf-8?B?NnNCc2xxdTRBb2FRNnA1S0Y4V0ZlRFd4NkRndEczdnRBODJTZ1hZNGxKZUl5?=
 =?utf-8?B?NCtiSkJ2Rm5qbitVWXVmZ3kzQ2U1a3l3Z1YyZ1FUSk41Y0ZOeG9FUUo0N2dk?=
 =?utf-8?B?djhFOVEwMFpqSlJTM3pEWHBYdHRKcmgvWE10bWNBZmVVOENjWjVucVBTOVkz?=
 =?utf-8?B?ZnFMeWw3ejU3L2REUjh4ekpSa0J4OUlDSThLQVBDS0RlL2FkS05qdlkyWmQy?=
 =?utf-8?B?dWQvNEdyTGhXU09ZbHRxSWVPVGhsUkEwOVQwUTVjT0NZOXNwMU5hOGpyaGl4?=
 =?utf-8?B?VEVoQWI5WXQ0M0hIRnNYdDltRGp5azZyYlpkNkVVVVg5dWk0RFUydmxRalhy?=
 =?utf-8?B?ZjQ4ODdyZVRtQ0hDOVRmVlNoN2ZuVXFlS21xNFhuSEtSeTZsMGtXeVpuam93?=
 =?utf-8?B?bnZ6ZXlvS2xqNnNlWFFxcElHbDNZRCsycnRlS1lTZ09FaWJvcWE0eXZXd3BV?=
 =?utf-8?B?bklGZERKNG82dml3aVE4aEdpK2dkNHpmWWRJcGFqRGllMDNTRlVlWTk4bnBw?=
 =?utf-8?B?dWl2WnpqTUs3T2Juc2FpQWdVdll2Tzg2Y1A1Y1h5SitWOUdqcXhJTEhMd1Q5?=
 =?utf-8?B?aW9OK25XVFhKUVc4bnNZSHA2Um5IQ1YrR01GZDlIVWdScHpVRURISk9HWFo2?=
 =?utf-8?B?QXFKNHlhU01uT2tFUW1HdGZMZGJyN1BDcG1EbVMxMXZlcVVlVlJRckZrTWM4?=
 =?utf-8?B?eDBSQTFkR0VGeXJxTTc1b0VZWGhHM3RlNXdva3FOV3h5RDcxZDJTSlZpM21p?=
 =?utf-8?B?R3VnYnBiWVdzQjkzQjNCeUJwaGNURzdhUVV2K2t2RTNRL0J1NWMzUmlrOWlR?=
 =?utf-8?B?TkRScm00VXhhMlc5QjRsWnpPNm80NzNNWkdXWlRFYjJaUU9OczVSZHRETFZF?=
 =?utf-8?B?QmxPajNlWC81c2pMZVpPL3N2Q0J0cTBmekt0TG1vSVlvNTVZaHVray9FTjNM?=
 =?utf-8?B?Sk80Z3RVNjBPSGZJUGQ4OEhYM1BsMS9RQVd2WE9zRzQvVTFMWGs0aDQrU1Ju?=
 =?utf-8?B?UktpZmtXalJmMFpFYkdNR2xUYkgwTXowbmpoTUxtdU8vTDdlblMybllLMGQr?=
 =?utf-8?B?SWRyMXphcVZFUnZvOTVTVG5SaGtKRXRnWnNZdHk5SDdMQldtS0p3enV2VnFD?=
 =?utf-8?B?a2ZhN1l1M0FwK3VlK0xHUHhXTkVWcDl6U2VUMCtOUGFtMnA5MjNxRVhjSUU0?=
 =?utf-8?Q?PkrCcycjukC6VS7dIvTlVbTLKbqmxb5fhnxeE1xKlk=3D?=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-LwXJDothEIo5Z2+fbvV/"
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4e7b21-9c59-41a1-bfa8-08da008ccf88
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 22:50:00.1894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcO7vqwJ7+nsScgxuX0u4WQotc5JmavqHgIFYFzewmbyYkS3F0juGXFqG+n5paLPJPNttfEh/4WdaN8E/6LcGaQ9Ws2ShmTGZDaC0uqqv24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2744
X-OriginatorOrg: intel.com

--=-LwXJDothEIo5Z2+fbvV/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This release incorporates functionality up to the 5.17 kernel.

Highlights include full CXL topology walk and filtering in cxl-list, a
new cxl-cli command to set memdev partitioning info, several unit test
fixes, conversion of the build system to meson, smart error injection
enhancements for 'papr' NVDIMMs, and RPM spec fixes to support config
file migration, and flatpak builds.

The shortlog is appended below.

Alison Schofield (10):
      libcxl: add GET_PARTITION_INFO mailbox command and accessors
      libcxl: add accessors for capacity fields of the IDENTIFY command
      libcxl: return the partition alignment field in bytes
      cxl: add memdev partition information to cxl-list
      libcxl: add interfaces for SET_PARTITION_INFO mailbox command
      cxl: add command 'cxl set-partition'
      libcxl: Remove extraneous NULL checks when validating cmd status
      libdaxctl: free resource allocated with asprintf()
      cxl/list: tidy the error path in add_cxl_decoder()
      cxl/list: always free the path var in add_cxl_decoder()

Dan Williams (55):
      ndctl/docs: Clarify update-firwmware activation 'overflow' conditions
      ndctl/test: Prepare for BLK-aperture support removal
      ndctl/test: Move 'reset()' to function in 'common'
      ndctl/test: Initialize the label area by default
      ndctl/test: Skip BLK flags checks
      ndctl/test: Move sector-mode to a different region
      ndctl: Deprecate BLK aperture support
      ndctl/test: Fix support for missing dax_pmem_compat module
      util: Distribute 'filter' and 'json' helpers to per-tool objects
      Documentation: Drop attrs.adoc include
      build: Drop unnecessary $tool/config.h includes
      test: Prepare out of line builds
      ndctl: Drop executable bit for bash-completion script
      build: Add meson build infrastructure
      build: Add meson rpmbuild support
      ndctl: Jettison autotools
      ndctl/build: Default asciidoctor to enabled
      test: Add 'suite' identifiers to tests
      ndctl: Rename util_filter to ndctl_filter
      build: Add tags
      json: Add support for json_object_new_uint64()
      cxl/json: Cleanup object leak false positive
      cxl/list: Support multiple memdev device name filter arguments
      cxl/list: Support comma separated lists
      cxl/list: Introduce cxl_filter_walk()
      cxl/list: Emit device serial numbers
      cxl/list: Add filter by serial support
      cxl/lib: Rename nvdimm bridge to pmem
      cxl/list: Cleanup options definitions
      Documentation: Enhance libcxl memdev API documentation
      cxl/list: Add bus objects
      util/json: Warn on stderr about empty list results
      util/sysfs: Uplevel modalias lookup helper to util/
      cxl/list: Add port enumeration
      cxl/list: Add --debug option
      cxl/list: Add endpoints
      cxl/list: Add 'host' entries for port-like objects
      cxl/list: Add 'host' entries for memdevs
      cxl/list: Move enabled memdevs underneath their endpoint
      cxl/list: Filter memdev by ancestry
      cxl/memdev: Use a local logger for debug
      cxl/memdev: Cleanup memdev filter
      cxl/memdev: Add serial support for memdev-related commands
      cxl/list: Add 'numa_node' to memdev listings
      util: Implement common bind/unbind helpers
      cxl/memdev: Enable / disable support
      cxl/list: Add decoder support
      cxl/list: Extend decoder objects with target information
      cxl/list: Use 'physical_node' for root port attachment detection
      cxl/list: Reuse the --target option for ports
      cxl/list: Support filtering memdevs by decoders
      cxl/list: Support filtering memdevs by ports
      cxl/port: Add {disable,enable}-port command
      cxl/list: Filter dports and targets by memdevs
      build: Automate rpmbuild.sh

Jay W (1):
      Update ndctl.spec to allow flatpak builds

Michal Suchanek (2):
      config: deduplicate monitor sample configuration.
      spec file: Add configuration migration.

Shivaprasad G Bhat (1):
      ndtest/ack-shutdown-count: Skip the test on ndtest

Vaibhav Jain (5):
      libndctl/papr: Add support for reporting shutdown-count
      libndctl, intel: Indicate supported smart-inject types
      libndctl/papr: Add limited support for inject-smart
      ndctl,libndctl: Update nvdimm flags after smart-inject
      util/size.h: Fix build error for GCC < 10

Vishal Verma (5):
      ndctl: add repology graphic to README.md
      ndctl: update README.md for meson build
      ndctl/test: make inject-smart.sh more tolerant of decimal fields
      util/size.h: fix build for older compilers
      scripts/docsurgeon: Fix document header for section 1 man pages

Yasunori Goto (1):
      Documentation/ndctl: fix self-reference of ndctl disable-namespace

michalbiesek (1):
      daxctl: provide safe versions of iteration API

--=-LwXJDothEIo5Z2+fbvV/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQT9vPEBxh63bwxRYEEPzq5USduLdgUCYiaMCAAKCRAPzq5USduL
dtCbAQD6XW65ba6Fm9GZgMTtvsBunCOkc+i4i8dw87q/uMGA+wEA2EE50PKhCX3e
FpTa0L5OJDY7+z2YDjFNkbtyOVNkiQk=
=K9qb
-----END PGP SIGNATURE-----

--=-LwXJDothEIo5Z2+fbvV/--
