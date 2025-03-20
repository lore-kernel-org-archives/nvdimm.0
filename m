Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55021859F
	for <nvdimm@lists.linux.dev>; Thu, 20 Mar 2025 11:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742468864; cv=fail; b=toXWReP1uo41VRylzHWr17XW8Y5LPbT6eSh6skyKtd40uWeCvre8gVOg0HkZoycvzF+R/pFBB+qD3YW2k59rMdhuqn0qt52KiJ4DIke6pJ6HPnLaqzxSoY89It0y0jqi10zZU6KX2prNgdmrwsPQSYKbs113ElvHUbtGyEsDwPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742468864; c=relaxed/simple;
	bh=+E6e8eMc8FwwoK48uwwXQ6Ls6aUo34RxNyg5fKhefko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O01nbsVw2mk5zvOZNys1lWEKLaLTU33M1uGhMQ5dN7DB60tO1nykGmFePvIAkFhy4KFp5jaabe/4sDQgbRNaUBST2jmNID/Lc9g9Z1FuRdGUGBgXYOdPF179PcZ+yqOJbWGWFzs13i4ovkt7QxYZeTuxHk/8asDKtIHcieCLZqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UO/h1Vns; arc=fail smtp.client-ip=40.107.237.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UO/h1Vns"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZ0geWx2A8T/7wcS3T7XcKbYkTbXKw2ZmpqTV19culYiKKejqnqE4qCRK+aWWpbbYWKciVR/EO7D87rXXvGfqqVbyBr2krIjXOYPpV0lDdMCb5P3OecLG22kaXHZXbSXHazmpWocDkvBtc3rqXet9i4IOn49MhsH/wwztdyBwgA+BiWK4lwrg1QmS2VmGry2Nrk+dwPIoB33zLQk+bMD2ODhY9H5x8yVAY0F6Aw4haFkZ24fsRPvEfAfUxn3XstejWTkR6ZnIrYUJtJvb6oBtL2RAb05lTfGFo4oi9ReIdL/vGl8Oa3k6kV1kjPCalfzD2DDblEvsJTtEArEiS9Wgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0enQEsZd06zD7hSGIhFpyAZYv3Fmn428iT1NV6GYM8=;
 b=XrwUqqbg+0/Ok4NexMn6fmA7oboZL4TuIknrYhB9e95rPHH4BLdNXfrbLKjOyaxjyPFvB9yVGZpUOqiwXCke+WQ/vxbwFZSucUH6LRwa1Rc0RpF8w3puCzH/oRwe1Z1Ywb3rN56h6bsQLGGUOW+sw4uxe2skzxeNj+aRRum6sTS7ZIvUREiM9oze5/AO8oE9QQv3GkVZsDLVCvvaQeplJtp/cOeZrhyCIDILJ87hkn78XVtb66QiFxL0xaEUGIDiXOEUFKa1pmqO02AP5nqZF7zGo2ubxcnH+qzQqYvGbCOKtQtOzeaJrJmtgJGeUoeAt+Wb2Rc5193NKea9WNzI/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0enQEsZd06zD7hSGIhFpyAZYv3Fmn428iT1NV6GYM8=;
 b=UO/h1VnsdCf7SHg2ARse92FkXQGCf4l7hzvGne7nHYTGesZ8JOqV0Uovh5rORpAhtmeEpKB8Mth1j6ovz6ZsQTZgGXMUYmNJUxjELJW1csWcqdhukCqSrsk6Q8Fe9UJlGn8xyxSvJ6SsfevzpNyyWRJG+a9zMzF/RvQmfElDLGQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CYYPR12MB8750.namprd12.prod.outlook.com (2603:10b6:930:be::18)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 11:07:39 +0000
Received: from CYYPR12MB8750.namprd12.prod.outlook.com
 ([fe80::b965:1501:b970:e60a]) by CYYPR12MB8750.namprd12.prod.outlook.com
 ([fe80::b965:1501:b970:e60a%7]) with mapi id 15.20.8534.034; Thu, 20 Mar 2025
 11:07:39 +0000
Date: Thu, 20 Mar 2025 12:07:31 +0100
From: Robert Richter <rrichter@amd.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	Davidlohr Bueso <dave@stgolabs.net>,
	Gregory Price <gourry@gourry.net>,
	Terry Bowman <terry.bowman@amd.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH] libnvdimm/labels: Fix divide error in
 nd_label_data_init()
Message-ID: <Z9v28_y6ZYEISqqH@rric.localdomain>
References: <20250319113215.520902-1-rrichter@amd.com>
 <67db1c22365_551042948@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67db1c22365_551042948@iweiny-mobl.notmuch>
X-ClientProxiedBy: FR4P281CA0042.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::12) To CYYPR12MB8750.namprd12.prod.outlook.com
 (2603:10b6:930:be::18)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYYPR12MB8750:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bc0d15f-d34d-4a32-1dd0-08dd679f6d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W4IVR2KxjgS+Oc0mvu00AnjFp9UrmYNjBrSAltD7GLF2xXwICU4adfMytb3A?=
 =?us-ascii?Q?n08Dr8slbX6UFIRFUh9faO061xWpixTDN614Oq9m/AucOLKYT1G/t2vQYBpc?=
 =?us-ascii?Q?0ZsHWOTrdkA/PDNkWLzpBlVkW4H9X+jz9M1hpK0+pwODWj1Oyk9tNG/qdYK0?=
 =?us-ascii?Q?gkr7sBAtn6zn9aOQ7Xz4Q9JMBtNxT6xeNDBXxuUj5ytqxSQue4ziYu5I1Boq?=
 =?us-ascii?Q?ZUeY8YYGwj9hF2PltJ9x5pbTTMwTWCM2bN1ffQvoejAhpw8kg6FG064kyHWp?=
 =?us-ascii?Q?3Bw7cGM/pC3jZKEdR/Kw2MUG++961kzWDkiDyio2yQ8Yylh4Z53HyjaG0+QM?=
 =?us-ascii?Q?vfK3mlrPBzn9Jh1j9GrForLie0J5+FnUQXTVPCzuV3e3H0BNkcPssrZWWYfS?=
 =?us-ascii?Q?o7DX4f1AclO9grxtnDPwBg/y9QXDFPv+UXtzo+9zYJbWF+yhwmX7CkKsLmIM?=
 =?us-ascii?Q?GS6pGDb/iS2zetpbahMZLLW+Cx7Mv5lp9map5PkVH8+T0JBAQGS9Fr1ts+mX?=
 =?us-ascii?Q?xW+IVTZfBgHJIq9rrsdE32+m2mK9jO8srFbGfCaKuhcNdRpHSqnSnD+v4i1p?=
 =?us-ascii?Q?HXCswMbk5I1ne95fRhBI0wq0K4AKKf3zOLDIk0vb3V+2Ucs7zcIGiiIewxZA?=
 =?us-ascii?Q?m/2BOLrma1uvXywRGNuGNp4JdgjSA+HCkTx8jByLQZsBIw7be8hhMwcjCarh?=
 =?us-ascii?Q?ehgCjJpETFf1iJ/Ky7ym9wmlW0mAYrt6RxrzkKRovuM1yMBqNOtyxJgRpKBY?=
 =?us-ascii?Q?2NH5myVAvW5XWN9LopW9XscItnSHv916fpA+ELC+/S+iD9v4pQ5KRfICWs0W?=
 =?us-ascii?Q?hbHC3y3ma4FbZAk83rp0wK9oPBmqnfrhaJBKWRY1TUcY1ChhG3dx6618ozj1?=
 =?us-ascii?Q?MhHesMEry4qql2lbRqkIAFsE8UnpSQkm1ju50ZJpjSZD2E+IMKLIs8y21eYu?=
 =?us-ascii?Q?DmjN91WI2T3mX7UL3XKTWa3faoRP6DThBnDl2MgYpM+EitTe9x97UOYBcoK+?=
 =?us-ascii?Q?XgJ94qngrnMXhLN3JBdbyRnJQEyCim14qGf6I5kui2HAx82xlXJPuil2mCpv?=
 =?us-ascii?Q?DV3eg0FwgqxpgVmMXaY3UgFanNEX1FKeYk96FfStEU5QnnwkPikFTg87DZwW?=
 =?us-ascii?Q?tVhveb6/wQabYvhjKURUGBEJQWPT/f6pJgKl04zK3HCMEsL9y69NEHXYdxCB?=
 =?us-ascii?Q?AHMfdHgf3wJ2g8cowrdPIYDQllsL1+z/PpbLLu2lD74qRSiyPLed4v8lsMbH?=
 =?us-ascii?Q?BMBFeRJafQOeC68WyNV1Iyqjb72ZgcPCHHz9uokZEDFRZiXkpg0NkCakvKw+?=
 =?us-ascii?Q?e/bZOwI/qN+/bD+XSdxKeOZiazPAu6QoBhhr6f/LewoTj8IgPD1CsHOgpf60?=
 =?us-ascii?Q?LzUTf19QzCI4phBTrWxHATsoym/s?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYYPR12MB8750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MNp6DdMcBuAG+mTicl9svmREmR3vjSBu0/AA016xt01RVTT40VO5st3d4BHc?=
 =?us-ascii?Q?eDh25ysb0Lz8tm8bwpzglTZ92bqEpoJWCXcO+hNMyGhKZmABIV2V8x1ae3Ly?=
 =?us-ascii?Q?g0AI0tAdkxgc7XiyJHEuh/dGZYsNzXKdwoik68aCzlyKorZnYP/Qs6c/v298?=
 =?us-ascii?Q?KudcA5WF0pDhQcTYfBrekw5CZ+/iiO9yFtKEhg1FW+3yoMP0nC3g42Y/Shvh?=
 =?us-ascii?Q?4jWL5r5da4J5+0fD0fLhkYIq9Erusi+58dUscdnA7/B4rseiLN2MGLtYI2rh?=
 =?us-ascii?Q?0fo2HEWXGWVOZ/C2yiYH5uBHy+G261RK+2egrNUchdQNWZAPh5Zdv3wMDQDx?=
 =?us-ascii?Q?wLHv2ZSK4/oxaCWnOwBhzr0ypAGcOYGHZuQkE+niCcQUct15zWt+8B0LDPkx?=
 =?us-ascii?Q?03U1+e9D+SDZXc/y3aIuAJ0pX1KkK/G5qZHG3KkOVQfsj5LRyVbBILQNia/D?=
 =?us-ascii?Q?HvYmDdJIvvTtcqoubaPkQ+Zzl2Xi3W0VyufXl6muzjF8eUyUJ6wewyQQMEtQ?=
 =?us-ascii?Q?7iAg8yCLwE65+rcbtcJnp4rirM7z5BwRU+3y7sGRTZJ6zBZiDX9u0FMUz6qj?=
 =?us-ascii?Q?m/bU6CSFnK5NCN+1jtlsrgQVMt0rXRBYUOS5ljbk6IpPTkJ0mnG0ClssooD8?=
 =?us-ascii?Q?trTfuGN7dW0QDMaZo1LnWb8CeVej0bCMfJiMmdTAh9F0+1E7K5bnkT8Jx7By?=
 =?us-ascii?Q?4K+emdo1CsAkoGeSgZcKo2XSt7UqQ5AoQFops5fPh0e/qWFptYLWEL6ORwBT?=
 =?us-ascii?Q?J+NNxqd5yFCakZgY6/lm4vRvt9rawVzH0J3qsspwW73Fol4ALykC0QOPgcM1?=
 =?us-ascii?Q?mJTmprgDPgSVDaFeN/6/Imr+71jKTm7165dBtyeVEaBtGoVvfhmwqFQEHEi4?=
 =?us-ascii?Q?5YQGJDDoU5krDj+HRkhCjBcT91Eu4RaAWFVEsF2XrOXP9EeMPGckJygJwvtO?=
 =?us-ascii?Q?B266/aUpp9tNKf//pAzhh/r4mQKRoQQRILGtt6ZSvpqDRXp/OaXCez+H+K4x?=
 =?us-ascii?Q?XyU9AmcvVLdiRoevEp2LlHl4X5LiZU+gPMFkabljS7PPqcm4Gm21vKYWnzVM?=
 =?us-ascii?Q?P7m57xignHFEMI+YvuvQEOgQMPeeHPU/dyrx76Yjk2uNjyGbyclKxjp90njK?=
 =?us-ascii?Q?SMAISNZE3YaS/na8uTVbAd1sawjH1PbmqLzzjYZD4Tkz4u5/v8p36Eagv4MA?=
 =?us-ascii?Q?6ajjryYP/nERcMsZCg5dOdTo/ld5iRjDxYMaLQHZ+Ct3Ky4hPX2Lp8cbBmQ2?=
 =?us-ascii?Q?luEp4S5FmgRJO+x0XRP5+87wqUxy6WOiV77JoRbc9geJBdpdc9jNLOG+DTfc?=
 =?us-ascii?Q?1c3+MAb29mYlaiKD1r3LZ++FPrhNF4BQteeBuG0nV1W/wjzJcK0WmevVzFCx?=
 =?us-ascii?Q?Lu/e74d+zUxmAfJqrUg3vVAZxjhb5YFEdNjYQHLMvRD2yheqFBu2ZBecQZM1?=
 =?us-ascii?Q?2pZj33PPl8y1NryytT+Unw5nMs30Xuy0HY2gTp0b1ssqFngo6O2ykuW5Yd4x?=
 =?us-ascii?Q?GUCr8zAtgCfpAlM+hfJMQNYGE9CcF+/UpAqFSDUo9R7HFIW3BAl0ChWwKova?=
 =?us-ascii?Q?CUBmCHNMVhA105+2KfmXA7Ca1HJTprAa73FX+PaS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc0d15f-d34d-4a32-1dd0-08dd679f6d4e
X-MS-Exchange-CrossTenant-AuthSource: CYYPR12MB8750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 11:07:39.1159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cy2zHtFYwFGNJp/N5elAzI+tWmR/a6cIGk7GY7JREjv/RcqhAuZ1f5h3WWvzohgF2GjnyB5xg1rKzaOVxEr/bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577

On 19.03.25 14:33:54, Ira Weiny wrote:
> Robert Richter wrote:
> > If a CXL memory device returns a broken zero LSA size in its memory
> > device information (Identify Memory Device (Opcode 4000h), CXL
> > spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
> > driver:
> > 
> >  Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
> >  RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]
> > 
> > Code and flow:
> > 
> > 1) CXL Command 4000h returns LSA size = 0,
> > 2) config_size is assigned to zero LSA size (CXL pmem driver):
> > 
> > drivers/cxl/pmem.c:             .config_size = mds->lsa_size,
> > 
> > 3) max_xfer is set to zero (nvdimm driver):
> > 
> > drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);
> > drivers/nvdimm/label.c: if (read_size < max_xfer) {
> > drivers/nvdimm/label.c-         /* trim waste */
> > 
> > 4) DIV_ROUND_UP() causes division by zero:
> > 
> > drivers/nvdimm/label.c:         max_xfer -= ((max_xfer - 1) - (config_size - 1) % max_xfer) /
> > drivers/nvdimm/label.c:                     DIV_ROUND_UP(config_size, max_xfer);
> 
> I think this is the wrong DIV_ROUND_UP which is failing because read_size is
> never less than max_xfer is it?
> 
> I believe the failing DIV_ROUND_UP is after if statement here:
> 
>  489         /* Make our initial read size a multiple of max_xfer size */
>  490         read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
>  491                         config_size);

Yes, it is this one.

> 
> Apparently nvdimm_get_config_data() was intended to check for this implicitly
> but it is too late.
> 
> Anyway all this side tracked me a bit.
> 
> I assume this is a broken device which is in the real world?  The fix looks
> fine.  But could you re-spin with a clean up of the commit message and I'll
> queue it up.

Yes, it was caused by a faulty device.

Sure, will update description and resend.

> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Thanks for review,

-Robert
