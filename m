Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ED46AA2
	for <nvdimm@lists.linux.dev>; Fri,  1 Dec 2023 04:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AkeTVn7s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701403965; x=1732939965;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6ZEcN73Om6DVV8MYm4mkjzY0FArzY9AJdaz8B1dmwz8=;
  b=AkeTVn7sdD0OiT9n5LuKLFR+R/OGanh/gktPtpYb5eDcy6/QxEmmnSWE
   pnViMgNiVGZ9dxdOC/9JZoL+ZApJhWzNyeIPg3nQacvxyo13PGyoAv8Wq
   QXGsaFh626feIN5A11qn4jrXUxntQnkWimXPim/3Ms4Bxi9E+tBAe142x
   yAXSrH9JGCD5XnKZkVxG5DRu0SQCawFXcnjIgHMaKURHNfZ0QhGA3hlo7
   Jkin9lhPOiz+ns/UztnmBqOXSML+BJjjzHaCdvpBaAiad4uSkCX45qeGA
   HlGaM7gVkJvmP/m6FfPLFRtjxyFMixA7dQJVJpER8cRgw855rOQFc7P35
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="392302309"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="392302309"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 20:12:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="762983353"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="762983353"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 20:12:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 20:12:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 20:12:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 20:12:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRbKhIjT4oEBl2quxUXTLVP54crPloDDE6BztmmZkszbWuf+0TW1a6YckeLdGvFTa44lT9QoQSK7bPRHgBVs6T/k50Svjph4bJWCMFivSd08RoQ5+QREWS5uN7NUWpgjO0RwPhNm7PvxbGT/OeRmGQNfTOwve4H6SwliCVsZzvKhBjJJ2WbqnMFs/JlWNcwxivmsI7/fgzQ7pz56LWv1rRH7vbWYNdFVV1ydHlqC35zjBDSCwQX9Ek7gJ0yv/oTryDPI7r0gf9a5qo0CsE9IEqpJllPe3Z+arC7Gce35GSQE4bhWmGkSahsrwuWRVeKKUJU8gG1xtLmqc56YQ+aqHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujDuScbnn6cA4XTiGhR67ajQmhSUs3zMQ9a4sSiaEyI=;
 b=MGj1EUP/VC+i4qaqMvgfCXF3BD74ponotjFJdgWLIVyleB8sEiiVOSdkE2ReWOK6LijCncAlm/RFdVPH68O/ho51pKIz7XLMpezdWgzMQ0DHT/LPclLApwMqGhuIJcg/kjU3JDsmL+WIYlpMbXnUY+sPCKgvdtSfPeObQRgc5wdDcGSXX+/TxokkeTvo3+qnKprznP9tgK7rp2+RxIe1TS6zP3xxwv1WM/9KyZrpmZIzlZmhNW4JqDU24rRObLCJ2oSShhcv8i4MhSH1k0/VQnwy26DzVUA/ICj9QLwnvQpqhK/l+5zJg4Nyz95AhU0hQo9kHTstwlMrYobUzRejhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 04:12:41 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c%4]) with mapi id 15.20.7046.015; Fri, 1 Dec 2023
 04:12:41 +0000
Date: Thu, 30 Nov 2023 20:12:36 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "fan.ni@gmx.us" <fan.ni@gmx.us>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: RE: [PATCH v2] daxctl: Remove unused memory_zone and mem_zone
Message-ID: <65695d348908f_110db929496@iweiny-mobl.notmuch>
References: <20230811011618.17290-1-yangx.jy@fujitsu.com>
 <TYCPR01MB10023F98F51B2AFE3E6B65A0E83CEA@TYCPR01MB10023.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <TYCPR01MB10023F98F51B2AFE3E6B65A0E83CEA@TYCPR01MB10023.jpnprd01.prod.outlook.com>
X-ClientProxiedBy: SJ0PR05CA0172.namprd05.prod.outlook.com
 (2603:10b6:a03:339::27) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ1PR11MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: 32660942-3791-4517-02c6-08dbf223c248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VKnKJWc0mDtClqFhe1UexRQ1EYv4v8JLYhoiC7vCCBWd3iV4/tDks+wzAAOBK5TJZTCMvRtrVDwLbn05Rzqwt+A7rPzovRw3KMpniUrQioWTKdZNGQ7hkO1yesV6SqDAyyMF8LZk3/c3qJUctWJzkHXWfoITL6vVcsElaLfp3jLK1IIFFoexBXlEU5bDA4t0nHbNfJXHCHSGml/KrhO35ZzaVLqeQ4LqtaKtQkxb9bQmZ2Vy6E1GlHECbj+fMnh4YWdm3kj+1Y+wWWMbVTzrhSBpJlYinfaMBlVu5djDVyXwnXC/J9m9l3wkx7vTJvd0g/ACtHIP0jV3DoWZ4EldKbEgtCppOMCzVGUp5HkDkPBcvemLbG0jWk5WOuo98dEQcJmVAvhpTC8LbHjhGGG40E0TH4VCTxuWHACoVXTdaT4ER0it8U2p2+01C2l9rH++In9QbfC5ccdqXGtphIrOGX1r0Xb7DATLWFRICqcXJ+2Lgwx/hyQBXUiezk4A8pbBvw0c9sCVNXL1dSk2UjQMbPW9l7pw9aaRo99MJtqo++CaGLrNu3GhqmppLO5qi3A6BrBvIOYBed4vP2DpAePjTQ369Ken56zPkV5C80iFoqsZfXGPR0/bcZ89dufZdkD5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(136003)(396003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(41300700001)(38100700002)(4744005)(2906002)(86362001)(110136005)(6512007)(82960400001)(66946007)(9686003)(6666004)(478600001)(26005)(6506007)(53546011)(6486002)(83380400001)(5660300002)(44832011)(4326008)(316002)(66556008)(66476007)(8676002)(8936002)(520744002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWxmbmhkMnpCM1F3QnZsS0RxOXdNL0hrZ0IvSndEb2tnT0loUTlBbGl3MGFa?=
 =?utf-8?B?RWpuUmpsdUtHVHBtV2IyQU9GaTRiOHRrRlFTQlJXdFJYR0JCY3NCQm9Pc09m?=
 =?utf-8?B?SHdUZERmL01yODlWMCtlZ28xMFFDMU5SNkl4MGxGaUNPTW0vSHBhY1I5TWdB?=
 =?utf-8?B?QnZoQTZpL3JtcXVCQldaVk1CZnlKUFNrb3lKeXF2RVN1Sy9CTzVzS2xnTlV5?=
 =?utf-8?B?NjE0alVORkNHNWhkcm55NWpUZExhUkE1WnNKeWdvRnBTZU1rVHQ5WjZ4MjN4?=
 =?utf-8?B?eUZzWVUwcmU2cStkdmRNQXNNbUVlNzZRRXkraUZaUmRNZEN1LytPeGJ2bkZ4?=
 =?utf-8?B?dWt6aUpuRmR6ekZlV2o4bDZ4UmxHdmE4SWdCL3dmNkFySDRxVC9jUFk2RndI?=
 =?utf-8?B?SmJTQW5IUkNvMCtDTnFiRUlwczRHaC9DcEtaSks0cDBDaTA3Qmx0NURudlI3?=
 =?utf-8?B?Z1g5c0ZWZjFwTjNDOUF4VTE3RThGUU5TK2xtOXd4eWdMeEZuS2tJUE12bTJW?=
 =?utf-8?B?NkVhYzdRU3JDeUw5cVRKSkx1Si9LZG10bzc1TDd2NnE2WEk4K2pvNnBBamRh?=
 =?utf-8?B?QU0rYmQ0aE1ZUEh2VGpsZnpsYmM2WG9XWFIzN05Db2JhQ0lNTWtVUi9yWHhC?=
 =?utf-8?B?bGtCUnpJRUM5cHQ0ZWJBeUNQN0dudWpqbGg5cldERkh4QTgwbkFhU3hnWFRJ?=
 =?utf-8?B?OGVLUFBCcEhsTWVVWXpVTVlPK2JQb3FwQk1KS2hvOGxuMlUvaDJPZnU5RVFh?=
 =?utf-8?B?NXhJaStoQ1RZRkF2dWFjN0FacmYwbFpwSHg4Z0l4dy9FRWhzMTBqVWgybVli?=
 =?utf-8?B?bUxGcXpReFMxS1M3R3RDZmpOMnNoS0ppMFNYZVZ6dzZzbXdKd0VMYThpQjRy?=
 =?utf-8?B?R2hMeUlWc3ZENFRPa1U3L2d6dVJTVWs0NWdKYWVldXdCSEZ4ZjNOZGxRZERJ?=
 =?utf-8?B?Mmo2NjdrSDhGUk95dWQzbmY3c0lHVUtibGJST2VQL21yRmFqV0ZMQUc0MUpB?=
 =?utf-8?B?TTRLNThNd25CUG5OZS9taUZYbHMwekVBZHhrdWZENFlZeTFCY3JnMk9rTlJ5?=
 =?utf-8?B?M2xBeWtZYVJ0cVhYaElXSnBrVEIwd1dLcTRVWko0YTdkS3dmMXVUdWRCTHIx?=
 =?utf-8?B?RGt1d3hzTjN0elJhbEo3YzFmOHFIZW5pRVhnVjEvUFIyekt3RXhWWk5tT3ZR?=
 =?utf-8?B?VGFjRHkrY3dMbTlNT2pBMXpVTjEzelUwMTRpaWlCcGpnWE4zM1dmWFE5ajNo?=
 =?utf-8?B?dWhYMHdObURpamk4bW8ramZnVzRWZ09Fd09MNFM3a250b21BV2hpelAyRzVx?=
 =?utf-8?B?My85M3RDMHY1d2UvMElHSkhYR2VMcEpBTjBYUG8rZU5BTEtDVU8wNmJiZytF?=
 =?utf-8?B?YmdkV3BJSUYxdU9iSld6ZnNXVzZpYkpIaTBoVWt4WmN3ZEtWbWZHNGVwUnVJ?=
 =?utf-8?B?azYzdnZvbzRZN0IxRWZrUEZ0b1hPYktnYWRaUGlCQXFra1FaMEhISE9GaUJU?=
 =?utf-8?B?ekRMNG50Ui9YanpBWFY5VXNnTWJlWUdGVUY2WEJPd2dlV3ZIWW1VWkZ6eE1K?=
 =?utf-8?B?MEFVNzgvMENvc3hmQU5wU2xMczR0dkh0djN1WjdQVzZWU0JXaC9YTmI1VUNJ?=
 =?utf-8?B?ZU9hUzVFRCtLc2ZybGxuY2dlc0xGMWpYUDgwelBIZmFVdFNYNUMvUDlUVnh4?=
 =?utf-8?B?VzJzZnRwdzRKaE5GTXVjWkNCVkRidkRMTWkydkVXVTlqYXlNTTZtU29CVWtS?=
 =?utf-8?B?SUxUNmd1VE95aFZOeW1YNlcrdGpUMTZCN3hlaXErYWxnYnhFRWE0MDdLNnU2?=
 =?utf-8?B?TGxPeWs5dUJQRGtmMnAvYm1JN0tRUFlMeW1hZW9ZWDB3NFJTNVAwM2N6T1V5?=
 =?utf-8?B?ajF4V1RMWEFCeldwc0QzRjNaZGdraHJaNCtKdVdCZkw3R0I5R0RlYWlOQnlK?=
 =?utf-8?B?MUNrQ0U2dnlyWlQ1WXVWeVlHOVRtVElMaXNZN0JpUnhBWmhOelRvWWViU1Q4?=
 =?utf-8?B?ekhScXN4RDcvTGhOSFdTbGRTMXNjeWJxNHQxSml0OVZia3dRKytreGFxVHd0?=
 =?utf-8?B?UldTZ21OOGVOd0JWeFZ3WXV0ZTNtTlVtWVplSW53WjBhamZQNThtcTVIcTgz?=
 =?utf-8?Q?5yu54DNBqDzPP/kcHR0LcQQqK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32660942-3791-4517-02c6-08dbf223c248
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 04:12:40.2710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcpNXEYn1RS2aH1CZSthus0S74lqd8SuwV+8bxdc696qPy+/C0ILm9JTnlOx3uWAPqk32NSAP7bdyLGHy1YwGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6297
X-OriginatorOrg: intel.com

Xiao Yang (Fujitsu) wrote:
> Ping. ^_^
> 
> -----Original Message-----
> From: Xiao Yang <yangx.jy@fujitsu.com> 
> Sent: 2023年8月11日 9:16
> To: vishal.l.verma@intel.com; fan.ni@gmx.us; nvdimm@lists.linux.dev
> Cc: linux-cxl@vger.kernel.org; Yang, Xiao/杨 晓 <yangx.jy@fujitsu.com>
> Subject: [PATCH v2] daxctl: Remove unused memory_zone and mem_zone
> 
> The enum memory_zone definition and mem_zone variable have never been used so remove them.

NIT: I don't know that they have never been used but they certainly seem
to have been moved to the library.

> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
