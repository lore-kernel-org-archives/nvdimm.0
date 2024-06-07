Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1878C14269
	for <nvdimm@lists.linux.dev>; Fri,  7 Jun 2024 03:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.151.214
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717729979; cv=fail; b=StYwMaXMKIvCvPv14vkV2WjSd+6ZHNcJwFDdeDAr2/sBAxRCF3LSgGoaZKplxLISt6UNcUe3+lX9EBUiJLowRZs1oXnYJfnMqESKfyQg+UbHw4EgrYWwJanFUbQsltAJe1QIVJUK9ecInoJIwmgjVvkbm1h2poZc5tYVUqOe+IM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717729979; c=relaxed/simple;
	bh=X4Cnm1ZAdLokQUbe1cLWR3QMoOzbVKiQyZzOOSmhhrQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UclSlkChrJC5GDzHzAYBTT2VipTzP39Egah+SHqNIhBMN9d5FsaaFVORVbi0gtSSlmAH05l9mPGQOF4dixMYHGkvIGkhUe3TFj8C/GK68fsBauhvpU5TectqTYAOBzgdY7qoaQWK5R10WphusaLWlMBDvmBhnUu3xvE3khCqrX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=l9NmTJx1; arc=fail smtp.client-ip=68.232.151.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="l9NmTJx1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1717729976; x=1749265976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X4Cnm1ZAdLokQUbe1cLWR3QMoOzbVKiQyZzOOSmhhrQ=;
  b=l9NmTJx1511Ar5aqaa8kAzxU0LMqqYoGmE5zjy3yQ68cinZU14JpiB14
   kYShGQQXGtan2ByFtoSMvfrsIvA1LX/Q1qE4kPUIjcEeVTK5fNiaRMXPH
   na6l7YawPZnOt6iH7GAVpqeXTLcDyncDwhKgTkhf6WyC0tYUTaImJ1qdL
   OJjaMr0OyIqq1Vr/zrvpMpOz+2pYcrbwa3SN8Sz1GQDeMhqwlvtlj50PY
   1WhaitL4UBS9xQ5xlp6ZtX4FNIbDJhF6suovse3lxY0L/0/oO4K0WsV7V
   Hzr7dM8N/9hcvOexwTPEVS79kqp6S4xz0fPnhYIrcbbZ5MT23hdZpnb0c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="34655725"
X-IronPort-AV: E=Sophos;i="6.08,219,1712588400"; 
   d="scan'208";a="34655725"
Received: from mail-os0jpn01lp2111.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.111])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 12:11:42 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myOrMpQ3qmorrW9mhWdIwUZQJNbs/+4BbYP3H6jHkh4gBtHzd0AHfPr51pWviYMY+CfNhNPxJsdDu5bb8EeMlOBNsRmGArlbuMERObvGOYLHBZSTi3SOhbW/2M1k3HP3ravPfFRwgyv0XXdWyBcd6ne9xIr5rwkGc8649OS09IQ6MHlRUjPW+gn+1v9FR8qzu58XU3IogiAMHfsSrsE2msv5o8oo0TpkCSH44kyJfd7j93SOdBsWX2nY/tnn9oDbeNbj+5dtWlaLiXkuC4ItvZIyUx1fs4FrXXeNAaHbUE9v+hviKGGR8QNmH57akXfLH2sAymM8bUXdn+ipPhVWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4Cnm1ZAdLokQUbe1cLWR3QMoOzbVKiQyZzOOSmhhrQ=;
 b=LJLREM7UeX6thX5NUMrR6BZNiBDMlCba4a4Kl/5wf6gIHBGSinwh8zwVutQFJJj1AU1E8+DXVT5RvmFxUounoX74tJ9ZMdVSxFxb9sIHxBahcoRLz6Vr2H0fgdAM0lM7QXb1M+3BRVCmzg5IspXirg1G4r6nht7eipm90nWI4qlIsCeinotquWoaP667KOVuJ99AjnaYy2H78W5DckLUVh9fjWmuiHt1s6gF+OjC3wH1FNAuCAYb20A/nMraR0SpIpymHfWRxwUaGB5UwDc16Vyaw8hNx+muH7VjQKyNfI6z+PSYE5wx4cYKcpyyab6iH1tVJgN42N1MRhbiTvAf5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYWPR01MB12103.jpnprd01.prod.outlook.com (2603:1096:400:446::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 03:11:38 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%3]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 03:11:38 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Ira Weiny <ira.weiny@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "dave.jiang@intel.com"
	<dave.jiang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: Fix devs leaks in scan_labels()
Thread-Topic: [PATCH] nvdimm: Fix devs leaks in scan_labels()
Thread-Index: AQHati2t74u/nyp7wUqtJRv05QCX+LG69qCAgACt1YA=
Date: Fri, 7 Jun 2024 03:11:38 +0000
Message-ID: <5a5c91a4-9b0c-47d7-a9e9-43d15a28c0d4@fujitsu.com>
References: <20240604031658.951493-1-lizhijian@fujitsu.com>
 <6661e897cfd4c_16ff40294f@iweiny-mobl.notmuch>
In-Reply-To: <6661e897cfd4c_16ff40294f@iweiny-mobl.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYWPR01MB12103:EE_
x-ms-office365-filtering-correlation-id: 50214828-f70d-4e4e-b980-08dc869f8c02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|1800799015|376005|366007|1580799018|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?VDgxTzJNT2tma1dWbGdkVUJkc2liaVYxMWF4eEI1dTVZb0crQkY3NEZabG05?=
 =?utf-8?B?OUY0T3pyeW80bkV6ZFBiWWc0Qmt6a3RuVVZMR2NUeURXYTZrQVlyaTdKclpn?=
 =?utf-8?B?bUFoUUhwTHJWaUg3S3ZmY2xlUjBhOXE1dzEwNUswOERVSkxIRkdYSzlPSkgw?=
 =?utf-8?B?K1ZoVW4raWlJZTBpOXp3OGUxT2JXdXlmR0p2b2t5QlRIcGp2cCt3cnpreGdn?=
 =?utf-8?B?L0lwT3RoOThZTWlIbGg2VmNqbW9wZU83bzBaUWhIL0tZYnBGYno3V1J4aWFE?=
 =?utf-8?B?bHRyYU54bWtpVlU4b2tINjJMOXdjdU5IQzRmbEd3L1plYVczeFBEaDBPczkr?=
 =?utf-8?B?V2k3MytSZUJTekdVK0VZV3l4TkFyeHgzcUZiMllmS2lMMXZNM0xRcWRMVCtE?=
 =?utf-8?B?UjB0VXdoREppMW5scmRlSnUrSmhnL0FPdlNXeXZVOER2UThBd3FJS29mRTU5?=
 =?utf-8?B?aytockt5bzFuZis1cTRTZlFiRG9KMUU1dEFudjRiZU53ZUVzRE54ek5Bc2xS?=
 =?utf-8?B?enFtblduMXhPTlVOMzFDS1Fzc2VtcXVKZEpKNnZndTdOMG9XS0hDa1lyQ254?=
 =?utf-8?B?NXVoZG9RaG80VVpsZ2tNY21TaGlOL3c1bVJ4YjRyUFVtT1U0aDVyN3RGV3RS?=
 =?utf-8?B?S1JSY0xLbjBDVFZpRTZEb0JPdmVBRklndjRNM0F0VU9kQnMrbUxKbGJ5ZnZJ?=
 =?utf-8?B?blA4R1EyaEJTb1ZjOStRRkxteG1RV3ZwOVVldERPWWtDeUJKWE5MSkp6T3ZD?=
 =?utf-8?B?MTNLLyttOVZqbEo2OEs4Q3BETHBaNUhzVFdnZmZLMUNNbjlnOWFnRTkrME1l?=
 =?utf-8?B?NU85cDh3UURVdGFRTTJCS1YydnJHVmpwbUpVMlhkclZWNlByWEdYalB1TGI5?=
 =?utf-8?B?NmFsNXJWWEttMktYV1ZTbFNYTkRzcjFNZWNYeS9kUUNEcEtOWlcwZzVCV0t4?=
 =?utf-8?B?STNjUFllVzRpZCtQV2FQY0cxc2Fmb1R1UWUxRkJBQVhOMFBVOGtQMjhlZVh5?=
 =?utf-8?B?Ym41dzhhSXJ0Szh1c2xleEM1bmZhd2ZseG9rTXFWeTRnUVg5My82M0dqS0pv?=
 =?utf-8?B?VXlnZUl5cGdhT2VzM1hrTC9GRG5MdjRDYzRoUEx0QXFneDBtUTZqSjY0Slk5?=
 =?utf-8?B?SmhqMHp0ZzdNS1ZzM3NKZnRtV2YvcGpXKzZ4V2ZhMWRtTVVLZjM3bWozMXM4?=
 =?utf-8?B?TjNzY0R5Z0txN2MyWHBNcDVQOVorTW40SlV1YjlnaVN0c3puNEN2Sm5iS3lw?=
 =?utf-8?B?bVUxSk5Ca3E5Vit6TGtkZytvUkVkcEhDdnc1VFpXTVUweTR2MUpEM2pjeHFT?=
 =?utf-8?B?dEV4ZXozYmxhUmZpT3dRby9jelJ2VXhvT09KSDZBSU9WY0FVSDk0eFBydDRJ?=
 =?utf-8?B?LzRISkp4THhuMTMrb0JGclcyZk1iaEtZemtmRnJYaFZiQmtnSWZJTnAvYUU4?=
 =?utf-8?B?WHhUWkM4V2RFSjR4UnBKVGdtQ3lXaitPRDliZk1JT0o1WjRxOTdWb1dKL3kr?=
 =?utf-8?B?b2lNNXpvN3ZQYVhBejJQNkFPcGR0clhMYXl3T2s3UXF1cERrZkpTTGdua1VL?=
 =?utf-8?B?anRqYlc1ZzVPdmw1bUVBdy9ZVTRCNXpxMjdKdjFMemNocjdVZnUvRFBhMk9o?=
 =?utf-8?B?ZHRVMnFxUXQ3bTV6Zi9WLzRwMjF3eUZySDZkZHVJN2pNQU5mTzJ4VE9RQlhL?=
 =?utf-8?B?cVAyYlRXWUI5NXR3U3lnSDhKb1pMcDkxU0JpZXVFSHhUMkYrbjJmQ2RORXRk?=
 =?utf-8?B?YmJFZTB2MHJlRmJzV0FZQWk2R3hxUnZFclFGYU1LNnpFcXNYNk5vbDZVMTE5?=
 =?utf-8?B?LzZqM0hEOWpES1VqNkZta0FzTW9TMFNrOVB1TkdLc0RpL2dyRFNDbUFKR0oz?=
 =?utf-8?B?cFZVSnJJQjZkRzhtVUlxME52c2Ryd3pKQnpESkxJMDdYZFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(1580799018)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aEwxbmhiTmVQOStBbU9KdWQ2dXVuTXVMNDRWZDJFNWtDNTRUdUcwZHVHd0lu?=
 =?utf-8?B?WE51TGRxRk1Lblc0Y2w0am0wd0VHT05sRWt5amFZci9jbWU2WDNiQW1nTS9i?=
 =?utf-8?B?TGVYVVUreHg3MnhFaGJFcGtPcDVlZlkzVC9CeHpNOHN4ZUxlVWxVSUE1dGo0?=
 =?utf-8?B?M0Z3L3hYbFNwSElkeEgrcWhqVDVZUWtsaHFUZmZBNTJmVDJVSi9nMHZpK21Q?=
 =?utf-8?B?NW9KRkZ2MzQ1NTd0NTVjbUdkajloQjlBZ3BxNG5mQkJ2U00yZjBqSG1NeEMx?=
 =?utf-8?B?UndmeHQrcWxacWxhVkF2eVVmUzM0RUhOTjhJb3R6Yy9uUUIvNU1ES3pKVTIr?=
 =?utf-8?B?NVlxWGtLeXRJQ0hZU2lxM0U5ZU82S1ZaemJDZW9LODVySjJVSG1Xc0NkdmxV?=
 =?utf-8?B?eGg4YWxaUWdnV1ZxMThNRzZmZVd6QVFJS1I3b29WT0JoT243TWFwN3ovOTZK?=
 =?utf-8?B?NklwVVc0RmtraWdZbHpKdkJYMm1Ca3o4WkdzTzN0OVFreU5MYi9YYnFLcmI4?=
 =?utf-8?B?QXJpUXUzOTNkQ0N0SHh0dk5wdUg3Q1l2OFI2RGg4M1NoRjUzU0NEYVpkdUNO?=
 =?utf-8?B?dTFqNEpybGpFM0JoMVNKT0JTcGtVcUhFUU9RMkxiUThxMi8xVlAyZDFFQWkx?=
 =?utf-8?B?WU1EY2tHZlhTWkhhUFl2am5Gc0g3UEo5QlJJOUN2eXBEbDQxVTRzcjVNOTRC?=
 =?utf-8?B?OURZVG9TbnRGVUVUZTFrMVoxZ2p2Z3VEZ28yNktNU282Rll3R3JySEZ6NC85?=
 =?utf-8?B?TGNYYWJVYTl6eUk1bWEwb2s5UFJ4blhnWkMzZDBaSkdzMVV0RFlTdVlEaFFM?=
 =?utf-8?B?aUZBRzJaTEpieDE4dkVkMitodVlVYllYcHZLU2JBWHVjWS9nRXkrV1ZsbEtT?=
 =?utf-8?B?bHJxcTBObTJtSnpjb3VQRWFjYmZDYjg2U3ArZjRsOW1HblhJUGZsZ084cXNz?=
 =?utf-8?B?b0Q3cUV6L2VqYmdDd1BFaDRsMjllRVFSQm91S1g1ODd2TzdKRkdZNGs3c0N3?=
 =?utf-8?B?Wk5ndWVvdG1oVXkycjZybEw4UTl6ams0VEZxYUU2WlFmODlKT081Y0lmSXBQ?=
 =?utf-8?B?WW1VZnl3blhwUWJ0aTYyY0JmMUxnK0F1UXNMa3JaQUxwYXc4YzhjdzE3VkFa?=
 =?utf-8?B?V1hVd1E5dmlCTFJwOGlGVyswZG5xVjc5QjAyTXI3UzVsdWJTaURYK1N4STc5?=
 =?utf-8?B?OW5SSkVPOVhlNTd3K0JIS0t0YXZraU1EaFRRK3pKbE1LQzRwcHRHNm9zTWxq?=
 =?utf-8?B?SkV0OGMzTkVDTHlxa1BXYWl5STY0WGthb1h0OXp4MTNFYnlWcGE5OXd1MDJS?=
 =?utf-8?B?RVdVMlhMdHhhbCt1UW45OVcraEtSeWgrTGlxekkzSE5NNFRVR2U2VE94Unp2?=
 =?utf-8?B?WTRnY2s0R2N6b1lPSWtadnZ1K0dhL09PUUdGakZZbHAveVNnbmlVTnRoUVhj?=
 =?utf-8?B?a2RnN0ZGMmk0QmtUUFpRelF0TXM4UTR5cXBrMGMxWkUrQXlsbzVRWEpHSi9E?=
 =?utf-8?B?d09ielByRm0zd292VDEvcDQ5Q3J1em5qeTBLQUNPZ2lkNzRBUFN4Qk13UDM1?=
 =?utf-8?B?ZWhlQXNWczZ4c3ZqK0hjWCtBMEJFaDZYYm5EMjZjcW5sdlpZZGpEKzB2OEFK?=
 =?utf-8?B?eXVYRGkwNUFBYkQ0bWdKQWJZRk4wTEhNNkFFQms5SjJaRi9qYjRyK250cDJs?=
 =?utf-8?B?RHlURGpXVjRHNm9CT0EwM21FeW8zSlhTTmhzYlEwMnJZc1BKSEFldUV4ZEth?=
 =?utf-8?B?VGNoU2ZiNmpnNER3NTRXMWVOVS9xZzYzdFNpdUFjR3I1aGhOZ3BJbnJCTU5y?=
 =?utf-8?B?VWFjOExnZGF3YndYTWRUL3FhK1hsQkorVWwrRjRmMTI3OTU0bnFXYWZTNlV4?=
 =?utf-8?B?ZmxkTXBLWGRPR3FzcDladzlvRU8xb2cxbm9tUTA2YXlHWW9Kd3gvSmhIMXBj?=
 =?utf-8?B?YUVsV0krcUE3Uk9QTCtyMVBRc3YvaG1nZk1YbU1iS05XZFhqbGFqZXlScDYx?=
 =?utf-8?B?V05Ba1V4YzFYY2hQSVh4T0xhQ2lvU1NteTEzMTBIRm54R1AwTUxzbFR5a2w3?=
 =?utf-8?B?S2xxcmVoYWZTRFNPd3Nrcm9NTWF6cUR5Q01vTjcwUjJxNHVqR0U5R29CNlQv?=
 =?utf-8?B?YW1wTnYzSXpOOWEyNlUvMm05SlFMc3lST0VIV3dZRGltYyttYVhSVTEwb1px?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95B38763DB244844AA2C04280D4F6821@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qYNOvA4xivnc71nU42tHLKRiPOUs95yv1U5PrCHXBPwnJ42kCBBUJfoNVUcmDr43V7CxHGtJjM9B9riLYvCt6OKmjH7fprbe6FPxeilSPJb/kM7hB1+0stOe9mtrtir2yxKE1nm76nr9WXagp66QsAtejM2+LIb4I3zoCkDSph9B1yEu+gSVDorsN4295hxn1fuEYJoxU1d1bckzdRo8SsxjR6yYP1Y0YBXZLr/A6IcUySv6+CpSBPevMiuMTDXdXLytKzbN6QtpUgKKax7XEGtU41TBXEv1+3STBzbAqJumHFYShmCOLWGm5c82QgphKGpnXYy5+O7xxGpiES3PGLEcPe3NFifLzSrilO5ptoLahzsYi9BCPwWdhLzzMJpTtQJ5HgLJU65Gh1rlik/1qAVd2cI8Iq0WLLunwFgT9/x5rdsOUHdqXBnWSdy6ZcCmIUXinIYus2sTPAovcp8NXv70K4DfSvau9TGyR3cxgM+Qd1DAHXk3sBupM0+3B74T7ihs3IBfJ9X8iroo9DpeAkCo1o7hpBtqARVlCjDZQlF910iz92FUkGlzlhn2uwz7rIBUv/G2wbEB7isSjkAhAc4RP7Dk5HKttLmsypKPJTBCNUZ/++joY10svYrtJGoD
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50214828-f70d-4e4e-b980-08dc869f8c02
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 03:11:38.6413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mxo5yHEGu+NGwglBM76wpxtSzN6hAeqyeh79eai6yuyFC+WMquMgbbL3b55Ytmk4/4yA8P0iY36ULu9mC694eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB12103

DQoNCk9uIDA3LzA2LzIwMjQgMDA6NDksIElyYSBXZWlueSB3cm90ZToNCj4gTGkgWmhpamlhbiB3
cm90ZToNCj4+IERvbid0IGFsbG9jYXRlIGRldnMgYWdhaW4gd2hlbiBpdCdzIHZhbGlkIHBvaW50
ZXIgd2hpY2ggaGFzIHBpb250ZWQgdG8NCj4+IHRoZSBtZW1vcnkgYWxsb2NhdGVkIGFib3ZlIHdp
dGggc2l6ZSAoY291bnQgKyAyICogc2l6ZW9mKGRldikpLg0KPj4NCj4+IEEga21lbWxlYWsgcmVw
b3J0czoNCj4+IHVucmVmZXJlbmNlZCBvYmplY3QgMHhmZmZmODg4MDBkZGExOTgwIChzaXplIDE2
KToNCj4+ICAgIGNvbW0gImt3b3JrZXIvdTEwOjUiLCBwaWQgNjksIGppZmZpZXMgNDI5NDY3MTc4
MQ0KPj4gICAgaGV4IGR1bXAgKGZpcnN0IDE2IGJ5dGVzKToNCj4+ICAgICAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgIC4uLi4uLi4uLi4uLi4uLi4NCj4+
ICAgIGJhY2t0cmFjZSAoY3JjIDApOg0KPj4gICAgICBbPDAwMDAwMDAwYzVkZWE1NjA+XSBfX2tt
YWxsb2MrMHgzMmMvMHg0NzANCj4+ICAgICAgWzwwMDAwMDAwMDllZDQzYzgzPl0gbmRfcmVnaW9u
X3JlZ2lzdGVyX25hbWVzcGFjZXMrMHg2ZmIvMHgxMTIwIFtsaWJudmRpbW1dDQo+PiAgICAgIFs8
MDAwMDAwMDAwZTA3YTY1Yz5dIG5kX3JlZ2lvbl9wcm9iZSsweGZlLzB4MjEwIFtsaWJudmRpbW1d
DQo+PiAgICAgIFs8MDAwMDAwMDA3Yjc5Y2U1Zj5dIG52ZGltbV9idXNfcHJvYmUrMHg3YS8weDFl
MCBbbGlibnZkaW1tXQ0KPj4gICAgICBbPDAwMDAwMDAwYTVmM2RhMmU+XSByZWFsbHlfcHJvYmUr
MHhjNi8weDM5MA0KPj4gICAgICBbPDAwMDAwMDAwMTI5ZTJhNjk+XSBfX2RyaXZlcl9wcm9iZV9k
ZXZpY2UrMHg3OC8weDE1MA0KPj4gICAgICBbPDAwMDAwMDAwMmRmZWQyOGI+XSBkcml2ZXJfcHJv
YmVfZGV2aWNlKzB4MWUvMHg5MA0KPj4gICAgICBbPDAwMDAwMDAwZTcwNDhkZTI+XSBfX2Rldmlj
ZV9hdHRhY2hfZHJpdmVyKzB4ODUvMHgxMTANCj4+ICAgICAgWzwwMDAwMDAwMDMyZGNhMjk1Pl0g
YnVzX2Zvcl9lYWNoX2RydisweDg1LzB4ZTANCj4+ICAgICAgWzwwMDAwMDAwMDM5MWM1YTdkPl0g
X19kZXZpY2VfYXR0YWNoKzB4YmUvMHgxZTANCj4+ICAgICAgWzwwMDAwMDAwMDI2ZGFiZWMwPl0g
YnVzX3Byb2JlX2RldmljZSsweDk0LzB4YjANCj4+ICAgICAgWzwwMDAwMDAwMGM1OTBkOTM2Pl0g
ZGV2aWNlX2FkZCsweDY1Ni8weDg3MA0KPj4gICAgICBbPDAwMDAwMDAwM2Q2OWJmYWE+XSBuZF9h
c3luY19kZXZpY2VfcmVnaXN0ZXIrMHhlLzB4NTAgW2xpYm52ZGltbV0NCj4+ICAgICAgWzwwMDAw
MDAwMDNmNGM1MmE0Pl0gYXN5bmNfcnVuX2VudHJ5X2ZuKzB4MmUvMHgxMTANCj4+ICAgICAgWzww
MDAwMDAwMGUyMDFmNGIwPl0gcHJvY2Vzc19vbmVfd29yaysweDFlZS8weDYwMA0KPj4gICAgICBb
PDAwMDAwMDAwNmQ5MGQ1YTk+XSB3b3JrZXJfdGhyZWFkKzB4MTgzLzB4MzUwDQo+Pg0KPj4gRml4
ZXM6IDFiNDBlMDlhMTIzMiAoImxpYm52ZGltbTogYmxrIGxhYmVscyBhbmQgbmFtZXNwYWNlIGlu
c3RhbnRpYXRpb24iKQ0KPj4gU2lnbmVkLW9mZi1ieTogTGkgWmhpamlhbiA8bGl6aGlqaWFuQGZ1
aml0c3UuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbnZkaW1tL25hbWVzcGFjZV9kZXZzLmMg
fCA0ICsrKy0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2cy5j
IGIvZHJpdmVycy9udmRpbW0vbmFtZXNwYWNlX2RldnMuYw0KPj4gaW5kZXggZDZkNTU4Zjk0ZDZi
Li41NmIwMTZkYmUzMDcgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL252ZGltbS9uYW1lc3BhY2Vf
ZGV2cy5jDQo+PiArKysgYi9kcml2ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2cy5jDQo+PiBAQCAt
MTk5NCw3ICsxOTk0LDkgQEAgc3RhdGljIHN0cnVjdCBkZXZpY2UgKipzY2FuX2xhYmVscyhzdHJ1
Y3QgbmRfcmVnaW9uICpuZF9yZWdpb24pDQo+PiAgIAkJLyogUHVibGlzaCBhIHplcm8tc2l6ZWQg
bmFtZXNwYWNlIGZvciB1c2Vyc3BhY2UgdG8gY29uZmlndXJlLiAqLw0KPj4gICAJCW5kX21hcHBp
bmdfZnJlZV9sYWJlbHMobmRfbWFwcGluZyk7DQo+PiAgIA0KPj4gLQkJZGV2cyA9IGtjYWxsb2Mo
Miwgc2l6ZW9mKGRldiksIEdGUF9LRVJORUwpOw0KPj4gKwkJLyogZGV2cyBwcm9iYWJseSBoYXMg
YmVlbiBhbGxvY2F0ZWQgKi8NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhpcyBpcyB3aGVyZSB0aGUg
YnVnIGlzLiAgVGhlIGxvb3AgYWJvdmUgaXMgcHJvY2Vzc2luZyB0aGUNCj4ga25vd24gbGFiZWxz
IGFuZCBzaG91bGQgZXhpdCB3aXRoIGEgY291bnQgPiAwIGlmIGRldnMgaXMgbm90IE5VTEwuDQo+
IA0KPiAgRnJvbSB3aGF0IEkgY2FuIHRlbGwgY3JlYXRlX25hbWVzcGFjZV9wbWVtKCkgbXVzdCBi
ZSByZXR1cm5pbmcgRUFHQUlODQo+IHdoaWNoIGxlYXZlcyBkZXZzIGFsbG9jYXRlZCBidXQgZmFp
bHMgdG8gaW5jcmVtZW50IGNvdW50LiAgVGh1cyB0aGVyZSBhcmUNCj4gbm8gdmFsaWQgbGFiZWxz
IGJ1dCBkZXZzIHdhcyBub3QgZnJlZSdlZC4NCg0KUGVyIHRoZSBwaWVjZSBvZiB0aGUgY29kZSwg
cmV0dXJuIEVBR0FJTiBhbmQgRU5PREVWIGNvdWxkIGNhdXNlIHRoaXMgaXNzdWUgaW4gdGhlb3J5
Lg0KDQoxOTgwICAgICAgICAgICAgICAgICBkZXYgPSBjcmVhdGVfbmFtZXNwYWNlX3BtZW0obmRf
cmVnaW9uLCBuZF9tYXBwaW5nLCBuZF9sYWJlbCk7DQoxOTgxICAgICAgICAgICAgICAgICBpZiAo
SVNfRVJSKGRldikpIHsNCjE5ODIgICAgICAgICAgICAgICAgICAgICAgICAgc3dpdGNoIChQVFJf
RVJSKGRldikpIHsNCjE5ODMgICAgICAgICAgICAgICAgICAgICAgICAgY2FzZSAtRUFHQUlOOg0K
MTk4NCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8qIHNraXAgaW52YWxpZCBsYWJl
bHMgKi8NCjE5ODUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCjE5
ODYgICAgICAgICAgICAgICAgICAgICAgICAgY2FzZSAtRU5PREVWOg0KMTk4NyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIC8qIGZhbGx0aHJvdWdoIHRvIHNlZWQgY3JlYXRpb24gKi8N
CjE5ODggICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCjE5ODkgICAgICAg
ICAgICAgICAgICAgICAgICAgZGVmYXVsdDoNCjE5OTAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBnb3RvIGVycjsNCjE5OTEgICAgICAgICAgICAgICAgICAgICAgICAgfQ0KMTk5MiAg
ICAgICAgICAgICAgICAgfSBlbHNlDQoxOTkzICAgICAgICAgICAgICAgICAgICAgICAgIGRldnNb
Y291bnQrK10gPSBkZXY7DQoNCg0KPiANCj4gQ2FuIHlvdSB0cmFjZSB0aGUgZXJyb3IgeW91IGFy
ZSBzZWVpbmcgYSBiaXQgbW9yZSB0byBzZWUgaWYgdGhpcyBpcyB0aGUNCj4gY2FzZT8NCg0KDQpJ
IGp1c3QgdHJpZWQsIGJ1dCBJIGNhbm5vdCByZXByb2R1Y2UgdGhpcyBsZWFraW5nIGFnYWluLg0K
V2hlbiBpdCBoYXBwZW5lZCgxMDAlIHJlcHJvZHVjZSBhdCB0aGF0IHRpbWUpLCBJIHByb2JhYmx5
IGhhZCBhIGNvcnJ1cHRlZCBMU0EoSSBzZWUgZW1wdHkNCm91dHB1dCB3aXRoIGNvbW1hbmQgJ25k
Y3RsIGxpc3QnKS4gSXQgc2VlbWVkIHRoZSBRRU1VIGVtdWxhdGVkIE52ZGltbSBkZXZpY2Ugd2Fz
IGJyb2tlbg0KZm9yIHNvbWUgcmVhc29ucy4NCg0KDQpUaGFua3MNClpoaWppYW4NCg0KDQo+IA0K
PiBUaGFua3MsDQo+IElyYQ0KPiANCj4+ICsJCWlmICghZGV2cykNCj4+ICsJCQlkZXZzID0ga2Nh
bGxvYygyLCBzaXplb2YoZGV2KSwgR0ZQX0tFUk5FTCk7DQo+PiAgIAkJaWYgKCFkZXZzKQ0KPj4g
ICAJCQlnb3RvIGVycjsNCj4+ICAgDQo+PiAtLSANCj4+IDIuMjkuMg0KPj4NCj4gDQo+IA==
