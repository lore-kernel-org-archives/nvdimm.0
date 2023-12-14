Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CCA55784
	for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 15:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UaYEoNrF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702568989; x=1734104989;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bmup252LQH8P7zuozgYH7uBSUUcwXeeXWSr59G5j5+8=;
  b=UaYEoNrFJWowYsyofE07VZCdTSoMfDmLttwaJiDm8oS6pP9z7sifrJEN
   Wb5fPmNwO22fCuFarNLOkRpu5et58XNEDHKM8g9jfBl1Ej+sL73LD6id4
   6YNje/UaEulA21UKTx+KGyhJurlH6p3ao8+X36PKzIy7Qp3/J1tL+OQ9F
   DNcUinDzvzDpc4mTOrjq4yX2ffRXrdMcmZ5xjOqfVsNC2ufhwFy6Tblak
   nO2yeWLWNzmJy453fKjEXBxkrqs06QouaUou9BJSvyjoWzaTg8eHrtFvm
   N5xD9pYHfhwQq8uEtqzaMYYedIGxs/l6wchG9knsy9l1n1ygXBJq1pEPp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="394883347"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="394883347"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 07:49:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="767647740"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="767647740"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Dec 2023 07:49:47 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 07:49:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Dec 2023 07:49:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Dec 2023 07:49:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqNEzJybqw+2U9wfSWf3flTcBnvhkKu9g4qwMttRs0LBrwuk4xmIvQ0JQDAlePXOXudS4B26gLVjFa7vACEo9J7pGWTxTzfQoHv55O8NBNMeeJ+0wYwqg3K2F5kL/5kxz0pde46btKBQUeOF18klljxoEtHkFeJk89j8PB5lApVjb2qQoZ/9WN23pLlpr4uAfX2rZlGodWsztD/bGNjVBx4OTRhOJtSb6gJBfNk7fa1+7Dyx2ufCBgctDLm7nxJfK1M8on5nrLW6DCVkjjsE2vwtuZ4QZ+RqH6OEFmRSFR34N01FhY3tio7Ej9i1sNUFwIFhHGHUIRi38iAcxkeW5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2Uyn7xlZOedIOB4PVLnUz6xhgNuOTtDf3wfmyJ0ry8=;
 b=fX2AHa5rsczU/TxiL7jarulqz3svoubk+3Tg1KnIvj+83943PQxTjKDn0vHn7eOdK9lmc35sNFxF0NIIathWXpNCvqMSakuycy9oEjzcl90IU24u5I4TVzAHUlo/UonTEIYOZWEZZLb7VVQFZEbPlYSWcHKzOPo6oITIIL1FOrzhZsJvLSFZXoKPot3ZB0H9Znpd129rqb5teWWZbbw5MfGKq7PRh0YB8gpWF/radz8AiFhnAUCypIMkcyayMLxDNsyQkKIfDrA7BapNOyI0EBB8UYk9Ncgz0v2gRWshNRLnZ/2Dqpzl8Lkk0EYhyCw3SmTiPrGqaXYq7lGZc9EXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by CY8PR11MB7745.namprd11.prod.outlook.com (2603:10b6:930:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.38; Thu, 14 Dec
 2023 15:49:44 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 15:49:44 +0000
Message-ID: <d1213b32-91ad-4bb0-bca4-b7113b693c70@intel.com>
Date: Thu, 14 Dec 2023 08:49:41 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH] driver core: Add a guard() definition for the
 device_lock()
To: Dan Williams <dan.j.williams@intel.com>, <gregkh@linuxfoundation.org>
CC: Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
References: <170250854466.1522182.17555361077409628655.stgit@dwillia2-xfh.jf.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <170250854466.1522182.17555361077409628655.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::19) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|CY8PR11MB7745:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee9c7c2-4fc8-43ed-8449-08dbfcbc4aa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxZIea2JTUfRu/Lbm08bg03xeadi6HzQ/uXndu+mQfouEsuLMQQtnhK4zdVJTLRvqpd1XIfOdD0T37v6Ol15/UoxUzenC45Oc0FsaVLp8Ng8tMxc0lEt+KiZBfLfZ6vuVrDERmqgcnQHNghurZdHkzWSy7ZlXt6MGggf9CfRntJQ0aXGpDq85sXh/ty+fuuViSmfR7tHJP5qwgoA47gjKFSCLPWEY8z2ayH4kt/KO94VbDsOPt/DEDQK+WgI5NJLWSwJoVhk7AbhO92Tmjh0sUtGrGmFwfUh+4NDYW7pKBA/bK54xv3AfceVsFIZXnLH57dTIcSrchZ4lkSvmlZotm5mJD0NmRF17+Zs/reTJegA4ZYlqhbM3JvTCYO6vFW77G3uzSSwAyG+odG2ACOnLsutW/gfjr9RTdWiUQDY8t8nu3nljtwTn7bl1Db2hhNkgVFjk6mTAL2LR3HEaTh6brMAhxfuk/gChel1LxxtIiOXXmw34EPhzeCKgmgn+wXR3flfWHMc3OEkMkpOu5Yllfl4JispRv2iYAwzX0ax41gdNMQLtvxEGmHG43WWyc++tBrzsjJa/iGSPB7LnV+ClB/kpwy2h6xN+Pv+YLvJTn1qYcxyTLKMbf+bamHnBnV54nS8VT8zjTZ5M6xhnyGVuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(366004)(346002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(31696002)(86362001)(36756003)(31686004)(82960400001)(41300700001)(6666004)(66556008)(478600001)(6506007)(53546011)(66946007)(66476007)(54906003)(26005)(6512007)(38100700002)(83380400001)(2616005)(5660300002)(2906002)(316002)(966005)(6486002)(44832011)(8936002)(8676002)(4326008)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm5WaU55ZVh6OE9BVzhpMW9QY0hBcy9BaER5MVo4M2wrMHJnaURvOW1FSnBo?=
 =?utf-8?B?T20wWTVDQ1M0Qkt5WmZPRXc0T29Ibk5VTlAzNFYxZFAxRGlKOUswbDBvRlBq?=
 =?utf-8?B?V3hzNVRKQzVYejlvRGxpOGdmOUhiOUZXZERpMXE0OVdHa1lsL0xETU5uN2lx?=
 =?utf-8?B?NWdibmNMb25BQk05TXVzK3h5bXkxLzVXbHZpR1VTTS9vUEkvNnduL2lwd0l0?=
 =?utf-8?B?K0lJZk5NbHVXUnRZeU10OXdsTFZaWlpFSmVjaURHR1pmRU5iQXROVmpOOWpK?=
 =?utf-8?B?b0RyTlZIbHZsMml6VURCSmZQYXZ1WkkyazdmZ255UWZvUFRYVnVBSmNYK2xx?=
 =?utf-8?B?TnVPbTQrbityWlhBd0tvdVhocENzSUV2QSsxQXA0WUhDQTBleDN2c3ZURVlh?=
 =?utf-8?B?Mkpkc2I5WEhzUEQ3VHpwbUwwaStkVzcxMDdIWGhtUnVXNFNheHEzWUkrVGYw?=
 =?utf-8?B?WmdlSWdwYzVUZUp4NEpYekxxSDJ6SHpic0hFWDZiQnBackxYNEpDUmcySEl4?=
 =?utf-8?B?V3lrU1RGOXd5RmFwMHNuVnAzZThuWFY0N3FoeFlTRE41SFVWelUyRUJCUCtz?=
 =?utf-8?B?M3cwUmlFUmlkMGU4ZGw3c1JHMnhRUW5QdUgzT3ZBLzIrMVRld3RRSVBnSjY3?=
 =?utf-8?B?djNmeVhzL01tKzJaSUNqMEVCY2lLMTFEOUJsbkMrbGVVZmF2bXhMNVVRVzhp?=
 =?utf-8?B?KzJJaG12dTVNcU5FTEhISlVTNFN3Rm01Q0cxTlhCdDhuZTR6UXlOSjBpNzFX?=
 =?utf-8?B?ZUdhajNYc2p1aXNmSW9WUnYzKzV2Ry90NmtBV1JHbVdOMk9hOHNxdFUzalJu?=
 =?utf-8?B?eWNrYU1KWS81NTR2SWNta0pEK3BEZGs5bkJuZXFHM29DSzVZWVY0Y1kzNUdM?=
 =?utf-8?B?b0ZWaVZwazBnVGNWd0NUVHFQNnVPd0JBMjFCcTFSNGo4TjlZbUNhVmVkek11?=
 =?utf-8?B?ajR2U2pjcm5xazlEdGZUODAxVkZCWUpzK1dQK29rMWh1ZmdabWNjdlFxZUUw?=
 =?utf-8?B?Y0kzTEpaalBydURROWljQ3EzZC9hS2hWQ01RdmdOUkd0R3JUVUxjSW55QUJx?=
 =?utf-8?B?ZktIcGVCS1dzclVRQ1I2OFlCTEFMVUdaMjZPRkdJRTJZQng5STVHWmptVGt0?=
 =?utf-8?B?SldnVDc2bG1ZRVR6alhhcDBleStuS0hmUkxJMTJKdkRKQkFEYktmeElRc2o1?=
 =?utf-8?B?bm14c09td1BmT3g4M2JnMEF6bll6WXBkL2hMa3FWRVFPQzRXNlI2eFJsMThy?=
 =?utf-8?B?ckdhSWpCSjFJUUFuc0RNL1pnNDl4b2NPeGp5cGl0eVNOTHl6djF5ZmFxaHU2?=
 =?utf-8?B?V0NxMldjeUJRMjBQNWZTajEwSllza0kzWE43YlZVSWVXWmQ1bzhkRERkOWRr?=
 =?utf-8?B?TVRPamdrTmdsNm83NEI5d3lORHY4c0RnTHFTTENEU0RrUjA0RllnUlY5NlMw?=
 =?utf-8?B?bzRUTWFrSy9GUXFPdU80Mm9pQXJoVFp5S2ZRQWdXOEZRaUg0SWtBeXdFNERp?=
 =?utf-8?B?R3F0Q2phcHBzRnMyU21Eam0waEQ1ZDBMbDFXWDJkQlViZDdDVmQ4b2pjbS8z?=
 =?utf-8?B?L0dWaDBYRjJJOFFIQ2tBcUd2bXRGb3RhSDRWU1F1elBQdGs4alNBRUFva1BR?=
 =?utf-8?B?Rk5NVStCamFLS0hNSnRQSENLa2htcnN3cDVsMi9NaUFSY0RQRTVpVnIzS0wx?=
 =?utf-8?B?cWVHR0tFbHlnNDVuTkZLc1RIdEJUU1ZqVzA0Z01JU2NNUExDMjNqRjRzazBu?=
 =?utf-8?B?VGtwU2E2WGkyMDdPbU96aHhIWUtycXFKL0dWczZHbHFGcmpFOU5NWHQyK0U1?=
 =?utf-8?B?TldSZjRBb2w1SU9vTjhNZ0djZ3ZFSVkvcnd1WUcvbE9DSHRkQ1lsNGlkRVB5?=
 =?utf-8?B?SnI1UnYvWGNJWFVHT3ErQkNuRHd2Qldoa0JDYWVlcVVMbU81d2Z4bmVNdkNl?=
 =?utf-8?B?RlcvRlVzK3F6d2pmK0NPYUpsZ1Evb0tPejZ5QkF0ejgrVW43ZUR4ZjdCREIv?=
 =?utf-8?B?MGZYL1l1TG84WlpiajFnT0FIdy9palVNNlhNOXQvNU13c3JmNkFiVEJJMkdw?=
 =?utf-8?B?cWxneVV3QWU0Q2t5V3ZkV25wQnlzYmhxVFY1VVkyNzlxWGxHQ2dIYTdoVEl0?=
 =?utf-8?Q?ed0iz56Cq1ue1UXGCxzfzTQzJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee9c7c2-4fc8-43ed-8449-08dbfcbc4aa6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 15:49:44.1500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 970iQfWr5lvSLIjFI4jXpZhhiCJhNOpmBaGJMkVCX74vHGIaM1WlGFsK5jUKVZuv+lFOsFfQGwU0yuo4DM/l2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7745
X-OriginatorOrg: intel.com



On 12/13/23 16:02, Dan Williams wrote:
> At present there are ~200 usages of device_lock() in the kernel. Some of
> those usages lead to "goto unlock;" patterns which have proven to be
> error prone. Define a "device" guard() definition to allow for those to
> be cleaned up and prevent new ones from appearing.
> 
> Link: http://lore.kernel.org/r/657897453dda8_269bd29492@dwillia2-mobl3.amr.corp.intel.com.notmuch
> Link: http://lore.kernel.org/r/6577b0c2a02df_a04c5294bb@dwillia2-xfh.jf.intel.com.notmuch
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> Hi Greg,
> 
> I wonder if you might include this change in v6.7-rc to ease some patch
> sets alternately going through my tree and Andrew's tree. Those
> discussions are linked above. Alternately I can can just take it through
> my tree with your ack and the other use case can circle back to it in
> the v6.9 cycle.
> 
> I considered also defining a __free() helper similar to __free(mutex),
> but I think "__free(device)" would be a surprising name for something
> that drops a lock. Also, I like the syntax of guard(device) over
> something like guard(device_lock) since a 'struct device *' is the
> argument, not a lock type, but I'm open to your or Peter's thoughts on
> the naming.
> 
>  include/linux/device.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index d7a72a8749ea..6c83294395ac 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1007,6 +1007,8 @@ static inline void device_unlock(struct device *dev)
>  	mutex_unlock(&dev->mutex);
>  }
>  
> +DEFINE_GUARD(device, struct device *, device_lock(_T), device_unlock(_T))
> +
>  static inline void device_lock_assert(struct device *dev)
>  {
>  	lockdep_assert_held(&dev->mutex);
> 
> 
