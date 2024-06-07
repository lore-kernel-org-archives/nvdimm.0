Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F4E819
	for <nvdimm@lists.linux.dev>; Fri,  7 Jun 2024 02:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717726966; cv=fail; b=GKHbV1jKhCFr7NAX3yja+SiCUiz4fZELXSWFn4fzj+WoP8GmlwLJvOJCKt8jWMLC+nnDVLTbWw1uKxXXzFbgBjRQkqRliBj+8nv99XFCCZULR75tn7VrXPiAjQvxwe3DWl/VmIpw9nEedX9IUXVfH96lUpvxUOt4kiVBLNbSXzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717726966; c=relaxed/simple;
	bh=niwegiFJlY/cAakWBWX9znkNdkoALoxjUOq2wLsCwFQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dkY3L9cXiu8mpQdOLO2W/PvkkNElNh6wReCYKsiB29+V2L3lwIFmUaHybXqL/ZPXRo/6y+YEuzPz5+YIbg7LGuaUL6lxrVJMIOEi4e/JujM1DdXzez4l2Ez2vYxrD5RoJ90aGd+dMyvLpeo1bQqKou7yBUocHORXuIyXh83ktpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=qGMZ+l1k; arc=fail smtp.client-ip=68.232.156.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="qGMZ+l1k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1717726964; x=1749262964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=niwegiFJlY/cAakWBWX9znkNdkoALoxjUOq2wLsCwFQ=;
  b=qGMZ+l1kuKl97FoH2NGRG+lTxmUXBYCKdAIBL531McDU2XZN3Nb9C9th
   AwAAxTBbb7o6u3nDra4ZwFLwqQvAjb27uwDeNGY9gpx+LJasySNDB9EnZ
   E+qhOlO54uBsuHmkssjZ5RhgkDOGjR9jdhfzNQy3gjvm4RrUHZDe1y29L
   6/0+an0aidXdDzRg2CXQ56whv3IF6MirZHtjnZTdmGZQ05s093/0HUd4e
   ip9K8oQqe/PIVQuSMoyT/WKU5yJ1SEdc70Zpuw2JEjodyq5ZtvCnRGGDS
   kESPOuqPv29EIAiQ+lil6cZ6rVc7Slzfc6Df/O546CYMTG19oeoQterCC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="121206383"
X-IronPort-AV: E=Sophos;i="6.08,219,1712588400"; 
   d="scan'208";a="121206383"
Received: from mail-tycjpn01lp2168.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.168])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 11:22:33 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ofi7l+n1lbK5Mn4rhkiC6udvxcTP5+gQ/5dF/DPNd8Gv5fwHesYvzxHDHs1un3WX/1U5GY20rbwl+QJ48myDCfTwjkonkAQaDteahASrxNqP7zPR6cybM2r4ieyPfHWgGNhiOgZIGaI9LWzIwwY8IpWI5deXP+wo2SALimja6X4/QcO7ElEqsQ4hnKm8HrBpwh0MPYbSuOXStoLU0KwIVHM3SFqwnpv//4eXyBQ/Zp/ybcIgGNXBepN+6wgcd45HAGr0TFzxLFjuTEExdFif8ZMH5B8SxF71Bk+YGgMvWUIgW/JPMvg14RITmRIQilTNoYRxX4CF4Z415gESCzH2EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=niwegiFJlY/cAakWBWX9znkNdkoALoxjUOq2wLsCwFQ=;
 b=Co1JxNV66v1w0niRT1yhV/05AZuoSFWpkwuWnXMkRGg36lfb0CLx549w6VYNHk6Yht7LlRntgqIUuRKlWq49683M69avNerZ3vY0i+5hPC5wLtPmWGZZcxh1gG2pZRHy+K4Hv0zhSGHuDQwccyvFSa5xebCH8fYdAko3E1e4fB/xZuKITmJy7g2JQox0pKpOew4ZeoyI9yjn7X+XrwY9RHydMwsEFIRQd4DwcpjIG3ykNzx/N4Wba3Z7Vfe7g7QLbVCKYKlAMApN3MG+RAPJm2fevpnmnW+fM1Wr0314+X1dTma0OG8AH8/BHoyCoOw1zvvrWZwy6C/OKUClQzUtrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OS3PR01MB8460.jpnprd01.prod.outlook.com (2603:1096:604:197::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 02:22:29 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%3]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 02:22:29 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "ira.weiny@intel.com"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: Fix devs leaks in scan_labels()
Thread-Topic: [PATCH] nvdimm: Fix devs leaks in scan_labels()
Thread-Index: AQHati2t74u/nyp7wUqtJRv05QCX+LG68F6AgACmW4A=
Date: Fri, 7 Jun 2024 02:22:29 +0000
Message-ID: <916631e6-6acf-4aa5-a406-4655a6517f78@fujitsu.com>
References: <20240604031658.951493-1-lizhijian@fujitsu.com>
 <116afccd-c817-4a45-ad77-ccc039339285@intel.com>
In-Reply-To: <116afccd-c817-4a45-ad77-ccc039339285@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OS3PR01MB8460:EE_
x-ms-office365-filtering-correlation-id: 6d451468-1218-420e-afb9-08dc8698adf9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|1800799015|376005|366007|1580799018|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?WXE0djZpcmNrNTNtSHJiT2ZsQ29VYW9tY0x5NmdjTWFYNUxWZnIvNzhRNmd5?=
 =?utf-8?B?SGNZaHFLZ1d1Vi9PbVZRbnhYWFhjQTZ0QmFvMVArc2pJVEFObWtadnppNnJq?=
 =?utf-8?B?OUpqa3dtbm1MYjdUSVFneTFFZG9CMDJ4YnhtdjRKZ0syVVhkSUVScEdXQU5p?=
 =?utf-8?B?eHJEN0lhOHh4MndYREV6VWNWTEs2a0pnZXJmdTB1cnVtSWR6TWZMV1BnYjJY?=
 =?utf-8?B?QmpkQ3BrZFZNUHFubkdVV0ZibTZDYm5UUm1KQXJ1MWR1N3RleDR5d05Nclcr?=
 =?utf-8?B?U3RSd2w2cjJMZEg2cmFhZ2R5bmhmTStCU1NrWjhoVlI3QlVlQmlDL1VSaElF?=
 =?utf-8?B?WTdQU1FqN1VzY3FVZkQ3QkVYNnFZQnArQ2txb3VCek1IVnBrRzRSYS81a1lW?=
 =?utf-8?B?U054bXFuU0w5cm51dElqSXdPMG05dEM0Z1hEc0l0WXRjdzYxRW9tZElhSjRQ?=
 =?utf-8?B?d1JTK2JzRVJkUjZDbWVlSlNXdXN4N2wvSTZzWjA5TU1pbWJTNTYrazBLZDh4?=
 =?utf-8?B?MlBsY1A2MzIwMythSDBQMG91UFNJdnBKUk04ZTJaOURLM1lTcERlTEUybTN2?=
 =?utf-8?B?ZHJkZ2Y4bUVqWmpKVFBBV0p3NHN1czR4OFlwc2N6QkNaMnlGdjNZTVFJNUph?=
 =?utf-8?B?REw1WnZEUjVpa3RpL0pldHBVTWwwS2hPOS8wYTlHc0hwNTMzNWRqd2lnd0NE?=
 =?utf-8?B?VDdUSGZCay94ME1rV0J4Nko3VkwxK1JQalRsTVVMbWg3NG5KNDhScXJ1c1JV?=
 =?utf-8?B?SlkvMFJaRVpsL1dzb1YzZE5CcFZNZ1p4bjI2WWphTWkxRnAvTjVIaVpwdTF6?=
 =?utf-8?B?Rk9ueUxhYlVselFHKzE4cHEwZ0xsZHAwL3lvNlgweFZGV3hmY0RiMnE2S2lQ?=
 =?utf-8?B?dk9WSkFJckRWUitudVFtUWZlZmk5TGRzKy9JUjI2K3k3R3Nwd0I3ckowcWxv?=
 =?utf-8?B?b1VuZDJURnhVQVQ1VThXNkZVZGFhNjV1NFpBRmR4aFNsRkg3dmhCN2NZWWR3?=
 =?utf-8?B?NHJWZC9jNHkxYVRqcGNJeWk3Qm9nWnNpckNqejZFREVTRXA1VVRPbWdQU3Ar?=
 =?utf-8?B?WE10am55UHExbExvSngvOWxQNkdONmhKaWIzY0NndVVUZHZRbFVWZ2RESlVv?=
 =?utf-8?B?b1hobjdJRWU2ekljamlTWXB1UG1HcEt1OUN6ZWZMMjJnencvSHMwcW5lT0FN?=
 =?utf-8?B?Zmp1bGtiVFNPWkxvWHNIS2JFVlVhRk1WRzhJaWJlSkJTY3dVNGU5T2xKakt3?=
 =?utf-8?B?Ny8zVitQaUtIWEpndHV6em0ya0p0dnh2NlJGQ0xFN29KZktQR25ESWVMSHBs?=
 =?utf-8?B?b25tRlMrNWMza2JKaC9mUHJlUVFOdFh3ZDVIN2V5K3dNQjNJa2pETzh2OVRa?=
 =?utf-8?B?TldTTlowTnZmaGRPbjNWT1ZVT25DK0M2REc5Skd5SzFUTkdNdTdGellqanVx?=
 =?utf-8?B?dkMrOG92WDBmY0VrOXJuTmRNZk54QTU4Ymtnakd4WUJDZVhYZ0tUbllFdkI0?=
 =?utf-8?B?U2d0cXlFbFp4MlZkb1hVYVNSZFpscVlyeCtQbnQvTURPLzZaUW5ybFBmTldj?=
 =?utf-8?B?cmhkbUdJVHlqNWVxU005Vm13L3JHb0J6SDBBSFpDUWNjc3l3ZEVITnpSZ0Zj?=
 =?utf-8?B?dXFDN0xKdGRMeDR0eFg2ek5zb2g2c0p4eUpQQlJTdlNVZFdDb3lzbHdNdEZp?=
 =?utf-8?B?Z0lQRncrZUx2OU9vS2hDdm90YXNYVjY5WGc2VE1VUWZVL0RhYUl1U21YQWNR?=
 =?utf-8?B?cytGUU91em5FaTZCNm5ieE56WkhQRlo4UXc2TmZrMi9QQ3VLdWU2dUxxYkVj?=
 =?utf-8?B?YXAxejY1bXNtQ3lDV0pxWFIzYS9DNFAxWGVoNkdsMHc3NUVzUWdiRVBCdEl3?=
 =?utf-8?B?cjFEclRwaTZJekQ3cGZaMEdudVRsek9sUUxTM0FVV2FWYWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(1580799018)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NVc1OXFRbmNwaVFOekNab1liemR2SjBZNUpmOFNQd1V2OFJ0RGY3Z3FTemth?=
 =?utf-8?B?ejlJeUhLbGR1Mk9JdVJzSXhkRmRLU255bk42UUVuMHFlSHBlVUE2b2ZHUFNs?=
 =?utf-8?B?dnVXUVB5ZVFoWEZQaGhlRERGOVAzN1F1ci8xMTR2ZnFiRVhHSXpFcmdGUkNt?=
 =?utf-8?B?aUtnWkdLU01FSVI1azhvK2xhSDJoYy8rYUk5VDlwSktkVXROcXpWTlZYRDVr?=
 =?utf-8?B?cmRHbmJZaTliOTdNNUNKdGJQOUg3ajdFeWJQd1QxRXZPN2ZoRGpGMVVxYVhn?=
 =?utf-8?B?c0Yvc1dHeENoK29sY3lJL1VVOFo3aFFUZGhydVJQV3RrY0xDRHErbHZTclhN?=
 =?utf-8?B?bkpsZGpwRzNNMTdDS2NaNTd2R2ptR1N2UjBIcUJHNyt6eDZldUV0cytOU3pY?=
 =?utf-8?B?V3JwTmNKeWQwSTRaWHZEMFFpR2p1MXVJNW1GTjhJUW1hK05vQ2tyRzNkYUZI?=
 =?utf-8?B?THZCazkwUkN3Q1RVZXgyTEpMeHA2SDJHNTVRTkd6M0t6bmhsREZTWFJnV2p6?=
 =?utf-8?B?WlVLb1hFM0lZUDRaL3gvazRrMW1TcFg0Q28vY1o3L3k3Vnk2TE1lQVZKSnNX?=
 =?utf-8?B?ZmdEcjN3MC9IZTUxdWlTUGxWVW5ZNjJuS0pYNVg3d0tzSjR5c3lJV095Wks4?=
 =?utf-8?B?NDU2a1lVWi91RVhKbHdMTDk1Sm1JZmJPbGZGRkZnLy9YVnRPbUtaNzZuVWI0?=
 =?utf-8?B?cm05NXZ0dFlYZGtITmVXSHlZRTlpbkZnRFpGaEgyZFAzWjIxazZvTnU5NWhV?=
 =?utf-8?B?TUk2Rm9LK2RFUTJvejZMcG10SVJjQTQ4MEhvKyt4ZlNySzV2TTlHSXd2SjFs?=
 =?utf-8?B?bWEzclp6N2o2MmlYRVI3M3FzRVBlWmlMSUNTK0Vxeit2UFNTZlkyL3ZmaVlG?=
 =?utf-8?B?TU9XYUM2ekNWL2hrQyt5SmZ3R1RZT3dlRThkVFBOUUFnSkNHbG10cE8rbkx4?=
 =?utf-8?B?YS9SUUwwejk1dE5uVHQwNC9NVDI5OG96a25aUzduZlNZbFowU1p3TW9ieGV5?=
 =?utf-8?B?V0JBY0R6OHdyTVU2bkh6K3JkakRxWUF4TWZhV3g0NGFndVdJK2M5b2U4anBQ?=
 =?utf-8?B?b3FIWlVLSjRPMDFCdWtodXc3SFcvdVdGbTkrcHprQnZCU1M2ZUNwUU9sQjdm?=
 =?utf-8?B?ZmJaaEZWUXVEZUIwWW9kOEQ0UlhrSG5CcWxqNlRJMUlIREU0eXh0djJzU0dC?=
 =?utf-8?B?T0VCbC9teklDb0JCKzRiRnlBZU84WVRPWlpSemVoQmNnRHU1MUtxdHhIMUc4?=
 =?utf-8?B?TUZ6UDMxT0g5c3c1YkxPRlFDclFob2lEaTRTWUxIQXBxVFN0WHBUQ3lYWkQ4?=
 =?utf-8?B?Y0ZKTU1jWVVWRCtsSlIrdXp2aWdmSWMrNUpLZXA0ODdnUmxsUTkxVFRIcEF0?=
 =?utf-8?B?OHVYdHhqOXJXWDZNOHNaRkp2K2xYVSs0QmRnTU5rQzhkNWpkcE1mWUIvK3Rl?=
 =?utf-8?B?MEtTSzdDZVVDWEhjL3BCVGR6a2lyaXZicVhFWDRiUU9tdG9OOFR2NzVoSXMw?=
 =?utf-8?B?WnEvVWczTjV5Q0M1cHp0Tm1LbFRYT20yb3B1NTkrR00raHNVMnJTZzRJQVFr?=
 =?utf-8?B?YmNjcTRJN2prUkZyNkExUDJ0Q3NiL09qMTF4ZWIxcW9WTlpiTkovb0JobE1T?=
 =?utf-8?B?WllxUXVFSytSQXNrdWpuTkhtb1RYZUk0dGVWWDhha3FXcFVZdWR1V3A0dkpQ?=
 =?utf-8?B?M3hYSnpFS3VZcXFhcy85bWZDYWR6M1R4YVFnbE1IOThsd2g1bWNiSjcwbi9w?=
 =?utf-8?B?ZXN5SXJxalhSNVhudzRUQkZGQnkwdm00c3djRWVQYm4yZlE0NWNEUElMQWhC?=
 =?utf-8?B?bjhvRU9SSVhwNlpoNHZ3eW9hTHBoUVVoVFZ1UlE4cHc0Mk5PTnpSWG9xcTQ2?=
 =?utf-8?B?QzZLYVlPQ2xvTkkraXBOc3dFU044bW45Q0tPTEFjdStDcWQrU3dEMVQ1Zkta?=
 =?utf-8?B?OGkyQXlKLzJFekszMWRPMWNINVAzaWZXWGoyTUJmbitydHp0L1VSQlQ3RWFa?=
 =?utf-8?B?VGxZc2k3ZmRoaEF1OEViaWNqcW0rQTIvZWNWdzJQY3Fodm9ocFptRzZ4ZjRN?=
 =?utf-8?B?ZUFOQnVIa05XMXJZYU1nTGRmQW81NGVJaUc3cm96dmRKcXZEbGZTRnU5Rmd5?=
 =?utf-8?B?WGJ1cG8rYytXSlBTMks5M2hkSmF5WU5UZDBFRHdsM2l2NHlMVHJZMkcwdTEr?=
 =?utf-8?B?TFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FB20F3FD5C9DC429BF0F644E6049811@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D4fzfMIo8MXFJhrz/IKAuFkdOPdL8DbTayhLqEVf4MC5ZBzkk5oyqQnXhS31zeXUd8As6MT7zQ5kMg2AJHq04IprBYfLII0bYPQBypUZZrGiKwxjiNYscmeQ87dmZoUcTJZkc0TqfbxkxeJCGzPYpppg4kmd7FALwzFeQrQdWJPkzMoRkMaxuVIXnlFZQLFFl3Dy+FVfRrKhlDEaLMqaKUnK+cdzQsrbBDGexf2DCaPO96ULiFXuz2JoQKUBENYabAtvlsh2OjV+LRfKV81/LA6gRmB+S7cDuuRe1Rx3dwRp4C6RkvziH6xODAbloW7Oxm29ClxDMiBKJdeLVLM28DWZkLELSWIcP6t8e86YFRV8T7j/pGbvVJzWaoJ/Yray4Nvjh5rZhNULTGQ55pxqKUlzEQnqZqcBnOhXK22eqNAD7yoAX6Pe5dvxAm7QBLbW+79yLFxQ/UYq/Bbu/j58ZvVNb8+M08zXPrDj6NlqC5FHZuDm/se8pHEvLYH4UF4i8gyBsTVrwysCDxlUCjyeAOZp8ClSv9W6GJ84Xt0wpkl/9S9L4PKkGoLXwbc/zQOZ5ZkaEg/BqLGyhdPpURubPX8vnZ5ODEw2wxu3P6V9gUkp7Qp2Ns8fDaqN2knb4DFf
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d451468-1218-420e-afb9-08dc8698adf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 02:22:29.1364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S1rmnUSSIF0AAvwWHmTfAYLCdXKTkbBNne4p87cTSp6paIN8AgprBszXRpFFChK63wrBBHJquPIvmDFFiB4hCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8460

DQoNCk9uIDA3LzA2LzIwMjQgMDA6MjcsIERhdmUgSmlhbmcgd3JvdGU6DQo+IA0KPiANCj4gT24g
Ni8zLzI0IDg6MTYgUE0sIExpIFpoaWppYW4gd3JvdGU6DQo+PiBEb24ndCBhbGxvY2F0ZSBkZXZz
IGFnYWluIHdoZW4gaXQncyB2YWxpZCBwb2ludGVyIHdoaWNoIGhhcyBwaW9udGVkIHRvDQo+PiB0
aGUgbWVtb3J5IGFsbG9jYXRlZCBhYm92ZSB3aXRoIHNpemUgKGNvdW50ICsgMiAqIHNpemVvZihk
ZXYpKS4NCj4+DQo+PiBBIGttZW1sZWFrIHJlcG9ydHM6DQo+PiB1bnJlZmVyZW5jZWQgb2JqZWN0
IDB4ZmZmZjg4ODAwZGRhMTk4MCAoc2l6ZSAxNik6DQo+PiAgICBjb21tICJrd29ya2VyL3UxMDo1
IiwgcGlkIDY5LCBqaWZmaWVzIDQyOTQ2NzE3ODENCj4+ICAgIGhleCBkdW1wIChmaXJzdCAxNiBi
eXRlcyk6DQo+PiAgICAgIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwICAuLi4uLi4uLi4uLi4uLi4uDQo+PiAgICBiYWNrdHJhY2UgKGNyYyAwKToNCj4+ICAg
ICAgWzwwMDAwMDAwMGM1ZGVhNTYwPl0gX19rbWFsbG9jKzB4MzJjLzB4NDcwDQo+PiAgICAgIFs8
MDAwMDAwMDA5ZWQ0M2M4Mz5dIG5kX3JlZ2lvbl9yZWdpc3Rlcl9uYW1lc3BhY2VzKzB4NmZiLzB4
MTEyMCBbbGlibnZkaW1tXQ0KPj4gICAgICBbPDAwMDAwMDAwMGUwN2E2NWM+XSBuZF9yZWdpb25f
cHJvYmUrMHhmZS8weDIxMCBbbGlibnZkaW1tXQ0KPj4gICAgICBbPDAwMDAwMDAwN2I3OWNlNWY+
XSBudmRpbW1fYnVzX3Byb2JlKzB4N2EvMHgxZTAgW2xpYm52ZGltbV0NCj4+ICAgICAgWzwwMDAw
MDAwMGE1ZjNkYTJlPl0gcmVhbGx5X3Byb2JlKzB4YzYvMHgzOTANCj4+ICAgICAgWzwwMDAwMDAw
MDEyOWUyYTY5Pl0gX19kcml2ZXJfcHJvYmVfZGV2aWNlKzB4NzgvMHgxNTANCj4+ICAgICAgWzww
MDAwMDAwMDJkZmVkMjhiPl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDFlLzB4OTANCj4+ICAgICAg
WzwwMDAwMDAwMGU3MDQ4ZGUyPl0gX19kZXZpY2VfYXR0YWNoX2RyaXZlcisweDg1LzB4MTEwDQo+
PiAgICAgIFs8MDAwMDAwMDAzMmRjYTI5NT5dIGJ1c19mb3JfZWFjaF9kcnYrMHg4NS8weGUwDQo+
PiAgICAgIFs8MDAwMDAwMDAzOTFjNWE3ZD5dIF9fZGV2aWNlX2F0dGFjaCsweGJlLzB4MWUwDQo+
PiAgICAgIFs8MDAwMDAwMDAyNmRhYmVjMD5dIGJ1c19wcm9iZV9kZXZpY2UrMHg5NC8weGIwDQo+
PiAgICAgIFs8MDAwMDAwMDBjNTkwZDkzNj5dIGRldmljZV9hZGQrMHg2NTYvMHg4NzANCj4+ICAg
ICAgWzwwMDAwMDAwMDNkNjliZmFhPl0gbmRfYXN5bmNfZGV2aWNlX3JlZ2lzdGVyKzB4ZS8weDUw
IFtsaWJudmRpbW1dDQo+PiAgICAgIFs8MDAwMDAwMDAzZjRjNTJhND5dIGFzeW5jX3J1bl9lbnRy
eV9mbisweDJlLzB4MTEwDQo+PiAgICAgIFs8MDAwMDAwMDBlMjAxZjRiMD5dIHByb2Nlc3Nfb25l
X3dvcmsrMHgxZWUvMHg2MDANCj4+ICAgICAgWzwwMDAwMDAwMDZkOTBkNWE5Pl0gd29ya2VyX3Ro
cmVhZCsweDE4My8weDM1MA0KPj4NCj4+IEZpeGVzOiAxYjQwZTA5YTEyMzIgKCJsaWJudmRpbW06
IGJsayBsYWJlbHMgYW5kIG5hbWVzcGFjZSBpbnN0YW50aWF0aW9uIikNCj4+IFNpZ25lZC1vZmYt
Ynk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2
ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2cy5jIHwgNCArKystDQo+PiAgIDEgZmlsZSBjaGFuZ2Vk
LCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9udmRpbW0vbmFtZXNwYWNlX2RldnMuYyBiL2RyaXZlcnMvbnZkaW1tL25hbWVzcGFjZV9k
ZXZzLmMNCj4+IGluZGV4IGQ2ZDU1OGY5NGQ2Yi4uNTZiMDE2ZGJlMzA3IDEwMDY0NA0KPj4gLS0t
IGEvZHJpdmVycy9udmRpbW0vbmFtZXNwYWNlX2RldnMuYw0KPj4gKysrIGIvZHJpdmVycy9udmRp
bW0vbmFtZXNwYWNlX2RldnMuYw0KPj4gQEAgLTE5OTQsNyArMTk5NCw5IEBAIHN0YXRpYyBzdHJ1
Y3QgZGV2aWNlICoqc2Nhbl9sYWJlbHMoc3RydWN0IG5kX3JlZ2lvbiAqbmRfcmVnaW9uKQ0KPj4g
ICAJCS8qIFB1Ymxpc2ggYSB6ZXJvLXNpemVkIG5hbWVzcGFjZSBmb3IgdXNlcnNwYWNlIHRvIGNv
bmZpZ3VyZS4gKi8NCj4+ICAgCQluZF9tYXBwaW5nX2ZyZWVfbGFiZWxzKG5kX21hcHBpbmcpOw0K
Pj4gICANCj4+IC0JCWRldnMgPSBrY2FsbG9jKDIsIHNpemVvZihkZXYpLCBHRlBfS0VSTkVMKTsN
Cj4+ICsJCS8qIGRldnMgcHJvYmFibHkgaGFzIGJlZW4gYWxsb2NhdGVkICovDQo+PiArCQlpZiAo
IWRldnMpDQo+PiArCQkJZGV2cyA9IGtjYWxsb2MoMiwgc2l6ZW9mKGRldiksIEdGUF9LRVJORUwp
Ow0KPiANCj4gVGhpcyBjaGFuZ2VzIHRoZSBiZWhhdmlvciBvZiB0aGlzIGNvZGUgYW5kIHBvc3Np
Ymx5IGNvcnJ1cHRpbmcgdGhlIHByZXZpb3VzbHkgYWxsb2NhdGVkIG1lbW9yeSBhdCB0aW1lcyB3
aGVuICdkZXZzJyBpcyB2YWxpZC4NCg0KSWYgd2UgcmVhY2ggaGVyZSwgdGhhdCBtZWFucyBjb3Vu
dCA9PSAwIGlzIHRydWUuIHNvIHdlIGNhbiBkZWR1Y2UgdGhhdA0KdGhlIHByZXZpb3VzbHkgYWxs
b2NhdGVkIG1lbW9yeSB3YXMgbm90IHRvdWNoZWQgYXQgYWxsIGluIHByZXZpb3VzIGxvb3AuDQph
bmQgaXRzIHNpemUgd2FzICgyICogc2l6ZW9mKGRldikpIHRvby4NCg0KV2FzIHRoZSAnZGV2cycg
bGVha2VkIG91dCBmcm9tIHRoZSBwcmV2aW91cyBsb29wIGFuZCBzaG91bGQgYmUgZnJlZWQgaW5z
dGVhZD8NCg0KdGhpcyBvcHRpb24gaXMgYWxzbyBmaW5lIHRvIG1lLiB3ZSBjYW4gYWxzbyBmaXgg
dGhpcyBieSBmcmVlKGRldnMpIGJlZm9yZSBhbGxvY2F0ZSBpdCBhZ2Fpbi46DQoNCisgICAgICAg
ICAgICAga2ZyZWUoZGV2cyk7IC8vIGtmcmVlKE5VTEwpIGlzIHNhZmUuDQogICAgICAgICAgICAg
ICBkZXZzID0ga2NhbGxvYygyLCBzaXplb2YoZGV2KSwgR0ZQX0tFUk5FTCk7DQoNCg0KVGhhbmtz
DQpaaGlqaWFuDQoNCj4gDQo+PiAgIAkJaWYgKCFkZXZzKQ0KPj4gICAJCQlnb3RvIGVycjsNCj4+
ICAgDQo+IA==
