Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 588BA2194D3AE
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 16:37:56 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH v2] libndctl: set errno for routines that don't
 return an error status
Date: Thu, 4 Oct 2018 23:37:49 +0000
Message-ID: <845dd77c812df262775a001f3e679536d609a59d.camel@intel.com>
References: <20181004231736.23756-1-vishal.l.verma@intel.com>
In-Reply-To: <20181004231736.23756-1-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <5E70A4B7954ECB489441E29902D2354D@intel.com>
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

On Thu, 2018-10-04 at 17:17 -0600, Vishal Verma wrote:
> For routines that return a UINT_MAX or UL{L}ONG_MAX, there isn't a
> way
> to get any information as to what went wrong. Set errno in such
> routines
> so that the callers can get some additional context about the error.
> 
> Reported-by: Lukasz Dorau <lukasz.dorau@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
