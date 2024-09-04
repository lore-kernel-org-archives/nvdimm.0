Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6949646
	for <nvdimm@lists.linux.dev>; Wed,  4 Sep 2024 00:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725410058; cv=fail; b=Y8h65uRFJFcUuoQObL3I7wPpMZ2w2RHCFojDm7SgIvLlka401CcU/JhytlQ3QJcBoAwkRqru3XG36KhI3bhrJB00p3DQMtHYhboHGsnFST1ySUmI3MEMD2FEjLwViiyszp2vfziHJQFU1vAKVESpuLnjzONKlo7L7fjzPBjWc6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725410058; c=relaxed/simple;
	bh=HwzB0rn9YV5r7XWFSb4DckcdYcTSDoMbGRv5+LTNdeQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VQnjDZkGG8Eg8Ww0qggPEtT4TOT80ug0lR3XUmrJPZE2qulZ6IHI7NQtreXqGOCfgYdnKP2CS88lq1weAsLaZn5NfPaiLSsHXsxqcMESvvnXTJ587RGJNZrhzVVIc3T2xj8yW7nkJQBfzWfO5cSgJFb27SJHFjddLU/EQXWRLr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RnLJsky9; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RnLJsky9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725410057; x=1756946057;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HwzB0rn9YV5r7XWFSb4DckcdYcTSDoMbGRv5+LTNdeQ=;
  b=RnLJsky9rrB2SiWVDBZTk7eZsnJ2hWVfC/5PAwZU5YGbMP20KmfPuI/D
   a325teHqg5/8NLmVgsWoJG4c/bmy8x/JJxqIF+wkqGD14ppT3Exwlnn4o
   rlQL3ky6+ItuFdoZTxpS2mM4ff7CI9lCgFSsTpTQzw051/v7EhSBZR1+L
   G3oMbyccgUCMRPNPOy0Yz7Ch7agLFd9P5jIR9gk9K8EObA74xwiUdaPrx
   Qwr2+b+zKCKH/Lr5aWx/0g9c/vInRODhboJl6QXUmjYBO2yEVIKs3HGFE
   JeE2FBSZe4KlJgQGHzVNewvAurLwqS7qGlPMMVa8SwkS34DgQ8p0qCLhx
   w==;
X-CSE-ConnectionGUID: QF3T3AlbTaaAKoD2ksRhDQ==
X-CSE-MsgGUID: XMWee9BmSNWUrl55k+Yycw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="46570020"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="46570020"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 17:34:16 -0700
X-CSE-ConnectionGUID: Snr+A6qWSMKpxig97fuEtA==
X-CSE-MsgGUID: CwYuYw3yTceIX0TBSv6J9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="95892005"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 17:34:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 17:34:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 17:34:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 17:34:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DBWb0OcTexAXz9S8qrnIPeg1HWgHEQVJvnuduX9JXMuJPpp7TT34vYwoL3Ng7Ms38IW0YosqqxJSrLtIbmyZ0qgp63yPY6T/UqM/sekCA3pOxpAZoxYqjMH/JB5sqOOPmO9shRuwxVxy0WacpC/Ihh/C3R5bz0oFFMmqHBj7uWd/N7nkQtwwGjGiLu/WYJwO9kkUGcldXULAEDYAn5wkViaGArWY4WRHINaE4RAAq0wfav/ZvDyeH6IcLdL1KK6VreYDacizzhEtjPuC1Y98yqSSGs1VxpgIidsI2/U06M8GnTGGuaQqqvYzGf29Gi3rOpUZYyn1pJo2UY4VO8rfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwzB0rn9YV5r7XWFSb4DckcdYcTSDoMbGRv5+LTNdeQ=;
 b=YUPfYWEgjBSxKDkyO/5Itr0ywsUYo6gqCTJPxqz+p9Ki/DlkIYuZ9W1Dqw52jaHJs4h8B7aGGsaBPdOSFZftVMsXOaVvRts9iDvxvdK8KiA1aSzBYTb58TvIrlCKsWsr8vhVoes0rFMMaakggUdIu7kDVUpfnZeFG+lYVYNmSVVfmhZ4NAR6IypIM6rsgMGwBOvxf03YoX19fIF5eTHwUio3CLF4WEnZwyjVPBKTUVunD8KWzy0fic6J4tyUUkEHe7kpYbY0Qos0PzeQLzWVy2X+BWm2BKh2IhWDBQzVFW/wXXbi1Va2kkadhNQW7EKyNNfEgSGeuiqrpRWJFRXx+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CH3PR11MB8589.namprd11.prod.outlook.com (2603:10b6:610:1ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 00:34:07 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%6]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 00:34:07 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] test/daxctl-create.sh: use CXL DAX regions
 instead of efi_fake_mem
Thread-Topic: [ndctl PATCH 2/2] test/daxctl-create.sh: use CXL DAX regions
 instead of efi_fake_mem
Thread-Index: AQHa+Pho//DbHTucOEqRAoF2v05gM7JG0lqA
Date: Wed, 4 Sep 2024 00:34:07 +0000
Message-ID: <a7d589e495c615dc61c9fc2a70b6ed3ccd535c0f.camel@intel.com>
References: <cover.1724813664.git.alison.schofield@intel.com>
	 <519161e23a43e530dbcffac203ecbbb897aa5342.1724813664.git.alison.schofield@intel.com>
In-Reply-To: <519161e23a43e530dbcffac203ecbbb897aa5342.1724813664.git.alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CH3PR11MB8589:EE_
x-ms-office365-filtering-correlation-id: 9bf89682-9a2d-41e1-00e7-08dccc794972
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c2lBNWpVK0JrbUI1cWFqaElIOEEwaGlPTEFZd1cweDNRTUlyRzk1NnVHajBH?=
 =?utf-8?B?N0x0ZGR4WUU3YTdiM3AreFRyNWliK1NWc2tHRGtuWVdheUh5QjU3c1Rya3E4?=
 =?utf-8?B?V0RJQmVPdGxhSStEVWtacXhac283d3V6dnJDYnRhUHQ1S3RDWXpycHNHVjUw?=
 =?utf-8?B?NFBvRmtmeFZUMU00MWFPZDFhWmxEeFZpMDV1NTM0OFdmNTdpNlNXS1RXemFj?=
 =?utf-8?B?RDdOMGdGelFXSWtlYXdySlJacEVJcGdpS1psWHFXWjF2c0I3QlhnbE1BSHZI?=
 =?utf-8?B?YzFuSUI1aC9LTnJFSUl5MnhvYnZMYXRvOGxkMExBVkRJL0tYWjdkSXNMVnBE?=
 =?utf-8?B?N2E1UThqbTY0RVdaendadDlHdHh5dFRHdkpKUkxpVk9aenpORGFYaWFFRnhO?=
 =?utf-8?B?aHRiOFNETkdVTGx4bVd4b1lQTE5TaS9xQ1dMWjB2M0M1LzNjRE84OWpLNEY1?=
 =?utf-8?B?cnU4WWdCcWUxZTBadDlyOVgwNS9jeEJtU29ZNVhSMDBnMXFrb0RGSE0yUFQ5?=
 =?utf-8?B?eWxZQUNWUWZQYjFmclNHR0kza2M3L0NSRWRDM0c2ZWVOdGkwd0owdmhQU09R?=
 =?utf-8?B?WFVTQzhzZjBnSTNHL0UyMGJnaVdsQUw0djhkclpEQ2xoNVEwazlUdkhNa3Fj?=
 =?utf-8?B?MnNDVHE0YTBocjczZTBQd2s3citOdjNQR0d5NzJzQUoyRXpCVXl5aFB0NUxN?=
 =?utf-8?B?bHJ1UGNGRWZDREpkeFpoSW9aWmhTTWtnaEpJWFVRU1RpenRTTEZPRFB6ZGFv?=
 =?utf-8?B?RE1VNHRyRGhOVlhnKzNMbEVXTy9hRzNvVXRPNGRIaVArVFQxdHpRNUtRSGFM?=
 =?utf-8?B?Mkk0VXdsL2dLd0JYck1wNklwaWthZW1FY0RhMmZJNWxQeXkrK2orVEN2UGx4?=
 =?utf-8?B?QnZUeWtBbmRXS1orbFR1czJnSEYxUms0dTVSajR6cndNS25QcWhTMXV0L05h?=
 =?utf-8?B?ZEJLKzNVWHBTMkhTeUhjSzlpWE1Bb0ZNamtFRXJRSDU0bzlVNUVrS1AyS3d0?=
 =?utf-8?B?dkp3UU1Ba0RPUTVFcG11L0hoYjIyd3ZxMFdPdVpiK251TXFkVTRQWlFuM1Jr?=
 =?utf-8?B?ME9ac2NGOHEvd0NSc3V6MHRUbFVaaWxBTlh3Q2d3Uno0bU5URHpQcTZTRjVt?=
 =?utf-8?B?Uis3UEoySCtnZ0tnQWw1eXBzUnhxdVdBSHM1ZzU3SXlOeTRFMHJsTXRCUUJT?=
 =?utf-8?B?amlLaFVKNVhnM1licUo0VUJUSVNxaDZCeXV1K2FucFVGa1djdVd2aE85SDhj?=
 =?utf-8?B?a3gzcXVubUJsMSswMi9BV1BnRHV2S1BRUHFpa1BHUTk3NzQ0OG85Sm51UWVs?=
 =?utf-8?B?ekM1YXJIOUhyY0w2aTI2ZmZUbzlhSFRLdm1zZ0FCVFo2bkNGWnZmcDg4dXMy?=
 =?utf-8?B?Rk9lUzZqbGowYmhLZGxOams2M1VVY3BBcUhjamduRFBwNGxrcXp0T0xieWFn?=
 =?utf-8?B?TjhiSE0yR1JKLy9JdGJEdktEMmViMjhvN3V1cW10WlZXaXovN1J6MjZ4T2di?=
 =?utf-8?B?aEdqYm1mc2prWllBZVlKams1blFDVFkzbXhEOWdDdGdCS3ZwNkJxWnBBMk9u?=
 =?utf-8?B?K3hRY3BzYmh1dk16c1lURnd5b3NRQWdDclRyenV6aWZ6OEV4Zm1sYmp3S3lE?=
 =?utf-8?B?bnNzN3ZJK2MwL2RLM1gxblluWk1tN2VvQ1V2ZTZJbUZoVmljK21lb2t5Z09x?=
 =?utf-8?B?Q1hDcDBaNWtYcUdOMGp0bjk4bVhMQmlHOWhXSENVU21QMWxyVkVETEZpSFdV?=
 =?utf-8?B?azZDVThsZmFCMjRjUzgxbW1idGZMcmZjNHhKbFhlYTNVKzVzRWg4czB6NjE1?=
 =?utf-8?B?QVpvZ0RZWUY4VjdObEp1TnliVVRka0xJZ1BidThEOFRRT0tHc2J0K2FySzUx?=
 =?utf-8?B?YVpsL2tzQ054MDZONHk4VmtpYjBlVzg4ZjdodlpKYTAwNEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OU8wS0I4MUhjcHlyakFaTE82QmduMXk3SjhrZlMxM05sK2xRN2tJSW5EWXRu?=
 =?utf-8?B?cDF5R2J2VnBodUN2dm5uQ3I3WHVzbzZodHZKTEhYUnp1K2J4QlgwNlhOYmQ4?=
 =?utf-8?B?dUFwdjJtb0FKOXB3dXc5WjdkRzhpQUlXanJhWmRZOE1jcldTQnBwaDBYS2th?=
 =?utf-8?B?c0dCUHh3b01GbjJ2STBrMzBlMlZCaFVpdStJRnNDd3Z1U3ZWTXl4cjNUby9u?=
 =?utf-8?B?WjZNS0grbGFrZEZYdmpZNEJkcFZuRUJrVzNxdEcrbU1VMUtsSVhJYmg3aGFv?=
 =?utf-8?B?RWkrNmRKT091TmhXeDAyVm5RQUxiNWpJaitMRjFWVXJOLzRWKzZab0lueVFM?=
 =?utf-8?B?bzZsVUp3VGVkSWVKRWV3VDlaZkZGUWREMzg2LzFzWWN2bFRXcjJ0T3lodlVE?=
 =?utf-8?B?UWlmOU5FenlFMlNJVG9LWGF5UUpXTXdOZ2JJS2FxN3h0dmgreUsrc1V5SCs1?=
 =?utf-8?B?WkMrMXp2QUJCMHZBNjhXdTJpTzM5L3o4U3V2cE5GbjFQTndtRUVJQVFLeTlR?=
 =?utf-8?B?WDlZVDd1bFhEYWNOdjNocFNxc09DckhIanRzOUdIeFQ4Y1ZxL2UyUTFxemh2?=
 =?utf-8?B?MTBsYjlYRy8vbmxVaWZRUllJSFZqaWZtQ2lwSG1LcHhiVm5aRkQ3NmM0bUov?=
 =?utf-8?B?WlB2SUc1WjVtVXp4d25hM3BvK1YyanZqRlRtbk9YSE5CcmdKSmREUGEvbVJ1?=
 =?utf-8?B?SXh6bklNRWV1OTdjTDliRHVBMHFaTU5iWndPTjZQKzlDbkpNOEFkbFBiN3FQ?=
 =?utf-8?B?Q3EyYUlxWlBtbUx2SkNnbkk3c1lhYklPaXFZZGRkTytwZnpXOFdzVkg1cXlM?=
 =?utf-8?B?T1A0SmY5MUNtWllTTmhTVG9LNnNrL0xpRm53SDZ6ME1wNXZ2SHVwa1VWVEE3?=
 =?utf-8?B?cjJMY3N6WlNJSFFGcTVUVG1ITFNlRDhnR2JCZC9nOVBobERvb09UZGNvcVEy?=
 =?utf-8?B?UVRXS2JDUjhCVXBaamVCK0pkM0Irc1d2djVHNXh3VE1mY3J1QVd4OUlzWEdM?=
 =?utf-8?B?bmI3MkRldXd3d01FZm9rVnRjaENpTWpOSllSSXNBMjI0cTlOQm45Q0NSZ2NH?=
 =?utf-8?B?aXVFb1BpQ0NSTEhzYW0yc2NHdkIrSGFmNUZKaFBzWVhJMDVsNVVmcFhZYmhQ?=
 =?utf-8?B?UU5zWUxydks4ZHM3SFFJcEwwbmcvMThVOXBqYTlPTXBaWWRhSkxYV000Z296?=
 =?utf-8?B?TWUyd0g4N2VGTXljMWtQencvQ0U2MXFsa004QWYzZEdjRE9UajhHSVJ4ZzEr?=
 =?utf-8?B?aEU5VE9lTXpIYkh4RHAvK29ObWxid1UyajdIc3Q4TXdmMnFsRThTN1lzMFlL?=
 =?utf-8?B?VUFFRDMzWVFFamRQWTdCcnVYVmdWTDVZTWdhV2NQZHJ0cXN1T3lSVXBDb0w4?=
 =?utf-8?B?aXRqVm5wdDh6WkVPRGdVUkl1YlJGMWdVbFBHSW9IbFFUamkwU1RRT3h0ZVNK?=
 =?utf-8?B?RUdqcUdHRmh4L0pWcVp3UFNlRG1VSkJKaWNCUDlzYVVHWmlnTVBoczVlVlg1?=
 =?utf-8?B?N3lZdDdxWmVHNkFlRGRmNFlFaEJsd1hRWXNxSkZUcVNxVW1qU0YyMVMrNXkz?=
 =?utf-8?B?UHVwL3FldSt3c1FaNXZRTWpyc2VBSVZyZjBSQXJBaHhEM29jZkpxTHdrUWJQ?=
 =?utf-8?B?UXZtMHVPaldKQ2pacmZZOXNKSmNkSko2Q0E5ZlVzWThkeldmQlNCb3N5WjVj?=
 =?utf-8?B?YlNFeVhnSW02OWVoNVdiSUgzVzNIaGU4Y1I1R2Q1VW1VOEsyMzRLeU0yWThj?=
 =?utf-8?B?bkg1bWdkazZncnIvVkt1b1pDTzVJT2U4UWNhYjNiTjQvdW8zYTZVb3lFbEVJ?=
 =?utf-8?B?QVFlZXVFOFVWS29qVi80Qk5pckVuV05lRHNmSnZucEhrYXBsOFFYNXRpSU9F?=
 =?utf-8?B?cXB0UmlSeUxXek85aUQrSEs1SS9BVkdSQXh3REhkWE51OVdiZFczTE02c0VW?=
 =?utf-8?B?WFE0OThxTHVobzBEOFZOMGtvTjlOSDR0cjZLQXVqM056VE10TG9rc3FSemd1?=
 =?utf-8?B?TWxwRWZaNEd0bi9hZkNaR2N4dXlIazNDOUw0SDUxSEVqNHRMcTZjQ0FqaDda?=
 =?utf-8?B?OWIva3NiMGZCTlZLSTJ2S2tKT0xJc2IyUlFnVWl3UDNZSEYyZzRmdHVGQzVY?=
 =?utf-8?B?aFpraXhMYmk2SnNFWjY1WnFEd3kvaWcxT2pndHcvSFBYWkQvSjVBa0kwcWl4?=
 =?utf-8?B?amc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5809430AC51A7D43AAD6716D91236C66@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf89682-9a2d-41e1-00e7-08dccc794972
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2024 00:34:07.4975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBF+dlJDxwjiT6nPEhR/gPk3JTAL0vas6Dz+j0M8yJQvpfX24vyRQlEYqgn2toKil+nu13BzkzkiY6eYKjITkfYiAGuJrR/9UAXnhFkwEWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8589
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTI3IGF0IDIwOjE0IC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBUaGlzIHRlc3QgdHJpZXMgdG8gdXNlIERBWCByZWdpb25zIGNyZWF0
ZWQgZnJvbSBlZmlfZmFrZV9tZW0gZGV2aWNlcy4NCj4gQSByZWNlbnQga2VybmVsIGNoYW5nZSBy
ZW1vdmVkIGVmaV9mYWtlX21lbSBzdXBwb3J0IGNhdXNpbmcgdGhpcyB0ZXN0DQo+IHRvIFNLSVAg
YmVjYXVzZSBubyBEQVggcmVnaW9ucyBjYW4gYmUgZm91bmQuDQo+IA0KPiBBbGFzLCBhIG5ldyBz
b3VyY2Ugb2YgREFYIHJlZ2lvbnMgaXMgYXZhaWxhYmxlOiBDWEwuIFVzZSB0aGF0IG5vdy4NCj4g
T3RoZXIgdGhhbiBzZWxlY3RpbmcgYSBkaWZmZXJlbnQgcmVnaW9uIHByb3ZpZGVyLCB0aGUgZnVu
Y3Rpb25hbGl0eQ0KPiBvZiB0aGUgdGVzdCByZW1haW5zIHRoZSBzYW1lLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQoN
Ckxvb2tzIGdvb2QsDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBp
bnRlbC5jb20+DQoNCj4gLS0tDQo+IMKgdGVzdC9kYXhjdGwtY3JlYXRlLnNoIHwgMTggKysrKysr
Ky0tLS0tLS0tLS0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMTEgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9kYXhjdGwtY3JlYXRlLnNoIGIvdGVz
dC9kYXhjdGwtY3JlYXRlLnNoDQo+IGluZGV4IGQ5NjhlN2JlZGQ4Mi4uMWVmNzBmMmZmMTg2IDEw
MDc1NQ0KPiAtLS0gYS90ZXN0L2RheGN0bC1jcmVhdGUuc2gNCj4gKysrIGIvdGVzdC9kYXhjdGwt
Y3JlYXRlLnNoDQo+IEBAIC03LDYgKzcsOSBAQCByYz03Nw0KPiDCoA0KPiDCoHRyYXAgJ2NsZWFu
dXAgJExJTkVOTycgRVJSDQo+IMKgDQo+ICttb2Rwcm9iZSAtciBjeGxfdGVzdA0KPiArbW9kcHJv
YmUgY3hsX3Rlc3QNCj4gKw0KPiDCoGNsZWFudXAoKQ0KPiDCoHsNCj4gwqAJcHJpbnRmICJFcnJv
ciBhdCBsaW5lICVkXG4iICIkMSINCj4gQEAgLTE4LDE4ICsyMSwxMCBAQCBmaW5kX3Rlc3RkZXYo
KQ0KPiDCoHsNCj4gwqAJbG9jYWwgcmM9NzcNCj4gwqANCj4gLQkjIFRoZSBobWVtIGRyaXZlciBp
cyBuZWVkZWQgdG8gY2hhbmdlIHRoZSBkZXZpY2UgbW9kZSwgb25seQ0KPiAtCSMga2VybmVscyA+
PSB2NS42IG1pZ2h0IGhhdmUgaXQgYXZhaWxhYmxlLiBTa2lwIGlmIG5vdC4NCj4gLQlpZiAhIG1v
ZGluZm8gZGF4X2htZW07IHRoZW4NCj4gLQkJIyBjaGVjayBpZiBkYXhfaG1lbSBpcyBidWlsdGlu
DQo+IC0JCWlmIFsgISAtZCAiL3N5cy9tb2R1bGUvZGV2aWNlX2htZW0iIF07IHRoZW4NCj4gLQkJ
CXByaW50ZiAiVW5hYmxlIHRvIGZpbmQgaG1lbSBtb2R1bGVcbiINCj4gLQkJCWV4aXQgJHJjDQo+
IC0JCWZpDQo+IC0JZmkNCj4gKwkjIGZpbmQgYSB2aWN0aW0gcmVnaW9uIHByb3ZpZGVkIGJ5IGN4
bF90ZXN0DQo+ICsJYnVzPSIkKCIkQ1hMIiBsaXN0IC1iICIkQ1hMX1RFU1RfQlVTIiB8IGpxIC1y
ICcuW10gfCAuYnVzJykiDQo+ICsJcmVnaW9uX2lkPSIkKCIkREFYQ1RMIiBsaXN0IC1SIHwganEg
LXIgIi5bXSB8IHNlbGVjdCgucGF0aCB8DQo+IGNvbnRhaW5zKFwiJGJ1c1wiKSkgfCAuaWQiKSIN
Cj4gwqANCj4gLQkjIGZpbmQgYSB2aWN0aW0gcmVnaW9uIHByb3ZpZGVkIGJ5IGRheF9obWVtDQo+
IC0JcmVnaW9uX2lkPSIkKCIkREFYQ1RMIiBsaXN0IC1SIHwganEgLXIgJy5bXSB8IHNlbGVjdCgu
cGF0aCB8DQo+IGNvbnRhaW5zKCJobWVtIikpIHwgLmlkJykiDQo+IMKgCWlmIFtbICEgIiRyZWdp
b25faWQiIF1dOyB0aGVuDQo+IMKgCQlwcmludGYgIlVuYWJsZSB0byBmaW5kIGEgdmljdGltIHJl
Z2lvblxuIg0KPiDCoAkJZXhpdCAiJHJjIg0KPiBAQCAtNDEzLDQgKzQwOCw1IEBAIGRheGN0bF90
ZXN0NQ0KPiDCoGRheGN0bF90ZXN0Ng0KPiDCoGRheGN0bF90ZXN0Nw0KPiDCoHJlc2V0X2Rldg0K
PiArbW9kcHJvYmUgLXIgY3hsX3Rlc3QNCj4gwqBleGl0IDANCg==
