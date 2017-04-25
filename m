Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12A3721951C8F
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 15:24:13 -0700 (PDT)
Date: Tue, 25 Apr 2017 16:22:51 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm: fix phys_addr for nvdimm_clear_poison
Message-ID: <20170425222250.GC15722@omniknight.lm.intel.com>
References: <20170425211651.7640-1-toshi.kani@hpe.com>
 <20170425214422.GB15722@omniknight.lm.intel.com>
 <1493156958.26622.8.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493156958.26622.8.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/25, Kani, Toshimitsu wrote:
> On Tue, 2017-04-25 at 15:44 -0600, Vishal Verma wrote:
> > On 04/25, Toshi Kani wrote:
[...]
> >
> > Should we be using nsio->res.start here or nsio->addr ?
> 
> nsio->addr is a virtual address.  We need to pass the physical address
> of this range.

I see - makes sense.
You can add
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
