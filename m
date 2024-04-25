Received: from esa20.fujitsucc.c3s2.iphmx.com (esa20.fujitsucc.c3s2.iphmx.com [216.71.158.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAED3B29D
	for <nvdimm@lists.linux.dev>; Thu, 25 Apr 2024 05:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.158.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714023061; cv=fail; b=B3559aLfrH4tVooXJMrxpS8DPgedDHp9G90E03P9suHmyYq3L32GWhSfEztmECRvQyyb1dPRHyjrPydTMsOryrSqEVBQIkbudKWs4ZwoBF9tCepQphCEm3zEvb2k8OO2fDo13MbwoeGoy/ttEiiaqXEq5FaIxzVTI37XGvYyCHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714023061; c=relaxed/simple;
	bh=kkqwiiYDmLCR4kulj2yYcpiHQ27SQLDs4SHwXzq9apg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fc0CoUdivsC7YppTHVG0EhxBymWths8VbOeRCEDCmAUbdeGdrhHrQ1pS6MPPsDfdx0yXt66rW/+RVgmf804uAMUtebBilOctO3hfFVKOVC4cgjHeF3u+AL0uNUamJLkNsD9ycf+vab8h1KT5Uv0KRfU9Tqe9g14SAqcqfu0/sUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=JC0h8LBa; arc=fail smtp.client-ip=216.71.158.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="JC0h8LBa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1714023059; x=1745559059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kkqwiiYDmLCR4kulj2yYcpiHQ27SQLDs4SHwXzq9apg=;
  b=JC0h8LBaFu+8nBP7ohzNurc9322PG72DNcNqKap20uOCDgJPn0C1aTP9
   o1LZhiMU9vkmbMgFsdbCLuaxI6bsLiLYA2LyeTjNq3/lJ+jVMp62NcLjy
   cQQoh7SlTiWS45USuBs8rQsOf6mBa7nbeWsEvU+qjP1D5mJs4MBTqbHkJ
   +qNRnv8gVSIUaXC8UGPYFkglpOJfI5BUJy9BgugoUwn700nWhY1ekhxLF
   97S8x8HHqlvBFnxABueVbIsj5FdSH+APRtLReQHjPTj2GvNlAYkPM0Qc3
   C4YWtZQNljERu3uKLTB8dKYplhPg8xqkmnLvQYSdKvI1vk4QrMksnE7ZB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="117692629"
X-IronPort-AV: E=Sophos;i="6.07,228,1708354800"; 
   d="scan'208";a="117692629"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 14:30:50 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqAW1jnfOXmox4gpC0A/w4Db5mrk21Wqya04VqaQfLb5R5qR81tcVyXQCMbpmilfjfxr9XWIDlh9hFFyTMC2xNab60xYbVKjZGeZBUKodj47fhOq/WYAI3iSjGBCi3gaK/8fd+PRrYX9QlX1NIUsY9Pb33kGOcVlBaRZZF1eEwNXaMf3WfjRl+DSfl0Dggc4jW/7KlDvA9zziAH4yipeYan/GjPc16mfW/sivNBWe5YhWkrDGhfSM9niA4wO0JDdIjO6vzlMZM5/J/VvxaYU/0E3G+njWe2cgGr2+Alw7eEk684jD+R6ngJXcZqvrrbUGdsZdMusom+Ttr8OrvXMKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkqwiiYDmLCR4kulj2yYcpiHQ27SQLDs4SHwXzq9apg=;
 b=ih5rYF57oOFRZDlQMJVI6NI/gv2TphtNUu8TD3g0kj/jUiojsTQXS0WttHgnT5iTKbyBOzu1j1HsDE9wtNgEr9i16Ib3i1Gyvmw76VZ9Y+uAmdLq7q6EsQzLTcgfA2A5ByufTiHwXnPqNtPxjsIgqMIx9V52z5LOvOJs0aJ8HBANTytZuHzxaJmDbUblrnXhzQcTsnSxeks2xn9qJJio/Gknxc9FmwRUL+YTDcVlEFqKvtVG7UL5yl/t8PkgnlLliLlYbo0Rfm284+CnqP2z2J6CPoUfP9hy/sCB5oRHjAA0WcBELQzEu/QjmcF5z4K4Z2RybJp9373VzyaDe+qLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYAPR01MB6490.jpnprd01.prod.outlook.com (2603:1096:400:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 05:30:41 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%5]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 05:30:40 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
CC: "Quanquan Cao (Fujitsu)" <caoqq@fujitsu.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v3 2/2] cxl: Add check for regions before disabling
 memdev
Thread-Topic: [NDCTL PATCH v3 2/2] cxl: Add check for regions before disabling
 memdev
Thread-Index: AQHaltG2SzHUVWSV+06RfsOl90X7tQ==
Date: Thu, 25 Apr 2024 05:30:40 +0000
Message-ID: <779cc56f-9958-4c0a-b5d6-2a9d4c3e4260@fujitsu.com>
References: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
 <20240417064622.42596-1-yaoxt.fnst@fujitsu.com>
 <9b00e36292b7aa19f68bda6912b04207f43c8dc5.camel@intel.com>
In-Reply-To: <9b00e36292b7aa19f68bda6912b04207f43c8dc5.camel@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYAPR01MB6490:EE_
x-ms-office365-filtering-correlation-id: cdf41c27-0c0b-4c16-c844-08dc64e8d898
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|376005|1800799015|366007|38070700009|1580799018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dG9jV2lxSHljanJIZ1A3TnM3MnA0RE5ybWVVM0REU3YvNXlZdi9TYmNpNEJ6?=
 =?utf-8?B?Mk8waUthYUM5QURVZmd3TklJcnJLaGdtNEVaUjUvMWVLS3IzNFAzd1E2ZVNB?=
 =?utf-8?B?aXo1eUpncW9Pc2ZPMEQzZmNvbjJlZzBlTW1BOWRPSThLZ2hIYzlIdFM0UmtZ?=
 =?utf-8?B?MiszTVJZS2NUNzBCZDVwNWFDMHcxWHhNelZSRVdoTldvTVlNOEkzOU0yRDg2?=
 =?utf-8?B?aU4zMGFNczcweVFZdnNGR1pBL0J2UXpDeGdwK1Niakw4dGpmRkowS0RGYUwy?=
 =?utf-8?B?c0p2WFdSblk4c2pJejdENGNmVERoa0Z6aGh2UEU4ZVNZV2wxUU0zYkh5Wldo?=
 =?utf-8?B?bGphQnZQZVhtQXNTUS9WYlJmc3czZDl2WmJOdFpOMjJiYURzeHlKZVBnTEVz?=
 =?utf-8?B?c0VtTURBNHNUcVJIVmRKdlpQYy9ERUtjLzMzdjM0R0RmZVV4MmlSc3gzQVc4?=
 =?utf-8?B?SjBhNmt4M2FCV0NtSEo1U2d2NGhicmdISW96VWVnSDNpR1dvSnF2S0dCNmo1?=
 =?utf-8?B?dGZWNURXUVNPMjcvSEdMTWtpd0h0K3J6Vmc1dk11ck52WDk0Uk9aNG5pNWNk?=
 =?utf-8?B?VDhCMk1XZDFTdjV1aWhPeUN1Nzh0ZHlQNzI2aTJuS0VtVjF2TXlwWTUvZlo1?=
 =?utf-8?B?L3NNUEN5MVFMeGhCVjF3VUpObGlGYnQzclU3NkhkOEdGTlhyMnpSOUd6VWdZ?=
 =?utf-8?B?QTFxM0c0bzZJL2E0alE1QUIvaFBNZ1UrdUZobWsxcnhvUW1wWWJNakhqRGV3?=
 =?utf-8?B?VHF0ZG1BQ3NSeWlaSTdYS3VGd3FMRGczU3llc08zam1IOVd0QnpCNjl3K0Zs?=
 =?utf-8?B?L0d0MktQZFFCZDFvaTgvRDdaM0h3WEowd1FqMGFrc0tDVjlVS1Q2TzIzcURF?=
 =?utf-8?B?TTNpMFlCUEZIU28yeEt2YXRWbDE3YmN1QXlBczQzSHFNVDEvSzRKNlBGNHN3?=
 =?utf-8?B?b21pZjJBdGowWGw4MGFqN2Y3SUVZRXVwYUkxTm5Kd1lDaHdra1lwZzIxZnVy?=
 =?utf-8?B?YkNUZGM3Z3UwOXhoc28zQmxUMTVZOUZZKytUT25UR1N6WDlBRTVQK3QrWHpy?=
 =?utf-8?B?R0JCUElxbDNtY0xkUXJ3bGNweGZqRzh4bUlFekROclpYYThxQ2ZuaW0xRjFs?=
 =?utf-8?B?ZWlPZTNlUTd3aGR2aXFQQ2dKaG1GbVpCNG1oeW1aUG5ZK3dVRE1lb3ZibVlM?=
 =?utf-8?B?V01RWWNOaGZVdGE4VDFKcHZidWpyazJjbG9zUVdOUStZVW9GNCtyczIwVkg5?=
 =?utf-8?B?clJyeXlZbGYyOUIyVnpUdGFRbUU5Zk9vYnpBbnBsVDlkUUltMU9sdzdHSlRS?=
 =?utf-8?B?eFcwRXk3cjhOR25zbU4zZXhsMEZxTWR1Y1NlWUdUT1ZiVEZJZzFsUjZobFJO?=
 =?utf-8?B?dG9vNGxLVm42Y0FwRG9VbzdGRkpYalFoT1RjWUNkb09zYmYzVFRqS0dibkl4?=
 =?utf-8?B?TUUxdk1DMHh5d1lrQU1FdHZtc2tRN1VOQlRBempEVEVpZlZOckF1WXVWYWQ3?=
 =?utf-8?B?UG42S251MHkyemFuN290WEF4dTdESU8wZ2JXbTIzYWhWbndCYjYxK1M1eXJI?=
 =?utf-8?B?T1FEcXVURkVYaFJZQTRPRlZZdUdQcTFuWWhzVUt1UGtuQ0d5SjZkMnpkODJh?=
 =?utf-8?B?OFIxaVU1RFVPV21CTGZUMDhuSVgyZ2pmcUdWNVpGMUpUdlRVNkZqWVdmUytu?=
 =?utf-8?B?aW8zdUtFL3ZXeENyc3dTQUF0cHN2UDZoMElZSzVwK1UvK2xCVFlzNHdtOW9m?=
 =?utf-8?B?aEpnZjIzWHp3c3RrQVdMaXRsemdzajFVYU5yY3JGSjBnMStqVCswOW40eXpm?=
 =?utf-8?B?Z1FiY3BtNWV3ZVkwNVArbmpsSittcS8yaGZUREdKN1dOK3NtM3F0Q2lUbllS?=
 =?utf-8?Q?fc1/wRINEqbJc?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009)(1580799018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UUdiSnlSazBObFFuUDZnL1laT0tEb2VLbXovNUtuUmRYMU5PKzhId2tsUCtH?=
 =?utf-8?B?WVRyQzdzZEE4N1pqcWI1NVJTTDBaeVE4MSs0WmtOeWlXa3F5S3FmMXV1T01v?=
 =?utf-8?B?MGRIckVNRlZocjloL01KV0ZhbWJrOTRkdEY2a0g3aDZLNnB5QndOZEFBSWQ4?=
 =?utf-8?B?RmFhcFQ5ck9xSytEWWkxVnZYM0owRmRsdUh5SUNTeFBjQjlDRDEyRVJ5WHpz?=
 =?utf-8?B?V28rZWlERW1CcHkzdThqc2V1WnArYmYvSlBIWC9kTGY4WitGQ2JsRWwwcU9Z?=
 =?utf-8?B?YUtUTjFYeTBPeCtidEkxR0EwaG1vaU11bmJWMkFKbUN4U051NHdVSUNwQi9a?=
 =?utf-8?B?ZFcyNEpWQW1Yd3Y3TnBlenh0c21yLzRyZHFnUW9LQkMyaHhKVVpHYVZ5UHRl?=
 =?utf-8?B?Y2RJV1ljTyt3WlJhUmtCd0dxMEdndnJ6TVNHNVFITG0zeTBIWHpkaFRPYjRp?=
 =?utf-8?B?aVY1LzB5M0lKM1pNZitjbHl6MUdjSDdLV08wUnAzUW9mZGV0bDcyT1hQcUlr?=
 =?utf-8?B?SlAvUG1nVWFRc2duWEg1c24zMG5rV1AxRURXVVBERXJIUUFkL1duVTY5VlF1?=
 =?utf-8?B?ang0MGo3N1k2U0o2T2FpaHZna1hyK1pRV1c0ODI2NDc3cjFHWmRwWHV5Wjdz?=
 =?utf-8?B?eFNGNHkzczhUZGdYTTZkOW10eVdLVTlrL3JPeWptejZLYkFZL1dINUxDZ3dt?=
 =?utf-8?B?TEtsTEZZdE1YQ3ViS2JqdW9WWjhDWUlrQXpFejhqVFJJQkc3NWdEUFM0U1ox?=
 =?utf-8?B?Rjc1YWFMT0VMQ3ArNHcvc1IxZnNDS3o5YjNZNmNvYUJIZUw1Zm5RZyswTkYr?=
 =?utf-8?B?Q1NtdXNhbDZCZDdPWmw2eThtdHZ5YVE1d2ZqMFVlenpQQ1Z3STJ3NXJjdUI2?=
 =?utf-8?B?VzRIZDZVdFRONDVOdW04QU9saDZ3Lzh6STg1THZjWUZ5SEJEeld4dGhGK0U4?=
 =?utf-8?B?SzcxYktpa2NtSHV0WDdRYzRYY3dkUXArTFp2LzRXalZxNEk3VlI2aHc1ZjdT?=
 =?utf-8?B?MEtSYmgveXZkSGZMaFAwWlQ3S0l0b0VVUitKUkM4MExBU1hrT3JZZ096U0JI?=
 =?utf-8?B?UVd6L0Z4TWdkNERkdU01YXlJNS8vZU82eXpkSEVJemZHNkd3ZGFEazg0Rzh6?=
 =?utf-8?B?OUVqMXgyaXVPNllORkpidEdReDE0WGxtUXhDNnNZeUZMY2xEUHJQeWdsV0lW?=
 =?utf-8?B?dWlYdXphL2JwUEtlZXVGTkY1ZkNRR0UvMkxxR293SitUeDRiZVVJalFQZ2FD?=
 =?utf-8?B?czlLOWtZaWkyNzd0RFIzMFgzM1hoSytwTStURGlmaEFzU2FZM0RQNXVoVVVO?=
 =?utf-8?B?SVRqV0Z4SW9xR3pOVlgwUHhTR1lmamt6bXQwRnVGakhFTWpCdm5FSEZKRHZY?=
 =?utf-8?B?bVVRRW1HZXIxUnZmZkQ3dHVWK00vOVNJN05MS1B5SEdpNnFVVkVGRmpiUDlY?=
 =?utf-8?B?UDdZa294dWZRMmU0Nk1BTUpLbHQ3Z0MwRGNqajdydHdYWVcwKzBIVlhMQjZJ?=
 =?utf-8?B?N25MT0UwN3VsL3pjZ1c4aU1EejYxMzNtNWUvMFExNjFOaEhheFNIaWZYUzFG?=
 =?utf-8?B?eEhFMmtyVU5ETzFvOThQbGtrcmpGZVc1R1I4Q2FKUmgyZ3FMWmtJRTFJTlFr?=
 =?utf-8?B?ZlpXVzNRQmhTWmxiU0NjaEJzOUFXUkFCWjhBRC9rTTdRamdzQlJBQTVKWkRa?=
 =?utf-8?B?NmdnK3J3MHJlOXpBZGhFODE0M1poQnUzWXdoeUlDNi9QNTFjVldtYXE3ZWpm?=
 =?utf-8?B?TzFxY1ZTK0NieldEa0NLSHhaZzF5blkza0lTQ1hBcmRRVHBFRnphMGJROXlx?=
 =?utf-8?B?dldnZmh0VW5XUjU1T3ZYWG5qQzg5dU83dnRpMG5HNG4wTHkySW16YmpJRXY5?=
 =?utf-8?B?QkJQanlQNEx1MUlrT2hCaTNzUlZWdVowUi9tVXNXMUpKWmNHeVVNa0FiejEy?=
 =?utf-8?B?cERwUjFyczBram1QS1BJVEp1SjVoNTZid3VQZGgwTnE1ZExtRUVLVkY4bldn?=
 =?utf-8?B?VWJaOTc3cnBFS2JZNDc1UlpPeUtTQnNkN0UwcGJaZUN3a0Rja3AvdFB5bXpu?=
 =?utf-8?B?YUVvSkxlRmdiRFp1bW1sU1NOWjJ1dEluRjdUMk01ditjSEZmWlZ3QVNVSElJ?=
 =?utf-8?B?bDVtOUc5QjBDOXlzdUFQZnVIK0dyYzhOUGo5UnAxRWZkOXB2ZWlYRnJja2FH?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCC1623B417B9D49B33364BD4CC6E6D9@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jYI0Fh72YHsMNz99MyfFN3uMgTrftzSbxHxx0lJ8xsGY2b7zHHB02i8oh8HF3bTZDbuGSo5gWnz68xexQ3wR7beZbc7f0dbd38cUJkX1DMH/JFg56bKhq3cML9B5fbCoRnFSRjpq9uE0qpKAuFRsXhxOIq4kf41/Bx/UwKDqGjWoqO4hoD8W8gw7HznTALzTX2j9S3fPtbtrSied8avR/0YcacVJY5RCwYQwd12hS09TFIGNltDi26FOnIpZZZ1vJ8zXdxk3Hiy7vAqysjkdmgX87DZ/8frKOh2tmVmx+WuG7Wx4Afxdcski7kvAv0HIsJZJYYCFusHxi/1Mp9Gr35ULk/Z9ZtveKrkcUitdosresx2Ujelflw3vWBrCGEc0GvWP/LFB3Dzrp6DmvirYRcL9oItT820lWd8zdl2gT9sdmcimZySA4VMzMKNwm8sQZ1kBBZPbzZfIjvoI7jYq3wDV/GyStc7bSFtAlXhtZ2bsCTymbV9e3xM2cTsaCOr/08OVID+UCM81NX7IvNNohkG8Ox5tsXY6QIZp1NXqbUE0+1RLGrVo9CRzapKCht0DyHnOxaCNgp5Q0kTq1zqN91UMTFGI7BOJ4m1fhjtGT6ojYhyhoqS6ytMzhJRMe5dn
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf41c27-0c0b-4c16-c844-08dc64e8d898
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 05:30:40.8223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gb4BSlJFzL7hkmfI0vpRraNCHEK0Ql7taXs+Vx8t7d/5Xvm+OWkPjE6RdYa/y0byHatqWUtSPVdI8eI8S1l0WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6490

SGkgVmVybWEsDQoNCg0KT24gMTgvMDQvMjAyNCAwMjoxNCwgVmVybWEsIFZpc2hhbCBMIHdyb3Rl
Og0KPiBPbiBXZWQsIDIwMjQtMDQtMTcgYXQgMDI6NDYgLTA0MDAsIFlhbyBYaW5ndGFvIHdyb3Rl
Og0KPj4NCj4+IEhpIERhdmUsDQo+PiAgwqAgSSBoYXZlIGFwcGxpZWQgdGhpcyBwYXRjaCBpbiBt
eSBlbnYsIGFuZCBkb25lIGEgbG90IG9mIHRlc3RpbmcsDQo+PiB0aGlzDQo+PiBmZWF0dXJlIGlz
IGN1cnJlbnRseSB3b3JraW5nIGZpbmUuDQo+PiAgwqAgQnV0IGl0IGlzIG5vdCBtZXJnZWQgaW50
byBtYXN0ZXIgYnJhbmNoIHlldCwgYXJlIHRoZXJlIGFueSB1cGRhdGVzDQo+PiBvbiB0aGlzIGZl
YXR1cmU/DQo+IA0KPiBIaSBYaW5ndGFvLA0KPiANCj4gVHVybnMgb3V0IHRoYXQgSSBoYWQgYXBw
bGllZCB0aGlzIHRvIGEgYnJhbmNoIGJ1dCBmb3Jnb3QgdG8gbWVyZ2UgYW5kDQo+IHB1c2ggaXQu
IFRoYW5rcyBmb3IgdGhlIHBpbmcgLSBkb25lIG5vdywgYW5kIHB1c2hlZCB0byBwZW5kaW5nLg0K
DQoNCk1heSBJIGtub3cgd2hlbiB0aGUgbmV4dCB2ZXJzaW9uIG9mIE5EQ1RMIHdpbGwgYmUgcmVs
ZWFzZWQuIEl0IHNlZW1zIGxpa2UNCml0J3MgYmVlbiBhIHZlcnkgbG9uZyB0aW1lIHNpbmNlIHRo
ZSBsYXN0IHJlbGVhc2UuDQoNCg0KDQpUaGFua3MNClpoaWppYW4NCg0KDQoNCg0KPiANCj4+DQo+
PiBBc3NvY2lhdGVkIHBhdGNoZXM6DQo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1j
eGwvMTcwMTEyOTIxMTA3LjI2ODc0NTcuMjc0MTIzMTk5NTE1NDYzOTE5Ny5zdGdpdEBkamlhbmc1
LW1vYmwzLw0KPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3hsLzE3MDEyMDQyMzE1
OS4yNzI1OTE1LjE0NjcwODMwMzE1ODI5OTE2ODUwLnN0Z2l0QGRqaWFuZzUtbW9ibDMvDQo+Pg0K
Pj4gVGhhbmtzDQo+PiBYaW5ndGFvDQo+IA==
