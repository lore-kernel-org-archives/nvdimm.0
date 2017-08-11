Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DCAA209589EF
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 19:10:04 -0700 (PDT)
Date: Thu, 10 Aug 2017 20:12:21 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH] ndctl: New structure definitions.
Message-ID: <20170811021221.GA19197@anatevka.americas.hpqcorp.net>
References: <20170811000000.18672-1-jerry.hoemann@hpe.com>
 <CAPcyv4grN7RXfkxNfXad79FAKJzwrAxit-xXW4J7n22i-s+Dvg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4grN7RXfkxNfXad79FAKJzwrAxit-xXW4J7n22i-s+Dvg@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 10, 2017 at 05:47:10PM -0700, Dan Williams wrote:
> On Thu, Aug 10, 2017 at 5:00 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Add structure definitions newly published/modified in v0.85:
> >
> > https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v85.pdf
> 
> Are there going to be follow-on patches that make use of these
> definitions? I would save this update for when those follow-on patches
> are ready.

There are multiple projects both inside and outside of HPE that need to
make DSM calls.

The DSM ioctl is an interface exported to user applications.  Customers
and vendors can and will use this interface for their own tools and this
use need not result in patches sent back to the ndctl project.


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
