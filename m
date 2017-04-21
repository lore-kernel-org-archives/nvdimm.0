Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 730FB21A6F107
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 13:51:14 -0700 (PDT)
Date: Fri, 21 Apr 2017 13:50:50 -0700
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] acpi, nfit: fix the memory error check in nfit_handle_mce
Message-ID: <20170421205050.GA17595@intel.com>
References: <20170420221818.23522-1-vishal.l.verma@intel.com>
 <CAPcyv4ijU2V-4WOPysL12ByOovAXDO=Mci1D4wNDFqxRjdvT2w@mail.gmail.com>
 <1492804517.2738.25.camel@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F6127653B@ORSMSX114.amr.corp.intel.com>
 <20170421203551.GC10645@omniknight.lm.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170421203551.GC10645@omniknight.lm.intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 21, 2017 at 02:35:51PM -0600, Vishal Verma wrote:
> On 04/21, Luck, Tony wrote:
> > Needs extra parentheses to make it right. Vishal, sorry I led you astray.
> > 
> > 	if (!((mce->status & 0xef80) == BIT(7)))
> 
> Is this still right though? Anything AND'ed with 0xef80 will never equal
> BIT(7) which is simply 01000000 binary (the lowest byte of the left hand
> side is '0')

I think so ... here it is in binary

ef80 = 1110 1111 1000 0000
BIT7 = 0000 0000 1000 0000

so the "&" will zap bits {6:0} and bit {12}  [and everything not part
of the MCACOD field].

If mce->status had some bit above BIT(7) set, it won't be zapped, so we
won't match the exact value BIT(7).

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
