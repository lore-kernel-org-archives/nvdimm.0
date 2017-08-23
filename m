Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8270021E47D72
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 10:20:57 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v6 6/6] libnvdimm, btt: rework error clearing
Date: Wed, 23 Aug 2017 17:23:15 +0000
Message-ID: <1503508401.2042.174.camel@hpe.com>
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
 <20170822221915.1732-7-vishal.l.verma@intel.com>
In-Reply-To: <20170822221915.1732-7-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <21BE184880A61948AAE2AD1D83B5220F@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2017-08-22 at 16:19 -0600, Vishal Verma wrote:
 :
> +
> +		/* The block had a media error, and needs to be
> cleared */
> +		if (btt_is_badblock(btt, arena, arena-
> >freelist[lane].block)) {
> +			arena->freelist[lane].has_err = 1;
> +			nd_region_release_lane(btt->nd_region,
> lane);
> +
> +			arena_clear_freelist_error(arena, lane);
> +			/* OK to acquire a different lane/free block
> */
> +			goto retry;

I hit an infinite clear loop when DSM Clear Uncorrectable Error
function fails.  Haven't looked into the details, but I suspect this
unconditional retry is the cause of this.

Thanks,
-Toshi


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
