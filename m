Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF2F621A07A92
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 14:31:31 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH v2 4/5] util/json: Add comments around re-checking
 the UTIL_JSON_MEDIA_ERRORS flag
Date: Wed, 3 Oct 2018 21:31:29 +0000
Message-ID: <5df10df5f313f3e80a49aa5e03720a42271cbc98.camel@intel.com>
References: <20181003181506.17682-1-vishal.l.verma@intel.com>
 <20181003181506.17682-4-vishal.l.verma@intel.com>
In-Reply-To: <20181003181506.17682-4-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <88D1D680805845428C63E0D41CBFE370@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-10-03 at 12:15 -0600, Vishal Verma wrote:
> Add comments to clarify that in the various ndctl_*_babdlock_foreach
> loops where we compose the json output, the additional check for
> UTIL_JSON_MEDIA_ERRORS is valid because even if we're not printing
> media errors, we still want the badblock_count to be updated, which
> requires a full badblocks traversal.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...and everything else looks good too in this series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
