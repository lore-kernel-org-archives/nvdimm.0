Received: from esa9.fujitsucc.c3s2.iphmx.com (esa9.fujitsucc.c3s2.iphmx.com [68.232.159.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BA119B
	for <nvdimm@lists.linux.dev>; Mon,  8 Jul 2024 02:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720404478; cv=fail; b=ELxxxW6aRLehnnsiMTW+wg3sCZcv+f1G+dFno7nBZKPrS1yWtGlqhpUHaSvLte5JTTAzVfsthk01gOYIA4IWaZGKZrtu+ZYlGOYn323zR/Nw3AFCrG3z+9w6G3Srri+iOwtJkvwt3SzBFrrCEieQDchbMKObqgtJn4kQeCJ42rY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720404478; c=relaxed/simple;
	bh=J63F1LL4qfAoyyxmxGAqG5jUPq7ukE0ZogCW7i/xzJ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WLXs15VXZM7ls3Ikv22a0Yl+xYlpTHTqcBDo06qnDKaEH1XmOhMe/07uiFtqtEprGsNlecMxEgZhhQIovL8W5aQTrFBADBqpQ0DN9gCIpkIy3tEoq+YBheCjxv0Qlmbz8Ib/D0AUCxiXWOkILIkmVnbzL+2H/dp1F46qtPOz61s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=aLirl4oS; arc=fail smtp.client-ip=68.232.159.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="aLirl4oS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1720404476; x=1751940476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J63F1LL4qfAoyyxmxGAqG5jUPq7ukE0ZogCW7i/xzJ0=;
  b=aLirl4oS8dUEDlbB7bPKk5HBqsiMSjJpV/uJgAykB7KAtkcZLEXNPHFl
   AyAY8x4cTYAGOXGi2TwZFUakxsstZ8s+4NTGaDNHKxVIgngojLs1xrCsO
   6fouWSOCrlByc7Zgbyx1qYpXdBHBbGq0WrNLxxPL8P0ox2Aa+ufaq8lNU
   hgMduIHF6pdREWPdRluoMEzIhTieSoCUrg8I+Kzzi7E+OhIQU10HioPrt
   Dhe6l4l0A9SJDxKbbLSj3eScvIw1vGHJVVoDiz1EOMS1iuCVyS/+mcD+2
   mfU0n/LqkWuIpUMo8kQoA76IJiRgkG84uc1OzSUEKsUYmzZfKiOGs1SZD
   Q==;
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="124601937"
X-IronPort-AV: E=Sophos;i="6.09,191,1716217200"; 
   d="scan'208";a="124601937"
Received: from mail-japanwestazlp17010001.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.1])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 11:07:46 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLXvDljcRVx43260kgNPKtyjSIjfJdV+hurBTIteUJrU+VFk/nHIzUfQLNailXnTRlu3Lp7QWmzpcZHOcZFni9iwNyRpt2ayXX3coFc4EEIC/WKffnq83xFNayggRkSWGwt7uwlbEEgwzjn4X9RrEDeb30CYz2aeHwh7B6PIOUOiD95uzo+O8OuZLObLWv7YBI4/mBbMgS6TLSkulinkik4E3rYi4YDFko9IZuu3vAEBQzwCrzw/t9rYOF3Q4yDYylKH7EoA+9NZ8eceq5QP2RmtxthmU1N6p+y2y8j5bb6pLqrlkrPAgbHgiXUQuAySfW2F4kqlKgOi+lHBhS876g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdhuQsvLMBVS4fdTQdmso3dawZdoSvZHjHyu6zk8LRs=;
 b=AAmuub88Moi/E/CyHbdlKHgfqiNkziSgGJmNkO8QuvTDQRZX0UkzgEge8JsLORPpScFQK2OXLoC5MFzzODIRpVZ0rOj4bYw8Yl04MXH04zxO4iFl0MUYDVWksm3qQalllFERWSZwOsvs4nzfaxxi9Qr25XHIZYmJzBPiw4/JQkqaB3i+ZMBuJ9VVu3RTpYyUDAM0yQGe/oq0nihbmeDD4smnkci8RBap43+0L29Fl+FMLkqKwSE+In3zTE2yu2s3CaAs9B7fDPuXPO8MPFwO20569J3u6h9oD7L/sxBA0pJpiI9FO+NKir4iCUmeNG0U5liekuToStyE4xX/rTwCjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com (2603:1096:604:ed::14)
 by TYRPR01MB12301.jpnprd01.prod.outlook.com (2603:1096:405:102::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Mon, 8 Jul
 2024 02:07:41 +0000
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11]) by OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11%4]) with mapi id 15.20.7741.033; Mon, 8 Jul 2024
 02:07:41 +0000
From: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
To: "alison.schofield@intel.com" <alison.schofield@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: Dave Jiang <dave.jiang@intel.com>
Subject: RE: [ndctl PATCH v13 6/8] cxl/list: collect and parse media_error
 records
Thread-Topic: [ndctl PATCH v13 6/8] cxl/list: collect and parse media_error
 records
Thread-Index: AQHaz21VzAphlYqVO0+0j0wIDe7KJrHsFypA
Date: Mon, 8 Jul 2024 02:07:41 +0000
Message-ID:
 <OSZPR01MB64538FDD3908A8A2CBBEDD938DDA2@OSZPR01MB6453.jpnprd01.prod.outlook.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
 <d267fb81f39c64979e47dd52391f458b0d9178e2.1720241079.git.alison.schofield@intel.com>
In-Reply-To:
 <d267fb81f39c64979e47dd52391f458b0d9178e2.1720241079.git.alison.schofield@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=e9947ab7-f36e-47cf-8fbe-1741be5b8cf1;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-07-08T02:03:28Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB6453:EE_|TYRPR01MB12301:EE_
x-ms-office365-filtering-correlation-id: 4c277d53-928a-4b36-4976-08dc9ef2bfc9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?cHNaRGplUHZJY3F0TFVRMTRMNkhCMENsb1dhN3Q2dERlTmU1SWdqR3Fj?=
 =?iso-2022-jp?B?a1V3dkNnWm5qNUxiNkJ3MnJzS3lzR0l3MXpXZ2I4SVFTcTVSNEgyQS9I?=
 =?iso-2022-jp?B?c0dRbWF2b0d4dVJzSitQV09NWnFzRFVjelNhQWYvUndUcytIRWdUaUxk?=
 =?iso-2022-jp?B?VXV0U1Z5aXA3VmRQODVSbXM4eUJUd0l4bml0azJ0RE5GY0VSMXNCaHlC?=
 =?iso-2022-jp?B?d0V1aVBjWFdsdkJ3NUdrQzMwVXNnSE9zYWZ3M3BRWjA4Z1poK0lJNFFJ?=
 =?iso-2022-jp?B?VFUzaFpmVjhQeUxQVVhMMURCcnc0QXcvem9kakVMUHZnbTh0NC9aV1Va?=
 =?iso-2022-jp?B?UGp1TldJMGs5VlhMRGZKalV2emJycklnRkxKeFo0T0hReFZQd2lOSVFk?=
 =?iso-2022-jp?B?dkZYaE1ieHRoQjgwWXJuQmhSdW1pcnFxNmdRN0lvRVUrOU5HeTVyVUZu?=
 =?iso-2022-jp?B?aDEvcHhCNzh4RzFFciszME1MV1pVenhLQWdHTXpRVHJDdnVyaDBhU1NR?=
 =?iso-2022-jp?B?ZnltR0cxYUFBQjJVaFBqaWs2OWdud21ZVStkeXQyc1pDcmNtdnRjL3Qx?=
 =?iso-2022-jp?B?dlM3NDdvVDBya3k4MkJaeUZEMjhZM0hPdDFrT0lYNElCbGs2UGF0NFBU?=
 =?iso-2022-jp?B?TmtWd3c0emJoZmxpUEhrWXNyZU13aDdTME9FOVNlWmdOYjF5VjlGYjB2?=
 =?iso-2022-jp?B?S3dzWW1kZWJSK0lpU2FRNGxMMTl0ODNhUy9zQ3d3V2o4TlZKY210QlhF?=
 =?iso-2022-jp?B?Y01UVml3OG9qbzYvdk5aekRqY2IrRzFoOERIeW8xb2hiVUVINmtseEJM?=
 =?iso-2022-jp?B?c2FjWmVHN1pHTGNwYUJmQmtCWUFRSHNiZnpWTUlVbW92RUdtaDNqVXRF?=
 =?iso-2022-jp?B?UXhXSTdidHdvSzJDaEc0TWcrV1ppc25BNWdEVmxXUGN5QkJjMkFjTm9y?=
 =?iso-2022-jp?B?ZG9vUTUwWUg5OUNZQjd5cVBrUVdLa0g2RWhIL3ZDRkRONDROdXZDUTFT?=
 =?iso-2022-jp?B?L0pXRnEyRkZpZUZsWXBzU2tsZDcwR21vWW9IWVgwVWtFdnJhNEhLNFhI?=
 =?iso-2022-jp?B?VytuNFVYVCtRUTR1SDlpK0xCTUw1WC9PZlZqUHVXbCthbUh3NHIrOUdF?=
 =?iso-2022-jp?B?aWo5MWZ0dlljbkhueHVJUlRUL1VtcTcvbDFBenczWXAwNmIwakVrdlI1?=
 =?iso-2022-jp?B?a2NjcklIZzA1RUxlZUhuUDhiRzE3MXdQRmFPVmlxUy9aQnN1VkZTRit3?=
 =?iso-2022-jp?B?Tm93eG1IcEJyMGN4VWd1UmdTcWZWVkV3cEUxTW5mSWZMZk1mM2ZLa0ll?=
 =?iso-2022-jp?B?VUJDWW50ckRtTGlzWXNUbmpPbmZhNWNpVU44T2E3MTYvanl3c28rZFF1?=
 =?iso-2022-jp?B?MVpKOE92ZkZOQ0xSR0pMMXBuemxsK0N5TmlCcUtHK1QvOHNJNTZPdEpV?=
 =?iso-2022-jp?B?VzFUaDI0dnhyL0tMMkZFc1dxMDc4MU1DQTF5YTFQTFpIVTNTKzZaSEtv?=
 =?iso-2022-jp?B?bnZyc3ltb3FQRGQzOVRxbnpSMnZNS2ZlTStIV0NlT2Z2V05VcVZqdjNJ?=
 =?iso-2022-jp?B?M1M5RGVOTTErTzYxZm5iWHh0VzdYR2RnTjdWQ0Y0WXRnTVdmUlBIajJ3?=
 =?iso-2022-jp?B?blRRWE1yVVFJTzFYbEtDRkEwRmdKNWtOUlFOdVgxNTlOM0U1ZU9tSStN?=
 =?iso-2022-jp?B?NWg0NkZUQmhIVDNPeEduT0F6Z1J0SXQzMURjd0pwZ3F3bkxXOTNtdW9B?=
 =?iso-2022-jp?B?UGc5QndYbklMNVppSUR5b3hDNmNxM3IyczU0ZEVJUVVHTklKV0RSWnd0?=
 =?iso-2022-jp?B?L1dubGRDdUZ5citycnRMUmVQUkNSSVZLMWhHR096WU1GbGhLUHptaVV5?=
 =?iso-2022-jp?B?eXoyOUpjUEZtWHQzcjdLTlExUFhEZUN0V3ZCMU13SXA0YnNva0lHK0VT?=
 =?iso-2022-jp?B?cUU4YTJTbnVvRzVraFliTmdmK1g2T2xDY1U0cFZMd05OZU5OTXNGZmtt?=
 =?iso-2022-jp?B?R2NXWjdydUEwRmZ6SzRGU3VKdk0wMzFldllTdWlVZklvQ2dOTzMwMGJr?=
 =?iso-2022-jp?B?d3lGQVJpNXJ3eU41MHNtd3RQZG01NTQ9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB6453.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?S0VWVHI3WHZDL0cvWkNxMU5UM243VUtTZEdSSW1wSnBZV1kreDh1RFU5?=
 =?iso-2022-jp?B?U1ZzbERZK2NPTHM1bUo0VEswaU1nanJTK0lmVmVtSmMvNi9vWFdmY3Bx?=
 =?iso-2022-jp?B?WDhJd1h3ZktZME1wVzlVMVh1NG5GZUFkZzI0c1ZSYnZidExmMEpzU3l1?=
 =?iso-2022-jp?B?N1VQbWZGOTdrOVpaS2NjeDRhT0hRTW52TkJRbFF5MVZHUzg0TW1mQzlB?=
 =?iso-2022-jp?B?alZZRVNOWnA0em9qV0pCdEUvSVhVTVptOXNGcTlrblZ2bytDWjNWZG1j?=
 =?iso-2022-jp?B?bEJhcFl6Y1FOQjU0SGViblllOVNxVUl5a0ZCcERNSE5hY2h4NE9vck9Y?=
 =?iso-2022-jp?B?WnVraFdGd1V6bGhLSjBBbTFrclRoTkg5VFJZR3BnR3o0ckJXOWVjQmpG?=
 =?iso-2022-jp?B?czNab1RWb2NDd1hmNlNiTEMwUzhLQzA0K0huNHM0TXBjSDJJYXl2c0U0?=
 =?iso-2022-jp?B?dnoxZUc1dUNKWFBhRGxkaXk1RGtOeFovN1ZYVU02ZnpPZVpNL2tURnkz?=
 =?iso-2022-jp?B?UTMxS0tpdjBnVHhqUDJLSjFUMzZKOHdLeXR3aW5pa2JvQkhJUUxOZ3JJ?=
 =?iso-2022-jp?B?ZjY1OStRS0Q0OHNzdnZNY0p3TXdXQStDbVRQczNqTFFTMDV0dmtmbnlS?=
 =?iso-2022-jp?B?eFptMEJYZTcrZVAwY1VxVWVuOXRidE9iUmFFSWdLVU9kZXZmNDZFU2sz?=
 =?iso-2022-jp?B?MUkyZnFiVTRSUnM5Tld0R1ZFbG5TYzRwNHJtcHBZUERhSGYyV0VGQ0RU?=
 =?iso-2022-jp?B?c0VjTWQ3bWdRQUNOMm1yY3dnelNoeXRjN2Q5TWJpaTlvcWt3V1Y5K0Er?=
 =?iso-2022-jp?B?bEdhZXJybVVOOGhGVlp5Si9ZSTJEVWorcUhOU09EeFl1UUNjTER3d2Yr?=
 =?iso-2022-jp?B?eTBxYS81NTZRTm5nRFBxZ1cwSzVPM1BjSXBjVnFENlZpMXNWVXFnc25D?=
 =?iso-2022-jp?B?SnBVeXNiNlRIRE9XY0FmNWE2R0Z3RTVyQkxUR0R5clluZS9pWE52am1w?=
 =?iso-2022-jp?B?bjFncEw0MFVUaWRERElPZDNydnFwckVMN0FlMUpwWXBwQ1YwaVc3V21Y?=
 =?iso-2022-jp?B?bGZaNkxEVTd2VFpySFRseTJWYUhSaldRbXZpSm9FZmFCQmlUUU9HUjNw?=
 =?iso-2022-jp?B?OWRWVWRvb2FjdmE1bVQ2czhCVzR3L2Q0enF0UE1EZEZQVks2MjFQT1p3?=
 =?iso-2022-jp?B?ZGc3NEZSTVFSZTFISk9BL09xTHRZcWFwMFRZQ3JkVUJEa1BiTmhXcWxH?=
 =?iso-2022-jp?B?ak52OVdDUmRScGRPUzRhZ0NOLzRNQ2taM2dlSEVacUNoS2lIZW82YW5k?=
 =?iso-2022-jp?B?ck80dlB1cnBUaVlxMElyMkpCU3MyVGhSN2p1MTQ0UzRqY0tnc0N2ckhs?=
 =?iso-2022-jp?B?OVI2VlMvUjAwblhxeE83SWRpbll3ZzNNR2p0aVhPcVBjN0prNHJnaFkw?=
 =?iso-2022-jp?B?Smt1cmppVHhBZ1VQRGpidGlBQ2RmalljYUU4NkRrWjBuL21jNi9KTHZm?=
 =?iso-2022-jp?B?dmZ1Q05WdUVRaXNsbTRGOXVtWkFaYkNINFdiSHIyS1FadjVCallVdjVU?=
 =?iso-2022-jp?B?QmtKM2MzcFdNY3lxQXJsRGJVdjI4clhFV1ZFU0xDSXBncjJTZ1lpakhj?=
 =?iso-2022-jp?B?Q1JRR3B3My8rWGwvTmRibTNTWnh2aURYSjlsQzlrQzZielZ6Zm5xSm9u?=
 =?iso-2022-jp?B?TThxZmtRS29MdnJFMTNnVGtGMFVycTlaU3ZsUFFJUGJrUHlBc3FvR0hz?=
 =?iso-2022-jp?B?V0tFeURGazEvak1nWkVjUkE4eHhHOVlFNGttMkFxMld3bVJMMUl0ZG4v?=
 =?iso-2022-jp?B?RmNJM1RVSms1TmVZaHRIdEJuZTNyeTNYMjdZZ0gyYVZQdUJVSXF6cnJn?=
 =?iso-2022-jp?B?QngxZThJbkp6d2dDcXBybFdNQm5JVVVxdTNRSnFiMUhnR0lmeTBBSDZE?=
 =?iso-2022-jp?B?T1RVYmw4YlFMbSs4YkZQeDVqKzZ6aVkxSmVLdkdLUnR1endiZ1czN1di?=
 =?iso-2022-jp?B?UEpzQW5RL1ZaajY3L0t4dVJwaUNaTHp4RG1meW1uVnVsMkRqUWdISldr?=
 =?iso-2022-jp?B?Z253NmpNWnpSWEl1Q0h6Ujd2Nk1qTTFHY3FrLzNGbVcvaFNqdzlXeE5p?=
 =?iso-2022-jp?B?ZHg2UXVXVDJSV3VaYUNUclZRZjcvbDRGUExkUy9uZTdVR3BpdUJlTFBs?=
 =?iso-2022-jp?B?ajNlTUlUZnBYMk9nY2FUamF3V2tPcnlac1huenFETHh1Q2YrRW9kd05B?=
 =?iso-2022-jp?B?TWNNdk9MWUtpTWpqMGphU2ZVM0MrdmhVaXJNMnVUakNlYVp2VEV0OTR1?=
 =?iso-2022-jp?B?UjJMbQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MCnPk2DQUtHUWyt8qtbjQGO5++SDXDxhZ6svuvnoddDXJ/m8a4AcelzFneNKphY0FRoQbLJGaAPFd88csxXNgKnUx+Sg/mn1Y3BbAMckT2vOVJvYOot6C/hXBtHhooe53IKqIQBEGvDBzwJXqRlxyzAN6F8SOMfw+eSPbr94Xm8DEmYOHPh5wLfxePK41jMMfw9r3PE5BBBYy/1M85hnLC2HW7xjm1MrRejVpweuJuMUOQeJM7dToNhC5aNlD8vgxzSiT7+6T8alKa/hDiGftsjrQ/5CUW85ZED3U77fah0LiNn22LE4CewmiVA8whrDAvIRhesjBfNnKrjgesgBwmvx/84NBjbAgS8vWuvE8uVj/7nrXjy+FqbZBR6xsHNPbm8/v8c/eVJN3WWicGQitsPaPpKEPsUC6GGZhIZOq+TK3Tk1LRtW3YVCLLWa/nXmYdN5CpAon99X/SsW5wvPFnz+FI+vg33vORB3Y0VG8S6eL4qpMgDiTLNJfvjgsznbYOJOnEthnVzUFI6y3NH+iNXuNI+B9XUpiznflaDwzIytE/V3C/xUYkH+QJmpSRkS4cnCjziTyKX+oqhfppM+bHO3oTuiRcSt6rU6iSKOVYggfcMcF27pLZ4RXATDZeYe
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB6453.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c277d53-928a-4b36-4976-08dc9ef2bfc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2024 02:07:41.6427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JtqBxloyRJuv5gj0mPmms5vSNHyurkkn8e34chq1ICIICpkxQFkFgoOKbmAFxx14YiZNtU3Sg9sxcvtrcxrSBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB12301

> +/* CXL Spec 3.1 Table 8-140 Media Error Record */
> +#define CXL_POISON_SOURCE_MAX 7
> +static const char * const poison_source[] =3D { "Unknown", "External", "=
Internal",
> +					     "Injected", "Reserved", "Reserved",
> +					     "Reserved", "Vendor" };
it might be better to use "Vendor Specific" instead of "Vendor".

Reviewed-by: Xingtao Yao <yaoxt.fnst@fujitsu.com>
