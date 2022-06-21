Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8801C0C
	for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655855292; x=1687391292;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lymHMFHKp2lUCnYeASUJ2Wama7wC5QEM7z6fwfRu0EY=;
  b=S3ow2hbN8J6RG2GP4kJln/WWlYpW3FFo+C7QtXBn0jVwgvwU9uGO/TSR
   sd+4LaRhqVUrN0X9qROgZXb0HS0+MN9AN2C8JWABxEqYMfSQxfutGOn+e
   +Gbux3XzgM8v40/UW9YTuOUKW/R2zDFmryKtqkbwpj/lFgWOneEpgr2I8
   h/07pFJZ3zkLiXtwetq+JVAYEIbVp8stXxC91YS9qPkXxnOJ7eBfZfc41
   OwE3pcwzInsRn01bYcnOCvGyOWZRK0ah94NLnE/9+iQbWW4Fuq1yD5PUW
   CMz4sBaMTPJP90hz5sfaKcn+l0+QE9B/GzGEZncPG2s20vodPRmrPaHLz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="263301239"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="263301239"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 16:48:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="833818009"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2022 16:48:11 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 16:48:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 16:48:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 21 Jun 2022 16:48:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 21 Jun 2022 16:48:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKvfenOj+dAn52KtIV9T3zLV2+pxsQ1KjourujV95yhKrYkF42Mhh+V2GXjNaquOAifOKdcGRQSDy7yz9C/iICcRNENmCeNrHA8K6+mgXGRIBr0JvI8Yoa2FjdO7WKLPtOYIdLjFkwH3g4/9oiEBMkeUiH0TOMrgJ5ULwRegeT9QoDDMS6Ex6o/z1vn55W3TE9gpDYSa9rzWD6/wsh+cN5mS+/KFPVRyfwjT7qaJzUAQuPsQskD198SGw9ibROFrxc6pAUnkSkEPcln1nY9/CBZqmUdsQy5Musthmc8jjIy8pbkLl9s6QzbU4OQWmMNbdu03lvOvv084lwWS7TmSyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EH7evXhu3fNkPqyk4LDuuMOQazhoEhgY5pkvC21OPwM=;
 b=IFezsQk0Uz1x5xY7Wgb/CmGxZyaDqMMYHKVUZzR6ZKeQUkC9/fgcOQQ5yAcciT1/1BQmljmNjkb9yVgxg6bIsYSqkrO2ToW+M0TKLEqqGMTfkuAR2OcfKitC/nAtxVBpfs9+8ChTsllfKszhXKW40mf+eTA5Y6qsCAWt19GS32ifmLPRqY/mplqKjKTTaH90ZerWE1zr1rdGj3hvvMRXlpSoras64OhWcN/3fAMBl/gk/BZzxcoO+R4O9wV/oBXmV+1drsN7xWhDbkmp3uGaFKaVt4CGxdAy2zdGRDGma9YuV9iSsTuqveigCc+/ES3W+zOVo88FQZzLV5ETOB+Rvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY4PR1101MB2102.namprd11.prod.outlook.com
 (2603:10b6:910:1e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Tue, 21 Jun
 2022 23:48:08 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 23:48:08 +0000
Date: Tue, 21 Jun 2022 16:48:06 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Chinner <david@fromorbit.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jack@suse.cz"
	<jack@suse.cz>, "djwong@kernel.org" <djwong@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Gomatam, Sravani"
	<sravani.gomatam@intel.com>
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Message-ID: <62b258b6c3821_89207294c@dwillia2-xfh.notmuch>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-9-david@fromorbit.com>
 <2820766805073c176e1a65a61fad2ef8ad0f9766.camel@intel.com>
 <20220619234011.GK227878@dread.disaster.area>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220619234011.GK227878@dread.disaster.area>
X-ClientProxiedBy: MW4PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:303:b6::20) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac1f3cd7-bb9d-4439-7326-08da53e07e6d
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2102:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB21024021EC61F14DE895EC2DC6B39@CY4PR1101MB2102.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ly5ImhwQ4/WbgelNuH+x5MCW42ZfZ9lCRG2CbUasMKuU2PvScWSVN1wlNscf7xydr2VI487WRYZKRM4O72qVdw9SVitXPHaFg702+kJMUgcdndkNNIshFTj4af3kAymwqKhfHllLwnrI7L2SoaUJl/NpipfASee5Rwxi0RW/b6sfxSBl56hvygdbNNIYOFp2QjNfd6QOp5/OOd30QRQc0sPSprO1/rmQGyMIx3X5cJKcgn5xoxbvFaTjJ+o+dgUkKhR4khlHARptcPsZbfOhvAVoiXy+hJJLd7Nombptvc1ylDYKHZ1jJAZYBjgbozX/veU37iWUek5TmCGvnN0NG1rRzj6Gc2vhVNGI0LTKXTdBpoO9GwwivW8xK0alZttmg9VQJ09NSKBzoldJX8pB2lTaMvIYVipTX/MOZE9UITQLiRWHe2cIjhTHwMPndK2iMzSUa1rkZc7WwnTht2wGqUhFi3H6VUZ9b03kpJnoD5NjTXU+BaEIds/7h2h3p0VTr+oAOuMTrp7fOwRCVFmakWITHgNiow2Vuhuw7oHEtFg5Qv7KkXvnn6K1sX+ppRhxqUfNJQKczLvfc66qW0YioFQa2v+RG4u8qawF5PvhJW4HaIRMZKHlTdHKMI/Iu2IoYqPhM4qWcohdyMNExJJ08Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(366004)(136003)(39860400002)(396003)(54906003)(26005)(8676002)(4326008)(110136005)(107886003)(316002)(8936002)(478600001)(66556008)(41300700001)(6512007)(186003)(9686003)(66476007)(66946007)(6506007)(83380400001)(6486002)(40140700001)(38100700002)(2906002)(5660300002)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?x/dzmGKSKRRsf7BSaa5dF8fWn6Xq/3iltF2aY89cRZ4Hy2RLAyY29iqlX+?=
 =?iso-8859-1?Q?lYjVCqZ1peQ9iliK7o89LtHE0/x4RyaQSQqSLJ2cQoZ42CURBGSGU7Afta?=
 =?iso-8859-1?Q?0EzrMz8DHhMDBQrotMmNs9ccXGmlg1mSTTDyzMQXtEBY6dMu1tkVZXYFIh?=
 =?iso-8859-1?Q?XMzIB4Mgc1iJgnlI71VnbaoOfpxP/V9ei/IBKml2ldOmSu3VEVcFnRmcbP?=
 =?iso-8859-1?Q?Ubv+2rV0PFs7RSdO+7L0zciDyKJf2R07rLX9Q9b9S/Ecvm7jqR+b8oxCMr?=
 =?iso-8859-1?Q?GvsxqrabrEV03brnWq6LU1X0acBVgN+ULn/37oiftvPWLlM+iraF42eFI+?=
 =?iso-8859-1?Q?3OFEbLguiWaUqeNgGnAUZ6qJVL8QS9ec2c7urg/Q6fVvww9ozNgG0rOK3h?=
 =?iso-8859-1?Q?5Qawu6BlgOqZpePFsPkb4sOgTK83pH2UrtpC5AxJzzLP0cAa4e1tGxrzzc?=
 =?iso-8859-1?Q?BmqWfEERbXmJ2Y+jLujPmaxQ5BZUgsMZSh5prJY7ePb4JiPZVGjpAUvs0U?=
 =?iso-8859-1?Q?7TOXGkvzxWYSEJch7WGGdrv3ZYRMUfWwgSZABsdDgBLt5oVqvpRrH8ehnY?=
 =?iso-8859-1?Q?CawX1UBg/cheAA8zvOHDzB3QiCHueWGJaoAyNPAFYW5v6L9T6EboTSZEYm?=
 =?iso-8859-1?Q?sbjGuDtPwBXDXjaGb7TMuaRJmuFXb1lMUTbZlo3CP0fxDpJl2VhS6Rfa+r?=
 =?iso-8859-1?Q?Lcs1guX2RLv2CXSIJFkBu62Tz3AaeGZbm6XQfy9phHgM3CllFv9iVvvRQg?=
 =?iso-8859-1?Q?dugL00iUtHrB0XoVjI4qaaF1U87AL/JR1S8kCB2GUrrqH0zQtqdNYnot6U?=
 =?iso-8859-1?Q?2l1fJOkls3vwRjDjR+UiaJ72LAsKG5ryNVVcYnWLNcS7kZgdrkyHgeneaW?=
 =?iso-8859-1?Q?tqqrgv8zkY2AajhiBlUZDXyROdfniIXd9gS/Xyt7aDXBnkeb7ngVjG0sZ7?=
 =?iso-8859-1?Q?2BRk3MhOpis/nSHbFiS0Jmhouw++1xBdLEkAy5aTqPjk0k9IPWwW0OfFGW?=
 =?iso-8859-1?Q?9Z9t176EI065EsD5o25GFx1lTAPF4H8JfvO7nMYZmwjd7Y9sx603aLdFMg?=
 =?iso-8859-1?Q?r/g5fWFvtl7OonJPXmhRcrbZdHHq+LLejMA65Crv5JDrWNIJYJ0j/3rDqG?=
 =?iso-8859-1?Q?YiN+fyf3/c/1rMT2CWQsmKCQvWQdf4AjWue6yOKGzPnpfZA+jL9r0x2QyT?=
 =?iso-8859-1?Q?oKNmx+Qt9h8S5xRtT6lRk0NntL6Wzt4NW6ucCz3ZsH7Jsnkjm466FKkSD9?=
 =?iso-8859-1?Q?tXrNUv1YXizImwpXWxQ0/zRIwHQ1+6/jr7uZie0CB1TqUyTLEc+su60Kfu?=
 =?iso-8859-1?Q?N98KraHyN8Y4E2K+mybVStyeJh6e6zyBNUd7DsdwsEsV5zok/OAc7WLngx?=
 =?iso-8859-1?Q?M6eSkxyAPlCaWrCq/BRAojmavcpMagpSDFX5R8Vg+KpJacaKPY0IVXfExD?=
 =?iso-8859-1?Q?5ajGMXrk5sXohCxPPe7ZwNIUQYmcQWe2pxbO+ZVB+Vy1SfdrFRXjW8yGF0?=
 =?iso-8859-1?Q?lu7/lgnP7n75z6Ph+aFtxIP5/uJOc4CFfpkn2zKRAAdUlp8/cghMQdfeca?=
 =?iso-8859-1?Q?59Tacuro2DPCYSfQEdVN08xoLWv5Wrvqd10eQItg9B9RUPzjUkGQaYoJIU?=
 =?iso-8859-1?Q?AnPVL/08ruqJSFYYetmDDlsJtFHH3lt+lAALbGRU1TPd4rHZbkpYOcflwf?=
 =?iso-8859-1?Q?KN+h6lxWGaSRPRWCTs1ZypuoPKHj1oEyajMelR0PP4JOGZLvpazj5xg1Qd?=
 =?iso-8859-1?Q?de4ctoMqHYXfQeNbc88CX6j1pkjd/lg4JcaAJHTKlwoQM6Xsgn3tQru4GB?=
 =?iso-8859-1?Q?GM1NjUkn8vd5HfJ8PGK7kwgUJgik9U4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1f3cd7-bb9d-4439-7326-08da53e07e6d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 23:48:08.6946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jjBGj40qonre/A2OT1AEVbcrTDGlIvXmPW84TIyNJD5uJ4YgNPxJOSbe9MbKFRAnpUDnbprzALirMvQ82zlMeVk5j+Xuv1niUst88+ZI2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2102
X-OriginatorOrg: intel.com

Dave Chinner wrote:
> On Thu, Jun 16, 2022 at 10:23:10PM +0000, Williams, Dan J wrote:
> > On Wed, 2022-03-30 at 12:10 +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Jan Kara reported a performance regression in dbench that he
> > > bisected down to commit bad77c375e8d ("xfs: CIL checkpoint
> > > flushes caches unconditionally").
> > > 
> > > Whilst developing the journal flush/fua optimisations this cache was
> > > part of, it appeared to made a significant difference to
> > > performance. However, now that this patchset has settled and all the
> > > correctness issues fixed, there does not appear to be any
> > > significant performance benefit to asynchronous cache flushes.
> > > 
> > > In fact, the opposite is true on some storage types and workloads,
> > > where additional cache flushes that can occur from fsync heavy
> > > workloads have measurable and significant impact on overall
> > > throughput.
> > > 
> > > Local dbench testing shows little difference on dbench runs with
> > > sync vs async cache flushes on either fast or slow SSD storage, and
> > > no difference in streaming concurrent async transaction workloads
> > > like fs-mark.
> > > 
> > > Fast NVME storage.
> > > 
> > > > From `dbench -t 30`, CIL scale:
> > > 
> > > clients         async                   sync
> > >                 BW      Latency         BW      Latency
> > > 1                935.18   0.855          915.64   0.903
> > > 8               2404.51   6.873         2341.77   6.511
> > > 16              3003.42   6.460         2931.57   6.529
> > > 32              3697.23   7.939         3596.28   7.894
> > > 128             7237.43  15.495         7217.74  11.588
> > > 512             5079.24  90.587         5167.08  95.822
> > > 
> > > fsmark, 32 threads, create w/ 64 byte xattr w/32k logbsize
> > > 
> > >         create          chown           unlink
> > > async   1m41s           1m16s           2m03s
> > > sync    1m40s           1m19s           1m54s
> > > 
> > > Slower SATA SSD storage:
> > > 
> > > > From `dbench -t 30`, CIL scale:
> > > 
> > > clients         async                   sync
> > >                 BW      Latency         BW      Latency
> > > 1                 78.59  15.792           83.78  10.729
> > > 8                367.88  92.067          404.63  59.943
> > > 16               564.51  72.524          602.71  76.089
> > > 32               831.66 105.984          870.26 110.482
> > > 128             1659.76 102.969         1624.73  91.356
> > > 512             2135.91 223.054         2603.07 161.160
> > > 
> > > fsmark, 16 threads, create w/32k logbsize
> > > 
> > >         create          unlink
> > > async   5m06s           4m15s
> > > sync    5m00s           4m22s
> > > 
> > > And on Jan's test machine:
> > > 
> > >                    5.18-rc8-vanilla       5.18-rc8-patched
> > > Amean     1        71.22 (   0.00%)       64.94 *   8.81%*
> > > Amean     2        93.03 (   0.00%)       84.80 *   8.85%*
> > > Amean     4       150.54 (   0.00%)      137.51 *   8.66%*
> > > Amean     8       252.53 (   0.00%)      242.24 *   4.08%*
> > > Amean     16      454.13 (   0.00%)      439.08 *   3.31%*
> > > Amean     32      835.24 (   0.00%)      829.74 *   0.66%*
> > > Amean     64     1740.59 (   0.00%)     1686.73 *   3.09%*
> > > 
> > > Performance and cache flush behaviour is restored to pre-regression
> > > levels.
> > > 
> > > As such, we can now consider the async cache flush mechanism an
> > > unnecessary exercise in premature optimisation and hence we can
> > > now remove it and the infrastructure it requires completely.
> > 
> > It turns out this regresses umount latency on DAX filesystems. Sravani
> > reached out to me after noticing that v5.18 takes up to 10 minutes to
> > complete umount. On a whim I guessed this patch and upon revert of
> > commit 919edbadebe1 ("xfs: drop async cache flushes from CIL commits")
> > on top of v5.18 umount time goes back down to v5.17 levels.
> 
> That doesn't change the fact we are issuing cache flushes from the
> log checkpoint code - it just changes how we issue them. We removed
> the explicit blkdev_issue_flush_async() call from the cache path and
> went back to the old way of doing things (attaching it directly to
> the first IO of a journal checkpoint) when it became clear the async
> flush was causing performance regressions on storage with really
> slow cache flush semantics by causing too many extra cache flushes
> to be issued.
> 
> As I just captured from /dev/pmem0 on 5.19-rc2 when a fsync was
> issued after a 1MB write:
> 
> 259,1    1      513    41.695930264  4615  Q FWFSM 8388688 + 8 [xfs_io]
> 259,1    1      514    41.695934668  4615  C FWFSM 8388688 + 8 [0]
> 
> You can see that the journal IO was issued as:
> 
> 	REQ_PREFLUSH | REQ_OP_WRITE | REQ_FUA | REQ_SYNC | REQ_META
> 
> As it was a single IO journal checkpoint - that's where the REQ_FUA
> came from.
> 
> So if we create 5000 zero length files instead to create a large,
> multi-IO checkpoint, we get this pattern from the journal:
> 
> 259,1    2      103    90.614842783   101  Q FWSM 8388720 + 64 [kworker/u33:1]
> 259,1    2      104    90.614928169   101  C FWSM 8388720 + 64 [0]
> 259,1    2      105    90.615012360   101  Q WSM 8388784 + 64 [kworker/u33:1]
> 259,1    2      106    90.615028941   101  C WSM 8388784 + 64 [0]
> 259,1    2      107    90.615102783   101  Q WSM 8388848 + 64 [kworker/u33:1]
> 259,1    2      108    90.615118677   101  C WSM 8388848 + 64 [0]
> .....
> 259,1    2      211    90.619375834   101  Q WSM 8392176 + 64 [kworker/u33:1]
> 259,1    2      212    90.619391042   101  C WSM 8392176 + 64 [0]
> 259,1    2      213    90.619415946   134  Q FWFSM 8392240 + 16 [kworker/2:1]
> 259,1    2      214    90.619420274   134  C FWFSM 8392240 + 16 [0]
> 
> And you can see that the first IO has REQ_PREFLUSH set, and the last
> IO (the commit record) has both REQ_PREFLUSH and REQ_FUA set.
> 
> IOWs, the filesystem is issuing IO with exactly the semantics it
> requires from the block device, and expecting the block device to b
> flushing caches entirely on the first IO of a checkpoint.
> 
> > Perf confirms that all of that CPU time is being spent in
> > arch_wb_cache_pmem(). It likely means that rather than amortizing that
> > same latency periodically throughout the workload run, it is all being
> > delayed until umount.
> 
> For completeness, this is what the umount IO looks like:
> 
> 259,1    5        1    98.680129260 10166  Q FWFSM 8392256 + 8 [umount]
> 259,1    5        2    98.680135797 10166  C FWFSM 8392256 + 8 [0]
> 259,1    3      429    98.680341063  4977  Q  WM 0 + 8 [xfsaild/pmem0]
> 259,1    3      430    98.680362599  4977  C  WM 0 + 8 [0]
> 259,1    5        3    98.680616201 10166  Q FWFSM 8392264 + 8 [umount]
> 259,1    5        4    98.680619218 10166  C FWFSM 8392264 + 8 [0]
> 259,1    3      431    98.680767121  4977  Q  WM 0 + 8 [xfsaild/pmem0]
> 259,1    3      432    98.680770938  4977  C  WM 0 + 8 [0]
> 259,1    5        5    98.680836733 10166  Q FWFSM 8392272 + 8 [umount]
> 259,1    5        6    98.680839560 10166  C FWFSM 8392272 + 8 [0]
> 259,1   12        7    98.683546633 10166  Q FWS [umount]
> 259,1   12        8    98.683551424 10166  C FWS 0 [0]
> 
> You can see 3 journal writes there with REQ_PREFLUSH set before XFS
> calls blkdev_issue_flush() (FWS of zero bytes) in xfs_free_buftarg()
> just before tearing down DAX state and freeing the buftarg.
> 
> Which one of these cache flush operations is taking 10 minutes to
> complete? That will tell us a lot more about what is going on...
> 
> > I assume this latency would also show up without DAX if page-cache is
> > now allowed to continue growing, or is there some other signal that
> > triggers async flushes in that case?
> 
> I think you've misunderstood what the "async" part of "async cache
> flushes" actually did. It was an internal journal write optimisation
> introduced in bad77c375e8d ("xfs: CIL checkpoint flushes caches
> unconditionally") in 5.14 that didn't work out and was reverted in
> 5.18. It didn't change the cache flushing semantics of the journal,
> just reverted to the same REQ_PREFLUSH behaviour we had for a decade
> leading up the the "async flush" change in the 5.14 kernel.

Oh, it would be interesting to see if pre-5.14 also has this behavior.

> To me, this smells of a pmem block device cache flush issue, not a
> filesystem problem...

...or at least an fs/dax.c problem. Sravani grabbed the call stack:

   100.00%     0.00%             0  [kernel.vmlinux]  [k] ret_from_fork                -      -            
            |
            ---ret_from_fork
               kthread
               worker_thread
               process_one_work
               wb_workfn
               wb_writeback
               writeback_sb_inodes
               __writeback_single_inode
               do_writepages
               dax_writeback_mapping_range
               |          
                --99.71%--arch_wb_cache_pmem

One experiment I want to see is turn off DAX and see what the unmount
performance is when this is targeting page cache for mmap I/O. My
suspicion is that at some point dirty-page pressure triggers writeback
that just does not happen in the DAX case.

The aspect of this that puts it more in the driver problem space is that
cache flushes on block devices are effectively "wbinvd" events. I.e.
they flush the entire device cache all at once. Cache flushes on pmem
avoid the wbinvd instruction and instead do line by line "clflush /
clwb" instructions (on x86). So this might a case of where tracking
dirty pages to avoid wbinvd events has crossed a threshold and it would
be better to do a bulk "writeback" with a wbinvd.
