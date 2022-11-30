Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE80658
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 00:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669769495; x=1701305495;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wq5mHpTyGS7kK8+AYM61Qq9Xy50I+RunGbloaKb+omI=;
  b=Oe+uzhByNpoRi4Pj2BueuU9eosYHfQlxlWiXKgwwYdGuT+7WyepoZd0O
   l1HbqLlUBXZg1vPOoYupQu/WPdMCIT4cHdc63gW+O99Lcg6uoUnK7yLS4
   L5+bropdFhXex9TX9IAHTLMKmjJb8oTtcWhWpN91F+t1Z/6in8iYFxi7l
   JSKJii79XkjKY8OgI8jBtI1myqxle4evcGcx0C80AP1bURIsbgawdC1j7
   InHmvI3tAzuTkosC/zwKftmoLKUkkMOQzhSI1QKl9WexGnBMHI0TEBWBL
   bC5oc6uWFdqQZt9SyZwgo5s5yc7sUj42duJFhK9FTNFZjP8l/9Qzh5l6z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="294963141"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="294963141"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 16:51:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="712607286"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="712607286"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 29 Nov 2022 16:51:34 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 16:51:34 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 16:51:34 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 16:51:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIIHk+Syl2FXqssBTmyZHMQMFmtc/5FAV0BU8RVlL/xTYXvWemPP8mOzk/G/0IfG0z/JmukuXjG8F9vDTeN/n2rC0ccPoJfMkemgooVP0MjjSx6uOj/hQ1jPlp21yvLdQN5PDsiVPeEILobHdp5ZNdwZJ+OOXzGTHGl7UYQ7MUfGRO0ZuZkSz2TR1Kqx/kbiTIlcb5ZYxAhRmUD5NkZtBCEFp0v/iYGQKMm52Qo2dW3IC32ryADLgcauj8Lk2uF3yEI+5x2k42EXUuI0QF3Yl/ACCgzoAZiCbB14GvtiWgisGDs4ssvqe9zFR5RkcV3ERG8j58heHX+stdzsCbyXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiBnMHghoLTX6vI2UmlDbhZczhCvvUPKASMOP+brhvs=;
 b=HiUq+ohyxRH2fLGfWlanECMJuBryldZibtpFcYBaOh9v7ezMGgQCvj7zsrWoTI6imCFRkMCuuxo9wG0Z+AM29WKJkCJl+G/IDAU/KVkvmI3n98zpmooGfwhE585eoCMLWsQRj7/J1TAG/7DfA8L0y/GKUPIZXsZdXEBlowdwqK20dx6D4OcUuUm5YzIBm4I4pIBf89xbgibrgLAav95PavXHfmZ+yRWXtYVvpOhiOGP/R4RuM7zxiKNsu9ryl2dPs2nBAMyIzzognuNsanV5OouV+3aphiDRpJ0kqi3WN474onGIXdl1WZJ783aSGVpQpb7xRIB/P7fzvEnw/SuKXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY8PR11MB7081.namprd11.prod.outlook.com
 (2603:10b6:930:53::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:51:31 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:51:31 +0000
Date: Tue, 29 Nov 2022 16:51:28 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<benjamin.cheatham@amd.com>
Subject: RE: [PATCH v5 03/18] cxl/pmem: Add "Set Passphrase" security command
 support
Message-ID: <6386a91018e8c_3cbe0294a3@dwillia2-xfh.jf.intel.com.notmuch>
References: <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
 <166863348100.80269.7399802373478394565.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166863348100.80269.7399802373478394565.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: SJ0PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::20) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CY8PR11MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: c2b7bd7d-51be-4b5e-2adf-08dad26d04eb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJN5hfQAOLUMlR/SQVwupCVyROmO8GGTw36MMIjCRiKKW3uwkAn8nMtUWcfAtw3KjVMN13g2iIg+hqdcOF8nN0DzaevilGp1ahKRgqenuB80kADvZFpBYKtYQVWg8sZdLQTUUTEOHzVO4XRUyfPTKEBhNUJZX2wz9+BwkVCmgDjAOSfPLZvOTBKtl0bR5TRZslqh0i0m22QNeZ2bqUo9/Pn0hvgVaJmDgWmKi7fipF15pEpEd+nUKaUDNIx4ZRIXRpY5gh0PXL5TcYpjRK3r1ABs9CmfeVjyrZKc2LNuftCWMj+0zJH/eYbMW4iXa69YoS5h9Av89l2sjXSCjK/eE9jk/okYeJKtL/t98VqsbUoxXDtxn0xgCDb9s3G1ckf656URsaaBvulBcydlm4mDVMOKOqjkyTJgqWUsaCeGX9o1e01i/CGEKN7Ah7cOuvthGg0mYxIc9lzyQtz1jKmxgzVPKtkqs5ZBl+qSmSB6TGES/VjaCdjC/oLJfFxdJ+ADLPJ/f+iI9SbSWmH5PGbAWmOkfMWaUs6LcIVADZU9KscEJu0+9d/j8E0dgl5qTcPprPNGm72TOX2mhI96DnIMY0wy8LA//RBmp5J2UrLbCGDbdgXgSh2NTrAO5Zd392093ri48XuXAYNXUMo2ljuoiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199015)(5660300002)(15650500001)(6666004)(38100700002)(82960400001)(26005)(9686003)(316002)(6512007)(186003)(6506007)(41300700001)(8676002)(66946007)(86362001)(66476007)(8936002)(4326008)(66556008)(478600001)(6486002)(83380400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KC0H4DRDxNvcO7lwLdDjJPhPvjTdGlhn418x7/B8myK3+8JK6RZhuTSdlv1H?=
 =?us-ascii?Q?pcbE1iqYb9kQ0BSNQuzuDJAMEV5p3fH7PJ0qyqSc/MVJyvShhSX2s+xTT8cB?=
 =?us-ascii?Q?z8VO9z/D7j2sVbfMUpNJafBjRqRz4M94wyhF7NAaLYEOLrDOkjBg86tOEiXp?=
 =?us-ascii?Q?RP/w5f6yamiDcEBpCBDVL/EOsnDq55XsE1ZnFrUN8I38zQFsXd6uPGHoCz60?=
 =?us-ascii?Q?JOK3mseq7I/BI2mp05DgPDXTupLCkuHuZsPhZ+RNosC+WG86Bw91+XP5I8fo?=
 =?us-ascii?Q?SS6uP2jDKAyQUd3/MwrWcjG2PVfjTaOJF3YIp4PEhdf+kPhqRc4XZ4KubUXQ?=
 =?us-ascii?Q?k+2VZ0RCfdMWuw/d6W3eThTGp+7F0iD9oex58xbGPjdCCb1VU6CUwUFkV7Bb?=
 =?us-ascii?Q?b3SPKgCEPIwJUSvjFpYWg0PKMLWd9b/4ts9LbQGINhGo5OUyjlzK0ukLTQvC?=
 =?us-ascii?Q?P7iUscFiyN2fs/cB3hZeaZdU4G32hAt4jnqQRw4KW+ArZIJvXNDXOL44eiGm?=
 =?us-ascii?Q?iD/b3O11sSgyySXhrv+nEPa0kF4F6tkZ1H2PnpKl6jbXA4jQwShj4JMnLKcF?=
 =?us-ascii?Q?wuJEy82wxRyK5XbFGUEmjLW0pBokjtdGzvX6wA680UtubigUqdHuexlwfOMZ?=
 =?us-ascii?Q?UtE/5niAStYVD/QH+HqBH8u4F4VL+3VMvHTHnqCv44hBHS9Cdlk0stsT6ldj?=
 =?us-ascii?Q?qhIKPRr2vPBocsLmFFx13ao87774eCcI9Ptht2aV1yoSydzHXtuJLfu/rlcW?=
 =?us-ascii?Q?bPy/YNqVIB2mXV5TA8pCei4vfE4GpDptjCMcW8E0tYbCOYyA9KzMrByKX3pm?=
 =?us-ascii?Q?Ypm3Wo+5vdq9fT9Tk5yCa86W0msAau1Mu45qWOYEVj/JCNZ5uU9MMC3ZaHMy?=
 =?us-ascii?Q?GI/AO1iN8XPQPDEqj8QR2/XpEdCVy2gy0WSmwzquJyvh6lj7KOfBFNfV7KsB?=
 =?us-ascii?Q?2uhZ9glw3qLKAWUIhqJnQzGKhcK3GGD1we7noWCFt6SpxJY6CAZw8xzyF5pe?=
 =?us-ascii?Q?q/aXONKryhJFSSK9mNS8LUldDYRlDc9U/lQU41BjGxvhlKRfQ/9dXJqOX5Th?=
 =?us-ascii?Q?2tU6TZXEzDW0Ic3h5UBa1r841lcKzbr5AyqF6ny5iovKWvQy34QA0o+mSPGT?=
 =?us-ascii?Q?km4qo0mgmgC9EPiBa1+8j8XfFp4Fe6jkm+LyjY7dHGqXwceQ8Csbh/5QCpT3?=
 =?us-ascii?Q?cIUV78HRzTCk/b31soiw1/8YbjBtjjPxzSjGwq+S63k9kzMxS+l8h5PlRBTb?=
 =?us-ascii?Q?ps+NpkWofp+AqRAtmTp/IevTukTRu5rj5FczDtloaZJ66NIGqHsxCEgdup8X?=
 =?us-ascii?Q?3GOYraFFX/58Dj3E2ACM8fLFUTfbPYHjv/ACoqHOZ7/1Se1fYKq3xBGM5FGm?=
 =?us-ascii?Q?klXnVEj1LaM86rpINkinH24H4v/x9tg+O2aTkJPriL6O/I3j18SXF3mojjEI?=
 =?us-ascii?Q?TCie9NgRlLOvI38f73DuBa8Pw1i5lhuLNPcRaUwcUVy2DkNnRJ1TZHLRGkv4?=
 =?us-ascii?Q?KIpJswONqpVMkCP7YTTIUYIioyAtLpCmcyAmZtCFi87ghBTheKzsKHNiCFOT?=
 =?us-ascii?Q?/DiX7xdzG6PD8h2oZTm7wXJQphynPUMr5o5pEZpkVUcgij1/vfUrXog8uJH9?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b7bd7d-51be-4b5e-2adf-08dad26d04eb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:51:31.5727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfmQwAh62gTvQ8PHCQPm4IjSxev8kGV+ROD55PX08KNRiNWV8i8u+eB+xA+DgdGv6756jr3zrueEyDrlgAz7u3hKPoB6nPhilGdNPXTZsrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7081
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Create callback function to support the nvdimm_security_ops ->change_key()
> callback. Translate the operation to send "Set Passphrase" security command
> for CXL memory device. The operation supports setting a passphrase for the
> CXL persistent memory device. It also supports the changing of the
> currently set passphrase. The operation allows manipulation of a user
> passphrase or a master passphrase.
> 
> See CXL rev3.0 spec section 8.2.9.8.6.2 for reference.
> 
> However, the spec leaves a gap WRT master passphrase usages. The spec does
> not define any ways to retrieve the status of if the support of master
> passphrase is available for the device, nor does the commands that utilize
> master passphrase will return a specific error that indicates master
> passphrase is not supported. If using a device does not support master
> passphrase and a command is issued with a master passphrase, the error
> message returned by the device will be ambiguos.

s/ambiguos/ambiguous/

Other than that, looks good.
