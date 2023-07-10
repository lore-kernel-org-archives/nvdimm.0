Received: from esa19.fujitsucc.c3s2.iphmx.com (esa19.fujitsucc.c3s2.iphmx.com [216.71.158.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0BD101C6
	for <nvdimm@lists.linux.dev>; Mon, 10 Jul 2023 13:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1688994390; x=1720530390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9rRkHNNCEoef57/TgVJfDXr5ho7mSQ7/rlQ86KaEdnM=;
  b=ocXISyHtR5z4kVmV8+fruCyRivcOac3TwqKvQDERxi5NhEgPxsDPkRu+
   j3KQcNxcDrhKKyQvmdmJYtkNID0wByNTtbzs6IT7I4vIYFhKjm9XL/QWL
   mj/osNqm7V+gRup9kki12BvULcdxhe578j2xMLX581/U5s5Hc+92D9WqG
   +NdRl0ZYZpcGDL0eZEH+H0lqvYQ9Y/BZ4cXPqQ548JUhOIiDwB5hEw1FC
   /g/opEjEcbT/2zPp6UKKszlLIdmYBwufcdbP7vUpf4wZRdTnM35/JieaA
   sk5cPMEvQ0kndjIn34qVXfWdIJFIHLZqpH6PkYt4vsiwKa5LlBFjO5XnW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="88871562"
X-IronPort-AV: E=Sophos;i="6.01,194,1684767600"; 
   d="scan'208";a="88871562"
Received: from mail-os0jpn01lp2107.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.107])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 22:05:16 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWv0pVh1f36HI8nWrnO/hS+lqaUNv9Pd9ItqjUgwYn3nyatj8UEMu8NF5E2ypTRODW9kX9C2ajvZEm0E2/CRivK3+F77CBefCCN2d5pGqKiyCFdcCa1ds9DxUWwNV2MNEZKFMO4yq0hQYYM9jxUt5kRW9rOjrD10KteV6Ku7lfQZGZd1Kk3ASg/J/A++y6WjhVF8ix1W/REY/dYAKdNq8PsIeIcPTTcBrzzB7NNKwoqcIGD9cGiHBSLJFwkjCKw56KgXkZsHh1EKMbfG2q2ROhy/oj8+hoiLMvBzHf4vyBb5hRht5nsfekAgSmba9cSXQmFH8Xwa0ueJadJuVdavgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rRkHNNCEoef57/TgVJfDXr5ho7mSQ7/rlQ86KaEdnM=;
 b=R5LdY1oWeZhFRLGsMl7mlIyx9EntRzIWXg2z5FTlAZkD+egpFbuND86B0PN/4GuGzECuJpzKHIF6OPiV+fxpoUh4xbUCOcoaL8/QxDAtLd1uPg5UVp5pVZbyEyJT3s9hZgja1YGMi6FlNXrQxzgeaQJvw1Hrwc5ekrk66dbsMI/QpYZaaaGOHVebWrRIkw0d5KSbfOfv5v0Gnac5LODwctA5PyMPveSCqpnMkgFXLsBtfOug/JzOudMl6K8JjTajdVV5zaO5z9XH6W5Lwbg5AZFgsD9676krVW07vCYVomzaCifCXV0ZgThVKl+q5lyIFHAgGEVhHLh71RLFen+mDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com (2603:1096:604:247::6)
 by TYVPR01MB11200.jpnprd01.prod.outlook.com (2603:1096:400:364::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Mon, 10 Jul
 2023 13:05:12 +0000
Received: from OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91]) by OS7PR01MB11664.jpnprd01.prod.outlook.com
 ([fe80::6d6e:460b:60f2:8d91%7]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 13:05:12 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 4/6] cxl/monitor: always log started message
Thread-Topic: [ndctl PATCH v3 4/6] cxl/monitor: always log started message
Thread-Index: AQHZk2Zfd+sXSUoREEeOSPCM2zLqz6+r5T4AgAdSRQA=
Date: Mon, 10 Jul 2023 13:05:12 +0000
Message-ID: <98fe9476-f659-d4b7-3a6d-f93e058ad9d6@fujitsu.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
 <20230531021936.7366-5-lizhijian@fujitsu.com>
 <4c2341c8a4e579e9643b7daa3eb412b0ac0da98a.camel@intel.com>
In-Reply-To: <4c2341c8a4e579e9643b7daa3eb412b0ac0da98a.camel@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB11664:EE_|TYVPR01MB11200:EE_
x-ms-office365-filtering-correlation-id: 1a45deff-e395-462c-8a09-08db81464bc3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Wbc3kZGkRKhKo2y1Tn9XydGgwJqHwdSlJocfA36AHkLitUri8g6RQKY8wyjs55By9dtgVPhVdyyqUE9qmjftCjoovNtZkbEvcUSEJuirEzbfDdlbNjFpabK9LkOOXmGcv34c0U51OrwiTBhAmdgm8WE8DZK3GbMGB20KDBfrhCvq2gjEOwEWptT+NlKMzqXv+icwOzanfrEXCAoS9sv73ZzZiYi7MbkhVh3X25NhgwRTQp1g7UQQQbREjhOz2CyLwTs6m6TkfvQnfezTjIuruOEFuxCKpn5j9pK8m4NzntxUzXV2uUPqswEgqE8KNugiSy0UnNwu96jsW6RTLOgmoNrr2R5Nzj51V5WL5amyp5wf7NnF8eved3+c7wcsvlDAIZMjlfFOuUlGKXjg0TGzriSagemyJM93h+R7bqzKUHl+JDPfD3edKiCBNEIzGCSrp6YTIpOOK/WBcRPwbiV/MBzOlRhVVoSuJ0wovCPPIvacYc11itQGQkl3qdF3W9VAihaZ1MCkxbOWSW7VaraPjVZ2Bpy3SWiYr31Yz6BT7qQMktpRNkYgeUhRdCLomo/IpcwCt+nn2wH2YvoUM2W6OV/HrwCnlvKjxMzW4AFXIGXDWAlsRjaxLCKwythc30VPq1ugHFyk6QIcEdRTsrpaWbI6U+9IDbn4TSA6/5AvAm0EjTCO++sOt+7yJxU+sQkeGoguDFDOxz1zewwhUjXDzg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7PR01MB11664.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(1590799018)(451199021)(86362001)(31696002)(38100700002)(38070700005)(82960400001)(31686004)(1580799015)(36756003)(85182001)(71200400001)(6486002)(110136005)(54906003)(76116006)(91956017)(122000001)(26005)(6506007)(186003)(6512007)(2616005)(5660300002)(2906002)(66556008)(316002)(478600001)(66946007)(8936002)(15650500001)(66476007)(8676002)(83380400001)(4326008)(64756008)(66446008)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UFBmaG1TVzlDYTM5NjM5NVJ2enVFUUpVYk8wQUs5UkxRVlNOaWJsb1E2d3BQ?=
 =?utf-8?B?M1d3MHplOVdKT21zK2dsRVh1L1JJbFVoZ21NVnhKZm0xUlV3WGFyK1h1Q3pn?=
 =?utf-8?B?UnZJcFBoOHg4djNlV0VsYTE4YVFkaFhFRHdUTmhXcU5QdWdvZkgwdzZVYVht?=
 =?utf-8?B?ZWdqTFNKYWdJN0VKZkRQOW5TdUYxWlhZQjY1WldNakZmT0FvcTRzV1VPRGZ4?=
 =?utf-8?B?L0ZLV01FcnVHL2dzQTA4WjhrSFdzUFV4UVFudjRRTEZwbEU1VWJDNW43SGdk?=
 =?utf-8?B?bDZkZzk0bHgzUW1jaXhlM0FONlJPbWJZUGlVNzh6clNpUi9QbmZQYzdubks5?=
 =?utf-8?B?ZTdOT0FMdFN5V2NMMGl6UFZTRkZRVlF2a2Z2bkJlSzN6S1c0RHJMY3FnY3NM?=
 =?utf-8?B?OVJPTUFhNEVKa2lhMU5IV0x4SEJidWVrYTU3SEZaNUpzeUNXT3U3b1hZZEpQ?=
 =?utf-8?B?UWh3TDg4aUpmTDNWckxPZUFvcVlrVjUxbVBZOGQ2S2hHbkhncFlxWmFHUk5q?=
 =?utf-8?B?cmVjdFlKTXFNZ3MxNzJDV1hzMmI4dGdUdW10bDB2Z2VBaHhhaDhMK2ZpQVEy?=
 =?utf-8?B?VVNISWQrd3Q0VlN3WG9WdjNxaVNmdFlJbFg4WDBDZnRIQWRUbDdRS2h6eXgz?=
 =?utf-8?B?SEUvL3F5dEJGbDNJUEt3V3VUNGlkOUhrOWhMYVJ4NzFmeEpjMmhVaVNsbU0r?=
 =?utf-8?B?cmk1Ny84OEZSM2cvamlxUi85c3crbFdNSFNDbDlzeG0rUHVpK0FmRnRnN1Rj?=
 =?utf-8?B?SklaTFMrZlNzMHdYQXlTQitRaUIydmRQMzVPTC9iVGE0YXJkV3BtTVRoYmcw?=
 =?utf-8?B?b3RDZU5GZzJOdENOZU4yWVJQVWNzT201cStuYU5Na3MzMGRFcnVUYnY3OHNo?=
 =?utf-8?B?OXJ2RG94Z3BQUnlmbEkrZWNKa1Q2WW9TRmZHaG5xUEdkRy95QkRNSnJWY21q?=
 =?utf-8?B?UytWY1kvZkdxWVZoZmlMdWh3MFlFODZUbTVPQjNWS1BFWDk1biswYjg2RHU0?=
 =?utf-8?B?eW5QQy91d0JIZXNRTXNpc2o0YTNJbUpHaDJLc2NtZkZMNmpSUjBBUWVZVDZU?=
 =?utf-8?B?cHJ3YzdvczdaTVJrT3hKbFdPRXBLMjJkekJZWk9HbHdWUXV2OS9jdExENVFS?=
 =?utf-8?B?aWZJYkJuZDdreGU0aCsySVZlOWdmSWhBSnJWc1J4bzY0VFYwZEwrU20vekR4?=
 =?utf-8?B?RDErRXMzai9xSVdZWnUrMW9Fd1RUMUxqU3JJSGlwMHRmd3Q3OGdPRitidG82?=
 =?utf-8?B?SEQ0d3JXdFpyS0tNbk1MUTRFdmpDRStFRnY3d2o2QmRIZEZOUHZUeXk2b0hK?=
 =?utf-8?B?U1laR21jQnRRYWd1MkcyNXF0TjZrTzNmdFBrMksyTG1HMDhqVERPbGZTSlZy?=
 =?utf-8?B?TzZoVVpjZDZSMkdiYzJ2ZExyTWpZY1cwU21iWlRKNXJYeWhZaDh6OEJURkp3?=
 =?utf-8?B?RTZ0bzkyRytpQ3M0RmFEYWFaNUVJU0NtcXRiSVZjYVRtWTVvOXhEU2tReWVQ?=
 =?utf-8?B?cFlNemY3aWRKUXJlWUthUlgvYXdLR0tpSFVoZFREVStSWTJDWmdMTnFibzRt?=
 =?utf-8?B?L2JyZ01pRGhQMkJHSlhUZ2tERDhKMU92c3FYVW8yZHIxNlhUNU01MU91VVc5?=
 =?utf-8?B?c3h5MXNkMjJBRmN5Y3MxZlN6R1dUWlJkUDRiY3dPbVJPM1EzU2pXQld5cTlr?=
 =?utf-8?B?L0pnTE5VbVcwWDhDT2RBWWJ0am1mR2M0bkVTcU1JZUFiOHM3SDkvZ0VhYXM3?=
 =?utf-8?B?RStKdzNNQnBzMzN6UUR6OWRRY3pJa2xBYkRZTlpxcFltQzY0QThMTDYyVmpa?=
 =?utf-8?B?bG1qbldVUmlQdE5UdFcrMHdwVU5WT2RHWTN4N1h0cEtOMGhFUzZMRWErR1Zn?=
 =?utf-8?B?SmZPRVJIZEVlL2VEckVRTUlRNnJKa0psNng2L2R6WUIwRkd3SmNwSFZZYU5i?=
 =?utf-8?B?cXkvc1VxN2JtbG5GNzAwem53TlBBZ3RheEdqbFNJWDBGRkNOVUxaaFAyd003?=
 =?utf-8?B?c0Y2WnRlZHFzZmRUZnR4VExOWHRPYU8xQ3FXczBSSUhNa09XSU82dW9rZWEv?=
 =?utf-8?B?bC9vYjg4bGpkTE9CR2xhM2RtMlJGcUdEV0haaGU3UWFxK2dWNFpvUExQMTlr?=
 =?utf-8?B?ZzZRSzBEdFdUTUc5TithRFFWbGJocmtXRFJKSjJlVGs3UXcrNTNzTUNYUTZl?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6A76EA6317FE0488AB489F435CA916D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	INMm0fnHFhXR6w9AD4iP4CU6IL4yeLpro/MGMJZGr7w9PZUB7m+7FWGtrUz59dVWZZmVGe1z81xUbAvWt3Ap/mqBkKyp3F5g11vCPdXpgAGFV9dE0eRgcv1fPICPIvTtjy1fkyi5lNWVdVNZTUIJv+QoRfHxBEZP4C8dkdPw+PTlp6vrDRln7TcqR8fV99KaUA525bxCPvhpIPozzgiVDyHEfvLU0ejz4ciueP2sDpFoU+h99+LYG7Ix02is+6euvJvS5OYFFc+DewcMiTFF3Yie8k9KeMy5UnF7C0D7j/51eoTDkQSNJQlWFyoqBw6/pdhvwTERheJhBncXTEEqNUZ7gos3liNJInUHb8Xft+ksghnxhgIyCd7OB6xv8M7JmPshxq9n+0s9ECy+esUBOKgY6DJFnpOz29YSMq+XqFgJK+a5/EwXDmFz/o79rfOQjv+o5I65LtzQmuK15bOlUdQL4MNP6QFXxC+QIYSaI/8WD80L/DA57rVYXrLFlQYvm5IFyMw9tUjK/LsOzcywqLJ7G6NVE0iuwMlSiFx4aDIRBkvNOI9KCLlqWtBkIzcs5nWNXVnuxLzhC/G1j4AoCLXf2UTAfdNaf1u+ygXFQNxtnoZ9QqsDb6tSr3AeuFm/EFcE3tyuIqW8WwkXUDemLnMyvcuTG6B36I0G7mJphAw+AY7Cwg2gYo3cna5jDFISjKDgtwTHJdJcR/+cZZEC5Zvm1i2NPunz8/cmMWjHNBEj9RK4XjPSg8CNaArl0bM/6IQeyaZab8AEJNExqN2A4cnR4fItQ2xaga0u+Z5yfwKtdsbu7LJaviM2+JROQXaiKA19eHfhJc3CbLUpuIKXLg==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB11664.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a45deff-e395-462c-8a09-08db81464bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2023 13:05:12.1248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kDmw+uXjmKPpo4mqYF+6fGf5cp84px7NhNOweHi74ryf3M0rz/qHxdjRlq4gDwOx/RBeBXMTA87uut/Gd5ExtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11200

DQoNCm9uIDcvNi8yMDIzIDU6MTYgQU0sIFZlcm1hLCBWaXNoYWwgTCB3cm90ZToNCj4gT24gV2Vk
LCAyMDIzLTA1LTMxIGF0IDEwOjE5ICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPj4gVGVsbCBw
ZW9wbGUgbW9uaXRvciBpcyBzdGFydGluZyByYXRoZXIgb25seSBkYWVtb24gbW9kZSB3aWxsIGxv
ZyB0aGlzDQo+PiBtZXNzYWdlIGJlZm9yZS4gSXQncyBhIG1pbm9yIGZpeCBzbyB0aGF0IHdoYXRl
dmVyIHN0ZG91dCBvciBsb2dmaWxlDQo+PiBpcyBzcGVjaWZpZWQsIHBlb3BsZSBjYW4gc2VlIGEg
Km5vcm1hbCogbWVzc2FnZS4NCj4+DQo+PiBBZnRlciB0aGlzIHBhdGNoDQo+PiAgwqAjIGN4bCBt
b25pdG9yDQo+PiAgwqBjeGwgbW9uaXRvciBzdGFydGVkLg0KPj4gIMKgXkMNCj4+ICDCoCMgY3hs
IG1vbml0b3IgLWwgc3RhbmRhcmQubG9nDQo+PiAgwqBeQw0KPj4gIMKgIyBjYXQgc3RhbmRhcmQu
bG9nDQo+PiAgwqBbMTY4NDczNTk5My43MDQ4MTU1NzFdIFs4MTg0OTldIGN4bCBtb25pdG9yIHN0
YXJ0ZWQuDQo+PiAgwqAjIGN4bCBtb25pdG9yIC0tZGFlbW9uIC1sIC92YXIvbG9nL2RhZW1vbi5s
b2cNCj4+ICDCoCMgY2F0IC92YXIvbG9nL2RhZW1vbi5sb2cNCj4+ICDCoFsxNjg0NzM2MDc1Ljgx
NzE1MDQ5NF0gWzgxODUwOV0gY3hsIG1vbml0b3Igc3RhcnRlZC4NCj4+DQo+PiBTaWduZWQtb2Zm
LWJ5OiBMaSBaaGlqaWFuIDxsaXpoaWppYW5AZnVqaXRzdS5jb20+DQo+PiAtLS0NCj4+IFYyOiBj
b21taXQgbG9nIHVwZGF0ZWQgIyBEYXZlDQo+PiAtLS0NCj4+ICDCoGN4bC9tb25pdG9yLmMgfCAy
ICstDQo+PiAgwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4+DQo+PiBkaWZmIC0tZ2l0IGEvY3hsL21vbml0b3IuYyBiL2N4bC9tb25pdG9yLmMNCj4+IGlu
ZGV4IDE3OTY0NjU2MjE4Ny4uMDczNjQ4M2NjNTBhIDEwMDY0NA0KPj4gLS0tIGEvY3hsL21vbml0
b3IuYw0KPj4gKysrIGIvY3hsL21vbml0b3IuYw0KPj4gQEAgLTIwNSw4ICsyMDUsOCBAQCBpbnQg
Y21kX21vbml0b3IoaW50IGFyZ2MsIGNvbnN0IGNoYXIgKiphcmd2LCBzdHJ1Y3QgY3hsX2N0eCAq
Y3R4KQ0KPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGVycigmbW9uaXRvciwgImRhZW1vbiBzdGFydCBmYWlsZWRcbiIpOw0KPj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Ow0KPj4gIMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQ0KPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGluZm8oJm1vbml0b3IsICJjeGwgbW9uaXRvciBkYWVtb24gc3RhcnRlZC5cbiIpOw0K
Pj4gIMKgwqDCoMKgwqDCoMKgwqB9DQo+PiArwqDCoMKgwqDCoMKgwqBpbmZvKCZtb25pdG9yLCAi
Y3hsIG1vbml0b3Igc3RhcnRlZC5cbiIpOw0KPiBBY3R1YWxseSBJIGRvbid0IHRoaW5rIHRoaXMg
bWVzc2FnZSBzaG91bGQgZ28gaW4gYSBsb2cgZmlsZSBhdCBhbGwuIEl0DQo+IGlzIG9rYXkgdG8g
cHJpbnQgdGhpcyBvbiBzdGRlcnIgb25seSBpbiBhbGwgY2FzZXMsIGJ1dCBpZiB0aGUgbW9uaXRv
cg0KPiBsb2cgaXMgbWVhbnQgdG8gY29udGFpbiBzYXkganNvbiwgc3VjaCBhIG1lc3NhZ2Ugd2ls
bCBicmVhayB0aGF0Lg0KDQp3b3csIHlvdSBhcmUgcmlnaHQuIEknbSBmaW5lIHRvIGRlbGV0ZSB0
aGUgbWVzc2FnZS4NCkxldCdzIGRyb3AgdGhpcyBwYXRjaCBzbyB0aGF0IGl0J3MgY29uc2lzdGVu
dCB3aXRoIG1lc3NhZ2Ugb2YgJ25kY3RsIA0KbW9uaXRvcicuDQoNClRoYW5rcw0KWmhpamlhbg0K
DQo+DQo+IFJlZ2FyZGxlc3Mgb2YgdGhlIGZvcm1hdCwgdGhlIGZhY3QgdGhhdCB0aGUgZmlsZSBp
cyBwcmVzZW50IGlzIGVub3VnaA0KPiB0byBzZWUgdGhhdCB0aGUgbW9uaXRvciB3YXMgc3RhcnRl
ZC4NCj4NCj4+ICAgDQo+PiAgwqDCoMKgwqDCoMKgwqDCoHJjID0gbW9uaXRvcl9ldmVudChjdHgp
Ow0KPj4gICANCg==
