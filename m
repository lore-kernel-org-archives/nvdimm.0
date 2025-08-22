Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F02028CF5F
	for <nvdimm@lists.linux.dev>; Fri, 22 Aug 2025 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755886451; cv=fail; b=GqhN1S/vzklryPKu2RDuvzcm/C2PPaCYCi4skWrIR10qB2XxEW2JHPGysHv0hNe/11pUIA7jLXvhhN5BciHRc13wsTBY4yaRNvBWgy8Vpn6jzlicnT8tEn2eCsUn9ldyaEx3GkTMZ8XmWTwfqMI7GvVu+aRLnSYP/FDHJd1aM28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755886451; c=relaxed/simple;
	bh=iCHMyA7aQhtIODsv0/dSDK71OOx0TCHyKCKLe9+ShEY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ORDy21EqBiYLyWa/qpNMWwE/SrsYQGsshzWCAjjtQQvmBhAsP7K3rLZ9vxwKA4omEQDk7qGD6AZtsUnglNNRo0kuKWmIyrlV94lMRrSwo90OnRA1c1f0ETynxADpODDUmc3Z4UwVRrqW31Czvm3IZXYrQbvZ6r8RDK1zctmqA4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eeVPgo2E; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eeVPgo2E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755886449; x=1787422449;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iCHMyA7aQhtIODsv0/dSDK71OOx0TCHyKCKLe9+ShEY=;
  b=eeVPgo2E0avo3YWJD7d3Gyqx4yeAQ7k1I99+0He317dgwBp+gGjpiSbz
   E+NkuxmDQKOgePkpeR46RWyhu5tMY8zIbOFOByy8t6IPc63YX7PPqtiRu
   7K4Bg7uvPQbQZcE15t0sboSocRpta2Y+ERaYmC75LZa+bE8WRiznNPFM/
   bQSlEER4j9FCO520su3IsueDbrRE+ASymNzsr1A0gFgXnjjeIy4gGUBgE
   NvTqKDMOIFjojWvbvE/54CuNGRfbRzQyUbzJFgEHQQ2aXNjaqFGkHvL1X
   COtrqQVy7sqLoF1ncVTiLZfb9WnyC7bAd6VtRAeCkPWEBgPjs19WmhcMz
   Q==;
X-CSE-ConnectionGUID: hf0iNUF1TFWz0vTbhoarIw==
X-CSE-MsgGUID: nxcZyhTTSWOS7/ScAlCFQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75656148"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="75656148"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 11:14:08 -0700
X-CSE-ConnectionGUID: hPGdGkSWRkyhb7qlF4k75A==
X-CSE-MsgGUID: uKtj2OCJRwK3TcrieEA+Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168275373"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 11:14:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 11:14:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 11:14:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.76)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 11:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtoWvof0SqqAtAhvfwy+UNmPHATT6oys4/oxkmWDJ+IApAmRZsnQF+fiRWpdahuVsdCkFCUMXz7Sela4hKnE70raM2ehPADxRWe0oSwQh5N5HCvpCKNFQSlo0pXdWa//8DRtvG+JQfbClEh27APor5i9kxusxBTA0KwY/1Y+NFEhPvQTpqNmtSYYthgFl0ZCEFXGMo5wy/Umkkr1FkxzkJ9Q9VGGB4l38tNutw5ogVWuIc6YznqNZyUbxY0MuDtlBeQS4lLZD7CSr4V5JvUjwSpEmm5EaE8+5Fk/jIuBaQ/x5hDPtI5XEXASj7iwm3Gs40dpFTX3dRGKXcaQve786w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YV46ISemyULlrR60lKzI6kOx+LD7bVFYMHWK0cka6aE=;
 b=lfCzkYeCkgjYGeVNu3cLEHncwg0hQ+xELbS2tsgBaEPM798ShTuMHGyEMBNZ+CLVFM1tKxKMC6fDkOBr1v6XjDv8ua+JsWaQFMQ+6OBkLU65tDNKkWulD+Pa3fqK2+K72exRFQUGYJK61xhQ6lrrjHWDYBvuJIlyI2ldZMC6+HJ5+N5TYeBbq5vkELTohYggJhlclF7viPVzGQX0kDBM+VAl1Vckn2kD1P6sYVtTPX5KzC2K0FEE/iJ+tImFyhYxZFFoUvaVw9PanQMQDtpvQ+4gdw9yg9uuU5MUPwRDQU1Aafgz6J5CX8mf0WTuaEmVmY8WAWOS7xG+zSRA2SRNfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by MW5PR11MB5931.namprd11.prod.outlook.com
 (2603:10b6:303:198::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 18:14:04 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%7]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 18:14:04 +0000
Date: Fri, 22 Aug 2025 11:13:57 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave.jiang@intel.com>
Subject: Re: [ndctl PATCH] test/common: document magic number
 CXL_TEST_QOS_CLASS=42
Message-ID: <aKizZaxYjEJ3g_Rc@aschofie-mobl2.lan>
References: <20250822025533.1159539-2-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250822025533.1159539-2-marc.herbert@linux.intel.com>
X-ClientProxiedBy: BY3PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::26) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|MW5PR11MB5931:EE_
X-MS-Office365-Filtering-Correlation-Id: a79d226b-8c77-40a3-2d7e-08dde1a7ad92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tD62uaM9uW1zDo1i773jlJThye33ocTbKCxMEl37EvQ4rocXUVV+eHuWHOQI?=
 =?us-ascii?Q?LjxgInL8o8VS9jWpd+0l097va3NjiKvYmY/oU6rfCI3CHxoPa94zgCKTbfse?=
 =?us-ascii?Q?bIuTOtVsD/mRGAwDTqYIuiaDblacGs+kpGZD7TPImNOGi3v0EFZVDca4tmyx?=
 =?us-ascii?Q?A0XIecrQYzFQM/1Oi/xZDJz02usAVKs5Q/gnXIgih9Wwguvk8YZz45rjZedZ?=
 =?us-ascii?Q?V5urnWYFaSe2e6I12av8IylUDsMhA/wFxE4AOwrPsGqKQYgx54xNLCDG4uSm?=
 =?us-ascii?Q?wPgipoRbZwk9WPOBb6IT5AoGr1rRgwKUkPFPg6UVy6WCOBCuYNYUvCfkGJ3O?=
 =?us-ascii?Q?uY5Dlr+AYEbve2eouh1gHym4TJgDZ/I+1flJlNBCSyq0QlpahVZslJ8EjLFV?=
 =?us-ascii?Q?geMWTYC7qYxLDUnxIFo78stIGGyi/85INYumGe3aN62fpaP/AjPC/1xzf01V?=
 =?us-ascii?Q?IkMkGl/VmuWt1caKHM0JQo/BggvtP5MMNm0PA80iNb5SKSmeXCOVgsj/kFPN?=
 =?us-ascii?Q?5CesluPMiFixUJAYtekFxMW5kMJu64xWT9m840R0OfUbAPfYF/58HG8rJFj3?=
 =?us-ascii?Q?vzYIoHGp4iLeb92tEIvudlrpwjgKddNiSpj3Rs+8yXgzjTK1z0AZkXa+i+ut?=
 =?us-ascii?Q?oM/eVkxDeE3+eqJQpQWVg3TG2ue0h9ekuwEPFp5FGO372XVVUBwZPmavUU1Z?=
 =?us-ascii?Q?iVOYUxVYMuTEV/TlgxGG9c8ZPl50D3/6Ye/nZsVi9kmz3mwNkHyp91UYslnH?=
 =?us-ascii?Q?ehfBc5kUq8QIj5GRdOUootboNwFscMDlYDICcbHmW2MIw8mFMckGwlp55/3b?=
 =?us-ascii?Q?CY0eqGmT4IRb5ULT1ozLQQoGu4s3oTE/W6zfUflCmd8NfFDZ2i8jCAUSCWHg?=
 =?us-ascii?Q?CPtU2tvVArX41Me9n5peETbEEMrqTC7Yyp4b7zRJotpB82Q57vJASn6Wne6C?=
 =?us-ascii?Q?Z5tj8iQPcKT1yewcsHRunQk8xV48eEtPqGBvMy/0CPp90mCUZq0H2spkDYCh?=
 =?us-ascii?Q?fyqRv6++TKqq/2p5RFGk7GPZrCGxHoHvU7rFIqJBbyJpKMJOUDslPRPy5FoY?=
 =?us-ascii?Q?cncnQvqpzoLwXDOMz6W93J1WiTYGrqJxPLTj31c+MnLRg3tvoBfo3mBaeg1r?=
 =?us-ascii?Q?47Wx8ZtwHGWFSl9v/j2FebammKAuwVDuVMoFI4mJZ3h+vgOIiLzCHCkmZcSR?=
 =?us-ascii?Q?nGSucUSRdouaM8Q34prS1GPlwuGIAxgFC+NZAr+dh9W3RSwi1inLuMQptDg7?=
 =?us-ascii?Q?ZyS3XhqOs2rBaEdrPBcPSf9rpVld0WfYR56rRBCdsiZCQcCA6GktyvwSR88N?=
 =?us-ascii?Q?ygx4NiZkbYnZm3iojDQVTjUYhm+2ZA3KA8qx5BMDZei/cbbLnhDEWDWTSzEo?=
 =?us-ascii?Q?6a/jLWO49yh/JwCto+1sBKKIAMalokmiDC3BkGjpee01nI6iryNFbhdA88ZM?=
 =?us-ascii?Q?Rtij0SFQ4gw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s/7lSrsoNA/t829oYdtawqzOgnkX+VyvuCLeVJp0IsQzZbKD31T+iYC9DGMT?=
 =?us-ascii?Q?HD+Onl3EpATK1M+lY1pn9W/zWWBXIlLqUpGmffT4JY6/LUl/zG7awDLG5dnK?=
 =?us-ascii?Q?ixLmuU5GJjn4kYYMBH6yZfeX2xnlqkLRCFuuJ2pfrz4vA/l+LNSM2G8oo3sn?=
 =?us-ascii?Q?rcnnAgGg6qhql0pZQquR9UQstKuAyR1+7TpUHFp7WnZfL9FUE/norkcRnmQW?=
 =?us-ascii?Q?BIs3vzfA+G11hOtzZ1yHAYzrIZiF797EexhyYWmG/BpYzJy6+Z3GZIAiEuON?=
 =?us-ascii?Q?oLRJ8FZwfwv01uIJ8IL7h9JF06+DO7wDqQjbOktGBpac1lqFFbR0sqLGWnK7?=
 =?us-ascii?Q?mo9rFmwkdGA+1krpKzWALwR/bY022Qt3K05Orl2m/FUcu3WbLWMR8hQPQVFn?=
 =?us-ascii?Q?HD2R4JzZZB87gFkPCrjK9pEW8D1MFL3N3cYich1sQ3kdzjpI0woWL5bnwDYD?=
 =?us-ascii?Q?GJplYyU6QMO5Kaq8uBGLJH8LokIDL/NbcmW0LMxQnFuZZbTGM2msMWovH/S/?=
 =?us-ascii?Q?ub3h3N2a60wF7sxu8DpL0gFAH8kriTh9wt+BGVUByC11HLigOmzp0rL/Rx+L?=
 =?us-ascii?Q?tHr6KWvmsAXxut6h3hJtDwPz15YUBKyh7iPdf9ySz3XwDDzGRUkFdfiIKGXr?=
 =?us-ascii?Q?y5a2T3J2KaFlakHVHjjE4HYlTJLsp01unHvihM3M2+M0X+8rXN4G83KRVGmj?=
 =?us-ascii?Q?kGPnB2SsO9HZH6VF59tZyPxSe5lpus8i/5L/97QHSo/YqLRxNlP7YFoQGb9B?=
 =?us-ascii?Q?NyYY6FvEx2E1h1+AVL4+Qi3a/et8bxGPoMVgvcO9IIk1NWlutA8+ISpbxVVD?=
 =?us-ascii?Q?NYCuffRiTgtj41mTNx/UvTpCpQyhsBRWl4ouBwLJljYfaMkIoE9Q7hbzPGny?=
 =?us-ascii?Q?fkvO/CpXNXYnmOZSgJcOUagiZYOZnjsFomLXdI/Lu8ls+X1xozfP5vKgPrPh?=
 =?us-ascii?Q?DOBiSHlzpkQHraFuNYf4wcudMsfazw3owSPkJ1+77M9BLHH91ZSSbUH8x1yr?=
 =?us-ascii?Q?eOmTi8zNGQR9SFBf3I8SecB8oM2241BcMMwzf8N8imw2NtzBbLqV0s3YKQw6?=
 =?us-ascii?Q?cqF7o3Hc7CcGaJJJTvSyCXZsf0DeON/fJyIyyb95QrdEwXJmn4QAhlsYqbBK?=
 =?us-ascii?Q?83NuZ8x8c7cUugVbglro3ySd7kH0eFGPbGQE21/SHKXcna+1d70EhaXBjLDP?=
 =?us-ascii?Q?IzmUil9n8jSydRLhyx6ZhAKuS0iwiLiQyFkZq3D5RLCO+WvBGHucMPCD3ayJ?=
 =?us-ascii?Q?Q0eVCWh8YEC0FM9VUU9h1H2zqwt303bAVwiPVlk6MiJj3uC6fzu9Ba3Mh+W/?=
 =?us-ascii?Q?94a6t8ietOafx+QZc/5P11KqxJ0q2FUlgKGUvx7JSn9lpD1yDjB7rX4V71ul?=
 =?us-ascii?Q?PQsb6EJyC2U1jr1uPjnXRKbl+EfJ6rDGN1GiUyjWN94O1x3u+hSZFxXUcoxU?=
 =?us-ascii?Q?FxrtD1rr6fkXUikjyIlW72zgHfhh3AlsZgD76zWfYqyhw95iVhkwCQCQSXV+?=
 =?us-ascii?Q?QccqXnv8FSEdu7AT7JwNjt0tZKubLkB6bWIvGLBvZBw/a59iwPHvplEeP58g?=
 =?us-ascii?Q?En6RdQJXNuWFpL33qoAMpaMXGrlSsEURbU9deAhlmsIC9Lggn9pCLWRCM5GF?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a79d226b-8c77-40a3-2d7e-08dde1a7ad92
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 18:14:04.6502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h16Fklab/QMry0XwwIla20jn/hwpImVk9xQGeO7NWIvyqwiWO0mhSSpkr9tK4zcyp9hLOB6h8ScO4pwhLDXgJo95yQ2kaPr3VdlDitdFf3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5931
X-OriginatorOrg: intel.com

On Fri, Aug 22, 2025 at 02:55:34AM +0000, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> This magic number must match kernel code. Make that corresponding kernel
> code much less time-consuming to find.

The 'must match' is the important part. Include that in the comment.
Why expect the user to parse a git describe string and go fishing.
Just tell them it is defined in the cxl-test module.

See below...

> 
> Additionally, that same one-line reference indirectly documents the
> minimum kernel version required by the test(s) using this value (only
> cxl-qos-class.sh at this time)
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
> ---
>  test/common | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/common b/test/common
> index 2d076402ef7c..1ab62be6994f 100644
> --- a/test/common
> +++ b/test/common
> @@ -155,4 +155,5 @@ check_dmesg()
>  }
>  
>  # CXL COMMON
> +# Test constant defined in kernel commit v6.8-rc2-9-g117132edc690

# Must match the FAKE_QTG_ID defined in the cxl-test module

>  CXL_TEST_QOS_CLASS=42
> -- 
> 2.50.1
> 
