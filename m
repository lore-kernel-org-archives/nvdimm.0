Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEFB3EBF04
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 19:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769715931; cv=fail; b=IlXquV+h6JpaNoCup73DW5vpeZQxzywyv9j/CcVcU92R+KITZiDFTh2yGf8EBxgp20JNUaLNg9cm8JUUUHHfDPxoZ43MWdJ27fqApCJ4d7i5oCt7SF4PIULAf0fGWAkQCYkF5x14EfeaHqkEbV2yynXwC7sxRtUpc3x8Q1JdUUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769715931; c=relaxed/simple;
	bh=ywx0r9bWFYi2e9tpM9wop2PrBUHUS3+MpB2vWlr0G4M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IpHZQ17oDvkI7w9eJwSvUrAGdt6OF/Qzep/tvdeUcUeGTOEmWJyNtiruyMKhcyUbcd7ShiQciSFA6PaVR5AfKjJ6tFWttaBDZcWZ/ex4ySsI3mNCKfWxKJ7eyIUKB1T/ig8eVt2oZ3g0FW2S6etJtm3+29/mJ9BBakWhMSkDgzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ElAm7007; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ElAm7007"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769715930; x=1801251930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ywx0r9bWFYi2e9tpM9wop2PrBUHUS3+MpB2vWlr0G4M=;
  b=ElAm7007t/t3HrKzSjzFe7Bz3fOGxePU7+siVktTXXHPcy3ON90o6w20
   ib4+Cf127eWPmPwAqXp8Aa+gafb5Qwj0plel2Zhd9Zxp1zBl/SrtsypER
   yhHxUYbfjlFQOnDZ8g/yZ+xJEq+m6GVHJgKPM5FK99fneR28LJ+mQq4f7
   TmHhoJzXkzMHJIZVERwS7Yw3WAf5KzepAevgUk0UjU4j+MCxpDx9JG5Yu
   cSWLlmmaDKzvP41iKMUWTgGJEXsOOnhr3ESOYKGR60jLhmK1Sdx+1O4KY
   +dFt7P1Uj9UAx3HvUuTDr89CO+YsifOknKqoOCjm2ERMpvwZrKT44pg5B
   A==;
X-CSE-ConnectionGUID: 6EWgD/awS/G6F5ZSmUVj8Q==
X-CSE-MsgGUID: +Gtxa9wDRMiMjX1fAUCbKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="82075347"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="82075347"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 11:45:30 -0800
X-CSE-ConnectionGUID: /w5NbEvjTJGMnxaT+58Fkw==
X-CSE-MsgGUID: fOx1E4TJQLaUtZjdOdd0AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="213152379"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 11:45:29 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 11:45:28 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 11:45:28 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.5) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 11:45:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xv7JGUB2O8GRPVpi4jn3cenwPvXgSQNu79pJzy27sj4+MA9ZUmsHkX98QUULAIwluCUfFzTVJlPE3gBl3Uq/HLwKCnFhy/tL5K+W3J6SR0dP6l2ANPIfFQKYEzw95fTbOgEi6Dl9ExdlQxJ1np/5wb+GEOY9E/dzkCH7pDvs0vCbKoXT4T3e3wfbP8VP/GfKnwQyKKqcjthi7/QHpKDIctJuMlStaFUtQFagcI9zqKUzFWGw7tU4k80qHrMPPR7P1HIaMM8yMACnOCf3pR3XNwisEGg3vadNelaTkAwonTLFsERfpBKx0u3F9WaXM1P2Ubnvl+4JnA5HzmRZlRRE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywx0r9bWFYi2e9tpM9wop2PrBUHUS3+MpB2vWlr0G4M=;
 b=GK2uewKZViAIwgQ+CbywUkZkkQz1Ow6lvqFkdF66jF+taUptvlBT4teK9nm2NcckZ67lyoJAph3tbCBiqyFcL+40uVz+VZn/VSg7E40AhZE5tlH9hC046qPSuJQrKoAkqr3P+m87BjVavOiYT0trKWv0LK5Q4wguPs6cgoWR0l/pFQGvc1aNZkSci4MtS0xnwVZTDWdKElXCISLAcxjM6B8gk1VxWdLqi9L4Hqpnd6B7iJM3U+v8SkJ4zoXEIpi7xbJxNAyTn6tzTo1nFJXeam+xOuEgk5tk+qF7Oz1XkjcEq4ka/j78E/pSnmv0j3n3ciMHwMaAnja+xUZD+Oi4Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA1PR11MB8542.namprd11.prod.outlook.com (2603:10b6:806:3a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 19:45:25 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%3]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 19:45:25 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>,
	"Benjamin.Cheatham@amd.com" <Benjamin.Cheatham@amd.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Jiang, Dave"
	<dave.jiang@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
Thread-Topic: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
Thread-Index: AQHci+eXEkQeU7kYMkKDkegRAYg3Q7Vpl88A
Date: Thu, 29 Jan 2026 19:45:25 +0000
Message-ID: <4e3cf71a568f98a8349416874a7f08a5e5099799.camel@intel.com>
References: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
	 <20260122203728.622-8-Benjamin.Cheatham@amd.com>
In-Reply-To: <20260122203728.622-8-Benjamin.Cheatham@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA1PR11MB8542:EE_
x-ms-office365-filtering-correlation-id: b2a16b0d-3a03-4fca-01b4-08de5f6ef296
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ejMzOTBxdkowNjhYVDU3U3phYngxSEJWb0R3NUhha3JMc05DYmhTR3hkWjl1?=
 =?utf-8?B?Z21NVHo2VG8zdnNNQm5RNFJFRnhFSUt2R21kb005SjQydWJtSEt0TlZycWZP?=
 =?utf-8?B?SEM5U1ZzMSs1aVdxZ1QrSmdzRGQrTldESDJGUUVrVWZpSW1KdGtKTDN2djdt?=
 =?utf-8?B?ckJVR1ArWEFJQ2pCcjU3S3Y5UURvL1granlqWGs2cDdXVjA4TzE1ZzRGZHBD?=
 =?utf-8?B?ekNmelpwWlJXVWt4OUdpTThPdGtmYmFMT0R1R1dXR3RIREVvR0V5TkZ3UTVJ?=
 =?utf-8?B?Z2N3RjRqNWRGZVVUVkE5OHU0SnhIb1BKZnh3ZThZYU1tOHcyYkg4Y25EMGsr?=
 =?utf-8?B?ekY0QUlDeEp0eUdEZzd0VE1sWmdzNzI3RzFSdzVqWVl3Wko2SjlLS0NRc1ls?=
 =?utf-8?B?T3Nsd2NIa0pqdkxuaGlLS3dtVUJtbEVBdXo2MnJvWmp3b0p5eTAvYjNSa2ZF?=
 =?utf-8?B?cmUyUGxEU0tvbnlVZ0dVWnRyT1Rma1ZFUjhGaFpkcG1CSE9rL0t2S1R1VGRZ?=
 =?utf-8?B?L20vNmxpdG1IbTdXKzI2Wit0VmFrbk96OWFGWGJOZlMyTGJod3YzRjRwbDBK?=
 =?utf-8?B?S3lsQjZqVlZUMTVjejlGakVqT3l3SHMwTVdHcmE3cG5KSDRTVHgvSGpCZTh4?=
 =?utf-8?B?YkUya2VVdTdqSHg5SHQ5WnFNQ1daTks4WndKMzFJY3k4MWlDRUFIMWRQa3l6?=
 =?utf-8?B?WlZjREswVklwSnU0angzbzNTVDRTQWl1UGpWTEpuSG5TL3VRU0xlQlRFRHJN?=
 =?utf-8?B?V091ZE5pYXg0MEVsSWVNeDlZUnVha3FBZGNTVVlPYndOYUhNNTVkZFUzWjVD?=
 =?utf-8?B?R1BER05WMnRHd0ZnRFluZ0pEa1ZSUE1oZEhMSVhTMU9XZTlPVDJ0bmkvU3Uv?=
 =?utf-8?B?Q0NUSFlYV2lTcmMxODNXSFdlbmhvUXlNUWtFNmdYSldpczZFWUR1Tm9sbkQy?=
 =?utf-8?B?eGNabTI4YzU1WkNsU09SQzhMVGkzSUU5WmRWcDJtWGNRVmVzMEw5OGphcnlh?=
 =?utf-8?B?OUtzTkVDeVE5ZEtFeGd5QjNkSzFSYnJKMmVEdmU1WjJqai8vWld6VW1JdW5Z?=
 =?utf-8?B?a2d1NWpPK3I1SThFcGI0NUxickh6c1FoTlQ2dWxSSkQ0Yjh2M1VsdXZhRHhh?=
 =?utf-8?B?VDBUVXhpZytPVTk3L3pINkVlVThwMStKZzhuWVFuRmtZQXZ3Z2pnNE04R0k0?=
 =?utf-8?B?RU91aDI5L2hoY2tmMkR5K1BBMExlQ1VlbkR3b0phRVh4ZmFEQWsyUWZvblFJ?=
 =?utf-8?B?SGdrRlJRVTlyckg3RFZ3NHJtQ1pvOHE2TmVZR1pKL2E2S3NqK0s0VnluMlgz?=
 =?utf-8?B?K3V0YkoxaHFuT0d2K3laWi9YN3V5eG1UVnBSWnV5NFlGRHZXbTI1QUN5KzJR?=
 =?utf-8?B?RHovVytsbG1ibFVNRG9jS3RVMUFRQXVCNGdDQXI0OVJIajFJWS8rQmEwYnpJ?=
 =?utf-8?B?Nml0MmJLamwxM0FvOSszNGQ5TjdDY0pCanUyeDZYYU1RSm1nVWY1NVVoc3Rq?=
 =?utf-8?B?dU5kWElJUFpBTkd1VTcxNk81WGFVYjBicmt6SG8ycXcxbzg2Y0pUMm5NMi9v?=
 =?utf-8?B?SmFjUEQybWF5MTNUcVNjeHJCQ3dQVDFxeThJVFFJZVNuTTZTLzI1Y1hpTC8r?=
 =?utf-8?B?VDMyVThZS0dSeXREa3pQWWRCOG5Sdkdhb0ZaRDY3djV4cjNFYzlNWGlhMUhy?=
 =?utf-8?B?T2NFRlJJa1hWUlFJU0pNVkQ5RWpTZzRjOU5NZTlyUGROa0ZCMi9wdHFzZ3pl?=
 =?utf-8?B?MmR5bkk3VFNpd2pZL2Y5V1NhZ0R0aXowQm5vTFZPSW43Y1Mzdm5OOEVPZ0dt?=
 =?utf-8?B?K0FiMlRQWFlTWTJLWGwwWTFIUUdadm1oVXNYQ1Zna0h6SFE0eXArbXl5V3Rx?=
 =?utf-8?B?U3JublMzZ3dJRkRucE9lMStFQ2dJdTZGa2ZjOGtDS0hVdDdZS3BoM3g3WmxR?=
 =?utf-8?B?MGtMaXBtR3BNK0xuOTROTXE0OXpwWlZIb21nQVI4Q0lpU3h4R0I0U1ZEWjQ0?=
 =?utf-8?B?ZTNpUjl2WDhwa2RDUUlKcHM4Sk0yU0l6dGpkYW55WGs0Q2l2NWlVdkRERzhL?=
 =?utf-8?B?dm9vZlpLaU40YVZkMkY0K00zRmU1aFV2Yi9SQUFxOWZhdVZ5ZEkrMDJNaU16?=
 =?utf-8?Q?+wWgnCeSUysrY5OPVDsoKEdG4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?USt2WjVPTVhMS01oMVdIUzJya2phSldSN0hPMkloYlUya1JUOXBvK2h2aERO?=
 =?utf-8?B?ZmpsMkdsMmVvcGxMNHE1QzJZeHl4NFY3ZzQxMXVvV2tDMkNFTEZlamY4SW1C?=
 =?utf-8?B?RDcvQTk1Z0IxK2RZNFRqSzZ3MXZmekU2U2hOTjNUZzZ4UEdER1I3TlIrUzJq?=
 =?utf-8?B?WXE4enBaMTFnODJJMml2dy96L2VFdXo3V0VzWTlLZDg2ZHhOeUs5cjN0ZFZv?=
 =?utf-8?B?cWhvbEhnN1J2ZXpONDhGb09BN3pFRWxhbjcveEVyV25Sc3J2V2tVK2tlc2Ju?=
 =?utf-8?B?LzFjNGk4OEhaR2crOVRKSk93N3QzbWgxNXEyNWtVa1YxRVhMS2lDMXBJYlpV?=
 =?utf-8?B?OUc3V2ZYNi9yaUViTzA5QXQzQTdLam5BVmt4OVZuK1o3ZTVlS2pZaWlVZjhL?=
 =?utf-8?B?SU5mUThocFNlV21jU01lRWpEcFlKRGZud2JRTlhQTWcyNGE0MDBYeVVmc1dn?=
 =?utf-8?B?THExZ0NqUGRsWExvdGV3S0llblRFcHRScU1rNEJpR1Fub3JxR09hbmRqNWVz?=
 =?utf-8?B?NXpIK2hyTTAwd1NTcjlidmFsTklTbkt1U2tqWk1EOUE4OVFQcmVacFNualJn?=
 =?utf-8?B?WnMrUjBoWUhzMUJDcUo0dHVudmd0dEJiaGh6UUtjSDcwaVUxVUsweElkV0tD?=
 =?utf-8?B?NzFLM1dIWkYydVVYZzFmcFBNYmJFc1BqbUFUT3RDMHlpR01oS2NVRVZHRkp3?=
 =?utf-8?B?czhLNjI2am9xaVVYMkMzWitjZzIzbWoyY1JnYXJKY2NHU3lZc2xhOS81ZHJv?=
 =?utf-8?B?Z2VEM1IzcXA0NHFkanp0Z0Q4NVI3RlBNZzh6YVNFK1l3bGxVUlkzSTkzdzg4?=
 =?utf-8?B?UVBsWjJrL0ovaHdpOENBQUg1OXM5NDB0d0hScmV3RUhSbzQycDRCZWpOT0tV?=
 =?utf-8?B?c3ZDbWg0bnpaT3gwQkFXU3hPeExNL2o1RHNUUzhIU0FHR2dzSFZKY2MxQnRT?=
 =?utf-8?B?UERYbG9vcG9CYVQ1bzh6NWR1QTNNbEVFckRvbUhqS1Z0V1dPSThkMVQ5MG01?=
 =?utf-8?B?dTVOcWJlaGlpWENHWjZKMjlFNnhCeFpoNmlFelFXZVdHdnlETkdndnJtTG1Y?=
 =?utf-8?B?VXZQcU1LNEVpdWZjRGo2WTl5aGVWdUp1YVRyeG1hQ25NalVPUjc3SnNyTWJS?=
 =?utf-8?B?R21MMDNLZDBrYWtqK0p6NjR6ZnI0TU0rNXoyeDNZUWVkeVhPTXFKUndCU3BW?=
 =?utf-8?B?d3pyOGtWRlA2WE9OV1FmMDl0KzhGQnNuWm9lRmEwV0NFVnlkdzdSeWVNcGZH?=
 =?utf-8?B?M3ZTa3dCamdoUWlKR1kyb214ZnZrNkNqNy80S0tybVI4MHlUNG0vdE11dUJR?=
 =?utf-8?B?Tnh1OTVaOFFWVnRBMDlueGxXaE05S1lSWVAyand0VG1GNzZhRG1Edm56aXpY?=
 =?utf-8?B?QUxpdithM3RMeEo3UitOK291eW1SSXY0czRGajZlTjV6NjFwdXpYSjBvZWRQ?=
 =?utf-8?B?aFYzZVVBeTRQZllrMUx6S1NpL3VQSVM5a0E4dGdIYktrQlI4UlUvK1ZNQ1lR?=
 =?utf-8?B?TkJpVk83ZmVJSkpOQlMrZkRjK0FmZE92SE9JQ2RkdElYZzdSMzJxYUdDQWd1?=
 =?utf-8?B?T0U0YmVXTDNhYzFaZHNEQmFPeUQzWXlxTnNZQmNWQUJQTUlpQnBCU1NzcmUz?=
 =?utf-8?B?N0pIc0k4RzFta3A4TERPUDVVbDRGVHFZZzhaUmxFTEZ2b0xjSnVodk1YQlZo?=
 =?utf-8?B?elFTVm4vdDZGOTBrMWoxLytqVkloOTRIa2tsRG1nQWlwSm9KUHlkWWoyR3A5?=
 =?utf-8?B?VU80eExnWXFzUEJrK0Zxa1QzZ2NtTkUxNUp2RjBkV016ZE1mTG5zM2tvZlpy?=
 =?utf-8?B?QVpSa3h6ZXRLUHJwY09PdmVxYlo1QnVxM3p5R0dHQXJwNXJ3SFVVYm9Zd0hN?=
 =?utf-8?B?WE1TM01OTnFKN0MzZzhtRmkzV0tqcFVXaEZTQjA2UVNTV1JYak56WTFEQWpM?=
 =?utf-8?B?YmYyc0lQU3I2UnpZcVNseVZTUHp5SlRobi84Y1ZtTDlpaWplaDl2Wmp0cUtP?=
 =?utf-8?B?bDVjOFIxTmgxV3kwb3ZwRk82Y0FnYXJ5dE95U0hUMkg4WkVHOTcwSHpXYTJ0?=
 =?utf-8?B?WExkK3RrWFpYL2JCQ0hBS2szbC85d2h1VkhCbVk1a3hzVzZQcjk1QnArL0pS?=
 =?utf-8?B?eWQ4UWFaRXUrTDkrNE1zOTNwSWE5RmYrTEY0U2RnUmJuY0NXUUZ6Q25KMTJx?=
 =?utf-8?B?aExneGRDcklkbWRTUFJIOTArdlc5bG4yYUY2bXdrMURrd0w2cTRpV0NxQ0dL?=
 =?utf-8?B?b2ppRjBBYnN6RUFJelZVRXpXeXd3Nis0SjRKUm5KMnJCQXlyNStKYmVXdGR1?=
 =?utf-8?B?dXk5MHNOZlRnWmRLdllhVkh5RVBMTEx0ZlR6Y0Vmd2pJNkEzektFN0cvUk1Y?=
 =?utf-8?Q?BjlmUyRoOzDg2Hls=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8901344B177FF74D93AC21B0B8614A8B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a16b0d-3a03-4fca-01b4-08de5f6ef296
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 19:45:25.3797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GUwxMjZHvTehvEDVVMb+hgoj1l1sxsPHCc0KMc/0CFdkPDQ6KcJQ980b3wEXcf5AQQCzjoap7P52BNcs8/kskThu2YgQagwWO0crVF5T9e4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8542
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTAxLTIyIGF0IDE0OjM3IC0wNjAwLCBCZW4gQ2hlYXRoYW0gd3JvdGU6DQo+
IEFkZCBtYW4gcGFnZXMgZm9yIHRoZSAnY3hsLWluamVjdC1lcnJvcicgYW5kICdjeGwtY2xlYXIt
ZXJyb3InIGNvbW1hbmRzLg0KPiBUaGVzZSBtYW4gcGFnZXMgc2hvdyB1c2FnZSBhbmQgZXhhbXBs
ZXMgZm9yIGVhY2ggb2YgdGhlaXIgdXNlIGNhc2VzLg0KPiANCj4gUmV2aWV3ZWQtYnk6IERhdmUg
SmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBCZW4gQ2hlYXRo
YW0gPEJlbmphbWluLkNoZWF0aGFtQGFtZC5jb20+DQoNClNvcnJ5IHRvIGp1bXAgaW4gbGF0ZSBp
biB0aGUgcmV2aWV3IGN5Y2xlLCBidXQgSSBoYWQgc29tZSB0aG91Z2h0cyBvbg0KdGhlIGNvbW1h
bmQgaW50ZXJmYWNlIGJlbG93Lg0KDQo8c25pcD4NCj4gDQo+ICsNCj4gK2N4bC1pbmplY3QtZXJy
b3IoMSkNCj4gKz09PT09PT09PT09PT09PT09PT0NCj4gKw0KPiArTkFNRQ0KPiArLS0tLQ0KPiAr
Y3hsLWluamVjdC1lcnJvciAtIEluamVjdCBDWEwgZXJyb3JzIGludG8gQ1hMIGRldmljZXMNCj4g
Kw0KPiArU1lOT1BTSVMNCj4gKy0tLS0tLS0tDQo+ICtbdmVyc2VdDQo+ICsnY3hsIGluamVjdC1l
cnJvcicgPGRldmljZSBuYW1lPiBbPG9wdGlvbnM+XQ0KPiArDQo+ICtXQVJOSU5HOiBFcnJvciBp
bmplY3Rpb24gY2FuIGNhdXNlIHN5c3RlbSBpbnN0YWJpbGl0eSBhbmQgc2hvdWxkIG9ubHkgYmUg
dXNlZA0KPiArZm9yIGRlYnVnZ2luZyBoYXJkd2FyZSBhbmQgc29mdHdhcmUgZXJyb3IgcmVjb3Zl
cnkgZmxvd3MuIFVzZSBhdCB5b3VyIG93biByaXNrIQ0KPiArDQo+ICtJbmplY3QgYW4gZXJyb3Ig
aW50byBhIENYTCBkZXZpY2UuIFRoZSB0eXBlIG9mIGVycm9ycyBzdXBwb3J0ZWQgZGVwZW5kIG9u
IHRoZQ0KPiArZGV2aWNlIHNwZWNpZmllZC4gVGhlIHR5cGVzIG9mIGRldmljZXMgc3VwcG9ydGVk
IGFyZToNCj4gKw0KPiArIkRvd25zdHJlYW0gUG9ydHMiOjogQSBDWEwgUkNIIGRvd25zdHJlYW0g
cG9ydCAoZHBvcnQpIG9yIGEgQ1hMIFZIIHJvb3QgcG9ydC4NCj4gK0VsaWdpYmxlIHBvcnRzIHdp
bGwgaGF2ZSB0aGVpciAncHJvdG9jb2xfaW5qZWN0YWJsZScgYXR0cmlidXRlIGluICdjeGwtbGlz
dCcNCj4gK3NldCB0byB0cnVlLiBEcG9ydHMgYXJlIHNwZWNpZmllZCBieSBob3N0IG5hbWUgKCIw
MDAwOjBlOjAxLjEiKS4NCj4gKyJtZW1kZXZzIjo6IEEgQ1hMIG1lbW9yeSBkZXZpY2UuIE1lbW9y
eSBkZXZpY2VzIGFyZSBzcGVjaWZpZWQgYnkgZGV2aWNlIG5hbWUNCj4gKygibWVtMCIpLCBkZXZp
Y2UgaWQgKCIwIiksIGFuZC9vciBob3N0IGRldmljZSBuYW1lICgiMDAwMDozNTowMC4wIikuDQo+
ICsNCj4gK1RoZXJlIGFyZSB0d28gdHlwZXMgb2YgZXJyb3JzIHdoaWNoIGNhbiBiZSBpbmplY3Rl
ZDogQ1hMIHByb3RvY29sIGVycm9ycw0KPiArYW5kIGRldmljZSBwb2lzb24uDQo+ICsNCj4gK0NY
TCBwcm90b2NvbCBlcnJvcnMgY2FuIG9ubHkgYmUgdXNlZCB3aXRoIGRvd25zdHJlYW0gcG9ydHMg
KGFzIGRlZmluZWQgYWJvdmUpLg0KPiArUHJvdG9jb2wgZXJyb3JzIGZvbGxvdyB0aGUgZm9ybWF0
IG9mICI8cHJvdG9jb2w+LTxzZXZlcml0eT4iLiBGb3IgZXhhbXBsZSwNCj4gK2EgIm1lbS1mYXRh
bCIgZXJyb3IgaXMgYSBDWEwubWVtIGZhdGFsIHByb3RvY29sIGVycm9yLiBQcm90b2NvbCBlcnJv
cnMgY2FuIGJlDQo+ICtmb3VuZCBpbiB0aGUgImluamVjdGFibGVfcHJvdG9jb2xfZXJyb3JzIiBs
aXN0IHVuZGVyIGEgQ1hMIGJ1cyBvYmplY3QuIFRoaXMNCj4gK2xpc3QgaXMgb25seSBhdmFpbGFi
bGUgd2hlbiB0aGUgQ1hMIGRlYnVnZnMgaXMgYWNjZXNzaWJsZSAobm9ybWFsbHkgbW91bnRlZA0K
PiArYXQgIi9zeXMva2VybmVsL2RlYnVnL2N4bCIpLiBGb3IgZXhhbXBsZToNCj4gKw0KPiArLS0t
LQ0KPiArDQo+ICsjIGN4bCBsaXN0IC1CDQo+ICtbDQo+ICvCoCB7DQo+ICsJImJ1cyI6InJvb3Qw
IiwNCj4gKwkicHJvdmlkZXIiOiJBQ1BJLkNYTCIsDQo+ICsJImluamVjdGFibGVfcHJvdG9jb2xf
ZXJyb3JzIjpbDQo+ICsJwqAgIm1lbS1jb3JyZWN0YWJsZSIsDQo+ICsJwqAgIm1lbS1mYXRhbCIs
DQo+ICsJXQ0KPiArwqAgfQ0KPiArXQ0KPiArDQo+ICstLS0tDQo+ICsNCj4gK0NYTCBwcm90b2Nv
bCAoQ1hMLmNhY2hlL21lbSkgZXJyb3IgaW5qZWN0aW9uIHJlcXVpcmVzIHRoZSBwbGF0Zm9ybSB0
byBzdXBwb3J0DQo+ICtBQ1BJIHY2LjUrIGVycm9yIGluamVjdGlvbiAoRUlOSikuIEluIGFkZGl0
aW9uIHRvIHBsYXRmb3JtIHN1cHBvcnQsIHRoZQ0KPiArQ09ORklHX0FDUElfQVBFSV9FSU5KIGFu
ZCBDT05GSUdfQUNQSV9BUEVJX0VJTkpfQ1hMIGtlcm5lbCBjb25maWd1cmF0aW9uIG9wdGlvbnMN
Cj4gK3dpbGwgbmVlZCB0byBiZSBlbmFibGVkLiBGb3IgbW9yZSBpbmZvcm1hdGlvbiwgdmlldyB0
aGUgTGludXgga2VybmVsIGRvY3VtZW50YXRpb24NCj4gK29uIEVJTkouIEV4YW1wbGUgdXNpbmcg
dGhlIGJ1cyBvdXRwdXQgYWJvdmU6DQo+ICsNCj4gKy0tLS0NCj4gKw0KPiArIyBjeGwgbGlzdCAt
VFANCj4gKyBbDQo+ICvCoCB7DQo+ICvCoMKgwqAgInBvcnQiOiJwb3J0MSIsDQo+ICvCoMKgwqAg
Imhvc3QiOiJwY2kwMDAwOmUwIiwNCj4gK8KgwqDCoCAiZGVwdGgiOjEsDQo+ICvCoMKgwqAgImRl
Y29kZXJzX2NvbW1pdHRlZCI6MSwNCj4gK8KgwqDCoCAibnJfZHBvcnRzIjoxLA0KPiArwqDCoMKg
ICJkcG9ydHMiOlsNCj4gK8KgwqDCoMKgwqAgew0KPiArwqDCoMKgwqDCoMKgwqAgImRwb3J0Ijoi
MDAwMDplMDowMS4xIiwNCj4gK8KgwqDCoMKgwqDCoMKgICJhbGlhcyI6ImRldmljZTowMiIsDQo+
ICvCoMKgwqDCoMKgwqDCoCAiaWQiOjAsDQo+ICvCoMKgwqDCoMKgwqDCoCAicHJvdG9jb2xfaW5q
ZWN0YWJsZSI6dHJ1ZQ0KPiArwqDCoMKgwqDCoCB9DQo+ICvCoMKgwqAgXQ0KPiArwqAgfQ0KPiAr
XQ0KPiArDQo+ICsjIGN4bCBpbmplY3QtZXJyb3IgIjAwMDA6ZTA6MDEuMSIgLXQgbWVtLWNvcnJl
Y3RhYmxlDQo+ICtjeGwgaW5qZWN0LWVycm9yOiBpbmplY3RfcHJvdG9fZXJyOiBpbmplY3RlZCBt
ZW0tY29ycmVjdGFibGUgcHJvdG9jb2wgZXJyb3IuDQo+ICsNCj4gKy0tLS0NCj4gKw0KPiArRGV2
aWNlIHBvaXNvbiBjYW4gb25seSBieSB1c2VkIHdpdGggQ1hMIG1lbW9yeSBkZXZpY2VzLiBBIGRl
dmljZSBwaHlzaWNhbCBhZGRyZXNzDQo+ICsoRFBBKSBpcyByZXF1aXJlZCB0byBkbyBwb2lzb24g
aW5qZWN0aW9uLiBEUEFzIHJhbmdlIGZyb20gMCB0byB0aGUgc2l6ZSBvZg0KPiArZGV2aWNlJ3Mg
bWVtb3J5LCB3aGljaCBjYW4gYmUgZm91bmQgdXNpbmcgJ2N4bC1saXN0Jy4gQW4gZXhhbXBsZSBp
bmplY3Rpb246DQo+ICsNCj4gKy0tLS0NCj4gKw0KPiArIyBjeGwgaW5qZWN0LWVycm9yIG1lbTAg
LXQgcG9pc29uIC1hIDB4MTAwMA0KPiArcG9pc29uIGluamVjdGVkIGF0IG1lbTA6MHgxMDAwDQo+
ICsjIGN4bCBsaXN0IC1tIG1lbTAgLXUgLS1tZWRpYS1lcnJvcnMNCj4gK3sNCj4gK8KgICJtZW1k
ZXYiOiJtZW0wIiwNCj4gK8KgICJyYW1fc2l6ZSI6IjI1Ni4wMCBNaUIgKDI2OC40NCBNQikiLA0K
PiArwqAgInNlcmlhbCI6IjAiLA0KPiArwqAgImhvc3QiOiIwMDAwOjBkOjAwLjAiLA0KPiArwqAg
ImZpcm13YXJlX3ZlcnNpb24iOiJCV0ZXIFZFUlNJT04gMDAiLA0KPiArwqAgIm1lZGlhX2Vycm9y
cyI6Ww0KPiArwqDCoMKgIHsNCj4gK8KgwqDCoMKgwqAgIm9mZnNldCI6IjB4MTAwMCIsDQo+ICvC
oMKgwqDCoMKgICJsZW5ndGgiOjY0LA0KPiArwqDCoMKgwqDCoCAic291cmNlIjoiSW5qZWN0ZWQi
DQo+ICvCoMKgwqAgfQ0KPiArwqAgXQ0KPiArfQ0KPiArDQo+ICstLS0tDQoNCkl0IGZlZWxzIHRv
IG1lIGxpa2UgdGhlIHR3byBpbmplY3Rpb24gJ21vZGVzJyBzaG91bGQgcmVhbGx5IGJlIHR3bw0K
c2VwYXJhdGUgY29tbWFuZHMsIGVzcGVjaWFsbHkgc2luY2UgdGhleSBhY3Qgb24gZGlmZmVyZW50
IGNsYXNzZXMgb2YNCnRhcmdldHMuDQoNClNvIGVzc2VudGlhbGx5LCBzcGxpdCBib3RoIHRoZSBp
bmplY3Rpb24gYW5kIGNsZWFyIGNvbW1hbmRzIGludG86DQoNCmluamVjdC1wcm90b2NvbC1lcnJv
cg0KaW5qZWN0LW1lZGlhLWVycm9yDQpjbGVhci1wcm90b2NvbC1lcnJvcg0KY2xlYXItbWVkaWEt
ZXJyb3IuDQoNClRoYXQgd2F5IHRoZSB0YXJnZXQgb3BlcmFuZHMgZm9yIHRoZW0gYXJlIHdlbGwg
ZGVmaW5lZCAtIGkuZS4gcG9ydA0Kb2JqZWN0cyBmb3IgcHJvdG9jb2wgZXJyb3JzIGFuZCBtZW1k
ZXZzIGZvciBtZWRpYSBlcnJvcnMuDQoNCg0KQW5vdGhlciB0aGluZyAtIGFuZCBJJ20gbm90IHRv
byBhdHRhY2hlZCB0byBlaXRoZXIgd2F5IGZvciB0aGlzIC0NCg0KVGhlIC10ICdsb25nLXN0cmlu
ZycgZmVlbHMgYSBiaXQgYXdrd2FyZC4gQ291bGQgaXQgYmUgc3BsaXQgaW50bw0Kc29tZXRoaW5n
IGxpa2U6DQoNCiAgLS10YXJnZXQ9e21lbSxjYWNoZX0gLS10eXBlPXtjb3JyZWN0YWJsZSx1bmNv
cnJlY3RhYmxlLGZhdGFsfQ0KDQpBbmQgdGhlbiAnY29tcG9zZScgdGhlIGFjdHVhbCB0aGluZyBi
ZWluZyBpbmplY3RlZCBmcm9tIHRob3NlIG9wdGlvbnM/DQpPciBpcyB0aGF0IHVubmVjZXNzYXJ5
IGd5bW5hc3RpY3M/DQoNCg==
