Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BE32232A
	for <nvdimm@lists.linux.dev>; Fri,  9 Aug 2024 22:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723244218; cv=fail; b=QhssFuZwDwgCUyHwIlthSwgBBRDfz5RI9z3wKLjRJY1S92avNRlnVXOMKu+zgObhrGYnddvOjmsUEGc44ElQZev4Nf80mkZI97BbN6H/RzBfXx1eFMBGglRB7YhYXAtctVJ3GkuwlPrH68YC3Q/Xw7+A8sVJgo4MTyB3uHIS5UQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723244218; c=relaxed/simple;
	bh=O/I4iiQFiATqLsu9phD8cbTgJF6rF2MSN2EUfIWGQMc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZOulQes4h2enX4jcx68H9TQ/VBLY31XqDutAU78l/EWM48wZdAUktnw1S8F++XUc7EEJjOaoVwYIB4vyDtJ73yU0Ptd9UTUI4R+OLR0ioU+KB/Td9vfbLS7BTs3YFhayHyUNmTVwqjMP0FaX3HLm/4ZWiNSJZF8q6/TfQkR8aKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2RgZL4s; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2RgZL4s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723244216; x=1754780216;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O/I4iiQFiATqLsu9phD8cbTgJF6rF2MSN2EUfIWGQMc=;
  b=a2RgZL4sGXtyWo1TANWPSXheDe+NBsUugjJHiFYTCl3wAapaS9jkLOTS
   hi83Slt1UgrSHgM6cfSND6dMNLYPjM/PuFFl6f8KwW2eJeBVFxn2sZeWm
   IY9y0HfZjpBbxSrO6KVWrOdoyad/MHvRcI8Pl/XdEoOwr++mCOrlvXHft
   Jp3dlli78v989u03QziHMJ0828fIp0M/2uXNuQVp5tGj3mVPnG5CYn/aJ
   oWXXAlrSHQ4tgFw+P6cq1kzeOKuK4r621dQCyJLonYfEF36lhhuqhZ4uC
   ZMESLSgHc3ZP8SO/afFyA8Nn03X+WUAiWv46vmpum11bGkZ6EzmnuZCtP
   Q==;
X-CSE-ConnectionGUID: wJ71nCR3RvazaAMfhqfUPQ==
X-CSE-MsgGUID: pdKOwXOLQZ2g1B8cGqiElA==
X-IronPort-AV: E=McAfee;i="6700,10204,11159"; a="32844683"
X-IronPort-AV: E=Sophos;i="6.09,277,1716274800"; 
   d="scan'208";a="32844683"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 15:56:55 -0700
X-CSE-ConnectionGUID: MoHV8oY9T6eXx2DbqIBYKQ==
X-CSE-MsgGUID: ZsGOAomhQdaUfvlzEatDKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,277,1716274800"; 
   d="scan'208";a="62103628"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Aug 2024 15:56:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 9 Aug 2024 15:56:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 9 Aug 2024 15:56:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 9 Aug 2024 15:56:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2wEWFjoY8Q5fq+lCq7dtHgrnFspXZUBCYbO2xi3qGSLQbvPA+MVrd8VDN5ZOKDZag/adhLS4mBUf6b7vAjTsxWnwgN0WIJO0RbZZnZg6e44K2Ho8fGccBLQko7csKSK8Id/2XfZBjmaHv7XF3PQznVx6yRfX9lzVXwam/uqTPIQ5l+av9PI/EkeyAtAqLiUaTuB46E7qkywsmyuujGkZKyKyh+d9fvMAx1ZGRLdfYf3Y7Glo7VDz9ZRJGHFy/xSy1e1QeG4q7F3jpOPLYKNJEePwXBMiLEaz5kqp5q1Pb3w6Zmw0lBxv8MmQnhSmGYI7VDgdK8NUZ8zri1VGzELTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXTTBNMObkGkGxWuewgFPo7JARVjtBZQR2i0iHTtR2c=;
 b=V+zVXdEj1TwOJEDI8YnXETZA3LCTYJVL8WBojXTqZcu87dx8iI9yhoQa0btghqGx8pAgMuxlzK0Df6ATOe8jXzApCP5VYhN7msAaq4i/VeKf01dsGZvNMYRpU1a2PEdjddKcL/vpjgmL+m2jZoZPD26PqfHsk/3llClGkyDSqxEvbqSXvV0nPv9ymq+5hRxitfTzMFSHziswGM36RySsPvT+yRftfOCvkjlmOJ0y8rIrnlo5qc1NG9o/Q3Hr5jhdsdUIGnjXz1wOkHYkF2OO0l+SPuzPR3pLCmbdxHPvTA/NI4El/Bgc2bsr5ZFzCRsN7y9wXNuBxxmOpQz0WKDiUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB5793.namprd11.prod.outlook.com (2603:10b6:510:13a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 9 Aug
 2024 22:56:52 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Fri, 9 Aug 2024
 22:56:52 +0000
Date: Fri, 9 Aug 2024 15:56:49 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH] cxl/list: add firmware_version to default memdev
 listing
Message-ID: <66b69eb1c831d_257529441@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240725073050.219952-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240725073050.219952-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:303:b8::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 33d63514-cc5e-4b00-d744-08dcb8c68f4b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Y4wWzJd/72bHs2JSKrQtmqdq0TF9jZMFrwhhQCqPhNOvuKUtfg8ZZPRyW+Eb?=
 =?us-ascii?Q?+vt+ZLm6jLuxqcxi3ObIuasMgy08tWYZUB/RKiwJQO7ORS/kHTHYAlytUp9Y?=
 =?us-ascii?Q?vU7gXspWuHOxrPdu6qy5Ic/6ocJvgGUgtVgeztABXMIvmOklWzZBv0wf3o/y?=
 =?us-ascii?Q?CSDQ3+RFP70lhKtFawzNnCUaiG3qcowOvYcGB8/bjfan27l3L+kHAmXzh7WL?=
 =?us-ascii?Q?bjnDev6sOSJD/LkC369PdrTqA+ejbtptGnChSYZc5JRD5w/PV+HC8AUKQP0e?=
 =?us-ascii?Q?jhsl6/0OHPpFkUSIo2QryYdUORtDKDQIZgzWnYcd3Gr/LbOaVRr1sH4bISty?=
 =?us-ascii?Q?Q5B2yOQuoxaSL1yX+IQYLdhsEztPlb3yPe8wn+dU4pkYgq5hXD4MwygQDBq4?=
 =?us-ascii?Q?vzyeRsj6Jsu+YFI31mSJIBlJ7OMVc+4zG6zmqm/NVTFHLiWtjZxOxoSJ7hrE?=
 =?us-ascii?Q?XIrS/gAvnX1N61ksFAFskkRUUPYAFbQbKFQIHS5k9v/5n6u7M1PlN4FDpxbG?=
 =?us-ascii?Q?dXXc7zxXyzMi5K1+57BA153ICEjIZmuQNzGzo637u4sr6zhxDPmZKDFWnjom?=
 =?us-ascii?Q?UR2+bPVtKVeJhyk5Wa2oHyBwdlzpPQ6e15aEW0SKxdAjwpAuvCIoOCY1ggID?=
 =?us-ascii?Q?PQdodDo1b0+4OGQGlcNGcLp4KFMeEjgowNVMu+lw9UgP1rcx3sOECUU/IRa3?=
 =?us-ascii?Q?hLXVtYRiPnGRuIQlvBQzDEO3f3SdIQBweM4wEw05Sw4ulYT0ydOiivSB6kFw?=
 =?us-ascii?Q?lKYAcgx3YjcEZJ9MVt0EVreI/gxef8sAoZ7qdeCH0YFx2Hu0gIcnY2qRFw+C?=
 =?us-ascii?Q?fP0DGSdU69sKbdaxQpF+uNa/8I+nT6wbD6NEy7iNV2HRDkETBOu6g9iecTIU?=
 =?us-ascii?Q?FAlyM0UmX8LzNOsRuPPM1kFaAgPeur8HobprlkeifSB5gcIawWcelobOi8am?=
 =?us-ascii?Q?iKSv3KcR5QJHoxSoDyNY/78nkDKtCfT5eTinHuY/btJ23zlG5Cl9Li48pAMl?=
 =?us-ascii?Q?h1LvdglbmSLDUC8jiLyWswpo7X9mEq/eGUYuW8a7oHmsPSgcWiINwW61YaK+?=
 =?us-ascii?Q?eI8cX4ydFh6babHo0zuZkVwdqlFE47sNRPC6nJDLEO/TgqnYPObY48+6Fqq7?=
 =?us-ascii?Q?jv5rylXQAOJClZ8haodUtWlH2T7e/gtlzR+tXylYbepx5XhgntyP/nNpqKoK?=
 =?us-ascii?Q?QjYAPlObOHYSXKglKt+EbUAuA6v1gR6pMT/X4ozZ34seuKjSmVSpAFVg/oE3?=
 =?us-ascii?Q?g5PMTNsdK100gaVMSlg38xFO7MAY2hgallYgDpqtTwdbAQgtRQ+5AIQ4VLJo?=
 =?us-ascii?Q?PukkTFOfLpF57CHgZhnStCnvTiFFZuZBeyw/+pITfAm9VQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nOeCAwfB7vb+W4l53O2Jn4kRxV8Zl+UJ75i93RgU5IJaxbbiVFTlq4Za9fNH?=
 =?us-ascii?Q?6oSGvoPRVkf4/ijLmDFg7V/j0ZRkk9EvkFVHok2VcZVqeSQSaWEVO1q8EdUP?=
 =?us-ascii?Q?L6W01pCjXk3Z62k1kNwS0jjcqSibOAFJH2huK/6NxvFlE/FoZgBg+Ekywelo?=
 =?us-ascii?Q?YB3JPFoXaFhGm10vEBih5NPa7o0Cl1ln62//yb5JPxZNvwKp9CHJkmmsR8p6?=
 =?us-ascii?Q?T5NvdhVZ1W1mgS+8hI3S/baK8+2ebjH4jS9TclUDqxQJyBLr44GRaQju2kZ/?=
 =?us-ascii?Q?tgWvMdh/olFi8U8pnz18lnihE4DyJk6zplEx5RgCTTdyma6vmwLFCQXHC/mi?=
 =?us-ascii?Q?C4yPB/qlOWaujJPT2fqzYWiAJ/CMdW38jjnpO3QvcGM88cclTekD7CgbB8Cv?=
 =?us-ascii?Q?wtPxFvtQS5W3lwVuvVi6BZhD2muygv2s1kRHxhjCipDpnGHwYpkysCBQPYF5?=
 =?us-ascii?Q?QYiiMbqz4qq4HnqPeG+OY32QUQTSoqmwaicdAFX3QPsqa8YRvZThQMSzgweB?=
 =?us-ascii?Q?O42e3X944Ub0y8Ej/VErqnv7K46dMUK9mYwsbbaa4X7LVoWi546Ksw0aXK50?=
 =?us-ascii?Q?Xea5dcjPq5JDQr/rlO6d/Is5iWYna30xmU1HaE8mSp5J/cqpdT5N4oEOMo8t?=
 =?us-ascii?Q?crA5VWGEUF2vRCim2c7jXkfSiUxp/amEmRizhP77FDheTlU8Dk4Dhd7MrvwU?=
 =?us-ascii?Q?1PvkB3OIJrGjl3QDv64h9JuHYqZw5FU8VX4kafv/va9Ww6NJvW3eJmfadXcj?=
 =?us-ascii?Q?Y0pXQ1aSyqt9iwOZiSCDzBvFXGUqw4q20dE22S2ibh22VqZ4CfPy3CS2Y183?=
 =?us-ascii?Q?6Lm/4x42eYSshQV3XvgmqsTuxX+v4w2MpnZj7pNz5LIFmUSQSUm2XuUiNmSE?=
 =?us-ascii?Q?3/IrHCeMgg+lI8eE3v0aW/zYkmLXL33VdQO1VybTcpX22IxiP9RzlXrx2sDp?=
 =?us-ascii?Q?HUcuuO9WxYAVsDsKvLF1rf45cUgARSVREThMNZyImpu5349yX90ilU6jrLk5?=
 =?us-ascii?Q?hmL7SxnUShVGTMB5V3PgNMfx+0HlD0TI5WtKfVIeZzHWbd6yh8QW+McqVJ6O?=
 =?us-ascii?Q?5jZDw5A+pwJOmmvZ+ilO1sKoxhdXWyGEdSVtrawS2AAmloi/yjxQ/gYpP8GW?=
 =?us-ascii?Q?7GAmucgk9gF/v0IWTcwT66cBa3XzqDc3zTzsvFGQ8xpDFfnr4QioDrSoDaAH?=
 =?us-ascii?Q?DqNSJotIC24kf64O5JG0grcFXIPZgFBfCXeQ+yUBFb3XXAGuP4q17LEye/Ws?=
 =?us-ascii?Q?mtkJr4GYkqkI/abl4/zGf0bSix2UxETMu072lpsU/03nwwBX6qF+fwV1YGg6?=
 =?us-ascii?Q?VrPCqB7/pAW6n5mPECsKZMvUfCIU/jfi456/kFwnZ0q2fzZFo6/QgYEbeUHo?=
 =?us-ascii?Q?OBq19z/v3guv0iRmeF2IIzObwZRCHod6190apV9Fh//OlFH0Z1UxJ3n5K9Pe?=
 =?us-ascii?Q?h6vWa8tOFJbM8zwafFhQT0tFhJFfm0/RIaN5i+WdTTs8A4P8yEJz6I3uCFkm?=
 =?us-ascii?Q?cVUoMZMxImaMIOs3wBXJMjifbgPrYw32Ynt96G6IO83ayqFuNq/mDzsii2AM?=
 =?us-ascii?Q?ry760A5iNyrJxOnCjPdQE7ApytRYeuQhF5l2dFL5bmn5SpAWk/6vvw1dQ1ta?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d63514-cc5e-4b00-d744-08dcb8c68f4b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 22:56:52.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLLNATDiQLVh60cjW/OlpdWq+o0mhXT7AOAB17IJF+tAvJWpvSIFDfm8vl2DG/XNds/UV8XoM+5xTtwT3gL9Xy1WDuNmgkPfrVU2x5mOwyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5793
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> cxl list users may discover the firmware revision of a memory
> device by using the -F option to cxl list. That option uses
> the CXL GET_FW_INFO command and emits this json:
> 
> "firmware":{
>       "num_slots":2,
>       "active_slot":1,
>       "staged_slot":1,
>       "online_activate_capable":false,
>       "slot_1_version":"BWFW VERSION 0",
>       "fw_update_in_progress":false
>     }
> 
> Since device support for GET_FW_INFO is optional, the above method
> is not guaranteed. However, the IDENTIFY command is mandatory and
> provides the current firmware revision.
> 
> Accessors already exist for retrieval from sysfs so simply add
> the new json member to the default memdev listing.
> 
> This means users of the -F option will get the same info twice if
> GET_FW_INFO is supported.
> 
> [
>   {
>     "memdev":"mem9",
>     "pmem_size":268435456,
>     "serial":0,
>     "host":"0000:c0:00.0"
>     "firmware_version":"BWFW VERSION 00",
>   }
> ]
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
